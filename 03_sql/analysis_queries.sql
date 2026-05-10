--Count transactions by status
SELECT status, COUNT(*) AS transaction_count
FROM cleaned_transactions
GROUP BY status;

--Calculate total captured GMV by merchant
SELECT merchant_id, SUM(amount) AS total_captured_gmv
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_id;

--Show top 10 merchants by captured GMV
SELECT merchant_id, SUM(amount) AS total_captured_gmv
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_id
ORDER BY total_captured_gmv DESC
LIMIT 10;

--Show daily GMV and successful transaction count
SELECT transaction_date, SUM(amount) AS daily_gmv, COUNT(*) AS successful_transactions
FROM cleaned_transactions
WHERE status = 'successful'
GROUP BY transaction_date
ORDER BY transaction_date;

--Find merchants with chargeback ratio above 1%
SELECT merchant_id, 
       SUM(CASE WHEN status = 'chargeback' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS chargeback_ratio
FROM cleaned_transactions
GROUP BY merchant_id
HAVING chargeback_ratio > 1;


--Find regions with average risk score above 50 and more than 20 transactions
SELECT region, AVG(risk_score) AS average_risk_score, COUNT(*) AS transaction_count
FROM cleaned_transactions
GROUP BY region
HAVING average_risk_score > 50 AND transaction_count > 20;

--Find users with 3 or more failed or chargeback transactions on the same day
SELECT user_id, transaction_date, COUNT(*) AS failed_or_chargeback_count
FROM cleaned_transactions
WHERE status IN ('failed', 'chargeback')
GROUP BY user_id, transaction_date
HAVING failed_or_chargeback_count >= 3;

--Show chargeback count, unique affected users, and chargeback amount by merchant
SELECT merchant_id, 
       SUM(CASE WHEN status = 'chargeback' THEN 1 ELSE 0 END) AS chargeback_count,
       COUNT(DISTINCT CASE WHEN status = 'chargeback' THEN user_id END) AS unique_affected_users,
       SUM(CASE WHEN status = 'chargeback' THEN amount ELSE 0 END) AS chargeback_amount
FROM cleaned_transactions
GROUP BY merchant_id;