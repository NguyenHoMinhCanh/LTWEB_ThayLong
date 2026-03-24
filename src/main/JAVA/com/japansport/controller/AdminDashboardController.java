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

        // ========== STATS ==========
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

        // Recent orders (top 6)
        List<Order> recentOrders = orderDao.adminGetAll(null, null);
        if (recentOrders != null && recentOrders.size() > 6) {
            recentOrders = recentOrders.subList(0, 6);
        }

        // Revenue chart last 7 days (PAID/DONE)
        Map<String, Double> revenueByDay = new HashMap<>();
        for (Object[] row : orderDao.revenueByDayLastNDays(7)) {
            Date d = (Date) row[0];
            Double v = (Double) row[1];
            revenueByDay.put(d.toString(), v);
        }
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");
        List<String> chartLabels = new ArrayList<>();
        List<Double> chartValues = new ArrayList<>();
        LocalDate today = LocalDate.now();
        for (int i = 6; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            chartLabels.add(day.format(fmt));
            chartValues.add(revenueByDay.getOrDefault(day.toString(), 0d));
        }

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("orderStatusCounts", orderStatusCounts);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("chartLabels", chartLabels);
        request.setAttribute("chartValues", chartValues);

        // Forward đến trang admin dashboard
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}