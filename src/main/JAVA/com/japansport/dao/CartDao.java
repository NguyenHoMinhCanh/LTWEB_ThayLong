package com.japansport.dao;

import com.japansport.model.Cart;
import com.japansport.model.CartItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Hướng B: Một user có thể có nhiều carts trong lịch sử,
 * nhưng tại 1 thời điểm chỉ có 1 cart ACTIVE (is_active=1).
 * <p>
 * DB enforce bằng UNIQUE(active_key):
 * - active_key = user_id khi is_active=1
 * - active_key = NULL khi is_active=0
 */
public class CartDao extends DAO {

    private void touchCart(int cartId) {
        String sql = "UPDATE carts SET updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (Exception ignored) {
        }
    }

    /**
     * Lấy cart ACTIVE của user; nếu chưa có thì tạo mới.
     * Đảm bảo không tạo 2 ACTIVE cart cho cùng user nhờ UNIQUE(active_key).
     */
    public int getOrCreateActiveCartId(int userId) throws SQLException {
        String find = "SELECT id FROM carts WHERE user_id=? AND is_active=1 ORDER BY updated_at DESC, id DESC LIMIT 1";
        try (PreparedStatement ps = getPreparedStatement(find)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }

        // chưa có -> tạo mới ACTIVE
        String ins = "INSERT INTO carts(user_id, status, is_active, active_key) VALUES(?, 'ACTIVE', 1, ?)";
        try (PreparedStatement ps = getPreparedStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException ex) {
            // nếu bị trùng unique(active_key) => đã có cart ACTIVE do race-condition
            try (PreparedStatement ps = getPreparedStatement(find)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt("id");
                }
            }
            throw ex;
        }

        throw new SQLException("Cannot create cart");
    }

    public Cart getActiveCart(int userId) throws SQLException {
        int cartId = getOrCreateActiveCartId(userId);
        List<CartItem> items = getCartItemsByCartId(cartId);
        return new Cart(cartId, userId, "ACTIVE", true, items);
    }

    public boolean productHasVariants(int productId) throws SQLException {
        String sql = "SELECT COUNT(*) c FROM product_variants WHERE product_id=?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt("c") > 0;
            }
        }
    }

    private Integer getVariantStock(Integer variantId) throws SQLException {
        if (variantId == null) return null;
        String sql = "SELECT stock_qty FROM product_variants WHERE id=?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("stock_qty");
            }
        }
        return 0;
    }

    public void addToCart(int userId, int productId, Integer variantId, int addQty) throws SQLException {
        if (addQty <= 0) addQty = 1;

        // Nếu sản phẩm có variants mà variantId null => bắt chọn
        if (productHasVariants(productId) && variantId == null) {
            throw new SQLException("Vui lòng chọn biến thể (màu/size) trước khi thêm vào giỏ.");
        }

        int cartId = getOrCreateActiveCartId(userId);

        String find = "SELECT id, quantity FROM cart_items " +
                "WHERE cart_id=? AND product_id=? AND (variant_id <=> ?)";
        Integer existingId = null;
        int existingQty = 0;

        try (PreparedStatement ps = getPreparedStatement(find)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            if (variantId == null) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, variantId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    existingId = rs.getInt("id");
                    existingQty = rs.getInt("quantity");
                }
            }
        }

        Integer stock = getVariantStock(variantId);
        int newQty = existingQty + addQty;

        if (stock != null) {
            if (stock <= 0) throw new SQLException("Biến thể đã hết hàng.");
            newQty = Math.min(newQty, stock);
        }

        if (existingId != null) {
            String upd = "UPDATE cart_items SET quantity=? WHERE id=? AND cart_id=?";
            try (PreparedStatement ps = getPreparedStatement(upd)) {
                ps.setInt(1, newQty);
                ps.setInt(2, existingId);
                ps.setInt(3, cartId);
                ps.executeUpdate();
            }
        } else {
            String ins = "INSERT INTO cart_items(cart_id, product_id, variant_id, quantity) VALUES(?,?,?,?)";
            try (PreparedStatement ps = getPreparedStatement(ins)) {
                ps.setInt(1, cartId);
                ps.setInt(2, productId);
                if (variantId == null) ps.setNull(3, Types.INTEGER);
                else ps.setInt(3, variantId);
                ps.setInt(4, newQty);
                ps.executeUpdate();
            }
        }

        touchCart(cartId);
    }

    /**
     * Danh sách item của cart ACTIVE (để render cart.jsp/payment.jsp).
     */
    public List<CartItem> getCartItems(int userId) throws SQLException {
        int cartId = getOrCreateActiveCartId(userId);
        return getCartItemsByCartId(cartId);
    }

    private List<CartItem> getCartItemsByCartId(int cartId) throws SQLException {
        String sql =
                "SELECT ci.id AS cart_item_id, ci.product_id, ci.variant_id, ci.quantity, " +
                        "p.name, p.image_url, " +
                        "v.color, v.size, COALESCE(v.price, p.price) AS unit_price, v.stock_qty " +
                        "FROM cart_items ci " +
                        "JOIN products p ON p.id = ci.product_id " +
                        "LEFT JOIN product_variants v ON v.id = ci.variant_id " +
                        "WHERE ci.cart_id=? " +
                        "ORDER BY ci.created_at DESC, ci.id DESC";

        List<CartItem> list = new ArrayList<>();
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem it = new CartItem();
                    it.setCartItemId(rs.getInt("cart_item_id"));
                    it.setProductId(rs.getInt("product_id"));

                    int vid = rs.getInt("variant_id");
                    it.setVariantId(rs.wasNull() ? null : vid);

                    it.setQuantity(rs.getInt("quantity"));
                    it.setProductName(rs.getString("name"));
                    it.setImageUrl(rs.getString("image_url"));
                    it.setColor(rs.getString("color"));
                    it.setSize(rs.getString("size"));
                    it.setUnitPrice(rs.getDouble("unit_price"));

                    int stock = rs.getInt("stock_qty");
                    it.setStockQty(rs.wasNull() ? -1 : stock);

                    list.add(it);
                }
            }
        }
        return list;
    }

    public int getCartCount(int userId) throws SQLException {
        int cartId = getOrCreateActiveCartId(userId);
        String sql = "SELECT COALESCE(SUM(quantity),0) AS cnt FROM cart_items WHERE cart_id=?";
        try (PreparedStatement ps = getPreparedStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        }
        return 0;
    }

    public void updateQuantity(int userId, int cartItemId, int qty) throws SQLException {
        if (qty < 1) qty = 1;

        int cartId = getOrCreateActiveCartId(userId);

        // lấy variant để clamp theo stock (nếu có)
        Integer variantId = null;
        String getVar = "SELECT variant_id FROM cart_items WHERE id=? AND cart_id=?";
        try (PreparedStatement ps = getPreparedStatement(getVar)) {
            ps.setInt(1, cartItemId);
            ps.setInt(2, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return;
                int vid = rs.getInt("variant_id");
                variantId = rs.wasNull() ? null : vid;
            }
        }

        Integer stock = getVariantStock(variantId);
        if (stock != null) qty = Math.min(qty, Math.max(stock, 1));

        String upd = "UPDATE cart_items SET quantity=? WHERE id=? AND cart_id=?";
        try (PreparedStatement ps = getPreparedStatement(upd)) {
            ps.setInt(1, qty);
            ps.setInt(2, cartItemId);
            ps.setInt(3, cartId);
            ps.executeUpdate();
        }

        touchCart(cartId);
    }

    public void removeItem(int userId, int cartItemId) throws SQLException {
        int cartId = getOrCreateActiveCartId(userId);
        String del = "DELETE FROM cart_items WHERE id=? AND cart_id=?";
        try (PreparedStatement ps = getPreparedStatement(del)) {
            ps.setInt(1, cartItemId);
            ps.setInt(2, cartId);
            ps.executeUpdate();
        }
        touchCart(cartId);
    }

    public void clearCart(int userId) throws SQLException {
        int cartId = getOrCreateActiveCartId(userId);
        String del = "DELETE FROM cart_items WHERE cart_id=?";
        try (PreparedStatement ps = getPreparedStatement(del)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        }
        touchCart(cartId);
    }
}
