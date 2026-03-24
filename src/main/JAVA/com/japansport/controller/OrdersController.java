package com.japansport.controller;

import com.japansport.dao.OrderDao;
import com.japansport.model.Order;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrdersController", urlPatterns = {"/orders"})
public class OrdersController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("currentUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + req.getContextPath() + "/orders");
            return;
        }

        List<Order> orders = orderDao.getOrdersByUser(u.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/orders.jsp").forward(req, resp);
    }
}
