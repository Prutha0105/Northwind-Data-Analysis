USE [Northwind]
GO
--Task 1: KPI
--KPI 1: Customer Retention Rate (CRR)
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
SELECT
    100.0*(SELECT COUNT(*) FROM retained )/ (SELECT COUNT(*) FROM Customers) 
    AS CRR;
--KPI 2: Revenue by product
--Aggrigated sales from product
SELECT p.ProductName, SUM((od.Quantity * od.UnitPrice) * (1.0 - od.Discount)) AS TotalRevenue
FROM   dbo.Orders AS o INNER JOIN
           dbo.[Order Details] AS od ON o.OrderID = od.OrderID INNER JOIN
           dbo.Products AS p ON od.ProductID = p.ProductID
GROUP BY p.ProductName

--KPI 3: Average Basket Value
SELECT 
    CAST(SUM(od.Quantity * od.UnitPrice) * 1.0 / COUNT(DISTINCT o.OrderID) AS DECIMAL(10,2)) AS AvgBasketValue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID;

--KPI 4: Region wise Customers’ Purchasing Power
SELECT 
    c.Region,
    COUNT(DISTINCT o.CustomerID) AS TotalCustomers,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue,
    CAST(SUM(od.Quantity * od.UnitPrice) * 1.0 / COUNT(DISTINCT o.CustomerID) AS DECIMAL(10,2)) AS AvgPurchasingPower
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Region IS NOT NULL
GROUP BY c.Region
ORDER BY AvgPurchasingPower DESC;


--KPI 5: On-time Order Delivery Rate

SELECT 
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN ShippedDate <= RequiredDate THEN 1 ELSE 0 END) AS OnTimeOrders,
    CAST(100.0 * SUM(CASE WHEN ShippedDate <= RequiredDate THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS OnTimeDeliveryRate
FROM Orders;

