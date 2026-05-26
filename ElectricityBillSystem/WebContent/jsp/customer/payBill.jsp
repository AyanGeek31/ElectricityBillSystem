<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ebs.model.Bill" %>
<%
    if (session.getAttribute("consumerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }
    Bill bill = (Bill) request.getAttribute("bill");
    if (bill == null) {
        response.sendRedirect(request.getContextPath() + "/viewBills"); return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pay Bill #<%= bill.getBillId() %> - EBS</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
/* Payment page specific styles */
.pay-layout { display: flex; gap: 24px; align-items: flex-start; }
.bill-summary {
    flex: 0 0 300px;
    background: linear-gradient(135deg, #1a237e, #283593);
    color: white; border-radius: 12px; padding: 28px;
}
.bill-summary h3 { margin-bottom: 20px; font-size: 18px; border-bottom: 1px solid rgba(255,255,255,0.3); padding-bottom: 12px; }
.bill-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; }
.bill-row span:first-child { color: #b0bec5; }
.bill-row.total { border-top: 1px solid rgba(255,255,255,0.3); padding-top: 14px; margin-top: 8px; font-size: 20px; font-weight: 700; }
.bill-row.total span:first-child { color: #fff; }

.pay-form { flex: 1; }

/* Payment method tabs */
.method-tabs { display: flex; gap: 0; margin-bottom: 24px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
.method-tab {
    flex: 1; padding: 12px; text-align: center; cursor: pointer;
    background: #f5f5f5; font-size: 14px; font-weight: 600;
    color: #666; border: none; transition: all 0.2s;
}
.method-tab.active { background: #3949ab; color: white; }
.method-tab:hover:not(.active) { background: #e8eaf6; color: #3949ab; }

.method-panel { display: none; }
.method-panel.active { display: block; }

/* Card input styling */
.card-input { font-size: 18px; letter-spacing: 3px; font-family: monospace; }
.card-row { display: flex; gap: 12px; }
.card-row .form-group { flex: 1; }
.secure-badge {
    display: flex; align-items: center; gap: 8px;
    background: #e8f5e9; padding: 10px 14px; border-radius: 6px;
    font-size: 13px; color: #2e7d32; margin-bottom: 18px;
}

/* UPI */
.upi-icons { display: flex; gap: 10px; margin-bottom: 14px; flex-wrap: wrap; }
.upi-icon { padding: 6px 14px; border: 1px solid #ddd; border-radius: 6px; font-size: 12px; font-weight: 700; color: #555; }

/* Net Banking */
.bank-grid { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 16px; }
.bank-option input[type=radio] { display: none; }
.bank-option label {
    display: block; padding: 10px 16px; border: 2px solid #ddd;
    border-radius: 6px; cursor: pointer; font-size: 13px;
    font-weight: 600; color: #555; transition: all 0.2s;
}
.bank-option input[type=radio]:checked + label { border-color: #3949ab; color: #3949ab; background: #e8eaf6; }
</style>
</head>
<body>
<nav class="navbar">
    <span class="brand">⚡ Electricity Bill System</span>
    <div>
        <a href="${pageContext.request.contextPath}/viewBills">← Back to Bills</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="container">
  <h2 style="margin-bottom:20px;color:#1a237e;">Complete Payment</h2>

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">${error}</div>
  <% } %>

  <div class="pay-layout">

    <!-- Bill Summary -->
    <div class="bill-summary">
      <h3>🧾 Bill Summary</h3>
      <div class="bill-row"><span>Bill ID</span><span>#<%= bill.getBillId() %></span></div>
      <div class="bill-row"><span>Month</span><span><%= bill.getMonth() %></span></div>
      <div class="bill-row"><span>Units</span><span><%= bill.getUnits() %> kWh</span></div>
      <div class="bill-row"><span>Due Date</span><span><%= bill.getDueDate() %></span></div>
      <div class="bill-row"><span>Consumer ID</span><span><%= bill.getConsumerId() %></span></div>
      <div class="bill-row"><span>Status</span><span style="color:#ffcc02;font-weight:700;"><%= bill.getStatus() %></span></div>
      <div class="bill-row total">
        <span>Total Due</span>
        <span>₹<%= String.format("%.2f", bill.getAmount()) %></span>
      </div>
    </div>

    <!-- Payment Form -->
    <div class="pay-form card" style="margin:0;">
      <h2 style="margin-bottom:16px;">Choose Payment Method</h2>

      <div class="method-tabs">
        <button class="method-tab active" onclick="showTab('card', this)">💳 Card</button>
        <button class="method-tab" onclick="showTab('upi', this)">📱 UPI</button>
        <button class="method-tab" onclick="showTab('netbanking', this)">🏦 Net Banking</button>
        <button class="method-tab" onclick="showTab('cash', this)">💵 Cash</button>
      </div>

      <!-- CARD -->
      <div id="panel-card" class="method-panel active">
        <form method="post" action="${pageContext.request.contextPath}/payBill" onsubmit="return validateCard()">
          <input type="hidden" name="billId"      value="<%= bill.getBillId() %>">
          <input type="hidden" name="amount"      value="<%= bill.getAmount() %>">
          <input type="hidden" name="paymentMode" value="Card">

          <div class="secure-badge">🔒 Secured by 256-bit SSL Encryption</div>

          <div class="form-group">
            <label>Card Number *</label>
            <input type="text" id="cardNumber" name="cardNumber" class="card-input"
                   placeholder="1234 5678 9012 3456" maxlength="19"
                   oninput="formatCard(this)" required>
          </div>
          <div class="form-group">
            <label>Name on Card *</label>
            <input type="text" name="cardName" placeholder="As printed on card" required>
          </div>
          <div class="card-row">
            <div class="form-group">
              <label>Expiry Date *</label>
              <input type="text" name="expiry" placeholder="MM / YY" maxlength="7"
                     oninput="formatExpiry(this)" required>
            </div>
            <div class="form-group">
              <label>CVV *</label>
              <input type="password" name="cvv" placeholder="•••" maxlength="4" required>
            </div>
          </div>
          <button type="submit" class="btn btn-primary" style="width:100%;padding:14px;font-size:16px;margin-top:8px;">
            Pay ₹<%= String.format("%.2f", bill.getAmount()) %>
          </button>
        </form>
      </div>

      <!-- UPI -->
      <div id="panel-upi" class="method-panel">
        <form method="post" action="${pageContext.request.contextPath}/payBill" onsubmit="return validateUpi()">
          <input type="hidden" name="billId"      value="<%= bill.getBillId() %>">
          <input type="hidden" name="amount"      value="<%= bill.getAmount() %>">
          <input type="hidden" name="paymentMode" value="UPI">

          <p style="font-size:14px;color:#555;margin-bottom:14px;">Pay using any UPI app</p>
          <div class="upi-icons">
            <span class="upi-icon" style="color:#00b300;">GPay</span>
            <span class="upi-icon" style="color:#6739b7;">PhonePe</span>
            <span class="upi-icon" style="color:#002970;">Paytm</span>
            <span class="upi-icon" style="color:#e31837;">BHIM</span>
          </div>
          <div class="form-group">
            <label>UPI ID *</label>
            <input type="text" id="upiId" name="upiId" placeholder="yourname@upi" required>
          </div>
          <div class="secure-badge">🔒 UPI payments are secured by NPCI</div>
          <button type="submit" class="btn btn-primary" style="width:100%;padding:14px;font-size:16px;">
            Pay ₹<%= String.format("%.2f", bill.getAmount()) %>
          </button>
        </form>
      </div>

      <!-- NET BANKING -->
      <div id="panel-netbanking" class="method-panel">
        <form method="post" action="${pageContext.request.contextPath}/payBill">
          <input type="hidden" name="billId"      value="<%= bill.getBillId() %>">
          <input type="hidden" name="amount"      value="<%= bill.getAmount() %>">
          <input type="hidden" name="paymentMode" value="Net Banking">

          <p style="font-size:14px;color:#555;margin-bottom:14px;">Select your bank</p>
          <div class="bank-grid">
            <div class="bank-option"><input type="radio" name="bank" id="sbi"  value="SBI"><label for="sbi">SBI</label></div>
            <div class="bank-option"><input type="radio" name="bank" id="hdfc" value="HDFC"><label for="hdfc">HDFC</label></div>
            <div class="bank-option"><input type="radio" name="bank" id="icici" value="ICICI"><label for="icici">ICICI</label></div>
            <div class="bank-option"><input type="radio" name="bank" id="axis" value="Axis"><label for="axis">Axis</label></div>
            <div class="bank-option"><input type="radio" name="bank" id="kotak" value="Kotak"><label for="kotak">Kotak</label></div>
            <div class="bank-option"><input type="radio" name="bank" id="pnb" value="PNB"><label for="pnb">PNB</label></div>
          </div>
          <div class="secure-badge">🔒 You will be redirected to your bank's secure portal</div>
          <button type="submit" class="btn btn-primary" style="width:100%;padding:14px;font-size:16px;">
            Pay ₹<%= String.format("%.2f", bill.getAmount()) %>
          </button>
        </form>
      </div>

      <!-- CASH / COUNTER -->
      <div id="panel-cash" class="method-panel">
        <form method="post" action="${pageContext.request.contextPath}/payBill">
          <input type="hidden" name="billId"      value="<%= bill.getBillId() %>">
          <input type="hidden" name="amount"      value="<%= bill.getAmount() %>">
          <input type="hidden" name="paymentMode" value="Cash at Counter">

          <div class="alert alert-info" style="margin-bottom:18px;">
            ℹ️ This option marks your bill as paid at the counter. Use this only if you have paid cash at the electricity office.
          </div>
          <div class="bill-row" style="font-size:16px;margin-bottom:16px;">
            <span style="color:#555;">Amount to Pay:</span>
            <strong style="color:#1a237e;font-size:22px;">₹<%= String.format("%.2f", bill.getAmount()) %></strong>
          </div>
          <button type="submit" class="btn btn-success" style="width:100%;padding:14px;font-size:16px;">
            ✅ Confirm Cash Payment
          </button>
        </form>
      </div>

    </div><!-- end pay-form -->
  </div><!-- end pay-layout -->
</div>

<script>
function showTab(name, btn) {
    document.querySelectorAll('.method-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.method-tab').forEach(t => t.classList.remove('active'));
    document.getElementById('panel-' + name).classList.add('active');
    btn.classList.add('active');
}

function formatCard(input) {
    let v = input.value.replace(/\D/g, '').substring(0, 16);
    input.value = v.replace(/(.{4})/g, '$1 ').trim();
}

function formatExpiry(input) {
    let v = input.value.replace(/\D/g, '').substring(0, 4);
    if (v.length >= 3) v = v.substring(0,2) + ' / ' + v.substring(2);
    input.value = v;
}

function validateCard() {
    const num = document.getElementById('cardNumber').value.replace(/\s/g,'');
    if (num.length < 12) { alert('Please enter a valid card number.'); return false; }
    return true;
}

function validateUpi() {
    const upi = document.getElementById('upiId').value.trim();
    if (!upi.includes('@')) { alert('Please enter a valid UPI ID (e.g. name@upi).'); return false; }
    return true;
}
</script>
</body>
</html>
