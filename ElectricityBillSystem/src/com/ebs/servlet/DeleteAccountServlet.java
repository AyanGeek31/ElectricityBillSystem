package com.ebs.servlet;

import com.ebs.dao.CustomerDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

// US011 - Soft Delete Account
public class DeleteAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loginId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        int loginId = (int) session.getAttribute("loginId");
        try {
            new CustomerDAO().softDeleteAccount(loginId);
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?msg=Account+deactivated+successfully");
        } catch (SQLException e) {
            req.setAttribute("error", "Could not delete account: " + e.getMessage());
            req.getRequestDispatcher("/jsp/customer/updateProfile.jsp").forward(req, resp);
        }
    }
}
