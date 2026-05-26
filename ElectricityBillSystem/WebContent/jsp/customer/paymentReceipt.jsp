<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ebs.model.Payment, com.ebs.model.Bill" %>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    Payment payment = (Payment) request.getAttribute("payment");
    Bill bill       = (Bill)    request.getAttribute("bill");
    if (payment == null || bill == null) {
        response.sendRedirect(request.getContextPath() + "/viewBills"); return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment Successful - EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.receipt-wrap { max-width: 560px; margin: 0 auto; }

.success-header {
    text-align: center; padding: 32px;
    background: linear-gradient(135deg, #2e7d32, #388e3c);
    color: white; border-radius: 12px 12px 0 0;
}
.success-header .checkmark { font-size: 56px; margin-bottom: 8px; }
.success-header h2 { font-size: 24px; margin: 0; }
.success-header p  { margin: 6px 0 0; opacity: 0.85; font-size: 15px; }

.receipt-body {
    background: white; border: 1px solid #e0e0e0;
    border-top: none; border-radius: 0 0 12px 12px;
    overflow: hidden;
}
.receipt-section { padding: 20px 24px; border-bottom: 1px dashed #e0e0e0; }
.receipt-section:last-child { border-bottom: none; }
.receipt-section h4 { color: #555; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 14px; }
.receipt-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; }
.receipt-row span:first-child { color: #777; }
.receipt-row span:last-child  { font-weight: 600; color: #333; }
.receipt-row.highlight span:last-child { color: #2e7d32; font-size: 18px; }

.txn-ref {
    background: #f5f5f5; padding: 10px 14px;
    border-radius: 6px; font-family: monospace;
    font-size: 13px; color: #333; word-break: break-all;
    margin-top: 6px;
}

.receipt-actions { display: flex; gap: 12px; justify-content: center; padding: 20px 24px; }

@media print {
    .navbar, .receipt-actions { display: none; }
    body { background: white; }
}
</style>
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <a href="${pageContext.request.contextPath}/viewBills">My Bills</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="container">
  <div class="receipt-wrap">

    <div class="success-header">
      <div class="checkmark">✅</div>
      <h2>Payment Successful!</h2>
      <p>Your bill has been paid. Keep this receipt for your records.</p>
    </div>

    <div class="receipt-body">

      <!-- Transaction Info -->
      <div class="receipt-section">
        <h4>Transaction Details</h4>
        <div class="receipt-row">
          <span>Payment ID</span>
          <span>#<%= payment.getPaymentId() %></span>
        </div>
        <div class="receipt-row">
          <span>Transaction Reference</span>
        </div>
        <div class="txn-ref"><%= payment.getTransactionRef() %></div>
        <div class="receipt-row" style="margin-top:12px;">
          <span>Payment Date</span>
          <span><%= payment.getPaymentDate() %></span>
        </div>
        <div class="receipt-row">
          <span>Payment Mode</span>
          <span><%= payment.getPaymentMode() %></span>
        </div>
      </div>

      <!-- Bill Info -->
      <div class="receipt-section">
        <h4>Bill Details</h4>
        <div class="receipt-row">
          <span>Bill ID</span>
          <span>#<%= bill.getBillId() %></span>
        </div>
        <div class="receipt-row">
          <span>Consumer ID</span>
          <span><%= bill.getConsumerId() %></span>
        </div>
        <div class="receipt-row">
          <span>Customer Name</span>
          <span>${sessionScope.customerName}</span>
        </div>
        <div class="receipt-row">
          <span>Billing Month</span>
          <span><%= bill.getMonth() %></span>
        </div>
        <div class="receipt-row">
          <span>Units Consumed</span>
          <span><%= bill.getUnits() %> kWh</span>
        </div>
        <div class="receipt-row">
          <span>Due Date</span>
          <span><%= bill.getDueDate() %></span>
        </div>
      </div>

      <!-- Amount -->
      <div class="receipt-section" style="background:#f9fbe7;">
        <div class="receipt-row highlight">
          <span style="font-size:16px;font-weight:600;color:#333;">Amount Paid</span>
          <span>₹<%= String.format("%.2f", payment.getAmount()) %></span>
        </div>
        <div class="receipt-row">
          <span>Status</span>
          <span class="badge badge-paid">✓ PAID</span>
        </div>
      </div>

      <!-- Actions -->
      <div class="receipt-actions">
        <button onclick="window.print()" class="btn" style="background:#e8eaf6;color:#1a237e;">🖨️ Print Receipt</button>
        <a href="${pageContext.request.contextPath}/viewBills" class="btn btn-primary">View All Bills</a>
        <a href="${pageContext.request.contextPath}/billHistory" class="btn" style="background:#e8f5e9;color:#2e7d32;">Payment History</a>
      </div>

    </div><!-- receipt-body -->
  </div><!-- receipt-wrap -->
</div>
</body>
</html>
