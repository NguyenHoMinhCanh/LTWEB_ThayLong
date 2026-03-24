package com.japansport.controller;

import com.japansport.dao.ReviewDao;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name="ReviewAddApiController", urlPatterns={"/api/reviews/add"})
public class ReviewAddApiController extends HttpServlet {

    private final ReviewDao reviewDao = new ReviewDao();

    private int parseInt(String s, int def){
        try { return Integer.parseInt(s); } catch (Exception e){ return def; }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        User u = (User) req.getSession().getAttribute("currentUser");
        if (u == null) {
            resp.setStatus(401);
            resp.getWriter().write("{\"ok\":false,\"message\":\"Bạn cần đăng nhập để đánh giá.\"}");
            return;
        }

        int productId = parseInt(req.getParameter("productId"), 0);
        int rating = parseInt(req.getParameter("rating"), 0);
        String comment = req.getParameter("comment");
        if (comment == null) comment = "";
        comment = comment.trim();

        if (productId <= 0 || rating < 1 || rating > 5 || comment.length() < 5) {
            resp.setStatus(400);
            resp.getWriter().write("{\"ok\":false,\"message\":\"Dữ liệu không hợp lệ (rating 1-5, comment >= 5 ký tự).\"}");
            return;
        }

        if (!reviewDao.canUserReview(u.getId(), productId)) {
            resp.setStatus(403);
            resp.getWriter().write("{\"ok\":false,\"message\":\"Bạn cần mua sản phẩm để đánh giá.\"}");
            return;
        }

        boolean ok = reviewDao.insertPending(productId, u.getId(), rating, comment);
        if (ok) {
            resp.getWriter().write("{\"ok\":true,\"message\":\"Đã gửi đánh giá! Hệ thống sẽ duyệt trước khi hiển thị.\"}");
        } else {
            resp.setStatus(500);
            resp.getWriter().write("{\"ok\":false,\"message\":\"Không gửi được đánh giá. Vui lòng thử lại.\"}");
        }
    }
}
