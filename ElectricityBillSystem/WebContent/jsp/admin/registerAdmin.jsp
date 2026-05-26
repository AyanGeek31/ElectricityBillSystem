<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (!"Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register Admin - EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp">Dashboard</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="container">
  <div class="card" style="max-width:440px;margin:0 auto;">
    <h2>Register New Admin</h2>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">${success}</div>
    <% } %>
    <form method="post" action="${pageContext.request.contextPath}/registerAdmin">
      <div class="form-group">
        <label>Email *</label>
        <input type="email" name="email" placeholder="Admin email address" required>
      </div>
      <div class="form-group">
        <label>Password *</label>
        <input type="password" name="password" placeholder="Create password" required>
      </div>
      <button type="submit" class="btn btn-primary">Register Admin</button>
    </form>
  </div>
</div>
</body>
</html>
