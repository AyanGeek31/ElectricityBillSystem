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

// US004 - View Bills
public class ViewBillsServlet extends HttpServlet {

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
            BillDAO dao = new BillDAO();
            List<Bill> bills = dao.getBillsByConsumer(consumerId);
            req.setAttribute("bills", bills);
            req.getRequestDispatcher("/jsp/customer/viewBills.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Error retrieving bills: " + e.getMessage());
            req.getRequestDispatcher("/jsp/customer/viewBills.jsp").forward(req, resp);
        }
    }
}
