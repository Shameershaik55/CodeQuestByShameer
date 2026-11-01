<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.models.LeaderboardEntry" %>
<%@ page import="java.util.List" %>
<%
    List<LeaderboardEntry> leaderboard = (List<LeaderboardEntry>) request.getAttribute("leaderboard");
    if (leaderboard == null) {
        com.codequest.dao.SubmissionDAO sDao = new com.codequest.dao.SubmissionDAO();
        leaderboard = sDao.getLeaderboard();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Global Standings &mdash; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <!-- Title Banner -->
        <div style="text-align: center; margin-bottom: 2.5rem;">
            <div class="cq-hero-pill" style="margin-bottom: 0.85rem;">
                <span>VERIFIED ACADEMIC STANDINGS</span>
            </div>
            <h1 style="font-size: 3rem; font-weight: 800; letter-spacing: -0.8px; color: var(--text-primary);">
                Global Student <span class="gradient-text">Leaderboard</span>
            </h1>
            <p style="color: var(--text-muted); font-size: 1.05rem; max-width: 620px; margin: 0 auto;">
                Students ranked dynamically by verified experience points (XP) and correctly mastered challenges.
            </p>
        </div>

        <% if (leaderboard != null && !leaderboard.isEmpty()) { %>
            <!-- Top 3 Claymorphic Podium Showcase -->
            <div class="podium-container">
                <% 
                    LeaderboardEntry first = leaderboard.size() > 0 ? leaderboard.get(0) : null;
                    LeaderboardEntry second = leaderboard.size() > 1 ? leaderboard.get(1) : null;
                    LeaderboardEntry third = leaderboard.size() > 2 ? leaderboard.get(2) : null;
                %>

                <!-- Rank #2 (Silver) -->
                <% if (second != null) { %>
                    <div class="podium-slot rank-2">
                        <div class="podium-pillar">
                            <span class="badge-tag" style="background: #f1f5f9; color: #475569; border: 1.5px solid #cbd5e1; margin-bottom: 0.6rem;">
                                Rank #2 &bull; Silver
                            </span>
                            <div class="podium-username"><%= second.getUsername() %></div>
                            <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 0.75rem;">
                                Lv. <%= second.getPlayerLevel() %> &bull; <%= second.getRankTitle() %>
                            </div>
                            <div class="podium-xp"><%= second.getTotalXp() %> XP</div>
                            <div style="font-size: 0.85rem; color: var(--accent-emerald); font-weight: 700; margin-top: 0.35rem;">
                                <%= second.getCompletedMissions() %> Challenges Solved
                            </div>
                        </div>
                    </div>
                <% } %>

                <!-- Rank #1 (Gold Champion) -->
                <% if (first != null) { %>
                    <div class="podium-slot rank-1">
                        <div class="podium-pillar">
                            <span class="badge-tag" style="background: #fffbeb; color: #b45309; border: 1.5px solid #fde68a; margin-bottom: 0.6rem;">
                                ★ Rank #1 &bull; Gold Champion ★
                            </span>
                            <div class="podium-username" style="font-size: 1.45rem; color: var(--text-primary);"><%= first.getUsername() %></div>
                            <div style="font-size: 0.88rem; color: var(--text-muted); margin-bottom: 0.75rem;">
                                Lv. <%= first.getPlayerLevel() %> &bull; <%= first.getRankTitle() %>
                            </div>
                            <div class="podium-xp" style="font-size: 1.65rem; color: #d97706;"><%= first.getTotalXp() %> XP</div>
                            <div style="font-size: 0.88rem; color: var(--accent-emerald); font-weight: 700; margin-top: 0.35rem;">
                                <%= first.getCompletedMissions() %> Challenges Solved
                            </div>
                        </div>
                    </div>
                <% } %>

                <!-- Rank #3 (Bronze) -->
                <% if (third != null) { %>
                    <div class="podium-slot rank-3">
                        <div class="podium-pillar">
                            <span class="badge-tag" style="background: #fff7ed; color: #c2410c; border: 1.5px solid #fed7aa; margin-bottom: 0.6rem;">
                                Rank #3 &bull; Bronze
                            </span>
                            <div class="podium-username"><%= third.getUsername() %></div>
                            <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 0.75rem;">
                                Lv. <%= third.getPlayerLevel() %> &bull; <%= third.getRankTitle() %>
                            </div>
                            <div class="podium-xp"><%= third.getTotalXp() %> XP</div>
                            <div style="font-size: 0.85rem; color: var(--accent-emerald); font-weight: 700; margin-top: 0.35rem;">
                                <%= third.getCompletedMissions() %> Challenges Solved
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Complete Roster Table (Pure Scriptlets, No JSTL / EL) -->
            <div style="margin-bottom: 1.25rem; display: flex; justify-content: space-between; align-items: center;">
                <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary);">Complete Academic Standings</h3>
                <span style="font-size: 0.9rem; color: var(--text-muted); font-weight: 600;">
                    <%= leaderboard.size() %> enrolled student<%= leaderboard.size() == 1 ? "" : "s" %> evaluated
                </span>
            </div>

            <div class="cq-table-wrapper">
                <table class="cq-table">
                    <thead>
                        <tr>
                            <th style="width: 90px; text-align: center;">Rank</th>
                            <th>Student Handle</th>
                            <th style="width: 150px;">Player Level</th>
                            <th style="width: 180px;">Prestige Standing</th>
                            <th style="width: 170px; text-align: center;">Challenges Mastered</th>
                            <th style="width: 140px; text-align: right;">Total Experience</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (LeaderboardEntry entry : leaderboard) {
                                String medalBadge = "";
                                String rowStyle = "";
                                if (entry.getRank() == 1) {
                                    medalBadge = "background: #fffbeb; color: #b45309; border: 1px solid #fde68a;";
                                    rowStyle = "background: #fffefb;";
                                } else if (entry.getRank() == 2) {
                                    medalBadge = "background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1;";
                                } else if (entry.getRank() == 3) {
                                    medalBadge = "background: #fff7ed; color: #c2410c; border: 1px solid #fed7aa;";
                                }
                        %>
                            <tr style="<%= rowStyle %>">
                                <td style="text-align: center;">
                                    <% if (!medalBadge.isEmpty()) { %>
                                        <span class="badge-tag" style="<%= medalBadge %> font-weight: 800;">
                                            #<%= entry.getRank() %>
                                        </span>
                                    <% } else { %>
                                        <span style="font-family: var(--font-mono); font-size: 0.95rem; font-weight: 700; color: var(--text-muted);">
                                            #<%= entry.getRank() %>
                                        </span>
                                    <% } %>
                                </td>
                                <td>
                                    <strong style="color: var(--text-primary); font-size: 1.02rem;"><%= entry.getUsername() %></strong>
                                </td>
                                <td>
                                    <span class="badge-tag badge-xp">
                                        Level <%= entry.getPlayerLevel() %>
                                    </span>
                                </td>
                                <td>
                                    <span style="font-size: 0.9rem; color: var(--text-secondary); font-weight: 600;">
                                        <%= entry.getRankTitle() %>
                                    </span>
                                </td>
                                <td style="text-align: center; color: var(--accent-emerald); font-weight: 700;">
                                    <%= entry.getCompletedMissions() %>
                                </td>
                                <td style="text-align: right; font-weight: 800; color: var(--lavender-700); font-size: 1.05rem;">
                                    <%= entry.getTotalXp() %> XP
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

        <% } else { %>
            <!-- Appropriate message when no players are available (Assignment Requirement) -->
            <div class="cq-card" style="text-align: center; padding: 4.5rem 2rem; max-width: 620px; margin: 2rem auto;">
                <h3 style="font-size: 1.6rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">No Student Standings Recorded Yet</h3>
                <p style="color: var(--text-secondary); font-size: 1rem; margin-bottom: 2rem; line-height: 1.6;">
                    Be the first student to register an account, solve an evaluated mission, and secure the #1 position on the global leaderboard.
                </p>
                <a href="<%= request.getContextPath() %>/register" class="cq-nav-btn btn-primary pulse-glow" style="padding: 0.95rem 2.25rem;">
                    Register Account &amp; Claim Rank #1 &rarr;
                </a>
            </div>
        <% } %>
    </main>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
