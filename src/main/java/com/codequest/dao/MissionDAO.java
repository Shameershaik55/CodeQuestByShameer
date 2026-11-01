package com.codequest.dao;

import com.codequest.config.DBConnection;
import com.codequest.models.Mission;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MissionDAO {

    /**
     * Inserts a new programming mission created by the Admin.
     */
    public boolean addMission(Mission m) {
        String sql = "INSERT INTO missions (title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getTitle().trim());
            ps.setString(2, m.getDescription().trim());
            ps.setString(3, m.getCategory().trim());
            ps.setString(4, m.getDifficulty().trim());
            ps.setString(5, m.getOptionA().trim());
            ps.setString(6, m.getOptionB().trim());
            ps.setString(7, m.getOptionC().trim());
            ps.setString(8, m.getOptionD().trim());
            ps.setString(9, m.getCorrectAnswer().trim());
            ps.setInt(10, m.getXpReward());
            if (m.getCreatedBy() > 0) {
                ps.setInt(11, m.getCreatedBy());
            } else {
                ps.setNull(11, java.sql.Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all missions stored in the database (for Admin management).
     */
    public List<Mission> getAllMissions() {
        List<Mission> list = new ArrayList<>();
        String sql = "SELECT id, title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by FROM missions ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToMission(rs, true));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single mission by ID (includes correct answer for evaluation).
     */
    public Mission getMissionById(int id) {
        String sql = "SELECT id, title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by FROM missions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMission(rs, true);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves missions for student view with attempt status.
     * Note: Does NOT populate correct_answer to satisfy requirement:
     * "The correct answer must not be included in the data displayed to students."
     */
    public List<Mission> getMissionsForStudent(int studentId, String categoryFilter) {
        List<Mission> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.id, m.title, m.description, m.category, m.difficulty, " +
            "m.option_a, m.option_b, m.option_c, m.option_d, m.xp_reward, m.created_by, " +
            "s.id AS submission_id, s.is_correct " +
            "FROM missions m " +
            "LEFT JOIN mission_submissions s ON m.id = s.mission_id AND s.user_id = ? "
        );

        boolean hasFilter = (categoryFilter != null && !categoryFilter.trim().isEmpty() && !categoryFilter.equalsIgnoreCase("ALL"));
        if (hasFilter) {
            sql.append("WHERE m.category = ? ");
        }
        sql.append("ORDER BY m.id ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, studentId);
            if (hasFilter) {
                ps.setString(2, categoryFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Mission m = new Mission();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setDescription(rs.getString("description"));
                    m.setCategory(rs.getString("category"));
                    m.setDifficulty(rs.getString("difficulty"));
                    m.setOptionA(rs.getString("option_a"));
                    m.setOptionB(rs.getString("option_b"));
                    m.setOptionC(rs.getString("option_c"));
                    m.setOptionD(rs.getString("option_d"));
                    m.setXpReward(rs.getInt("xp_reward"));
                    m.setCreatedBy(rs.getInt("created_by"));
                    // Mask correct answer: left null
                    m.setCorrectAnswer(null);

                    int subId = rs.getInt("submission_id");
                    if (subId > 0) {
                        m.setAlreadyAttempted(true);
                        m.setPreviousAttemptCorrect(rs.getBoolean("is_correct"));
                    } else {
                        m.setAlreadyAttempted(false);
                    }
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Checks if a student has already attempted a specific mission.
     */
    public boolean hasStudentAttempted(int studentId, int missionId) {
        String sql = "SELECT id FROM mission_submissions WHERE user_id = ? AND mission_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, missionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Mission mapResultSetToMission(ResultSet rs, boolean includeAnswer) throws SQLException {
        Mission m = new Mission();
        m.setId(rs.getInt("id"));
        m.setTitle(rs.getString("title"));
        m.setDescription(rs.getString("description"));
        m.setCategory(rs.getString("category"));
        m.setDifficulty(rs.getString("difficulty"));
        m.setOptionA(rs.getString("option_a"));
        m.setOptionB(rs.getString("option_b"));
        m.setOptionC(rs.getString("option_c"));
        m.setOptionD(rs.getString("option_d"));
        if (includeAnswer) {
            m.setCorrectAnswer(rs.getString("correct_answer"));
        }
        m.setXpReward(rs.getInt("xp_reward"));
        m.setCreatedBy(rs.getInt("created_by"));
        return m;
    }
}

