# Electricity Bill System
Java Web Application — JSP + Servlet + SQLite + Tomcat 9 + Eclipse

## Features (User Stories Implemented)
| ID     | Feature                  | Description                                      |
|--------|--------------------------|--------------------------------------------------|
| US001  | Customer Registration    | Register with name/email/mobile/password         |
| US002  | Admin Registration       | Admin-only: register new admins                  |
| US003  | User Login               | Login → redirect to dashboard by role            |
| US004  | View Bills               | Fetch all bills from bill table                  |
| US005  | Pay Bill                 | One-click payment, prevents duplicate payment    |
| US006  | Bill History             | View all paid bills                              |
| US007  | Register Complaint       | Submit complaints stored in Complaint table      |
| US008  | Search Complaint         | Search by complaint ID                           |
| US009  | Complaint History        | View all past complaints                         |
| US010  | Update Customer Details  | Edit name/mobile/address                         |
| US011  | Soft Delete Account      | Sets status = Inactive (not hard delete)         |

---

## Prerequisites
- Java JDK 11+
- Apache Tomcat 9.x
- Eclipse IDE for Enterprise Java (Eclipse EE) 2021+
- SQLite JDBC driver (already included)

---

## Setup in Eclipse

### Step 1 — Import the Project
1. Open Eclipse → `File` → `Import`
2. Choose `General` → `Existing Projects into Workspace`
3. Browse to this folder and click **Finish**

### Step 2 — Add the SQLite JDBC JAR
The JAR file `sqlite-jdbc-3.45.1.0.jar` needs to be placed in:
```
WebContent/WEB-INF/lib/
```
Download it from:
```
https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.45.1.0/sqlite-jdbc-3.45.1.0.jar
```
Then right-click project → `Build Path` → `Configure Build Path` → `Libraries` tab
→ `Add JARs` → select the jar from `WebContent/WEB-INF/lib/`

### Step 3 — Configure Tomcat in Eclipse
1. `Window` → `Preferences` → `Server` → `Runtime Environments`
2. Click `Add` → select `Apache Tomcat v9.0`
3. Point it to your Tomcat 9 installation directory
4. Click `Finish`

### Step 4 — Add Project to Tomcat
1. In the `Servers` view (bottom panel), right-click your Tomcat server
2. Select `Add and Remove...`
3. Move `ElectricityBillSystem` to the right (Configured) side
4. Click `Finish`

### Step 5 — Run the Application
1. Right-click the project → `Run As` → `Run on Server`
2. Select your Tomcat 9 server → `Finish`
3. Browser opens at: `http://localhost:8080/ElectricityBillSystem/`

---

## Default Login Credentials
| Role     | Email           | Password   |
|----------|-----------------|------------|
| Admin    | admin@ebs.com   | admin123   |
| Customer | (register new)  | (your own) |

---

## Database
- SQLite file: `electricity_bill.db` (auto-created in the directory where Tomcat runs)
- No setup needed — tables are created automatically on first startup
- Tables: `Login`, `Customer`, `Bill`, `Payment`, `Complaint`

---

## Project Structure
```
ElectricityBillSystem/
├── src/
│   └── com/ebs/
│       ├── dao/          # Data Access Objects (DB queries)
│       ├── model/        # Java Beans (Customer, Bill, Complaint, Login)
│       ├── servlet/      # HttpServlet classes (one per user story)
│       └── util/         # DBConnection + schema initializer
├── WebContent/
│   ├── WEB-INF/
│   │   ├── web.xml       # Servlet mappings
│   │   └── lib/          # sqlite-jdbc-3.45.1.0.jar goes here
│   ├── css/style.css
│   ├── index.jsp         # Redirects to login
│   └── jsp/
│       ├── login.jsp
│       ├── register.jsp
│       ├── customer/     # All customer-facing JSPs
│       └── admin/        # All admin-facing JSPs
├── .project              # Eclipse project file
└── .classpath            # Eclipse classpath file
```

---

## Test Cases Coverage
Each servlet validates both positive and negative test cases:
- **Positive**: Valid data → success response + DB update
- **Negative**: Empty fields → validation error | Duplicate email → error | DB failure → exception handled | Inactive account → login denied | Duplicate payment → prevented
