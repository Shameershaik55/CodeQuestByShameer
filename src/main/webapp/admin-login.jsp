<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Access &mdash; CodeQuest</title>
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
            <div class="cq-form-card" style="border-top: 5px solid var(--lavender-600);">
                <div class="cq-form-header">
                    <h2 class="cq-form-title">Administrator Terminal</h2>
                    
                    <%-- Demonstrating ServletContext & ServletConfig parameters --%>
                    <%
                        String appNameVal = (String) request.getAttribute("appName");
                        if (appNameVal == null) {
                            appNameVal = application.getInitParameter("appName");
                        }
                        String roleTitle = (String) request.getAttribute("adminRoleTitle");
                        if (roleTitle == null) roleTitle = "Command Center Administrator";
                    %>
                    <div style="font-size: 0.82rem; color: var(--lavender-700); font-weight: 800; text-transform: uppercase; margin-top: 6px; letter-spacing: 0.6px;">
                        <%= roleTitle %> &bull; <%= appNameVal != null ? appNameVal : "CodeQuest" %>
                    </div>
                </div>

                <%-- Inline Alerts --%>
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
                    String logoutMsg = request.getParameter("logout");
                    if ("success".equals(logoutMsg)) {
                %>
                    <div class="cq-alert alert-info">
                        <span>Administrator session terminated securely.</span>
                    </div>
                <%
                    }
                    String enteredUser = (String) request.getAttribute("enteredUsername");
                    if (enteredUser == null) enteredUser = "";
                %>

                <form action="<%= request.getContextPath() %>/admin-login" method="POST">
                    <div class="cq-form-group">
                        <label class="cq-form-label" for="username">Administrator Username</label>
                        <input type="text" id="username" name="username" class="cq-input" 
                               value="<%= enteredUser %>" placeholder="admin" required autocomplete="username">
                    </div>

                    <div class="cq-form-group">
                        <label class="cq-form-label" for="password">Security Password</label>
                        <input type="password" id="password" name="password" class="cq-input" 
                               placeholder="Admin password" required autocomplete="current-password">
                    </div>

                    <div style="margin-top: 2rem;">
                        <button type="submit" class="cq-nav-btn btn-primary" style="width: 100%; justify-content: center; padding: 0.95rem; font-size: 1.02rem;">
                            Authenticate Administrator &rarr;
                        </button>
                    </div>
                </form>

                <!-- Quick Fill Demo -->
                <div style="margin-top: 1.75rem; text-align: center; padding: 1.15rem; background: var(--lavender-50); border-radius: 16px; border: 1px dashed var(--lavender-300);">
                    <span style="font-size: 0.8rem; color: var(--text-muted); display: block; margin-bottom: 0.5rem; font-weight: 700;">Default Administrator Credentials:</span>
                    <button type="button" class="filter-chip" onclick="fillAdmin('admin', 'admin123')" style="font-size: 0.82rem; padding: 0.4rem 1rem;">
                        Autofill: admin / admin123
                    </button>
                </div>

                <div style="text-align: center; margin-top: 1.75rem; font-size: 0.92rem;">
                    <a href="<%= request.getContextPath() %>/login" style="color: var(--text-secondary); text-decoration: none; font-weight: 600;">&larr; Switch to Student Sign In</a>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>

    <script>
        function fillAdmin(u, p) {
            document.getElementById('username').value = u;
            document.getElementById('password').value = p;
        }
    </script>
</body>
</html>
