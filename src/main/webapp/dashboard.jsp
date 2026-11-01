<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.models.User" %>
<%
    User student = null;
    if (session != null) {
        student = (User) session.getAttribute("studentUser");
    }
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
        return;
    }

    User user = (User) request.getAttribute("user");
    if (user == null) user = student;

    Integer completedCount = (Integer) request.getAttribute("completedCount");
    if (completedCount == null) completedCount = 0;

    Integer progressPercent = (Integer) request.getAttribute("progressPercent");
    if (progressPercent == null) progressPercent = user.getLevelProgressPercent();

    Integer xpNeeded = (Integer) request.getAttribute("xpNeeded");
    if (xpNeeded == null) xpNeeded = user.getXpToNextLevel();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= user.getUsername() %>'s Dashboard &mdash; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <!-- Student HUD Banner -->
        <div class="hud-banner">
            <div class="hud-user-info">
                <div class="hud-avatar">
                    <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </div>
                <div>
                    <div class="hud-rank-tag">
                        Rank Tier: <%= user.getRankTitle() %>
                    </div>
                    <h1 class="hud-username"><%= user.getUsername() %></h1>
                    <div style="font-size: 0.92rem; color: var(--text-muted); margin-top: 2px;">
                        <%= user.getEmail() %> &bull; Enrolled: <%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 10) : "Active Student" %>
                    </div>
                </div>
            </div>

            <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/missions" class="cq-nav-btn btn-primary pulse-glow">
                    Solve Next Challenge &rarr;
                </a>
                <a href="<%= request.getContextPath() %>/leaderboard" class="cq-nav-btn btn-secondary">
                    View Rankings
                </a>
            </div>
        </div>

        <!-- Level & XP Advancement Track -->
        <div class="cq-card" style="margin-bottom: 2.25rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem; flex-wrap: wrap; gap: 0.75rem;">
                <div>
                    <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--text-primary);">
                        Level <%= user.getPlayerLevel() %> Progression
                    </h3>
                    <span style="font-size: 0.88rem; color: var(--text-muted);">
                        Advancement threshold: 100 XP per rank tier
                    </span>
                </div>
                <div style="font-weight: 800; font-size: 1.05rem; color: var(--lavender-700);">
                    <%= xpNeeded %> XP to Level <%= user.getPlayerLevel() + 1 %>
                </div>
            </div>

            <div class="xp-bar-container">
                <div class="xp-bar-label">
                    <span><%= progressPercent %>% Progress Completed</span>
                    <span>Total Accumulated: <%= user.getTotalXp() %> XP</span>
                </div>
                <div class="xp-progress-track">
                    <div class="xp-progress-fill" style="width: <%= progressPercent %>%;"></div>
                </div>
            </div>
        </div>

        <!-- Key Metrics Cards -->
        <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.75rem;">Academic Performance Metrics</h3>
        <div class="cq-grid-4">
            <div class="stat-metric-card">
                <div class="stat-metric-value"><%= user.getPlayerLevel() %></div>
                <div class="stat-metric-label">Current Level</div>
            </div>

            <div class="stat-metric-card">
                <div class="stat-metric-value"><%= user.getTotalXp() %></div>
                <div class="stat-metric-label">Total Experience (XP)</div>
            </div>

            <div class="stat-metric-card">
                <div class="stat-metric-value" style="color: var(--accent-emerald);"><%= completedCount %></div>
                <div class="stat-metric-label">Missions Mastered</div>
            </div>

            <div class="stat-metric-card">
                <div class="stat-metric-value" style="font-size: 1.55rem; color: #d97706;"><%= user.getRankTitle() %></div>
                <div class="stat-metric-label">Prestige Standing</div>
            </div>
        </div>

        <!-- Quick Access CTA -->
        <div class="cq-card" style="margin-top: 3rem; text-align: center; padding: 3rem 2rem; background: linear-gradient(180deg, #ffffff 0%, var(--lavender-50) 100%);">
            <h3 style="font-size: 1.7rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">Continue Your Learning Journey</h3>
            <p style="color: var(--text-secondary); font-size: 1.02rem; max-width: 600px; margin: 0 auto 1.75rem;">
                Select from Java, SQL, or Data Structures challenges. Each mission allows one evaluated attempt to encourage disciplined code analysis.
            </p>
            <a href="<%= request.getContextPath() %>/missions" class="cq-nav-btn btn-primary" style="padding: 0.95rem 2.25rem; font-size: 1.05rem;">
                Browse Available Challenges &rarr;
            </a>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
