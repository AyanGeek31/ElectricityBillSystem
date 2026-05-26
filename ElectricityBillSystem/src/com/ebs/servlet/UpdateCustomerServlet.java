package com.ebs.servlet;

import com.ebs.dao.CustomerDAO;
import com.ebs.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

// US010 - Customer Details Update
public class UpdateCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("consumerId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }
        int consumerId = (int) session.getAttribute("consumerId");
        try {
            Customer c = new CustomerDAO().getCustomerByLoginId((int) session.getAttribute("loginId"));
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/jsp/customer/updateProfile.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Error loading profile.");
            req.getRequestDispatcher("/jsp/customer/updateProfile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("consumerId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String name    = req.getParameter("name");
        String mobile  = req.getParameter("mobile");
        String address = req.getParameter("address");
        int consumerId = (int) session.getAttribute("consumerId");

        if (name == null || name.trim().isEmpty() || mobile == null || mobile.trim().isEmpty()) {
            req.setAttribute("error", "Name and mobile are required.");
            req.getRequestDispatcher("/jsp/customer/updateProfile.jsp").forward(req, resp);
            return;
        }

        try {
            Customer c = new Customer();
            c.setConsumerId(consumerId);
            c.setName(name.trim());
            c.setMobile(mobile.trim());
            c.setAddress(address != null ? address.trim() : "");

            new CustomerDAO().updateCustomer(c);
            session.setAttribute("customerName", name.trim());
            req.setAttribute("success", "Profile updated successfully.");
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/jsp/customer/updateProfile.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/customer/updateProfile.jsp").forward(req, resp);
        }
    }
}
