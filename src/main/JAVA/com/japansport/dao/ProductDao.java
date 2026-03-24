package com.japansport.dao;

import com.japansport.model.Product;
import com.japansport.model.Brand;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class ProductDao extends DAO {

    public ProductDao() {
        super();
    }

    private Product mapRowToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();

        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));

        try {
            String description = rs.getString("description");
            if (description != null) {
                p.setDescription(description);
            }
        } catch (SQLException ignored) {}

        p.setPrice(rs.getDouble("price"));

        try {
            double oldPrice = rs.getDouble("old_price");
            if (!rs.wasNull()) {
                p.setOld_price(oldPrice);
            }
        } catch (SQLException ignored) {}

        p.setImage_url(rs.getString("image_url"));

        try {
            String gender = rs.getString("gender");
            if (gender != null) {
                p.setGender(gender);
            }
        } catch (SQLException ignored) {}

        try {
            int categoryId = rs.getInt("category_id");
            if (!rs.wasNull()) {
                p.setCategoryId(categoryId);
            }
        } catch (SQLException ignored) {}

        try {
            int brandId = rs.getInt("brand_id");
            if (!rs.wasNull()) {
                p.setBrandId(brandId);
            }
        } catch (SQLException ignored) {}

        try {
            p.setActive(rs.getInt("active") == 1);
        } catch (SQLException ignored) {}

        return p;
    }

    /**
     * Map ResultSet có JOIN với bảng brand/category (nếu cần chi tiết).
     */
    private Product mapRowToProductWithDetails(ResultSet rs) throws SQLException {
        Product p = mapRowToProduct(rs);

        try {
            String brandName = rs.getString("brand_name");
            if (brandName != null) {
                Brand brand = new Brand();
                brand.setId(rs.getInt("brand_id"));
                brand.setName(brandName);
                try {
                    brand.setLogoUrl(rs.getString("brand_logo"));
                } catch (SQLException ignored) {}
                p.setBrand(brand);
            }
        } catch (SQLException ignored) {}

        try {
            p.setActive(rs.getInt("active") == 1);
        } catch (SQLException ignored) {}

        return p;
    }

    /** Map giới tính từ UI -> giá trị trong DB */
    private String mapGenderCode(String genderCode) {
        if (genderCode == null) return null;
        genderCode = genderCode.trim().toLowerCase();
        switch (genderCode) {
            case "m":
            case "male":
            case "men":
                return "men";
            case "f":
            case "female":
            case "women":
                return "women";
            case "unisex":
                return "unisex";
            default:
                return genderCode;
        }
    }

    /** ORDER BY cho các hàm sort bên list-product */
    private String buildOrderBy(String sortKey) {
        if (sortKey == null || sortKey.isEmpty()) {
            return " ORDER BY updated_at DESC, id DESC";
        }
        switch (sortKey) {
            case "price_asc":
                return " ORDER BY price ASC, id DESC";
            case "price_desc":
                return " ORDER BY price DESC, id DESC";
            case "newest":
                return " ORDER BY updated_at DESC, id DESC";
            case "oldest":
                return " ORDER BY created_at ASC, id ASC";
            default:
                return " ORDER BY updated_at DESC, id DESC";
        }
    }

    // ================== SELECT CHO TRANG CHỦ ==================

    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT id, name, description, price, old_price, image_url, " +
                    "gender, category_id, brand_id, active, created_at, updated_at " +
                    "FROM products " +
                    "WHERE active = 1 " +
                    "ORDER BY updated_at DESC, id DESC";

            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }


    // =======================
    // ADMIN: lấy cả active=0
    // =======================
    public List<Product> getAllAdmin() {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT id, name, description, price, old_price, image_url, " +
                    "gender, category_id, brand_id, active, created_at, updated_at " +
                    "FROM products " +
                    "ORDER BY updated_at DESC, id DESC";

            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public Product getByIdAdmin(int id) {
        try {
            String sql = "SELECT p.id, p.name, p.description, p.price, p.old_price, " +
                    "p.image_url, p.gender, p.category_id, p.brand_id, p.active, " +
                    "p.created_at, p.updated_at, " +
                    "b.name AS brand_name, b.logo_url AS brand_logo " +
                    "FROM products p " +
                    "LEFT JOIN brands b ON p.brand_id = b.id " +
                    "WHERE p.id = ?";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToProductWithDetails(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean setActive(int id, boolean active) {
        try {
            String sql = "UPDATE products SET active = ? WHERE id = ?";
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, active ? 1 : 0);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public Product getById(int id) {
        try {
            String sql = "SELECT p.id, p.name, p.description, p.price, p.old_price, " +
                    "p.image_url, p.gender, p.category_id, p.brand_id, p.active, " +
                    "p.created_at, p.updated_at, " +
                    "b.name AS brand_name, b.logo_url AS brand_logo " +
                    "FROM products p " +
                    "LEFT JOIN brands b ON p.brand_id = b.id " +
                    "WHERE p.id = ? AND p.active = 1";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToProductWithDetails(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<Product> getByGender(String gender, int limit) {
        List<Product> list = new ArrayList<>();
        try {
            String dbGender = mapGenderCode(gender);

            String sql = "SELECT id, name, description, price, old_price, image_url, " +
                    "gender, category_id, brand_id, active, created_at, updated_at " +
                    "FROM products " +
                    "WHERE gender = ? AND active = 1 " +
                    "ORDER BY updated_at DESC, id DESC " +
                    "LIMIT ?";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, dbGender);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<Product> getLatest(int limit) {
        List<Product> list = new ArrayList<>();
        if (limit <= 0) limit = 8;
        try {
            String sql = "SELECT id, name, description, price, old_price, image_url, " +
                    "gender, category_id, brand_id, active, created_at, updated_at " +
                    "FROM products " +
                    "WHERE active = 1 " +
                    "ORDER BY created_at DESC, id DESC " +
                    "LIMIT ?";
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<Product> getBestSellers(int limit) {
        List<Product> list = new ArrayList<>();
        if (limit <= 0) limit = 8;
        try {
            String sql =
                    "SELECT p.id, p.name, p.description, p.price, p.old_price, p.image_url, " +
                            "p.gender, p.category_id, p.brand_id, p.active, p.created_at, p.updated_at, " +
                            "COALESCE(SUM(oi.quantity),0) AS sold_qty " +
                            "FROM products p " +
                            "LEFT JOIN order_items oi ON oi.product_id = p.id " +
                            "LEFT JOIN orders o ON o.id = oi.order_id " +
                            "WHERE p.active = 1 " +
                            "GROUP BY p.id, p.name, p.description, p.price, p.old_price, p.image_url, " +
                            "p.gender, p.category_id, p.brand_id, p.active, p.created_at, p.updated_at " +
                            "ORDER BY sold_qty DESC, p.updated_at DESC, p.id DESC " +
                            "LIMIT ?";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ================== SELECT CHO TRANG LIST-PRODUCT ==================

    public List<Product> getAllSorted(String sortKey) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT id, name, description, price, old_price, image_url, " +
                    "gender, category_id, brand_id, active, created_at, updated_at " +
                    "FROM products " +
                    "WHERE active = 1 " +
                    buildOrderBy(sortKey);

            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<Product> getByCategorySorted(int categoryId, String sortKey) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT id, name, description, price, old_price, image_url, " +
                    "gender, category_id, brand_id, active, created_at, updated_at " +
                    "FROM products " +
                    "WHERE active = 1 AND category_id = ? " +
                    buildOrderBy(sortKey);

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, categoryId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<Product> getByCategory(int categoryId) {
        return getByCategorySorted(categoryId, null);
    }

    public List<Product> searchByName(String keyword) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT id, name, description, price, old_price, image_url, " +
                    "gender, category_id, brand_id, active, created_at, updated_at " +
                    "FROM products " +
                    "WHERE active = 1 AND name LIKE ? " +
                    "ORDER BY updated_at DESC, id DESC";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // === THỐNG KÊ ===

    public int countAll() {
        try {
            String sql = "SELECT COUNT(*) AS total FROM products WHERE active = 1";
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public int countByCategory(int categoryId) {
        try {
            String sql = "SELECT COUNT(*) AS total FROM products " +
                    "WHERE active = 1 AND category_id = ?";
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public int countByBrand(int brandId) {
        try {
            String sql = "SELECT COUNT(*) AS total FROM products " +
                    "WHERE active = 1 AND brand_id = ?";
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, brandId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public double getAveragePrice() {
        try {
            String sql = "SELECT AVG(price) AS avg_price FROM products WHERE active = 1";
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avg_price");
            }
            return 0.0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public Map<String, Double> getPriceRange() {
        Map<String, Double> range = new HashMap<>();
        try {
            String sql = "SELECT MIN(price) AS min_price, MAX(price) AS max_price " +
                    "FROM products WHERE active = 1";
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                range.put("min", rs.getDouble("min_price"));
                range.put("max", rs.getDouble("max_price"));
            }
            return range;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // === CRUD ===

    public int insert(Product product) throws SQLException {
        String sql = "INSERT INTO products (name, description, price, old_price, image_url, " +
                "gender, category_id, brand_id, active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement ps = getPreparedStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, product.getName());
        ps.setString(2, product.getDescription());
        ps.setDouble(3, product.getPrice());
        if (product.getOld_price() > 0) {
            ps.setDouble(4, product.getOld_price());
        } else {
            ps.setNull(4, Types.DOUBLE);
        }
        ps.setString(5, product.getImage_url());
        ps.setString(6, product.getGender());

        if (product.getCategoryId() != null) {
            ps.setInt(7, product.getCategoryId());
        } else {
            ps.setNull(7, Types.INTEGER);
        }

        if (product.getBrandId() != null) {
            ps.setInt(8, product.getBrandId());
        } else {
            ps.setNull(8, Types.INTEGER);
        }

        ps.setInt(9, product.isActive() ? 1 : 0); // active

        int affected = ps.executeUpdate();

        if (affected > 0) {
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                product.setId(rs.getInt(1));
            }
        }

        return affected;
    }

    public int update(Product product) throws SQLException {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, old_price = ?, " +
                "image_url = ?, gender = ?, category_id = ?, brand_id = ?, active = ? " +
                "WHERE id = ?";

        PreparedStatement ps = getPreparedStatement(sql);
        ps.setString(1, product.getName());
        ps.setString(2, product.getDescription());
        ps.setDouble(3, product.getPrice());
        if (product.getOld_price() > 0) {
            ps.setDouble(4, product.getOld_price());
        } else {
            ps.setNull(4, Types.DOUBLE);
        }
        ps.setString(5, product.getImage_url());
        ps.setString(6, product.getGender());

        if (product.getCategoryId() != null) {
            ps.setInt(7, product.getCategoryId());
        } else {
            ps.setNull(7, Types.INTEGER);
        }

        if (product.getBrandId() != null) {
            ps.setInt(8, product.getBrandId());
        } else {
            ps.setNull(8, Types.INTEGER);
        }

        ps.setInt(9, product.isActive() ? 1 : 0); // active
        ps.setInt(10, product.getId());

        return ps.executeUpdate();
    }

    /**
     * Xoá sản phẩm theo id (dùng cho admin).
     * Trả về true nếu xoá thành công.
     */
    public boolean delete(int id) {
        try {
            return deleteById(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int deleteById(int id) throws SQLException {
        String sql = "DELETE FROM products WHERE id = ?";
        PreparedStatement ps = getPreparedStatement(sql);
        ps.setInt(1, id);
        return ps.executeUpdate();
    }


    /** Nếu product đã có id và tồn tại trong DB -> update, chưa có -> insert */
    public int save(Product product) throws SQLException {
        if (product.getId() > 0) {
            Product existing = getById(product.getId());
            if (existing != null) {
                return update(product);
            }
        }
        return insert(product);
    }

    @Deprecated
    public Product findNew(int id) {
        return getById(id);
    }

    @Deprecated
    public Product findHot(int id) {
        return getById(id);
    }

    @Deprecated
    public Product findBestSellers(int id) {
        return getById(id);
    }
}
