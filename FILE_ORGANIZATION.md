# File Organization Guide

This guide helps you organize your SQL files into the proper folder structure for the portfolio project.

## Current Structure vs. Recommended Structure

### Current (Root Level)
```
Northwind-Data-Analysis/
├── Adhoc Queries.sql
├── Create View scipt for Dashboard.sql
├── Database Script - Northwind.sql
├── Interesting Insights.sql
├── KPIs.sql
└── Dashboard.pbix
```

### Recommended (Organized)
```
Northwind-Data-Analysis/
├── sql/
│   ├── database/
│   │   └── Database Script - Northwind.sql
│   ├── views/
│   │   └── Create View scipt for Dashboard.sql
│   ├── queries/
│   │   ├── KPIs.sql
│   │   ├── Adhoc Queries.sql
│   │   └── Interesting Insights.sql
│   └── README.md
├── dashboards/
│   ├── Dashboard.pbix
│   └── README.md
├── docs/
│   ├── DATA_DICTIONARY.md
│   ├── KPI_DEFINITIONS.md
│   └── INSIGHTS.md
├── setup/
│   ├── SETUP.md
│   └── requirements.txt
├── .gitignore
└── README.md
```

## How to Organize Files

### Option 1: Manual File Move (Windows Explorer)

1. **Open Windows Explorer**
   - Navigate to: `C:\Users\pdesai\source\repos\Northwind-Data-Analysis`

2. **Move Database Script**
   - Select: `Database Script - Northwind.sql`
   - Cut (Ctrl+X)
   - Open: `sql\database\` folder
   - Paste (Ctrl+V)

3. **Move View Script**
   - Select: `Create View scipt for Dashboard.sql`
   - Cut (Ctrl+X)
   - Open: `sql\views\` folder
   - Paste (Ctrl+V)

4. **Move Query Files**
   - Select all three query files:
     - `Adhoc Queries.sql`
     - `Interesting Insights.sql`
     - `KPIs.sql`
   - Cut (Ctrl+X)
   - Open: `sql\queries\` folder
   - Paste (Ctrl+V)

5. **Move Power BI File**
   - Select: `Dashboard.pbix`
   - Cut (Ctrl+X)
   - Open: `dashboards\` folder
   - Paste (Ctrl+V)

### Option 2: Command Line (PowerShell)

Run these commands from the project root:

```powershell
# Move database script
Move-Item "Database Script - Northwind.sql" "sql\database\"

# Move view script
Move-Item "Create View scipt for Dashboard.sql" "sql\views\"

# Move query files
Move-Item "KPIs.sql" "sql\queries\"
Move-Item "Adhoc Queries.sql" "sql\queries\"
Move-Item "Interesting Insights.sql" "sql\queries\"

# Move Power BI file
Move-Item "Dashboard.pbix" "dashboards\"
```

### Option 3: Git Move (Preserves History)

If using Git version control:

```bash
git mv "Database Script - Northwind.sql" "sql/database/"
git mv "Create View scipt for Dashboard.sql" "sql/views/"
git mv "KPIs.sql" "sql/queries/"
git mv "Adhoc Queries.sql" "sql/queries/"
git mv "Interesting Insights.sql" "sql/queries/"
git mv "Dashboard.pbix" "dashboards/"
git commit -m "Organize project files into folder structure"
```

## Updating References

### Power BI Dashboard Connection

After moving files, update Power BI if needed:

1. Open `dashboards\Dashboard.pbix`
2. If connection to SQL fails:
   - Transform Data → Data source settings
   - Update server and database connection
   - Click Apply

### SQL Server Scripts

No changes needed - scripts work from any folder. When running:

1. In SSMS, just open from new location
2. Scripts reference Northwind database (not file paths)
3. Execution same as before

### Documentation References

Update **bookmark locations** in documentation:

| Old Reference | New Reference |
|---|---|
| `Database Script - Northwind.sql` | `sql/database/Database Script - Northwind.sql` |
| `Create View scipt for Dashboard.sql` | `sql/views/Create View scipt for Dashboard.sql` |
| `KPIs.sql` | `sql/queries/KPIs.sql` |
| `Adhoc Queries.sql` | `sql/queries/Adhoc Queries.sql` |
| `Interesting Insights.sql` | `sql/queries/Interesting Insights.sql` |
| `Dashboard.pbix` | `dashboards/Dashboard.pbix` |

## Verifying Organization

After moving files, verify everything is correct:

### Folder Contents Check

```PowerShell
# Check each folder has correct files
Get-ChildItem "sql\database\"     # Should show Database Script
Get-ChildItem "sql\views\"        # Should show view script
Get-ChildItem "sql\queries\"      # Should show 3 query files
Get-ChildItem "dashboards\"       # Should show Dashboard.pbix
```

### Git Status Check (If Using Git)

```bash
git status        # Should show all files moved
git log --oneline # Should show move commits
```

### Root Folder Cleanup

After moving, root folder should only contain:
```
Northwind-Data-Analysis/
├── .git/
├── .gitignore
├── README.md
├── dashboards/
├── docs/
├── setup/
└── sql/
```

SQL files and Dashboard.pbix should NOT be at root level.

## Restoring File References in Power BI

### If Dashboard doesn't Connect

1. **Disconnect from Data**
   - Power BI → Edit Queries
   - Data source settings
   - Delete the SQL Server connection

2. **Reconnect**
   - New Source → SQL Server
   - Enter server name: `(local)` or `.`
   - Database: `Northwind`
   - Click OK

3. **Refresh Dashboard**
   - Home → Refresh
   - Data should load

## Benefits of Organization

✅ **Cleaner Structure**: Easier to navigate and maintain

✅ **Professional Appearance**: Looks like enterprise project

✅ **Clear Separation**: Different file types properly organized

✅ **Better Documentation**: Easier to follow setup guide

✅ **Portfolio Quality**: Demonstrates attention to detail

✅ **Scalability**: Easy to add new scripts/dashboards

## Troubleshooting After Organization

### Power BI Shows "File Not Found"

- Verify Dashboard.pbix moved to `dashboards/` folder
- Check file still opens correctly
- SQL connection should not be affected

### Can't Find SQL Scripts

- Use "Find in Folder" (Ctrl+Shift+F) in VS Code / SSMS
- Or navigate via File → Open to new location
- Update your bookmarks/shortcuts

### Git Conflicts After Move

If using Git:
```bash
git merge  # Might have conflicts
git add *
git commit -m "Resolve merge conflicts from file reorganization"
```

## Next Steps

1. ✅ Watch folders have been created
2. ⏳ **Organize files** using Option 1, 2, or 3 above
3. ✅ Update Power BI connection if needed (usually automatic)
4. ✅ Test all scripts still work from new locations
5. ✅ Commit changes to Git (if using)
6. ✅ Update any bookmarks or shortcuts

---

**Time Required**: ~5 minutes

**Difficulty**: Easy

**Prerequisites**: File system access, VS Code or Windows Explorer

---

Ready to organize? Pick your preferred method above and follow the steps!
