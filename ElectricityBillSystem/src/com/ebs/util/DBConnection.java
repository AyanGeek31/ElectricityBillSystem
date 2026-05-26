package com.ebs.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    private static final String DB_URL = "jdbc:sqlite:electricity_bill.db";

    static {
        try {
            Class.forName("org.sqlite.JDBC");
            initializeDatabase();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQLite JDBC Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL);
    }

    private static void initializeDatabase() {
        try (Connection conn = DriverManager.getConnection(DB_URL);
             Statement stmt = conn.createStatement()) {

            // Login table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS Login (" +
                "  login_id   INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  email      TEXT    NOT NULL UNIQUE," +
                "  password   TEXT    NOT NULL," +
                "  user_type  TEXT    NOT NULL CHECK(user_type IN ('Customer','Admin'))," +
                "  status     TEXT    NOT NULL DEFAULT 'Active' CHECK(status IN ('Active','Inactive'))" +
                ")"
            );

            // Customer table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS Customer (" +
                "  consumer_id  INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  name         TEXT NOT NULL," +
                "  email        TEXT NOT NULL UNIQUE," +
                "  mobile       TEXT NOT NULL," +
                "  address      TEXT," +
                "  login_id     INTEGER REFERENCES Login(login_id)" +
                ")"
            );

            // Bill table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS Bill (" +
                "  bill_id      INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  consumer_id  INTEGER NOT NULL REFERENCES Customer(consumer_id)," +
                "  month        TEXT NOT NULL," +
                "  units        REAL NOT NULL," +
                "  amount       REAL NOT NULL," +
                "  due_date     TEXT NOT NULL," +
                "  status       TEXT NOT NULL DEFAULT 'Unpaid' CHECK(status IN ('Unpaid','Paid'))" +
                ")"
            );

            // Payment table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS Payment (" +
                "  payment_id      INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  bill_id         INTEGER NOT NULL UNIQUE REFERENCES Bill(bill_id)," +
                "  consumer_id     INTEGER NOT NULL REFERENCES Customer(consumer_id)," +
                "  amount          REAL NOT NULL," +
                "  payment_date    TEXT NOT NULL," +
                "  payment_mode    TEXT NOT NULL DEFAULT 'Online'," +
                "  transaction_ref TEXT NOT NULL" +
                ")"
            );

            // Complaint table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS Complaint (" +
                "  complaint_id  INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  consumer_id   INTEGER NOT NULL REFERENCES Customer(consumer_id)," +
                "  subject       TEXT NOT NULL," +
                "  description   TEXT NOT NULL," +
                "  status        TEXT NOT NULL DEFAULT 'Open'," +
                "  created_date  TEXT NOT NULL" +
                ")"
            );

            // Seed a default admin if none exists
            try (var ps = conn.prepareStatement(
                    "INSERT OR IGNORE INTO Login(email,password,user_type,status) VALUES(?,?,?,?)")) {
                ps.setString(1, "admin@ebs.com");
                ps.setString(2, "admin123");
                ps.setString(3, "Admin");
                ps.setString(4, "Active");
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize database: " + e.getMessage(), e);
        }
    }
}
