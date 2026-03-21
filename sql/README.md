# SQL Scripts Organization

This folder contains all SQL Server scripts for the Northwind Data Analysis project.

## 📁 Folder Structure

```
sql/
├── database/                 # Database setup
│   └── Database Script - Northwind.sql
├── views/                   # SQL Views for Power BI
│   └── Create View scipt for Dashboard.sql
├── queries/                 # Analysis Queries
│   ├── KPIs.sql
│   ├── Adhoc Queries.sql
│   └── Interesting Insights.sql
└── README.md               # This file
```

## 📋 File Descriptions

### Database Setup

#### Database Script - Northwind.sql
- **Purpose**: Creates and populates the complete Northwind database
- **Contents**:
  - Database creation
  - Table creation with schema
  - Primary key definitions
  - Foreign key relationships
  - Sample data population
  - Index creation
  - View definitions
- **Dependencies**: None (standalone script)
- **Execution Time**: 1-2 minutes
- **When to Use**: 
  - Initial database setup
  - Restore from backup
  - Dev environment setup

**To Run**:
```sql
-- Open in SSMS
-- Select all or run entire script
-- Press F5 or click Execute
```

---

### Views for Power BI

#### Create View scipt for Dashboard.sql
- **Purpose**: Creates optimized SQL views for Power BI consumption
- **Contents**:
  - Aggregated sales views
  - Customer summary views
  - Product performance views
  - Employee metrics views
  - Time-series views for trend analysis
- **Dependencies**: Northwind database must exist first
- **Execution Time**: < 1 minute
- **When to Use**:
  - After database creation
  - When rebuilding Power BI connections
  - After data structure changes

**Typical Views**:
- VW_SalesByProduct
- VW_SalesByCustomer
- VW_EmployeePerformance
- VW_SalesTrend
- VW_OrderDetails

**To Run**:
```sql
-- Prerequisites: Run Database Script first
-- Then run this view creation script
-- Verify views created in Object Explorer
```

---

### Analysis Queries

#### KPIs.sql
- **Purpose**: Calculates Key Performance Indicators and business metrics
- **Queries Include**:
  - Total sales revenue
  - Average order value
  - Customer lifetime value
  - Sales by product, employee, region
  - Discount impact analysis
  - On-time delivery metrics
  - Profit calculations
- **Dependencies**: Northwind database
- **When to Use**: 
  - Monthly reporting
  - KPI tracking
  - Business metric verification
  - Dashboard validation

**Common Metrics**:
- Revenue summaries (daily/monthly/yearly)
- Customer analysis (count, value, segments)
- Product performance (top sellers, revenue)
- Employee metrics (sales, order count, performance)

**To Use**:
```sql
-- Open in SSMS
-- Select specific KPI query of interest
-- Run individual queries or all at once
-- Export results to Excel or Power BI
```

---

#### Adhoc Queries.sql
- **Purpose**: Exploratory data analysis and ad-hoc investigations
- **Queries Include**:
  - Quick data exploration
  - Trend analysis
  - Anomaly detection
  - Specific business questions
  - Data quality checks
  - Filtering and sorting examples
  - Comparison queries
- **Dependencies**: Northwind database
- **When to Use**:
  - Investigating specific questions
  - Data exploration
  - Testing hypotheses
  - One-time analysis
  - Learning SQL patterns

**Examples**:
- Find top customers in specific region
- Compare two time periods
- Identify slow-moving products
- Check for data inconsistencies
- Detail-level transaction analysis

**To Use**:
```sql
-- Open in SSMS
-- Find query matching your question
-- Modify parameters/filters as needed
-- Execute to get results
-- Can copy results to Excel for further analysis
```

---

#### Interesting Insights.sql
- **Purpose**: Pre-built analysis queries revealing business patterns
- **Queries Include**:
  - Seasonal trends
  - Customer concentration analysis
  - Product performance rankings
  - Geographic insights
  - Employee productivity comparisons
  - Revenue pattern analysis
  - Customer behavior patterns
- **Dependencies**: Northwind database
- **When to Use**:
  - Business intelligence reporting
  - Stakeholder presentations
  - Finding data stories
  - Identifying opportunities

**Insights Revealed**:
- Which products are most profitable
- Customer segments and behaviors
- Sales trends and seasonality
- Territory performance
- Untapped market opportunities

**To Use**:
```sql
-- Open in SSMS
-- Review insight queries of interest
-- Run to see key findings
-- Use results for presentations
-- Reference in strategy documents
```

---

## 🚀 Quick Start Guide

### First Time Setup

1. **Create Database**
   ```
   1. Open SSMS
   2. Open: sql/database/Database Script - Northwind.sql
   3. Execute all (F5)
   4. Verify: View Object Explorer → Databases → Northwind
   ```

2. **Create Views**
   ```
   1. Open: sql/views/Create View scipt for Dashboard.sql
   2. Execute all (F5)
   3. Verify: View Object Explorer → Databases → Northwind → Views
   ```

3. **Connect Power BI**
   ```
   1. Open Power BI Dashboard (dashboards/Dashboard.pbix)
   2. Select Northwind database
   3. Dashboard should load with data
   ```

### Ongoing Usage

**For Analysis**:
- Open Adhoc Queries.sql for exploration
- Run KPIs.sql for metrics
- Reference Interesting Insights.sql for patterns

**For Troubleshooting**:
- Verify database exists: (Should see in Object Explorer)
- Verify views exist: Check under Databases → Views
- Run sample query: SELECT TOP 10 * FROM Customers;

---

## 📚 SQL Concepts Used

### Query Types
- **SELECT**: Data retrieval and filtering
- **JOIN**: Combining data from multiple tables
- **GROUP BY**: Aggregating data by categories
- **WINDOW Functions**: Advanced aggregations (RANK, ROW_NUMBER)
- **CTE (Common Table Expressions)**: Complex query organization
- **Subqueries**: Nested data analysis

### Aggregation Functions
- **SUM**: Total values
- **COUNT**: Number of records
- **AVG**: Average values
- **MIN/MAX**: Minimum/maximum values
- **GROUP_CONCAT**: Concatenate values

### Performance Considerations
- Queries optimized for Northwind database size
- Most queries execute in < 5 seconds
- Views pre-computed for Power BI efficiency
- Indexes created on frequently queried columns

---

## 🔧 Customization

### Modifying Queries

**Change Date Range**:
```sql
-- Original
WHERE OrderDate >= '2024-01-01'

-- Modify to different period
WHERE OrderDate >= '2024-06-01'
```

**Filter by Region**:
```sql
-- Add region filter
WHERE Region = 'North America'
```

**Adjust Top N**:
```sql
-- Original: Top 10
SELECT TOP 10 ...

-- Change to Top 5 or Top 20
SELECT TOP 20 ...
```

### Adding New Queries
- Follow existing query structure
- Include comments explaining purpose
- Test before using in reports
- Add to relevant file (KPIs, Adhoc, or Insights)

---

## 📊 Integration with Other Tools

### Power BI Connection
- Power BI connects directly to SQL views
- Use views instead of raw tables
- Supports real-time and scheduled refresh
- See dashboards/README.md for connection details

### Excel Integration
```
1. Open Excel
2. Data → New Query → From SQL Server
3. Enter server and database name
4. Select tables or views to import
5. Load data into Excel workbooks
```

### Git Version Control
- SQL files tracked in Git
- Change history preserved
- Easy rollback if needed
- Collaboration enabled

---

## 🐛 Troubleshooting

### Query Won't Execute

**Problem**: Syntax error or table not found

**Solutions**:
1. Verify database exists and is selected
2. Check table names spelling
3. Run database creation script again
4. Verify foreign key table relationships

**Error Message**: "Invalid object name 'Customers'"
- **Solution**: Use fully qualified name: Northwind.dbo.Customers

---

### Performance Issues

**Problem**: Query runs slowly

**Solutions**:
1. Reduce date range being queried
2. Add WHERE clause to filter data
3. Check for large full table scans
4. Verify indexes exist on filtered columns

---

### View Not Found

**Problem**: Power BI can't find views

**Solutions**:
1. Run view creation script again
2. Verify views appear in SSMS Object Explorer
3. Refresh Power BI data source
4. Restart Power BI Desktop

---

## 📞 Support & Questions

### Getting Help

1. **SQL Syntax**: Microsoft SQL Server Documentation
   - https://docs.microsoft.com/en-us/sql/

2. **Northwind Data**: Database Schema Reference
   - See ../docs/DATA_DICTIONARY.md

3. **Specific Questions**: Check comments in SQL files
   - Each query includes purpose explanation

---

## 📝 File Maintenance

### Regular Tasks
- [ ] Test queries after SQL Server updates
- [ ] Review query performance quarterly
- [ ] Backup all SQL files to Git
- [ ] Update documentation for changes

### Archival
- Old versions: Keep in Git history
- Deprecated queries: Mark with "-- DEPRECATED" comment
- Backup scripts: Store in archive subfolder

---

**Last Updated**: March 2026
**Database Version**: Northwind
**SQL Server Versions**: 2016 SP2+

---

**Tip**: When writing new queries, follow the naming conventions and commenting style of existing scripts for consistency.
