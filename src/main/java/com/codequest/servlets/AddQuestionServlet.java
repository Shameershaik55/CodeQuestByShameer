package com.codequest.servlets;

import com.codequest.dao.MissionDAO;
import com.codequest.models.Admin;
import com.codequest.models.Mission;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/add-question")
public class AddQuestionServlet extends HttpServlet {

    private MissionDAO missionDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
            return;
        }
        request.getRequestDispatcher("/add-question.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
            return;
        }

        Admin admin = (Admin) session.getAttribute("adminUser");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");
        String xpRewardParam = request.getParameter("xpReward");

        // Validate required fields
        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            difficulty == null || difficulty.trim().isEmpty() ||
            optionA == null || optionA.trim().isEmpty() ||
            optionB == null || optionB.trim().isEmpty() ||
            optionC == null || optionC.trim().isEmpty() ||
            optionD == null || optionD.trim().isEmpty() ||
            correctAnswer == null || correctAnswer.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All mission fields and 4 answer choices are required!");
            request.getRequestDispatcher("/add-question.jsp").forward(request, response);
            return;
        }

        int xpReward = 50;
        try {
            if (xpRewardParam != null && !xpRewardParam.trim().isEmpty()) {
                xpReward = Integer.parseInt(xpRewardParam.trim());
            }
        } catch (NumberFormatException e) {
            xpReward = 50;
        }

        Mission m = new Mission();
        m.setTitle(title.trim());
        m.setDescription(description.trim());
        m.setCategory(category.trim());
        m.setDifficulty(difficulty.trim());
        m.setOptionA(optionA.trim());
        m.setOptionB(optionB.trim());
        m.setOptionC(optionC.trim());
        m.setOptionD(optionD.trim());
        m.setCorrectAnswer(correctAnswer.trim());
        m.setXpReward(xpReward);
        m.setCreatedBy(admin.getId());

        boolean success = missionDAO.addMission(m);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/view-questions?msg=added_successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to save the question to the database.");
            request.getRequestDispatcher("/add-question.jsp").forward(request, response);
        }
    }
}

