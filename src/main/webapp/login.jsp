<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Sign In &mdash; CodeQuest</title>
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
                    <h2 class="cq-form-title">Student Portal</h2>
                    <p class="cq-form-subtitle">Authenticate to access missions and dashboard</p>
                </div>

                <%-- Inline Alerts (Pure Scriptlets, No JSTL / EL) --%>
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
                    String success = (String) request.getAttribute("successMessage");
                    if (success != null && !success.isEmpty()) {
                %>
                    <div class="cq-alert alert-success">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span><%= success %></span>
                    </div>
                <%
                    }
                    String logoutParam = request.getParameter("logout");
                    if ("success".equals(logoutParam)) {
                %>
                    <div class="cq-alert alert-info">
                        <span>You have been safely signed out. Session invalidated.</span>
                    </div>
                <%
                    }
                    String savedUser = (String) request.getAttribute("savedUsername");
                    String enteredIdent = (String) request.getAttribute("enteredIdentifier");
                    String defaultVal = (enteredIdent != null && !enteredIdent.isEmpty()) ? enteredIdent : (savedUser != null ? savedUser : "");
                %>

                <form action="<%= request.getContextPath() %>/login" method="POST">
                    <div class="cq-form-group">
                        <label class="cq-form-label" for="identifier">Username or Email</label>
                        <input type="text" id="identifier" name="identifier" class="cq-input" 
                               value="<%= defaultVal %>" placeholder="Enter your username or email" required autocomplete="username">
                    </div>

                    <div class="cq-form-group">
                        <label class="cq-form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="cq-input" 
                               placeholder="Enter account password" required autocomplete="current-password">
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin: 1.25rem 0;">
                        <label class="cq-checkbox-label">
                            <input type="checkbox" name="rememberMe" class="cq-checkbox" <%= (savedUser != null && !savedUser.isEmpty()) ? "checked" : "" %>>
                            <span>Remember my handle (Cookie)</span>
                        </label>
                    </div>

                    <div style="margin-top: 1.75rem;">
                        <button type="submit" class="cq-nav-btn btn-primary" style="width: 100%; justify-content: center; padding: 0.95rem; font-size: 1.02rem;">
                            Sign In to Portal &rarr;
                        </button>
                    </div>
                </form>

                <!-- Fast Demo Account Selector -->
                <div style="margin-top: 2rem; padding: 1.25rem; background: var(--lavender-50); border-radius: 18px; border: 1px dashed var(--lavender-300); text-align: center;">
                    <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--lavender-800); font-weight: 800; letter-spacing: 0.5px;">Evaluation Accounts (Click to Autofill)</span>
                    <div style="display: flex; gap: 0.6rem; justify-content: center; margin-top: 0.75rem; flex-wrap: wrap;">
                        <button type="button" class="filter-chip" onclick="fillCreds('NeoMatrix', 'pass123')" style="font-size: 0.82rem; padding: 0.4rem 1rem;">
                            NeoMatrix (Lv. 5)
                        </button>
                        <button type="button" class="filter-chip" onclick="fillCreds('ByteWizard', 'pass123')" style="font-size: 0.82rem; padding: 0.4rem 1rem;">
                            ByteWizard (Lv. 3)
                        </button>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 1.75rem; font-size: 0.92rem; color: var(--text-secondary);">
                    New student? 
                    <a href="<%= request.getContextPath() %>/register" style="color: var(--lavender-700); text-decoration: none; font-weight: 700;">Create an account &rarr;</a>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>

    <script>
        function fillCreds(u, p) {
            document.getElementById('identifier').value = u;
            document.getElementById('password').value = p;
        }
    </script>
</body>
</html>
