<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.ebs.model.Complaint" %>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Complaint History - EBS</title>
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
    <h2>My Complaint History</h2>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>
    <% if (complaints == null || complaints.isEmpty()) { %>
      <div class="empty">📭 No complaints registered yet.</div>
    <% } else { %>
    <table>
      <thead>
        <tr><th>ID</th><th>Subject</th><th>Description</th><th>Status</th><th>Date</th></tr>
      </thead>
      <tbody>
        <% for (Complaint c : complaints) { %>
        <tr>
          <td>#<%= c.getComplaintId() %></td>
          <td><%= c.getSubject() %></td>
          <td><%= c.getDescription().length() > 60 ? c.getDescription().substring(0,60)+"..." : c.getDescription() %></td>
          <td><span class="badge badge-open"><%= c.getStatus() %></span></td>
          <td><%= c.getCreatedDate() %></td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>
</body>
</html>
