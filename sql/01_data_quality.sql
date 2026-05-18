-- Data Quality Checks
-- Проєкт: Monthly Marketing Performance Report
-- Dataset: hw-skelar.marketing_report
-- Таблиці: spend, users

-- 1. Базовий профіль таблиць: кількість рядків і діапазон дат
SELECT
  'spend' AS table_name,
  COUNT(*) AS row_count,
  MIN(date) AS min_date,
  MAX(date) AS max_date
FROM `hw-skelar.marketing_report.spend`

UNION ALL

SELECT
  'users' AS table_name,
  COUNT(*) AS row_count,
  MIN(registration_date) AS min_date,
  MAX(registration_date) AS max_date
FROM `hw-skelar.marketing_report.users`;


-- 2. Перевірка NULL та невалідних числових значень
SELECT
  'spend' AS table_name,
  COUNTIF(date IS NULL) AS null_date,
  COUNTIF(channel IS NULL OR TRIM(channel) = '') AS null_channel,
  COUNTIF(geo IS NULL OR TRIM(geo) = '') AS null_geo,
  COUNTIF(spend IS NULL) AS null_value,
  COUNTIF(spend < 0) AS negative_value
FROM `hw-skelar.marketing_report.spend`

UNION ALL

SELECT
  'users' AS table_name,
  COUNTIF(registration_date IS NULL) AS null_date,
  COUNTIF(channel IS NULL OR TRIM(channel) = '') AS null_channel,
  COUNTIF(geo IS NULL OR TRIM(geo) = '') AS null_geo,
  COUNTIF(revenue_90d IS NULL) AS null_value,
  COUNTIF(revenue_90d < 0 OR revenue_7d < 0) AS negative_value
FROM `hw-skelar.marketing_report.users`;


-- 3. Перевірка значень is_payer
SELECT
  is_payer,
  COUNT(*) AS user_count
FROM `hw-skelar.marketing_report.users`
GROUP BY is_payer
ORDER BY is_payer;


-- 4. Перевірка дублікатів користувачів
SELECT
  COUNT(*) AS row_count,
  COUNT(DISTINCT id_user) AS unique_user_count,
  COUNT(*) - COUNT(DISTINCT id_user) AS duplicate_user_rows
FROM `hw-skelar.marketing_report.users`;


-- 5. Перевірка значень у довідникових полях: channel, geo, device_os
SELECT
  'spend_channel' AS field_name,
  channel AS value,
