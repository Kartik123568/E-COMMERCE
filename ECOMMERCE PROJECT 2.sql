USE ECOMMERCE;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
INSERT INTO customers (customer_id, name, email) VALUES
(1, 'John Doe', 'john.doe@email.com'),
(2, 'Jane Smith', 'jane.smith@email.com'),
(3, 'Peter Jones', 'peter.jones@email.com'),
(4, 'Mary Johnson', 'mary.johnson@email.com'),
(5, 'David Chen', 'david.chen@email.com'),
(6, 'Susan Davis', 'susan.davis@email.com'),
(7, 'Sarah Miller', 'sarah.miller@email.com');
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(101, 1, '2024-01-15'),
(102, 2, '2024-01-16'),
(103, 1, '2024-01-20'),
(104, 3, '2024-02-05'),
(105, 2, '2024-02-10'),
(106, 5, '2024-02-12'),
(107, 1, '2024-03-01'),
(108, 4, '2024-03-02'),
(109, 3, '2024-03-15'),
(110, 5, '2024-03-20'),
(111, 6, '2024-03-25');
INSERT INTO order_items (order_item_id, order_id, product_name, quantity, price) VALUES
(1, 101, 'Laptop', 1, 1200.00),
(2, 101, 'Mouse', 2, 25.00),
(3, 102, 'Keyboard', 1, 75.00),
(4, 103, 'Monitor', 1, 300.00),
(5, 104, 'Laptop', 1, 1200.00),
(6, 105, 'Mouse', 3, 25.00),
(7, 106, 'Webcam', 1, 50.00),
(8, 107, 'Laptop', 1, 1200.00),
(9, 107, 'Keyboard', 1, 75.00),
(10, 108, 'Mouse', 1, 25.00),
(11, 109, 'Monitor', 1, 300.00),
(12, 110, 'Webcam', 2, 50.00),
(13, 111, 'Keyboard', 1, 75.00);

SELECT
    c.customer_id,
    c.name,
    SUM(oi.price * oi.quantity) AS total_revenue
FROM
    customers c
INNER JOIN
    orders o ON c.customer_id = o.customer_id
INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id, c.name
ORDER BY
    total_revenue DESC;
    
    SELECT
    oi.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM
    order_items oi
GROUP BY
    oi.product_name
ORDER BY
    total_quantity_sold DESC
LIMIT 3;
SELECT
    c.customer_id,
    c.name
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.order_id IS NULL;


SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    SUM(oi.price * oi.quantity) AS monthly_sales
FROM
    orders o
INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    order_month
ORDER BY
    order_month;
    
    WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.name,
        SUM(oi.price * oi.quantity) AS total_spend
    FROM
        customers c
    INNER JOIN
        orders o ON c.customer_id = o.customer_id
    INNER JOIN
        order_items oi ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id, c.name
)
SELECT
    customer_id,
    name,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spending_rank
FROM
    customer_spending;
    SELECT
    c.customer_id,
    c.name,
    (SELECT MIN(order_date) FROM orders o WHERE o.customer_id = c.customer_id) AS first_order_date
FROM
    customers c;
    SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(price * quantity) AS total_revenue,
    AVG(price) AS average_price
FROM
    order_items
GROUP BY
    product_name;
    