-- Create player_drugs table
CREATE TABLE IF NOT EXISTS `player_drugs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` varchar(50) NOT NULL UNIQUE,
    `drug_type` varchar(50) DEFAULT NULL,
    `stage` int(11) DEFAULT 0,
    `start_time` int(11) DEFAULT NULL,
    `last_production` int(11) DEFAULT NULL,
    `total_produced` int(11) DEFAULT 0,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`citizen_id`) REFERENCES `players`(`citizen_id`) ON DELETE CASCADE
);

-- Create drug_sales table for logging
CREATE TABLE IF NOT EXISTS `drug_sales` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` varchar(50) NOT NULL,
    `drug_type` varchar(50) NOT NULL,
    `amount` int(11) NOT NULL,
    `price` int(11) NOT NULL,
    `timestamp` int(11) DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`citizen_id`) REFERENCES `players`(`citizen_id`) ON DELETE CASCADE
);

-- Create drug_inventory table (optional - for better tracking)
CREATE TABLE IF NOT EXISTS `drug_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` varchar(50) NOT NULL,
    `drug_type` varchar(50) NOT NULL,
    `amount` int(11) DEFAULT 0,
    `last_updated` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_drug` (`citizen_id`, `drug_type`),
    FOREIGN KEY (`citizen_id`) REFERENCES `players`(`citizen_id`) ON DELETE CASCADE
);
