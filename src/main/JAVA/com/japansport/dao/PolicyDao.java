package com.japansport.dao;

import com.japansport.model.Policy;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PolicyDao extends DAO {

    private Policy map(ResultSet rs) throws SQLException {
        Policy p = new Policy();
        p.setId(rs.getInt("id"));
        p.setTitle(rs.getString("title"));
        p.setSlug(rs.getString("slug"));
        p.setContent(rs.getString("content"));
        p.setPolicyType(rs.getString("policy_type"));
        p.setDisplayOrder(rs.getInt("display_order"));
        p.setActive(rs.getBoolean("active"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }

    public List<Policy> getAll() {
        List<Policy> list = new ArrayList<>();
        String sql = "SELECT * FROM policies ORDER BY display_order ASC, id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Policy getById(int id) {
        String sql = "SELECT * FROM policies WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Policy getBySlug(String slug) {
        String sql = "SELECT * FROM policies WHERE slug = ? AND active = 1";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insert(Policy p) {
        String sql = "INSERT INTO policies(title, slug, content, policy_type, display_order, active) VALUES(?,?,?,?,?,?)";
        try {
            PreparedStatement ps = getPreparedStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getSlug());
            ps.setString(3, p.getContent());
            ps.setString(4, p.getPolicyType());
            ps.setInt(5, p.getDisplayOrder());
            ps.setBoolean(6, p.isActive());
            int affected = ps.executeUpdate();
            if (affected == 0) return 0;
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean update(Policy p) {
        String sql = "UPDATE policies SET title=?, slug=?, content=?, policy_type=?, display_order=?, active=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getSlug());
            ps.setString(3, p.getContent());
            ps.setString(4, p.getPolicyType());
            ps.setInt(5, p.getDisplayOrder());
            ps.setBoolean(6, p.isActive());
            ps.setInt(7, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM policies WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Policy> getAllActiveForMenu() {
        List<Policy> list = new ArrayList<>();
        String sql = "SELECT * FROM policies WHERE active = 1 ORDER BY display_order ASC, id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
