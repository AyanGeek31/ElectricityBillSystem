package com.ebs.servlet;

import com.ebs.dao.ComplaintDAO;
import com.ebs.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

// US008 - Search Complaint
public class SearchComplaintServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loginId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }
        req.getRequestDispatcher("/jsp/customer/searchComplaint.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loginId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String idStr = req.getParameter("complaintId");
        if (idStr == null || idStr.trim().isEmpty()) {
            req.setAttribute("error", "Please enter a Complaint ID.");
            req.getRequestDispatcher("/jsp/customer/searchComplaint.jsp").forward(req, resp);
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            Complaint c = new ComplaintDAO().getComplaintById(id);
            if (c == null) {
                req.setAttribute("error", "Complaint ID " + id + " not found.");
            } else {
                req.setAttribute("complaint", c);
            }
            req.getRequestDispatcher("/jsp/customer/searchComplaint.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid Complaint ID format.");
            req.getRequestDispatcher("/jsp/customer/searchComplaint.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/customer/searchComplaint.jsp").forward(req, resp);
        }
    }
}
