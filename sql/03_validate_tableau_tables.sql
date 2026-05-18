-- Перевірка фінальних таблиць для Tableau
-- Dataset: hw-skelar.marketing_report
-- Таблиці:
-- - marketing_dashboard_base
-- - marketing_device_os_base

-- 1. Перевірка кількості рядків і діапазону дат
SELECT
  'marketing_dashboard_base' AS table_name,
  COUNT(*) AS row_count,
  MIN(date) AS min_date,
  MAX(date) AS max_date
FROM `hw-skelar.marketing_report.marketing_dashboard_base`

UNION ALL

SELECT
  'marketing_device_os_base' AS table
