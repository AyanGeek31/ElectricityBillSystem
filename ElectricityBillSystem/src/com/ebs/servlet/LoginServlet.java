package com.ebs.servlet;

import com.ebs.dao.CustomerDAO;
import com.ebs.dao.LoginDAO;
import com.ebs.model.Customer;
import com.ebs.model.Login;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

// US003 - User Login
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        try {
            LoginDAO loginDAO = new LoginDAO();
            Login login = loginDAO.authenticate(email.trim(), password);

            if (login == null) {
                req.setAttribute("error", "Invalid credentials. Please check your email and password.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
                return;
            }

            if ("Inactive".equals(login.getStatus())) {
                req.setAttribute("error", "Your account has been deactivated. Please contact admin.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
                return;
            }

            // Set session attributes
            HttpSession session = req.getSession(true);
            session.setAttribute("loginId",  login.getLoginId());
            session.setAttribute("email",    login.getEmail());
            session.setAttribute("userType", login.getUserType());

            if ("Customer".equals(login.getUserType())) {
                CustomerDAO custDAO = new CustomerDAO();
                Customer cust = custDAO.getCustomerByLoginId(login.getLoginId());
                session.setAttribute("consumerId", cust.getConsumerId());
                session.setAttribute("customerName", cust.getName());
                resp.sendRedirect(req.getContextPath() + "/jsp/customer/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/jsp/admin/dashboard.jsp");
            }

        } catch (SQLException e) {
            req.setAttribute("error", "Database connection error. Please try again.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }
}
