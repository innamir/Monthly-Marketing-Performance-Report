# Підготовка таблиць для Tableau

## Джерела

У BigQuery використані дві сирі таблиці:

- `hw-skelar.marketing_report.spend`
- `hw-skelar.marketing_report.users`

Після перевірки якості даних створені дві таблиці для Tableau:

- `marketing_dashboard_base`
- `marketing_device_os_base`

## marketing_dashboard_base

Основна таблиця для аналізу бюджету, ROAS, каналів і гео.

Рівень агрегації: `date × channel × geo`

Логіка:

- `users` агрегується до рівня `registration_date × channel × geo`;
- `spend` агрегується до рівня `date × channel × geo`;
- таблиці з’єднуються через `date`, `channel`, `geo`;
- основою є `spend`, тому використовується `LEFT JOIN`.

Основні поля:

| field | description |
|---|---|
| date | дата |
| channel | маркетинговий канал |
| geo | гео |
| spend | витрати |
| users | кількість користувачів |
| payers | кількість платників |
| revenue_7d | виручка за 7 днів |
| revenue_90d | виручка за 90 днів |
| payer_conversion | конверсія в платника |
| roas_7d | ROAS на основі revenue_7d |
| roas_90d | ROAS на основі revenue_90d |
| cost_per_user | витрати на користувача |
| cost_per_payer | витрати на платника |
| arpu_90d | виручка на користувача |
| arppu_90d | виручка на платника |

## marketing_device_os_base

Окрема таблиця для аналізу `device_os`.

Рівень агрегації: `date × channel × geo × device_os`

Ця таблиця створена окремо, бо в `spend.csv` немає поля `device_os`. Якщо додати `device_os` до основної таблиці, spend буде дублюватися для кожної OS, що зламає ROAS.

Тому в OS-таблиці аналізуються:

- users;
- payers;
- payer_conversion;
- revenue_7d;
- revenue_90d;
- arpu_90d;
- arppu_90d.

Без прямого ROAS по OS.

## Використання в Tableau

| Sheet | Source table |
|---|---|
| KPI | `marketing_dashboard_base` |
| Channels | `marketing_dashboard_base` |
| Geo × Channel | `marketing_dashboard_base` |
| Device OS | `marketing_device_os_base` |

## Висновок

Для Tableau підготовлено дві таблиці: основну для бюджетних метрик і окрему для аналізу device_os. Такий підхід відповідає умові ДЗ і не створює дублювання витрат.
