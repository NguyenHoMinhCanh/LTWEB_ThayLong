package com.japansport.controller;

import com.japansport.dao.CartDao;
import com.japansport.dao.OrderDao;
import com.japansport.dao.UserAddressDao;
import com.japansport.model.Cart;
import com.japansport.model.User;
import com.japansport.model.UserAddress;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private final CartDao cartDao = new CartDao();
    private final OrderDao orderDao = new OrderDao();
    private final UserAddressDao addressDao = new UserAddressDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("currentUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + req.getContextPath() + "/checkout");
            return;
        }

        try {
            Cart cart = cartDao.getActiveCart(u.getId());
            if (cart.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            // Prefill địa chỉ mặc định để payment.jsp tự điền nhanh
            UserAddress addr = null;
            try {
                addr = addressDao.getDefaultByUserId(u.getId());
            } catch (Exception ignored) {}
            req.setAttribute("defaultAddress", addr);

            req.setAttribute("cart", cart);
            req.setAttribute("cartItems", cart.getItems());
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("currentUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + req.getContextPath() + "/checkout");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String addressLine = req.getParameter("addressLine");
        String city = req.getParameter("city");
        String district = req.getParameter("district");
        String ward = req.getParameter("ward");
        String payMethod = req.getParameter("payMethod");
        String note = req.getParameter("note");

        try {
            int orderId = orderDao.placeOrderFromCart(
                    u.getId(), fullName, phone, addressLine, city, district, ward, payMethod, note
            );
            HttpSession session = req.getSession();
            session.setAttribute("FLASH_MSG", "Đặt hàng thành công. Mã đơn #" + orderId);
            session.setAttribute("FLASH_TYPE", "success");
            resp.sendRedirect(req.getContextPath() + "/order-detail?id=" + orderId);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Đặt hàng thất bại: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
