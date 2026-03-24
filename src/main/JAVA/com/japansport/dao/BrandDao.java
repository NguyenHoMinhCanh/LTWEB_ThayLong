package com.japansport.dao;

import com.japansport.model.Brand;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BrandDao extends DAO {

    public BrandDao() {
        super();
    }

    private Brand mapRowToBrand(ResultSet rs) throws SQLException {
        Brand b = new Brand();
        b.setId(rs.getInt("id"));
        b.setName(rs.getString("name"));
        b.setSlug(rs.getString("slug"));
        b.setLogoUrl(rs.getString("logo_url"));
        b.setActive(rs.getBoolean("active"));
        return b;
    }

    // ========== 1) Danh sách brand active (dùng cho shop/menu/filter) ==========

    public List<Brand> getAllActive() {
        List<Brand> list = new ArrayList<>();
        String sql =
                "SELECT b.id, b.name, b.slug, b.logo_url, b.active " +
                        "FROM brands b " +
                        "WHERE b.active = 1 " +
                        "ORDER BY b.name ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBrand(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ========== 2) Brand theo id ==========

    public Brand getById(int id) {
        String sql =
                "SELECT b.id, b.name, b.slug, b.logo_url, b.active " +
                        "FROM brands b " +
                        "WHERE b.id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToBrand(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ========== ADMIN CRUD ==========

    /** Lấy tất cả brand (cả active/inactive) cho admin */
    public List<Brand> getAll() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT b.id, b.name, b.slug, b.logo_url, b.active " +
                "FROM brands b ORDER BY b.id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBrand(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /** Tìm brand theo keyword (name/slug). Nếu keyword null/blank thì trả về getAll(). */
    public List<Brand> searchAll(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAll();
        }

        List<Brand> list = new ArrayList<>();
        String sql = "SELECT b.id, b.name, b.slug, b.logo_url, b.active " +
                "FROM brands b " +
                "WHERE (LOWER(b.name) LIKE ? OR LOWER(b.slug) LIKE ?) " +
                "ORDER BY b.id DESC";
        String like = "%" + keyword.trim().toLowerCase() + "%";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, like);
            ps.setString(2, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBrand(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /** Thêm brand. Trả về id vừa tạo (0 nếu thất bại). */
    public int insert(Brand brand) {
        String sql = "INSERT INTO brands(name, slug, logo_url, active) VALUES(?,?,?,?)";
        try {
            PreparedStatement ps = getPreparedStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, brand.getName());
            ps.setString(2, brand.getSlug());
            ps.setString(3, brand.getLogoUrl());
            ps.setBoolean(4, brand.isActive());
            int affected = ps.executeUpdate();
            if (affected == 0) return 0;

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /** Cập nhật brand. */
    public boolean update(Brand brand) {
        String sql = "UPDATE brands SET name = ?, slug = ?, logo_url = ?, active = ? WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, brand.getName());
            ps.setString(2, brand.getSlug());
            ps.setString(3, brand.getLogoUrl());
            ps.setBoolean(4, brand.isActive());
            ps.setInt(5, brand.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /** Bật/tắt hiển thị brand (active) để shop tự thay đổi theo. */
    public boolean updateActive(int id, boolean active) {
        String sql = "UPDATE brands SET active = ? WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /** Xoá brand theo id (hard delete). */
    public boolean delete(int id) {
        String sql = "DELETE FROM brands WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<Brand> getActiveBrandsWithProductCount() {
        List<Brand> list = new ArrayList<>();
        String sql =
                "SELECT b.id, b.name, b.slug, b.logo_url, b.active, " +
                        "       COUNT(p.id) AS product_count " +
                        "FROM brands b " +
                        "LEFT JOIN products p ON p.brand_id = b.id AND p.active = 1 " +
                        "WHERE b.active = 1 " +
                        "GROUP BY b.id, b.name, b.slug, b.logo_url, b.active " +
                        "ORDER BY product_count DESC, b.name ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBrand(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
