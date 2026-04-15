# Business Model Knowledge Graph for Software Ventures

A formal ontology and labeled property graph for multi-framework business model
representation, grounded in Basic Formal Ontology (BFO) and implemented in Neo4j.
Companion repository for the paper:

> **"Multi-framework business model representation: a knowledge graph approach on a real case software venture"**
> Alexandra Negoescu, Lucian-Mihai Mocanu
> Constantin Belea Doctoral School, University of Craiova
> FedCSIS 2026

---

## What This Repository Contains

| File | Contents |
|---|---|
| `cypher` | Complete HashiCorp graph instantiation script (12 layers in a single file) |
| `constraints` | Neo4j uniqueness constraints — run before loading the graph |
| `constraints_validation` | Representative PROFILE queries for all constraint and analytical categories reported in Table IV, plus a self-contained before/after index effectiveness test |
| `indexes` | Composite index definitions — applied **after** the base graph is loaded and the unindexed baseline is recorded |
| `cypher_synthetic_scale-up` | Synthetic graph generator for scalability benchmarks (three tiers: ~500, ~1,000, ~5,000 total nodes) |
| `LICENSE` | MIT License |

---

## Requirements

- **Neo4j 5.24** or later (Community or Enterprise edition)
- Neo4j Desktop, Neo4j Aura, or a self-hosted instance
- Neo4j Browser or Cypher shell for running scripts
- No external plugins or APOC procedures required

---

## Quickstart: Reproducing the Paper Results

Follow these steps **in order**. Indexes are applied as a separate step so you
can record the unindexed query performance baseline reported in Table IV before
enabling them.

---

### Step 1 — Create a new database

In Neo4j Desktop, create a new project and a blank local database (Neo4j 5.24).
Start the database and open Neo4j Browser at `http://localhost:7474`.

---

### Step 2 — Apply uniqueness constraints

Run the uniqueness constraints first. These are separate from the performance
indexes and must be in place before data is loaded:

```bash
cypher-shell -u neo4j -p <your-password> -f constraints
```

Or paste the contents of `constraints` directly into Neo4j Browser.

---

### Step 3 — Load the HashiCorp graph

The full instantiation script is in the file `cypher`. It is structured in twelve
commented layers matching the order described in Section IV of the paper.
Paste the contents into Neo4j Browser or run via Cypher shell:

```bash
cypher-shell -u neo4j -p <your-password> -f cypher
```

Verify the graph loaded correctly:

```cypher
MATCH (n) RETURN labels(n)[1] AS type, count(n) AS count
ORDER BY count DESC;
```

Expected result: **162 nodes** across 11 domain types, matching Table III in the paper.

---

### Step 4 — Profile constraint and analytical queries (no indexes)

Open `constraints_validation` in Neo4j Browser and run each `PROFILE` query
individually. Record the database hit counts — these are the **unindexed baselines**
for Table IV.

The file covers the following query categories in order:

| Query | Table IV row | Hops |
|---|---|---|
| HC-01: Product without segment | Constraint Validation | 1 |
| HC-12: Invalid assumption type | Constraint Validation | 1 |
| HC-17: IP jurisdiction gap | Constraint Validation | 3 |
| SC-16: Fork risk auto-trigger | Constraint Validation | 2 |
| Lean Canvas generation | Canvas & Analytical | 2–3 |
| Cross-framework consistency | Canvas & Analytical | 4 |
| Gap detection batch | Canvas & Analytical | 1–2 |
| CONTINGENT_ON traversal | Canvas & Analytical | 2 |
| Assumption filter (no index) | Index Effectiveness | 1 |

**Do not run the index creation block at the bottom of the file yet** — that block
is part of the self-contained before/after test described in Step 6.

---

### Step 5 — Apply composite indexes

Once you have recorded all unindexed baselines, apply the full index suite:

```bash
cypher-shell -u neo4j -p <your-password> -f indexes
```

Wait for index population to complete before proceeding:

```cypher
SHOW INDEXES YIELD name, state, populationPercent
WHERE state <> 'ONLINE'
RETURN name, state, populationPercent;
```

Proceed when the query returns no rows (all indexes ONLINE).

---

### Step 6 — Re-profile queries with indexes active

Re-run the same `PROFILE` queries from Step 4 and compare database hits.
The most significant result to verify is the assumption filter:
database hits should drop from **35 to 5** (a sevenfold reduction) as the
execution plan transitions from `NodeByLabelScan` to `NodeIndexSeek`.

The bottom section of `constraints_validation` contains a self-contained
index effectiveness test that recreates this measurement in isolation:

1. Run the `PROFILE` query on lines 52–53 — this is the **no-index** baseline
2. Run `CREATE INDEX` on line 56 (add `IF NOT EXISTS` if the index already exists from Step 5)
3. Run `CALL db.awaitIndexes(30)` on line 59
4. Run the `PROFILE` query on lines 61–62 — this is the **indexed** result

**Note:** Run this block only once. If indexes are already active from Step 5,
skip straight to step 4 of this sequence.

---

### Step 7 — Reproduce the SC-16 fork risk finding

This is the most significant empirical result in the paper. In Neo4j Browser, run:

```cypher
MATCH (p:Product)-[:HAS_COMMUNITY_HEALTH]->(h:CommunityHealthMetric)
WHERE h.fork_risk_score > 7
RETURN p.name AS product, h.fork_risk_score AS fork_risk,
       'SC-16: auto-generate community fork risk node' AS action;
```

Expected result: Terraform OSS returns with `fork_risk_score = 8`, exceeding
the SC-16 threshold of 7. This result reflects the state of the graph in early
2023, several months before the OpenTofu fork materialised in October 2023.

The SC-16 constraint would then trigger creation of a community fork risk node.
To simulate this auto-generation manually:

```cypher
MATCH (p:Product)-[:HAS_COMMUNITY_HEALTH]->(h:CommunityHealthMetric)
WHERE h.fork_risk_score > 7
MERGE (r:Risk {category: 'community_fork', source_constraint: 'SC-16'})
SET r.description = 'Auto-generated: fork risk score ' + toString(h.fork_risk_score) + ' exceeds threshold',
    r.generated_at = date()
CREATE (p)-[:HAS_RISK]->(r);
```

---

### Step 8 — Run temporal evolution and cross-framework queries

The following queries are included in `constraints_validation` and can also be
run directly in Neo4j Browser.

**Temporal evolution** — reconstructs the MPL-2.0 to BSL-1.1 license transition:

```cypher
MATCH (old)-[e:EVOLVES_TO]->(new)
RETURN labels(old)[0] AS entity_type,
       old.name AS from_state,
       new.name AS to_state,
       e._change_reason AS reason,
       e._valid_from AS transition_date
ORDER BY e._valid_from;
```

**Cross-framework consistency** — identifies segments with no value proposition
resolving their stakeholder pain points:

```cypher
MATCH (cs:CustomerSegment)<-[:SERVES_SEGMENT]-(p:Product)
WHERE NOT EXISTS {
  MATCH (cs)<-[:PROPOSES_VALUE_TO]-(vp:ValueProposition)
        -[:RESOLVES]->(pp:PainPoint)
        <-[:EXPERIENCES_PAIN]-(st:Stakeholder)
        <-[:HAS_STAKEHOLDER]-(cs)
}
RETURN cs.name AS orphaned_segment,
       'No VP resolves segment pains' AS inconsistency;
```

Expected result: no rows returned, confirming all four customer segments are covered.

---

### Step 9 — Scalability benchmarks

The synthetic generator in `cypher_synthetic_scale-up` builds on top of the base
HashiCorp graph and must be run against the same database used in Steps 3–7.

The file contains three sequential tiers. Run them one at a time in Neo4j Browser
or Cypher shell, profiling HC-01 between each tier:

**Tier 1 — approximately 500 total nodes:**
Run the first `UNWIND` block (range 1–100).

**Tier 2 — approximately 1,000 total nodes:**
Run the second `UNWIND` block (range 101–250) against the same database.

**Tier 3 — approximately 5,000 total nodes:**
Run the third `UNWIND` block (range 251–1250) against the same database.

After each tier, profile HC-01 in two modes:

```cypher
-- Unscoped: visits all Product nodes including synthetic ones
PROFILE MATCH (p:Product)
WHERE NOT (p)-[:SERVES_SEGMENT]->(:CustomerSegment)
AND NOT (p)-[:VARIANT_OF]->()
RETURN count(p);

-- Scoped: visits only the HashiCorp product subgraph
PROFILE MATCH (p:Product)
WHERE p.name IN [
  'Terraform', 'Terraform OSS', 'Terraform Cloud',
  'Vault', 'Vault OSS', 'Vault Enterprise',
  'Consul', 'Nomad'
]
AND NOT (p)-[:SERVES_SEGMENT]->(:CustomerSegment)
AND NOT (p)-[:VARIANT_OF]->()
RETURN count(p);
```

The scoped query should return approximately 37 database hits regardless of total
graph size, compared to hits that scale linearly with Product node count in the
unscoped version — the result reported in Table IV of the paper.

To return to the base HashiCorp graph after benchmarking, run the cleanup query
at the bottom of `cypher_synthetic_scale-up` (commented out by default).

---

## Repository Notes

**Data provenance:** The HashiCorp graph is constructed from publicly available
sources including the HashiCorp S-1 filing, GitHub repository metrics, press
releases, and analyst reports covering the 2020–2023 period. It represents the
best available public reconstruction of HashiCorp's business model and not
internal company data. Data gathering was assisted by Claude (Anthropic,
claude-sonnet-4-6) as a synthesis tool; all values were verified by the authors
against primary sources.

**Synthetic data:** The scalability generator produces structurally valid but
semantically meaningless nodes that satisfy HC-12 and HC-13. It is provided
solely for benchmark reproduction and should not be interpreted as business
model data.

**Schema vs. instance counts:** The ontology defines approximately 60 entity
types and over 70 typed relationship categories at schema level. The HashiCorp
instance contains 162 nodes and 234 relationships — these are instance-level
counts, not schema-level counts.

**What is not included in this release:** The full 18-constraint batch engine
as a single composite query, the deliberately invalid test instance, and the
complete competency question suite (CQ1–CQ19) are not included in this
repository release. Representative queries covering all categories reported in
Table IV are available in `constraints_validation`.

---

## Citation

If you use this repository in your research, please cite the paper:

```bibtex
@inproceedings{negoescu2026bm,
  title     = {Multi-framework business model representation: a knowledge graph
               approach on a real case software venture},
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

The schema definitions, Cypher scripts, and query files in this repository are
released under the MIT License. See `LICENSE` for details.

The HashiCorp case study data is reconstructed from public sources for academic
research purposes only and is not affiliated with or endorsed by HashiCorp, Inc.
(now IBM).
