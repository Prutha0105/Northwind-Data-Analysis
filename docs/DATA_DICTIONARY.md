# Northwind Database - Data Dictionary

Complete documentation of the Northwind database schema, tables, and relationships.

## Overview

The Northwind database is a sample database from Microsoft that contains sales and inventory data for a fictional company. It includes information about customers, orders, products, and employees.

## Database Schema

### Tables Overview

| Table | Records | Purpose |
|-------|---------|---------|
| Customers | 91 | Customer information and contact details |
| Orders | 830 | Sales orders and transaction data |
| OrderDetails | 2,155 | Line items for each order |
| Products | 77 | Product catalog and inventory details |
| Categories | 8 | Product categories |
| Suppliers | 29 | Product suppliers and vendors |
| Employees | 9 | Employee information |
| EmployeeTerritories | 49 | Employee territory assignments |
| Territories | 10 | Sales territories |
| Shippers | 3 | Shipping companies |
| Region | 4 | Geographic regions |

## Table Definitions

### Customers
Stores information about business customers.

```sql
CustomerID (Primary Key)     → Unique customer identifier
CompanyName                  → Name of the company
ContactName                  → Contact person name
ContactTitle                 → Contact person's job title
Address                      → Street address
City                         → City name
Region                       → State or region
PostalCode                   → Zip/postal code
Country                      → Country
Phone                        → Phone number
Fax                          → Fax number
```

**Sample Records**: 91 customers
**Key Relationships**: Has many Orders

---

### Orders
Contains sales order headers and transaction information.

```sql
OrderID (Primary Key)        → Unique order identifier
CustomerID (Foreign Key)     → Customer who placed the order
EmployeeID (Foreign Key)     → Employee who took the order
OrderDate                    → Date order was placed
RequiredDate                 → Requested delivery date
ShippedDate                  → Actual ship date
ShipperID (Foreign Key)      → Shipping company used
Freight                      → Shipping cost
ShipName                     → Name for shipment
ShipAddress                  → Shipping address
ShipCity                     → Shipping city
ShipRegion                   → Shipping region
ShipPostalCode               → Shipping postal code
ShipCountry                  → Shipping country
```

**Sample Records**: 830 orders
**Date Range**: 1996-01-01 to 1998-05-06
**Key Relationships**: Links CustomersEmployees (taker), Shippers, OrderDetails

---

### OrderDetails
Line items within each order - the detailed items ordered.

```sql
OrderID (Primary Key/FK)     → Order this item belongs to
ProductID (Primary Key/FK)   → Product being ordered
UnitPrice                    → Price per unit at time of order
Quantity                     → Number of units ordered
Discount                     → Discount percentage (0-1 decimal)
```

**Sample Records**: 2,155 line items
**Key Calculations**:
- Extended Price = UnitPrice × Quantity × (1 - Discount)
- Total Order Value = Sum of extended prices

---

### Products
Product catalog and inventory details.

```sql
ProductID (Primary Key)      → Unique product identifier
ProductName                  → Name of the product
SupplierID (Foreign Key)     → Supplier of this product
CategoryID (Foreign Key)     → Product category
QuantityPerUnit              → Package quantity (e.g., "10 boxes")
UnitPrice                    → Current sales price
UnitsInStock                 → Current inventory level
UnitsOnOrder                 → Units on order from supplier
ReorderLevel                 → Minimum inventory level
Discontinued                 → Product status (0 = active, 1 = discontinued)
```

**Sample Records**: 77 products in 8 categories
**Key Relationships**: Multiple per Category, Supplier, OrderDetails

---

### Categories
Product category classifications.

```sql
CategoryID (Primary Key)     → Unique category identifier
CategoryName                 → Category name
Description                  → Category description
Picture                      → Category image (binary data)
```

**Sample Records**: 8 categories
**Examples**: Beverages, Condiments, Confections, Dairy Products, etc.

---

### Suppliers
Vendor information for products.

```sql
SupplierID (Primary Key)     → Unique supplier identifier
CompanyName                  → Supplier company name
ContactName                  → Contact person name
ContactTitle                 → Contact person's job title
Address                      → Street address
City                         → City name
Region                       → State or region
PostalCode                   → Zip/postal code
Country                      → Country
Phone                        → Phone number
Fax                          → Fax number
HomePage                     → Website URL
```

**Sample Records**: 29 suppliers
**Key Relationships**: Supplies many Products

---

### Employees
Employee information and organization structure.

```sql
EmployeeID (Primary Key)     → Unique employee identifier
LastName                     → Employee surname
FirstName                    → Employee first name
Title                        → Job title
TitleOfCourtesy              → Formal title (Mr., Ms., etc.)
BirthDate                    → Date of birth
HireDate                     → Employee hire date
Address                      → Home address
City                         → City name
Region                       → State or region
PostalCode                   → Zip/postal code
Country                      → Country
HomePhone                    → Phone number
Extension                    → Phone extension
Photo                        → Employee photo (binary data)
Notes                        → Employee notes/biography
ReportsTo (FK)               → Manager's EmployeeID (self-referencing)
PhotoPath                    → Path to photo file
```

**Sample Records**: 9 employees
**Hierarchy**: Employees can report to other employees (management structure)

---

### EmployeeTerritories
Mapping of employees to sales territories.

```sql
EmployeeID (Primary Key/FK)  → Employee assigned to territory
TerritoryID (Primary Key/FK) → Territory assigned
```

**Sample Records**: 49 employee-territory assignments
**Purpose**: Tracks which territories each employee covers

---

### Territories
Sales territories and regions.

```sql
TerritoryID (Primary Key)    → Unique territory identifier
TerritoryDescription         → Territory name/description
RegionID (Foreign Key)       → Region this territory is in
```

**Sample Records**: 10 territories
**Example**: "Northeast", "Midwest", "South", etc.

---

### Region
Geographic regions (high-level).

```sql
RegionID (Primary Key)       → Unique region identifier
RegionDescription            → Region name
```

**Sample Records**: 4 regions
**Examples**: North, South, East, West

---

### Shippers
Shipping company information.

```sql
ShipperID (Primary Key)      → Unique shipper identifier
CompanyName                  → Company name
Phone                        → Contact phone
```

**Sample Records**: 3 shippers
**Examples**: "Speedy Express", "United Package", "Federal Shipping"

---

## Key Relationships

### Entity Relationship Diagram

```
Regions          Territories       EmployeeTerritories       Employees
  1 ←─→ *          1 ←─→ *           M:N                        1
                                                                  ↓ (ReportsTo)
                                                              Employees

Categories       Suppliers         Products          OrderDetails       Orders
  1 ←─→ *          1 ←─→ *           1 ←─→ *           * ←─→ 1            1
                                                                           ↑
                                     Customers ←───────────────────────────┘
                                     
                     Shippers
                       1 ←─→ * Orders
```

## Data Types Reference

Common SQL Server data types used in Northwind:

| Type | Usage | Examples |
|------|-------|----------|
| INT | Integer values | CustomerID, OrderID, Quantity |
| DECIMAL(10,2) | Currency and decimals | UnitPrice, Freight, Discount |
| VARCHAR(50) | Text fields | CustomerName, City, Phone |
| NVARCHAR(50) | Unicode text | International names and text |
| DATETIME | Date and time | OrderDate, ShippedDate, BirthDate |
| BIT | Boolean (0 or 1) | Discontinued |
| IMAGE | Binary data | Photo, Picture |

## Business Calculations

### Common KPIs and Formulas

#### Order Value
```
SalesAmount = UnitPrice × Quantity - (UnitPrice × Quantity × Discount)
OrderTotal = SUM(SalesAmount) for all items in order
```

#### Revenue Metrics
```
Total Revenue = SUM(OrderTotal) for period
Gross Revenue = SUM(UnitPrice × Quantity)
Net Revenue = Gross Revenue - Discounts
```

#### Product Metrics
```
Revenue by Product = SUM(UnitPrice × Quantity) per ProductID
Profit Margin = (UnitPrice - CostPrice) / UnitPrice
Inventory Turnover = SalesQuantity / Average Inventory
```

#### Customer Metrics
```
Customer Lifetime Value = SUM(OrderTotal) per CustomerID
Orders per Customer = COUNT(DISTINCT OrderID) per CustomerID
Average Order Value = SUM(OrderTotal) / COUNT(OrderID) per CustomerID
```

## Indexing Strategy

### Primary Indexes (Pre-created)
- Tables indexed on all Primary Keys
- Foreign Keys indexed for join performance
- OrderID and CustomerID frequently queried

### Recommended Indexes
```sql
-- For dashboard queries
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE INDEX IX_Orders_CustomerID ON Orders(CustomerID);
CREATE INDEX IX_OrderDetails_ProductID ON OrderDetails(ProductID);
CREATE INDEX IX_Products_CategoryID ON Products(CategoryID);
```

## Data Integrity Constraints

### Referential Integrity
- All Foreign Keys enforce referential integrity
- CASCADE options typically NOT used (data safety)
- Deletes restricted if child records exist

### NULL Handling
- PRIMARY KEYS: NOT NULL
- FOREIGN KEYS: Generally NOT NULL
- Optional Fields: ShippedDate, Region can be NULL

### Check Constraints
- Quantity ≥ 0
- UnitPrice ≥ 0
- Discount between 0 and 1

## Access and Permissions

### Typical Database Roles
- **db_owner**: Full database access
- **db_datareader**: Query data only
- **db_datawriter**: Insert/update/delete data
- **db_ddladmin**: Modify schema

### View Access
Business users typically access:
- Sales views by date, product, customer
- Order views with status
- Product performance dashboards
- Employee territory summaries

---

**Last Updated**: March 2026
**Database Version**: Northwind Sample DB
**Last Backup**: Check SQL Server backups for current date
