package com.ebs.servlet;

import com.ebs.dao.BillDAO;
import com.ebs.model.Bill;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

// US006 - View Bill History
public class BillHistoryServlet extends HttpServlet {

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
            List<Bill> history = new BillDAO().getBillHistory(consumerId);
            req.setAttribute("history", history);
            req.getRequestDispatcher("/jsp/customer/billHistory.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/customer/billHistory.jsp").forward(req, resp);
        }
    }
}
