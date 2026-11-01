package com.codequest.servlets;

import com.codequest.dao.UserDAO;
import com.codequest.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Read "remember me" cookie if available
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("codequest_saved_user".equals(c.getName())) {
                    request.setAttribute("savedUsername", c.getValue());
                    break;
                }
            }
        }

        // Pass any redirect registration message from session to request
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("regSuccessMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("regSuccessMessage"));
            session.removeAttribute("regSuccessMessage");
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        if (identifier == null || identifier.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Both username/email and password are required!");
            request.setAttribute("enteredIdentifier", identifier);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.validateLogin(identifier, password);

        if (user != null) {
            // Authentication successful -> Create new session
            HttpSession session = request.getSession(true);
            session.setAttribute("studentUser", user);
            session.setAttribute("studentUserId", user.getId());
            session.setAttribute("studentUsername", user.getUsername());

            // Handle Remember Me cookie (Module 12 requirement)
            if ("on".equalsIgnoreCase(rememberMe)) {
                Cookie cookie = new Cookie("codequest_saved_user", user.getUsername());
                cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                cookie.setPath(request.getContextPath() + "/");
                response.addCookie(cookie);
            } else {
                // Delete existing cookie
                Cookie cookie = new Cookie("codequest_saved_user", "");
                cookie.setMaxAge(0);
                cookie.setPath(request.getContextPath() + "/");
                response.addCookie(cookie);
            }

            // Redirect to Student Dashboard (Post-Redirect-Get pattern)
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid credentials! Check your username/email and password.");
            request.setAttribute("enteredIdentifier", identifier);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

