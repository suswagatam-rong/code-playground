-- 1. CIF FLOW
SELECT 
    'CIF' AS source_type, 
    approver_approval_date, 
    APPROVER_REJECTED_DATE 
FROM ckyc_dashboard_base 
WHERE maker_id = '1084774' 
AND (account_type_flag IS NULL OR account_type_flag = 'NI') 
AND (
    approver_approval_date >= TO_DATE('2026-02-01', 'YYYY-MM-DD') 
    OR APPROVER_REJECTED_DATE >= TO_DATE('2026-02-01', 'YYYY-MM-DD') 
    OR (approver_approval_date IS NULL AND APPROVER_REJECTED_DATE IS NULL)
) 

UNION ALL 

-- 2. ACCOUNT FLOW (INDIVIDUAL)
SELECT 
    'ACCT' AS source_type, 
    approver_approval_date, 
    APPROVER_REJECTED_DATE 
FROM account_dashboard_base 
WHERE maker_id = '1084774' 
AND (
    approver_approval_date >= TO_DATE('2026-02-01', 'YYYY-MM-DD') 
    OR APPROVER_REJECTED_DATE >= TO_DATE('2026-02-01', 'YYYY-MM-DD') 
    OR (approver_approval_date IS NULL AND APPROVER_REJECTED_DATE IS NULL)
) 

UNION ALL 

-- 3. ACCOUNT FLOW (NON-INDIVIDUAL)
SELECT 
    'ACCT' AS source_type, 
    approver_approval_date, 
    APPROVER_REJECTED_DATE 
FROM account_dashboard_base_ni 
WHERE maker_id = '1084774' 
AND (
    approver_approval_date >= TO_DATE('2026-02-01', 'YYYY-MM-DD') 
    OR APPROVER_REJECTED_DATE >= TO_DATE('2026-02-01', 'YYYY-MM-DD') 
    OR (approver_approval_date IS NULL AND APPROVER_REJECTED_DATE IS NULL)
);
