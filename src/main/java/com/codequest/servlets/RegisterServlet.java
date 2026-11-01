package com.codequest.servlets;

import com.codequest.dao.UserDAO;
import com.codequest.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All registration fields are required!");
            request.setAttribute("enteredUsername", username);
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.setAttribute("enteredUsername", username);
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 4) {
            request.setAttribute("errorMessage", "Password must be at least 4 characters long!");
            request.setAttribute("enteredUsername", username);
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check uniqueness of username and email
        if (userDAO.isUsernameOrEmailTaken(username, email)) {
            request.setAttribute("errorMessage", "Username or email is already registered. Choose another one.");
            request.setAttribute("enteredUsername", username);
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Create new user (XP starts at 0, Level at 1)
        User newUser = new User(username, email, password);
        boolean success = userDAO.registerUser(newUser);

        if (success) {
            request.getSession().setAttribute("regSuccessMessage", "Registration complete! You are enrolled at Level 1 with 0 XP. Please log in.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMessage", "Database registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

