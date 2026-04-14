Business Model Knowledge Graph for Software Ventures

A formal ontology and labeled property graph for multi-framework business model representation, grounded in Basic Formal Ontology (BFO) and implemented in Neo4j. Companion repository for the paper:

> **"Multi-framework business model representation: a knowledge graph approach on a real case software venture"**  
> Alexandra Negoescu, Lucian-Mihai Mocanu  
> Constantin Belea Doctoral School, University of Craiova  
> FedCSIS 2026

---

## What This Repository Contains

| Folder | Contents |
|---|---|
| `schema/` | Entity type definitions, relationship catalogue, BFO mappings |
| `constraints/` | All 18 hard constraints and 23 soft constraints as runnable Cypher |
| `graph/` | HashiCorp instantiation script and deliberately invalid test instance |
| `queries/` | Canvas generation, competency questions CQ1–CQ19, gap detection, temporal queries |
| `indexes/` | Index creation scripts — applied **after** base graph setup |
| `scalability/` | Synthetic graph generator and benchmark methodology notes |
| `evaluation/` | Framework coverage mapping (Table A-XIII) with traversal path notes |

---

## Requirements

- **Neo4j** 5.24 or later (Community or Enterprise edition)
- Neo4j Desktop, Neo4j Aura, or a self-hosted instance
- Cypher shell or Neo4j Browser for running scripts
- No external plugins or APOC procedures required

---

## Quickstart: Reproducing the Paper Results

Follow these steps **in order**. Indexes are added as a separate step so you can observe the unindexed baseline reported in Table IV before applying them.

---

### Step 1 — Create a new database

In Neo4j Desktop, create a new project and a blank local database (Neo4j 5.24). Start the database and open Neo4j Browser at `http://localhost:7474`.

---

### Step 2 — Apply the schema indexes (baseline: no indexes)

At this stage, **do not run the index script yet**. The base graph is populated without indexes so that the unindexed query performance baseline in Table IV is reproducible.

---

### Step 3 — Load the HashiCorp graph

Run the instantiation script in twelve layers, in the order shown. Each layer is a separate file; paste the contents into Neo4j Browser or run via Cypher shell:

```bash
# If using Cypher shell
cypher-shell -u neo4j -p <your-password> -f graph/01_foundation.cypher
cypher-shell -u neo4j -p <your-password> -f graph/02_stakeholders.cypher
cypher-shell -u neo4j -p <your-password> -f graph/03_market.cypher
cypher-shell -u neo4j -p <your-password> -f graph/04_value.cypher
cypher-shell -u neo4j -p <your-password> -f graph/05_channels.cypher
cypher-shell -u neo4j -p <your-password> -f graph/06_metrics.cypher
cypher-shell -u neo4j -p <your-password> -f graph/07_intelligence.cypher
cypher-shell -u neo4j -p <your-password> -f graph/08_compliance.cypher
cypher-shell -u neo4j -p <your-password> -f graph/09_open_innovation.cypher
cypher-shell -u neo4j -p <your-password> -f graph/10_financial.cypher
cypher-shell -u neo4j -p <your-password> -f graph/11_meta_framework.cypher
cypher-shell -u neo4j -p <your-password> -f graph/12_evolves_to.cypher
```

Verify the graph loaded correctly:

```cypher
MATCH (n) RETURN labels(n)[1] AS type, count(n) AS count
ORDER BY count DESC;
```

Expected result: 162 nodes across 11 domain types, matching Table III in the paper.

---

### Step 4 — Run the constraint engine (no indexes)

```bash
cypher-shell -u neo4j -p <your-password> -f constraints/constraint_engine.cypher
```

On the valid HashiCorp instance all 18 hard constraints should return no violations. Note the database hit counts from the query profile — these are the **unindexed** baselines for Table IV.

To profile a specific constraint query in Neo4j Browser, prefix with `PROFILE`:

```cypher
PROFILE MATCH (p:Product)
WHERE NOT (p)-[:SERVES_SEGMENT]->(:CustomerSegment)
AND NOT (p)-[:VARIANT_OF]->()
RETURN p.name AS entity_name, 'HC-01' AS constraint_id;
```

---

### Step 5 — Apply indexes

Once you have recorded the unindexed baseline, apply all composite indexes:

```bash
cypher-shell -u neo4j -p <your-password> -f indexes/index_strategy.cypher
```

Wait for index population to complete:

```cypher
SHOW INDEXES YIELD name, state, populationPercent
WHERE state <> 'ONLINE'
RETURN name, state, populationPercent;
```

Proceed when the query returns no rows (all indexes ONLINE).

---

### Step 6 — Re-run constraint engine (with indexes)

Run the constraint engine again and compare database hits against Step 4. The key result to reproduce is HC-01: database hits should drop from a full label scan to approximately 5 hits via NodeIndexSeek when the assumption index is active.

---

### Step 7 — Reproduce the SC-16 fork risk finding

This is the most significant empirical result in the paper. Run:

```bash
cypher-shell -u neo4j -p <your-password> -f constraints/soft_constraints.cypher
```

SC-16 should fire on Terraform OSS (fork_risk_score = 8, threshold = 7) and auto-generate a community fork risk node. This result anticipates the OpenTofu fork of October 2023 from data reflecting the state of the graph in early 2023.

Verify the auto-generated node:

```cypher
MATCH (r:Risk {category: 'community_fork'})
RETURN r.description, r.source_constraint, r.generated_at;
```

---

### Step 8 — Run competency questions

```bash
cypher-shell -u neo4j -p <your-password> -f queries/competency_questions.cypher
```

CQ1–CQ19 are answerable from the graph. CQ20–CQ24 are boundary questions documented in the file with explanations of why they fall outside schema scope.

---

### Step 9 — Generate a canvas

To generate the Lean Canvas for Terraform from the graph:

```bash
cypher-shell -u neo4j -p <your-password> -f queries/canvas_generation.cypher
```

Edit the `framework_name` and `product_name` parameters at the top of the file to switch frameworks or products.

---

### Step 10 — Test the invalid instance

Load the deliberately violated graph instance to verify that all 18 hard constraints fire correctly:

```bash
# Use a separate database for this — do not run against the valid HashiCorp instance
cypher-shell -u neo4j -p <your-password> -f graph/invalid_instance.cypher
cypher-shell -u neo4j -p <your-password> -f constraints/constraint_engine.cypher
```

Expected result: 18 violations returned, one per constraint, each with entity_name, constraint_id, severity, violation_description, and remediation_hint.

---

### Step 11 — Scalability benchmarks

The synthetic generator builds on top of the base HashiCorp graph. Run against the same database used in Steps 3–6:

```bash
cypher-shell -u neo4j -p <your-password> \
  -f scalability/generator.cypher \
  --param 'target_total_nodes => 512'
```

Re-run with 1024 and 5000. For each tier, profile HC-01 both unscoped and scoped:

```cypher
-- Unscoped (full graph scan)
PROFILE MATCH (p:Product)
WHERE NOT (p)-[:SERVES_SEGMENT]->(:CustomerSegment)
AND NOT (p)-[:VARIANT_OF]->()
RETURN count(p);

-- Scoped to HashiCorp subgraph only
PROFILE MATCH (p:Product)
WHERE p.organization = 'HashiCorp'
AND NOT (p)-[:SERVES_SEGMENT]->(:CustomerSegment)
AND NOT (p)-[:VARIANT_OF]->()
RETURN count(p);
```

The 136-fold reduction in database hits at 5,000 nodes (5,040 unscoped vs. 37 scoped) reported in Table IV should be reproducible.

---

## Repository Notes

**Data provenance:** The HashiCorp graph is constructed from publicly available sources including the HashiCorp S-1 filing, GitHub repository metrics, press releases, and analyst reports covering the 2020–2023 period. It represents the best available public reconstruction of HashiCorp's business model and not internal company data. Data gathering was assisted by Claude (Anthropic, claude-sonnet-4-6) as a synthesis tool; all values were verified by the authors against primary sources.

**Synthetic data:** The scalability generator produces structurally valid but semantically meaningless nodes. It is provided solely for benchmark reproduction and should not be interpreted as business model data.

**Schema vs. instance counts:** The ontology defines approximately 60 entity types and over 70 typed relationship categories at schema level. The HashiCorp instance contains 162 nodes and 234 relationships — these are instance-level counts, not schema-level counts.

---

## Citation

If you use this repository in your research, please cite the paper:

```bibtex
@inproceedings{negoescu2026knowledge,
  title     = {Multi-framework business model representation: a knowledge graph approach on a real case software venture},
  author    = {Negoescu, Alexandra and Mocanu, Lucian-Mihai},
  booktitle = {Proceedings of the 21st Conference on Computer Science
               and Intelligence Systems (FedCSIS 2026)},
  year      = {2026},
  address   = {Riga, Latvia},
  publisher = {IEEE}
}
```

---

## License

The schema definitions, Cypher scripts, and query files in this repository are released under the MIT License. See `LICENSE` for details.

The HashiCorp case study data is reconstructed from public sources for academic research purposes only and is not affiliated with or endorsed by HashiCorp, Inc.
