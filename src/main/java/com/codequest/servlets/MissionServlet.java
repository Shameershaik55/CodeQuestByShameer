package com.codequest.servlets;

import com.codequest.dao.MissionDAO;
import com.codequest.models.Mission;
import com.codequest.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/missions")
public class MissionServlet extends HttpServlet {

    private MissionDAO missionDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int studentId = 0;
        if (session != null && session.getAttribute("studentUser") != null) {
            User student = (User) session.getAttribute("studentUser");
            studentId = student.getId();
        }

        String categoryFilter = request.getParameter("category");
        if (categoryFilter == null || categoryFilter.trim().isEmpty()) {
            categoryFilter = "ALL";
        }

        // Retrieve missions dynamically from MySQL with attempt status
        // Note: MissionDAO does NOT include correct_answer for students
        List<Mission> missions = missionDAO.getMissionsForStudent(studentId, categoryFilter);

        request.setAttribute("missions", missions);
        request.setAttribute("activeCategory", categoryFilter);

        request.getRequestDispatcher("missions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

