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

public class ViewAllBillsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userType"))) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }
        try {
            List<Bill> bills = new BillDAO().getAllBillsWithCustomer();
            req.setAttribute("bills", bills);
            req.getRequestDispatcher("/jsp/admin/viewAllBills.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/admin/viewAllBills.jsp").forward(req, resp);
        }
    }
}
