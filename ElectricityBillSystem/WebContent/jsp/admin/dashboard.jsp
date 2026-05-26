<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ebs.dao.BillDAO, com.ebs.dao.CustomerDAO, com.ebs.dao.ComplaintDAO" %>
<%
    if (!"Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    int totalCustomers = 0; int totalBills = 0; int unpaidBills = 0; int openComplaints = 0;
    try {
        totalCustomers = new CustomerDAO().getAllCustomers().size();
        java.util.List<com.ebs.model.Bill> allBills = new BillDAO().getAllBillsWithCustomer();
        totalBills = allBills.size();
        for (com.ebs.model.Bill b : allBills) if ("Unpaid".equals(b.getStatus())) unpaidBills++;
        openComplaints = new ComplaintDAO().getAllComplaints().size();
    } catch (Exception e) { /* show zeros */ }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.stats { display:flex; gap:16px; margin-bottom:28px; flex-wrap:wrap; }
.stat-card {
    flex:1; min-width:150px; background:white; border-radius:10px;
    padding:20px 16px; text-align:center;
    box-shadow:0 2px 8px rgba(0,0,0,0.06); border-top:4px solid #3949ab;
}
.stat-card .val { font-size:32px; font-weight:700; color:#1a237e; }
.stat-card .lbl { font-size:12px; color:#888; margin-top:4px; text-transform:uppercase; letter-spacing:1px; }
</style>
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <span style="color:#cfd8dc;font-size:14px;">Admin: ${sessionScope.email}</span>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="container">
    <h2 style="margin-bottom:8px;color:#1a237e;">Admin Dashboard</h2>
    <p style="color:#888;margin-bottom:24px;font-size:14px;">Manage customers, generate bills, and monitor payments.</p>

    <!-- Stats Row -->
    <div class="stats">
        <div class="stat-card">
            <div class="val"><%= totalCustomers %></div>
            <div class="lbl">Customers</div>
        </div>
        <div class="stat-card">
            <div class="val"><%= totalBills %></div>
            <div class="lbl">Total Bills</div>
        </div>
        <div class="stat-card" style="border-top-color:#e65100;">
            <div class="val" style="color:#e65100;"><%= unpaidBills %></div>
            <div class="lbl">Unpaid Bills</div>
        </div>
        <div class="stat-card" style="border-top-color:#f57c00;">
            <div class="val" style="color:#f57c00;"><%= openComplaints %></div>
            <div class="lbl">Complaints</div>
        </div>
    </div>

    <!-- Action Cards -->
    <div class="dash-grid">
        <a class="dash-card" href="${pageContext.request.contextPath}/viewCustomers">
            <div class="icon">👥</div>
            <div><strong>View Customers</strong></div>
            <div class="label">All registered customers</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/addBill" style="border-top-color:#2e7d32;">
            <div class="icon">⚡</div>
            <div><strong>Generate Bill</strong></div>
            <div class="label">Create bill for customer</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/viewAllBills" style="border-top-color:#e65100;">
            <div class="icon">🧾</div>
            <div><strong>All Bills</strong></div>
            <div class="label">View & track payments</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/searchComplaint" style="border-top-color:#f57c00;">
            <div class="icon">📋</div>
            <div><strong>Complaints</strong></div>
            <div class="label">Search complaints</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/registerAdmin" style="border-top-color:#6a1b9a;">
            <div class="icon">👤</div>
            <div><strong>Add Admin</strong></div>
            <div class="label">Register new admin</div>
        </a>
    </div>
</div>
</body>
</html>
