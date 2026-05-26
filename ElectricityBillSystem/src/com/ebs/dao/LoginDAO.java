package com.ebs.dao;

import com.ebs.model.Login;
import com.ebs.util.DBConnection;

import java.sql.*;

public class LoginDAO {

    // US002: Register admin
    public boolean registerAdmin(String email, String password) throws SQLException {
        String sql = "INSERT INTO Login(email, password, user_type, status) VALUES(?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, "Admin");
            ps.setString(4, "Active");
            ps.executeUpdate();
            return true;
        }
    }

    // US003: User login - validates credentials, checks status
    public Login authenticate(String email, String password) throws SQLException {
        String sql = "SELECT * FROM Login WHERE email=? AND password=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Login l = new Login();
                l.setLoginId(rs.getInt("login_id"));
                l.setEmail(rs.getString("email"));
                l.setUserType(rs.getString("user_type"));
                l.setStatus(rs.getString("status"));
                return l;
            }
        }
        return null;
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM Login WHERE email=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        }
    }
}
