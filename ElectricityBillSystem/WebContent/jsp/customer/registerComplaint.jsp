<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register Complaint - EBS</title>
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
    <h2>Register Complaint</h2>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">${success}</div>
    <% } %>
    <form method="post" action="${pageContext.request.contextPath}/registerComplaint">
      <div class="form-group">
        <label>Subject *</label>
        <input type="text" name="subject" placeholder="Brief subject of complaint" required>
      </div>
      <div class="form-group">
        <label>Description *</label>
        <textarea name="description" rows="4" placeholder="Describe your issue in detail..." required></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Submit Complaint</button>
      <a href="${pageContext.request.contextPath}/complaintHistory" class="btn" style="background:#e8eaf6;color:#1a237e;margin-left:8px;">View History</a>
    </form>
  </div>
</div>
</body>
</html>
