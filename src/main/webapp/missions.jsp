<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.models.User" %>
<%@ page import="com.codequest.models.Mission" %>
<%@ page import="java.util.List" %>
<%
    User student = null;
    if (session != null) {
        student = (User) session.getAttribute("studentUser");
    }

    List<Mission> missions = (List<Mission>) request.getAttribute("missions");
    String activeCategory = (String) request.getAttribute("activeCategory");
    if (activeCategory == null) activeCategory = "ALL";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Missions &mdash; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <!-- Header Banner -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.25rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 2.5rem; font-weight: 800; letter-spacing: -0.6px; color: var(--text-primary);">Evaluated Programming Missions</h1>
                <p style="color: var(--text-muted); font-size: 1.05rem;">
                    Analyze each challenge thoroughly. Correct solutions award XP and advance your player level.
                </p>
            </div>
            <% if (student != null) { %>
                <div style="background: var(--clay-card); border: 1.5px solid var(--lavender-200); border-radius: 20px; padding: 0.85rem 1.5rem; display: flex; align-items: center; gap: 1rem; box-shadow: var(--clay-shadow-sm);">
                    <div style="width: 42px; height: 42px; background: var(--lavender-100); color: var(--lavender-700); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-weight: 800;">
                        <%= student.getPlayerLevel() %>
                    </div>
                    <div>
                        <div style="font-size: 0.78rem; text-transform: uppercase; color: var(--text-muted); font-weight: 800; letter-spacing: 0.5px;">Student Profile</div>
                        <strong style="color: var(--text-primary); font-size: 1.05rem;"><%= student.getUsername() %></strong>
                        <span style="font-size: 0.85rem; color: var(--lavender-700); font-weight: 700; margin-left: 4px;">(<%= student.getTotalXp() %> XP)</span>
                    </div>
                </div>
            <% } else { %>
                <div>
                    <a href="<%= request.getContextPath() %>/login" class="cq-nav-btn btn-primary">
                        Sign In to Submit Answers &rarr;
                    </a>
                </div>
            <% } %>
        </div>

        <!-- Domain Filter Chips -->
        <div class="cq-category-filters">
            <a href="<%= request.getContextPath() %>/missions?category=ALL" 
               class="filter-chip <%= "ALL".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
               All Tracks
            </a>
            <a href="<%= request.getContextPath() %>/missions?category=Java" 
               class="filter-chip <%= "Java".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
               Java
            </a>
            <a href="<%= request.getContextPath() %>/missions?category=SQL" 
               class="filter-chip <%= "SQL".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
               Relational SQL
            </a>
            <a href="<%= request.getContextPath() %>/missions?category=DSA" 
               class="filter-chip <%= "DSA".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
               Data Structures &amp; Algorithms
            </a>
        </div>

        <!-- Dynamic Questions List (Pure Scriptlets, No JSTL / EL) -->
        <%
            if (missions != null && !missions.isEmpty()) {
                for (Mission m : missions) {
                    String diffClass = "badge-easy";
                    if ("Medium".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-medium";
                    else if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-hard";

                    boolean attempted = m.isAlreadyAttempted();
                    boolean prevCorrect = m.isPreviousAttemptCorrect();
        %>
            <div class="mission-card <%= attempted ? "completed" : "" %>">
                <div class="mission-header">
                    <div>
                        <div style="display: flex; gap: 0.6rem; align-items: center; margin-bottom: 0.5rem; flex-wrap: wrap;">
                            <span class="badge-tag" style="background: var(--lavender-100); color: var(--lavender-800); border: 1px solid var(--lavender-200);">
                                <%= m.getCategory() %>
                            </span>
                            <span class="badge-tag <%= diffClass %>">
                                <%= m.getDifficulty() %>
                            </span>
                            <span class="badge-tag badge-xp">
                                +<%= m.getXpReward() %> XP
                            </span>
                            <% if (attempted) { %>
                                <% if (prevCorrect) { %>
                                    <span class="badge-tag" style="background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0;">
                                        &#10004; Solved Correctly
                                    </span>
                                <% } else { %>
                                    <span class="badge-tag" style="background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3;">
                                        &#10008; Attempted (Incorrect)
                                    </span>
                                <% } %>
                            <% } %>
                        </div>
                        <h3 class="mission-title"><%= m.getTitle() %></h3>
                    </div>
                    <div style="font-family: var(--font-mono); font-size: 0.88rem; color: var(--text-muted); font-weight: 600;">
                        Challenge #<%= m.getId() %>
                    </div>
                </div>

                <p style="color: var(--text-secondary); font-size: 1.02rem; line-height: 1.6; margin-bottom: 1.5rem;">
                    <%= m.getDescription() %>
                </p>

                <!-- Submission Form (Answer Masked, Single-Attempt Enforced) -->
                <form action="<%= request.getContextPath() %>/submit-answer" method="POST">
                    <input type="hidden" name="missionId" value="<%= m.getId() %>">

                    <div class="mission-options-list">
                        <label class="mission-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionA() %>" 
                                   <%= attempted ? "disabled" : "required" %>>
                            <span><strong>A.</strong> <%= m.getOptionA() %></span>
                        </label>

                        <label class="mission-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionB() %>" 
                                   <%= attempted ? "disabled" : "required" %>>
                            <span><strong>B.</strong> <%= m.getOptionB() %></span>
                        </label>

                        <label class="mission-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionC() %>" 
                                   <%= attempted ? "disabled" : "required" %>>
                            <span><strong>C.</strong> <%= m.getOptionC() %></span>
                        </label>

                        <label class="mission-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionD() %>" 
                                   <%= attempted ? "disabled" : "required" %>>
                            <span><strong>D.</strong> <%= m.getOptionD() %></span>
                        </label>
                    </div>

                    <div style="display: flex; justify-content: flex-end; align-items: center; margin-top: 1.5rem; gap: 1rem;">
                        <% if (attempted) { %>
                            <span style="font-size: 0.9rem; color: var(--text-muted); font-weight: 600;">
                                Locked: One-Attempt Rule applied to this challenge.
                            </span>
                        <% } else if (student != null) { %>
                            <button type="submit" class="cq-nav-btn btn-primary">
                                Submit Solution (+<%= m.getXpReward() %> XP) &rarr;
                            </button>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/login" class="cq-nav-btn btn-secondary">
                                Sign In to Submit Answer
                            </a>
                        <% } %>
                    </div>
                </form>
            </div>
        <%
                }
            } else {
        %>
            <div class="cq-card" style="text-align: center; padding: 4rem 2rem;">
                <h3 style="font-size: 1.5rem; font-weight: 800; color: var(--text-primary);">No missions found in this category.</h3>
                <p style="color: var(--text-muted); font-size: 1rem; margin-top: 0.5rem;">
                    Please select a different category filter or check back after the curriculum administrator adds challenges.
                </p>
                <div style="margin-top: 1.75rem;">
                    <a href="<%= request.getContextPath() %>/missions?category=ALL" class="cq-nav-btn btn-secondary">
                        View All Categories
                    </a>
                </div>
            </div>
        <%
            }
        %>
    </main>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
