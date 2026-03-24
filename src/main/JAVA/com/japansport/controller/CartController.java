package com.japansport.controller;

import com.japansport.dao.CartDao;
import com.japansport.model.Cart;
import com.japansport.model.CartItem;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("currentUser");

        // badge count: /cart?mode=count
        if ("count".equalsIgnoreCase(req.getParameter("mode"))) {
            resp.setContentType("application/json;charset=UTF-8");
            try {
                int count = (u == null) ? 0 : cartDao.getCartCount(u.getId());
                resp.getWriter().write("{\"count\":" + count + "}");
            } catch (Exception e) {
                resp.getWriter().write("{\"count\":0}");
            }
            return;
        }

        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + req.getContextPath() + "/cart");
            return;
        }

        try {
            Cart cart = cartDao.getActiveCart(u.getId());
            req.setAttribute("cart", cart);
            req.setAttribute("cartItems", cart.getItems());
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        User u = (User) req.getSession().getAttribute("currentUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + req.getHeader("Referer"));
            return;
        }

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null || action.isBlank()) action = "add";

        try {
            switch (action) {
                case "add": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    String vidStr = req.getParameter("variantId");
                    Integer variantId = (vidStr == null || vidStr.isBlank()) ? null : Integer.parseInt(vidStr);
                    int qty = Integer.parseInt(req.getParameter("qty"));
                    cartDao.addToCart(u.getId(), productId, variantId, qty);

                    // mua ngay -> đi checkout
                    if ("1".equals(req.getParameter("buyNow"))) {
                        resp.sendRedirect(req.getContextPath() + "/checkout");
                        return;
                    }
                    break;
                }
                case "update": {
                    int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));
                    int qty = Integer.parseInt(req.getParameter("qty"));
                    cartDao.updateQuantity(u.getId(), cartItemId, qty);
                    break;
                }
                case "remove": {
                    int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));
                    cartDao.removeItem(u.getId(), cartItemId);
                    break;
                }
                case "clear": {
                    cartDao.clearCart(u.getId());
                    break;
                }
            }
            resp.sendRedirect(req.getContextPath() + "/cart");
        } catch (Exception e) {
            req.getSession().setAttribute("cartError", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
