package com.japansport.dao;

import com.japansport.model.NewsCategory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NewsCategoryDao extends DAO {

    public List<NewsCategory> getAll() {
        List<NewsCategory> list = new ArrayList<>();
        String sql = "SELECT id, name, slug, description, active FROM news_categories ORDER BY id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                NewsCategory c = new NewsCategory();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                c.setDescription(rs.getString("description"));
                c.setActive(rs.getBoolean("active"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public NewsCategory getById(int id) {
        String sql = "SELECT id, name, slug, description, active FROM news_categories WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                NewsCategory c = new NewsCategory();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                c.setDescription(rs.getString("description"));
                c.setActive(rs.getBoolean("active"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insert(NewsCategory c) {
        String sql = "INSERT INTO news_categories(name, slug, description, active) VALUES(?,?,?,?)";
        try {
            PreparedStatement ps = getPreparedStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, c.getName());
            ps.setString(2, c.getSlug());
            ps.setString(3, c.getDescription());
            ps.setBoolean(4, c.isActive());
            int affected = ps.executeUpdate();
            if (affected == 0) return 0;
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean update(NewsCategory c) {
        String sql = "UPDATE news_categories SET name=?, slug=?, description=?, active=? WHERE id=?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, c.getName());
            ps.setString(2, c.getSlug());
            ps.setString(3, c.getDescription());
            ps.setBoolean(4, c.isActive());
            ps.setInt(5, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM news_categories WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<NewsCategory> getAllActive() {
        List<NewsCategory> list = new ArrayList<>();
        String sql = "SELECT id, name, slug, description, active FROM news_categories WHERE active = 1 ORDER BY id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                NewsCategory c = new NewsCategory();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                c.setDescription(rs.getString("description"));
                c.setActive(rs.getBoolean("active"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
