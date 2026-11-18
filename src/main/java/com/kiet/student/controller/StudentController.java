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
     * Placed before /{studentId} mapping so spring does not mistake /search for an ID
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
     * Returns students whose CGPA is greater than or equal to the supplied CGPA.
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
