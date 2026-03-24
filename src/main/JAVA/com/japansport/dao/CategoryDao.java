package com.japansport.dao;

import com.japansport.model.Category;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao extends DAO {

    // map cho phần bán hàng (cũ)
    private Category mapRowToCategory(ResultSet rs) throws SQLException {
        return new Category(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("image_url"),
                rs.getString("link"),
                rs.getInt("is_featured"),
                rs.getInt("active")
        );
    }

    // map cho admin (đủ field mới)
    private Category mapRowToCategoryAdmin(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setImage_url(rs.getString("image_url"));
        c.setLink(rs.getString("link"));
        c.setIs_featured(rs.getInt("is_featured"));
        c.setActive(rs.getInt("active"));

        c.setSlug(rs.getString("slug"));
        c.setParent_id((Integer) rs.getObject("parent_id"));
        c.setDisplay_order(rs.getInt("display_order"));

        // nếu query có join parent_name
        try {
            c.setParentName(rs.getString("parent_name"));
        } catch (SQLException ignored) {}

        return c;
    }

    // ========== 1) TRANG CHỦ: category nổi bật ==========
    public List<Category> getFeaturedCategories(int limit) {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT c.id, c.name, c.image_url, c.link, c.is_featured, c.active " +
                        "FROM categories c " +
                        "WHERE c.active = 1 AND c.is_featured = 1 " +
                        "ORDER BY c.display_order ASC, c.id ASC\n " +
                        "LIMIT ?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRowToCategory(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ========== 2) FILTER TRANG LIST-PRODUCT: category active ==========
    public List<Category> getAllActive() {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT c.id, c.name, c.image_url, c.link, c.is_featured, c.active " +
                        "FROM categories c " +
                        "WHERE c.active = 1 " +
                        "ORDER BY c.name ASC";
        try (PreparedStatement ps = getPreparedStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowToCategory(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ========== 3) Query nâng cấp (giữ lại để báo cáo) ==========
    public List<Category> getAllActiveWithProductCount() {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT c.id, c.name, c.image_url, c.link, c.is_featured, c.active, " +
                        "       COUNT(p.id) AS product_count " +
                        "FROM categories c " +
                        "LEFT JOIN products p ON p.category_id = c.id AND p.active = 1 " +
                        "WHERE c.active = 1 " +
                        "GROUP BY c.id, c.name, c.image_url, c.link, c.is_featured, c.active " +
                        "ORDER BY product_count DESC, c.name ASC";
        try (PreparedStatement ps = getPreparedStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowToCategory(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ============================================================
    // ======================= ADMIN METHODS ======================
    // ============================================================

    // Admin: list all
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT c.*, p.name AS parent_name " +
                        "FROM categories c " +
                        "LEFT JOIN categories p ON c.parent_id = p.id " +
                        "ORDER BY c.display_order, c.name";
        try (PreparedStatement ps = getPreparedStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowToCategoryAdmin(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        }
    }

    // Admin: get by id (⚠️ servlet admin gọi method này)
    public Category getById(int id) {
        String sql =
                "SELECT c.*, p.name AS parent_name " +
                        "FROM categories c " +
                        "LEFT JOIN categories p ON c.parent_id = p.id " +
                        "WHERE c.id = ?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToCategoryAdmin(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Admin: insert
    public int insert(Category category) {
        String sql =
                "INSERT INTO categories (name, image_url, link, is_featured, active, slug, parent_id, display_order) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = getPreparedStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getImage_url());
            ps.setString(3, category.getLink());
            ps.setInt(4, category.getIs_featured());
            ps.setInt(5, category.getActive());

            String slug = category.getSlug();
            if (slug == null || slug.trim().isEmpty()) slug = Category.generateSlug(category.getName());
            ps.setString(6, slug);

            if (category.getParent_id() != null) ps.setInt(7, category.getParent_id());
            else ps.setNull(7, Types.INTEGER);

            ps.setInt(8, category.getDisplay_order());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
            return 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Admin: update
    public boolean update(Category category) {
        String sql =
                "UPDATE categories SET name=?, image_url=?, link=?, " +
                        "is_featured=?, active=?, slug=?, parent_id=?, display_order=? " +
                        "WHERE id=?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getImage_url());
            ps.setString(3, category.getLink());
            ps.setInt(4, category.getIs_featured());
            ps.setInt(5, category.getActive());

            String slug = category.getSlug();
            if (slug == null || slug.trim().isEmpty()) slug = Category.generateSlug(category.getName());
            ps.setString(6, slug);

            if (category.getParent_id() != null) ps.setInt(7, category.getParent_id());
            else ps.setNull(7, Types.INTEGER);

            ps.setInt(8, category.getDisplay_order());
            ps.setInt(9, category.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Admin: delete
    public boolean delete(int id) {
        String sql = "DELETE FROM categories WHERE id=?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Admin: lấy danh mục cha (dropdown)
    public List<Category> getParentCategories() {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT id, name " +
                        "FROM categories " +
                        "WHERE parent_id IS NULL AND active = 1 " +
                        "ORDER BY display_order, name";
        try (PreparedStatement ps = getPreparedStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        }
    }
}
