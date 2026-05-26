<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.ebs.model.Bill" %>
<%
    if (!"Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    int totalBills = bills != null ? bills.size() : 0;
    int paidBills = 0; int unpaidBills = 0; double totalRevenue = 0; double pendingRevenue = 0;
    if (bills != null) {
        for (Bill b : bills) {
            if ("Paid".equals(b.getStatus())) { paidBills++; totalRevenue += b.getAmount(); }
            else { unpaidBills++; pendingRevenue += b.getAmount(); }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Bills - Admin EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.stats { display:flex; gap:16px; margin-bottom:24px; flex-wrap:wrap; }
.stat-card {
    flex:1; min-width:160px; background:white; border-radius:10px;
    padding:20px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,0.06);
}
.stat-card .val { font-size:28px; font-weight:700; margin-bottom:4px; }
.stat-card .lbl { font-size:12px; color:#888; text-transform:uppercase; letter-spacing:1px; }
.filter-bar { display:flex; gap:12px; margin-bottom:16px; align-items:center; flex-wrap:wrap; }
.filter-bar input { padding:8px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px; width:220px; }
.filter-bar select { padding:8px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px; }
</style>
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp">Dashboard</a>
        <a href="${pageContext.request.contextPath}/addBill">Generate Bill</a>
        <a href="${pageContext.request.contextPath}/viewCustomers">Customers</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="container" style="max-width:1100px;">
    <h2 style="margin-bottom:20px;color:#1a237e;">All Bills Overview</h2>

    <!-- Stats -->
    <div class="stats">
        <div class="stat-card">
            <div class="val" style="color:#1a237e;"><%= totalBills %></div>
            <div class="lbl">Total Bills</div>
        </div>
        <div class="stat-card">
            <div class="val" style="color:#2e7d32;"><%= paidBills %></div>
            <div class="lbl">Paid</div>
        </div>
        <div class="stat-card">
            <div class="val" style="color:#e65100;"><%= unpaidBills %></div>
            <div class="lbl">Unpaid</div>
        </div>
        <div class="stat-card">
            <div class="val" style="color:#2e7d32;font-size:20px;">₹<%= String.format("%.0f", totalRevenue) %></div>
            <div class="lbl">Revenue Collected</div>
        </div>
        <div class="stat-card">
            <div class="val" style="color:#e65100;font-size:20px;">₹<%= String.format("%.0f", pendingRevenue) %></div>
            <div class="lbl">Pending Amount</div>
        </div>
    </div>

    <div class="card">
        <div class="filter-bar">
            <input type="text" id="searchInput" placeholder="🔍 Search customer / bill ID..." oninput="filterTable()">
            <select id="statusFilter" onchange="filterTable()">
                <option value="">All Status</option>
                <option value="Unpaid">Unpaid</option>
                <option value="Paid">Paid</option>
            </select>
            <span style="margin-left:auto;font-size:13px;color:#888;">Showing <span id="rowCount"><%= totalBills %></span> bills</span>
        </div>

        <% if (bills == null || bills.isEmpty()) { %>
          <div class="empty">No bills have been generated yet.</div>
        <% } else { %>
        <table id="billsTable">
            <thead>
                <tr>
                    <th>Bill ID</th>
                    <th>Consumer ID</th>
                    <th>Customer</th>
                    <th>Month</th>
                    <th>Units</th>
                    <th>Amount</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <% for (Bill b : bills) { %>
            <tr data-status="<%= b.getStatus() %>">
                <td>#<%= b.getBillId() %></td>
                <td>#<%= b.getConsumerId() %></td>
                <td>
                    <strong><%= b.getCustomerName() != null ? b.getCustomerName() : "-" %></strong><br>
                    <small style="color:#888;"><%= b.getCustomerEmail() != null ? b.getCustomerEmail() : "" %></small>
                </td>
                <td><%= b.getMonth() %></td>
                <td><%= b.getUnits() %> kWh</td>
                <td><strong>₹<%= String.format("%.2f", b.getAmount()) %></strong></td>
                <td><%= b.getDueDate() %></td>
                <td>
                    <% if ("Paid".equals(b.getStatus())) { %>
                        <span class="badge badge-paid">✓ Paid</span>
                    <% } else { %>
                        <span class="badge badge-unpaid">⏳ Unpaid</span>
                    <% } %>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/addBill?consumerId=<%= b.getConsumerId() %>"
                       class="btn btn-primary btn-sm">View Customer</a>
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
    const search = document.getElementById('searchInput').value.toLowerCase();
    const status = document.getElementById('statusFilter').value;
    const rows   = document.querySelectorAll('#billsTable tbody tr');
    let visible  = 0;
    rows.forEach(row => {
        const text    = row.textContent.toLowerCase();
        const rowStat = row.getAttribute('data-status');
        const matchSearch = text.includes(search);
        const matchStatus = !status || rowStat === status;
        if (matchSearch && matchStatus) { row.style.display = ''; visible++; }
        else row.style.display = 'none';
    });
    document.getElementById('rowCount').textContent = visible;
}
</script>
</body>
</html>
