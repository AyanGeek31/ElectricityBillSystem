<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.ebs.model.Customer, com.ebs.model.Bill" %>
<%
    if (!"Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    List<Customer> customers  = (List<Customer>) request.getAttribute("customers");
    Customer sel              = (Customer) request.getAttribute("selectedCustomer");
    List<Bill> existingBills  = (List<Bill>) request.getAttribute("existingBills");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Generate Bill - Admin EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.page-grid { display: flex; gap: 24px; align-items: flex-start; }
.left-col  { flex: 0 0 320px; }
.right-col { flex: 1; }

/* Customer card */
.cust-card {
    background: linear-gradient(135deg, #1a237e, #283593);
    color: white; border-radius: 10px; padding: 22px; margin-bottom: 20px;
}
.cust-card h4 { font-size: 11px; text-transform: uppercase; letter-spacing: 1px; color: #90caf9; margin-bottom: 12px; }
.cust-card .name { font-size: 20px; font-weight: 700; margin-bottom: 6px; }
.cust-card .detail { font-size: 13px; color: #b0bec5; margin-bottom: 4px; }
.cust-card .id-badge {
    display: inline-block; background: rgba(255,255,255,0.15);
    padding: 4px 12px; border-radius: 20px; font-size: 13px; margin-top: 8px;
}

/* Bill form */
.bill-form-card { border-left: 4px solid #3949ab; }

/* Rate calculator */
.calc-box {
    background: #e8f5e9; border: 1px solid #a5d6a7;
    border-radius: 8px; padding: 16px; margin-bottom: 16px;
}
.calc-box h4 { color: #2e7d32; margin-bottom: 10px; font-size: 14px; }
.calc-result {
    font-size: 22px; font-weight: 700; color: #1a237e;
    text-align: center; padding: 10px; background: #e8eaf6;
    border-radius: 6px; margin-top: 8px;
}

/* Customer list */
.cust-list { max-height: 300px; overflow-y: auto; }
.cust-item {
    display: flex; justify-content: space-between; align-items: center;
    padding: 10px 12px; border-bottom: 1px solid #f0f0f0; font-size: 13px;
}
.cust-item:hover { background: #f5f5ff; }
.cust-item .cname { font-weight: 600; }
.cust-item .cid { color: #999; font-size: 12px; }

/* Status badges */
.status-unpaid { color: #e65100; font-weight: 700; }
.status-paid   { color: #2e7d32; font-weight: 700; }
</style>
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp">Dashboard</a>
        <a href="${pageContext.request.contextPath}/viewAllBills">All Bills</a>
        <a href="${pageContext.request.contextPath}/viewCustomers">Customers</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="container" style="max-width:1100px;">
  <h2 style="margin-bottom:20px;color:#1a237e;">⚡ Generate Electricity Bill</h2>

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">${error}</div>
  <% } %>
  <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success">✅ ${success}</div>
  <% } %>

  <div class="page-grid">

    <!-- LEFT: Customer Search + List -->
    <div class="left-col">
      <div class="card" style="padding:20px;">
        <h3 style="color:#1a237e;margin-bottom:14px;font-size:16px;">🔍 Find Customer</h3>
        <form method="post" action="${pageContext.request.contextPath}/addBill">
          <input type="hidden" name="action" value="lookup">
          <div style="display:flex;gap:8px;">
            <input type="text" name="searchTerm" placeholder="Enter Consumer ID"
                   style="flex:1;padding:9px 12px;border:1px solid #ddd;border-radius:6px;font-size:14px;"
                   value="<%= sel != null ? sel.getConsumerId() : "" %>">
            <button type="submit" class="btn btn-primary" style="padding:9px 14px;">Search</button>
          </div>
        </form>

        <% if (request.getAttribute("lookupError") != null) { %>
          <div class="alert alert-error" style="margin-top:10px;padding:8px 12px;font-size:13px;">${lookupError}</div>
        <% } %>

        <hr style="margin:16px 0;border:none;border-top:1px solid #eee;">
        <h4 style="font-size:12px;color:#888;text-transform:uppercase;letter-spacing:1px;margin-bottom:10px;">All Customers</h4>
        <div class="cust-list">
          <% if (customers != null) { for (Customer c : customers) { %>
          <div class="cust-item">
            <div>
              <div class="cname"><%= c.getName() %></div>
              <div class="cid">ID: #<%= c.getConsumerId() %> · <%= c.getMobile() %></div>
            </div>
            <a href="${pageContext.request.contextPath}/addBill?consumerId=<%= c.getConsumerId() %>"
               class="btn btn-primary btn-sm">Select</a>
          </div>
          <% } } %>
          <% if (customers == null || customers.isEmpty()) { %>
            <div style="text-align:center;color:#aaa;padding:20px;font-size:13px;">No customers registered yet.</div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- RIGHT: Billing Form + Existing Bills -->
    <div class="right-col">

      <% if (sel != null) { %>
      <!-- Customer Info Card -->
      <div class="cust-card">
        <h4>Selected Customer</h4>
        <div class="name"><%= sel.getName() %></div>
        <div class="detail">📧 <%= sel.getEmail() %></div>
        <div class="detail">📱 <%= sel.getMobile() %></div>
        <% if (sel.getAddress() != null && !sel.getAddress().isEmpty()) { %>
          <div class="detail">📍 <%= sel.getAddress() %></div>
        <% } %>
        <div class="id-badge">Consumer ID: #<%= sel.getConsumerId() %></div>
      </div>

      <!-- Bill Generation Form -->
      <div class="card bill-form-card" style="margin-bottom:20px;">
        <h2>Generate New Bill</h2>
        <form method="post" action="${pageContext.request.contextPath}/addBill" onsubmit="return confirmBill()">
          <input type="hidden" name="action"     value="generate">
          <input type="hidden" name="consumerId" value="<%= sel.getConsumerId() %>">

          <div class="form-row">
            <div class="form-group">
              <label>Billing Month *</label>
              <input type="month" name="month" id="monthInput" required>
            </div>
            <div class="form-group">
              <label>Due Date *</label>
              <input type="date" name="dueDate" id="dueDate" required>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Units Consumed (kWh) *</label>
              <input type="number" step="0.01" min="0" name="units" id="units"
                     placeholder="e.g. 250" oninput="calcAmount()" required>
            </div>
            <div class="form-group">
              <label>Rate per Unit (₹/kWh) *</label>
              <select name="rate" id="rate" onchange="calcAmount()">
                <option value="5.50">Domestic — ₹5.50/unit</option>
                <option value="7.00">Commercial — ₹7.00/unit</option>
                <option value="9.00">Industrial — ₹9.00/unit</option>
                <option value="4.00">Agricultural — ₹4.00/unit</option>
              </select>
            </div>
          </div>

          <!-- Live Amount Calculator -->
          <div class="calc-box">
            <h4>💡 Bill Amount Calculator</h4>
            <div style="display:flex;gap:16px;font-size:13px;color:#555;margin-bottom:8px;">
              <span>Units: <strong id="dispUnits">0</strong> kWh</span>
              <span>×</span>
              <span>Rate: <strong id="dispRate">₹5.50</strong></span>
              <span>=</span>
            </div>
            <div class="calc-result">₹<span id="calcAmount">0.00</span></div>
            <input type="hidden" name="calculatedAmount" id="calcHidden" value="0">
          </div>

          <button type="submit" class="btn btn-primary" style="padding:12px 32px;font-size:15px;">
            ⚡ Generate Bill
          </button>
        </form>
      </div>

      <!-- Existing Bills for this Customer -->
      <div class="card">
        <h2>Billing History — <%= sel.getName() %></h2>
        <% if (existingBills == null || existingBills.isEmpty()) { %>
          <div class="empty">No bills generated for this customer yet.</div>
        <% } else { %>
        <table>
          <thead>
            <tr><th>Bill ID</th><th>Month</th><th>Units</th><th>Amount</th><th>Due Date</th><th>Status</th></tr>
          </thead>
          <tbody>
            <% for (Bill b : existingBills) { %>
            <tr>
              <td>#<%= b.getBillId() %></td>
              <td><%= b.getMonth() %></td>
              <td><%= b.getUnits() %> kWh</td>
              <td><strong>₹<%= String.format("%.2f", b.getAmount()) %></strong></td>
              <td><%= b.getDueDate() %></td>
              <td>
                <% if ("Paid".equals(b.getStatus())) { %>
                  <span class="badge badge-paid">✓ Paid</span>
                <% } else { %>
                  <span class="badge badge-unpaid">⏳ Unpaid</span>
                <% } %>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
        <% } %>
      </div>

      <% } else { %>
      <!-- No customer selected placeholder -->
      <div class="card" style="text-align:center;padding:60px 24px;">
        <div style="font-size:48px;margin-bottom:16px;">👈</div>
        <h3 style="color:#555;margin-bottom:8px;">Select a Customer</h3>
        <p style="color:#aaa;font-size:14px;">Search by Consumer ID or click "Select" from the customer list to generate a bill.</p>
      </div>
      <% } %>

    </div><!-- right col -->
  </div><!-- page grid -->
</div>

<script>
function calcAmount() {
    const units = parseFloat(document.getElementById('units').value) || 0;
    const rate  = parseFloat(document.getElementById('rate').value) || 0;
    const amt   = (units * rate).toFixed(2);
    document.getElementById('dispUnits').textContent  = units;
    document.getElementById('dispRate').textContent   = '₹' + rate.toFixed(2);
    document.getElementById('calcAmount').textContent = amt;
    document.getElementById('calcHidden').value       = amt;
}

function confirmBill() {
    const units  = document.getElementById('units').value;
    const amount = document.getElementById('calcAmount').textContent;
    const month  = document.getElementById('monthInput').value;
    if (!units || parseFloat(units) <= 0) { alert('Please enter valid units consumed.'); return false; }
    return confirm('Generate bill for ' + month + '?\nUnits: ' + units + ' kWh\nAmount: ₹' + amount);
}

// Set month input default to current month and due date to 15 days from now
window.onload = function() {
    const now = new Date();
    const y = now.getFullYear();
    const m = String(now.getMonth() + 1).padStart(2, '0');
    document.getElementById('monthInput').value = y + '-' + m;

    const due = new Date();
    due.setDate(due.getDate() + 15);
    document.getElementById('dueDate').value = due.toISOString().split('T')[0];
    calcAmount();
};
</script>
</body>
</html>
