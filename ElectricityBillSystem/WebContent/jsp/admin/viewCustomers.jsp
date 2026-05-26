<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.ebs.model.Customer" %>
<%
    if (!"Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Customers - Admin EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.filter-bar { display:flex; gap:12px; margin-bottom:16px; }
.filter-bar input { padding:8px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px; width:260px; }
</style>
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp">Dashboard</a>
        <a href="${pageContext.request.contextPath}/addBill">Generate Bill</a>
        <a href="${pageContext.request.contextPath}/viewAllBills">All Bills</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="container" style="max-width:1000px;">
    <h2 style="margin-bottom:20px;color:#1a237e;">All Registered Customers</h2>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>

    <div class="card">
        <div class="filter-bar">
            <input type="text" id="searchInput" placeholder="🔍 Search by name, email, ID..." oninput="filterTable()">
            <span style="margin-left:auto;font-size:13px;color:#888;align-self:center;">
                Total: <strong><%= customers != null ? customers.size() : 0 %></strong> customers
            </span>
        </div>

        <% if (customers == null || customers.isEmpty()) { %>
          <div class="empty">No customers registered yet.</div>
        <% } else { %>
        <table id="custTable">
            <thead>
                <tr><th>Consumer ID</th><th>Name</th><th>Email</th><th>Mobile</th><th>Address</th><th>Actions</th></tr>
            </thead>
            <tbody>
            <% for (Customer c : customers) { %>
            <tr>
                <td><strong>#<%= c.getConsumerId() %></strong></td>
                <td><%= c.getName() %></td>
                <td><%= c.getEmail() %></td>
                <td><%= c.getMobile() %></td>
                <td><%= c.getAddress() != null && !c.getAddress().isEmpty() ? c.getAddress() : "-" %></td>
                <td>
                    <a href="${pageContext.request.contextPath}/addBill?consumerId=<%= c.getConsumerId() %>"
                       class="btn btn-primary btn-sm">Generate Bill</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
<script>
function filterTable() {
    const q    = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('#custTable tbody tr');
    rows.forEach(r => r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none');
}
</script>
</body>
</html>
