package com.japansport.dao;

import com.japansport.model.News;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsDao extends DAO {

    private News map(ResultSet rs) throws SQLException {
        News n = new News();
        n.setId(rs.getInt("id"));
        n.setTitle(rs.getString("title"));
        n.setSlug(rs.getString("slug"));
        n.setSummary(rs.getString("summary"));
        n.setContent(rs.getString("content"));
        n.setThumbnailUrl(rs.getString("thumbnail_url"));
        n.setAuthor(rs.getString("author"));
        n.setViewCount(rs.getInt("view_count"));
        n.setStatus(rs.getString("status"));
        n.setFeatured(rs.getInt("featured"));
        n.setCreatedAt(rs.getTimestamp("created_at"));
        n.setUpdatedAt(rs.getTimestamp("updated_at"));
        return n;
    }

    public List<News> getAll() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY created_at DESC, id DESC";
        try (PreparedStatement ps = getPreparedStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        }
    }

    public News getById(int id) {
        String sql = "SELECT * FROM news WHERE id = ?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                News n = map(rs);
                n.setCategoryIds(getCategoryIds(id));
                return n;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public int insert(News n) {
        String sql = "INSERT INTO news(title, slug, summary, content, thumbnail_url, author, status, featured) " +
                "VALUES(?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = getPreparedStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, n.getTitle());
            ps.setString(2, n.getSlug());
            ps.setString(3, n.getSummary());
            ps.setString(4, n.getContent());
            ps.setString(5, n.getThumbnailUrl());
            ps.setString(6, n.getAuthor());
            ps.setString(7, n.getStatus());
            ps.setInt(8, n.getFeatured());

            int affected = ps.executeUpdate();
            if (affected == 0) return 0;

            try (ResultSet rs = ps.getGeneratedKeys()) {
                int newsId = rs.next() ? rs.getInt(1) : 0;
                if (newsId > 0) {
                    updateCategoryMap(newsId, n.getCategoryIds());
                }
                return newsId;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean update(News n) {
        String sql = "UPDATE news SET title=?, slug=?, summary=?, content=?, thumbnail_url=?, author=?, status=?, featured=? WHERE id=?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setString(1, n.getTitle());
            ps.setString(2, n.getSlug());
            ps.setString(3, n.getSummary());
            ps.setString(4, n.getContent());
            ps.setString(5, n.getThumbnailUrl());
            ps.setString(6, n.getAuthor());
            ps.setString(7, n.getStatus());
            ps.setInt(8, n.getFeatured());
            ps.setInt(9, n.getId());

            boolean ok = ps.executeUpdate() > 0;
            if (ok) updateCategoryMap(n.getId(), n.getCategoryIds());
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        // map table sẽ cascade delete theo FK fk_ncm_news
        String sql = "DELETE FROM news WHERE id = ?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ===== category mapping =====

    public List<Integer> getCategoryIds(int newsId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT category_id FROM news_category_map WHERE news_id = ?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, newsId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    public void updateCategoryMap(int newsId, List<Integer> categoryIds) throws SQLException {
        // xoá cũ
        try (PreparedStatement del = getPreparedStatement("DELETE FROM news_category_map WHERE news_id = ?")) {
            del.setInt(1, newsId);
            del.executeUpdate();
        }

        if (categoryIds == null || categoryIds.isEmpty()) return;

        // insert mới
        try (PreparedStatement ins = getPreparedStatement(
                "INSERT INTO news_category_map(news_id, category_id) VALUES(?,?)")) {
            for (Integer cid : categoryIds) {
                if (cid == null) continue;
                ins.setInt(1, newsId);
                ins.setInt(2, cid);
                ins.addBatch();
            }
            ins.executeBatch();
        }
    }
    // ===== SHOP QUERIES =====

    public List<News> shopGetPublished(Integer categoryId, String keyword, int limit, int offset) {
        List<News> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT n.* ")
                .append("FROM news n ");

        if (categoryId != null) {
            sql.append("JOIN news_category_map m ON m.news_id = n.id ");
        }

        sql.append("WHERE n.status = 'PUBLISHED' ");

        if (categoryId != null) {
            sql.append("AND m.category_id = ? ");
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (n.title LIKE ? OR n.summary LIKE ?) ");
        }

        sql.append("ORDER BY n.created_at DESC, n.id DESC ")
                .append("LIMIT ? OFFSET ?");

        try (PreparedStatement ps = getPreparedStatement(sql.toString())) {
            int_toggleParams(ps, categoryId, keyword, limit, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // helper để set params gọn
    private void int_toggleParams(PreparedStatement ps, Integer categoryId, String keyword, int limit, int offset) throws SQLException {
        int idx = 1;

        if (categoryId != null) {
            ps.setInt(idx++, categoryId);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            String k = "%" + keyword.trim() + "%";
            ps.setString(idx++, k);
            ps.setString(idx++, k);
        }

        ps.setInt(idx++, limit);
        ps.setInt(idx, offset);
    }

    public News shopGetPublishedBySlug(String slug) {
        String sql = "SELECT * FROM news WHERE slug = ? AND status = 'PUBLISHED'";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }



    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE news SET status = ? WHERE id = ?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean slugExists(String slug, Integer excludeId) {
        String sql = "SELECT 1 FROM news WHERE slug = ? " + (excludeId != null ? "AND id <> ?" : "") + " LIMIT 1";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setString(1, slug);
            if (excludeId != null) ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void increaseViewCount(int newsId) {
        String sql = "UPDATE news SET view_count = view_count + 1 WHERE id = ?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, newsId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
