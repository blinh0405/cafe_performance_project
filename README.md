# Coffee Shop In-Store Sales Analysis (SQL)

## Project Overview
This project analyzes coffee shop transaction data using SQL to evaluate in-store sales performance, product demand, payment behavior, purchase channels, and store-level revenue trends.

The project was designed to simulate a multi-location retail analysis environment and demonstrate business analytics skills relevant to FP&A, commercial finance, and operations strategy.

## Objectives
- Analyze transaction-level sales performance
- Identify top-selling products and revenue drivers
- Compare store-level performance across 9 operating locations
- Evaluate payment and purchase channel behavior
- Build a simple profitability model using estimated product costs
- Prepare monthly revenue trends for forecasting

## Dataset
The original dataset contained transaction-level fields for:
- Transaction ID
- Product
- Quantity
- Unit Price
- Total Price
- Payment Method
- Purchase Type
- Order Date

A simulated `store_location` column was added to support multi-store portfolio analysis.

## Key Business Questions
- What are the top-selling products by volume and revenue?
- Which stores generate the highest sales?
- Which purchase channel performs best?
- Which payment methods are most commonly used?
- What are the monthly revenue trends?
- Which products and stores contribute the most estimated gross profit?

## Tools Used
- SQLite
- VS Code
- SQL

## SQL Analysis Sections
1. Data cleaning and schema correction
2. KPI summary
3. Product analysis
4. Store performance analysis
5. Payment and channel analysis
6. Profitability modeling
7. Monthly trend analysis

## Key Insights
- Coffee and core espresso-based drinks generated the highest unit sales
- Store-level revenue varied meaningfully across the simulated 9-location portfolio
- Takeaway transactions drove a significant share of sales
- Product-level gross margin analysis highlighted the strongest contributors to estimated profit

## Files
- `01_data_cleaning.sql`: rebuilds the raw table into a usable schema
- `02_kpi_analysis.sql`: headline performance metrics
- `03_store_analysis.sql`: store and product performance
- `04_profitability_analysis.sql`: estimated cost and margin analysis
- `05_forecasting_prep.sql`: monthly revenue trend outputs

## Notes
This project uses estimated product cost assumptions and simulated store locations for portfolio demonstration purposes.
