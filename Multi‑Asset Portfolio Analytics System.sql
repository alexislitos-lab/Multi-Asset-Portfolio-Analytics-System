use PortfolioDB

go

-- Portfolio_Weights Table

CREATE TABLE Portfolio_Weights (
    AssetID INT PRIMARY KEY,
    AssetTicker VARCHAR(10),
    Weight DECIMAL(5, 2)
);

INSERT INTO Portfolio_Weights (AssetID, AssetTicker, Weight) VALUES
(1, 'AAPL', 0.20), -- 20% Apple
(2, 'MSFT', 0.20), -- 20% Microsoft
(3, 'NVDA', 0.20), -- 20% NVIDIA
(4, 'AGG',  0.30), -- 30% Bonds
(5, 'EURUSD', 0.10); -- 10% FX

SELECT *
FROM [dbo].[Portfolio_Weights];

SELECT *
FROM [dbo].[Portfolio_Prices];

SELECT 
    p.PriceDate,
    SUM(p.DailyReturn * w.Weight) AS Account_Daily_Increase
FROM [dbo].[Portfolio_Prices] p 
JOIN [dbo].[Portfolio_Weights] w ON p.AssetID = w.AssetID
GROUP BY p.PriceDate
ORDER BY p.PriceDate;

--Cumulative Return

CREATE OR ALTER VIEW View_Portfolio_Daily_Returns AS
SELECT 
    p.PriceDate,
    SUM(p.DailyReturn * w.Weight) AS Account_Daily_Increase
FROM [dbo].[Portfolio_Prices] p 
JOIN [dbo].[Portfolio_Weights] w ON p.AssetID = w.AssetID
GROUP BY p.PriceDate;
GO  

SELECT 
    PriceDate,
    ROUND(Account_Daily_Increase, 4) AS Daily_Return_Percent,
    ROUND(10000 * Account_Daily_Increase, 2) AS Daily_Profit_Loss_USD,
    ROUND(10000 + SUM(10000 * Account_Daily_Increase) OVER (ORDER BY PriceDate), 2) AS Total_Account_Value
FROM View_Portfolio_Daily_Returns
ORDER BY PriceDate;

-- Final Amount

CREATE OR ALTER VIEW Final_Value AS
SELECT 
    PriceDate,
    ROUND(Account_Daily_Increase, 4) AS Daily_Return_Percent,
    ROUND(10000 * Account_Daily_Increase, 2) AS Daily_Profit_Loss_USD,
    ROUND(10000 + SUM(10000 * Account_Daily_Increase) OVER (ORDER BY PriceDate), 2) AS Total_Account_Value
FROM View_Portfolio_Daily_Returns;
GO

SELECT TOP(1) PriceDate, Total_Account_Value
FROM Final_Value
ORDER BY PriceDate DESC;


SELECT * FROM Final_Value ORDER BY PriceDate