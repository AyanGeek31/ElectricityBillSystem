<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ebs.model.Complaint" %>
<%
    if (session.getAttribute("loginId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    Complaint c = (Complaint) request.getAttribute("complaint");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Complaint - EBS</title>
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
  <div class="card" style="max-width:560px;margin:0 auto;">
    <h2>Search Complaint</h2>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>
    <form method="post" action="${pageContext.request.contextPath}/searchComplaint" style="display:flex;gap:12px;align-items:flex-end;margin-bottom:24px;">
      <div class="form-group" style="flex:1;margin:0;">
        <label>Complaint ID</label>
        <input type="number" name="complaintId" placeholder="Enter complaint ID" required>
      </div>
      <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <% if (c != null) { %>
    <table>
      <tr><th>Complaint ID</th><td>#<%= c.getComplaintId() %></td></tr>
      <tr><th>Consumer ID</th><td><%= c.getConsumerId() %></td></tr>
      <tr><th>Subject</th><td><%= c.getSubject() %></td></tr>
      <tr><th>Description</th><td><%= c.getDescription() %></td></tr>
      <tr><th>Status</th><td><span class="badge badge-open"><%= c.getStatus() %></span></td></tr>
      <tr><th>Date Filed</th><td><%= c.getCreatedDate() %></td></tr>
    </table>
    <% } %>
  </div>
</div>
</body>
</html>
