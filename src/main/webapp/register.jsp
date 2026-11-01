<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration &mdash; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Unified Navbar Include -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="cq-main-container">
        <div class="cq-form-wrapper">
            <div class="cq-form-card">
                <div class="cq-form-header">
                    <h2 class="cq-form-title">Student Registration</h2>
                    <p class="cq-form-subtitle">Enroll as a learner &bull; Begin at Level 1 with 0 XP</p>
                </div>

                <%-- Inline Validation Feedback (Pure Scriptlets, No JSTL / EL) --%>
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
                    String enteredUser = (String) request.getAttribute("enteredUsername");
                    if (enteredUser == null) enteredUser = "";
                    String enteredMail = (String) request.getAttribute("enteredEmail");
                    if (enteredMail == null) enteredMail = "";
                %>

                <form action="<%= request.getContextPath() %>/register" method="POST" id="regForm">
                    <div class="cq-form-group">
                        <label class="cq-form-label" for="username">Student Username</label>
                        <input type="text" id="username" name="username" class="cq-input" 
                               value="<%= enteredUser %>" placeholder="e.g. alex_rivera" required autocomplete="username">
                    </div>

                    <div class="cq-form-group">
                        <label class="cq-form-label" for="email">Institutional / Personal Email</label>
                        <input type="email" id="email" name="email" class="cq-input" 
                               value="<%= enteredMail %>" placeholder="student@university.edu" required autocomplete="email">
                    </div>

                    <div class="cq-form-group">
                        <label class="cq-form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="cq-input" 
                               placeholder="Minimum 4 characters" required autocomplete="new-password">
                    </div>

                    <div class="cq-form-group">
                        <label class="cq-form-label" for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="cq-input" 
                               placeholder="Re-enter your password" required autocomplete="new-password">
                        <small id="pwdMatchMsg" style="display: block; font-size: 0.8rem; margin-top: 5px; font-weight: 600;"></small>
                    </div>

                    <div style="margin-top: 2rem;">
                        <button type="submit" class="cq-nav-btn btn-primary" style="width: 100%; justify-content: center; padding: 0.95rem; font-size: 1.02rem;">
                            Complete Registration &rarr;
                        </button>
                    </div>
                </form>

                <div style="text-align: center; margin-top: 1.75rem; font-size: 0.92rem; color: var(--text-secondary);">
                    Already enrolled? 
                    <a href="<%= request.getContextPath() %>/login" style="color: var(--lavender-700); text-decoration: none; font-weight: 700;">Sign in to account &rarr;</a>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>

    <script>
        const pwd = document.getElementById('password');
        const confirmPwd = document.getElementById('confirmPassword');
        const matchMsg = document.getElementById('pwdMatchMsg');

        function checkMatch() {
            if (!confirmPwd.value) {
                matchMsg.textContent = '';
                return;
            }
            if (pwd.value === confirmPwd.value) {
                matchMsg.style.color = '#059669';
                matchMsg.textContent = '✓ Passwords match';
            } else {
                matchMsg.style.color = '#e11d48';
                matchMsg.textContent = '✕ Passwords do not match';
            }
        }

        pwd.addEventListener('input', checkMatch);
        confirmPwd.addEventListener('input', checkMatch);
    </script>
</body>
</html>
