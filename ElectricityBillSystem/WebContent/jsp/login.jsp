<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Electricity Bill System</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
</nav>
<div class="login-wrapper">
  <div class="card login-card">
    <h2>Sign In</h2>

    <% if (request.getParameter("msg") != null) { %>
      <div class="alert alert-info">${param.msg}</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">${success}</div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" placeholder="Enter your email" required>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="Enter your password" required>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%">Login</button>
    </form>

    <p style="text-align:center;margin-top:18px;font-size:14px;">
      New customer? <a href="${pageContext.request.contextPath}/registerCustomer">Register here</a>
    </p>
    <p style="text-align:center;margin-top:8px;font-size:13px;color:#888;">
      Default Admin: admin@ebs.com / admin123
    </p>
  </div>
</div>
</body>
</html>
