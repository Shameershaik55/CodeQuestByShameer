<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.models.Admin" %>
<%@ page import="com.codequest.config.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
    // Enforce Admin Authentication (Role Isolation)
    Admin admin = null;
    if (session != null) {
        admin = (Admin) session.getAttribute("adminUser");
    }
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
        return;
    }

    // Dynamic Database Statistics
    int totalUsers = 0;
    int totalMissions = 0;
    int totalSubmissions = 0;

    try (Connection conn = DBConnection.getConnection()) {
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalUsers = rs.getInt(1);
        }
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM missions");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalMissions = rs.getInt(1);
        }
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM mission_submissions");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalSubmissions = rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String contextAppName = application.getInitParameter("appName");
    String appTagline = application.getInitParameter("appTagline");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Console &mdash; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <!-- Admin HUD Header -->
        <div class="hud-banner">
            <div class="hud-user-info">
                <div class="hud-avatar">
                    <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                </div>
                <div>
                    <div class="hud-rank-tag">System Administration</div>
                    <h2 class="hud-username">Command Center &bull; <%= admin.getUsername() %></h2>
                    <p style="color: var(--text-muted); font-size: 0.92rem;">
                        <%= contextAppName != null ? contextAppName : "CodeQuest" %> &bull; <%= appTagline != null ? appTagline : "Platform Operations" %>
                    </p>
                </div>
            </div>

            <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/admin/add-question" class="cq-nav-btn btn-primary">
                    + Add New Question
                </a>
                <a href="<%= request.getContextPath() %>/admin/view-questions" class="cq-nav-btn btn-secondary">
                    View Catalog
                </a>
                <a href="<%= request.getContextPath() %>/admin-logout" class="cq-nav-btn btn-danger">
                    Terminate Session
                </a>
            </div>
        </div>

        <!-- Live Platform Telemetry Metrics -->
        <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">Platform Telemetry</h3>
        <div class="cq-grid-3">
            <div class="cq-card">
                <div class="stat-metric-value"><%= totalUsers %></div>
                <div class="stat-metric-label">Enrolled Students</div>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.6rem;">
                    Active student profiles participating in evaluated challenges
                </p>
            </div>

            <div class="cq-card">
                <div class="stat-metric-value" style="color: var(--lavender-600);"><%= totalMissions %></div>
                <div class="stat-metric-label">Curriculum Challenges</div>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.6rem;">
                    Active questions authored across Java, SQL, and DSA
                </p>
            </div>

            <div class="cq-card">
                <div class="stat-metric-value" style="color: var(--accent-emerald);"><%= totalSubmissions %></div>
                <div class="stat-metric-label">Evaluated Submissions</div>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.6rem;">
                    Total student attempts processed through JDBC transactions
                </p>
            </div>
        </div>

        <!-- Action Cards -->
        <div class="cq-grid-2" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 1.75rem; margin-top: 2.25rem;">
            <div class="cq-card" style="border-left: 5px solid var(--lavender-600);">
                <h4 style="font-size: 1.3rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">Author New Question</h4>
                <p style="color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 1.5rem; line-height: 1.6;">
                    Insert programming challenges into MySQL with custom categories (Java, SQL, DSA), difficulty levels, 4 multiple choice options, and assigned XP bounties.
                </p>
                <a href="<%= request.getContextPath() %>/admin/add-question" class="cq-nav-btn btn-primary">
                    Open Authoring Form &rarr;
                </a>
            </div>

            <div class="cq-card" style="border-left: 5px solid var(--accent-cyan);">
                <h4 style="font-size: 1.3rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">Curriculum Management</h4>
                <p style="color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 1.5rem; line-height: 1.6;">
                    Inspect the active question bank stored in the database. Filter challenges by discipline, review difficulty distributions, and inspect solutions.
                </p>
                <a href="<%= request.getContextPath() %>/admin/view-questions" class="cq-nav-btn btn-secondary">
                    View All Questions &rarr;
                </a>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
