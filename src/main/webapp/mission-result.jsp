<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.models.Mission" %>
<%@ page import="com.codequest.models.User" %>
<%
    Boolean alreadyAttempted = (Boolean) request.getAttribute("alreadyAttempted");
    if (alreadyAttempted == null) alreadyAttempted = false;

    Boolean isCorrect = (Boolean) request.getAttribute("isCorrect");
    if (isCorrect == null) isCorrect = false;

    Boolean didLevelUp = (Boolean) request.getAttribute("didLevelUp");
    if (didLevelUp == null) didLevelUp = false;

    Integer xpEarned = (Integer) request.getAttribute("xpEarned");
    if (xpEarned == null) xpEarned = 0;

    Integer newTotalXp = (Integer) request.getAttribute("newTotalXp");
    if (newTotalXp == null) newTotalXp = 0;

    Integer newLevel = (Integer) request.getAttribute("newLevel");
    if (newLevel == null) newLevel = 1;

    Mission mission = (Mission) request.getAttribute("mission");
    String selectedAnswer = (String) request.getAttribute("selectedAnswer");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluation Result &mdash; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <div class="cq-form-wrapper" style="max-width: 660px;">
            <% if (alreadyAttempted) { %>
                <!-- Duplicate Attempt Warning Card -->
                <div class="cq-form-card" style="text-align: center; border-top: 5px solid var(--accent-amber);">
                    <div style="width: 60px; height: 60px; background: var(--accent-amber-soft); color: var(--accent-amber); border-radius: 20px; margin: 0 auto 1.25rem; display: flex; align-items: center; justify-content: center; font-size: 1.75rem; box-shadow: var(--clay-shadow-sm);">
                        !
                    </div>
                    <h2 class="cq-form-title" style="color: var(--text-primary);">Challenge Already Recorded</h2>
                    <p style="color: var(--text-secondary); font-size: 1.05rem; margin-bottom: 2rem; line-height: 1.6;">
                        You have already completed an evaluated attempt for this mission. In accordance with CodeQuest competition guidelines, each challenge allows exactly one attempt.
                    </p>
                    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                        <a href="<%= request.getContextPath() %>/missions" class="cq-nav-btn btn-primary">
                            Explore Other Missions &rarr;
                        </a>
                        <a href="<%= request.getContextPath() %>/dashboard" class="cq-nav-btn btn-secondary">
                            Return to Dashboard
                        </a>
                    </div>
                </div>

            <% } else if (isCorrect) { %>
                <!-- Correct Solution Card -->
                <div class="cq-form-card" style="text-align: center; border-top: 5px solid var(--accent-emerald);">
                    <div style="width: 64px; height: 64px; background: var(--accent-emerald-soft); color: var(--accent-emerald); border-radius: 20px; margin: 0 auto 1rem; display: flex; align-items: center; justify-content: center; font-size: 2rem; box-shadow: var(--clay-shadow-sm);">
                        ✓
                    </div>
                    <div class="hud-rank-tag" style="color: var(--accent-emerald);">Challenge Solved</div>
                    <h2 class="cq-form-title" style="color: var(--text-primary); margin-top: 0.25rem;">
                        Correct Solution!
                    </h2>

                    <div style="margin: 1.5rem 0; padding: 1.5rem; background: var(--accent-emerald-soft); border-radius: 20px; border: 1.5px solid #a7f3d0;">
                        <div style="font-size: 0.85rem; text-transform: uppercase; color: #047857; font-weight: 800; letter-spacing: 0.5px;">XP Award Bounty</div>
                        <div style="font-size: 3rem; font-weight: 800; color: #059669; font-family: var(--font-sans); letter-spacing: -1px;">
                            +<%= xpEarned %> XP
                        </div>
                        <div style="font-size: 0.95rem; color: var(--text-secondary); margin-top: 0.35rem; font-weight: 600;">
                            New Standing: <strong style="color: var(--text-primary);"><%= newTotalXp %> XP</strong> &bull; Player Level: <strong style="color: var(--lavender-700);"><%= newLevel %></strong>
                        </div>
                    </div>

                    <% if (didLevelUp) { %>
                        <!-- Level-Up Alert Banner -->
                        <div style="margin-bottom: 1.75rem; padding: 1.25rem; background: linear-gradient(135deg, #fffbeb, #faf5ff); border-radius: 18px; border: 1.5px solid #fde68a; box-shadow: var(--clay-shadow-sm);">
                            <strong style="color: #d97706; font-size: 1.15rem; display: block; font-weight: 800;">LEVEL UP ACHIEVED!</strong>
                            <span style="font-size: 0.95rem; color: var(--text-primary); font-weight: 600;">
                                Congratulations! You have successfully advanced to <strong>Level <%= newLevel %></strong>.
                            </span>
                        </div>
                    <% } %>

                    <div style="text-align: left; background: var(--bg-subtle); padding: 1.5rem; border-radius: 18px; margin-bottom: 2rem; border: 1.5px solid var(--lavender-100);">
                        <div style="font-size: 0.82rem; text-transform: uppercase; color: var(--text-muted); font-weight: 800; letter-spacing: 0.5px;">Challenge Title</div>
                        <strong style="font-size: 1.05rem; color: var(--text-primary); display: block; margin-top: 2px;"><%= mission != null ? mission.getTitle() : "Challenge" %></strong>
                        <div style="margin-top: 0.85rem; font-size: 0.92rem; color: var(--text-secondary);">
                            <span>Your Submitted Choice:</span>
                            <span style="color: #059669; font-weight: 700; margin-left: 5px;">&ldquo;<%= selectedAnswer %>&rdquo;</span>
                        </div>
                    </div>

                    <div style="display: flex; gap: 0.85rem; justify-content: center; flex-wrap: wrap;">
                        <a href="<%= request.getContextPath() %>/missions" class="cq-nav-btn btn-primary pulse-glow">
                            Solve Next Challenge &rarr;
                        </a>
                        <a href="<%= request.getContextPath() %>/dashboard" class="cq-nav-btn btn-secondary">
                            View Dashboard
                        </a>
                        <a href="<%= request.getContextPath() %>/leaderboard" class="cq-nav-btn btn-secondary">
                            Standings
                        </a>
                    </div>
                </div>

            <% } else { %>
                <!-- Incorrect Answer Card -->
                <div class="cq-form-card" style="text-align: center; border-top: 5px solid var(--accent-rose);">
                    <div style="width: 64px; height: 64px; background: var(--accent-rose-soft); color: var(--accent-rose); border-radius: 20px; margin: 0 auto 1rem; display: flex; align-items: center; justify-content: center; font-size: 2rem; box-shadow: var(--clay-shadow-sm);">
                        ✕
                    </div>
                    <div class="hud-rank-tag" style="color: var(--accent-rose);">Evaluation Complete</div>
                    <h2 class="cq-form-title" style="color: var(--text-primary); margin-top: 0.25rem;">
                        Incorrect Solution
                    </h2>

                    <div style="margin: 1.5rem 0; padding: 1.5rem; background: var(--accent-rose-soft); border-radius: 20px; border: 1.5px solid #fecdd3;">
                        <div style="font-size: 0.85rem; text-transform: uppercase; color: #be123c; font-weight: 800; letter-spacing: 0.5px;">XP Awarded</div>
                        <div style="font-size: 2.75rem; font-weight: 800; color: #e11d48; font-family: var(--font-sans); letter-spacing: -1px;">
                            +0 XP
                        </div>
                        <div style="font-size: 0.95rem; color: var(--text-secondary); margin-top: 0.35rem; font-weight: 600;">
                            No XP was awarded for this attempt. Review the correct concept below to strengthen your understanding.
                        </div>
                    </div>

                    <div style="text-align: left; background: var(--bg-subtle); padding: 1.5rem; border-radius: 18px; margin-bottom: 2rem; border: 1.5px solid var(--lavender-100);">
                        <div style="font-size: 0.82rem; text-transform: uppercase; color: var(--text-muted); font-weight: 800; letter-spacing: 0.5px;">Solution Review</div>
                        <strong style="font-size: 1.05rem; color: var(--text-primary); display: block; margin-top: 2px;"><%= mission != null ? mission.getTitle() : "Challenge" %></strong>
                        
                        <div style="margin-top: 0.85rem; font-size: 0.92rem;">
                            <span style="color: var(--text-muted);">Your Selection:</span>
                            <span style="color: #e11d48; text-decoration: line-through; margin-left: 5px;"><%= selectedAnswer %></span>
                        </div>
                        <% if (mission != null && mission.getCorrectAnswer() != null) { %>
                            <div style="margin-top: 0.45rem; font-size: 0.92rem;">
                                <span style="color: var(--text-muted);">Expected Answer:</span>
                                <span style="color: #059669; font-weight: 700; margin-left: 5px;"><%= mission.getCorrectAnswer() %></span>
                            </div>
                        <% } %>
                    </div>

                    <div style="display: flex; gap: 0.85rem; justify-content: center; flex-wrap: wrap;">
                        <a href="<%= request.getContextPath() %>/missions" class="cq-nav-btn btn-primary">
                            Continue Curriculum &rarr;
                        </a>
                        <a href="<%= request.getContextPath() %>/dashboard" class="cq-nav-btn btn-secondary">
                            View Dashboard
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            <% if (isCorrect) { %>
                <% if (didLevelUp) { %>
                    window.CodeQuestAudio.playLevelUp();
                <% } else { %>
                    window.CodeQuestAudio.playSuccess();
                <% } %>
                if (typeof window.launchConfetti === 'function') {
                    window.launchConfetti();
                }
            <% } else if (!alreadyAttempted) { %>
                window.CodeQuestAudio.playFail();
            <% } %>
        });
    </script>
</body>
</html>
