package com.japansport.dao;

import com.japansport.model.ProductVariant;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ProductVariantDAO extends DAO {

    public ProductVariantDAO() {
        super();
    }

    private ProductVariant mapRow(ResultSet rs) throws SQLException {
        ProductVariant v = new ProductVariant();
        v.setId(rs.getInt("id"));
        v.setProductId(rs.getInt("product_id"));
        v.setColor(rs.getString("color"));
        v.setSize(rs.getString("size"));
        v.setStockQty(rs.getInt("stock_qty"));
        v.setSku(rs.getString("sku"));

        // price có thể null
        double p = rs.getDouble("price");
        if (rs.wasNull()) v.setPrice(null);
        else v.setPrice(p);

        // created_at / updated_at (có thể có hoặc không tùy schema)
        try {
            Timestamp c = rs.getTimestamp("created_at");
            v.setCreatedAt(c);
        } catch (SQLException ignored) {}

        try {
            Timestamp u = rs.getTimestamp("updated_at");
            v.setUpdatedAt(u);
        } catch (SQLException ignored) {}

        return v;
    }

    /** Lấy tất cả biến thể theo productId (size, color, stock...) */
    public List<ProductVariant> findByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql =
                "SELECT id, product_id, color, size, stock_qty, sku, price, created_at, updated_at " +
                        "FROM product_variants " +
                        "WHERE product_id = ? " +
                        "ORDER BY color ASC, CAST(size AS UNSIGNED) ASC\n";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /** Lấy 1 biến thể theo id (dùng khi add-to-cart / checkout) */
    public ProductVariant findById(int id) {
        String sql =
                "SELECT id, product_id, color, size, stock_qty, sku, price, created_at, updated_at " +
                        "FROM product_variants " +
                        "WHERE id = ?";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Trừ kho an toàn: chỉ trừ nếu còn đủ hàng (tránh âm kho).
     * Trả về true nếu trừ thành công.
     */
    public boolean decreaseStock(int variantId, int qty) {
        String sql =
                "UPDATE product_variants " +
                        "SET stock_qty = stock_qty - ? " +
                        "WHERE id = ? AND stock_qty >= ?";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, qty);
            ps.setInt(2, variantId);
            ps.setInt(3, qty);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ================== CRUD cho Admin ==================

    /**
     * Thêm biến thể mới.
     * @return id mới (nếu lấy được), -1 nếu thất bại.
     */
    public int insert(ProductVariant v) {
        String sql = "INSERT INTO product_variants(product_id, color, size, stock_qty, sku, price) VALUES (?,?,?,?,?,?)";
        try {
            PreparedStatement ps = getPreparedStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, v.getProductId());
            ps.setString(2, v.getColor());
            ps.setString(3, v.getSize());
            ps.setInt(4, v.getStockQty());
            if (v.getSku() == null || v.getSku().trim().isEmpty()) ps.setNull(5, java.sql.Types.VARCHAR);
            else ps.setString(5, v.getSku().trim());
            if (v.getPrice() == null) ps.setNull(6, java.sql.Types.DOUBLE);
            else ps.setDouble(6, v.getPrice());

            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /** Update biến thể theo id. */
    public boolean update(ProductVariant v) {
        String sql = "UPDATE product_variants SET color=?, size=?, stock_qty=?, sku=?, price=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, v.getColor());
            ps.setString(2, v.getSize());
            ps.setInt(3, v.getStockQty());
            if (v.getSku() == null || v.getSku().trim().isEmpty()) ps.setNull(4, java.sql.Types.VARCHAR);
            else ps.setString(4, v.getSku().trim());
            if (v.getPrice() == null) ps.setNull(5, java.sql.Types.DOUBLE);
            else ps.setDouble(5, v.getPrice());
            ps.setInt(6, v.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Xóa biến thể theo id. */
    public boolean delete(int id) {
        String sql = "DELETE FROM product_variants WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Set stock trực tiếp (dùng khi chỉnh kho trong Admin). */
    public boolean setStockQty(int id, int stockQty) {
        String sql = "UPDATE product_variants SET stock_qty=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, stockQty);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
