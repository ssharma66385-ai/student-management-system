Write-Host "=== TEST 1: GET /students ==="
$r1 = Invoke-WebRequest -Uri "http://localhost:8080/students" -Method Get
Write-Host "Status: $($r1.StatusCode)"
Write-Host "Response Body: $($r1.Content)"

Write-Host "`n=== TEST 2: GET /students/101 ==="
$r2 = Invoke-WebRequest -Uri "http://localhost:8080/students/101" -Method Get
Write-Host "Status: $($r2.StatusCode)"
Write-Host "Response Body: $($r2.Content)"

Write-Host "`n=== TEST 3: GET /students/999 (Not Found) ==="
try {
    $r3 = Invoke-WebRequest -Uri "http://localhost:8080/students/999" -Method Get
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host "Response Body: $($reader.ReadToEnd())"
}

Write-Host "`n=== TEST 4: POST /students ==="
$bodyPost = @{
    studentId = 106
    name = "Amit Kumar"
    email = "amit@kiet.edu"
    branch = "CSE(AI)"
    year = 2
    cgpa = 8.75
} | ConvertTo-Json
$r4 = Invoke-WebRequest -Uri "http://localhost:8080/students" -Method Post -Body $bodyPost -ContentType "application/json"
Write-Host "Status: $($r4.StatusCode)"
Write-Host "Response Body: $($r4.Content)"

Write-Host "`n=== TEST 5: PUT /students/101 ==="
$bodyPut = @{
    studentId = 101
    name = "Rahul Sharma"
    email = "rahul@kiet.edu"
    branch = "CSE(AI & ML)"
    year = 3
    cgpa = 9.05
} | ConvertTo-Json
$r5 = Invoke-WebRequest -Uri "http://localhost:8080/students/101" -Method Put -Body $bodyPut -ContentType "application/json"
Write-Host "Status: $($r5.StatusCode)"
Write-Host "Response Body: $($r5.Content)"

Write-Host "`n=== TEST 6: DELETE /students/105 ==="
$r6 = Invoke-WebRequest -Uri "http://localhost:8080/students/105" -Method Delete
Write-Host "Status: $($r6.StatusCode)"
Write-Host "Response Body: $($r6.Content)"

Write-Host "`n=== TEST 7: DELETE /students/999 (Not Found) ==="
try {
    $r7 = Invoke-WebRequest -Uri "http://localhost:8080/students/999" -Method Delete
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host "Response Body: $($reader.ReadToEnd())"
}

Write-Host "`n=== TEST 8: GET /students/search?branch=CSE&year=2 ==="
$r8 = Invoke-WebRequest -Uri "http://localhost:8080/students/search?branch=CSE&year=2" -Method Get
Write-Host "Status: $($r8.StatusCode)"
Write-Host "Response Body: $($r8.Content)"

Write-Host "`n=== TEST 9: GET /students/topper?cgpa=9.0 ==="
$r9 = Invoke-WebRequest -Uri "http://localhost:8080/students/topper?cgpa=9.0" -Method Get
Write-Host "Status: $($r9.StatusCode)"
Write-Host "Response Body: $($r9.Content)"
