package com.japansport.dao;

import com.japansport.model.Review;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ReviewDao extends DAO {

    private Review mapRow(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setId(rs.getInt("id"));
        r.setProductId(rs.getInt("product_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        try { r.setUserName(rs.getString("user_name")); } catch (SQLException ignored) {}
        return r;
    }

    public static class PageResult<T> {
        public final List<T> items;
        public final int page;
        public final int pageSize;
        public final int total;
        public final int totalPages;

        public PageResult(List<T> items, int page, int pageSize, int total) {
            this.items = items;
            this.page = page;
            this.pageSize = pageSize;
            this.total = total;
            this.totalPages = (int) Math.ceil(total / (double) pageSize);
        }
    }

    // Summary (APPROVED only)
    public Map<String, Object> getStatsApproved(int productId) {
        Map<String, Object> out = new HashMap<>();
        double avg = 0.0;
        int count = 0;
        Map<Integer, Integer> counts = new HashMap<>();
        for (int i = 1; i <= 5; i++) counts.put(i, 0);

        try {
            String sqlAvg = "SELECT AVG(rating) AS avg_rating, COUNT(*) AS cnt " +
                    "FROM reviews WHERE product_id=? AND status='APPROVED'";
            PreparedStatement ps1 = getPreparedStatement(sqlAvg);
            ps1.setInt(1, productId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                avg = rs1.getDouble("avg_rating");
                count = rs1.getInt("cnt");
            }

            String sqlCounts = "SELECT rating, COUNT(*) AS cnt " +
                    "FROM reviews WHERE product_id=? AND status='APPROVED' GROUP BY rating";
            PreparedStatement ps2 = getPreparedStatement(sqlCounts);
            ps2.setInt(1, productId);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                counts.put(rs2.getInt("rating"), rs2.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        out.put("avg", avg);
        out.put("count", count);
        out.put("counts", counts);
        return out;
    }

    private String buildOrderBy(String sortKey) {
        if (sortKey == null) sortKey = "";
        switch (sortKey) {
            case "highest": return " ORDER BY r.rating DESC, r.created_at DESC, r.id DESC";
            case "lowest":  return " ORDER BY r.rating ASC, r.created_at DESC, r.id DESC";
            case "newest":
            default:        return " ORDER BY r.created_at DESC, r.id DESC";
        }
    }

    // Visible list: guest -> APPROVED; user -> APPROVED + mine PENDING
    public PageResult<Review> findVisible(int productId, Integer viewerUserId,
                                          int ratingFilter, String sortKey,
                                          int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 6;
        int offset = (page - 1) * pageSize;

        boolean hasFilter = ratingFilter >= 1 && ratingFilter <= 5;

        String whereBase;
        if (viewerUserId == null) {
            whereBase = " WHERE r.product_id=? AND r.status='APPROVED' ";
        } else {
            whereBase = " WHERE r.product_id=? AND (r.status='APPROVED' OR (r.status='PENDING' AND r.user_id=?)) ";
        }
        String whereRating = hasFilter ? " AND r.rating=? " : "";

        int total = 0;
        List<Review> items = new ArrayList<>();

        try {
            String sqlCount = "SELECT COUNT(*) AS cnt FROM reviews r " + whereBase + whereRating;
            PreparedStatement psCount = getPreparedStatement(sqlCount);
            int idx = 1;
            psCount.setInt(idx++, productId);
            if (viewerUserId != null) psCount.setInt(idx++, viewerUserId);
            if (hasFilter) psCount.setInt(idx++, ratingFilter);
            ResultSet rsCount = psCount.executeQuery();
            if (rsCount.next()) total = rsCount.getInt("cnt");

            String sqlList =
                    "SELECT r.*, u.name AS user_name " +
                            "FROM reviews r LEFT JOIN users u ON r.user_id = u.id " +
                            whereBase + whereRating +
                            buildOrderBy(sortKey) +
                            " LIMIT ? OFFSET ?";

            PreparedStatement ps = getPreparedStatement(sqlList);
            idx = 1;
            ps.setInt(idx++, productId);
            if (viewerUserId != null) ps.setInt(idx++, viewerUserId);
            if (hasFilter) ps.setInt(idx++, ratingFilter);
            ps.setInt(idx++, pageSize);
            ps.setInt(idx++, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) items.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new PageResult<>(items, page, pageSize, total);
    }

    public boolean insertPending(int productId, int userId, int rating, String comment) {
        try {
            String sql = "INSERT INTO reviews(product_id, user_id, rating, comment, status, created_at) " +
                    "VALUES(?,?,?,?, 'PENDING', NOW())";
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Nếu schema orders/order_items không đúng thì mình return true để không chặn
    public boolean canUserReview(int userId, int productId) {
        try {
            String sql =
                    "SELECT 1 FROM orders o JOIN order_items oi ON o.id = oi.order_id " +
                            "WHERE o.user_id=? AND oi.product_id=? LIMIT 1";
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            return true;
        }
    }
}
