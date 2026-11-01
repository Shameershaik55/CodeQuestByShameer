package com.codequest.dao;

import com.codequest.config.DBConnection;
import com.codequest.models.LeaderboardEntry;
import com.codequest.models.Submission;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SubmissionDAO {

    /**
     * Records a submission in mission_submissions within an active transaction.
     */
    public boolean recordSubmission(Connection conn, Submission sub) throws SQLException {
        String sql = "INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sub.getUserId());
            ps.setInt(2, sub.getMissionId());
            ps.setString(3, sub.getAnswer());
            ps.setBoolean(4, sub.isCorrect());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Counts correctly completed missions for a user.
     */
    public int getCorrectCompletedCount(int userId) {
        String sql = "SELECT COUNT(*) FROM mission_submissions WHERE user_id = ? AND is_correct = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Retrieves global leaderboard rankings sorted descending by total_xp.
     */
    public List<LeaderboardEntry> getLeaderboard() {
        List<LeaderboardEntry> leaderboard = new ArrayList<>();
        String sql = 
            "SELECT u.username, u.player_level, u.total_xp, " +
            "COALESCE(sub.correct_count, 0) AS completed_missions " +
            "FROM users u " +
            "LEFT JOIN (" +
            "    SELECT user_id, COUNT(*) AS correct_count " +
            "    FROM mission_submissions " +
            "    WHERE is_correct = TRUE " +
            "    GROUP BY user_id" +
            ") sub ON u.id = sub.user_id " +
            "ORDER BY u.total_xp DESC, u.player_level DESC, completed_missions DESC, u.id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            int currentRank = 1;
            while (rs.next()) {
                LeaderboardEntry entry = new LeaderboardEntry(
                    currentRank++,
                    rs.getString("username"),
                    rs.getInt("player_level"),
                    rs.getInt("completed_missions"),
                    rs.getInt("total_xp")
                );
                leaderboard.add(entry);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return leaderboard;
    }
}

