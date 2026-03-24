package com.japansport.controller;

import com.japansport.dao.ReviewDao;
import com.japansport.model.Review;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name="ReviewApiController", urlPatterns={"/api/reviews"})
public class ReviewApiController extends HttpServlet {

    private final ReviewDao reviewDao = new ReviewDao();
    private static final SimpleDateFormat DF = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    private static String jsonEscape(String s){
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "")
                .replace("\t", "\\t");
    }

    private static String maskName(String name){
        if (name == null) return "Khách";
        name = name.trim();
        if (name.isEmpty()) return "Khách";
        if (name.length() <= 2) return name.charAt(0) + "*";
        return name.substring(0, Math.min(4, name.length())) + "***";
    }

    private int parseInt(String s, int def){
        try { return Integer.parseInt(s); } catch (Exception e){ return def; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        int productId = parseInt(req.getParameter("productId"), 0);
        if (productId <= 0) {
            resp.getWriter().write("{\"ok\":false,\"message\":\"Missing productId\"}");
            return;
        }

        int rating = parseInt(req.getParameter("rating"), 0);     // 0 = all
        String sort = req.getParameter("sort");                    // newest/highest/lowest
        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = parseInt(req.getParameter("pageSize"), 6);

        User u = (User) req.getSession().getAttribute("currentUser");
        Integer viewerId = (u == null) ? null : u.getId();

        Map<String, Object> stats = reviewDao.getStatsApproved(productId);
        ReviewDao.PageResult<Review> pr = reviewDao.findVisible(productId, viewerId, rating, sort, page, pageSize);

        boolean loggedIn = viewerId != null;
        boolean canReview = loggedIn && reviewDao.canUserReview(viewerId, productId);

        double avg = (double) stats.getOrDefault("avg", 0.0);
        int cnt = (int) stats.getOrDefault("count", 0);
        @SuppressWarnings("unchecked")
        Map<Integer,Integer> counts = (Map<Integer,Integer>) stats.getOrDefault("counts", new HashMap<Integer,Integer>());

        StringBuilder sb = new StringBuilder();
        sb.append("{\"ok\":true");
        sb.append(",\"productId\":").append(productId);

        sb.append(",\"stats\":{");
        sb.append("\"avg\":").append(String.format(Locale.US, "%.2f", avg)).append(",");
        sb.append("\"count\":").append(cnt).append(",");
        sb.append("\"counts\":{");
        for(int i=1;i<=5;i++){
            if(i>1) sb.append(",");
            sb.append("\"").append(i).append("\":").append(counts.getOrDefault(i,0));
        }
        sb.append("}}");

        sb.append(",\"page\":{");
        sb.append("\"page\":").append(pr.page).append(",");
        sb.append("\"pageSize\":").append(pr.pageSize).append(",");
        sb.append("\"total\":").append(pr.total).append(",");
        sb.append("\"totalPages\":").append(pr.totalPages);
        sb.append("}");

        sb.append(",\"viewer\":{");
        sb.append("\"loggedIn\":").append(loggedIn).append(",");
        sb.append("\"canReview\":").append(canReview);
        sb.append("}");

        sb.append(",\"reviews\":[");
        for(int i=0;i<pr.items.size();i++){
            Review r = pr.items.get(i);
            if(i>0) sb.append(",");
            String name = maskName(r.getUserName());
            String date = (r.getCreatedAt()==null) ? "" : DF.format(r.getCreatedAt());
            sb.append("{");
            sb.append("\"id\":").append(r.getId()).append(",");
            sb.append("\"userName\":\"").append(jsonEscape(name)).append("\",");
            sb.append("\"rating\":").append(r.getRating()).append(",");
            sb.append("\"comment\":\"").append(jsonEscape(r.getComment())).append("\",");
            sb.append("\"status\":\"").append(jsonEscape(r.getStatus())).append("\",");
            sb.append("\"createdAt\":\"").append(jsonEscape(date)).append("\"");
            sb.append("}");
        }
        sb.append("]}");

        resp.getWriter().write(sb.toString());
    }
}
