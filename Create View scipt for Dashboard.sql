CREATE VIEW vw_SalesSummary AS
SELECT
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue,
    SUM(od.UnitPrice * od.Quantity * od.Discount) AS TotalDiscount,
    COUNT(DISTINCT c.CustomerID) AS TotalCustomers,
    COUNT(DISTINCT o.OrderID) AS TotalOrders
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID;
GO

CREATE VIEW vw_TopCustomersRevenue AS
SELECT TOP 10
    c.CustomerID,
    c.CompanyName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalRevenue DESC;
GO

CREATE VIEW vw_TopProductsRevenue AS
SELECT TOP 10
    p.ProductID,
    p.ProductName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue,
    SUM(od.Quantity) AS TotalUnitsSold
FROM [Order Details] od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalRevenue DESC;
GO

CREATE VIEW vw_DeliveryPerformance AS
SELECT
    s.ShipperID,
    s.CompanyName AS ShipperName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue,
    AVG(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS AvgDeliveryDays
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.ShipperID, s.CompanyName;
GO

CREATE VIEW vw_RevenueByDimensions AS
SELECT
    c.CategoryName,
    r.RegionDescription,
    DATENAME(YEAR, o.OrderDate) AS SalesYear,
    DATEPART(QUARTER, o.OrderDate) AS SalesQuarter,
    e.EmployeeID,
    e.LastName + ' ' + e.FirstName AS EmployeeName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Customers cu ON o.CustomerID = cu.CustomerID
JOIN EmployeeTerritories et ON o.EmployeeID = et.EmployeeID
JOIN Territories t ON et.TerritoryID = t.TerritoryID
JOIN Region r ON t.RegionID = r.RegionID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY c.CategoryName, r.RegionDescription,
         DATENAME(YEAR, o.OrderDate),
         DATEPART(QUARTER, o.OrderDate),
         e.EmployeeID, e.LastName, e.FirstName;

GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_DiscountImpact AS
SELECT 
    CASE 
        WHEN od.Discount = 0 THEN 'No Discount'
        WHEN od.Discount < 0.1 THEN 'Low Discount'
        WHEN od.Discount < 0.2 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS DiscountCategory,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Revenue
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY 
    CASE 
        WHEN od.Discount = 0 THEN 'No Discount'
        WHEN od.Discount < 0.1 THEN 'Low Discount'
        WHEN od.Discount < 0.2 THEN 'Medium Discount'
        ELSE 'High Discount'
    END;
GO

CREATE VIEW vw_Insight_ChurnRate AS
WITH Cust2016 AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) =2016
),
Cust2017 AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) =2017
),
Cust2018 AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) =2018
),
retained AS (
    SELECT j.CustomerID
    FROM Cust2016 j
    INNER JOIN Cust2017 f ON j.CustomerID = f.CustomerID
	INNER JOIN Cust2018 g on f.CustomerID=g.CustomerID
)

--select count(*) from retained
SELECT  (CAST
                  ((SELECT  COUNT(*) AS TotalCustomers
                  FROM    Customers) AS DECIMAL(5, 2))-CAST
                  ((SELECT  COUNT(*) AS ReturnCustomers
                  FROM    retained) AS DECIMAL(5, 2))) / CAST
                  ((SELECT  COUNT(*) AS TotalCustomers
                  FROM    dbo.Customers) AS DECIMAL(5, 2)) AS ChurnRate
GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_SeasonalOrders AS
SELECT 
    DATENAME(MONTH, o.OrderDate) AS OrderMonth,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Revenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY DATENAME(MONTH, o.OrderDate), MONTH(o.OrderDate)
--ORDER BY MONTH(o.OrderDate);
GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_CustomerFrequency AS
SELECT 
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity) AS TotalOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName;
GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_SlowInventory AS
SELECT 
    p.ProductName,
    SUM(od.Quantity) AS UnitsSold,
    p.UnitsInStock
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE p.UnitsInStock > 100
GROUP BY p.ProductName, p.UnitsInStock;
GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_HeroProductByCategory AS
WITH CategorySales AS (
    SELECT  
        c.CategoryName,
        p.ProductName,
        SUM(od.Quantity) AS TotalQtySold,
        ROW_NUMBER() OVER (
            PARTITION BY c.CategoryName 
            ORDER BY SUM(od.Quantity) DESC
        ) AS rn
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
    GROUP BY c.CategoryName, p.ProductName
)
SELECT CategoryName, ProductName, TotalQtySold
FROM CategorySales
WHERE rn = 1;
GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_HeroProductQuarterly AS
WITH QuarterlyProductSales AS (
    SELECT
        YEAR(o.OrderDate) AS Year,
        DATEPART(QUARTER, o.OrderDate) AS Quarter,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice * (1.0 - od.Discount)) AS ProductRevenue
    FROM [Order Details] od
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY YEAR(o.OrderDate), DATEPART(QUARTER, o.OrderDate), p.ProductName
),
QuarterlyTotal AS (
    SELECT
        Year,
        Quarter,
        SUM(ProductRevenue) AS TotalRevenue
    FROM QuarterlyProductSales
    GROUP BY Year, Quarter
),
RankedProducts AS (
    SELECT
        qps.Year,
        qps.Quarter,
        qps.ProductName,
        qps.ProductRevenue,
        qt.TotalRevenue,
        ROW_NUMBER() OVER (
            PARTITION BY qps.Year, qps.Quarter
            ORDER BY qps.ProductRevenue DESC
        ) AS rn
    FROM QuarterlyProductSales qps
    INNER JOIN QuarterlyTotal qt
        ON qps.Year = qt.Year AND qps.Quarter = qt.Quarter
)
SELECT
    Year,
    Quarter,
    ProductName AS HeroProduct,
    ROUND(ProductRevenue, 2) AS Revenue,
    ROUND((ProductRevenue * 100.0) / TotalRevenue, 2) AS ShareOfQuarterRevenue
FROM RankedProducts
WHERE rn = 1;
GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_QuarterlyRevenue AS
WITH quarterly_revenue AS
(
    SELECT
        YEAR(o.OrderDate) AS Year,
        DATEPART(QUARTER, o.OrderDate) AS Quarter,
        ROUND(SUM(od.Quantity * od.UnitPrice * (1.0 - od.Discount)), 2) AS Revenue
    FROM [Order Details] od
        INNER JOIN Orders o ON od.OrderID = o.OrderID
    GROUP BY YEAR(o.OrderDate),
             DATEPART(QUARTER, o.OrderDate)
),
yearly_total AS
(
    SELECT
        Year,
        SUM(Revenue) AS TotalRevenue
    FROM quarterly_revenue
    GROUP BY Year
)
SELECT
    q.Year,
    q.Quarter,
    q.Revenue,
    ROUND((q.Revenue * 100.0) / y.TotalRevenue, 2) AS ShareOfYearlyRevenue
FROM quarterly_revenue q
INNER JOIN yearly_total y ON q.Year = y.Year;
GO

USE [Northwind];
GO

CREATE VIEW vw_Insight_HeroCategoryQuarterly AS
WITH QuarterlyCategorySales AS (
    SELECT
        YEAR(o.OrderDate) AS Year,
        DATEPART(QUARTER, o.OrderDate) AS Quarter,
        c.CategoryName,
        SUM(od.Quantity * od.UnitPrice * (1.0 - od.Discount)) AS CategoryRevenue
    FROM [Order Details] od
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    GROUP BY YEAR(o.OrderDate), DATEPART(QUARTER, o.OrderDate), c.CategoryName
),
QuarterlyTotal AS (
    SELECT
        Year,
        Quarter,
        SUM(CategoryRevenue) AS TotalRevenue
    FROM QuarterlyCategorySales
    GROUP BY Year, Quarter
),
RankedCategories AS (
    SELECT
        qcs.Year,
        qcs.Quarter,
        qcs.CategoryName,
        qcs.CategoryRevenue,
        qt.TotalRevenue,
        ROW_NUMBER() OVER (
            PARTITION BY qcs.Year, qcs.Quarter
            ORDER BY qcs.CategoryRevenue DESC
        ) AS rn
    FROM QuarterlyCategorySales qcs
    INNER JOIN QuarterlyTotal qt
        ON qcs.Year = qt.Year AND qcs.Quarter = qt.Quarter
)
SELECT
    Year,
    Quarter,
    CategoryName AS HeroCategory,
    ROUND(CategoryRevenue, 2) AS Revenue,
    ROUND((CategoryRevenue * 100.0) / TotalRevenue, 2) AS ShareOfQuarterRevenue
FROM RankedCategories
WHERE rn = 1;
GO
USE [Northwind];
GO

ALTER VIEW vw_KPI_CustomerRetentionRate AS
WITH Cust2016 AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) =2016
),
Cust2017 AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) =2017
),
Cust2018 AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) =2018
),
retained AS (
    SELECT j.CustomerID
    FROM Cust2016 j
    INNER JOIN Cust2017 f ON j.CustomerID = f.CustomerID
	inner join Cust2018 g on f.CustomerID=g.CustomerID
)
 
select
 CAST( (SELECT COUNT(*) FROM retained )AS DECIMAL(5,2))/ CAST((SELECT COUNT(*) FROM Customers) AS DECIMAL(5,2))
    AS CRR;
GO

USE [Northwind];
GO

CREATE VIEW vw_KPI_RevenueByProduct AS
SELECT 
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice * (1.0 - od.Discount)) AS TotalRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName;
GO
USE [Northwind];
GO

CREATE VIEW vw_KPI_AverageBasketValue AS
SELECT 
    CAST(SUM(od.Quantity * od.UnitPrice) * 1.0 / COUNT(DISTINCT o.OrderID) AS DECIMAL(10,2)) AS AvgBasketValue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID;
GO


CREATE VIEW vw_Insights_SalesGrowth AS
WITH quarterly_revenue AS
(
    SELECT
        YEAR(o.OrderDate) AS year,
        DATEPART(QUARTER, o.OrderDate) AS quarter,
        ROUND(SUM(od.Quantity * od.UnitPrice * (1.0 - od.Discount)), 2) AS revenue
    FROM [Order Details] od
        INNER JOIN Orders o ON od.OrderID = o.OrderID
    GROUP BY YEAR(o.OrderDate),
             DATEPART(QUARTER, o.OrderDate)
),
yearly_total AS
(
    SELECT
        year,
        SUM(revenue) AS total_revenue
    FROM quarterly_revenue
    GROUP BY year
)
SELECT
    q.year AS "Year",
    q.quarter AS "Quarter",
    q.revenue AS "Revenue",
    ROUND(
        (q.revenue * 100.0) / y.total_revenue, 2
    ) AS "Share of Yearly Revenue (%)"
FROM
    quarterly_revenue q
    INNER JOIN yearly_total y ON q.year = y.year

GO


ALTER VIEW vw_Insights_EmployeePerformance AS
SELECT TOP 5
    --DATEPART(YEAR, o.OrderDate) AS OrderYear,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    COUNT(DISTINCT o.OrderID) AS OrdersHandled,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY DATEPART(YEAR, o.OrderDate), e.EmployeeID, e.FirstName, e.LastName
ORDER BY  TotalRevenue DESC;
GO