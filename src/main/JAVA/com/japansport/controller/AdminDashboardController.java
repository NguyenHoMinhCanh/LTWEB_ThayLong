package com.japansport.controller;

import com.japansport.model.User;
import com.japansport.dao.OrderDao;
import com.japansport.dao.ProductDao;
import com.japansport.dao.UserDao;
import com.japansport.model.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final OrderDao orderDao = new OrderDao();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin admin từ session (đã được filter kiểm tra)
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Set attribute cho JSP
        request.setAttribute("adminName", currentUser != null ? currentUser.getName() : "Admin");
        request.setAttribute("pageTitle", "Dashboard");

        // STATS
        int totalProducts = productDao.countAll();
        int totalUsers = userDao.countAllUsers();
        int activeUsers = userDao.countActiveUsers();
        int totalOrders = orderDao.countAllOrders();

        double totalRevenue = orderDao.sumRevenuePaidDone();

        Map<String, Integer> orderStatusCounts = new HashMap<>();
        orderStatusCounts.put("PENDING", orderDao.countByStatus("PENDING"));
        orderStatusCounts.put("PAID", orderDao.countByStatus("PAID"));
        orderStatusCounts.put("SHIPPING", orderDao.countByStatus("SHIPPING"));
        orderStatusCounts.put("DONE", orderDao.countByStatus("DONE"));
        orderStatusCounts.put("CANCEL", orderDao.countByStatus("CANCEL"));

        // Recent orders (top 6) — chỉ fetch đúng 6 dòng từ DB
        List<Order> recentOrders = orderDao.getRecentOrders(6);

        // Revenue chart last 12 months
        Map<String, Double> revenueByMonth = new HashMap<>();
        for (Object[] row : orderDao.revenueByMonthLast12()) {
            String m = (String) row[0];
            Double v = (Double) row[1];
            revenueByMonth.put(m, v);
        }

        DateTimeFormatter monthKeyFmt = DateTimeFormatter.ofPattern("yyyy-MM");
        DateTimeFormatter monthLabelFmt = DateTimeFormatter.ofPattern("MM/yyyy");
        List<String> monthLabels = new ArrayList<>();
        List<Double> monthValues = new ArrayList<>();
        LocalDate now = LocalDate.now();
        for (int i = 11; i >= 0; i--) {
            LocalDate d = now.minusMonths(i);
            String key = d.format(monthKeyFmt);
            monthLabels.add(d.format(monthLabelFmt));
            monthValues.add(revenueByMonth.getOrDefault(key, 0d));
        }

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("orderStatusCounts", orderStatusCounts);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("monthLabels", monthLabels);
        request.setAttribute("monthValues", monthValues);

        // Forward đến trang admin dashboard
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}