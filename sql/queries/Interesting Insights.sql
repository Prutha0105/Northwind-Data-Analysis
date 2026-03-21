USE [Northwind]
GO

--Task 2: Insights
--Is disCOUNT affecting the frequency of customers to order?
SELECT 
    CASE 
        WHEN od.DisCOUNT = 0 THEN 'No DisCOUNT'
        WHEN od.DisCOUNT < 0.1 THEN 'Low DisCOUNT'
        WHEN od.DisCOUNT < 0.2 THEN 'Medium DisCOUNT'
        ELSE 'High DisCOUNT'
    END AS DisCOUNTCategory,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.DisCOUNT)) AS Revenue
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY 
    CASE 
        WHEN od.DisCOUNT = 0 THEN 'No DisCOUNT'
        WHEN od.DisCOUNT < 0.1 THEN 'Low DisCOUNT'
        WHEN od.DisCOUNT < 0.2 THEN 'Medium DisCOUNT'
        ELSE 'High DisCOUNT'
    END
ORDER BY Revenue DESC;

--SeasONs wise orders
SELECT 
    DATENAME(MONTH, o.OrderDate) AS OrderMONth,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.DisCOUNT)) AS Revenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY DATENAME(MONTH, o.OrderDate), MONTH(o.OrderDate)
ORDER BY MONTH(o.OrderDate);

--Churn Rate

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

--Slow moving inventory
SELECT 
    p.ProductID,
    p.ProductName,
    p.UnitsInStock,
    ISNULL(SUM(od.Quantity), 0) AS TotalUnitsSold,
    (p.UnitsInStock - ISNULL(SUM(od.Quantity), 0)) AS StockVsSalesGap
FROM Products p
 JOIN [Order Details] od 
    ON p.ProductID = od.ProductID
GROUP BY 
    p.ProductID, 
    p.ProductName, 
    p.UnitsInStock
-- Look for slow movers: high stock and low sales
HAVING 
    ISNULL(SUM(od.Quantity), 0) = 0           -- never sold
    OR p.UnitsInStock > (ISNULL(SUM(od.Quantity), 0) * 2)  -- stock much higher than sold
ORDER BY 
    StockVsSalesGap DESC,
    p.UnitsInStock DESC;



--category wise hero product by most number of orders

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
WHERE rn = 1
ORDER BY CategoryName;

--This will give you the top-selling product of each quarter with its revenue and its cONtributiON to that quarter’s total.
;WITH QuarterlyProductSales AS (
    SELECT
        YEAR(o.OrderDate) AS Year,
        DATEPART(QUARTER, o.OrderDate) AS Quarter,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice * (1.0 - od.DisCOUNT)) AS ProductRevenue
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
    ProductName AS "Hero Product",
    ROUND(ProductRevenue, 2) AS "Revenue",
    ROUND((ProductRevenue * 100.0) / TotalRevenue, 2) AS "Share of Quarter Revenue (%)"
FROM RankedProducts
WHERE rn = 1
ORDER BY Year, Quarter;



--1. How does the mONthly revenue evolve over time/in veery Quarter?
--This query shows how business is growing by mONth and how it is generating revenue over the time.
--To answer this questiON, I calculate the mONthly revenue alONg with the percentage variatiON FROM the previous mONth. AdditiONally, I compute the cumulative Year-to-Date (YTD) revenue. 
USE [Northwind]
GO
;WITH quarterly_revenue AS
(
    SELECT
        YEAR(o.OrderDate) AS year,
        DATEPART(QUARTER, o.OrderDate) AS quarter,
        ROUND(SUM(od.Quantity * od.UnitPrice * (1.0 - od.DisCOUNT)), 2) AS revenue
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
ORDER BY
    q.year, q.quarter;

--Per category per quarter shows the share of Quarterly revenue:
;WITH QuarterlyCategorySales AS (
    SELECT
        YEAR(o.OrderDate) AS Year,
        DATEPART(QUARTER, o.OrderDate) AS Quarter,
        c.CategoryName,
        SUM(od.Quantity * od.UnitPrice * (1.0 - od.DisCOUNT)) AS CategoryRevenue
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
    CategoryName AS "Hero Category",
    ROUND(CategoryRevenue, 2) AS "Revenue",
    ROUND((CategoryRevenue * 100.0) / TotalRevenue, 2) AS "Share of Quarter Revenue (%)"
FROM RankedCategories
WHERE rn = 1
ORDER BY Year, Quarter;

--Top-selling product of each quarter with its revenue and cONtributiON
WITH QuarterlyRevenue AS (
    SELECT 
        DATEPART(YEAR, o.OrderDate) AS OrderYear,
        DATEPART(QUARTER, o.OrderDate) AS OrderQuarter,
        p.ProductName,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DisCOUNT)) AS ProductRevenue
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY DATEPART(YEAR, o.OrderDate), DATEPART(QUARTER, o.OrderDate), p.ProductName
),
QuarterlyTotal AS (
    SELECT 
        OrderYear, 
        OrderQuarter,
        SUM(ProductRevenue) AS TotalQuarterRevenue
    FROM QuarterlyRevenue
    GROUP BY OrderYear, OrderQuarter
),
RankedProducts AS (
    SELECT 
        qr.OrderYear,
        qr.OrderQuarter,
        qr.ProductName,
        qr.ProductRevenue,
        (qr.ProductRevenue / qt.TotalQuarterRevenue) * 100 AS CONtributiONPct,
        RANK() OVER (PARTITION BY qr.OrderYear, qr.OrderQuarter ORDER BY qr.ProductRevenue DESC) AS RankNo
    FROM QuarterlyRevenue qr
    JOIN QuarterlyTotal qt 
        ON qr.OrderYear = qt.OrderYear AND qr.OrderQuarter = qt.OrderQuarter
)
SELECT 
    OrderYear,
    OrderQuarter,
    ProductName,
    ProductRevenue,
    CONtributiONPct
FROM RankedProducts
WHERE RankNo = 1
ORDER BY OrderYear, OrderQuarter;

--Employee performance by revenue and orders handled
SELECT 
    DATEPART(YEAR, o.OrderDate) AS OrderYear,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    COUNT(DISTINCT o.OrderID) AS OrdersHandled,
    SUM(od.UnitPrice * od.Quantity * (1 - od.DisCOUNT)) AS TotalRevenue
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY DATEPART(YEAR, o.OrderDate), e.EmployeeID, e.FirstName, e.LastName
ORDER BY OrderYear, TotalRevenue DESC;

