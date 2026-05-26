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

// US007 - Register Complaint
public class RegisterComplaintServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("consumerId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }
        req.getRequestDispatcher("/jsp/customer/registerComplaint.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("consumerId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String subject     = req.getParameter("subject");
        String description = req.getParameter("description");
        int consumerId     = (int) session.getAttribute("consumerId");

        if (subject == null || subject.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/jsp/customer/registerComplaint.jsp").forward(req, resp);
            return;
        }

        try {
            Complaint c = new Complaint();
            c.setConsumerId(consumerId);
            c.setSubject(subject.trim());
            c.setDescription(description.trim());

            new ComplaintDAO().registerComplaint(c);
            req.setAttribute("success", "Complaint registered successfully.");
            req.getRequestDispatcher("/jsp/customer/registerComplaint.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/customer/registerComplaint.jsp").forward(req, resp);
        }
    }
}
