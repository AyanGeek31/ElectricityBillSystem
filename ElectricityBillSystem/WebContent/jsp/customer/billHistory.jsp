<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.ebs.model.Bill" %>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    List<Bill> history = (List<Bill>) request.getAttribute("history");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bill History - EBS</title>
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
    <h2>Bill Payment History</h2>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>
    <% if (history == null || history.isEmpty()) { %>
      <div class="empty">📭 No payment history available.</div>
    <% } else { %>
    <table>
      <thead>
        <tr><th>Bill ID</th><th>Month</th><th>Units</th><th>Amount Paid (₹)</th><th>Due Date</th><th>Status</th></tr>
      </thead>
      <tbody>
        <% for (Bill b : history) { %>
        <tr>
          <td>#<%= b.getBillId() %></td>
          <td><%= b.getMonth() %></td>
          <td><%= b.getUnits() %></td>
          <td>₹<%= String.format("%.2f", b.getAmount()) %></td>
          <td><%= b.getDueDate() %></td>
          <td><span class="badge badge-paid">Paid</span></td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>
</body>
</html>
