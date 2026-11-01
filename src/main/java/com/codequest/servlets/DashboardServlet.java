package com.codequest.servlets;

import com.codequest.dao.SubmissionDAO;
import com.codequest.dao.UserDAO;
import com.codequest.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private UserDAO userDAO;
    private SubmissionDAO submissionDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        submissionDAO = new SubmissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }

        User sessionUser = (User) session.getAttribute("studentUser");

        // Fetch fresh up-to-date data directly from database using session user ID
        User currentUser = userDAO.getUserById(sessionUser.getId());
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=user_not_found");
            return;
        }

        // Refresh session object
        session.setAttribute("studentUser", currentUser);

        // Fetch count of correctly completed missions
        int completedMissionsCount = submissionDAO.getCorrectCompletedCount(currentUser.getId());

        // Calculate progress toward the next level (100 XP per level)
        int xpThreshold = 100;
        int currentLevelFloorXp = (currentUser.getPlayerLevel() - 1) * xpThreshold;
        int xpInCurrentLevel = currentUser.getTotalXp() - currentLevelFloorXp;
        if (xpInCurrentLevel < 0) xpInCurrentLevel = 0;
        int progressPercent = Math.min(100, (xpInCurrentLevel * 100) / xpThreshold);
        int xpNeeded = Math.max(0, (currentUser.getPlayerLevel() * xpThreshold) - currentUser.getTotalXp());

        request.setAttribute("user", currentUser);
        request.setAttribute("completedCount", completedMissionsCount);
        request.setAttribute("progressPercent", progressPercent);
        request.setAttribute("xpNeeded", xpNeeded);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

