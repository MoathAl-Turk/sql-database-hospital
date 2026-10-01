CREATE TABLE Employee(
EmployeeID NUMBER PRIMARY KEY,
Name VARCHAR2(50) NOT NULL,
Salary NUMBER,
SupervisorID NUMBER,
FOREIGN KEY(SupervisorID)
REFERENCES Employee(EmployeeID)
);

CREATE TABLE Department(
DeptID NUMBER PRIMARY KEY,
DeptName VARCHAR2(50),
Location VARCHAR2(50),
RoomCount NUMBER,
ManagerID NUMBER UNIQUE,
FOREIGN KEY(ManagerID)
REFERENCES Employee(EmployeeID)
);

CREATE TABLE Doctor(
EmployeeID NUMBER PRIMARY KEY,
MedicalLicenseNo VARCHAR2(30) UNIQUE,
Specialty VARCHAR2(50),
YearsExperience NUMBER,
FOREIGN KEY(EmployeeID)
REFERENCES Employee(EmployeeID)
);

CREATE TABLE Nurse(
EmployeeID NUMBER PRIMARY KEY,
ShiftType VARCHAR2(20),
Ward VARCHAR2(30),
OnCallStatus VARCHAR2(10)
CHECK(OnCallStatus IN('On-call','Off-call')),
FOREIGN KEY(EmployeeID)
REFERENCES Employee(EmployeeID)
);

CREATE TABLE Room(
DeptID NUMBER,
RoomNum NUMBER,
RoomType VARCHAR2(30),
Capacity NUMBER,
PRIMARY KEY(DeptID,RoomNum),
FOREIGN KEY(DeptID)
REFERENCES Department(DeptID)
);

CREATE TABLE Patient(
PatientID NUMBER PRIMARY KEY,
FName VARCHAR2(30),
MInit CHAR(1),
LName VARCHAR2(30),
DateOfBirth DATE,
DeptID NUMBER,
RoomNum NUMBER,
FOREIGN KEY(DeptID,RoomNum)
REFERENCES Room(DeptID,RoomNum)
);

CREATE TABLE PatientNumbers(
PatientID NUMBER,
PhoneNumber VARCHAR2(15),
PRIMARY KEY(PatientID,PhoneNumber),
FOREIGN KEY(PatientID)
REFERENCES Patient(PatientID)
);

CREATE TABLE Treats(
PatientID NUMBER,
DoctorID NUMBER,
TreatmentDate DATE,
Diagnosis VARCHAR2(100),
PRIMARY KEY(PatientID,DoctorID,TreatmentDate),
FOREIGN KEY(PatientID)
REFERENCES Patient(PatientID),
FOREIGN KEY(DoctorID)
REFERENCES Doctor(EmployeeID)
);

CREATE TABLE Attends_To(
PatientID NUMBER,
NurseID NUMBER,
PRIMARY KEY(PatientID,NurseID),
FOREIGN KEY(PatientID)
REFERENCES Patient(PatientID),
FOREIGN KEY(NurseID)
REFERENCES Nurse(EmployeeID)
);

INSERT INTO Employee VALUES(101,'Shahd Alami',9000,NULL);
INSERT INTO Employee VALUES(102,'Khaled Shweiki',8500,101);
INSERT INTO Employee VALUES(103,'moath alturk',8000,101);
INSERT INTO Employee VALUES(104,'Layan ahmad',7500,102);
INSERT INTO Employee VALUES(105,'wesam mohammad',7000,102);

INSERT INTO Department VALUES(1,'Heart','A',5,101);
INSERT INTO Department VALUES(2,'Brain','B',4,102);
INSERT INTO Department VALUES(3,'Bones','C',3,103);
INSERT INTO Department VALUES(4,'General','D',4,104);
INSERT INTO Department VALUES(5,'Emergency','E',2,105);

INSERT INTO Doctor VALUES(101,'ML1001','Heart',15);
INSERT INTO Doctor VALUES(102,'ML1002','Bones',12);
INSERT INTO Doctor VALUES(103,'ML1003','Brain',10);
INSERT INTO Doctor VALUES(104,'ML1004','General',8);
INSERT INTO Doctor VALUES(105,'ML1005','Emergency',6);

INSERT INTO Employee VALUES(201,'Rama Ali',5000,101);
INSERT INTO Employee VALUES(202,'Alaa Ahmad',5000,101);
INSERT INTO Employee VALUES(203,'Dana Omar',5000,102);
INSERT INTO Employee VALUES(204,'Noor Khaled',5000,102);
INSERT INTO Employee VALUES(205,'Aya Salem',5000,103);

INSERT INTO Nurse VALUES(201,'Day','WardA','On-call');
INSERT INTO Nurse VALUES(202,'Night','WardB','Off-call');
INSERT INTO Nurse VALUES(203,'Day','WardC','On-call');
INSERT INTO Nurse VALUES(204,'Night','WardD','Off-call');
INSERT INTO Nurse VALUES(205,'Day','WardE','On-call);

INSERT INTO Room VALUES(1,101,'ICU',2);
INSERT INTO Room VALUES(2,201,'General',4);
INSERT INTO Room VALUES(3,301,'Private',1);
INSERT INTO Room VALUES(4,401,'General',3);
INSERT INTO Room VALUES(5,501,'Emergency',2);

INSERT INTO Patient VALUES(1,'Ahmad','M','Saleh',DATE '2001-03-15',1,101);
INSERT INTO Patient VALUES(2,'Lina','A','Omar',DATE '1999-07-20',2,201);
INSERT INTO Patient VALUES(3,'Yousef','K','Ali',DATE '2002-01-10',3,301);
INSERT INTO Patient VALUES(4,'Razan','T','Mahmoud',DATE '1998-11-25',4,401);
INSERT INTO Patient VALUES(5,'Sami','N','Hassan',DATE '2000-05-08',5,501);

INSERT INTO PatientNumbers VALUES(1,'0791111111');
INSERT INTO PatientNumbers VALUES(1,'0792222222');
INSERT INTO PatientNumbers VALUES(2,'0783333333');
INSERT INTO PatientNumbers VALUES(3,'0774444444');
INSERT INTO PatientNumbers VALUES(4,'0795555555');

INSERT INTO Treats VALUES(1,101,DATE '2024-01-01','HeartDisease');
INSERT INTO Treats VALUES(2,102,DATE '2024-01-05','Fracture');
INSERT INTO Treats VALUES(3,103,DATE '2024-01-10','Migraine');
INSERT INTO Treats VALUES(4,104,DATE '2024-01-12','Flu');
INSERT INTO Treats VALUES(5,105,DATE '2024-01-15','Injury');

INSERT INTO Attends_To VALUES(1,201);
INSERT INTO Attends_To VALUES(2,202);
INSERT INTO Attends_To VALUES(3,203);
INSERT INTO Attends_To VALUES(4,204);
INSERT INTO Attends_To VALUES(5,205);

UPDATE Employee
SET Salary = 9500
WHERE EmployeeID = 101;

DELETE FROM PatientNumbers
WHERE PhoneNumber='0795555555';

SELECT P.FName,
       P.LName,
       E.Name AS DoctorName,
       T.Diagnosis
FROM Patient P
JOIN Treats T
ON P.PatientID = T.PatientID
JOIN Doctor D
ON T.DoctorID = D.EmployeeID
JOIN Employee E
ON D.EmployeeID = E.EmployeeID;

SELECT P.FName,
       P.LName,
       E.Name AS NurseName,
       N.Ward
FROM Patient P
JOIN Attends_To A
ON P.PatientID = A.PatientID
JOIN Nurse N
ON A.NurseID = N.EmployeeID
JOIN Employee E
ON N.EmployeeID = E.EmployeeID;

SELECT E.Name,
       COUNT(T.PatientID) AS TotalPatients
FROM Employee E
JOIN Doctor D
ON E.EmployeeID = D.EmployeeID
JOIN Treats T
ON D.EmployeeID = T.DoctorID
GROUP BY E.Name;

SELECT D.DeptName,
       AVG(E.Salary) AS AverageSalary
FROM Department D
JOIN Employee E
ON D.ManagerID = E.SupervisorID
GROUP BY D.DeptName;

SELECT FName, LName
FROM Patient
WHERE PatientID IN
(
    SELECT PatientID
    FROM Treats
    WHERE DoctorID IN
    (
        SELECT EmployeeID
        FROM Doctor
        WHERE Specialty='Heart'
    )
);

SELECT Name, Salary
FROM Employee
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employee
);