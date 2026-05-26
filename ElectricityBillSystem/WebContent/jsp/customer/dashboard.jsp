<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ebs.dao.BillDAO" %>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    int unpaidCount = 0;
    try {
        unpaidCount = new BillDAO().getUnpaidBillCount((int) session.getAttribute("consumerId"));
    } catch (Exception e) { /* ignore */ }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Dashboard - EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <span style="color:#cfd8dc;font-size:14px;">Welcome, ${sessionScope.customerName}</span>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="container">
    <h2 style="margin-bottom:16px;color:#1a237e;">My Dashboard</h2>

    <% if (unpaidCount > 0) { %>
    <div style="background:#fff3e0;border:1px solid #ffb74d;border-left:4px solid #e65100;
                border-radius:8px;padding:14px 18px;margin-bottom:24px;display:flex;
                align-items:center;justify-content:space-between;">
        <div>
            <strong style="color:#e65100;">⚠️ You have <%= unpaidCount %> unpaid bill<%= unpaidCount > 1 ? "s" : "" %>!</strong>
            <span style="color:#777;font-size:13px;margin-left:8px;">Please pay before the due date to avoid penalties.</span>
        </div>
        <a href="${pageContext.request.contextPath}/viewBills" class="btn btn-primary btn-sm">Pay Now</a>
    </div>
    <% } else { %>
    <div style="background:#e8f5e9;border:1px solid #a5d6a7;border-left:4px solid #2e7d32;
                border-radius:8px;padding:14px 18px;margin-bottom:24px;">
        <strong style="color:#2e7d32;">✅ All bills are paid.</strong>
        <span style="color:#555;font-size:13px;margin-left:8px;">Great job staying up to date!</span>
    </div>
    <% } %>

    <div class="dash-grid">
        <a class="dash-card" href="${pageContext.request.contextPath}/viewBills"
           style="<%= unpaidCount > 0 ? "border-top-color:#e65100;" : "" %>">
            <div class="icon">🧾</div>
            <div><strong>View Bills</strong></div>
            <div class="label"><%= unpaidCount > 0 ? unpaidCount + " unpaid" : "All paid" %></div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/billHistory">
            <div class="icon">📋</div>
            <div><strong>Bill History</strong></div>
            <div class="label">Past payments</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/registerComplaint">
            <div class="icon">📝</div>
            <div><strong>New Complaint</strong></div>
            <div class="label">Raise an issue</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/searchComplaint">
            <div class="icon">🔍</div>
            <div><strong>Search Complaint</strong></div>
            <div class="label">Find by ID</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/complaintHistory">
            <div class="icon">📂</div>
            <div><strong>Complaint History</strong></div>
            <div class="label">All my complaints</div>
        </a>
        <a class="dash-card" href="${pageContext.request.contextPath}/updateCustomer">
            <div class="icon">👤</div>
            <div><strong>My Profile</strong></div>
            <div class="label">Update details</div>
        </a>
    </div>
</div>
</body>
</html>
