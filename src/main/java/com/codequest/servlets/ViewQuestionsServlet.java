package com.codequest.servlets;

import com.codequest.dao.MissionDAO;
import com.codequest.models.Mission;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/view-questions")
public class ViewQuestionsServlet extends HttpServlet {

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

        // Retrieve all question records from MySQL through JDBC
        List<Mission> questionsList = missionDAO.getAllMissions();

        // Forward to the JSP page using RequestDispatcher (Module 7 requirement)
        request.setAttribute("questionsList", questionsList);
        request.getRequestDispatcher("/view-questions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

