<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ebs.model.Customer" %>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    Customer c = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Profile - EBS</title>
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
  <div class="card" style="max-width:500px;margin:0 auto;">
    <h2>Update Profile</h2>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">${success}</div>
    <% } %>
    <form method="post" action="${pageContext.request.contextPath}/updateCustomer">
      <div class="form-group">
        <label>Full Name *</label>
        <input type="text" name="name" value="<%= c != null ? c.getName() : "" %>" required>
      </div>
      <div class="form-group">
        <label>Email (read-only)</label>
        <input type="email" value="<%= c != null ? c.getEmail() : "" %>" disabled style="background:#f5f5f5;">
      </div>
      <div class="form-group">
        <label>Mobile *</label>
        <input type="text" name="mobile" value="<%= c != null ? c.getMobile() : "" %>" required>
      </div>
      <div class="form-group">
        <label>Address</label>
        <textarea name="address" rows="2"><%= c != null && c.getAddress() != null ? c.getAddress() : "" %></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Update Profile</button>
    </form>

    <hr style="margin:24px 0;border:none;border-top:1px solid #eee;">
    <h3 style="color:#c62828;margin-bottom:12px;">Danger Zone</h3>
    <p style="font-size:13px;color:#777;margin-bottom:12px;">Deactivating your account will prevent you from logging in. This action sets your account to Inactive.</p>
    <form method="post" action="${pageContext.request.contextPath}/deleteAccount"
          onsubmit="return confirm('Are you sure you want to deactivate your account? You will be logged out.')">
      <button type="submit" class="btn btn-danger">Deactivate Account</button>
    </form>
  </div>
</div>
</body>
</html>
