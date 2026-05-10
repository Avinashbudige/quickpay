# SQL Answers

## Q1
### Query
```sql
SELECT clean_status AS status, COUNT(*) AS transaction_count
FROM cleaned_transactions
GROUP BY clean_status;
```
### Result Summary
| Status              | Transaction Count |
|---------------------|-------------------|
| captured            | 19                |
| chargeback          | 4                 |
| failed e05 timeout  | 7                 |

## Q2
### Query
```sql
SELECT clean_merchant_name AS merchant_name, SUM(clean_transaction_amount) AS total_captured_gmv
FROM cleaned_transactions
WHERE clean_status = 'captured'
GROUP BY clean_merchant_name;
```

### Result Summary
| Merchant Name  | Total Captured GMV |
|----------------|---------------------|
| Alpha Mart     | 29928.5            |
| Beta Stores    | 33141.5            |
| City Pharma    | 8640.0             |
| Delta Travels  | 10300.0            |

## Q3
### Query
```sql
SELECT clean_merchant_name AS merchant_name, SUM(clean_transaction_amount) AS total_captured_gmv
FROM cleaned_transactions
WHERE clean_status = 'captured'
GROUP BY clean_merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;
```
### Result Summary
| Merchant Name  | Total Captured GMV |
|----------------|---------------------|
| Beta Stores    | 33141.5            |
| Alpha Mart     | 29928.5            |
| Delta Travels  | 10300.0            |
| City Pharma    | 8640.0             |

## Q4
### Query
```sql
SELECT transaction_date, SUM(clean_transaction_amount) AS daily_gmv, COUNT(*) AS successful_transactions
FROM cleaned_transactions
WHERE clean_status = 'successful'
GROUP BY transaction_date
ORDER BY transaction_date;
```
### Result Summary
No data available for successful transactions.

## Q5
### Query
```sql
SELECT clean_merchant_name AS merchant_name, SUM(CASE WHEN clean_status = 'chargeback' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS chargeback_ratio
FROM cleaned_transactions
GROUP BY clean_merchant_name
HAVING chargeback_ratio > 1;
```
### Result Summary
| Merchant Name  | Chargeback Ratio |
|----------------|------------------|
| Alpha Mart     | 9.09%            |
| Beta Stores    | 9.09%            |
| Delta Travels  | 25.00%           |
| Eco Home       | 50.00%           |

## Q6
### Query
```sql
SELECT clean_gateway_region AS region, AVG(clean_risk_score) AS average_risk_score, COUNT(*) AS transaction_count
FROM cleaned_transactions
GROUP BY clean_gateway_region
HAVING average_risk_score > 50 AND transaction_count > 20;
```
### Result Summary
No regions meet the criteria.

## Q7
### Query
```sql
SELECT user_id, transaction_date, COUNT(*) AS failed_or_chargeback_count
FROM cleaned_transactions
WHERE clean_status IN ('failed', 'chargeback')
GROUP BY user_id, transaction_date
HAVING failed_or_chargeback_count >= 3;
```
### Result Summary
No users meet the criteria.

## Q8
### Query
```sql
SELECT clean_merchant_name AS merchant_name, SUM(CASE WHEN clean_status = 'chargeback' THEN 1 ELSE 0 END) AS chargeback_count, COUNT(DISTINCT CASE WHEN clean_status = 'chargeback' THEN user_id END) AS unique_affected_users, SUM(CASE WHEN clean_status = 'chargeback' THEN clean_transaction_amount ELSE 0 END) AS chargeback_amount
FROM cleaned_transactions
GROUP BY clean_merchant_name;
```
### Result Summary
| Merchant Name  | Chargeback Count | Unique Affected Users | Chargeback Amount |
|----------------|-------------------|------------------------|-------------------|
| Alpha Mart     | 1                 | 1                      | 5355.0            |
| Beta Stores    | 1                 | 1                      | 1725.5            |
| City Pharma    | 0                 | 0                      | 0.0               |
| Delta Travels  | 1                 | 1                      | 2500.0            |
| Eco Home       | 1                 | 1                      | 6588.0            |