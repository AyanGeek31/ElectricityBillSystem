package com.ebs.servlet;

import com.ebs.dao.BillDAO;
import com.ebs.dao.CustomerDAO;
import com.ebs.model.Bill;
import com.ebs.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AddBillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userType"))) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // If a consumerId is passed, load that customer for the billing form
        String consumerIdStr = req.getParameter("consumerId");
        try {
            CustomerDAO custDAO = new CustomerDAO();
            BillDAO billDAO = new BillDAO();

            // Load all customers for the dropdown
            List<Customer> customers = custDAO.getAllCustomers();
            req.setAttribute("customers", customers);

            if (consumerIdStr != null && !consumerIdStr.isEmpty()) {
                Customer c = custDAO.getCustomerById(Integer.parseInt(consumerIdStr));
                if (c != null) {
                    req.setAttribute("selectedCustomer", c);
                    // Load their existing bills
                    List<Bill> existingBills = billDAO.getBillsByConsumer(c.getConsumerId());
                    req.setAttribute("existingBills", existingBills);
                }
            }
            req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userType"))) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        // "lookup" action: find customer by ID or name
        if ("lookup".equals(action)) {
            String searchTerm = req.getParameter("searchTerm");
            try {
                CustomerDAO custDAO = new CustomerDAO();
                List<Customer> customers = custDAO.getAllCustomers();
                req.setAttribute("customers", customers);

                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                    try {
                        int cid = Integer.parseInt(searchTerm.trim());
                        Customer c = custDAO.getCustomerById(cid);
                        if (c != null) {
                            req.setAttribute("selectedCustomer", c);
                            List<Bill> existingBills = new BillDAO().getBillsByConsumer(c.getConsumerId());
                            req.setAttribute("existingBills", existingBills);
                        } else {
                            req.setAttribute("lookupError", "No customer found with ID: " + cid);
                        }
                    } catch (NumberFormatException e) {
                        req.setAttribute("lookupError", "Please enter a valid numeric Consumer ID.");
                    }
                }
                req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);
            } catch (SQLException e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);
            }
            return;
        }

        // "generate" action: create the bill
        String consumerIdStr = req.getParameter("consumerId");
        String month         = req.getParameter("month");
        String unitsStr      = req.getParameter("units");
        String rateStr       = req.getParameter("rate");
        String dueDate       = req.getParameter("dueDate");

        if (consumerIdStr == null || month == null || unitsStr == null || rateStr == null || dueDate == null
                || consumerIdStr.trim().isEmpty() || month.trim().isEmpty() || dueDate.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            try {
                CustomerDAO custDAO = new CustomerDAO();
                req.setAttribute("customers", custDAO.getAllCustomers());
                Customer c = custDAO.getCustomerById(Integer.parseInt(consumerIdStr));
                if (c != null) {
                    req.setAttribute("selectedCustomer", c);
                    req.setAttribute("existingBills", new BillDAO().getBillsByConsumer(c.getConsumerId()));
                }
            } catch (Exception ignore) {}
            req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);
            return;
        }

        try {
            int consumerId    = Integer.parseInt(consumerIdStr.trim());
            double units      = Double.parseDouble(unitsStr.trim());
            double rate       = Double.parseDouble(rateStr.trim());
            double amount     = Math.round(units * rate * 100.0) / 100.0;

            Bill b = new Bill();
            b.setConsumerId(consumerId);
            b.setMonth(month.trim());
            b.setUnits(units);
            b.setAmount(amount);
            b.setDueDate(dueDate.trim());

            new BillDAO().addBill(b);

            // Reload page with updated bill list
            CustomerDAO custDAO = new CustomerDAO();
            Customer c = custDAO.getCustomerById(consumerId);
            req.setAttribute("customers", custDAO.getAllCustomers());
            req.setAttribute("selectedCustomer", c);
            req.setAttribute("existingBills", new BillDAO().getBillsByConsumer(consumerId));
            req.setAttribute("success",
                "Bill generated for " + (c != null ? c.getName() : "Consumer #" + consumerId)
                + " — ₹" + String.format("%.2f", amount) + " for " + month.trim());
            req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid numeric value entered.");
            req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/admin/addBill.jsp").forward(req, resp);
        }
    }
}
