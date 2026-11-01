package com.codequest.servlets;

import com.codequest.config.DBConnection;
import com.codequest.dao.MissionDAO;
import com.codequest.dao.SubmissionDAO;
import com.codequest.dao.UserDAO;
import com.codequest.models.Mission;
import com.codequest.models.Submission;
import com.codequest.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

    private MissionDAO missionDAO;
    private UserDAO userDAO;
    private SubmissionDAO submissionDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
        userDAO = new UserDAO();
        submissionDAO = new SubmissionDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        User student = (User) session.getAttribute("studentUser");

        String missionIdParam = request.getParameter("missionId");
        String selectedAnswer = request.getParameter("selectedAnswer");

        if (missionIdParam == null || missionIdParam.trim().isEmpty() ||
            selectedAnswer == null || selectedAnswer.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/missions?error=missing_choice");
            return;
        }

        int missionId;
        try {
            missionId = Integer.parseInt(missionIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/missions");
            return;
        }

        // 1. Enforce One-Attempt-Per-Mission Rule
        if (missionDAO.hasStudentAttempted(student.getId(), missionId)) {
            request.setAttribute("alreadyAttempted", true);
            request.setAttribute("missionTitle", "Mission Already Completed");
            request.setAttribute("resultMessage", "You have already completed this mission. In CodeQuest, each mission can only be attempted once!");
            request.getRequestDispatcher("mission-result.jsp").forward(request, response);
            return;
        }

        // 2. Retrieve the question to verify the correct answer
        Mission mission = missionDAO.getMissionById(missionId);
        if (mission == null) {
            response.sendRedirect(request.getContextPath() + "/missions");
            return;
        }

        // Compare student's selected answer with correct answer
        boolean isCorrect = mission.getCorrectAnswer().equalsIgnoreCase(selectedAnswer.trim());
        int xpEarned = isCorrect ? mission.getXpReward() : 0;

        // Fetch student's latest stats from DB before transaction
        User currentUser = userDAO.getUserById(student.getId());
        int previousLevel = currentUser.getPlayerLevel();
        int newTotalXp = currentUser.getTotalXp() + xpEarned;
        // Level calculation: 1 + (newTotalXp / 100)
        int newLevel = 1 + (newTotalXp / 100);
        boolean didLevelUp = (newLevel > previousLevel);

        // 3. Database Transaction: Insert submission & update user stats atomically
        Connection conn = null;
        boolean transactionSuccess = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin Transaction

            Submission sub = new Submission(currentUser.getId(), missionId, selectedAnswer.trim(), isCorrect);
            submissionDAO.recordSubmission(conn, sub);

            if (isCorrect) {
                userDAO.updateXpAndLevel(conn, currentUser.getId(), xpEarned, newLevel);
            }

            conn.commit(); // Commit Transaction
            transactionSuccess = true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        if (!transactionSuccess) {
            response.sendRedirect(request.getContextPath() + "/missions?error=transaction_failed");
            return;
        }

        // Update session user with new stats
        currentUser.setTotalXp(newTotalXp);
        currentUser.setPlayerLevel(newLevel);
        session.setAttribute("studentUser", currentUser);

        // Forward to mission-result.jsp with detailed evaluation feedback
        request.setAttribute("mission", mission);
        request.setAttribute("selectedAnswer", selectedAnswer);
        request.setAttribute("isCorrect", isCorrect);
        request.setAttribute("xpEarned", xpEarned);
        request.setAttribute("newTotalXp", newTotalXp);
        request.setAttribute("newLevel", newLevel);
        request.setAttribute("didLevelUp", didLevelUp);

        request.getRequestDispatcher("mission-result.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/missions");
    }
}

