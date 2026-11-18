# OOPJ (CS336B)
# Moodle MSE 2 Submission Format

---

### **Student Information**
- **Name:** Shubham Sharma
- **Branch:** CSE(AI & ML)
- **Roll Number:** 25003249
- **Section:** A
- **Shift:** I
- **Case Study Name:** Student Academic Management REST API (Spring Boot In-Memory)

---

### **GitHub Repository Link**
🔗 **Repository URL:**  
`https://github.com/ssharma66385-ai/student-management-system`

---

## 1. Project Code

### A. Model Class: `Student.java`
**File Path:** `src/main/java/com/kiet/student/model/Student.java`
```java
package com.kiet.student.model;

/**
 * Model class representing a Student entity for KIET Deemed to be University.
 */
public class Student {

    private int studentId;
    private String name;
    private String email;
    private String branch;
    private int year;
    private double cgpa;

    // Default constructor
    public Student() {
    }

    // Parameterized constructor
    public Student(int studentId, String name, String email, String branch, int year, double cgpa) {
        this.studentId = studentId;
        this.name = name;
        this.email = email;
        this.branch = branch;
        this.year = year;
        this.cgpa = cgpa;
    }

    // Getters and Setters
    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public double getCgpa() {
        return cgpa;
    }

    public void setCgpa(double cgpa) {
        this.cgpa = cgpa;
    }

    @Override
    public String toString() {
        return "Student{" +
                "studentId=" + studentId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", branch='" + branch + '\'' +
                ", year=" + year +
                ", cgpa=" + cgpa +
                '}';
    }
}
```

---

### B. Controller Class: `StudentController.java`
**File Path:** `src/main/java/com/kiet/student/controller/StudentController.java`
```java
package com.kiet.student.controller;

import com.kiet.student.model.Student;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * REST Controller for Student Academic Management at KIET Deemed to be University.
 */
@RestController
@RequestMapping("/students")
public class StudentController {

    // Thread-safe in-memory list containing student records
    private final List<Student> studentList = new CopyOnWriteArrayList<>();

    public StudentController() {
        // Initializing in-memory list with at least 5 student records
        studentList.add(new Student(101, "Rahul Sharma", "rahul@kiet.edu", "CSE(AI & ML)", 2, 8.65));
        studentList.add(new Student(102, "Priya Singh", "priya@kiet.edu", "CSE", 2, 9.20));
        studentList.add(new Student(103, "Aman Verma", "aman@kiet.edu", "IT", 3, 8.40));
        studentList.add(new Student(104, "Sneha Patel", "sneha@kiet.edu", "CSE", 2, 9.15));
        studentList.add(new Student(105, "Vikram Malhotra", "vikram@kiet.edu", "ECE", 4, 7.90));
    }

    /**
     * Question 3.A - Get All Students
     * GET /students
     */
    @GetMapping
    public ResponseEntity<List<Student>> getAllStudents() {
        return ResponseEntity.ok(studentList);
    }

    /**
     * Question 6.A - Search by Branch and Year
     * GET /students/search?branch=CSE&year=2
     */
    @GetMapping("/search")
    public ResponseEntity<List<Student>> searchByBranchAndYear(
            @RequestParam String branch,
            @RequestParam int year) {
        List<Student> filtered = studentList.stream()
                .filter(s -> s.getBranch().equalsIgnoreCase(branch) && s.getYear() == year)
                .collect(Collectors.toList());
        return ResponseEntity.ok(filtered);
    }

    /**
     * Question 6.B - Find Students Based on CGPA (Toppers)
     * GET /students/topper?cgpa=9.0
     */
    @GetMapping("/topper")
    public ResponseEntity<List<Student>> getTopperStudents(@RequestParam double cgpa) {
        List<Student> toppers = studentList.stream()
                .filter(s -> s.getCgpa() >= cgpa)
                .collect(Collectors.toList());
        return ResponseEntity.ok(toppers);
    }

    /**
     * Question 3.B - Get Student by ID
     * GET /students/{studentId}
     */
    @GetMapping("/{studentId}")
    public ResponseEntity<?> getStudentById(@PathVariable int studentId) {
        Optional<Student> studentOpt = studentList.stream()
                .filter(s -> s.getStudentId() == studentId)
                .findFirst();

        if (studentOpt.isPresent()) {
            return ResponseEntity.ok(studentOpt.get());
        } else {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", "Student not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    /**
     * Question 4 - Add New Student
     * POST /students
     */
    @PostMapping
    public ResponseEntity<Student> addStudent(@RequestBody Student student) {
        studentList.add(student);
        return ResponseEntity.status(HttpStatus.CREATED).body(student);
    }

    /**
     * Question 5.A - Update Existing Student
     * PUT /students/{studentId}
     */
    @PutMapping("/{studentId}")
    public ResponseEntity<?> updateStudent(
            @PathVariable int studentId,
            @RequestBody Student updatedData) {

        for (Student student : studentList) {
            if (student.getStudentId() == studentId) {
                student.setName(updatedData.getName());
                student.setEmail(updatedData.getEmail());
                student.setBranch(updatedData.getBranch());
                student.setYear(updatedData.getYear());
                student.setCgpa(updatedData.getCgpa());
                return ResponseEntity.ok(student);
            }
        }

        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put("message", "Student not found");
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
    }

    /**
     * Question 5.B - Delete Student
     * DELETE /students/{studentId}
     */
    @DeleteMapping("/{studentId}")
    public ResponseEntity<?> deleteStudent(@PathVariable int studentId) {
        boolean removed = studentList.removeIf(s -> s.getStudentId() == studentId);

        Map<String, String> response = new HashMap<>();
        if (removed) {
            response.put("message", "Student deleted successfully");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "Student not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }
}
```

---

### C. Main Class & CommandLineRunner: `StudentApplication.java`
**File Path:** `src/main/java/com/kiet/student/StudentApplication.java`
```java
package com.kiet.student;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Application Class for KIET Student Academic Management REST API.
 */
@SpringBootApplication
public class StudentApplication implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(StudentApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(StudentApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        logger.info("KIET Student Management System Started");
        logger.info("Loading Student Data...");
        logger.info("Student Management REST API is Ready");
    }
}
```

---

### D. Configuration: `application.properties`
**File Path:** `src/main/resources/application.properties`
```properties
server.port=8080
spring.application.name=student-management-system
```

---

### E. Maven Build File: `pom.xml`
**File Path:** `pom.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>4.1.2</version>
		<relativePath/>
	</parent>
	<groupId>com.kiet</groupId>
	<artifactId>student-management-system</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>student-management-system</name>
	<description>Student Academic Management REST API - KIET Deemed to be University</description>
	<properties>
		<java.version>21</java.version>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-webmvc</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-webmvc-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>
</project>
```

---

## 2. Startup & Runner Logger Output
```text
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v4.1.2)

2026-11-18T22:12:46.914+05:30  INFO 7144 --- [student-management-system] [main] o.s.boot.tomcat.TomcatWebServer    : Tomcat started on port 8080 (http) with context path '/'
2026-11-18T22:12:46.920+05:30  INFO 7144 --- [student-management-system] [main] com.kiet.student.StudentApplication: Started StudentApplication in 1.059 seconds
2026-11-18T22:12:46.922+05:30  INFO 7144 --- [student-management-system] [main] com.kiet.student.StudentApplication: KIET Student Management System Started
2026-11-18T22:12:46.922+05:30  INFO 7144 --- [student-management-system] [main] com.kiet.student.StudentApplication: Loading Student Data...
2026-11-18T22:12:46.922+05:30  INFO 7144 --- [student-management-system] [main] com.kiet.student.StudentApplication: Student Management REST API is Ready
```

---

## 3. Postman / REST API Execution Testing & JSON Request/Response

### Endpoint 1: Get All Students
- **Method:** `GET`
- **URL:** `http://localhost:8080/students`
- **Status:** `200 OK`
- **Response JSON:**
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

### Endpoint 2: Get Student by ID (Existing Student)
- **Method:** `GET`
- **URL:** `http://localhost:8080/students/101`
- **Status:** `200 OK`
- **Response JSON:**
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

---

### Endpoint 3: Get Student by ID (Non-Existing Student)
- **Method:** `GET`
- **URL:** `http://localhost:8080/students/999`
- **Status:** `404 Not Found`
- **Response JSON:**
```json
{
  "message": "Student not found"
}
```

---

### Endpoint 4: Add New Student
- **Method:** `POST`
- **URL:** `http://localhost:8080/students`
- **Header:** `Content-Type: application/json`
- **Request Body JSON:**
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
- **Response JSON:**
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

### Endpoint 5: Update Student Record
- **Method:** `PUT`
- **URL:** `http://localhost:8080/students/101`
- **Header:** `Content-Type: application/json`
- **Request Body JSON:**
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
- **Response JSON:**
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

### Endpoint 6: Delete Student Record (Success)
- **Method:** `DELETE`
- **URL:** `http://localhost:8080/students/105`
- **Status:** `200 OK`
- **Response JSON:**
```json
{
  "message": "Student deleted successfully"
}
```

---

### Endpoint 7: Delete Student Record (Not Found)
- **Method:** `DELETE`
- **URL:** `http://localhost:8080/students/999`
- **Status:** `404 Not Found`
- **Response JSON:**
```json
{
  "message": "Student not found"
}
```

---

### Endpoint 8: Search by Branch and Year
- **Method:** `GET`
- **URL:** `http://localhost:8080/students/search?branch=CSE&year=2`
- **Status:** `200 OK`
- **Response JSON:**
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

### Endpoint 9: Find Students Based on CGPA (Toppers)
- **Method:** `GET`
- **URL:** `http://localhost:8080/students/topper?cgpa=9.0`
- **Status:** `200 OK`
- **Response JSON:**
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

## 4. Screenshot of IntelliJ Project Structure

```text
student-management-system [C:\Users\lenovo\OneDrive\Desktop\student-management-system]
├── .mvn
│   └── wrapper
│       └── maven-wrapper.properties
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── kiet
│   │   │           └── student
│   │   │               ├── controller
│   │   │               │   └── StudentController.java
│   │   │               ├── model
│   │   │               │   └── Student.java
│   │   │               └── StudentApplication.java
│   │   └── resources
│   │       └── application.properties
│   └── test
│       └── java
│           └── com
│               └── kiet
│                   └── student
│                       └── StudentApplicationTests.java
├── .gitignore
├── mvnw
├── mvnw.cmd
├── pom.xml
├── README.md
└── run_tests.ps1
```

---

## 5. Three AI Prompts Used for Creating the Project

### **Prompt 1: Project Architecture, Model Entity & Runner Setup**
> "Generate a Spring Boot 3/4 Maven project for 'KIET Deemed to be University' titled 'Student Academic Management REST API'. The project must follow the package structure `com.kiet.student` containing `StudentApplication.java`, `model/Student.java`, and `controller/StudentController.java`. The `Student` model must include fields: `studentId` (int), `name` (String), `email` (String), `branch` (String), `year` (int), and `cgpa` (double) with constructors, getters, and setters. Configure `server.port=8080` in `application.properties` and implement `CommandLineRunner` in the main class using SLF4J `Logger` to display:
> 'KIET Student Management System Started'
> 'Loading Student Data...'
> 'Student Management REST API is Ready'."

### **Prompt 2: REST Controller & In-Memory CRUD Operations**
> "In `StudentController.java`, create an in-memory thread-safe `List<Student>` initialized with 5 sample students. Implement CRUD REST API endpoints:
> 1. `GET /students` to retrieve all students.
> 2. `GET /students/{studentId}` using `@PathVariable`, returning the student or a 404 response `{\"message\": \"Student not found\"}`.
> 3. `POST /students` using `@RequestBody` to add a student and return the newly created student with HTTP status 201.
> 4. `PUT /students/{studentId}` using `@PathVariable` and `@RequestBody` to update the student's name, email, branch, year, and cgpa, or return 404 if not found.
> 5. `DELETE /students/{studentId}` using `@PathVariable` to delete the student, returning `{\"message\": \"Student deleted successfully\"}` on success or 404 with `{\"message\": \"Student not found\"}` if absent."

### **Prompt 3: Filtering, RequestParam & Query Methods**
> "Add specialized search and filter endpoints to `StudentController.java` using `@RequestParam`:
> 1. `GET /students/search?branch={branch}&year={year}` to filter and return all students matching the given branch and academic year using Java Streams.
> 2. `GET /students/topper?cgpa={cgpa}` to filter and return all students whose CGPA is greater than or equal to the supplied CGPA threshold.
> Ensure that endpoint URL mappings do not collide with `/{studentId}` path variable routes and return proper JSON response lists."
