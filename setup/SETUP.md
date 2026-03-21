# Setup Instructions

Complete guide to set up the Northwind Data Analysis project on your machine.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
- **SQL Server 2016 or Later** (or SQL Server Express - free)
  - Download: [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
  - Or: [SQL Server Developer Edition](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (free)
  
- **SQL Server Management Studio (SSMS)**
  - Download: [SSMS](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
  
- **Power BI Desktop**
  - Download: [Power BI Desktop](https://www.microsoft.com/en-us/power-bi/desktop)
  - Or install from Microsoft Store

### System Requirements
- Windows 10/11 or Windows Server 2016+
- Minimum 4 GB RAM (8 GB recommended)
- 5 GB free disk space
- .NET Framework 4.7.2 or later

## 🔧 Installation Steps

### Step 1: Install SQL Server
1. Download SQL Server Express or Developer Edition
2. Run the installer and follow the installation wizard
3. Choose "Standard Installation" or "Custom Installation"
4. Configure:
   - Instance Name: `SQLEXPRESS` (or your preferred name)
   - Authentication Mode: Mixed Mode (SQL Server and Windows Authentication)
   - SA Password: Choose a strong password
   - Add current user as SQL Server administrator
5. Complete the installation

### Step 2: Install SSMS
1. Download SQL Server Management Studio
2. Run the installer
3. Complete the installation
4. Verify installation by launching SSMS

### Step 3: Install Power BI Desktop
1. Download Power BI Desktop
2. Install via Microsoft Store or direct download
3. Verify installation by launching Power BI

## 🗄️ Database Setup

### Step 1: Create the Database

1. **Open SQL Server Management Studio (SSMS)**
2. **Connect to your SQL Server instance**
3. **Run the database creation script:**
   - Navigate to: `sql/database/Database Script - Northwind.sql`
   - Open in SSMS (File → Open → File)
   - Click "Execute" or press F5
   - This will create the complete Northwind database with all tables and data

### Step 2: Create Database Views

1. **Open the view creation script:**
   - Navigate to: `sql/views/Create View scipt for Dashboard.sql`
   - Open in SSMS
   - Execute to create all views needed for Power BI
   - These views aggregate data for dashboard consumption

### Step 3: Verify Installation

Run a quick verification query in SSMS:

```sql
-- Check if database exists
SELECT name FROM sys.databases WHERE name = 'Northwind';

-- Check table count
SELECT COUNT(*) as TableCount FROM information_schema.tables 
WHERE table_catalog = 'Northwind' AND table_schema = 'dbo';

-- Check sample data
SELECT TOP 5 * FROM Northwind.dbo.Customers;
```

All queries should return results without errors.

## 📊 Power BI Setup

### Step 1: Open the Dashboard

1. **Launch Power BI Desktop**
2. **Open the dashboard file:**
   - Navigate to: `dashboards/Dashboard.pbix`
   - Double-click to open in Power BI

### Step 2: Configure Data Connection

The dashboard connects to your local SQL Server database:

1. **If prompted to configure connection:**
   - Server: `localhost` or `(local)`
   - Database: `Northwind`
   - Authentication: Windows or SQL Server based on your setup
   - Click "Connect"

2. **If connection fails:**
   - Right-click dataset in Power BI → "Edit Queries"
   - Click "Data source settings"
   - Update server name to match your SQL Server instance name
   - Click "Close & Apply"

### Step 3: Refresh Data

- Click "Refresh" in Power BI to load the latest data
- If no data appears, verify your SQL Server connection

## 📝 SQL Queries

All SQL analysis files are in the `sql/` directory:

| File | Purpose | How to Use |
|------|---------|-----------|
| `queries/KPIs.sql` | Calculate key performance indicators | Execute in SSMS to see metrics |
| `queries/Adhoc Queries.sql` | Exploratory analysis queries | Run individual queries to explore data |
| `queries/Interesting Insights.sql` | Key findings and patterns | Execute to discover business insights |

**To run SQL queries:**
1. Open SSMS
2. Navigate to: `sql/queries/[filename].sql`
3. Select the query you want to run (or run all)
4. Press F5 or click Execute

## 🐛 Troubleshooting

### Connection Issues

**Problem**: "Cannot connect to SQL Server" in Power BI
- **Solution**: 
  - Verify SQL Server is running: Services > SQL Server (SQLEXPRESS)
  - Check server name: Open SSMS and note the server name in brackets
  - Use `(local)` or `.` for default instance on local machine

**Problem**: "Database not found"
- **Solution**:
  - Run the database creation script again
  - Verify the database name matches exactly: "Northwind"
  - Check that you have sufficient permissions

### Permission Issues

**Problem**: "Login failed" in SSMS
- **Solution**:
  - Verify SA password is correct (if using SQL auth)
  - Use Windows authentication if configured
  - Contact your SQL Server administrator

### Power BI Issues

**Problem**: Power BI shows no data
- **Solution**:
  - Click "Refresh" to reload data
  - Check that views were created: Run view creation script again
  - Verify SQL connection is active in Power BI

## ✅ Verification Checklist

After setup, verify everything is working:

- [ ] SQL Server is installed and running
- [ ] SSMS connects successfully to SQL Server
- [ ] Northwind database is created with tables
- [ ] Views are created in the database
- [ ] Power BI Desktop is installed
- [ ] Power BI dashboard opens without errors
- [ ] Power BI can connect to SQL Server
- [ ] Dashboard displays data after refresh
- [ ] Sample SQL queries execute successfully

## 📚 Next Steps

Once setup is complete:

1. **Explore the Data**: Run the SQL queries to understand the data
2. **Review the Dashboard**: Interact with Power BI visualizations
3. **Read the Insights**: Check `/docs/INSIGHTS.md` for key findings
4. **Customize**: Modify queries and dashboard for your own analysis

## 🤝 Support

If you encounter any issues:

1. Check the [Troubleshooting](#troubleshooting) section above
2. Review the relevant documentation in `/docs/`
3. Verify all prerequisite software is installed
4. Check that file paths match your installation

## 📞 Additional Resources

- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)
- [SSMS Documentation](https://docs.microsoft.com/en-us/sql/ssms/sql-server-management-studio-ssms)
- [Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
- [Northwind Database Guide](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/linq/downloading-sample-databases)

---

**Last Updated**: March 2026
