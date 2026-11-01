-- 10.6.3：给店员一个手机号打了星号的视图（用 root 运行，需先运行 lab10_1_accounts.sql）
CREATE OR REPLACE VIEW v_customer_masked AS
SELECT customer_id, name,
       CONCAT(LEFT(phone, 3), '****', RIGHT(phone, 4)) AS phone
FROM customer;
GRANT SELECT ON shop.v_customer_masked TO r_clerk;
SELECT * FROM v_customer_masked ORDER BY customer_id LIMIT 3;
