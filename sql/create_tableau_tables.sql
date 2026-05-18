-- Tableau Base Tables
-- Проєкт: Monthly Marketing Performance Report
-- Dataset: hw-skelar.marketing_report
-- Джерела: spend, users
--
-- Мета:
-- 1. Створити основну таблицю для аналізу бюджету, ROAS, каналів і гео.
-- 2. Створити окрему таблицю для аналізу device_os без дублювання spend.

-- 1. Основна таблиця для Tableau:
-- Рівень агрегації: date x channel x geo
-- Використовується для KPI, аналізу каналів, geo x channel і рекомендацій по бюджету.

CREATE OR REPLACE TABLE `hw-skelar.marketing_report.marketing_dashboard_base` AS

WITH users_daily AS (
  SELECT
    registration_date AS date,
    channel,
    geo,
    COUNT(DISTINCT id_user) AS users,
    COUNT(DISTINCT IF(is_payer = 1, id_user, NULL)) AS payers,
    SUM(revenue_7d) AS revenue_7d,
    SUM(revenue_90d) AS revenue_90d
  FROM `hw-skelar.marketing_report.users`
  GROUP BY
    date,
    channel,
    geo
),

spend_daily AS (
  SELECT
    date,
    channel,
    geo,
    SUM(spend) AS spend
  FROM `hw-skelar.marketing_report.spend`
  GROUP BY
    date,
    channel,
    geo
)

SELECT
  s.date,
  s.channel,
  s.geo,
  s.spend,

  COALESCE(u.users, 0) AS users,
  COALESCE(u.payers, 0) AS payers,
  COALESCE(u.revenue_7d, 0) AS revenue_7d,
  COALESCE(u.revenue_90d, 0) AS revenue_90d,

  SAFE_DIVIDE(COALESCE(u.payers, 0), COALESCE(u.users, 0)) AS payer_conversion,
  SAFE_DIVIDE(COALESCE(u.revenue_7d, 0), s.spend) AS roas_7d,
  SAFE_DIVIDE(COALESCE(u.revenue_90d, 0), s.spend) AS roas_90d,
  SAFE_DIVIDE(s.spend, COALESCE(u.users, 0)) AS cost_per_user,
  SAFE_DIVIDE(s.spend, COALESCE(u.payers, 0)) AS cost_per_payer,
  SAFE_DIVIDE(COALESCE(u.revenue_90d, 0), COALESCE(u.users, 0)) AS arpu_90d,
  SAFE_DIVIDE(COALESCE(u.revenue_90d, 0), COALESCE(u.payers, 0)) AS arppu_90d

FROM spend_daily s
LEFT JOIN users_daily u
  ON s.date = u.date
  AND s.channel = u.channel
  AND s.geo = u.geo;


-- 2. Таблиця для аналізу Device OS:
-- Рівень агрегації: date x channel x geo x device_os
-- Spend не додається, бо в spend.csv немає розрізу device_os.
-- Це дозволяє уникнути дублювання витрат.

CREATE OR REPLACE TABLE `hw-skelar.marketing_report.marketing_device_os_base` AS

SELECT
  registration_date AS date,
  channel,
  geo,
  device_os,

  COUNT(DISTINCT id_user) AS users,
  COUNT(DISTINCT IF(is_payer = 1, id_user, NULL)) AS payers,
  SUM(revenue_7d) AS revenue_7d,
  SUM(revenue_90d) AS revenue_90d,

  SAFE_DIVIDE(
    COUNT(DISTINCT IF(is_payer = 1, id_user, NULL)),
    COUNT(DISTINCT id_user)
  ) AS payer_conversion,

  SAFE_DIVIDE(SUM(revenue_90d), COUNT(DISTINCT id_user)) AS arpu_90d,

  SAFE_DIVIDE(
    SUM(revenue_90d),
    COUNT(DISTINCT IF(is_payer = 1, id_user, NULL))
  ) AS arppu_90d

FROM `hw-skelar.marketing_report.users`
GROUP BY
  date,
  channel,
  geo,
  device_os;
