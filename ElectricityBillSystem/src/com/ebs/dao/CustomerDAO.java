package com.ebs.dao;

import com.ebs.model.Customer;
import com.ebs.model.Login;
import com.ebs.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // US001: Register customer - stores in Customer and Login tables
    public boolean registerCustomer(Customer c, String password) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert into Login
            String loginSQL = "INSERT INTO Login(email, password, user_type, status) VALUES(?,?,?,?)";
            int loginId;
            try (PreparedStatement ps = conn.prepareStatement(loginSQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, c.getEmail());
                ps.setString(2, password);
                ps.setString(3, "Customer");
                ps.setString(4, "Active");
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (!rs.next()) throw new SQLException("Failed to get login ID");
                loginId = rs.getInt(1);
            }

            // Insert into Customer
            String custSQL = "INSERT INTO Customer(name, email, mobile, address, login_id) VALUES(?,?,?,?,?)";
            try (PreparedStatement ps = conn.prepareStatement(custSQL)) {
                ps.setString(1, c.getName());
                ps.setString(2, c.getEmail());
                ps.setString(3, c.getMobile());
                ps.setString(4, c.getAddress());
                ps.setInt(5, loginId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }

    // Check if email already exists in Login table
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM Login WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    // Get customer by login_id (for session after login)
    public Customer getCustomerByLoginId(int loginId) throws SQLException {
        String sql = "SELECT * FROM Customer WHERE login_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loginId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setConsumerId(rs.getInt("consumer_id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setMobile(rs.getString("mobile"));
                c.setAddress(rs.getString("address"));
                c.setLoginId(rs.getInt("login_id"));
                return c;
            }
        }
        return null;
    }

    // US010: Update customer profile
    public boolean updateCustomer(Customer c) throws SQLException {
        String sql = "UPDATE Customer SET name=?, mobile=?, address=? WHERE consumer_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getMobile());
            ps.setString(3, c.getAddress());
            ps.setInt(4, c.getConsumerId());
            return ps.executeUpdate() > 0;
        }
    }

    // Get all active customers (for admin)
    public List<Customer> getAllCustomers() throws SQLException {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT c.*, l.status as acc_status FROM Customer c " +
                     "JOIN Login l ON c.login_id = l.login_id " +
                     "WHERE l.user_type='Customer' ORDER BY c.consumer_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer c = new Customer();
                c.setConsumerId(rs.getInt("consumer_id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setMobile(rs.getString("mobile"));
                c.setAddress(rs.getString("address"));
                c.setLoginId(rs.getInt("login_id"));
                list.add(c);
            }
        }
        return list;
    }

    // Get customer by consumer_id (for admin billing)
    public Customer getCustomerById(int consumerId) throws SQLException {
        String sql = "SELECT * FROM Customer WHERE consumer_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, consumerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setConsumerId(rs.getInt("consumer_id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setMobile(rs.getString("mobile"));
                c.setAddress(rs.getString("address"));
                c.setLoginId(rs.getInt("login_id"));
                return c;
            }
        }
        return null;
    }

    // US011: Soft delete - set status to Inactive in Login table
    public boolean softDeleteAccount(int loginId) throws SQLException {
        String sql = "UPDATE Login SET status='Inactive' WHERE login_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loginId);
            return ps.executeUpdate() > 0;
        }
    }
}
