// ============================================================
// HashiCorp Knowledge Graph ‚a Neo4j Cypher Implementation
// Snapshot: Q1 2023 (pre-IBM acquisition, post-Series E)
// Schema version: Dynamic Business Model Innovation Framework
// ============================================================


//  LAYER 1 - FOUNDATION                             

// ORGANIZATION 
CREATE (hashi:Organization:IndependentContinuant {
  name: 'HashiCorp',
  type: 'commercial_oss_vendor',
  stage: 'growth',
  founding_date: date('2012-10-01'),
  mission: 'Consistent workflows to provision, secure, connect, and run any infrastructure for any application',
  vision: 'Enable infrastructure automation for every organization regardless of cloud provider',
  headcount: 2200,
  _version: 3,
  _valid_from: date('2020-01-01'),
  _valid_to: date('2023-08-09')
});

// TEAMS 
CREATE (engTeam:Team:IndependentContinuant {
  name: 'Engineering',
  function: 'product_development',
  headcount: 800,
  cost_center: 'R&D',
  loaded_monthly_cost: 12000000
});
CREATE (salesTeam:Team:IndependentContinuant {
  name: 'Sales & Marketing',
  function: 'revenue_generation',
  headcount: 400,
  cost_center: 'S&M',
  loaded_monthly_cost: 6000000
});
CREATE (devrelTeam:Team:IndependentContinuant {
  name: 'Developer Relations',
  function: 'community_growth',
  headcount: 80,
  cost_center: 'S&M',
  loaded_monthly_cost: 1200000
});
CREATE (gaTeam:Team:IndependentContinuant {
  name: 'G&A',
  function: 'general_administration',
  headcount: 200,
  cost_center: 'G&A',
  loaded_monthly_cost: 3000000
});
MATCH (o:Organization {name:'HashiCorp'}), (t:Team)
WHERE t.name IN ['Engineering','Sales & Marketing','Developer Relations','G&A']
CREATE (o)-[:CONTAINS_TEAM]->(t);

// LICENSES 
CREATE (mpl2:License:GenericallydependentContinuant {
  spdx_id: 'MPL-2.0',
  type: 'weak_copyleft',
  osi_approved: true,
  compatibility_set: ['Apache-2.0','MIT','GPL-2.0','GPL-3.0']
});
CREATE (bsl11:License:GenericallydependentContinuant {
  spdx_id: 'BSL-1.1',
  type: 'source_available',
  osi_approved: false,
  compatibility_set: [],
  notes: 'Converts to MPL-2.0 after 4 years; prohibits competitive managed-service use'
});
CREATE (proprietary:License:GenericallydependentContinuant {
  spdx_id: 'Proprietary-HCL',
  type: 'proprietary',
  osi_approved: false,
  compatibility_set: []
});

//TECH STACK 
CREATE (goStack:TechStack:IndependentContinuant {
  name: 'Go',
  layer: 'application',
  maturity: 'stable',
  vendor_lock_risk: 'low'
});
CREATE (hclStack:TechStack:IndependentContinuant {
  name: 'HCL / Terraform Core',
  layer: 'dsl',
  maturity: 'stable',
  vendor_lock_risk: 'low'
});
CREATE (grpcStack:TechStack:IndependentContinuant {
  name: 'gRPC / Protocol Buffers',
  layer: 'communication',
  maturity: 'stable',
  vendor_lock_risk: 'low'
});

//ASSETS 
CREATE (hclIP:IPAsset:GenericallydependentContinuant {
  name: 'HCL Specification',
  type: 'copyright',
  status: 'active',
  jurisdiction: ['US','EU','GLOBAL'],
  filing_date: date('2014-09-01'),
  description: 'HashiCorp Configuration Language specification and implementation'
});
CREATE (sentinelIP:IPAsset:GenericallydependentContinuant {
  name: 'Sentinel Policy Engine',
  type: 'copyright',
  status: 'active',
  jurisdiction: ['US','EU'],
  description: 'Sentinel Policy-as-Code engine ‚ enterprise only'
});
CREATE (vaultTransitIP:IPAsset:GenericallydependentContinuant {
  name: 'Vault Transit Encryption',
  type: 'patent_pending',
  status: 'active',
  jurisdiction: ['US'],
  description: 'Vault Transit encryption-as-a-service methodology'
});
// IPAsset‚ License direction
MATCH (ip:IPAsset {name:'HCL Specification'}), (l:License {spdx_id:'MPL-2.0'})
CREATE (ip)-[:GOVERNED_BY_LICENSE]->(l);
MATCH (ip:IPAsset {name:'Sentinel Policy Engine'}), (l:License {spdx_id:'Proprietary-HCL'})
CREATE (ip)-[:GOVERNED_BY_LICENSE]->(l);
MATCH (ip:IPAsset {name:'Vault Transit Encryption'}), (l:License {spdx_id:'Proprietary-HCL'})
CREATE (ip)-[:GOVERNED_BY_LICENSE]->(l);

//READINESS LEVELS 
CREATE (tfTRL:ReadinessLevel:DependentContinuant {
  framework: 'TRL', level: 8,
  assessment_date: date('2022-06-01'),
  evidence: 'Production deployments at >80% of Fortune 500; 100M+ downloads',
  assessor: 'Internal Product Board'
});
CREATE (vaultTRL:ReadinessLevel:DependentContinuant {
  framework: 'TRL', level: 8,
  assessment_date: date('2022-06-01'),
  evidence: 'FedRAMP authorization in progress; banking and healthcare sector deployments'
});
CREATE (consulTRL:ReadinessLevel:DependentContinuant {
  framework: 'TRL', level: 7,
  assessment_date: date('2022-06-01'),
  evidence: 'Production deployments; active enterprise customer base'
});

// LAYER 2 - PRODUCTS (parent + variants)                  
// Parent products (abstract concept nodes)
CREATE (terraformP:Product:IndependentContinuant {
  name: 'Terraform',
  type: 'infrastructure_automation',
  version: '1.4', lifecycle_stage: 'growth',
  USP: 'Provision any infrastructure with one consistent workflow',
  deployment_model: 'hybrid',
  _version: 4, _valid_from: date('2020-01-01')
});
CREATE (vaultP:Product:IndependentContinuant {
  name: 'Vault',
  type: 'secrets_management',
  version: '1.13', lifecycle_stage: 'growth',
  USP: 'Centralize secrets and protect sensitive data across distributed infrastructure',
  deployment_model: 'hybrid',
  _version: 3, _valid_from: date('2020-01-01')
});
CREATE (consulP:Product:IndependentContinuant {
  name: 'Consul',
  type: 'service_networking',
  version: '1.15', lifecycle_stage: 'growth',
  USP: 'Automate network configurations and service discovery across any cloud',
  deployment_model: 'hybrid',
  _version: 2, _valid_from: date('2020-01-01')
});
CREATE (nomadP:Product:IndependentContinuant {
  name: 'Nomad',
  type: 'workload_orchestration',
  version: '1.5', lifecycle_stage: 'maturity',
  USP: 'Simple and flexible workload orchestrator for any application on any infrastructure',
  deployment_model: 'self_hosted',
  _version: 2, _valid_from: date('2020-01-01')
});

// Variant products
CREATE (tfOSS:Product:IndependentContinuant {
  name: 'Terraform OSS',
  type: 'infrastructure_automation',
  version: '1.4', lifecycle_stage: 'growth',
  USP: 'Open source IaC for any cloud provider',
  deployment_model: 'self_hosted', oss: true
});
CREATE (tfCloud:Product:IndependentContinuant {
  name: 'Terraform Cloud',
  type: 'infrastructure_automation_saas',
  version: 'cloud', lifecycle_stage: 'growth',
  USP: 'Managed Terraform with collaboration, governance, and policy enforcement',
  deployment_model: 'saas'
});
CREATE (vaultOSS:Product:IndependentContinuant {
  name: 'Vault OSS',
  type: 'secrets_management',
  lifecycle_stage: 'growth',
  deployment_model: 'self_hosted', oss: true
});
CREATE (vaultEnt:Product:IndependentContinuant {
  name: 'Vault Enterprise',
  type: 'secrets_management',
  lifecycle_stage: 'growth',
  deployment_model: 'self_hosted'
});

MATCH (oss:Product {name:'Terraform OSS'}), (p:Product {name:'Terraform'})
  CREATE (oss)-[:VARIANT_OF]->(p);
MATCH (c:Product {name:'Terraform Cloud'}), (p:Product {name:'Terraform'})
  CREATE (c)-[:VARIANT_OF]->(p);
MATCH (oss:Product {name:'Vault OSS'}), (p:Product {name:'Vault'})
  CREATE (oss)-[:VARIANT_OF]->(p);
MATCH (e:Product {name:'Vault Enterprise'}), (p:Product {name:'Vault'})
  CREATE (e)-[:VARIANT_OF]->(p);

// Organization OWNS_PRODUCT (parent nodes only ‚variants inherit via VARIANT_OF)
MATCH (o:Organization {name:'HashiCorp'}), (p:Product)
WHERE p.name IN ['Terraform','Vault','Consul','Nomad']
CREATE (o)-[:OWNS_PRODUCT]->(p);

// Licenses on variants
MATCH (p:Product {name:'Terraform OSS'}), (l:License {spdx_id:'MPL-2.0'}) CREATE (p)-[:LICENSED_UNDER]->(l);
MATCH (p:Product {name:'Terraform Cloud'}), (l:License {spdx_id:'Proprietary-HCL'}) CREATE (p)-[:LICENSED_UNDER]->(l);
MATCH (p:Product {name:'Vault OSS'}), (l:License {spdx_id:'MPL-2.0'}) CREATE (p)-[:LICENSED_UNDER]->(l);
MATCH (p:Product {name:'Vault Enterprise'}), (l:License {spdx_id:'Proprietary-HCL'}) CREATE (p)-[:LICENSED_UNDER]->(l);
MATCH (p:Product {name:'Consul'}), (l:License {spdx_id:'MPL-2.0'}) CREATE (p)-[:LICENSED_UNDER]->(l);
MATCH (p:Product {name:'Nomad'}), (l:License {spdx_id:'MPL-2.0'}) CREATE (p)-[:LICENSED_UNDER]->(l);

// Dual licensing nodes on parent products (HC-11 checked here, not on variants)
CREATE (tfDual:DualLicensing:GenericallydependentContinuant {
  community_license_spdx: 'MPL-2.0',
  commercial_license_terms: 'HashiCorp Enterprise License Agreement',
  boundary_definition: 'Sentinel, audit logging, HSM integration, replication are Enterprise only features',
  fee_structure: 'Annual subscription per node or cluster'
});
CREATE (vaultDual:DualLicensing:GenericallydependentContinuant {
  community_license_spdx: 'MPL-2.0',
  commercial_license_terms: 'HashiCorp Enterprise License Agreement',
  boundary_definition: 'Namespaces, DR replication, MFA enforcement, HSM sealing are Enterprise only',
  fee_structure: 'Annual subscription per cluster'
});
MATCH (p:Product {name:'Terraform'}), (d:DualLicensing {community_license_spdx:'MPL-2.0'}) WHERE d.boundary_definition CONTAINS 'Sentinel' CREATE (p)-[:HAS_DUAL_LICENSE]->(d);
MATCH (p:Product {name:'Vault'}), (d:DualLicensing {community_license_spdx:'MPL-2.0'}) WHERE d.boundary_definition CONTAINS 'Namespaces' CREATE (p)-[:HAS_DUAL_LICENSE]->(d);

// IP asset product links
MATCH (p:Product {name:'Terraform'}), (ip:IPAsset) WHERE ip.name IN ['HCL Specification','Sentinel Policy Engine'] CREATE (p)-[:HAS_IP]->(ip);
MATCH (p:Product {name:'Vault'}), (ip:IPAsset {name:'Vault Transit Encryption'}) CREATE (p)-[:HAS_IP]->(ip);

// Tech stack
MATCH (p:Product), (t:TechStack {name:'Go'}) WHERE p.name IN ['Terraform','Vault','Consul','Nomad'] CREATE (p)-[:USES_STACK]->(t);
MATCH (p:Product {name:'Terraform'}), (t:TechStack {name:'HCL / Terraform Core'}) CREATE (p)-[:USES_STACK]->(t);
MATCH (p:Product {name:'Vault'}), (t:TechStack {name:'gRPC / Protocol Buffers'}) CREATE (p)-[:USES_STACK]->(t);

// Readiness
MATCH (p:Product {name:'Terraform'}), (r:ReadinessLevel {level:8}) WHERE r.evidence CONTAINS 'Fortune 500' CREATE (p)-[:HAS_READINESS]->(r);
MATCH (p:Product {name:'Vault'}), (r:ReadinessLevel {level:8}) WHERE r.evidence CONTAINS 'FedRAMP' CREATE (p)-[:HAS_READINESS]->(r);
MATCH (p:Product {name:'Consul'}), (r:ReadinessLevel {level:7}) CREATE (p)-[:HAS_READINESS]->(r);

// LAYER 3 PARTNERS

CREATE (awsP:Partner:IndependentContinuant { name:'Amazon Web Services', partner_type:'cloud_provider', strategic_value:'critical', dependency_level:'high' });
CREATE (azureP:Partner:IndependentContinuant { name:'Microsoft Azure', partner_type:'cloud_provider', strategic_value:'high', dependency_level:'medium' });
CREATE (gcpP:Partner:IndependentContinuant { name:'Google Cloud Platform', partner_type:'cloud_provider', strategic_value:'high', dependency_level:'medium' });
MATCH (o:Organization {name:'HashiCorp'}), (p:Partner) WHERE p.name IN ['Amazon Web Services','Microsoft Azure','Google Cloud Platform'] CREATE (o)-[:PARTNERS_WITH]->(p);

// Partnerships (time-bound events) 
CREATE (awsPS:Partnership:Occurrent { type:'ecosystem_partner', start_date:date('2017-01-01'), end_date:null, value_exchanged:'Marketplace distribution, co-sell, AWS provider maintenance' });
CREATE (azurePS:Partnership:Occurrent { type:'ecosystem_partner', start_date:date('2018-06-01'), end_date:null, value_exchanged:'Marketplace distribution, co-sell' });
MATCH (p:Partner {name:'Amazon Web Services'}), (ps:Partnership {value_exchanged:'Marketplace distribution, co-sell, AWS provider maintenance'}) CREATE (p)-[:ENGAGES_IN]->(ps);
MATCH (p:Partner {name:'Microsoft Azure'}), (ps:Partnership {value_exchanged:'Marketplace distribution, co-sell'}) CREATE (p)-[:ENGAGES_IN]->(ps);

MATCH (ps:Partnership {value_exchanged:'Marketplace distribution, co-sell, AWS provider maintenance'}), (p:Partner {name:'Amazon Web Services'}) CREATE (ps)-[:INVOLVES_PARTNER]->(p);
MATCH (ps:Partnership {value_exchanged:'Marketplace distribution, co-sell'}), (p:Partner {name:'Microsoft Azure'}) CREATE (ps)-[:INVOLVES_PARTNER]->(p);

// Competitors
CREATE (pulumi:Competitor:IndependentContinuant { name:'Pulumi', type:'direct', threat_level:'high', overlap_score:0.85 });
CREATE (awsCF:Competitor:IndependentContinuant { name:'AWS CloudFormation', type:'alternative', threat_level:'medium', overlap_score:0.60 });
CREATE (ansible:Competitor:IndependentContinuant { name:'Red Hat Ansible', type:'direct', threat_level:'medium', overlap_score:0.55 });
CREATE (cyberArk:Competitor:IndependentContinuant { name:'CyberArk', type:'direct', threat_level:'medium', overlap_score:0.45 });
MATCH (o:Organization {name:'HashiCorp'}), (c:Competitor) CREATE (o)-[:COMPETES_WITH]->(c);

// LAYER 4- MARKETS & SEGMENTS

CREATE (iacMkt:Market:IndependentContinuant { name:'Enterprise Infrastructure Automation', TAM:7500000000, SAM:2200000000, SOM:420000000, growth_rate:0.28, maturity:'growth', geography:['US','EU','APAC'] });
CREATE (secretsMkt:Market:IndependentContinuant { name:'Secrets Management & Cloud Security', TAM:5200000000, SAM:1800000000, SOM:280000000, growth_rate:0.32, maturity:'growth', geography:['US','EU','APAC'] });
CREATE (netMkt:Market:IndependentContinuant { name:'Service Mesh & Cloud Networking', TAM:3100000000, SAM:800000000, SOM:95000000, growth_rate:0.35, maturity:'emerging', geography:['US','EU'] });

MATCH (p:Product {name:'Terraform'}), (m:Market {name:'Enterprise Infrastructure Automation'}) CREATE (p)-[:TARGETS_MARKET]->(m);
MATCH (p:Product {name:'Vault'}), (m:Market {name:'Secrets Management & Cloud Security'}) CREATE (p)-[:TARGETS_MARKET]->(m);
MATCH (p:Product {name:'Consul'}), (m:Market {name:'Service Mesh & Cloud Networking'}) CREATE (p)-[:TARGETS_MARKET]->(m);

// Market Opportunities
CREATE (iacOpp:MarketOpportunity:DependentContinuant { stage:'pursue_now', rationale:'Strong PMF, growing enterprise pipeline, 28% market CAGR', review_date:date('2023-06-01'), navigator_score:82 });
CREATE (secretsOpp:MarketOpportunity:DependentContinuant { stage:'pursue_now', rationale:'Zero-trust wave driving demand; Vault uniquely positioned with dynamic secrets', review_date:date('2023-06-01'), navigator_score:78 });
CREATE (netOpp:MarketOpportunity:DependentContinuant { stage:'keep_open', rationale:'Istio/Envoy ecosystem maturing; competitive dynamics uncertain', review_date:date('2023-12-01'), navigator_score:54 });
MATCH (m:Market {name:'Enterprise Infrastructure Automation'}), (o:MarketOpportunity {navigator_score:82}) CREATE (m)-[:HAS_OPPORTUNITY]->(o);
MATCH (m:Market {name:'Secrets Management & Cloud Security'}), (o:MarketOpportunity {navigator_score:78}) CREATE (m)-[:HAS_OPPORTUNITY]->(o);
MATCH (m:Market {name:'Service Mesh & Cloud Networking'}), (o:MarketOpportunity {navigator_score:54}) CREATE (m)-[:HAS_OPPORTUNITY]->(o);

// Market Accessibility
CREATE (iacAcc:MarketAccessibility:DependentContinuant { time_to_revenue_days:45, regulatory_barriers:['FedRAMP for gov segment'], resource_requirements:'Enterprise sales team, solution architects', competitive_intensity:0.65, total_score:82 });
CREATE (secretsAcc:MarketAccessibility:DependentContinuant { time_to_revenue_days:60, regulatory_barriers:['FedRAMP','PCI-DSS','HIPAA'], resource_requirements:'Security-specialised sales, compliance team', competitive_intensity:0.58, total_score:78 });
MATCH (o:MarketOpportunity {navigator_score:82}), (a:MarketAccessibility {total_score:82}) CREATE (o)-[:SCORED_BY]->(a);
MATCH (o:MarketOpportunity {navigator_score:78}), (a:MarketAccessibility {total_score:78}) CREATE (o)-[:SCORED_BY]->(a);

// Change Waves
CREATE (cloudWave:ChangeWave:Occurrent { name:'Cloud-Native Infrastructure Adoption', type:'technology_transition', momentum:0.88, time_horizon:'2020-2030', impact_score:0.92 });
CREATE (zeroTrustWave:ChangeWave:Occurrent { name:'Zero-Trust Security Architecture', type:'security_paradigm_shift', momentum:0.82, time_horizon:'2021-2028', impact_score:0.87 });
CREATE (platEngWave:ChangeWave:Occurrent { name:'Platform Engineering Emergence', type:'organisational_trend', momentum:0.74, time_horizon:'2022-2027', impact_score:0.78 });
MATCH (m:Market {name:'Enterprise Infrastructure Automation'}), (w:ChangeWave) WHERE w.name IN ['Cloud-Native Infrastructure Adoption','Platform Engineering Emergence'] CREATE (m)-[:DRIVEN_BY_WAVE]->(w);
MATCH (m:Market {name:'Secrets Management & Cloud Security'}), (w:ChangeWave {name:'Zero-Trust Security Architecture'}) CREATE (m)-[:DRIVEN_BY_WAVE]->(w);

// Customer Segments
CREATE (communityDevSeg:CustomerSegment:IndependentContinuant { name:'Open Source Community Developers', segmentation_approach:'behavioural', size:3000000, willingness_to_pay:0, acquisition_cost:2 });
CREATE (smbSeg:CustomerSegment:IndependentContinuant { name:'SMB DevOps Teams', segmentation_approach:'firmographic', size:45000, willingness_to_pay:5000, acquisition_cost:1200 });
CREATE (entPlatSeg:CustomerSegment:IndependentContinuant { name:'Enterprise Platform Engineering Teams', segmentation_approach:'firmographic', size:8500, willingness_to_pay:180000, acquisition_cost:38000 });
CREATE (entSecSeg:CustomerSegment:IndependentContinuant { name:'Enterprise Security Teams', segmentation_approach:'firmographic', size:6200, willingness_to_pay:150000, acquisition_cost:42000 });

MATCH (m:Market {name:'Enterprise Infrastructure Automation'}), (s:CustomerSegment) WHERE s.name IN ['Open Source Community Developers','SMB DevOps Teams','Enterprise Platform Engineering Teams'] CREATE (m)-[:CONTAINS_SEGMENT]->(s);
MATCH (m:Market {name:'Secrets Management & Cloud Security'}), (s:CustomerSegment {name:'Enterprise Security Teams'}) CREATE (m)-[:CONTAINS_SEGMENT]->(s);

MATCH (p:Product {name:'Terraform'}), (s:CustomerSegment) WHERE s.name IN ['Open Source Community Developers','SMB DevOps Teams','Enterprise Platform Engineering Teams'] CREATE (p)-[:SERVES_SEGMENT]->(s);
MATCH (p:Product {name:'Vault'}), (s:CustomerSegment) WHERE s.name IN ['Enterprise Security Teams','Enterprise Platform Engineering Teams'] CREATE (p)-[:SERVES_SEGMENT]->(s);
MATCH (p:Product {name:'Consul'}), (s:CustomerSegment {name:'Enterprise Platform Engineering Teams'}) CREATE (p)-[:SERVES_SEGMENT]->(s);

// LAYER 5- STAKEHOLDERS & PAIN 

CREATE (devUser:User:Stakeholder:IndependentContinuant { name:'Infrastructure Developer', stakeholder_type:'user', influence_level:'medium', usage_frequency:'daily', expertise_level:'intermediate', satisfaction_score:8.2 });
CREATE (platUser:User:Stakeholder:IndependentContinuant { name:'Platform Engineer', stakeholder_type:'user_champion', influence_level:'high', usage_frequency:'daily', expertise_level:'expert', satisfaction_score:8.7 });
CREATE (ctoBuyer:EconomicBuyer:Stakeholder:IndependentContinuant { name:'CTO / VP Engineering', stakeholder_type:'economic_buyer', influence_level:'critical', budget_range:'100000-500000', ROI_threshold:3.0, approval_process:'annual_budget_cycle', risk_tolerance:'low' });
CREATE (secBuyer:TechnicalBuyer:Stakeholder:IndependentContinuant { name:'Security Engineer', stakeholder_type:'technical_buyer', influence_level:'high', evaluation_criteria:['SOC2','FedRAMP','HSM_support','audit_logs'], integration_requirements:['LDAP','ActiveDirectory','Kubernetes'] });
CREATE (devopsChamp:Champion:Stakeholder:IndependentContinuant { name:'DevOps Lead / Platform Architect', stakeholder_type:'champion', influence_level:'high', advocacy_strength:0.85, motivation:'Technical evangelism and career growth', political_capital:'high' });

MATCH (s:CustomerSegment {name:'Open Source Community Developers'}), (st:Stakeholder {name:'Infrastructure Developer'}) CREATE (s)-[:HAS_STAKEHOLDER]->(st);
MATCH (s:CustomerSegment {name:'Enterprise Platform Engineering Teams'}), (st:Stakeholder) WHERE st.name IN ['Platform Engineer','CTO / VP Engineering','DevOps Lead / Platform Architect'] CREATE (s)-[:HAS_STAKEHOLDER]->(st);
MATCH (s:CustomerSegment {name:'Enterprise Security Teams'}), (st:Stakeholder) WHERE st.name IN ['Security Engineer','CTO / VP Engineering'] CREATE (s)-[:HAS_STAKEHOLDER]->(st);

// Pain Points
CREATE (driftPain:PainPoint:DependentContinuant { description:'Infrastructure drift: manually managed configs diverge from desired state, causing outages', severity:'critical', frequency:'daily', current_workaround:'Manual audits, bespoke scripts', cost_of_pain:'Engineering hours + outage risk' });
CREATE (lockInPain:PainPoint:DependentContinuant { description:'Cloud provider lock-in prevents multi-cloud strategy and increases switching cost', severity:'major', frequency:'strategic', current_workaround:'Provider-specific tooling per cloud' });
CREATE (secretsSprawlPain:PainPoint:DependentContinuant { description:'Secrets sprawl: credentials hardcoded or scattered across systems, creating breach risk', severity:'critical', frequency:'continuous', current_workaround:'Manual rotation, environment variables, partial vaults' });
CREATE (slowProvPain:PainPoint:DependentContinuant { description:'Slow infrastructure provisioning through ticketing systems blocks developer velocity', severity:'major', frequency:'weekly', current_workaround:'Ticket-based ops, manual CLI' });
CREATE (compliancePain:PainPoint:DependentContinuant { description:'Difficulty enforcing policy and audit trail across infrastructure changes', severity:'critical', frequency:'continuous', cost_of_pain:'Audit failures, regulatory fines' });

MATCH (st:Stakeholder {name:'Infrastructure Developer'}), (p:PainPoint) WHERE p.description CONTAINS 'drift' OR p.description CONTAINS 'Slow' CREATE (st)-[:EXPERIENCES_PAIN]->(p);
MATCH (st:Stakeholder {name:'Platform Engineer'}), (p:PainPoint) WHERE p.description CONTAINS 'drift' OR p.description CONTAINS 'lock-in' OR p.description CONTAINS 'policy' CREATE (st)-[:EXPERIENCES_PAIN]->(p);
MATCH (st:Stakeholder {name:'Security Engineer'}), (p:PainPoint) WHERE p.description CONTAINS 'sprawl' OR p.description CONTAINS 'policy' CREATE (st)-[:EXPERIENCES_PAIN]->(p);

// Benefits
CREATE (consistencyBenefit:Benefit:DependentContinuant { description:'Consistent, reproducible infrastructure state across all environments', type:'functional', magnitude:'high', measurability:'high' });
CREATE (multiCloudBenefit:Benefit:DependentContinuant { description:'Multi-cloud portability with a single workflow', type:'functional', magnitude:'high', measurability:'medium' });
CREATE (securityBenefit:Benefit:DependentContinuant { description:'Zero standing privileges; dynamic secrets that auto-rotate', type:'functional', magnitude:'critical', measurability:'high' });

// Jobs to be done
CREATE (provisionJob:JobToBeDone:DependentContinuant { description:'Provision and manage cloud infrastructure reliably at scale', type:'functional', importance:9, satisfaction_current:4 });
CREATE (secureJob:JobToBeDone:DependentContinuant { description:'Secure secrets and enforce least-privilege access across distributed systems', type:'functional', importance:10, satisfaction_current:3 });
CREATE (complianceJob:JobToBeDone:DependentContinuant { description:'Demonstrate policy compliance and produce audit evidence on demand', type:'social', importance:9, satisfaction_current:3 });

MATCH (st:Stakeholder {name:'Platform Engineer'}), (j:JobToBeDone) WHERE j.description CONTAINS 'Provision' OR j.description CONTAINS 'compliance' CREATE (st)-[:HAS_JOB]->(j);
MATCH (st:Stakeholder {name:'Security Engineer'}), (j:JobToBeDone) WHERE j.description CONTAINS 'secrets' OR j.description CONTAINS 'compliance' CREATE (st)-[:HAS_JOB]->(j);
MATCH (p:Product {name:'Terraform'}), (j:JobToBeDone {description:'Provision and manage cloud infrastructure reliably at scale'}) CREATE (p)-[:FULFILLS_JOB]->(j);
MATCH (p:Product {name:'Vault'}), (j:JobToBeDone) WHERE j.description CONTAINS 'secrets' OR j.description CONTAINS 'audit' CREATE (p)-[:FULFILLS_JOB]->(j);

// LAYER 6 - VALUE, PRICING, REVENUE, COST

// Features
CREATE (hclFeat:Feature:DependentContinuant { name:'HCL Infrastructure Definition Language', priority:'must_have', status:'ga', complexity:'high', differentiation_score:0.82 });
CREATE (stateFeat:Feature:DependentContinuant { name:'State Management & Remote Backend', priority:'must_have', status:'ga', complexity:'high', differentiation_score:0.75 });
CREATE (providerFeat:Feature:DependentContinuant { name:'Provider Ecosystem (1000+ providers)', priority:'must_have', status:'ga', complexity:'medium', differentiation_score:0.90 });
CREATE (sentinelFeat:Feature:DependentContinuant { name:'Sentinel Policy-as-Code', priority:'must_have', status:'ga', complexity:'high', differentiation_score:0.88, enterprise_only:true });
CREATE (workspaceFeat:Feature:DependentContinuant { name:'Team Workspaces & Collaboration', priority:'must_have', status:'ga', complexity:'medium', differentiation_score:0.70 });
CREATE (secretsEngFeat:Feature:DependentContinuant { name:'Dynamic Secrets Engine', priority:'must_have', status:'ga', complexity:'high', differentiation_score:0.92 });
CREATE (authFeat:Feature:DependentContinuant { name:'Auth Methods (100+ integrations)', priority:'must_have', status:'ga', complexity:'medium', differentiation_score:0.80 });

MATCH (p:Product {name:'Terraform'}), (f:Feature) WHERE f.name IN ['HCL Infrastructure Definition Language','State Management & Remote Backend','Provider Ecosystem (1000+ providers)','Sentinel Policy-as-Code'] CREATE (p)-[:HAS_FEATURE]->(f);
MATCH (p:Product {name:'Terraform Cloud'}), (f:Feature {name:'Team Workspaces & Collaboration'}) CREATE (p)-[:HAS_FEATURE]->(f);
MATCH (p:Product {name:'Vault'}), (f:Feature) WHERE f.name IN ['Dynamic Secrets Engine','Auth Methods (100+ integrations)'] CREATE (p)-[:HAS_FEATURE]->(f);

// Feature dependencies (must be acyclic, HC-14)
MATCH (a:Feature {name:'State Management & Remote Backend'}), (b:Feature {name:'HCL Infrastructure Definition Language'}) CREATE (a)-[:DEPENDS_ON {type:'requires'}]->(b);
MATCH (a:Feature {name:'Sentinel Policy-as-Code'}), (b:Feature {name:'State Management & Remote Backend'}) CREATE (a)-[:DEPENDS_ON {type:'requires'}]->(b);
MATCH (a:Feature {name:'Team Workspaces & Collaboration'}), (b:Feature {name:'State Management & Remote Backend'}) CREATE (a)-[:DEPENDS_ON {type:'requires'}]->(b);
MATCH (a:Feature {name:'Auth Methods (100+ integrations)'}), (b:Feature {name:'Dynamic Secrets Engine'}) CREATE (a)-[:DEPENDS_ON {type:'requires'}]->(b);

// Feature ‚ Pain
MATCH (f:Feature {name:'HCL Infrastructure Definition Language'}), (p:PainPoint) WHERE p.description CONTAINS 'drift' OR p.description CONTAINS 'Slow' CREATE (f)-[:ADDRESSES_PAIN]->(p);
MATCH (f:Feature {name:'Provider Ecosystem (1000+ providers)'}), (p:PainPoint {description:'Cloud provider lock-in prevents multi-cloud strategy and increases switching cost'}) CREATE (f)-[:ADDRESSES_PAIN]->(p);
MATCH (f:Feature {name:'Sentinel Policy-as-Code'}), (p:PainPoint {description:'Difficulty enforcing policy and audit trail across infrastructure changes'}) CREATE (f)-[:ADDRESSES_PAIN]->(p);
MATCH (f:Feature {name:'Dynamic Secrets Engine'}), (p:PainPoint {description:'Secrets sprawl: credentials hardcoded or scattered across systems, creating breach risk'}) CREATE (f)-[:ADDRESSES_PAIN]->(p);

// Value Propositions
CREATE (tfVP:ValueProposition:DependentContinuant { statement:'Provision any infrastructure with one consistent workflow across any cloud provider', differentiation_type:'multi_cloud_breadth', quantified_value:'50% reduction in provisioning time; eliminates infrastructure drift', proof_points:['100M+ downloads','Used by 90% of Fortune 500 infrastructure teams'] });
CREATE (tfEntVP:ValueProposition:DependentContinuant { statement:'Governance, policy enforcement, and collaboration for infrastructure-as-code at enterprise scale', differentiation_type:'governance_depth', quantified_value:'Audit-ready infrastructure changes; prevent policy violations pre-apply', proof_points:['Sentinel policy engine','Detailed audit logs','SSO/SAML integration'] });
CREATE (vaultVP:ValueProposition:DependentContinuant { statement:'Eliminate secrets sprawl and enforce least-privilege access across any infrastructure', differentiation_type:'security_centralisation', quantified_value:'80% reduction in credential-related incidents; zero standing privileges', proof_points:['Dynamic secrets auto-rotate','100+ auth method integrations','FedRAMP-ready'] });

MATCH (vp:ValueProposition {differentiation_type:'multi_cloud_breadth'}), (p:PainPoint) WHERE p.description CONTAINS 'drift' OR p.description CONTAINS 'lock-in' OR p.description CONTAINS 'Slow' CREATE (vp)-[:RESOLVES]->(p);
MATCH (vp:ValueProposition {differentiation_type:'governance_depth'}), (p:PainPoint {description:'Difficulty enforcing policy and audit trail across infrastructure changes'}) CREATE (vp)-[:RESOLVES]->(p);
MATCH (vp:ValueProposition {differentiation_type:'security_centralisation'}), (p:PainPoint) WHERE p.description CONTAINS 'sprawl' OR p.description CONTAINS 'policy' CREATE (vp)-[:RESOLVES]->(p);

MATCH (vp:ValueProposition {differentiation_type:'multi_cloud_breadth'}), (s:CustomerSegment) WHERE s.name IN ['Open Source Community Developers','SMB DevOps Teams'] CREATE (vp)-[:PROPOSES_VALUE_TO]->(s);
MATCH (vp:ValueProposition {differentiation_type:'governance_depth'}), (s:CustomerSegment {name:'Enterprise Platform Engineering Teams'}) CREATE (vp)-[:PROPOSES_VALUE_TO]->(s);
MATCH (vp:ValueProposition {differentiation_type:'security_centralisation'}), (s:CustomerSegment {name:'Enterprise Security Teams'}) CREATE (vp)-[:PROPOSES_VALUE_TO]->(s);

// Pricing Models
CREATE (freePricing:PricingModel:DependentContinuant { type:'open_source', price_points:[0], elasticity_estimate:0, notes:'Free forever; no feature limitations for OSS' });
CREATE (cloudPricing:PricingModel:DependentContinuant { type:'usage_based', price_points:[20, 0.00014], notes:'$20/user/month + $0.00014 per managed resource' });
CREATE (entPricing:PricingModel:DependentContinuant { type:'subscription', price_points:[150000, 300000, 500000], notes:'Annual subscription, node/cluster based; enterprise negotiated' });
MATCH (p:Product {name:'Terraform OSS'}), (pm:PricingModel {type:'open_source'}) CREATE (p)-[:PRICED_BY]->(pm);
MATCH (p:Product {name:'Terraform Cloud'}), (pm:PricingModel {type:'usage_based'}) CREATE (p)-[:PRICED_BY]->(pm);
MATCH (p:Product {name:'Vault Enterprise'}), (pm:PricingModel {type:'subscription'}) CREATE (p)-[:PRICED_BY]->(pm);
// HC-05: Pricing must reference a segment
MATCH (pm:PricingModel {type:'open_source'}), (s:CustomerSegment {name:'Open Source Community Developers'}) CREATE (pm)-[:REFERENCES_SEGMENT]->(s);
MATCH (pm:PricingModel {type:'usage_based'}), (s:CustomerSegment {name:'SMB DevOps Teams'}) CREATE (pm)-[:REFERENCES_SEGMENT]->(s);
MATCH (pm:PricingModel {type:'subscription'}), (s:CustomerSegment {name:'Enterprise Platform Engineering Teams'}) CREATE (pm)-[:REFERENCES_SEGMENT]->(s);

// Revenue Streams
CREATE (hcpRev:RevenueStream:DependentContinuant { type:'recurring', amount:65000000, gross_revenue_share:0.55, notes:'HCP ARR estimate 2022' });
CREATE (entRev:RevenueStream:DependentContinuant { type:'recurring', amount:230000000, gross_revenue_share:0.85, notes:'Enterprise license ARR estimate 2022' });
CREATE (svcRev:RevenueStream:DependentContinuant { type:'transactional', amount:25000000, gross_revenue_share:0.40, notes:'Professional services and training' });
MATCH (p:Product {name:'Terraform Cloud'}), (r:RevenueStream {type:'recurring', amount:65000000}) CREATE (p)-[:GENERATES_REVENUE]->(r);
MATCH (p:Product {name:'Vault Enterprise'}), (r:RevenueStream {type:'recurring', amount:230000000}) CREATE (p)-[:GENERATES_REVENUE]->(r);

// Channels
CREATE (awsMkt:Channel:IndependentContinuant { name:'AWS Marketplace', type:'indirect', funnel_stage:'acquisition', conversion_rate:0.08, bullseye_ring:1 });
CREATE (directSales:Channel:IndependentContinuant { name:'Direct Enterprise Sales', type:'direct', funnel_stage:'acquisition', conversion_rate:0.22, bullseye_ring:1 });
CREATE (ghCommunity:Channel:IndependentContinuant { name:'GitHub / OSS Community', type:'digital', funnel_stage:'acquisition', conversion_rate:0.03, bullseye_ring:1 });
CREATE (hashiConf:Channel:IndependentContinuant { name:'HashiConf', type:'physical', funnel_stage:'activation', conversion_rate:0.15, bullseye_ring:2 });
MATCH (p:Partner {name:'Amazon Web Services'}), (c:Channel {name:'AWS Marketplace'}) CREATE (p)-[:OPERATES_CHANNEL]->(c);
MATCH (p:Product {name:'Terraform OSS'}), (c:Channel {name:'GitHub / OSS Community'}) CREATE (p)-[:DISTRIBUTED_THROUGH]->(c);
MATCH (p:Product {name:'Terraform Cloud'}), (c:Channel) WHERE c.name IN ['AWS Marketplace','Direct Enterprise Sales'] CREATE (p)-[:DISTRIBUTED_THROUGH]->(c);
MATCH (p:Product {name:'Vault Enterprise'}), (c:Channel {name:'Direct Enterprise Sales'}) CREATE (p)-[:DISTRIBUTED_THROUGH]->(c);
MATCH (m:Market), (c:Channel {name:'AWS Marketplace'}) WHERE m.name IN ['Enterprise Infrastructure Automation','Secrets Management & Cloud Security'] CREATE (m)-[:REACHED_VIA]->(c);

// Cost Structures
CREATE (rdCost:CostStructure:DependentContinuant { cost_type:'fixed', category:'R&D', amount:144000000, unit_cost:180000, notes:'Annual engineering team fully loaded cost' });
CREATE (smCost:CostStructure:DependentContinuant { cost_type:'semi_variable', category:'S&M', amount:87600000, unit_cost:120000, notes:'Sales, marketing, DevRel combined' });
CREATE (infraCost:CostStructure:DependentContinuant { cost_type:'variable', category:'COGS', amount:28000000, notes:'Cloud infrastructure for HCP platform' });
CREATE (gaCost:CostStructure:DependentContinuant { cost_type:'fixed', category:'G&A', amount:36000000, notes:'G&A fully loaded annual' });
MATCH (t:Team {name:'Engineering'}), (c:CostStructure {category:'R&D'}) CREATE (t)-[:COSTS_VIA]->(c);
MATCH (t:Team), (c:CostStructure {category:'S&M'}) WHERE t.name IN ['Sales & Marketing','Developer Relations'] CREATE (t)-[:COSTS_VIA]->(c);
MATCH (t:Team {name:'G&A'}), (c:CostStructure {category:'G&A'}) CREATE (t)-[:COSTS_VIA]->(c);
MATCH (p:Product {name:'Terraform'}), (c:CostStructure {category:'R&D'}) CREATE (p)-[:INCURS_COST]->(c);
MATCH (p:Product {name:'Terraform Cloud'}), (c:CostStructure {category:'COGS'}) CREATE (p)-[:INCURS_COST]->(c);

MATCH (c:CostStructure {category:'S&M'}), (s:CustomerSegment {name:'Enterprise Platform Engineering Teams'}) CREATE (c)-[:ATTRIBUTED_TO_SEGMENT {weight:0.70}]->(s);
MATCH (c:CostStructure {category:'S&M'}), (s:CustomerSegment {name:'Enterprise Security Teams'}) CREATE (c)-[:ATTRIBUTED_TO_SEGMENT {weight:0.20}]->(s);
MATCH (c:CostStructure {category:'S&M'}), (s:CustomerSegment {name:'SMB DevOps Teams'}) CREATE (c)-[:ATTRIBUTED_TO_SEGMENT {weight:0.10}]->(s);

// Unit Economics
CREATE (entUE:UnitEconomics:DependentContinuant { ltv_usd:520000, cac_usd:38000, ltv_cac_ratio:13.7, payback_period_months:8, gross_margin:0.80, cohort_id:'2022_enterprise', derivation_method:'cohort_analysis' });
CREATE (smbUE:UnitEconomics:DependentContinuant { ltv_usd:18000, cac_usd:1200, ltv_cac_ratio:15.0, payback_period_months:4, gross_margin:0.75, cohort_id:'2022_smb' });
MATCH (ue:UnitEconomics {cohort_id:'2022_enterprise'}), (s:CustomerSegment {name:'Enterprise Platform Engineering Teams'}) CREATE (ue)-[:ECONOMICS_FOR]->(s);
MATCH (ue:UnitEconomics {cohort_id:'2022_smb'}), (s:CustomerSegment {name:'SMB DevOps Teams'}) CREATE (ue)-[:ECONOMICS_FOR]->(s);
MATCH (ue:UnitEconomics {cohort_id:'2022_enterprise'}), (r:RevenueStream {amount:230000000}) CREATE (ue)-[:DERIVES_FROM]->(r);
MATCH (ue:UnitEconomics {cohort_id:'2022_enterprise'}), (c:CostStructure {category:'S&M'}) CREATE (ue)-[:DERIVES_FROM]->(c);
MATCH (ue:UnitEconomics {cohort_id:'2022_smb'}), (r:RevenueStream {amount:65000000}) CREATE (ue)-[:DERIVES_FROM]->(r);

//  LAYER 7-  INVESTORS & 

CREATE (mayfield:Investor:IndependentContinuant { name:'Mayfield Fund', investor_type:'venture_capital', portfolio_focus:'enterprise_software', check_size_range:'5M-50M', board_seat:true });
CREATE (ggv:Investor:IndependentContinuant { name:'GGV Capital', investor_type:'venture_capital', portfolio_focus:'cloud_infrastructure', check_size_range:'10M-100M', board_seat:true });
CREATE (trueV:Investor:IndependentContinuant { name:'True Ventures', investor_type:'venture_capital', portfolio_focus:'developer_tools', check_size_range:'5M-30M', board_seat:false });
CREATE (ivp:Investor:IndependentContinuant { name:'IVP', investor_type:'venture_capital', portfolio_focus:'growth_technology', check_size_range:'50M-200M', board_seat:true });
CREATE (bessemer:Investor:IndependentContinuant { name:'Bessemer Venture Partners', investor_type:'venture_capital', portfolio_focus:'cloud_saas', check_size_range:'20M-150M', board_seat:false });
CREATE (redpoint:Investor:IndependentContinuant { name:'Redpoint Ventures', investor_type:'venture_capital', portfolio_focus:'infrastructure', check_size_range:'10M-100M', board_seat:false });
CREATE (franklin:Investor:IndependentContinuant { name:'Franklin Templeton', investor_type:'institutional', portfolio_focus:'growth_technology', check_size_range:'100M-500M', board_seat:false });

CREATE (rndA:FundingRound:Occurrent { round_type:'series_A', target_amount:10000000, raised_amount:10000000, open_date:date('2014-12-10'), close_date:date('2014-12-15'), valuation:40000000 });
CREATE (rndB:FundingRound:Occurrent { round_type:'series_B', target_amount:24000000, raised_amount:24000000, open_date:date('2015-09-01'), close_date:date('2015-09-30'), valuation:100000000 });
CREATE (rndC:FundingRound:Occurrent { round_type:'series_C', target_amount:40000000, raised_amount:40000000, open_date:date('2017-10-01'), close_date:date('2017-10-31'), valuation:340000000 });
CREATE (rndD:FundingRound:Occurrent { round_type:'series_D', target_amount:100000000, raised_amount:100000000, open_date:date('2018-11-01'), close_date:date('2018-11-30'), valuation:1900000000 });
CREATE (rndE:FundingRound:Occurrent { round_type:'series_E', target_amount:175000000, raised_amount:175000000, open_date:date('2020-03-16'), close_date:date('2020-04-15'), valuation:5100000000 });

CREATE (invA:Investment:Occurrent { type:'equity', amount:10000000, date:date('2014-12-10'), instrument_terms:'Preferred Series A' });
CREATE (invD:Investment:Occurrent { type:'equity', amount:100000000, date:date('2018-11-01'), instrument_terms:'Preferred Series D' });
CREATE (invE:Investment:Occurrent { type:'equity', amount:175000000, date:date('2020-03-16'), instrument_terms:'Preferred Series E' });

MATCH (o:Organization {name:'HashiCorp'}), (i:Investment) CREATE (o)-[:FUNDED_BY]->(i);
MATCH (i:Investment {amount:10000000}), (r:FundingRound {round_type:'series_A'}) CREATE (i)-[:WITHIN_ROUND]->(r);
MATCH (i:Investment {amount:100000000}), (r:FundingRound {round_type:'series_D'}) CREATE (i)-[:WITHIN_ROUND]->(r);
MATCH (i:Investment {amount:175000000}), (r:FundingRound {round_type:'series_E'}) CREATE (i)-[:WITHIN_ROUND]->(r);
MATCH (i:Investment {amount:10000000}), (iv:Investor) WHERE iv.name IN ['Mayfield Fund','GGV Capital','True Ventures'] CREATE (i)-[:INVESTED_BY]->(iv);
MATCH (i:Investment {amount:100000000}), (iv:Investor) WHERE iv.name IN ['IVP','Bessemer Venture Partners','GGV Capital','Redpoint Ventures','Mayfield Fund'] CREATE (i)-[:INVESTED_BY]->(iv);
MATCH (i:Investment {amount:175000000}), (iv:Investor) WHERE iv.name IN ['Franklin Templeton','GGV Capital','IVP','Redpoint Ventures','Mayfield Fund'] CREATE (i)-[:INVESTED_BY]->(iv);
MATCH (iv:Investor), (o:Organization {name:'HashiCorp'}) WHERE iv.name IN ['Mayfield Fund','GGV Capital','IVP','Franklin Templeton'] CREATE (iv)-[:BACKS_ORGANIZATION]->(o);

//  LAYER 8 ‚ INTELLIGENCE (Assumptions, Hypos, Experiments

CREATE (openCoreA:Assumption:DependentContinuant { statement:'The open-core model will sustain community growth while generating sufficient enterprise revenue to fund R&D', assumption_type:'viability', validation_status:'validated', confidence:8, riskiness_score:6 });
CREATE (cloudGrowthA:Assumption:DependentContinuant { statement:'Cloud-native infrastructure adoption will continue at >25% CAGR through 2025', assumption_type:'scalability', validation_status:'validated', confidence:9, riskiness_score:4 });
CREATE (mplLicenseA:Assumption:DependentContinuant { statement:'MPL-2.0 license sufficiently deters hyperscalers from building competing managed services on HashiCorp OSS without contributing back', assumption_type:'sustainability', validation_status:'invalidated', confidence:3, riskiness_score:9, invalidation_date:date('2023-01-01'), invalidation_evidence:'AWS and GCP maintained Terraform providers without meaningful code contribution to core; BSL switch required Aug 2023' });
CREATE (entGovA:Assumption:DependentContinuant { statement:'Enterprise platform teams will pay a significant premium for policy enforcement and governance features on top of free OSS', assumption_type:'viability', validation_status:'validated', confidence:9, riskiness_score:3 });
CREATE (multiCloudA:Assumption:DependentContinuant { statement:'Multi-cloud architecture will become the dominant enterprise pattern, making cloud-agnostic tooling essential', assumption_type:'desirability', validation_status:'validated', confidence:8, riskiness_score:4 });
CREATE (hcpFeasA:Assumption:DependentContinuant { statement:'HashiCorp can build and operate a managed cloud platform (HCP) at competitive unit economics versus hyperscaler-native tools', assumption_type:'feasibility', validation_status:'testing', confidence:6, riskiness_score:7 });
CREATE (ossHealthA:Assumption:DependentContinuant { statement:'The open source contributor ecosystem will remain healthy without direct financial compensation to community contributors', assumption_type:'sustainability', validation_status:'testing', confidence:5, riskiness_score:8 });
CREATE (platEngA:Assumption:DependentContinuant { statement:'Platform engineering will emerge as a distinct function in enterprises with >500 engineers, creating a dedicated buyer persona', assumption_type:'desirability', validation_status:'validated', confidence:8, riskiness_score:3 });

MATCH (p:Product {name:'Terraform'}), (a:Assumption) WHERE a.statement CONTAINS 'open-core' OR a.statement CONTAINS 'MPL-2.0' OR a.statement CONTAINS 'enterprise platform teams' CREATE (p)-[:HAS_ASSUMPTION]->(a);
MATCH (p:Product {name:'Terraform Cloud'}), (a:Assumption {statement:'HashiCorp can build and operate a managed cloud platform (HCP) at competitive unit economics versus hyperscaler-native tools'}) CREATE (p)-[:HAS_ASSUMPTION]->(a);
MATCH (p:Product {name:'Terraform OSS'}), (a:Assumption {statement:'The open source contributor ecosystem will remain healthy without direct financial compensation to community contributors'}) CREATE (p)-[:HAS_ASSUMPTION]->(a);
MATCH (m:Market {name:'Enterprise Infrastructure Automation'}), (a:Assumption) WHERE a.statement CONTAINS 'Multi-cloud' OR a.statement CONTAINS 'Cloud-native' OR a.statement CONTAINS 'Platform engineering' CREATE (m)-[:HAS_ASSUMPTION]->(a);

MATCH (a:Assumption {statement:'Cloud-native infrastructure adoption will continue at >25% CAGR through 2025'}), (w:ChangeWave {name:'Cloud-Native Infrastructure Adoption'}) CREATE (a)-[:CONTINGENT_ON]->(w);
MATCH (a:Assumption {statement:'Multi-cloud architecture will become the dominant enterprise pattern, making cloud-agnostic tooling essential'}), (w:ChangeWave {name:'Cloud-Native Infrastructure Adoption'}) CREATE (a)-[:CONTINGENT_ON]->(w);
MATCH (a:Assumption {statement:'Platform engineering will emerge as a distinct function in enterprises with >500 engineers, creating a dedicated buyer persona'}), (w:ChangeWave {name:'Platform Engineering Emergence'}) CREATE (a)-[:CONTINGENT_ON]->(w);
MATCH (a:Assumption {statement:'The open source contributor ecosystem will remain healthy without direct financial compensation to community contributors'}), (w:ChangeWave {name:'Cloud-Native Infrastructure Adoption'}) CREATE (a)-[:CONTINGENT_ON]->(w);

// Hypotheses
CREATE (sentinelH:Hypothesis:DependentContinuant { statement:'Adding Sentinel policy-as-code to Terraform Enterprise will increase average enterprise deal size by >30% compared to a control group without Sentinel', null_hypothesis:'Sentinel has no significant effect on enterprise deal size', success_metric:'average_enterprise_deal_ACV', success_threshold:0.30, current_status:'validated' });
CREATE (hcpConvH:Hypothesis:DependentContinuant { statement:'Launching HCP Terraform will convert >5% of active OSS users to paid within 12 months of GA', null_hypothesis:'HCP conversion rate will not exceed 1% baseline', success_metric:'oss_to_paid_conversion_rate', success_threshold:0.05, current_status:'testing' });
CREATE (bslH:Hypothesis:DependentContinuant { statement:'Switching to BSL-1.1 will reduce hyperscaler competitive offerings without causing >20% decline in community contributions', null_hypothesis:'BSL switch causes >20% community contribution decline within 6 months', success_metric:'monthly_community_contributions', success_threshold:-0.20, current_status:'testing' });

MATCH (a:Assumption {statement:'Enterprise platform teams will pay a significant premium for policy enforcement and governance features on top of free OSS'}), (h:Hypothesis {statement:'Adding Sentinel policy-as-code to Terraform Enterprise will increase average enterprise deal size by >30% compared to a control group without Sentinel'}) CREATE (a)-[:FORMALIZED_AS]->(h);
MATCH (a:Assumption {statement:'HashiCorp can build and operate a managed cloud platform (HCP) at competitive unit economics versus hyperscaler-native tools'}), (h:Hypothesis {statement:'Launching HCP Terraform will convert >5% of active OSS users to paid within 12 months of GA'}) CREATE (a)-[:FORMALIZED_AS]->(h);
MATCH (a:Assumption {statement:'MPL-2.0 license sufficiently deters hyperscalers from building competing managed services on HashiCorp OSS without contributing back'}), (h:Hypothesis {statement:'Switching to BSL-1.1 will reduce hyperscaler competitive offerings without causing >20% decline in community contributions'}) CREATE (a)-[:FORMALIZED_AS]->(h);

// Experiments
CREATE (sentinelExp:Experiment:Occurrent { type:'MVP', start_date:date('2018-09-01'), end_date:date('2019-03-31'), sample_size:12, result:'validated', cost:200000, learning_summary:'Enterprise customers with Sentinel closed at 2.4x higher ACV; governance-focused buyer NPS rose to 72' });
CREATE (hcpEAExp:Experiment:Occurrent { type:'concierge', start_date:date('2021-06-01'), end_date:date('2022-01-31'), sample_size:45, result:'partial', cost:1500000, learning_summary:'Conversion rate 3.8% vs 5% target; 91% retention at 6 months; pricing elasticity lower than expected' });
CREATE (wtpExp:Experiment:Occurrent { type:'interview', start_date:date('2020-03-01'), end_date:date('2020-06-30'), sample_size:38, result:'validated', cost:45000, learning_summary:'Enterprise WTP confirmed at $150K-$500K annual; SMB ceiling at $8K/yr; community segment price-sensitive below $100/mo' });

MATCH (h:Hypothesis {statement:'Adding Sentinel policy-as-code to Terraform Enterprise will increase average enterprise deal size by >30% compared to a control group without Sentinel'}), (e:Experiment {type:'MVP'}) CREATE (h)-[:TESTED_BY]->(e);
MATCH (h:Hypothesis {statement:'Launching HCP Terraform will convert >5% of active OSS users to paid within 12 months of GA'}), (e:Experiment {type:'concierge'}) CREATE (h)-[:TESTED_BY]->(e);
MATCH (pm:PricingModel), (e:Experiment {type:'interview'}) CREATE (pm)-[:HAS_ASSUMPTION]->(wtpA) WITH pm, e MATCH (a:Assumption {assumption_type:'viability',riskiness_score:3}) CREATE (pm)-[:HAS_ASSUMPTION]->(a);

// Risks
CREATE (forkRisk:Risk:DependentContinuant { description:'OpenTofu fork captures significant Terraform community mindshare following BSL relicensing', category:'community', probability:0.75, impact:0.80, exposure_score:8.5, mitigation_strategy:'Accelerate HCP feature velocity; engage CNCF diplomatically; clarify BSL conversion timeline' });
CREATE (hyperscalerRisk:Risk:DependentContinuant { description:'AWS and Azure build native IaC tooling that displaces Terraform in their respective cloud environments', category:'market', probability:0.55, impact:0.65, exposure_score:6.2, mitigation_strategy:'Deepen multi-cloud differentiation; expand provider ecosystem breadth' });
CREATE (channelRisk:Risk:DependentContinuant { description:'Heavy dependence on AWS Marketplace creates single-channel concentration risk for enterprise discovery', category:'financial', probability:0.35, impact:0.50, exposure_score:4.8, mitigation_strategy:'Expand Azure and GCP marketplace presence; increase direct outbound sales investment' });

MATCH (p:Product {name:'Terraform OSS'}), (r:Risk {category:'community'}) CREATE (p)-[:HAS_RISK]->(r);
MATCH (p:Product {name:'Terraform'}), (r:Risk {category:'market'}) CREATE (p)-[:HAS_RISK]->(r);
MATCH (ps:Partnership {value_exchanged:'Marketplace distribution, co-sell, AWS provider maintenance'}), (r:Risk {category:'financial'}) CREATE (ps)-[:HAS_RISK]->(r);

// Key Activities
CREATE (providerMaint:KeyActivity:Occurrent { name:'Terraform Provider Ecosystem Maintenance', type:'platform_management', criticality:'critical', cost:8000000, automation_level:'partial' });
CREATE (enterpriseSales:KeyActivity:Occurrent { name:'Enterprise Field Sales Motions', type:'problem_solving', criticality:'critical', cost:60000000, automation_level:'low' });
MATCH (r:Risk {category:'community'}), (ka:KeyActivity {name:'Terraform Provider Ecosystem Maintenance'}) CREATE (r)-[:MITIGATED_BY]->(ka);
MATCH (r:Risk {category:'financial'}), (ka:KeyActivity {name:'Enterprise Field Sales Motions'}) CREATE (r)-[:MITIGATED_BY]->(ka);

// LAYER 9‚ COMPLIANCE, SUSTAINABILITY & SECURITY

CREATE (gdpr:RegulatoryFramework:GenericallydependentContinuant { name:'GDPR', jurisdiction:'EU', domain:'data_privacy', effective_date:date('2018-05-25'), version:'2016/679' });
CREATE (soc2:RegulatoryFramework:GenericallydependentContinuant { name:'SOC 2 Type II', jurisdiction:'US', domain:'cyber', effective_date:date('2019-01-01'), version:'2017' });
CREATE (fedRamp:RegulatoryFramework:GenericallydependentContinuant { name:'FedRAMP Moderate', jurisdiction:'US', domain:'cyber', effective_date:date('2020-01-01'), version:'Rev5' });

MATCH (p:Product), (r:RegulatoryFramework) WHERE p.name IN ['Vault','Terraform Cloud'] AND r.name IN ['GDPR','SOC 2 Type II'] CREATE (p)-[:REGULATED_BY]->(r);
MATCH (p:Product {name:'Vault'}), (r:RegulatoryFramework {name:'FedRAMP Moderate'}) CREATE (p)-[:REGULATED_BY]->(r);

// HC-17: IPAsset GOVERNED_BY RegulatoryFramework
MATCH (ip:IPAsset {name:'HCL Specification'}), (r:RegulatoryFramework {name:'GDPR'}) CREATE (ip)-[:GOVERNED_BY]->(r);
MATCH (ip:IPAsset {name:'Sentinel Policy Engine'}), (r:RegulatoryFramework {name:'FedRAMP Moderate'}) CREATE (ip)-[:GOVERNED_BY]->(r);

CREATE (gdprCompliance:ComplianceStrategy:DependentContinuant { framework_ref:'GDPR', status:'compliant', gap_analysis:'DPA in place; data residency options for EU customers on HCP', cost:800000, responsible_owner:'Legal & Compliance Team' });
CREATE (soc2Compliance:ComplianceStrategy:DependentContinuant { framework_ref:'SOC2', status:'compliant', gap_analysis:'SOC 2 Type II certified annually since 2019', cost:350000, responsible_owner:'Security Team' });
CREATE (fedRampCompliance:ComplianceStrategy:DependentContinuant { framework_ref:'FedRAMP', status:'in_progress', gap_analysis:'Authorization in progress for Vault Enterprise; 12 open POAMs', remediation_plan:'Complete 3PAO assessment Q4 2023', cost:2500000, responsible_owner:'GovCloud Team' });
MATCH (o:Organization {name:'HashiCorp'}), (c:ComplianceStrategy) CREATE (o)-[:COMPLIES_VIA]->(c);

// Sustainability Layers 
CREATE (ossEcoSust:SustainabilityLayer:DependentContinuant { type:'social', circularity_score:0.65, impact_metrics:['contributor_retention_rate','community_health_score','knowledge_commons_contribution'], assumption_refs:[], notes:'Degraded post-BSL relicensing; community trust metric fell significantly in H2 2023' });
CREATE (cloudEffSust:SustainabilityLayer:DependentContinuant { type:'environmental', circularity_score:0.70, impact_metrics:['cloud_efficiency_score','infrastructure_waste_reduction'], notes:'HashiCorp products reduce cloud waste through better resource lifecycle management' });
MATCH (p:Product {name:'Terraform OSS'}), (s:SustainabilityLayer {type:'social'}) CREATE (p)-[:HAS_SUSTAINABILITY_LAYER]->(s);
MATCH (p:Product {name:'Terraform'}), (s:SustainabilityLayer {type:'environmental'}) CREATE (p)-[:HAS_SUSTAINABILITY_LAYER]->(s);

MATCH (a:Assumption {statement:'The open source contributor ecosystem will remain healthy without direct financial compensation to community contributors'}), (s:SustainabilityLayer {type:'social'}) CREATE (a)-[:RELATES_TO_SUSTAINABILITY]->(s);
MATCH (a:Assumption {statement:'MPL-2.0 license sufficiently deters hyperscalers from building competing managed services on HashiCorp OSS without contributing back'}), (s:SustainabilityLayer {type:'social'}) CREATE (a)-[:RELATES_TO_SUSTAINABILITY]->(s);

MATCH (s:SustainabilityLayer {type:'social'}), (e:Experiment {type:'MVP'}) CREATE (s)-[:EVIDENCED_BY]->(e);

CREATE (cyberProf:CybersecurityProfile:DependentContinuant { standard:'SOC2', status:'certified', maturity_level:4, avg_patch_time_hrs:48 });
MATCH (p:Product {name:'Vault'}), (c:CybersecurityProfile) CREATE (p)-[:HAS_SECURITY_PROFILE]->(c);

//  LAYER 10 - OPEN SOURCE & COMMUNITY                      

CREATE (tfHealth:CommunityHealthMetric:DependentContinuant { bus_factor_score:4, contributor_diversity_index:0.68, issue_response_time_hrs:48, PR_merge_rate:0.62, release_cadence:'monthly', fork_risk_score:8, notes:'Fork risk elevated post BSL-1.1 announcement Aug 2023; OpenTofu fork launched Oct 2023' });
CREATE (vaultHealth:CommunityHealthMetric:DependentContinuant { bus_factor_score:5, contributor_diversity_index:0.72, issue_response_time_hrs:36, PR_merge_rate:0.71, release_cadence:'monthly', fork_risk_score:2 });
MATCH (p:Product {name:'Terraform OSS'}), (h:CommunityHealthMetric {bus_factor_score:4}) CREATE (p)-[:HAS_COMMUNITY_HEALTH]->(h);
MATCH (p:Product {name:'Vault OSS'}), (h:CommunityHealthMetric {bus_factor_score:5}) CREATE (p)-[:HAS_COMMUNITY_HEALTH]->(h);

CREATE (tfContrib:ContributorJourney:Occurrent { stages:['awareness','first_contribution','regular_contributor','maintainer'], conversion_rates:[0.08,0.25,0.12,0.04], avg_time_per_stage:[30,90,180,365], drop_off_points:['first_PR_review_latency','complex_codebase_onboarding'], incentive_mechanisms:['public_recognition','HashiConf_speaking_slot','swag','career_visibility'] });
MATCH (p:Product {name:'Terraform OSS'}), (j:ContributorJourney) CREATE (p)-[:HAS_CONTRIBUTOR_FUNNEL]->(j);

CREATE (awsProvider:DownstreamDependency:IndependentContinuant { project_name:'AWS Terraform Provider', dependency_type:'direct', strategic_importance:'critical', communication_channel:'GitHub Issues + quarterly sync' });
CREATE (openTofu:DownstreamDependency:IndependentContinuant { project_name:'OpenTofu (CNCF fork)', dependency_type:'fork', strategic_importance:'critical', communication_channel:'None ‚ adversarial relationship post-BSL', notes:'Launched Oct 2023; CNCF sandbox project; drop-in Terraform replacement' });
CREATE (k8sOp:DownstreamDependency:IndependentContinuant { project_name:'Terraform Controller for Kubernetes', dependency_type:'transitive', strategic_importance:'medium', communication_channel:'GitHub' });
MATCH (p:Product {name:'Terraform OSS'}), (d:DownstreamDependency) CREATE (p)-[:DEPENDED_ON_BY]->(d);

CREATE (hashiOSS:OpenSourceStrategy:DependentContinuant { open_innovation_score:0.72, open_strategic_autonomy_score:0.88, governance_maturity_level:4, contribution_policy:'CLA required; HashiCorp retains copyright; community PRs welcomed for non-enterprise features' });
CREATE (corpSteward:GovernanceModel:GenericallydependentContinuant { type:'corporate_steward', decision_process:'HashiCorp core team controls roadmap; community advisory input via GitHub Issues and RFCs', membership_criteria:'Employee or approved external contributor with signed CLA', transparency_level:'medium' });
MATCH (o:Organization {name:'HashiCorp'}), (s:OpenSourceStrategy) CREATE (o)-[:FOLLOWS_OSS_STRATEGY]->(s);
MATCH (s:OpenSourceStrategy), (g:GovernanceModel) CREATE (s)-[:GOVERNED_BY_MODEL]->(g);

CREATE (hashiConf22:CommunityEngagement:Occurrent { type:'event', sentiment_score:0.82, retention_rate:0.71, notes:'HashiConf 2022 ‚ 4000+ attendees; major Terraform 1.3 and Vault 1.12 announcements' });
MATCH (o:Organization {name:'HashiCorp'}), (e:CommunityEngagement) CREATE (o)-[:ENGAGES_COMMUNITY]->(e);

// LAYER 11 - METRICS

CREATE (downloadsM:Metric:DependentContinuant { name:'Terraform Total Downloads', category:'community', unit:'count', target_value:120000000, current_value:100000000, frequency:'cumulative' });
CREATE (arrM:Metric:DependentContinuant { name:'Annual Recurring Revenue', category:'financial', unit:'USD', target_value:400000000, current_value:320000000, frequency:'annual' });
CREATE (npsM:Metric:DependentContinuant { name:'Net Promoter Score ‚ Terraform Cloud', category:'product_health', unit:'score', target_value:75, current_value:68, frequency:'quarterly' });
CREATE (convM:Metric:DependentContinuant { name:'OSS to Paid Conversion Rate', category:'AARRR', unit:'ratio', target_value:0.05, current_value:0.038, frequency:'monthly' });
MATCH (p:Product {name:'Terraform'}), (m:Metric {name:'Terraform Total Downloads'}) CREATE (p)-[:MEASURED_BY]->(m);
MATCH (o:Organization {name:'HashiCorp'}), (m:Metric {name:'Annual Recurring Revenue'}) CREATE (o)-[:MEASURED_BY]->(m);
MATCH (p:Product {name:'Terraform Cloud'}), (m:Metric) WHERE m.name IN ['Net Promoter Score ‚ Terraform Cloud','OSS to Paid Conversion Rate'] CREATE (p)-[:MEASURED_BY]->(m);

// LAYER 12 - META-FRAMWORK

CREATE (bmc:Framework:GenericallydependentContinuant { name:'Business Model Canvas', type:'canvas', version:'2010', building_blocks:['Key Partners','Key Activities','Key Resources','Value Propositions','Customer Relationships','Channels','Customer Segments','Cost Structure','Revenue Streams'] });
CREATE (lean:Framework:GenericallydependentContinuant { name:'Lean Canvas', type:'canvas', version:'2012', building_blocks:['Problem','Solution','Key Metrics','Unique Value Proposition','Unfair Advantage','Channels','Customer Segments','Cost Structure','Revenue Streams'] });
CREATE (vpc:Framework:GenericallydependentContinuant { name:'Value Proposition Canvas', type:'canvas', version:'2014', building_blocks:['Customer Jobs','Pains','Gains','Products & Services','Pain Relievers','Gain Creators'] });
CREATE (mn:Framework:GenericallydependentContinuant { name:'Market Navigator', type:'navigator', version:'2019', building_blocks:['Market Definition','Accessibility Scoring','Stage Decision','Trend Analysis'] });

CREATE (bbVP:BuildingBlock:GenericallydependentContinuant { name:'Value Propositions', framework_ref:'Business Model Canvas', required_entity_types:['ValueProposition'], mapping_rules:'All ValueProposition nodes for target product' });
CREATE (bbCS:BuildingBlock:GenericallydependentContinuant { name:'Customer Segments', framework_ref:'Business Model Canvas', required_entity_types:['CustomerSegment'], mapping_rules:'All CustomerSegment nodes via SERVES_SEGMENT' });
CREATE (bbProb:BuildingBlock:GenericallydependentContinuant { name:'Problem', framework_ref:'Lean Canvas', required_entity_types:['PainPoint'], mapping_rules:'PainPoint severity=critical via EXPERIENCES_PAIN from target segments' });
CREATE (bbMkt:BuildingBlock:GenericallydependentContinuant { name:'Market Definition', framework_ref:'Market Navigator', required_entity_types:['Market','MarketOpportunity','MarketAccessibility'], mapping_rules:'Market with TAM/SAM/SOM linked to opportunity and accessibility nodes' });

MATCH (bb:BuildingBlock {name:'Value Propositions'}), (f:Framework {name:'Business Model Canvas'}) CREATE (bb)-[:BLOCK_BELONGS_TO]->(f);
MATCH (bb:BuildingBlock {name:'Customer Segments'}), (f:Framework {name:'Business Model Canvas'}) CREATE (bb)-[:BLOCK_BELONGS_TO]->(f);
MATCH (bb:BuildingBlock {name:'Problem'}), (f:Framework {name:'Lean Canvas'}) CREATE (bb)-[:BLOCK_BELONGS_TO]->(f);
MATCH (bb:BuildingBlock {name:'Market Definition'}), (f:Framework {name:'Market Navigator'}) CREATE (bb)-[:BLOCK_BELONGS_TO]->(f);

MATCH (vp:ValueProposition {differentiation_type:'multi_cloud_breadth'}), (bb:BuildingBlock {name:'Value Propositions'}) CREATE (vp)-[:MAPS_TO_BLOCK]->(bb);
MATCH (s:CustomerSegment {name:'Enterprise Platform Engineering Teams'}), (bb:BuildingBlock {name:'Customer Segments'}) CREATE (s)-[:MAPS_TO_BLOCK]->(bb);
MATCH (p:PainPoint {description:'Infrastructure drift: manually managed configs diverge from desired state, causing outages'}), (bb:BuildingBlock {name:'Problem'}) CREATE (p)-[:MAPS_TO_BLOCK]->(bb);
MATCH (m:Market {name:'Enterprise Infrastructure Automation'}), (bb:BuildingBlock {name:'Market Definition'}) CREATE (m)-[:MAPS_TO_BLOCK]->(bb);

CREATE (effPhase:StrategyPhase:Occurrent { name:'efficiency', start_date:date('2020-01-01'), end_date:date('2023-12-31'), applicable_frameworks:['Business Model Canvas','Lean Canvas','Market Navigator'] });
MATCH (f:Framework), (sp:StrategyPhase {name:'efficiency'}) WHERE f.name IN ['Business Model Canvas','Lean Canvas','Market Navigator'] CREATE (f)-[:APPLICABLE_IN_PHASE]->(sp);

// TEMPORAL EVOLUTION (EVOLVES_TO) 
// Record the MPL-2.0 ‚ BSL-1.1 license change for Terraform OSS
MATCH (oss:Product {name:'Terraform OSS'}), (bsl:License {spdx_id:'BSL-1.1'})
CREATE (oss)-[:EVOLVES_TO {
  _change_reason: 'BSL-1.1 relicensing to prevent hyperscaler competitive use; announced Aug 10 2023',
  _valid_from: date('2023-08-10')
}]->(bsl);

// Record governance model transparency downgrade
MATCH (g:GovernanceModel {type:'corporate_steward'})
CREATE (g2:GovernanceModel:GenericallydependentContinuant {
  type: 'corporate_steward',
  decision_process: 'HashiCorp unilateral license change without community vote; reduced trust',
  transparency_level: 'low',
  _version: 2,
  _valid_from: date('2023-08-10')
})
CREATE (g)-[:EVOLVES_TO {_change_reason:'BSL relicensing bypassed community RFC process', _valid_from:date('2023-08-10')}]->(g2);




// ============================================================
// SAMPLE CONSTRAINT VALIDATION QUERIES
// ============================================================

// HC-01: Products without customer segments
// MATCH (p:Product) WHERE NOT (p)-[:SERVES_SEGMENT]->(:CustomerSegment) AND NOT (p)-[:VARIANT_OF]->() RETURN p.name AS violation, 'HC-01' AS constraint;

// HC-12: Assumptions with invalid assumption_type
// MATCH (a:Assumption) WHERE NOT a.assumption_type IN ['desirability','feasibility','viability','scalability','sustainability'] RETURN a.statement, a.assumption_type, 'HC-12' AS constraint;

// SC-03 (per-segment): CAC > LTV/3
// MATCH (ue:UnitEconomics) WHERE ue.cac_usd > ue.ltv_usd / 3 RETURN ue.cohort_id, ue.cac_usd, ue.ltv_usd, 'SC-03 violation' AS flag;

// SC-16: Fork risk exceeds 7 (should auto-generate risk node)
// MATCH (h:CommunityHealthMetric) WHERE h.fork_risk_score > 7 MATCH (p:Product)-[:HAS_COMMUNITY_HEALTH]->(h) RETURN p.name, h.fork_risk_score, 'SC-16: fork risk critical' AS flag;

// CQ-21: Bus factor and fork risk
// MATCH (p:Product)-[:HAS_COMMUNITY_HEALTH]->(h:CommunityHealthMetric) RETURN p.name, h.bus_factor_score, h.fork_risk_score ORDER BY h.fork_risk_score DESC;

// CQ-15: Funding history
// MATCH (o:Organization {name:'HashiCorp'})-[:FUNDED_BY]->(i:Investment)-[:WITHIN_ROUND]->(r:FundingRound) RETURN r.round_type, r.raised_amount, r.valuation, r.close_date ORDER BY r.close_date;

// Canvas generation: Lean Canvas for Terraform
// MATCH (f:Framework {name:'Lean Canvas'})-[:BLOCK_BELONGS_TO]-(bb:BuildingBlock) MATCH (p:Product {name:'Terraform'}) WITH bb, p OPTIONAL MATCH (p)-[:SERVES_SEGMENT]->(:CustomerSegment)<-[:HAS_STAKEHOLDER]-(st)-[:EXPERIENCES_PAIN]->(pp:PainPoint) WHERE bb.name = 'Problem' RETURN bb.name AS block, collect(DISTINCT pp.description) AS content;

//temporal evolution
MATCH (old)-[e:EVOLVES_TO]->(new) RETURN labels(old)[0] AS entity_type, old.name  AS from_state, new.name AS to_state, e._change_reason AS reason, e._valid_from  AS transition_date ORDER BY e._valid_from

//cross framework consistency checking
MATCH (cs:CustomerSegment)<-[:SERVES_SEGMENT]-(p:Product) WHERE NOT EXISTS { MATCH (cs)<-[:PROPOSES_VALUE_TO]-(vp:ValueProposition) -[:RESOLVES]->(pp:PainPoint) <-[:EXPERIENCES_PAIN]-(st:Stakeholder) <-[:HAS_STAKEHOLDER]-(cs) } RETURN cs.name AS orphaned_segment, 'No VP resolves segment pains' AS inconsistency

//Gap detection
MATCH (cs:CustomerSegment) WHERE NOT (cs)-[:HAS_STAKEHOLDER]->() RETURN cs.name AS entity, 'No stakeholders' AS gap UNION ALL MATCH (pm:PricingModel) WHERE NOT (pm)-[:HAS_ASSUMPTION]->()RETURN pm.type AS entity, 'No pricing assumptions' AS gap UNION ALL MATCH (sl:SustainabilityLayer) WHERENOT (sl)<-[:RELATES_TO_SUSTAINABILITY]-(:Assumption) RETURN sl.type AS entity, 'No sustainability assumption linked' AS gap
