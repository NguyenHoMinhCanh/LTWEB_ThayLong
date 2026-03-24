package com.japansport.dao;

import com.japansport.model.ProductSpec;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * DAO cho bảng product_specs (key-value specs).
 */
public class ProductSpecDao extends DAO {

    public ProductSpecDao() {
        super();
    }

    private ProductSpec mapRow(ResultSet rs) throws SQLException {
        ProductSpec s = new ProductSpec();
        s.setId(rs.getInt("id"));
        s.setProductId(rs.getInt("product_id"));
        s.setSpecKey(rs.getString("spec_key"));
        s.setSpecValue(rs.getString("spec_value"));
        try {
            s.setSortOrder(rs.getInt("sort_order"));
        } catch (SQLException ignored) {}
        try {
            Timestamp c = rs.getTimestamp("created_at");
            s.setCreatedAt(c);
        } catch (SQLException ignored) {}
        try {
            Timestamp u = rs.getTimestamp("updated_at");
            s.setUpdatedAt(u);
        } catch (SQLException ignored) {}
        return s;
    }

    /** Lấy danh sách specs theo product_id, sắp theo sort_order rồi id. */
    public List<ProductSpec> findByProductId(int productId) {
        String sql = "SELECT id, product_id, spec_key, spec_value, sort_order, created_at, updated_at " +
                "FROM product_specs " +
                "WHERE product_id = ? " +
                "ORDER BY sort_order ASC, id ASC";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            List<ProductSpec> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            // Nếu bảng chưa tạo hoặc lỗi SQL, đừng làm sập trang detail
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // ====== CRUD cơ bản cho trang Admin (để bạn dùng sau này) ======

    /** Thêm spec mới. Trả về id mới (nếu DB support generated keys), -1 nếu thất bại. */
    public int insert(ProductSpec spec) {
        String sql = "INSERT INTO product_specs(product_id, spec_key, spec_value, sort_order) VALUES (?,?,?,?)";
        try {
            PreparedStatement ps = getPreparedStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, spec.getProductId());
            ps.setString(2, spec.getSpecKey());
            ps.setString(3, spec.getSpecValue());
            ps.setInt(4, spec.getSortOrder());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /** Update spec theo id. */
    public boolean update(ProductSpec spec) {
        String sql = "UPDATE product_specs SET spec_key=?, spec_value=?, sort_order=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, spec.getSpecKey());
            ps.setString(2, spec.getSpecValue());
            ps.setInt(3, spec.getSortOrder());
            ps.setInt(4, spec.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Xóa spec theo id. */
    public boolean delete(int id) {
        String sql = "DELETE FROM product_specs WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
