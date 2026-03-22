package vn.edu.hcmuaf.web.controller;

import com.japansport.dao.OrderDao;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet(name = "OrderCancelController", urlPatterns = {"/order-cancel"})
public class OrderCancelController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static String ensureCsrf(HttpSession session) {
        Object cur = session.getAttribute("CSRF_TOKEN");
        if (cur != null) return String.valueOf(cur);

        byte[] buf = new byte[32];
        new SecureRandom().nextBytes(buf);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
        session.setAttribute("CSRF_TOKEN", token);
        return token;
    }

    // Nếu hệ thống đã dùng CSRF thì check, còn nếu chưa có token thì cho qua
    private static boolean validCsrfIfPresent(HttpServletRequest req) {
        HttpSession session = req.getSession();
        Object cur = session.getAttribute("CSRF_TOKEN");
        if (cur == null) return true;
        String expected = String.valueOf(cur);
        String got = req.getParameter("csrf");
        return got != null && got.equals(expected);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        ensureCsrf(session);

        User u = (User) session.getAttribute("currentUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + req.getContextPath() + "/orders");
            return;
        }

        String redirect = req.getParameter("redirect");
        if (redirect == null || redirect.isBlank() || !redirect.startsWith("/")) {
            redirect = "/orders";
        }

        if (!validCsrfIfPresent(req)) {
            session.setAttribute("FLASH_MSG", "CSRF token không hợp lệ. Vui lòng tải lại trang và thử lại.");
            session.setAttribute("FLASH_TYPE", "danger");
            resp.sendRedirect(req.getContextPath() + redirect);
            return;
        }

        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) {
            session.setAttribute("FLASH_MSG", "Mã đơn hàng không hợp lệ.");
            session.setAttribute("FLASH_TYPE", "danger");
            resp.sendRedirect(req.getContextPath() + redirect);
            return;
        }

        int r = orderDao.cancelOrderForUser(id, u.getId());
        if (r == 1) {
            session.setAttribute("FLASH_MSG", "Đã hủy đơn hàng #" + id + " thành công.");
            session.setAttribute("FLASH_TYPE", "success");
        } else if (r == -1) {
            session.setAttribute("FLASH_MSG", "Đơn hàng #" + id + " không thể hủy (đã được xử lý hoặc đang giao).");
            session.setAttribute("FLASH_TYPE", "danger");
        } else {
            session.setAttribute("FLASH_MSG", "Không tìm thấy đơn hàng hoặc bạn không có quyền hủy đơn này.");
            session.setAttribute("FLASH_TYPE", "danger");
        }

        resp.sendRedirect(req.getContextPath() + redirect);
    }
}
