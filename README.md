# 🎮 CodeQuest — Programming Learning Game

An enterprise-grade, gamified web learning platform developed for university programming assessment.
Built strictly with **JSP, Servlets, JDBC, HTML, and CSS without JSTL or JSP Expression Language**, running on **Apache Tomcat 10.1** and **MySQL 8.0**.

---

## ⚡ Unique & Standout Features

1. **Cyber-Gaming Glassmorphism UI**
   - Immersive dark aesthetic with dynamic neon cyan and purple glows.
   - Interactive sound effect synthesizer built with the native browser **Web Audio API** (100% offline, zero lag, with an in-navbar audio toggle).
   - Real-time particle confetti celebrations on solving missions and leveling up.
2. **Interactive Progression Engine**
   - Dynamic Level calculation: $\text{Player Level} = 1 + \left\lfloor \frac{\text{Total XP}}{100} \right\rfloor$.
   - Live XP progress bar calculating remaining XP to the next prestige rank.
   - Prestige Titles: *Novice Coder*, *Byte Runner*, *Syntax Sorcerer*, *Algorithm Knight*, *Cyber Overlord*.
3. **Competitive Hall of Fame (Leaderboard)**
   - Top 3 3D-style podiums (Gold Champion #1 with crown, Silver #2, Bronze #3).
   - Real-time ranking based on total XP, level, and solved counts.
4. **Strict Transaction Safety & Integrity**
   - JDBC transactions (`setAutoCommit(false)`, `commit()`, `rollback()`) guarantee atomic answer submission and student stat updates.
   - Anti-cheat **One-Attempt-Per-Mission Rule** enforced at both servlet and database levels.
5. **Full Module Compliance (1 to 12)**
   - 100% pure scriptlets (`<% ... %>` and `<%= ... %>`), no JSTL, no Expression Language.
   - Role separation between Student and Admin sessions.
   - Full demonstration of `ServletConfig`, `ServletContext`, HTTP Sessions, and Cookies.

---

## 📂 Project Architecture

```
CodeQuest/
├── pom.xml                                   # Maven configuration (Jakarta Servlet 6.0, MySQL Connector)
├── .project / .classpath                     # Eclipse IDE project descriptors
├── database/
│   └── codequest_db.sql                      # Complete MySQL schema & initial seed data
├── src/main/java/com/codequest/
│   ├── config/
│   │   └── DBConnection.java                 # Centralized JDBC connection manager
│   ├── models/
│   │   ├── User.java                         # Student profile & level calculation
│   │   ├── Admin.java                        # Administrator entity
│   │   ├── Mission.java                      # Question model (Java, SQL, DSA)
│   │   ├── Submission.java                   # Answer attempt model
│   │   └── LeaderboardEntry.java             # Ranked leaderboard entry
│   ├── dao/
│   │   ├── UserDAO.java                      # User auth, registration & stats
│   │   ├── AdminDAO.java                     # Admin authentication
│   │   ├── MissionDAO.java                   # Question querying & insertion
│   │   └── SubmissionDAO.java                # Transactional submission & leaderboard
│   └── servlets/
│       ├── RegisterServlet.java              # Student registration (/register)
│       ├── LoginServlet.java                 # Student login & cookies (/login)
│       ├── LogoutServlet.java                # Session invalidation (/logout)
│       ├── DashboardServlet.java             # Personalized HUD stats (/dashboard)
│       ├── MissionServlet.java               # Question retrieval & filters (/missions)
│       ├── SubmitAnswerServlet.java          # Transactional evaluation (/submit-answer)
│       ├── LeaderboardServlet.java           # Hall of fame ranking (/leaderboard)
│       ├── AdminLoginServlet.java            # Admin terminal login (/admin-login)
│       ├── AdminLogoutServlet.java           # Admin session logout (/admin-logout)
│       ├── AddQuestionServlet.java           # Question creation (/admin/add-question)
│       └── ViewQuestionsServlet.java         # Question catalog (/admin/view-questions)
└── src/main/webapp/
    ├── css/style.css                         # Dark gaming design system
    ├── js/
    │   ├── audio-fx.js                       # Native Web Audio API sound FX
    │   └── confetti.js                       # HTML5 canvas confetti celebration
    ├── includes/
    │   ├── navbar.jsp                        # Dynamic header with session detection & sound toggle
    │   └── footer.jsp                        # Footer with script includes
    ├── index.html                            # Landing page (Module 1)
    ├── register.jsp                          # Student registration form (Module 2)
    ├── login.jsp                             # Student login form (Module 3)
    ├── admin-login.jsp                       # Administrator login (Module 4)
    ├── admin-dashboard.jsp                   # Administrator control console (Module 4)
    ├── add-question.jsp                      # Question creator form (Module 6)
    ├── view-questions.jsp                    # Question management table (Module 7)
    ├── dashboard.jsp                         # Student personal HUD dashboard (Module 8)
    ├── missions.jsp                          # Categorized quest catalog (Module 9)
    ├── mission-result.jsp                    # Instant feedback & Level-Up alert (Module 10)
    ├── leaderboard.jsp                       # Top 3 podium & rankings (Module 11)
    └── WEB-INF/
        ├── web.xml                           # Servlet mappings, context-param, init-param
        └── lib/
            └── mysql-connector-j-8.3.0.jar   # Embedded MySQL JDBC driver
```

---

## 🗄️ Database Setup (`codequest_db`)

The database is already configured on your local MySQL 8.0 instance:
* **Database Name:** `codequest_db`
* **Username:** `root`
* **Password:** `Shameershaik55@`

If you ever need to reset or reseed the database, simply run in Command Prompt:
```cmd
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pShameershaik55@ < c:\Users\shame\Downloads\Java\database\codequest_db.sql
```

---

## 🚀 How to Run in Eclipse IDE

1. **Open Eclipse IDE**.
2. Go to **File ➔ Import... ➔ Maven ➔ Existing Maven Projects** (or **General ➔ Existing Projects into Workspace**).
3. Browse and select the directory: `C:\Users\shame\Downloads\Java`.
4. Click **Finish**. Eclipse will detect all classes and the web configuration.
5. In the **Servers** tab:
   * Right-click your **Tomcat v10.1 Server at localhost** ➔ **Add and Remove...**
   * Add **CodeQuest** to the Configured column ➔ Click **Finish**.
6. Right-click the server ➔ **Start** (or select the project ➔ **Run As ➔ Run on Server**).
7. Open your browser and navigate to:
   ```
   http://localhost:8080/CodeQuest/
   ```

---

## 🔑 Pre-Seeded Accounts for Instant Grading

| Role | Username | Password | Notes |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Full access to add and manage curriculum questions |
| **Student #1** | `NeoMatrix` | `pass123` | Level 5 (450 XP) &mdash; #1 on Leaderboard |
| **Student #2** | `CyberNinja` | `pass123` | Level 4 (300 XP) &mdash; #2 on Leaderboard |
| **Student #3** | `ByteWizard` | `pass123` | Level 3 (200 XP) &mdash; #3 on Leaderboard |
| **Student #4** | *New Student* | *Custom* | Starts at Level 1 with 0 XP upon registration |

