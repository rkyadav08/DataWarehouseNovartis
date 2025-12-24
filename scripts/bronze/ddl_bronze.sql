IF OBJECT_ID('bronze.cpid_edc_subject_metrics', 'U') IS NOT NULL
    DROP TABLE bronze.cpid_edc_subject_metrics;
GO
CREATE TABLE bronze.cpid_edc_subject_metrics (
    study_id                VARCHAR(255),
    region                      VARCHAR(50),
    country                     VARCHAR(100),
    site_id                     VARCHAR(100),
    subject_id                  VARCHAR(100),
    latest_visit                VARCHAR(100),
    subject_status              VARCHAR(100),
    missing_visits              VARCHAR(50),
    missing_pages               VARCHAR(50),
    coded_terms                 VARCHAR(50),
    uncoded_terms               VARCHAR(50),
    open_issues_lnr             VARCHAR(50),
    open_issues_edrr            VARCHAR(50),
    inactivated_forms           VARCHAR(50),
    esae_review_dm              VARCHAR(50),
    esae_review_safety          VARCHAR(50),
    expected_visits             VARCHAR(50),
    pages_entered               VARCHAR(50),
    pages_non_conformant        VARCHAR(50),
    crfs_with_issues            VARCHAR(50),
    crfs_clean                  VARCHAR(50),
    percent_clean_crf           VARCHAR(50),
    dm_queries                  VARCHAR(50),
    clinical_queries            VARCHAR(50),
    medical_queries             VARCHAR(50),
    site_queries                VARCHAR(50),
    field_monitor_queries       VARCHAR(50),
    coding_queries              VARCHAR(50),
    safety_queries              VARCHAR(50),
    total_queries               VARCHAR(50),
    crfs_require_verification   VARCHAR(50),
    forms_verified              VARCHAR(50),
    crfs_frozen                 VARCHAR(50),
    crfs_not_frozen             VARCHAR(50),
    crfs_locked                 VARCHAR(50),
    crfs_unlocked               VARCHAR(50),
    pds_confirmed               VARCHAR(50),
    pds_proposed                VARCHAR(50),
    crfs_signed                 VARCHAR(50),
    crfs_overdue_45             VARCHAR(50),
    crfs_overdue_45_90           VARCHAR(50),
    crfs_overdue_90             VARCHAR(50),
    broken_signatures           VARCHAR(50),
    crfs_never_signed           VARCHAR(50)
);
GO
IF OBJECT_ID('bronze.visit_projection_tracker', 'U') IS NOT NULL
    DROP TABLE bronze.visit_projection_tracker;
GO
CREATE TABLE bronze.visit_projection_tracker (
	study_id            VARCHAR(100),
    country             VARCHAR(100),
    site_id            VARCHAR(100),
    subject_id          VARCHAR(100),
    visit          VARCHAR(255),
    projected_date      VARCHAR(50),
    days_outstanding    VARCHAR(50),
);
GO
IF OBJECT_ID('bronze.missing_lab_ranges', 'U') IS NOT NULL
    DROP TABLE bronze.missing_lab_ranges;
GO
CREATE TABLE bronze.missing_lab_ranges (
	study_id            VARCHAR(100),
    country             VARCHAR(100),
    site_id             VARCHAR(100),
    subject_id          VARCHAR(100),
    visit          VARCHAR(255),
    form_name           VARCHAR(255),
    lab_category        VARCHAR(100),
    lab_date            VARCHAR(50),
    test_name           VARCHAR(100),
    test_description    VARCHAR(255),
    issue               VARCHAR(255),
    comments            VARCHAR(255)
);
GO
IF OBJECT_ID('bronze.sae_dashboard_dm', 'U') IS NOT NULL
    DROP TABLE bronze.sae_dashboard_dm;
GO
CREATE TABLE bronze.sae_dashboard_dm (
    discrepancy_id      VARCHAR(100),
    study_id            VARCHAR(100),
    country             VARCHAR(100),
    site_id             VARCHAR(100),
    patient_id         VARCHAR(100),
    form_name           VARCHAR(255),
    discrepancy_ts      VARCHAR(50),
    review_status       VARCHAR(100),
    action_status       VARCHAR(100)
);
GO
IF OBJECT_ID('bronze.sae_dashboard_safety', 'U') IS NOT NULL
    DROP TABLE bronze.sae_dashboard_safety ;
GO
CREATE TABLE bronze.sae_dashboard_safety (
    discrepancy_id      VARCHAR(100),
    study_id           VARCHAR(100),
    site_id             VARCHAR(100),
    patient_id          VARCHAR(100),
    case_status         VARCHAR(100),
    discrepancy_ts      VARCHAR(50),
    review_status       VARCHAR(100),
    action_status       VARCHAR(100)
);
GO
IF OBJECT_ID('bronze.inactivated_forms_loglines', 'U') IS NOT NULL
    DROP TABLE bronze.inactivated_forms_loglines;
GO
CREATE TABLE bronze.inactivated_forms_loglines (
	study_id                VARCHAR(255),
    country                 VARCHAR(100),
    site_id               VARCHAR(255),
    subject_id              VARCHAR(100),
    folder            VARCHAR(255),
    form               VARCHAR(255),
    data_on_form      CHAR(5),      -- Y / N
    record_position         INTEGER,
    audit_action            VARCHAR(500)
);
GO
IF OBJECT_ID('bronze.missing_pages_all', 'U') IS NOT NULL
    DROP TABLE bronze.missing_pages_all;
GO
CREATE TABLE bronze.missing_pages_all (
    study_id                     VARCHAR(100),
    site_group                   VARCHAR(100),
    site_id                      VARCHAR(50),
    subject_id                   VARCHAR(100),

    overall_subject_status        VARCHAR(100),
    visit_level_subject_status    VARCHAR(100),   -- nullable (not always present)

    folder_name                   VARCHAR(200),
    page_name                     VARCHAR(100),

    visit_date_raw                VARCHAR(50),   -- Summary Page / Visit Level

    days_page_missing             INT,
);

GO
IF OBJECT_ID('bronze.missing_pages_visit_level', 'U') IS NOT NULL
    DROP TABLE bronze.missing_pages_visit_level;
GO
CREATE TABLE bronze.missing_pages_visit_level (
    study_id                     VARCHAR(100),
    site_group                   VARCHAR(100),
    site_id                      VARCHAR(50),
    subject_id                   VARCHAR(100),

    overall_subject_status        VARCHAR(100),
    visit_level_subject_status    VARCHAR(100),
    form_subject_status           VARCHAR(100),

    visit_name                    VARCHAR(200),
    folder_name                   VARCHAR(200),
    form_name                     VARCHAR(100),

    visit_date                VARCHAR(50),

    days_page_missing             INT,
);



GO

IF OBJECT_ID('bronze.compiled_edrr', 'U') IS NOT NULL
    DROP TABLE bronze.compiled_edrr;
GO

CREATE TABLE bronze.compiled_edrr(
    study_id             NVARCHAR(50),
    subject_id       NVARCHAR(50),
    total_open_issue_count_per_subject      NVARCHAR(50)
);
GO
IF OBJECT_ID('bronze.globalcodingreport_meddra', 'U') IS NOT NULL
    DROP TABLE bronze.globalcodingreport_meddra;
GO
CREATE TABLE bronze.globalcodingreport_meddra (
    report_type         VARCHAR(100),
    study_id            VARCHAR(100),
    dictionary          VARCHAR(100),
    dictionary_version  VARCHAR(50),
    subject_id          VARCHAR(100),
    form_oid            VARCHAR(100),
    logline             VARCHAR(50),
    field_oid           VARCHAR(100),
    coding_status       VARCHAR(100),
    require_coding      VARCHAR(100)
);
GO
IF OBJECT_ID('bronze.globalcodingreport_whodra', 'U') IS NOT NULL
    DROP TABLE bronze.globalcodingreport_whodra;
GO
CREATE TABLE bronze.globalcodingreport_whodra (
    report_type         VARCHAR(100),
    study_id            VARCHAR(100),
    dictionary          VARCHAR(100),
    dictionary_version  VARCHAR(50),
    subject_id          VARCHAR(100),
    form_oid            VARCHAR(100),
    logline             VARCHAR(50),
    field_oid           VARCHAR(100),
    coding_status       VARCHAR(100),
    require_coding      VARCHAR(100)
);
GO
