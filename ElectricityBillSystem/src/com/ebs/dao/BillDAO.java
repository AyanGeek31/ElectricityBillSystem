package com.ebs.dao;

import com.ebs.model.Bill;
import com.ebs.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    // US004: View all bills for a consumer
    public List<Bill> getBillsByConsumer(int consumerId) throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM Bill WHERE consumer_id=? ORDER BY bill_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, consumerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bills.add(mapBill(rs));
            }
        }
        return bills;
    }

    // Admin: view all bills with customer name
    public List<Bill> getAllBillsWithCustomer() throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, c.name as customer_name, c.email as customer_email " +
                     "FROM Bill b JOIN Customer c ON b.consumer_id=c.consumer_id " +
                     "ORDER BY b.bill_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill b = mapBill(rs);
                b.setCustomerName(rs.getString("customer_name"));
                b.setCustomerEmail(rs.getString("customer_email"));
                bills.add(b);
            }
        }
        return bills;
    }

    // Get count of unpaid bills for a consumer (for dashboard alert)
    public int getUnpaidBillCount(int consumerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bill WHERE consumer_id=? AND status='Unpaid'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, consumerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Admin: view all bills
    public List<Bill> getAllBills() throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, c.name as cname FROM Bill b JOIN Customer c ON b.consumer_id=c.consumer_id ORDER BY b.bill_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bills.add(mapBill(rs));
            }
        }
        return bills;
    }

    // Get single bill by ID
    public Bill getBillById(int billId) throws SQLException {
        String sql = "SELECT * FROM Bill WHERE bill_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapBill(rs);
        }
        return null;
    }

    // US005: Pay bill - update status, insert payment record
    public boolean payBill(int billId, int consumerId, double amount) throws SQLException {
        return payBill(billId, consumerId, amount, "Online", generateRef());
    }

    private String generateRef() {
        return "TXN" + System.currentTimeMillis();
    }

    public boolean payBill(int billId, int consumerId, double amount, String paymentMode, String txnRef) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Check if already paid
            String checkSQL = "SELECT status FROM Bill WHERE bill_id=?";
            try (PreparedStatement ps = conn.prepareStatement(checkSQL)) {
                ps.setInt(1, billId);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && "Paid".equals(rs.getString("status"))) {
                    throw new SQLException("DUPLICATE_PAYMENT");
                }
            }

            // Update bill status
            String updateSQL = "UPDATE Bill SET status='Paid' WHERE bill_id=? AND consumer_id=?";
            try (PreparedStatement ps = conn.prepareStatement(updateSQL)) {
                ps.setInt(1, billId);
                ps.setInt(2, consumerId);
                int rows = ps.executeUpdate();
                if (rows == 0) throw new SQLException("Bill not found or unauthorized");
            }

            // Insert payment record with unique payment ID (auto-generated)
            String paySQL = "INSERT INTO Payment(bill_id, consumer_id, amount, payment_date, payment_mode, transaction_ref) VALUES(?,?,?,date('now'),?,?)";
            try (PreparedStatement ps = conn.prepareStatement(paySQL)) {
                ps.setInt(1, billId);
                ps.setInt(2, consumerId);
                ps.setDouble(3, amount);
                ps.setString(4, paymentMode);
                ps.setString(5, txnRef);
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

    // US006: View bill history (paid bills)
    public List<Bill> getBillHistory(int consumerId) throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, p.payment_date FROM Bill b " +
                     "LEFT JOIN Payment p ON b.bill_id=p.bill_id " +
                     "WHERE b.consumer_id=? AND b.status='Paid' ORDER BY b.bill_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, consumerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bills.add(mapBill(rs));
            }
        }
        return bills;
    }

    // Get payment record by bill ID (for receipt)
    public com.ebs.model.Payment getPaymentByBillId(int billId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE bill_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                com.ebs.model.Payment p = new com.ebs.model.Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setBillId(rs.getInt("bill_id"));
                p.setConsumerId(rs.getInt("consumer_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setPaymentMode(rs.getString("payment_mode"));
                p.setTransactionRef(rs.getString("transaction_ref"));
                return p;
            }
        }
        return null;
    }

    // Admin: add bill for a consumer
    public boolean addBill(Bill b) throws SQLException {
        String sql = "INSERT INTO Bill(consumer_id, month, units, amount, due_date, status) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, b.getConsumerId());
            ps.setString(2, b.getMonth());
            ps.setDouble(3, b.getUnits());
            ps.setDouble(4, b.getAmount());
            ps.setString(5, b.getDueDate());
            ps.setString(6, "Unpaid");
            return ps.executeUpdate() > 0;
        }
    }

    private Bill mapBill(ResultSet rs) throws SQLException {
        Bill b = new Bill();
        b.setBillId(rs.getInt("bill_id"));
        b.setConsumerId(rs.getInt("consumer_id"));
        b.setMonth(rs.getString("month"));
        b.setUnits(rs.getDouble("units"));
        b.setAmount(rs.getDouble("amount"));
        b.setDueDate(rs.getString("due_date"));
        b.setStatus(rs.getString("status"));
        return b;
    }
}
