package com.ebs.servlet;

import com.ebs.dao.BillDAO;
import com.ebs.model.Bill;
import com.ebs.model.Payment;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

// US005 - Pay Bill (with checkout page and receipt)
public class PayBillServlet extends HttpServlet {

    // GET: show checkout / payment page for a specific bill
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("consumerId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String billIdStr = req.getParameter("billId");
        if (billIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/viewBills");
            return;
        }

        try {
            int billId = Integer.parseInt(billIdStr);
            BillDAO dao = new BillDAO();
            Bill bill = dao.getBillById(billId);

            if (bill == null) {
                req.setAttribute("error", "Bill not found.");
                resp.sendRedirect(req.getContextPath() + "/viewBills?error=Bill+not+found");
                return;
            }
            if ("Paid".equals(bill.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/viewBills?error=Bill+already+paid");
                return;
            }

            req.setAttribute("bill", bill);
            req.getRequestDispatcher("/jsp/customer/payBill.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/viewBills?error=Invalid+bill+ID");
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/viewBills?error=DB+error");
        }
    }

    // POST: process the payment
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("consumerId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String billIdStr    = req.getParameter("billId");
        String amountStr    = req.getParameter("amount");
        String paymentMode  = req.getParameter("paymentMode");

        // Card / UPI extra fields (just stored as part of mode for display)
        String cardNumber   = req.getParameter("cardNumber");
        String upiId        = req.getParameter("upiId");

        if (billIdStr == null || amountStr == null || paymentMode == null) {
            resp.sendRedirect(req.getContextPath() + "/viewBills?error=Invalid+request");
            return;
        }

        int consumerId = (int) session.getAttribute("consumerId");

        try {
            int billId     = Integer.parseInt(billIdStr);
            double amount  = Double.parseDouble(amountStr);
            BillDAO dao    = new BillDAO();

            // Build a transaction reference
            String txnRef  = "TXN" + System.currentTimeMillis();

            // Validate payment mode specific fields
            if ("Card".equals(paymentMode)) {
                if (cardNumber == null || cardNumber.replaceAll("\\s","").length() < 12) {
                    req.setAttribute("bill", dao.getBillById(billId));
                    req.setAttribute("error", "Please enter a valid card number.");
                    req.getRequestDispatcher("/jsp/customer/payBill.jsp").forward(req, resp);
                    return;
                }
                // Mask card number for receipt
                String masked = "**** **** **** " + cardNumber.replaceAll("\\s","").substring(cardNumber.replaceAll("\\s","").length() - 4);
                paymentMode = "Card (" + masked + ")";
            } else if ("UPI".equals(paymentMode)) {
                if (upiId == null || upiId.trim().isEmpty()) {
                    req.setAttribute("bill", dao.getBillById(billId));
                    req.setAttribute("error", "Please enter your UPI ID.");
                    req.getRequestDispatcher("/jsp/customer/payBill.jsp").forward(req, resp);
                    return;
                }
                paymentMode = "UPI (" + upiId.trim() + ")";
            }

            dao.payBill(billId, consumerId, amount, paymentMode, txnRef);

            // Fetch payment record for receipt
            Payment payment = dao.getPaymentByBillId(billId);
            Bill bill       = dao.getBillById(billId);

            req.setAttribute("payment", payment);
            req.setAttribute("bill", bill);
            req.setAttribute("customerName", session.getAttribute("customerName"));
            req.getRequestDispatcher("/jsp/customer/paymentReceipt.jsp").forward(req, resp);

        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("DUPLICATE_PAYMENT")) {
                resp.sendRedirect(req.getContextPath() + "/viewBills?error=Bill+already+paid");
            } else {
                resp.sendRedirect(req.getContextPath() + "/viewBills?error=Payment+failed");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/viewBills?error=Invalid+data");
        }
    }
}
