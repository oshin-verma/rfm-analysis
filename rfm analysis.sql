create database project;
use project;
select * from rfm_data;
select CustomerID, max(PurchaseDate) as last_purchase,datediff(current_date(),max(PurchaseDate)) as recency
from rfm_data
group by CustomerID;

select CustomerID, count(*) as frequency
from rfm_data
group by CustomerID;

select CustomerID,sum(TransactionAmount) as Monetary 
from rfm_data
group by CustomerID;

#after calculating each metrics in seperate queries ,we would join them together

select r.CustomerID,r.recency,f.frequency,m.Monetary
from (select CustomerID, datediff(current_date(),max(PurchaseDate)) as recency
from rfm_data
group by CustomerID) r

join (select CustomerID, count(*) as frequency
from rfm_data
group by CustomerID) f on r.CustomerID=f.CustomerID

join(select CustomerID,sum(TransactionAmount) as Monetary 
from rfm_data
group by CustomerID) m on r.CustomerID=m.CustomerID;

WITH CombinedRFMTable AS (
    SELECT 
        CustomerID,
        DATEDIFF(CURRENT_DATE(), MAX(PurchaseDate)) AS Recency,
        COUNT(*) AS Frequency,
        SUM(TransactionAmount) AS Monetary
    FROM rfm_data
    GROUP BY CustomerID
)

SELECT CustomerID,
       CASE
           WHEN recency <= 30 THEN 'High'
           WHEN recency BETWEEN 31 AND 60 THEN 'Medium'
           ELSE 'Low'
       END AS RecencyScore,
       CASE
           WHEN frequency >= 10 THEN 'High'
           WHEN frequency BETWEEN 5 AND 9 THEN 'Medium'
           ELSE 'Low'
       END AS FrequencyScore,
       CASE
           WHEN monetary >= 500 THEN 'High'
           WHEN monetary BETWEEN 200 AND 499 THEN 'Medium'
           ELSE 'Low'
       END AS MonetaryScore
FROM CombinedRFMTable;

#Conclusion from the Data:
All 5 customers shown (CustomerIDs: 8814, 2188, 4608, 2559, 9482) have:
Low Recency Score: These customers have not engaged recently (they haven’t made purchases in a long time).
Low Frequency Score: They have made very few purchases historically.
Mixed Monetary Score:
Some have High or Medium Monetary values (e.g., 8814 and 9482 spent a lot in the past).
Others have Low Monetary scores (e.g., 4608).
Insights:
These are lapsed customers — they haven’t engaged in a long time and have low activity.
Despite some high spending in the past, their lack of recent engagement and low frequency makes them low-priority for short-term marketing.
we can:
Re-engage high monetary but inactive customers (like 8814, 9482) with personalized offers.
Ignore low monetary and low frequency customers (like 4608) if marketing budget is limited.



