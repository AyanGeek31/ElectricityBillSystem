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
import java.util.List;

// US009 - Complaint History
public class ComplaintHistoryServlet extends HttpServlet {

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
            List<Complaint> complaints = new ComplaintDAO().getComplaintsByConsumer(consumerId);
            req.setAttribute("complaints", complaints);
            req.getRequestDispatcher("/jsp/customer/complaintHistory.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/customer/complaintHistory.jsp").forward(req, resp);
        }
    }
}
