package com.codequest.servlets;

import com.codequest.dao.AdminDAO;
import com.codequest.models.Admin;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(
    urlPatterns = {"/admin-login"},
    initParams = {
        @WebInitParam(name = "adminRoleTitle", value = "Command Center Administrator"),
        @WebInitParam(name = "maxLoginAttempts", value = "5")
    }
)
public class AdminLoginServlet extends HttpServlet {

    private AdminDAO adminDAO;
    private String adminRoleTitle;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        adminDAO = new AdminDAO();
        // Demonstrating ServletConfig: reading servlet-specific init parameter
        this.adminRoleTitle = config.getInitParameter("adminRoleTitle");
        if (this.adminRoleTitle == null) {
            this.adminRoleTitle = "Administrator";
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Demonstrating ServletContext: reading application-wide context parameter
        ServletContext context = getServletContext();
        String appName = context.getInitParameter("appName");
        request.setAttribute("appName", appName);
        request.setAttribute("adminRoleTitle", adminRoleTitle);

        request.getRequestDispatcher("admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Admin username and password are required!");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminDAO.validateLogin(username, password);

        if (admin != null) {
            // Create dedicated Admin Session (separate from student session)
            HttpSession session = request.getSession(true);
            session.setAttribute("adminUser", admin);
            session.setAttribute("adminId", admin.getId());
            session.setAttribute("adminUsername", admin.getUsername());

            // Redirect to Admin Dashboard
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Access Denied: Invalid administrator credentials!");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }
}

