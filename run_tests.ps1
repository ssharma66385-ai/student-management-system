$baseUrl = "http://localhost:8080"
$output = @()

function Log-Section($title) {
    Write-Host "`n========================================================"
    Write-Host $title
    Write-Host "========================================================"
}

Log-Section "QUESTION 3.A - GET ALL STUDENTS (GET /students)"
$res1 = Invoke-RestMethod -Uri "$baseUrl/students" -Method Get
Write-Host "HTTP Status: 200 OK"
Write-Host "Response Body:"
$json1 = $res1 | ConvertTo-Json -Depth 5
Write-Host $json1

Log-Section "QUESTION 3.B - GET STUDENT BY ID (GET /students/101)"
$res2 = Invoke-RestMethod -Uri "$baseUrl/students/101" -Method Get
Write-Host "HTTP Status: 200 OK"
Write-Host "Response Body:"
$json2 = $res2 | ConvertTo-Json -Depth 5
Write-Host $json2

Log-Section "QUESTION 3.B - GET STUDENT BY ID (NOT FOUND) (GET /students/999)"
try {
    $res3 = Invoke-RestMethod -Uri "$baseUrl/students/999" -Method Get
} catch {
    Write-Host "HTTP Status: $($_.Exception.Response.StatusCode.value__) Not Found"
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $body = $reader.ReadToEnd()
    Write-Host "Response Body: $body"
}

Log-Section "QUESTION 4 - POST ADD NEW STUDENT (POST /students)"
$newStudent = @{
    studentId = 106
    name = "Amit Kumar"
    email = "amit@kiet.edu"
    branch = "CSE(AI)"
    year = 2
    cgpa = 8.75
}
$postPayload = $newStudent | ConvertTo-Json
Write-Host "Request Body:`n$postPayload"
$res4 = Invoke-RestMethod -Uri "$baseUrl/students" -Method Post -Body $postPayload -ContentType "application/json"
Write-Host "HTTP Status: 201 Created"
Write-Host "Response Body:"
$json4 = $res4 | ConvertTo-Json -Depth 5
Write-Host $json4

Log-Section "QUESTION 5.A - PUT UPDATE STUDENT (PUT /students/101)"
$updateStudent = @{
    studentId = 101
    name = "Rahul Sharma"
    email = "rahul@kiet.edu"
    branch = "CSE(AI & ML)"
    year = 3
    cgpa = 9.05
}
$putPayload = $updateStudent | ConvertTo-Json
Write-Host "Request Body:`n$putPayload"
$res5 = Invoke-RestMethod -Uri "$baseUrl/students/101" -Method Put -Body $putPayload -ContentType "application/json"
Write-Host "HTTP Status: 200 OK"
Write-Host "Response Body:"
$json5 = $res5 | ConvertTo-Json -Depth 5
Write-Host $json5

Log-Section "QUESTION 5.B - DELETE STUDENT (DELETE /students/105)"
$res6 = Invoke-RestMethod -Uri "$baseUrl/students/105" -Method Delete
Write-Host "HTTP Status: 200 OK"
Write-Host "Response Body:"
$json6 = $res6 | ConvertTo-Json -Depth 5
Write-Host $json6

Log-Section "QUESTION 5.B - DELETE STUDENT (NOT FOUND) (DELETE /students/999)"
try {
    $res7 = Invoke-RestMethod -Uri "$baseUrl/students/999" -Method Delete
} catch {
    Write-Host "HTTP Status: $($_.Exception.Response.StatusCode.value__) Not Found"
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $body = $reader.ReadToEnd()
    Write-Host "Response Body: $body"
}

Log-Section "QUESTION 6.A - SEARCH BY BRANCH AND YEAR (GET /students/search?branch=CSE&year=2)"
$res8 = Invoke-RestMethod -Uri "$baseUrl/students/search?branch=CSE&year=2" -Method Get
Write-Host "HTTP Status: 200 OK"
Write-Host "Response Body:"
$json8 = $res8 | ConvertTo-Json -Depth 5
Write-Host $json8

Log-Section "QUESTION 6.B - FIND TOPPERS BASED ON CGPA (GET /students/topper?cgpa=9.0)"
$res9 = Invoke-RestMethod -Uri "$baseUrl/students/topper?cgpa=9.0" -Method Get
Write-Host "HTTP Status: 200 OK"
Write-Host "Response Body:"
$json9 = $res9 | ConvertTo-Json -Depth 5
Write-Host $json9
