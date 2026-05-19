-- Аналіз для бюджетних рекомендацій
-- Dataset: hw-skelar.marketing_report
-- Базова таблиця: marketing_dashboard_base
--
-- Рекомендації базуються на mature 90-day revenue cohorts.
-- Decision period: 2025-11-01 — 2026-01-31.
-- Цей період використовується, бо revenue_90d вже мав достатньо часу для дозрівання.

SELECT
  channel,
  SUM(spend) AS total_spend,
  SUM(revenue_90d) AS total_revenue_90d,
  SAFE_DIVIDE(SUM(revenue_90d), SUM(spend)) AS roas,
  SUM(users) AS total_users,
  SUM(payers) AS total_payers,
  SAFE_DIVIDE(SUM(payers), SUM(users)) * 100 AS conversion_pct,
  SAFE_DIVIDE(SUM(revenue_90d), SUM(users)) AS arpu
FROM `hw-skelar.marketing_report.marketing_dashboard_base`
WHERE date BETWEEN '2025-11-01' AND '2026-01-31'
GROUP BY channel
ORDER BY roas DESC;
