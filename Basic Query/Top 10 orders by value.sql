SELECT TOP 10 od.OrderID, sum((1-[Discount])*([UnitPrice] * [Quantity])) as [Value]

FROM [Order Details] as od

JOIN Orders As o ON od.OrderID = o.OrderID

WHERE year(o.OrderDate) = '1997'

GROUP BY
od.OrderID

Having sum((1-[Discount])*([UnitPrice] * [Quantity])) BETWEEN 1000 and 2000

Order by [Value] desc