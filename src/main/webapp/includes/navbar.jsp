<%@ page import="com.codequest.models.User" %>
<%@ page import="com.codequest.models.Admin" %>
<%
    User navStudent = null;
    Admin navAdmin = null;
    if (session != null) {
        navStudent = (User) session.getAttribute("studentUser");
        navAdmin = (Admin) session.getAttribute("adminUser");
    }
    String ctxPath = request.getContextPath();
%>
<nav class="cq-navbar">
    <a href="<%= ctxPath %>/" class="cq-brand">
        <div class="cq-logo-icon">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                <polyline points="2 17 12 22 22 17"></polyline>
                <polyline points="2 12 12 17 22 12"></polyline>
            </svg>
        </div>
        <div class="cq-brand-text">CodeQuest <span class="cq-brand-badge">PRO</span></div>
    </a>

    <ul class="cq-nav-links">
        <li>
            <a href="<%= ctxPath %>/" class="cq-nav-link">
                Home
            </a>
        </li>
        <li>
            <a href="<%= ctxPath %>/missions" class="cq-nav-link">
                Missions
            </a>
        </li>
        <li>
            <a href="<%= ctxPath %>/leaderboard" class="cq-nav-link">
                Leaderboard
            </a>
        </li>

        <% if (navStudent != null) { %>
            <!-- Student Logged In -->
            <li>
                <a href="<%= ctxPath %>/dashboard" class="cq-nav-link">
                    Dashboard 
                    <span class="badge-tag badge-xp" style="margin-left: 6px; font-size: 0.72rem; padding: 0.15rem 0.55rem;">Lv.<%= navStudent.getPlayerLevel() %></span>
                </a>
            </li>
            <li>
                <a href="<%= ctxPath %>/logout" class="cq-nav-btn btn-danger" style="padding: 0.45rem 1rem;">
                    Sign Out (<%= navStudent.getUsername() %>)
                </a>
            </li>
        <% } else if (navAdmin != null) { %>
            <!-- Admin Logged In -->
            <li><a href="<%= ctxPath %>/admin-dashboard.jsp" class="cq-nav-link">Admin Console</a></li>
            <li><a href="<%= ctxPath %>/admin/view-questions" class="cq-nav-link">Curriculum</a></li>
            <li><a href="<%= ctxPath %>/admin/add-question" class="cq-nav-link">+ New Challenge</a></li>
            <li>
                <a href="<%= ctxPath %>/admin-logout" class="cq-nav-btn btn-danger" style="padding: 0.45rem 1rem;">
                    Exit Admin
                </a>
            </li>
        <% } else { %>
            <!-- Guest Links -->
            <li><a href="<%= ctxPath %>/login" class="cq-nav-btn btn-secondary">Student Sign In</a></li>
            <li><a href="<%= ctxPath %>/register" class="cq-nav-btn btn-primary pulse-glow">Create Account</a></li>
            <li><a href="<%= ctxPath %>/admin-login" class="cq-nav-btn btn-admin" style="font-size: 0.82rem; padding: 0.45rem 0.85rem;">Admin Terminal</a></li>
        <% } %>

        <!-- Elegant Audio Synthesizer Toggle -->
        <li>
            <button id="soundToggleBtn" class="sound-toggle-btn" onclick="window.CodeQuestAudio.toggleMute()" title="Toggle Web Audio FX">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle;">
                    <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                    <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"></path>
                </svg>
            </button>
        </li>
    </ul>
</nav>
