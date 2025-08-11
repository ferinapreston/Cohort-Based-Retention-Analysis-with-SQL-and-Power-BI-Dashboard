# Cohort-Based-Retention-Analysis-with-SQL-and-Power-BI-Dashboard
# Cohort-Based Retention Analysis (SQL + Power BI)

**Goal:** Compute user retention cohorts from first purchase with SQL; visualize weekly retention via a Power BI heatmap + KPIs.

## SQL (MySQL)
- Uses temp tables to derive:
  - `first_week` = Monday-start week of first purchase
  - `order_week` = Monday-start week of each order
  - `week_index` = weeks since first purchase (0..10)
- Output: cohort table with distinct users per week_index.

Run order:
1) Load `data/Q1_orders.csv` into table `orders(id, user_id, total, created)`.
2) Execute `sql/retention.sql`.
3) Export the final SELECT to CSV for Power BI (or connect PBIX directly to database).

## Power BI
- Load `orders` (or the SQL result).
- Create calculated columns:
  - **FirstPurchaseDate** =
    `CALCULATE(MIN(Orders[created]), ALLEXCEPT(Orders, Orders[user_id]))`
  - **FirstWeek** = `STARTOFWEEK([FirstPurchaseDate], 2)`  
  - **OrderWeek** = `STARTOFWEEK(Orders[created], 2)`
  - **WeekIndex** =
    `INT(DIVIDE(DATEDIFF([FirstWeek], [OrderWeek], DAY), 7))`
- Measures:
  - **Retained Users** = `DISTINCTCOUNT(Orders[user_id])`
  - **Cohort Size** =
    `CALCULATE(DISTINCTCOUNT(Orders[user_id]), FILTER(ALL(Orders[WeekIndex]), Orders[WeekIndex]=0))`
  - **Retention %** = `DIVIDE([Retained Users], [Cohort Size])`
- Matrix visual:
  - Rows = **FirstWeek**
  - Columns = **WeekIndex**
  - Values = **Retention %** (show as %).  
  - Conditional formatting → Color scale (heatmap).
- Add cards/KPIs:
  - **Week 1 Retention %** =
    `CALCULATE([Retention %], FILTER(ALLSELECTED(Orders[WeekIndex]), Orders[WeekIndex]=1))`
  - **Week 4 Retention %** similarly with `=4`.
- Optional slicers: date range, user segment.

## Files
- `data/Q1_orders.csv` – sample orders
- `sql/retention.sql` – cohort logic
- `powerbi/CohortRetention.pbix` – dashboard
