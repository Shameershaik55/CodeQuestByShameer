package com.codequest.dao;

import com.codequest.config.DBConnection;
import com.codequest.models.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    /**
     * Checks if a username or email is already registered.
     */
    public boolean isUsernameOrEmailTaken(String username, String email) {
        String sql = "SELECT id FROM users WHERE username = ? OR email = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    /**
     * Inserts a new student into the users table with 0 XP and Level 1.
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, email, password, total_xp, player_level) VALUES (?, ?, ?, 0, 1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername().trim());
            ps.setString(2, user.getEmail().trim());
            ps.setString(3, user.getPassword());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Validates student credentials using username or email.
     */
    public User validateLogin(String identifier, String password) {
        String sql = "SELECT id, username, email, password, total_xp, player_level, created_at FROM users WHERE (username = ? OR email = ?) AND password = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier.trim());
            ps.setString(2, identifier.trim());
            ps.setString(3, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setTotalXp(rs.getInt("total_xp"));
                    u.setPlayerLevel(rs.getInt("player_level"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves student profile and up-to-date stats by user id.
     */
    public User getUserById(int userId) {
        String sql = "SELECT id, username, email, password, total_xp, player_level, created_at FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setTotalXp(rs.getInt("total_xp"));
                    u.setPlayerLevel(rs.getInt("player_level"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Updates XP and level as part of an active transaction.
     */
    public boolean updateXpAndLevel(Connection conn, int userId, int additionalXp, int newLevel) throws SQLException {
        String sql = "UPDATE users SET total_xp = total_xp + ?, player_level = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, additionalXp);
            ps.setInt(2, newLevel);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        }
    }
}

