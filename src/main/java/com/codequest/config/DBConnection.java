package com.codequest.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Reusable Database Connection Provider for CodeQuest.
 * Configured for Aiven Cloud MySQL instance.
 */
public class DBConnection {

    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://mysql-2feb87b1-shameershaik3951-4001.e.aivencloud.com:24736/defaultdb?sslMode=REQUIRED";
    
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "AVNS_76v-Vj8lNI-hkfnroDz";

    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("[CodeQuest] MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    /**
     * Obtains a new database connection.
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
}
