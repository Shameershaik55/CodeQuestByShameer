<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.models.Admin" %>
<%@ page import="com.codequest.models.Mission" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = null;
    if (session != null) {
        admin = (Admin) session.getAttribute("adminUser");
    }
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
        return;
    }

    List<Mission> questionsList = (List<Mission>) request.getAttribute("questionsList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Inventory &mdash; CodeQuest Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 2.2rem; font-weight: 800; letter-spacing: -0.6px; color: var(--text-primary);">Curriculum Question Bank</h1>
                <p style="color: var(--text-muted); font-size: 1rem;">
                    All programming challenges stored in MySQL (<code>missions</code> table)
                </p>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/admin/add-question" class="cq-nav-btn btn-primary">
                    + Author New Question
                </a>
            </div>
        </div>

        <%-- Post-addition notification --%>
        <%
            String msg = request.getParameter("msg");
            if ("added_successfully".equals(msg)) {
        %>
            <div class="cq-alert alert-success">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                <span>Question saved to database successfully and published to student curriculum!</span>
            </div>
        <%
            }
        %>

        <!-- Filter and Search Bar -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <div class="cq-category-filters" style="margin-bottom: 0;">
                <button class="filter-chip active" onclick="filterTable('ALL', this)">All Challenges</button>
                <button class="filter-chip" onclick="filterTable('Java', this)">Java</button>
                <button class="filter-chip" onclick="filterTable('SQL', this)">SQL</button>
                <button class="filter-chip" onclick="filterTable('DSA', this)">DSA</button>
            </div>
            <div>
                <input type="text" id="tableSearch" class="cq-input" placeholder="Search by title..." 
                       style="width: 260px; padding: 0.55rem 1rem; font-size: 0.9rem;" oninput="searchQuestions()">
            </div>
        </div>

        <!-- Pure Scriptlets Table (No JSTL / EL) -->
        <div class="cq-table-wrapper">
            <table class="cq-table" id="questionsTable">
                <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Challenge Title</th>
                        <th style="width: 130px;">Category</th>
                        <th style="width: 130px;">Difficulty</th>
                        <th style="width: 120px;">XP Reward</th>
                        <th>Expected Solution</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (questionsList != null && !questionsList.isEmpty()) {
                            for (Mission m : questionsList) {
                                String diffClass = "badge-easy";
                                if ("Medium".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-medium";
                                else if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-hard";
                    %>
                        <tr data-category="<%= m.getCategory() %>">
                            <td style="font-family: var(--font-mono); color: var(--lavender-700); font-weight: 700;">
                                #<%= m.getId() %>
                            </td>
                            <td>
                                <strong style="color: var(--text-primary); font-size: 1rem;"><%= m.getTitle() %></strong>
                                <div style="font-size: 0.85rem; color: var(--text-secondary); max-width: 480px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; margin-top: 2px;">
                                    <%= m.getDescription() %>
                                </div>
                            </td>
                            <td>
                                <span class="badge-tag" style="background: var(--lavender-100); color: var(--lavender-800); border: 1px solid var(--lavender-200);">
                                    <%= m.getCategory() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge-tag <%= diffClass %>">
                                    <%= m.getDifficulty() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge-tag badge-xp">
                                    +<%= m.getXpReward() %> XP
                                </span>
                            </td>
                            <td style="font-family: var(--font-mono); font-size: 0.88rem; color: var(--accent-emerald); font-weight: 600;">
                                <%= m.getCorrectAnswer() %>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 3.5rem; color: var(--text-muted);">
                                No questions found in the database. Click "+ Author New Question" to add one.
                            </td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>

    <script>
        function filterTable(category, chip) {
            document.querySelectorAll('.cq-category-filters .filter-chip').forEach(c => c.classList.remove('active'));
            chip.classList.add('active');

            const rows = document.querySelectorAll('#questionsTable tbody tr');
            rows.forEach(r => {
                const rowCat = r.getAttribute('data-category');
                if (category === 'ALL' || (rowCat && rowCat.toLowerCase() === category.toLowerCase())) {
                    r.style.display = '';
                } else {
                    r.style.display = 'none';
                }
            });
        }

        function searchQuestions() {
            const query = document.getElementById('tableSearch').value.toLowerCase();
            const rows = document.querySelectorAll('#questionsTable tbody tr');
            rows.forEach(r => {
                const text = r.textContent.toLowerCase();
                r.style.display = text.includes(query) ? '' : 'none';
            });
        }
    </script>
</body>
</html>
