package com.japansport.controller;

import com.japansport.dao.OrderDao;
import com.japansport.model.Order;
import com.japansport.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageOrderAdminServlet", urlPatterns = {"/admin/orders"})
public class ManageOrderAdminServlet extends HttpServlet {

    private OrderDao orderDao;

    @Override
    public void init() {
        orderDao = new OrderDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "cancel":
                cancelOrder(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "list":
            default:
                showList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            if (status == null || status.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + id + "&error=badstatus");
                return;
            }

            status = status.trim().toUpperCase();

            // Validate status theo enum đang dùng trong Order.getStatusVi()
            if (!status.equals("PENDING") && !status.equals("PAID") && !status.equals("SHIPPING")
                    && !status.equals("DONE") && !status.equals("CANCEL")) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + id + "&error=badstatus");
                return;
            }

            boolean ok;
            // Nếu admin chọn CANCEL thì dùng hàm cancel để hoàn tồn kho (chỉ cho khi đang PENDING)
            if (status.equals("CANCEL")) {
                int rc = orderDao.adminCancelOrder(id);
                ok = (rc == 1);
                if (!ok) {
                    // -1: không còn PENDING, 0: notfound, -2: error
                    if (rc == -1) {
                        response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + id + "&error=badstatus");
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + id + "&error=error");
                    return;
                }
            } else {
                ok = orderDao.adminUpdateStatus(id, status);
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + id + (ok ? "&success=1" : "&error=error"));
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status"); // optional filter
        String keyword = request.getParameter("q");     // optional search (name/email/phone)
        if (status != null && status.isBlank()) status = null;
        if (keyword != null && keyword.isBlank()) keyword = null;

        List<Order> orders = orderDao.adminGetAll(status, keyword);

        request.setAttribute("orders", orders);

        // show flash messages
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            switch (success) {
                case "cancel":
                    request.setAttribute("success", "Đã hủy đơn hàng");
                    break;
                default:
                    request.setAttribute("success", success);
            }
        }
        if (error != null) {
            switch (error) {
                case "notfound":
                    request.setAttribute("error", "Không tìm thấy đơn hàng");
                    break;
                case "badstatus":
                    request.setAttribute("error", "Chỉ hủy được đơn đang ở trạng thái PENDING");
                    break;
                default:
                    request.setAttribute("error", error);
            }
        }
        request.setAttribute("pageTitle", "Quản lý đơn hàng");
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }


    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=list&error=notfound");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=list&error=notfound");
            return;
        }

        int rc = orderDao.adminCancelOrder(id);
        if (rc == 1) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=list&success=cancel");
        } else if (rc == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=list&error=notfound");
        } else if (rc == -1) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + id + "&error=badstatus");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + id + "&error=error");
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Order order = orderDao.adminGetById(id);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=notfound");
            return;
        }

        List<OrderItem> items = orderDao.getOrderItems(id);

        request.setAttribute("order", order);
        request.setAttribute("items", items);
        request.setAttribute("pageTitle", "Chi tiết đơn hàng #" + id);
        request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
    }
}
