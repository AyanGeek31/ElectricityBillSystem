<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.ebs.model.Bill" %>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Bills - EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <a href="${pageContext.request.contextPath}/jsp/customer/dashboard.jsp">Dashboard</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="container">
  <div class="card">
    <h2>My Bills</h2>

    <% if (request.getParameter("success") != null) { %>
      <div class="alert alert-success">${param.success}</div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
      <div class="alert alert-error">${param.error}</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>

    <% if (bills == null || bills.isEmpty()) { %>
      <div class="empty">📭 No bills found for your account.</div>
    <% } else { %>
    <table>
      <thead>
        <tr><th>Bill ID</th><th>Month</th><th>Units</th><th>Amount (₹)</th><th>Due Date</th><th>Status</th><th>Action</th></tr>
      </thead>
      <tbody>
        <% for (Bill b : bills) { %>
        <tr>
          <td>#<%= b.getBillId() %></td>
          <td><%= b.getMonth() %></td>
          <td><%= b.getUnits() %></td>
          <td>₹<%= String.format("%.2f", b.getAmount()) %></td>
          <td><%= b.getDueDate() %></td>
          <td><span class="badge <%= "Paid".equals(b.getStatus()) ? "badge-paid" : "badge-unpaid" %>"><%= b.getStatus() %></span></td>
          <td>
            <% if ("Unpaid".equals(b.getStatus())) { %>
            <a href="${pageContext.request.contextPath}/payBill?billId=<%= b.getBillId() %>"
               class="btn btn-success btn-sm">Pay Now</a>
            <% } else { %>
              <span style="color:#999;font-size:13px;">Paid ✓</span>
            <% } %>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>
</body>
</html>
