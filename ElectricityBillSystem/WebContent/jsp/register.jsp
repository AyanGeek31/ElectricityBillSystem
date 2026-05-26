<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Registration - EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div><a href="${pageContext.request.contextPath}/jsp/login.jsp">Login</a></div>
</nav>
<div class="container">
  <div class="card" style="max-width:500px;margin:32px auto;">
    <h2>Customer Registration</h2>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/registerCustomer">
      <div class="form-group">
        <label>Full Name *</label>
        <input type="text" name="name" placeholder="Enter full name" required>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Email *</label>
          <input type="email" name="email" placeholder="Enter email" required>
        </div>
        <div class="form-group">
          <label>Mobile *</label>
          <input type="text" name="mobile" placeholder="Mobile number" required>
        </div>
      </div>
      <div class="form-group">
        <label>Address</label>
        <textarea name="address" rows="2" placeholder="Enter address"></textarea>
      </div>
      <div class="form-group">
        <label>Password *</label>
        <input type="password" name="password" placeholder="Create password" required>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%">Register</button>
    </form>
    <p style="text-align:center;margin-top:16px;font-size:14px;">
      Already registered? <a href="${pageContext.request.contextPath}/jsp/login.jsp">Login</a>
    </p>
  </div>
</div>
</body>
</html>
