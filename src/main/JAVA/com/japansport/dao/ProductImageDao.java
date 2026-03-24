package com.japansport.dao;

import com.japansport.model.ProductImage;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductImageDao extends DAO {

    public ProductImageDao() {
        super();
    }

    private ProductImage map(ResultSet rs) throws SQLException {
        ProductImage img = new ProductImage();
        img.setId(rs.getInt("id"));
        img.setProductId(rs.getInt("product_id"));
        img.setImageUrl(rs.getString("image_url"));
        img.setAlt(rs.getString("alt"));
        img.setMainImage(rs.getInt("is_main") == 1);
        img.setSortOrder(rs.getInt("sort_order"));
        img.setActive(rs.getInt("active") == 1);
        img.setColor(rs.getString("color"));
        return img;
    }

    // Lấy toàn bộ ảnh của sản phẩm (để lọc theo màu ở JSP/JS)
    public List<ProductImage> getByProductId(int productId) {
        List<ProductImage> list = new ArrayList<>();
        String sql =
                "SELECT id, product_id, image_url, alt, is_main, sort_order, active, color " +
                        "FROM product_images " +
                        "WHERE product_id = ? AND active = 1 " +
                        "ORDER BY (color IS NULL) ASC, color ASC, is_main DESC, sort_order ASC, id ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // (Không bắt buộc) Nếu bạn muốn lọc ảnh theo màu ngay từ DB
    public List<ProductImage> getByProductIdAndColor(int productId, String color) {
        List<ProductImage> list = new ArrayList<>();
        String sql =
                "SELECT id, product_id, image_url, alt, is_main, sort_order, active, color " +
                        "FROM product_images " +
                        "WHERE product_id = ? AND active = 1 AND LOWER(TRIM(color)) = LOWER(TRIM(?)) " +
                        "ORDER BY is_main DESC, sort_order ASC, id ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ps.setString(2, color);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ================== Admin helpers ==================

    /**
     * Admin: lấy toàn bộ ảnh của sản phẩm (cả active=0) để quản trị.
     */
    public List<ProductImage> adminGetAllByProductId(int productId) {
        List<ProductImage> list = new ArrayList<>();
        String sql =
                "SELECT id, product_id, image_url, alt, is_main, sort_order, active, color " +
                        "FROM product_images " +
                        "WHERE product_id = ? " +
                        "ORDER BY (color IS NULL) ASC, color ASC, is_main DESC, sort_order ASC, id ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Thêm ảnh mới. Trả về id mới, -1 nếu fail.
     */
    public int insert(ProductImage img) {
        String sql = "INSERT INTO product_images(product_id, image_url, alt, is_main, sort_order, active, color) VALUES (?,?,?,?,?,?,?)";
        try {
            PreparedStatement ps = getPreparedStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, img.getProductId());
            ps.setString(2, img.getImageUrl());
            if (img.getAlt() == null || img.getAlt().trim().isEmpty()) ps.setNull(3, java.sql.Types.VARCHAR);
            else ps.setString(3, img.getAlt().trim());
            ps.setInt(4, img.isMainImage() ? 1 : 0);
            ps.setInt(5, img.getSortOrder());
            ps.setInt(6, img.isActive() ? 1 : 0);
            if (img.getColor() == null || img.getColor().trim().isEmpty()) ps.setNull(7, java.sql.Types.VARCHAR);
            else ps.setString(7, img.getColor().trim());

            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                int newId = keys.getInt(1);
                // nếu ảnh mới là main => đảm bảo main duy nhất theo (product + color)
                if (img.isMainImage()) {
                    setMain(newId, img.getProductId(), img.getColor());
                }
                return newId;
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Update thông tin ảnh (không xử lý main ở đây).
     */
    public boolean update(ProductImage img) {
        String sql = "UPDATE product_images SET image_url=?, alt=?, sort_order=?, active=?, color=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, img.getImageUrl());
            if (img.getAlt() == null || img.getAlt().trim().isEmpty()) ps.setNull(2, java.sql.Types.VARCHAR);
            else ps.setString(2, img.getAlt().trim());
            ps.setInt(3, img.getSortOrder());
            ps.setInt(4, img.isActive() ? 1 : 0);
            if (img.getColor() == null || img.getColor().trim().isEmpty()) ps.setNull(5, java.sql.Types.VARCHAR);
            else ps.setString(5, img.getColor().trim());
            ps.setInt(6, img.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa ảnh theo id.
     * Lưu ý: nếu muốn giữ lịch sử, bạn có thể đổi thành soft delete (active=0).
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM product_images WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Set ảnh main cho 1 nhóm (product + color). Nếu color null/blank => nhóm NULL.
     * - Clear main của các ảnh cùng nhóm
     * - Set main cho id.
     */
    public boolean setMain(int id, int productId, String color) {
        String clearSql =
                "UPDATE product_images SET is_main = 0 " +
                        "WHERE product_id = ? AND (" +
                        "   (color IS NULL AND ? IS NULL) " +
                        "   OR (color IS NOT NULL AND ? IS NOT NULL AND LOWER(TRIM(color)) = LOWER(TRIM(?)))" +
                        ")";
        String setSql = "UPDATE product_images SET is_main = 1 WHERE id = ?";

        // normalize color
        String c = (color == null || color.trim().isEmpty()) ? null : color.trim();

        try {
            PreparedStatement psClear = getPreparedStatement(clearSql);
            psClear.setInt(1, productId);
            psClear.setString(2, c);
            psClear.setString(3, c);
            psClear.setString(4, c);
            psClear.executeUpdate();

            PreparedStatement psSet = getPreparedStatement(setSql);
            psSet.setInt(1, id);
            return psSet.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
