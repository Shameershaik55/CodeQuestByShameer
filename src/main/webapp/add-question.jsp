<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.models.Admin" %>
<%
    Admin admin = null;
    if (session != null) {
        admin = (Admin) session.getAttribute("adminUser");
    }
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Author Question &mdash; CodeQuest Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <div class="cq-form-wide">
            <div class="cq-form-card">
                <div class="cq-form-header">
                    <h2 class="cq-form-title">Create Curriculum Challenge</h2>
                    <p class="cq-form-subtitle">Store a new question dynamically in the MySQL database</p>
                </div>

                <%-- Inline Error Feedback --%>
                <%
                    String error = (String) request.getAttribute("errorMessage");
                    if (error != null && !error.isEmpty()) {
                %>
                    <div class="cq-alert alert-error">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <span><%= error %></span>
                    </div>
                <%
                    }
                %>

                <form action="<%= request.getContextPath() %>/admin/add-question" method="POST" id="questionForm">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.25rem;">
                        <div class="cq-form-group">
                            <label class="cq-form-label" for="title">Question Title</label>
                            <input type="text" id="title" name="title" class="cq-input" 
                                   placeholder="e.g. Memory Leak Identification" required>
                        </div>

                        <div class="cq-form-group">
                            <label class="cq-form-label" for="category">Category</label>
                            <select id="category" name="category" class="cq-select" required>
                                <option value="Java">Java</option>
                                <option value="SQL">SQL</option>
                                <option value="DSA">DSA (Data Structures &amp; Algorithms)</option>
                            </select>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.25rem;">
                        <div class="cq-form-group">
                            <label class="cq-form-label" for="difficulty">Difficulty Level</label>
                            <select id="difficulty" name="difficulty" class="cq-select" required onchange="autoSuggestXp(this.value)">
                                <option value="Easy">Easy (50 XP)</option>
                                <option value="Medium">Medium (75 XP)</option>
                                <option value="Hard">Hard (100 XP)</option>
                            </select>
                        </div>

                        <div class="cq-form-group">
                            <label class="cq-form-label" for="xpReward">XP Award Bounty</label>
                            <input type="number" id="xpReward" name="xpReward" class="cq-input" 
                                   value="50" min="10" max="500" required>
                        </div>
                    </div>

                    <div class="cq-form-group">
                        <label class="cq-form-label" for="description">Problem Statement / Code Snippet</label>
                        <textarea id="description" name="description" class="cq-textarea" 
                                  placeholder="Provide the conceptual explanation, code snippet, or scenario..." required></textarea>
                    </div>

                    <!-- 4 Multiple Choice Options -->
                    <div style="margin: 2rem 0 1.25rem;">
                        <h4 style="font-size: 1.15rem; font-weight: 800; color: var(--lavender-800); margin-bottom: 0.85rem;">
                            Multiple Choice Options
                        </h4>
                        
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.25rem;">
                            <div class="cq-form-group">
                                <label class="cq-form-label" for="optionA">Option A</label>
                                <input type="text" id="optionA" name="optionA" class="cq-input" 
                                       placeholder="First choice" required>
                            </div>
                            <div class="cq-form-group">
                                <label class="cq-form-label" for="optionB">Option B</label>
                                <input type="text" id="optionB" name="optionB" class="cq-input" 
                                       placeholder="Second choice" required>
                            </div>
                            <div class="cq-form-group">
                                <label class="cq-form-label" for="optionC">Option C</label>
                                <input type="text" id="optionC" name="optionC" class="cq-input" 
                                       placeholder="Third choice" required>
                            </div>
                            <div class="cq-form-group">
                                <label class="cq-form-label" for="optionD">Option D</label>
                                <input type="text" id="optionD" name="optionD" class="cq-input" 
                                       placeholder="Fourth choice" required>
                            </div>
                        </div>
                    </div>

                    <div class="cq-form-group" style="background: var(--lavender-50); padding: 1.5rem; border-radius: 18px; border: 1.5px solid var(--lavender-200);">
                        <label class="cq-form-label" style="color: var(--lavender-900);" for="correctAnswer">
                            Correct Answer (Text Must Match One of the Options Exactly)
                        </label>
                        <input type="text" id="correctAnswer" name="correctAnswer" class="cq-input" 
                               placeholder="Type the exact text or use the quick buttons below" required>
                        <div style="display: flex; gap: 0.6rem; margin-top: 0.85rem; flex-wrap: wrap;">
                            <button type="button" class="filter-chip" onclick="setCorrectFrom('optionA')">Set Option A as Correct</button>
                            <button type="button" class="filter-chip" onclick="setCorrectFrom('optionB')">Set Option B as Correct</button>
                            <button type="button" class="filter-chip" onclick="setCorrectFrom('optionC')">Set Option C as Correct</button>
                            <button type="button" class="filter-chip" onclick="setCorrectFrom('optionD')">Set Option D as Correct</button>
                        </div>
                    </div>

                    <div style="display: flex; gap: 1rem; margin-top: 2.25rem;">
                        <button type="submit" class="cq-nav-btn btn-primary" style="flex: 1; justify-content: center; padding: 0.95rem; font-size: 1.02rem;">
                            Publish Question to Database &rarr;
                        </button>
                        <a href="<%= request.getContextPath() %>/admin/view-questions" class="cq-nav-btn btn-secondary" style="padding: 0.95rem 1.75rem;">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>

    <script>
        function autoSuggestXp(diff) {
            const xpInput = document.getElementById('xpReward');
            if (diff === 'Easy') xpInput.value = 50;
            else if (diff === 'Medium') xpInput.value = 75;
            else if (diff === 'Hard') xpInput.value = 100;
        }

        function setCorrectFrom(id) {
            const text = document.getElementById(id).value;
            if (text.trim() === '') {
                alert('Please enter text into ' + id + ' first!');
                return;
            }
            document.getElementById('correctAnswer').value = text.trim();
        }
    </script>
</body>
</html>
