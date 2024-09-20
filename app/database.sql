CREATE DATABASE IF NOT EXISTS messages_db;

USE messages_db;

CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id VARCHAR(255),
    message_id VARCHAR(255),
    sender_number VARCHAR(20),
    receiver_number VARCHAR(20)
);
