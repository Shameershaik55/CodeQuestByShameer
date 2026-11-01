-- ========================================================
-- CodeQuest: Database Tables Setup for Cloud Database (defaultdb)
-- ========================================================

DROP TABLE IF EXISTS mission_submissions;
DROP TABLE IF EXISTS missions;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    total_xp INT DEFAULT 0,
    player_level INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE missions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(30) NOT NULL,
    difficulty VARCHAR(20) NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_answer VARCHAR(255) NOT NULL,
    xp_reward INT DEFAULT 50,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES admins(id) ON DELETE SET NULL
);

CREATE TABLE mission_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    mission_id INT NOT NULL,
    answer VARCHAR(255) NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (mission_id) REFERENCES missions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_mission (user_id, mission_id)
);

-- Seed Data
INSERT INTO admins (username, password) VALUES ('admin', 'admin123');

INSERT INTO users (username, email, password, total_xp, player_level) VALUES
('NeoMatrix', 'neo@codequest.io', 'pass123', 450, 5),
('CyberNinja', 'ninja@codequest.io', 'pass123', 300, 4),
('ByteWizard', 'wizard@codequest.io', 'pass123', 200, 3),
('ShadowCoder', 'shadow@codequest.io', 'pass123', 100, 2),
('PixelKnight', 'pixel@codequest.io', 'pass123', 50, 1);

INSERT INTO missions (title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by) VALUES
('String Immutability', 'What happens when you modify a String object in Java?', 'Java', 'Easy', 'The original object is changed in memory', 'A new String object is created in memory', 'A compilation error occurs', 'The string is converted to a StringBuilder', 'A new String object is created in memory', 50, 1),
('Polymorphism Mechanism', 'Which Java keyword prevents a method from being overridden in a child subclass?', 'Java', 'Easy', 'static', 'abstract', 'final', 'synchronized', 'final', 50, 1),
('Garbage Collection Trigger', 'Which method in Java is traditionally suggested to request garbage collection, though execution is not guaranteed?', 'Java', 'Medium', 'Runtime.getRuntime().gc()', 'Thread.sleep()', 'Object.finalize()', 'System.freeMemory()', 'Runtime.getRuntime().gc()', 75, 1),
('Generics & Type Erasure', 'At which stage does Java remove generic type parameters (Type Erasure)?', 'Java', 'Hard', 'Runtime initialization', 'Compilation', 'Class loading by JVM', 'Bytecode verification', 'Compilation', 100, 1),
('Filtering Aggregates', 'Which SQL clause is used to filter groups created by the GROUP BY statement?', 'SQL', 'Easy', 'WHERE', 'ORDER BY', 'HAVING', 'FILTER', 'HAVING', 50, 1),
('Relational Joins', 'Which type of JOIN returns all records from the left table and matched records from the right table, filling nulls if no match exists?', 'SQL', 'Easy', 'INNER JOIN', 'LEFT OUTER JOIN', 'RIGHT OUTER JOIN', 'CROSS JOIN', 'LEFT OUTER JOIN', 50, 1),
('ACID Properties', 'In SQL transactions, which property ensures that once a transaction is committed, its changes survive system crashes?', 'SQL', 'Medium', 'Atomicity', 'Consistency', 'Isolation', 'Durability', 'Durability', 75, 1),
('Window Functions', 'Which SQL window function assigns a sequential unique integer to each row within a partition, without gaps?', 'SQL', 'Hard', 'RANK()', 'DENSE_RANK()', 'ROW_NUMBER()', 'NTILE()', 'ROW_NUMBER()', 100, 1),
('Array Access Time', 'What is the worst-case time complexity to access an element by index in a contiguous array?', 'DSA', 'Easy', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'O(1)', 50, 1),
('Stack Applications', 'Which standard data structure is fundamentally utilized to evaluate arithmetic postfix expressions?', 'DSA', 'Easy', 'Queue', 'Stack', 'Binary Tree', 'Priority Queue', 'Stack', 50, 1),
('Binary Search Condition', 'What prerequisite must be satisfied before performing Binary Search on an array?', 'DSA', 'Medium', 'Array elements must be unique', 'Array must be sorted', 'Array size must be a power of 2', 'Array must contain only integers', 'Array must be sorted', 75, 1),
('Graph Shortest Path', 'Which algorithm finds the shortest path between all pairs of vertices in a weighted graph without negative cycles?', 'DSA', 'Hard', 'Dijkstra', 'Floyd-Warshall', 'Kruskal', 'Breadth-First Search', 'Floyd-Warshall', 100, 1);

