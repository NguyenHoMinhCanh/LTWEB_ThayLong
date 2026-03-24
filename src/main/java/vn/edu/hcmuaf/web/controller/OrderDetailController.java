package vn.edu.hcmuaf.web.controller;

import com.japansport.dao.OrderDao;
import com.japansport.model.Order;
import com.japansport.model.OrderItem;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/order-detail"})
public class OrderDetailController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User u = (User) session.getAttribute("currentUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + req.getContextPath() + "/orders");
            return;
        }

        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) {
            session.setAttribute("FLASH_MSG", "Mã đơn hàng không hợp lệ.");
            session.setAttribute("FLASH_TYPE", "danger");
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        Order order = orderDao.getOrderByIdForUser(id, u.getId());
        if (order == null) {
            session.setAttribute("FLASH_MSG", "Không tìm thấy đơn hàng hoặc bạn không có quyền xem đơn này.");
            session.setAttribute("FLASH_TYPE", "danger");
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        List<OrderItem> items = orderDao.getOrderItems(order.getId());

        req.setAttribute("order", order);
        req.setAttribute("items", items);
        req.getRequestDispatcher("/order_detail.jsp").forward(req, resp);
    }
}
