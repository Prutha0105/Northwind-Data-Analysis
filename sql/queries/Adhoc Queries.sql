USE [Northwind]
GO
--Step 1: to clean th data
SELECT RequiredDate,ShippedDate,OrderDate FROM Orders
--UPDATE Orders SET ShippedDate = DATEADD(YEAR, 20, ShippedDate)

--TASk 4: Ad- Hoc QuestiONs
--QuestiON 1: Who are the top 10 customers by revenue in the lASt 12 mONths?
SELECT TOP 10 c.CONtactName,SUM(od.UnitPrice*od.Quantity* (1 - od.Discount)) TotalAmount
FROM Customers c
INNER JOIN orders o ON c.CustomerID=o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
GROUP BY c.CONtactName,o.OrderDate
HAVING o.OrderDate>= DATEADD (MONTH,-12,MAX(o.orderdate))
ORDER BY SUM(od.UnitPrice*od.Quantity) DESC

--QuestiON 2: Which products are low in stock but high in demand?
SELECT p.ProductName,p.UnitsInStock,SUM(od.quantity) HighOrderedQty
FROM products p
INNER JOIN [Order Details] od ON p.ProductID=od.ProductID 
WHERE p.UnitsInStock <10
GROUP BY p.ProductName,p.UnitsInStock
ORDER BY UnitsInStock ASC


--QuestiON 3: Which shipper delivers fAStest ON average?
SELECT companyname,AVG(Daysdiff) FROM (
SELECT o.orderdate,o.ShippedDate,s.CompanyName,DATEDIFF(DAY,o.OrderDate,o.ShippedDate) Daysdiff
FROM Orders o
INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE DATEDIFF(DAY,OrderDate,ShippedDate)<5
GROUP BY o.orderdate,o.ShippedDate,s.CompanyName,DATEDIFF(DAY,OrderDate,ShippedDate)
) a  GROUP BY CompanyName

SELECT TOP 1 
    s.ShipperID,
    s.CompanyName,
    AVG(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS AvgDeliveryDays
FROM Orders o
JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.ShipperID, s.CompanyName
ORDER BY AvgDeliveryDays ASC;

--QuestiON 4: Which employees’ orders are most delayed?
SELECT top 10 E.EmployeeID,E.FirstName+' '+E.LAStName AS EmployeeName ,DATEDIFF(DAY,RequiredDate,ShippedDate) Daysdiff
FROM orders o 
INNER JOIN employees e ON o.EmployeeID=e.EmployeeID
ORDER BY DATEDIFF(DAY,RequiredDate,ShippedDate) desc

SELECT TOP 10
    e.EmployeeID,
    e.FirstName + ' ' + e.LAStName AS EmployeeName,
    AVG(DATEDIFF(DAY, o.RequiredDate, o.ShippedDate)) AS AvgDelayDays
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE o.ShippedDate > o.RequiredDate
GROUP BY e.EmployeeID, e.FirstName, e.LAStName
ORDER BY AvgDelayDays DESC;
--QuestiON 5: What is the average order value (AOV) by regiON?
SELECT AVG(Od.Quantity*od.UnitPrice) TotalOrderValue , R.RegiONDescriptiON
FROM Orders O
INNER JOIN [Order Details] od ON o.orderid = od.OrderID
INNER JOIN Employees E ON o.EmployeeID=e.EmployeeID
INNER JOIN EmployeeTerritories ET ON E.EmployeeID=ET.EmployeeID
INNER JOIN Territories t ON ET.TerritoryID=t.TerritoryID
INNER JOIN RegiON R ON T.RegiONID=R.RegiONID
GROUP BY R.RegiONDescriptiON

SELECT c.RegiON,
       AVG(OrderTotals.OrderValue) AS AvgOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN (
    SELECT od.OrderID,
           SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderValue
    FROM [Order Details] od
    GROUP BY od.OrderID
) AS OrderTotals ON o.OrderID = OrderTotals.OrderID
WHERE c.RegiON IS NOT NULL
GROUP BY c.RegiON
ORDER BY AvgOrderValue DESC;