# Novartis Clinical Trials Data Warehouse

## 🏗️ Medallion Architecture Implementation

A comprehensive data warehouse solution for clinical trial operational metrics, implementing the Bronze-Silver-Gold medallion architecture pattern.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Data Sources](#data-sources)
- [Installation](#installation)
- [Usage](#usage)
- [Layer Details](#layer-details)
- [Key Metrics](#key-metrics)
- [Project Structure](#project-structure)

---

## Overview

This data warehouse integrates clinical trial data from multiple sources to:

- **Generate actionable insights** for Data Quality Teams (DQT), Clinical Research Associates (CRAs), and Investigational Sites
- **Detect operational bottlenecks** through automated data quality monitoring
- **Support scientific decision-making** with derived metrics and risk scoring
- **Enable AI/LLM integration** with a clean, standardized data layer

### Key Features

✅ Data Quality Index (DQI) calculation  
✅ Clean Patient Status derivation  
✅ Site risk level classification  
✅ Interim/Submission readiness assessment  
✅ Automated ETL orchestration  

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        DATA SOURCES                                  │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │Rave EDC │ │  CPMD   │ │   SSM   │ │Lab Sys  │ │ eSAE    │       │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘       │
└───────┼───────────┼───────────┼───────────┼───────────┼─────────────┘
        │           │           │           │           │
        ▼           ▼           ▼           ▼           ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     🥉 BRONZE LAYER                                  │
│                    Raw Data Ingestion                                │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ • 132 CSV files across 11 data categories                    │   │
│  │ • 22 clinical studies                                        │   │
│  │ • Data preserved as-is from source systems                   │   │
│  │ • VARCHAR types for flexibility                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     🥈 SILVER LAYER                                  │
│                 Cleansed & Standardized                              │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ • Data type conversions (dates, integers, floats)            │   │
│  │ • Null handling & default values                             │   │
│  │ • ID normalization (Site XX, Subject XX)                     │   │
│  │ • Cross-study standardization                                │   │
│  │ • Audit timestamps (dwh_create_date)                         │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     🥇 GOLD LAYER                                    │
│                 Business-Ready Analytics                             │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ • Subject Data Quality (Clean Patient Status, DQI)           │   │
│  │ • Site Performance Summary (Risk Levels)                     │   │
│  │ • Study Overview Dashboard (Readiness Indicators)            │   │
│  │ • Visit Overdue Tracking (Priority Classification)           │   │
│  │ • Coding Completion Summary (MedDRA & WHO Drug)              │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Data Sources

| Source | Description | Files |
|--------|-------------|-------|
| `cpid_edc_subject_metrics` | Core EDC metrics per subject | 18 |
| `globalcodingreport_meddra` | MedDRA adverse event coding | 18 |
| `globalcodingreport_whodra` | WHO Drug medication coding | 19 |
| `inactivated_forms_loglines` | Deactivated records tracking | 13 |
| `compiled_edrr` | 3rd party reconciliation issues | 12 |
| `sae_dashboard_safety` | Safety team SAE reviews | 11 |
| `sae_dashboard_dm` | Data management SAE reviews | 10 |
| `missing_pages_all` | Global missing CRF pages | 10 |
| `missing_pages_visit_level` | Visit-level data gaps | 8 |
| `visit_projection_tracker` | Overdue visit monitoring | 7 |
| `missing_lab_ranges` | Lab data quality issues | 6 |

**Total: 132 CSV files covering 22 studies**

---

## Installation

### Prerequisites

- SQL Server 2016 or later
- Windows OS (for BULK INSERT file paths)
- Data files placed in `C:\DataWarehouseNovartis\`

### Setup Steps

```sql
-- 1. Create database and schemas
:r scripts/init_database.sql

-- 2. Create Bronze layer tables
:r scripts/bronze/ddl_bronze.sql

-- 3. Create Bronze stored procedures
:r scripts/bronze/stored_procedures/load_cpid_edc_subject_metrics.sql
:r scripts/bronze/stored_procedures/compiled_edrr.sql
-- ... (all other bronze procedures)

-- 4. Create Silver layer tables
:r scripts/silver/ddl_silver.sql

-- 5. Create Silver stored procedures
:r scripts/silver/stored_procedures/silver.cpid_edc_subject_metrics.sql
-- ... (all other silver procedures)

-- 6. Create Gold layer tables
:r scripts/gold/ddl_gold.sql

-- 7. Create Gold stored procedures
:r scripts/gold/stored_procedures/gold.subject_data_quality.sql
-- ... (all other gold procedures)

-- 8. Create ETL orchestration
:r scripts/run_etl.sql
```

---

## Usage

### Run Full ETL Pipeline

```sql
-- Execute complete Bronze -> Silver -> Gold pipeline
EXEC dbo.run_full_etl;
```

### Run Individual Layers

```sql
-- Bronze only (raw data ingestion)
EXEC dbo.run_bronze_etl;

-- Silver only (transformation)
EXEC dbo.run_silver_etl;

-- Gold only (aggregation)
EXEC dbo.run_gold_etl;

-- Skip Bronze, run Silver + Gold
EXEC dbo.run_full_etl @load_bronze = 0, @load_silver = 1, @load_gold = 1;
```

### Query Gold Layer Analytics

```sql
-- Study-level overview
SELECT * FROM gold.study_overview;

-- Sites requiring attention
SELECT * FROM gold.site_performance_summary 
WHERE risk_level IN ('High', 'Critical');

-- Clean patient status
SELECT study_id, 
       COUNT(*) AS total_subjects,
       SUM(CASE WHEN is_clean_patient = 1 THEN 1 ELSE 0 END) AS clean_patients,
       AVG(data_quality_index) AS avg_dqi
FROM gold.subject_data_quality
GROUP BY study_id;

-- Overdue visits by priority
SELECT priority_level, COUNT(*) AS count
FROM gold.visit_overdue_summary
GROUP BY priority_level;
```

---

## Layer Details

### Bronze Layer

Raw data ingestion preserving source format:
- VARCHAR types for all fields
- No transformations applied
- Source file structure maintained

### Silver Layer Transformations

| Transformation | Description |
|----------------|-------------|
| Data Type Conversion | Dates, integers, floats properly typed |
| ID Normalization | `Site XX`, `Subject XX` format |
| Null Handling | Default values for required fields |
| Whitespace Trimming | LTRIM/RTRIM on all strings |
| Status Standardization | Consistent status values |
| Audit Columns | `dwh_create_date` timestamp |

### Gold Layer Derived Metrics

#### Data Quality Index (DQI)

Weighted score (0-100) based on:
- Visit completion: 20%
- CRF cleanliness: 25%
- Query resolution: 20%
- Coding completion: 15%
- Signature compliance: 10%
- Issue resolution: 10%

#### Clean Patient Status

Patient is "clean" when:
- ✅ No missing visits
- ✅ No missing pages
- ✅ No open queries
- ✅ No non-conformant data
- ✅ No uncoded terms
- ✅ All CRFs signed

#### Site Risk Classification

| Level | Criteria |
|-------|----------|
| Low | DQI ≥ 90%, Queries < 2/subject |
| Medium | DQI ≥ 75%, Queries < 5/subject |
| High | DQI ≥ 50%, Queries < 10/subject |
| Critical | DQI < 50% or Queries ≥ 10/subject |

#### Readiness Indicators

**Interim Analysis Ready:**
- DQI ≥ 70%
- Visit completion ≥ 80%
- Coding completion ≥ 90%

**Submission Ready:**
- DQI ≥ 85%
- Visit completion ≥ 95%
- Coding completion ≥ 99%
- No critical-risk sites

---

## Project Structure

```
DataWarehouseNovartis/
├── README.md
├── scripts/
│   ├── init_database.sql           # Database & schema creation
│   ├── run_etl.sql                 # Master ETL orchestration
│   │
│   ├── bronze/
│   │   ├── ddl_bronze.sql          # Bronze table definitions
│   │   └── stored_procedures/
│   │       ├── load_cpid_edc_subject_metrics.sql
│   │       ├── compiled_edrr.sql
│   │       ├── globalcodingreport_meddra.sql
│   │       ├── globalcodingreport_whodra.sql
│   │       ├── inactivated_forms_loglines.sql
│   │       ├── missing_lab_ranges.sql
│   │       ├── missing_pages_all.sql
│   │       ├── missing_pages_visit_level.sql
│   │       ├── sae_dashboard_dm.sql
│   │       ├── sae_dashboard_safety.sql
│   │       └── visit_projection_tracker.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql          # Silver table definitions
│   │   ├── stored_procedures/
│   │   │   ├── silver.cpid_edc_subject_metrics.sql
│   │   │   ├── silver.compiled_edrr.sql
│   │   │   ├── silver.globalcodingreport_meddra.sql
│   │   │   ├── silver.globalcodingreport_whodra.sql
│   │   │   ├── silver.inactivated_forms_loglines.sql
│   │   │   ├── silver.missing_lab_ranges.sql
│   │   │   ├── silver.missing_pages_all.sql
│   │   │   ├── silver.missing_pages_visit_level.sql
│   │   │   ├── silver.sae_dashboard_dm.sql
│   │   │   ├── silver.sae_dashboard_safety.sql
│   │   │   └── silver.visit_projection_tracker.sql
│   │   └── tests/
│   │       └── test.inactivated_forms_loglines.sql
│   │
│   └── gold/
│       ├── ddl_gold.sql            # Gold table definitions
│       └── stored_procedures/
│           ├── gold.subject_data_quality.sql
│           ├── gold.site_performance_summary.sql
│           ├── gold.study_overview.sql
│           ├── gold.visit_overdue_summary.sql
│           └── gold.coding_completion_summary.sql
```

---

## Scientific Questions Addressed

This data warehouse enables answering:

1. **Which sites/patients have the most missing visits/pages or unresolved queries?**
   → `gold.subject_data_quality`, `gold.site_performance_summary`

2. **Where are the highest rates of non-conformant data?**
   → `gold.site_performance_summary.total_crfs_with_issues`

3. **Which sites/CRAs are underperforming based on current metrics?**
   → `gold.site_performance_summary.risk_level`

4. **Where are the most open issues in lab reconciliation or coding?**
   → `gold.coding_completion_summary`, `silver.missing_lab_ranges`

5. **Which sites require immediate attention based on current data?**
   → `gold.site_performance_summary WHERE risk_level = 'Critical'`

6. **Is the current data snapshot clean enough for interim analysis or submission?**
   → `gold.study_overview.is_interim_ready`, `is_submission_ready`

---

## Future Enhancements

- [ ] Query aging analysis implementation
- [ ] Incremental loading (CDC)
- [ ] Historical snapshots for trend analysis
- [ ] Power BI / Tableau dashboard integration
- [ ] AI/ML model integration for predictive risk scoring
- [ ] REST API layer for real-time access

---

## License

Proprietary - Novartis Clinical Data Management

---

*Last Updated: January 2026*
