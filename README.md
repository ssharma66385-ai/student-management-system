# KIET Deemed to be University
## Spring Boot Coding Assessment – MSE 2
### Subject: OOPJ (CS336B)
**Assessment:** Student Academic Management REST API  
**Developer:** Shubham Sharma  
**Roll Number:** 202501100300249
**Branch:** CSE(AI)  
**Email:** shubham.25003249@kiet.edu  
**Repository:** https://github.com/ssharma66385-ai/student-management-system  

---

## 📌 Project Overview
This project implements the **Student Academic Management REST API** using **Java 21** and **Spring Boot 4.1.2** for KIET Deemed to be University. It provides centralized RESTful endpoints to manage student academic records using an in-memory `CopyOnWriteArrayList<Student>` without requiring an external database.

### Core Features:
- Standard Maven & Spring Boot project structure
- Application configured to run on port `8080`
- `CommandLineRunner` and SLF4J Logger displaying startup initialization messages
- In-memory data store preloaded with 5 student records
- Full CRUD REST API support (`GET`, `POST`, `PUT`, `DELETE`)
- Path variables (`@PathVariable`) for ID-based retrieval, update, and deletion
- Request parameters (`@RequestParam`) for search by branch & academic year, and finding students by minimum CGPA
- Proper HTTP response codes (`200 OK`, `201 Created`, `404 Not Found`) and error messages

---

## 🏗️ Project Structure
```
student-management-system/
├── pom.xml
├── mvnw
├── mvnw.cmd
├── .gitignore
├── README.md
├── run_tests.ps1
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── kiet/
│   │   │           └── student/
│   │   │               ├── StudentApplication.java          # Spring Boot Main & CommandLineRunner
│   │   │               ├── controller/
│   │   │               │   └── StudentController.java       # REST Controller with all endpoints
│   │   │               └── model/
│   │   │                   └── Student.java                 # Student POJO Entity
│   │   └── resources/
│   │       └── application.properties                       # Server configuration (port 8080)
│   └── test/
│       └── java/
│           └── com/
│               └── kiet/
│                   └── student/
│                       └── StudentApplicationTests.java     # Integration Tests
```

---

## ⚙️ Configuration (`src/main/resources/application.properties`)
```properties
server.port=8080
spring.application.name=student-management-system
```

---

## 🚀 Running the Application
To run the application locally:
```bash
./mvnw clean spring-boot:run
```
Upon startup, the following log output is produced by the `CommandLineRunner`:
```
KIET Student Management System Started
Loading Student Data...
Student Management REST API is Ready
```

---

## 📋 REST API Endpoints Specification

| HTTP Method | Endpoint | Description | Annotations Used |
| :--- | :--- | :--- | :--- |
| **GET** | `/students` | Retrieve all student records | `@GetMapping` |
| **GET** | `/students/{studentId}` | Retrieve a student by ID | `@GetMapping`, `@PathVariable` |
| **POST** | `/students` | Add a new student record | `@PostMapping`, `@RequestBody` |
| **PUT** | `/students/{studentId}` | Update an existing student | `@PutMapping`, `@PathVariable`, `@RequestBody` |
| **DELETE** | `/students/{studentId}` | Delete a student by ID | `@DeleteMapping`, `@PathVariable` |
| **GET** | `/students/search?branch=CSE&year=2` | Search students by branch & year | `@GetMapping`, `@RequestParam` |
| **GET** | `/students/topper?cgpa=9.0` | Find students with CGPA >= threshold | `@GetMapping`, `@RequestParam` |

---

## 🧪 API Request & Response Samples

### 1. Get All Students
- **Request:** `GET http://localhost:8080/students`
- **Status:** `200 OK`
- **Response:**
```json
[
  {
    "studentId": 101,
    "name": "Rahul Sharma",
    "email": "rahul@kiet.edu",
    "branch": "CSE(AI & ML)",
    "year": 2,
    "cgpa": 8.65
  },
  {
    "studentId": 102,
    "name": "Priya Singh",
    "email": "priya@kiet.edu",
    "branch": "CSE",
    "year": 2,
    "cgpa": 9.2
  },
  {
    "studentId": 103,
    "name": "Aman Verma",
    "email": "aman@kiet.edu",
    "branch": "IT",
    "year": 3,
    "cgpa": 8.4
  },
  {
    "studentId": 104,
    "name": "Sneha Patel",
    "email": "sneha@kiet.edu",
    "branch": "CSE",
    "year": 2,
    "cgpa": 9.15
  },
  {
    "studentId": 105,
    "name": "Vikram Malhotra",
    "email": "vikram@kiet.edu",
    "branch": "ECE",
    "year": 4,
    "cgpa": 7.9
  }
]
```

---

### 2. Get Student by ID (Found)
- **Request:** `GET http://localhost:8080/students/101`
- **Status:** `200 OK`
- **Response:**
```json
{
  "studentId": 101,
  "name": "Rahul Sharma",
  "email": "rahul@kiet.edu",
  "branch": "CSE(AI & ML)",
  "year": 2,
  "cgpa": 8.65
}
```

### 3. Get Student by ID (Not Found)
- **Request:** `GET http://localhost:8080/students/999`
- **Status:** `404 Not Found`
- **Response:**
```json
{
  "message": "Student not found"
}
```

---

### 4. Add New Student
- **Request:** `POST http://localhost:8080/students`
- **Headers:** `Content-Type: application/json`
- **Body:**
```json
{
  "studentId": 106,
  "name": "Amit Kumar",
  "email": "amit@kiet.edu",
  "branch": "CSE(AI)",
  "year": 2,
  "cgpa": 8.75
}
```
- **Status:** `201 Created`
- **Response:**
```json
{
  "studentId": 106,
  "name": "Amit Kumar",
  "email": "amit@kiet.edu",
  "branch": "CSE(AI)",
  "year": 2,
  "cgpa": 8.75
}
```

---

### 5. Update Existing Student
- **Request:** `PUT http://localhost:8080/students/101`
- **Headers:** `Content-Type: application/json`
- **Body:**
```json
{
  "studentId": 101,
  "name": "Rahul Sharma",
  "email": "rahul@kiet.edu",
  "branch": "CSE(AI & ML)",
  "year": 3,
  "cgpa": 9.05
}
```
- **Status:** `200 OK`
- **Response:**
```json
{
  "studentId": 101,
  "name": "Rahul Sharma",
  "email": "rahul@kiet.edu",
  "branch": "CSE(AI & ML)",
  "year": 3,
  "cgpa": 9.05
}
```

---

### 6. Delete Student (Found)
- **Request:** `DELETE http://localhost:8080/students/105`
- **Status:** `200 OK`
- **Response:**
```json
{
  "message": "Student deleted successfully"
}
```

### 7. Delete Student (Not Found)
- **Request:** `DELETE http://localhost:8080/students/999`
- **Status:** `404 Not Found`
- **Response:**
```json
{
  "message": "Student not found"
}
```

---

### 8. Search by Branch and Year
- **Request:** `GET http://localhost:8080/students/search?branch=CSE&year=2`
- **Status:** `200 OK`
- **Response:**
```json
[
  {
    "studentId": 102,
    "name": "Priya Singh",
    "email": "priya@kiet.edu",
    "branch": "CSE",
    "year": 2,
    "cgpa": 9.2
  },
  {
    "studentId": 104,
    "name": "Sneha Patel",
    "email": "sneha@kiet.edu",
    "branch": "CSE",
    "year": 2,
    "cgpa": 9.15
  }
]
```

---

### 9. Find Students Based on CGPA (Toppers)
- **Request:** `GET http://localhost:8080/students/topper?cgpa=9.0`
- **Status:** `200 OK`
- **Response:**
```json
[
  {
    "studentId": 101,
    "name": "Rahul Sharma",
    "email": "rahul@kiet.edu",
    "branch": "CSE(AI & ML)",
    "year": 3,
    "cgpa": 9.05
  },
  {
    "studentId": 102,
    "name": "Priya Singh",
    "email": "priya@kiet.edu",
    "branch": "CSE",
    "year": 2,
    "cgpa": 9.2
  },
  {
    "studentId": 104,
    "name": "Sneha Patel",
    "email": "sneha@kiet.edu",
    "branch": "CSE",
    "year": 2,
    "cgpa": 9.15
  }
]
```

---

## 🤖 3 AI Prompts Used for Creating the Project

### **Prompt 1 (Project Architecture & Setup):**
> "Generate a Spring Boot 3/4 Maven project for 'KIET Deemed to be University' titled 'Student Academic Management REST API'. The project must follow the package structure `com.kiet.student` containing `StudentApplication.java`, `model/Student.java`, and `controller/StudentController.java`. The `Student` model must include fields: `studentId` (int), `name` (String), `email` (String), `branch` (String), `year` (int), and `cgpa` (double) with constructors, getters, and setters. Configure `server.port=8080` in `application.properties` and implement `CommandLineRunner` in the main class using SLF4J `Logger` to display:
> 'KIET Student Management System Started'
> 'Loading Student Data...'
> 'Student Management REST API is Ready'."

### **Prompt 2 (REST Controller & In-Memory CRUD Implementation):**
> "In `StudentController.java`, create an in-memory thread-safe `List<Student>` initialized with 5 sample students. Implement CRUD REST API endpoints:
> 1. `GET /students` to retrieve all students.
> 2. `GET /students/{studentId}` using `@PathVariable`, returning the student or a 404 response `{\"message\": \"Student not found\"}`.
> 3. `POST /students` using `@RequestBody` to add a student and return the newly created student with HTTP status 201.
> 4. `PUT /students/{studentId}` using `@PathVariable` and `@RequestBody` to update the student's name, email, branch, year, and cgpa, or return 404 if not found.
> 5. `DELETE /students/{studentId}` using `@PathVariable` to delete the student, returning `{\"message\": \"Student deleted successfully\"}` on success or 404 with `{\"message\": \"Student not found\"}` if absent."

### **Prompt 3 (Search, Filtering & RequestParam Handling):**
> "Add specialized search and filter endpoints to `StudentController.java` using `@RequestParam`:
> 1. `GET /students/search?branch={branch}&year={year}` to filter and return all students matching the given branch and academic year using Java Streams.
> 2. `GET /students/topper?cgpa={cgpa}` to filter and return all students whose CGPA is greater than or equal to the supplied CGPA threshold.
> Ensure that endpoint URL mappings do not collide with `/{studentId}` path variable routes and return proper JSON response lists."
