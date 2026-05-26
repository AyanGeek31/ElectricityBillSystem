package com.ebs.servlet;

import com.ebs.dao.LoginDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

// US002 - Administrator Registration (only accessible by logged-in admins)
public class AdminRegistrationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userType"))) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }
        req.getRequestDispatcher("/jsp/admin/registerAdmin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userType"))) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/jsp/admin/registerAdmin.jsp").forward(req, resp);
            return;
        }

        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            req.setAttribute("error", "Invalid email format.");
            req.getRequestDispatcher("/jsp/admin/registerAdmin.jsp").forward(req, resp);
            return;
        }

        try {
            LoginDAO dao = new LoginDAO();
            if (dao.emailExists(email.trim())) {
                req.setAttribute("error", "Email already exists in the system.");
                req.getRequestDispatcher("/jsp/admin/registerAdmin.jsp").forward(req, resp);
                return;
            }
            dao.registerAdmin(email.trim(), password);
            req.setAttribute("success", "Admin registered successfully.");
            req.getRequestDispatcher("/jsp/admin/registerAdmin.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/admin/registerAdmin.jsp").forward(req, resp);
        }
    }
}
