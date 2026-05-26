package com.ebs.servlet;

import com.ebs.dao.CustomerDAO;
import com.ebs.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

// US001 - Customer Registration
public class CustomerRegistrationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String mobile   = req.getParameter("mobile");
        String address  = req.getParameter("address");
        String password = req.getParameter("password");

        // Basic validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            mobile == null || mobile.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "All mandatory fields are required.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            req.setAttribute("error", "Invalid email format.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        try {
            CustomerDAO dao = new CustomerDAO();

            if (dao.emailExists(email)) {
                req.setAttribute("error", "Email already registered. Please use a different email.");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
                return;
            }

            Customer c = new Customer();
            c.setName(name.trim());
            c.setEmail(email.trim());
            c.setMobile(mobile.trim());
            c.setAddress(address != null ? address.trim() : "");

            dao.registerCustomer(c, password);
            req.setAttribute("success", "Registration successful! Please login.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
        }
    }
}
