# Dashboard Documentation

## Northwind Power BI Dashboard Overview

The Power BI dashboard provides interactive visualization and analysis of Northwind sales data. This document explains the dashboard structure, how to use it, and how to interpret the visualizations.

## Dashboard Location

**File**: `dashboards/Dashboard.pbix`
**Tool**: Power BI Desktop (required to open)

## Connection Requirements

### Data Source
- **Server**: Local SQL Server instance
- **Database**: Northwind
- **Authentication**: Windows or SQL Server

### Data Refresh
- Manual refresh available via "Refresh" button in Power BI
- Automatic refresh can be configured (Power BI Desktop settings)
- Expected refresh time: 10-30 seconds

## Dashboard Structure

### Main Pages/Tabs

#### 1. Sales Overview
**Purpose**: High-level sales metrics and trends

**Key Metrics**:
- Total Sales (YTD, MTD, or custom period)
- Total Orders (count and trend)
- Average Order Value
- Number of Customers

**Visualizations**:
- Sales trend line chart (time-based)
- Orders count card
- KPI indicators
- Period-over-period growth

#### 2. Product Analysis
**Purpose**: Product performance and popularity analysis

**Metrics Displayed**:
- Top 10 revenue-generating products
- Product quantity sold
- Product category performance
- Product profitability

**Visualizations**:
- Horizontal bar chart (Top products)
- Pie chart (Category distribution)
- Table (All products with metrics)

#### 3. Customer Insights
**Purpose**: Customer behavior and segmentation analysis

**Metrics**:
- Number of customers
- Customer lifetime value distribution
- Top customers by revenue
- Customers by geography
- Orders per customer

**Visualizations**:
- Map visualization (geographic distribution)
- Scatter plot (order count vs. order value)
- Customer ranking table
- Customer segment pie chart

#### 4. Employee Performance
**Purpose**: Sales team efficiency and contribution

**Metrics**:
- Sales by employee
- Orders by employee
- Average order value per employee
- Employee territory performance
- Comparative metrics

**Visualizations**:
- Column chart (Employee sales comparison)
- KPI cards (Performance metrics)
- Badge/rank visualization

#### 5. Order Fulfillment
**Purpose**: Shipping and delivery analysis

**Metrics**:
- Orders by shipper
- On-time delivery rate (if available)
- Freight costs
- Shipping efficiency

**Visualizations**:
- Shipper comparison chart
- Delivery performance gauge
- Freight cost trend

## Interactive Features

### Slicers/Filters

The dashboard includes various interactive filters:

**Date Range Slicer**
- Filter data by date range
- Predefined options: Last 30 days, Last Quarter, YTD, etc.
- Custom date range selection

**Product Category Filter**
- Select specific categories to analyze
- Multi-select option available
- "Select All" option

**Customer Region Filter**
- Filter by geographic region
- Shows data for selected regions only

**Employee Filter**
- Select specific sales representatives
- Analyze individual performance

### Cross-Highlighting

- Clicking on a product highlights it across all dashboard visualizations
- Selecting a customer shows their order history
- Selecting a date range updates all metrics

## How to Use the Dashboard

### Basic Navigation

1. **Open Dashboard**
   - Launch Power BI Desktop
   - Open: File → Open → `dashboards/Dashboard.pbix`
   - Wait for data to load (~10-30 seconds)

2. **Connect to Data**
   - If prompted, select your SQL Server instance
   - Verify Northwind database connection
   - Click "Load" or allow auto-connection

3. **Explore Pages**
   - Use tabs at bottom to navigate dashboard pages
   - Each page shows different analysis perspective

### Using Filters

1. **Date Filter**
   - Click on date slicer
   - Select date range using calendar
   - Dashboard updates automatically

2. **Category/Region Filter**
   - Click on filter dropdown
   - Check/uncheck categories
   - Click "Apply" or "Filter"

3. **Reset Filters**
   - Use "Clear" or "Select All" option
   - Or use Ctrl+Alt+C keyboard shortcut

### Interpreting Metrics

**KPI Cards**
- Shows current value and arrow (↑ up or ↓ down)
- Green indicates positive trend, red indicates negative

**Charts**
- Hover over segments to see exact values
- Larger bars/segments indicate higher values
- Click legend items to toggle visibility

**Trend Lines**
- Upward slope = increasing over time
- Downward slope = decreasing over time
- Flat line = stable/no significant change

## Key Insights to Look For

### Sales Analysis
1. **Growth Trends**: Is sales trending up or down?
2. **Seasonality**: Do sales spike in certain months?
3. **Top Products**: Which products drive most revenue?
4. **Geographic Performance**: Which regions are strongest?

### Customer Analysis
1. **Customer Concentration**: Do few customers drive most revenue?
2. **Customer Lifetime Value**: What's the average CLV distribution?
3. **Growth**: Is customer base growing?
4. **Geographic Spread**: Where are customers concentrated?

### Employee Performance
1. **Top Performers**: Who generates most sales?
2. **Consistency**: Are performance differences significant?
3. **Territory Analysis**: How do territories compare?
4. **Customer Base**: What's average customer count per employee?

## Customizing the Dashboard

### Export Options

**Export Data**
- Right-click any visualization
- Select "Export data" → CSV or other format
- Data exports to Downloads folder

**Export Dashboard**
- File → Export → PDF
- Creates snapshot of current view
- Useful for sharing with stakeholders

**Copy Visual**
- Right-click visualization
- Select "Copy as image"
- Paste into presentations or documents

### Print Options
- File → Print
- Select specific page(s) to print
- Configure print layout and scaling

## Troubleshooting

### Dashboard Won't Load

**Problem**: Blank dashboard or "Connection failed"

**Solutions**:
1. Verify SQL Server is running
   - Windows Services → SQL Server
2. Check database exists in SQL Server
   - Open SSMS and verify Northwind database
3. Verify connection string
   - Power BI → Transform Data → Data source settings
4. Check Windows firewall allows SQL Server access

### Data Not Refreshing

**Problem**: Dashboard shows old data after updates

**Solutions**:
1. Click "Refresh" button in Power BI
2. Force refresh: Ctrl+Shift+R
3. Close and reopen Dashboard.pbix
4. Verify data is updated in SQL Server first

### Slow Performance

**Problem**: Dashboard takes long time to load or interact

**Solutions**:
1. Check network connection to SQL Server
2. Verify SQL Server has adequate resources
3. Try refreshing data: File → Options → Reduce server load
4. Consider splitting dashboard into multiple files

### Connection Errors

**Problem**: "Cannot authenticate" or "Access denied"

**Solutions**:
1. Verify you have Read access to Northwind database
2. Check database connection credentials
3. Try Windows Authentication instead of SQL login
4. Contact SQL Server administrator

## Performance Tips

### For Dashboard Performance
- Use specific date ranges to reduce data loaded
- Consider archiving old data to separate table
- Use incremental refresh for large datasets
- Schedule off-peak hours for heavy queries

### For Analysis
- Use slicers to focus on specific segments
- Don't load entire dataset if only recent data needed
- Archive historical data if dataset gets too large

## Advanced Features

### Drill-Down Analysis
- Many visualizations support drill-down
- Double-click bar or segment to drill deeper
- Use breadcrumb to navigate back

### Tooltips
- Hover over any data point for details
- Tooltips show additional context
- Can be customized by dashboard creator

### Buttons
- Some dashboards have navigation buttons
- Click to jump to specific pages
- Use for quick navigation

## Dashboard Maintenance

### Regular Updates
- Refresh data after each business cycle
- Review metrics monthly
- Archive old data quarterly
- Update filters as business requirements change

### Change Log
If dashboard is modified:
- Document changes made
- Save version with date
- Backup previous version
- Update this documentation

## Related Documentation

- [KPI Definitions](KPI_DEFINITIONS.md): Understand each metric
- [Data Dictionary](DATA_DICTIONARY.md): Learn about data source
- [Setup Guide](../setup/SETUP.md): Connection troubleshooting

## Support

For issues or questions:
1. Review troubleshooting section above
2. Check Power BI documentation
3. Verify SQL Server connection
4. Contact dashboard creator or BI team

---

**Last Updated**: March 2026
**Dashboard Name**: Northwind Sales Analysis
**Data Source**: Northwind Database (SQL Server)
**Refresh Frequency**: Manual or scheduled
