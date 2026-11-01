package com.codequest.servlets;

import com.codequest.dao.SubmissionDAO;
import com.codequest.models.LeaderboardEntry;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {

    private SubmissionDAO submissionDAO;

    @Override
    public void init() throws ServletException {
        submissionDAO = new SubmissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Fetch real-time rankings from database ordered descending by total XP
        List<LeaderboardEntry> leaderboard = submissionDAO.getLeaderboard();
        request.setAttribute("leaderboard", leaderboard);

        request.getRequestDispatcher("leaderboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

