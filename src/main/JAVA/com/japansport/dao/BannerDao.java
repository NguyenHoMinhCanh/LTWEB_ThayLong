package com.japansport.dao;

import com.japansport.model.Banner;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Banner DAO.
 *
 * Bảng: banners(id, image_url, link, title, position, active, created_at)
 *
 * Lưu ý:
 * - Các method "public" ở dưới được dùng cho cả Shop (chỉ lấy active=1)
 *   và Admin (lấy cả active=0) tùy theo method.
 */
public class BannerDao extends DAO {

    // Map 1 dòng ResultSet -> Banner
    private Banner mapRowToBanner(ResultSet rs) throws SQLException {
        Banner b = new Banner();
        b.setId(rs.getInt("id"));
        b.setImage_url(rs.getString("image_url"));
        b.setLink(rs.getString("link"));
        b.setTitle(rs.getString("title"));
        b.setPosition(rs.getString("position"));
        b.setActive(rs.getInt("active"));
        return b;
    }

    // ===================== SHOP =====================

    /**
     * Lấy danh sách banner theo position (chỉ active=1), order theo id DESC.
     */
    public List<Banner> getBannersByPosition(String position) {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT id, image_url, link, title, position, active " +
                "FROM banners WHERE position = ? AND active = 1 ORDER BY id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, position);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBanner(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Lấy 1 banner theo position (chỉ active=1) -> banner mới nhất.
     */
    public Banner getOneBannerByPosition(String position) {
        String sql = "SELECT id, image_url, link, title, position, active " +
                "FROM banners WHERE position = ? AND active = 1 ORDER BY id DESC LIMIT 1";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, position);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowToBanner(rs);
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Lấy banner cho Home theo các position theo thứ tự ưu tiên (để code JSP/Home dễ dùng).
     * Đây là method cũ đang được HomeController dùng.
     */
    public List<Banner> getHomeBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT id, image_url, link, title, position, active " +
                "FROM banners WHERE active=1 " +
                "ORDER BY CASE " +
                "           WHEN position = 'HOME_MAIN' THEN 1 " +
                "           WHEN position LIKE 'HOME_SUB%' THEN 2 " +
                "           WHEN position = 'HOME_SMALL' THEN 3 " +
                "           ELSE 4 " +
                "         END, id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBanner(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ===================== ADMIN =====================

    /**
     * Admin: lấy tất cả banner (bao gồm active=0), order theo created_at DESC, id DESC.
     */
    public List<Banner> getAllAdmin() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT id, image_url, link, title, position, active " +
                "FROM banners ORDER BY created_at DESC, id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowToBanner(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Admin: filter theo position (bao gồm active=0).
     */
    public List<Banner> getByPositionAdmin(String position) {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT id, image_url, link, title, position, active " +
                "FROM banners WHERE position = ? ORDER BY created_at DESC, id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, position);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowToBanner(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public Banner getById(int id) {
        String sql = "SELECT id, image_url, link, title, position, active " +
                "FROM banners WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowToBanner(rs);
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public int create(Banner b) {
        String sql = "INSERT INTO banners(image_url, link, title, position, active) VALUES(?,?,?,?,?)";
        try {
            PreparedStatement ps = getPreparedStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, b.getImage_url());
            ps.setString(2, b.getLink());
            ps.setString(3, b.getTitle());
            ps.setString(4, b.getPosition());
            ps.setInt(5, b.getActive());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean update(Banner b) {
        String sql = "UPDATE banners SET image_url=?, link=?, title=?, position=?, active=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, b.getImage_url());
            ps.setString(2, b.getLink());
            ps.setString(3, b.getTitle());
            ps.setString(4, b.getPosition());
            ps.setInt(5, b.getActive());
            ps.setInt(6, b.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean setActive(int id, int active) {
        String sql = "UPDATE banners SET active=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, active);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM banners WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
