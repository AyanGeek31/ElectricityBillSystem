package com.ebs.dao;

import com.ebs.model.Complaint;
import com.ebs.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    // US007: Register complaint
    public boolean registerComplaint(Complaint c) throws SQLException {
        String sql = "INSERT INTO Complaint(consumer_id, subject, description, status, created_date) VALUES(?,?,?,?,date('now'))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getConsumerId());
            ps.setString(2, c.getSubject());
            ps.setString(3, c.getDescription());
            ps.setString(4, "Open");
            return ps.executeUpdate() > 0;
        }
    }

    // US008: Search complaint by ID
    public Complaint getComplaintById(int complaintId) throws SQLException {
        String sql = "SELECT * FROM Complaint WHERE complaint_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapComplaint(rs);
            }
        }
        return null;
    }

    // US009: Complaint history for a consumer
    public List<Complaint> getComplaintsByConsumer(int consumerId) throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM Complaint WHERE consumer_id=? ORDER BY complaint_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, consumerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                complaints.add(mapComplaint(rs));
            }
        }
        return complaints;
    }

    // Admin: get all complaints
    public List<Complaint> getAllComplaints() throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM Complaint ORDER BY complaint_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                complaints.add(mapComplaint(rs));
            }
        }
        return complaints;
    }

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("complaint_id"));
        c.setConsumerId(rs.getInt("consumer_id"));
        c.setSubject(rs.getString("subject"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setCreatedDate(rs.getString("created_date"));
        return c;
    }
}
