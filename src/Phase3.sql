-- Margo Segui (msegui@wpi.edu)
CREATE TABLE Employee(
                         employeeID number PRIMARY KEY,
                         firstName varchar2(100),
                         lastName varchar2(100),
                         salary float,
                         jobTitle varchar2(100),
                         officeNum number,
                         empRank varchar2(100),
                         supervisorID number,
                         addressStreet varchar2(100),
                         addressCity varchar2(100)
);

CREATE TABLE Doctor(
                       employeeID number,
                       gender varchar2(10),
                       specialty varchar2(100),
                       graduatedFrom varchar2(100),
                       CONSTRAINT Doctor_PK PRIMARY KEY (employeeID),
                       CONSTRAINT Employee_FK FOREIGN KEY (employeeID) REFERENCES Employee(employeeID)
);

CREATE TABLE EquipmentTechnician(
                                    employeeID number,
                                    CONSTRAINT EquipmentTechnician_PK PRIMARY KEY (employeeID),
                                    CONSTRAINT EquipmentTechnician_FK FOREIGN KEY (employeeID) REFERENCES Employee (employeeID)
);


CREATE TABLE EquipmentType(
                              equipID varchar2(20),
                              equipDesc varchar2(255),
                              equipModel varchar2(100),
                              instructions varchar2(255),
                              numUnits number,
                              CONSTRAINT EquipmentType_PK PRIMARY KEY (equipID)
);

CREATE TABLE CanRepairEquipment(
                                   employeeID number,
                                   equipmentType varchar2(20),
                                   CONSTRAINT CanRepairEquipment PRIMARY KEY (employeeID, equipmentType),
                                   CONSTRAINT CanRepairEquipment_FK FOREIGN KEY (EmployeeID) REFERENCES Employee(employeeID),
                                   CONSTRAINT CanRepairEquipmentType_FK FOREIGN KEY (equipmentType) REFERENCES EquipmentType(equipID)
);

CREATE TABLE Equipment(
                          serialNum number,
                          typeID varchar2(20),
                          purchaseYear number(4,0),
                          lastInspection date,
                          roomNum number,
                          CONSTRAINT Equipment_PK PRIMARY KEY (serialNum),
                          CONSTRAINT EquipmentType_FK FOREIGN KEY (typeID) REFERENCES EquipmentType(equipID)
);

CREATE TABLE Room(
                     roomNum number PRIMARY KEY,
                     occupiedFlag char(1) Default 'N'
);

CREATE TABLE RoomService(
                            roomNum number UNIQUE,
                            service varchar2(100),
                            CONSTRAINT RoomService_PK PRIMARY KEY (roomNum, service),
                            CONSTRAINT Room_FK FOREIGN KEY (roomNum) REFERENCES Room(roomNum)
);

CREATE TABLE RoomAccess(
                           roomNum number,
                           employeeID number,
                           CONSTRAINT RoomAccess_PK PRIMARY KEY (roomNum, employeeID),
                           CONSTRAINT RoomAccess_FK FOREIGN KEY (roomNum) REFERENCES Room(roomNum),
                           CONSTRAINT RoomAccessEmployee_FK FOREIGN KEY (employeeID) REFERENCES Employee(employeeID)
);

CREATE TABLE Patient(
                        SSN number(9,0) PRIMARY KEY NOT NULL,
                        firstName varchar2(100) NOT NULL,
                        lastName varchar2(100) NOT NULL,
                        address varchar2(100),
                        telNum varchar2(20)
);

CREATE TABLE Admission (
                           admissionNum number PRIMARY KEY,
                           admissionDate date,
                           leaveDate date,
                           totalPayment number,
                           insurancePayment number,
                           SSN number(9,0) NOT NULL UNIQUE,
                           futureVisit date,
                           FOREIGN KEY (SSN) REFERENCES Patient(SSN)
);

CREATE TABLE Examine(
                        doctorID number,
                        AdmissionNum number,
                        doctorComment varchar2(255),
                        CONSTRAINT Examine_FK FOREIGN KEY (doctorID) REFERENCES Doctor(employeeID)
);

CREATE TABLE StayIn(
                       admissionNum number,
                       roomNum number,
                       startDate date,
                       endDate date,
                       CONSTRAINT StayIn_PK PRIMARY KEY (admissionNum, roomNum, startDate, endDate),
                       CONSTRAINT StayInAdmission_FK FOREIGN KEY (admissionNum) REFERENCES Admission(admissionNum),
                       CONSTRAINT StayInRoom_FK FOREIGN KEY (roomNum) REFERENCES Room(roomNum)
);

-- records:
-- a.10 patients
INSERT INTO Patient VALUES (1, 'Alex', 'Huang', '12345 Institute Rd', '012-345-6789');
INSERT INTO Patient VALUES (2, 'Bobby', 'Brown', '12345 Highland St', '123-456-7890');
INSERT INTO Patient VALUES (3, 'Chris', 'Ramirez', '12345 Park Ave', '234-567-8901');
INSERT INTO Patient VALUES (4, 'Devin', 'Bird', '12345 Main St', '345-678-9012');
INSERT INTO Patient VALUES (5, 'Ethan', 'Kwan', '12345 Daniels Rd', '456-789-0123');
INSERT INTO Patient VALUES (6, 'Freddy', 'Mercury', '12345 Queen St', '567-890-1234');
INSERT INTO Patient VALUES (7, 'Greg', 'Wong', '12345 Fruit St', '678-901-2345');
INSERT INTO Patient VALUES (8, 'Helen', 'Tran', '12345 Oxford St', '789-012-3456');
INSERT INTO Patient VALUES (9, 'Ivan', 'Zhou', '12345 Pleasant St', '890-123-4567');
INSERT INTO Patient VALUES (10, 'Julia', 'Sangil', '12345 Dover St', '901-234-5678');

-- b. 10 rooms, 3 have 2+ services
INSERT INTO Room VALUES (1, 'Y');
INSERT INTO Room VALUES (2, 'Y');
INSERT INTO Room VALUES (3, 'N');
INSERT INTO Room VALUES (4, 'Y');
INSERT INTO Room VALUES (5, 'N');
INSERT INTO Room VALUES (6, 'Y');
INSERT INTO Room VALUES (7, 'Y');
INSERT INTO Room VALUES (8, 'N');
INSERT INTO Room VALUES (9, 'N');
INSERT INTO Room VALUES (10, 'Y');

INSERT INTO RoomService VALUES (1, 'ICU');
INSERT INTO RoomService VALUES (4, 'ER');

INSERT INTO RoomService VALUES (2, 'ICU');
INSERT INTO RoomService VALUES (5, 'OR');

INSERT INTO RoomService VALUES (3, 'Ward');
INSERT INTO RoomService VALUES (6, 'Consulting');

-- c. 3 equipment types
INSERT INTO EquipmentType VALUES ('MRI', 'large, cylindrical machine that uses magnetic waves to produce images of the patient', 'Closed MRI', 'inform doctor, remove all metal, change into gown, stay super still, follow instructions, plan for longer appointment', 3);
INSERT INTO EquipmentType VALUES ('Ultrasound', 'transducer/probe/device used in medical imaging to create images of the inside of the body using high-frequency sound waves', '3D Model', 'N/A', 3);
INSERT INTO EquipmentType VALUES ('CT Scanner', 'know what you are getting, follow dietary restrictions, wear comfortable clothing, bring necessary documentation, arrive early and relax', 'N/A', 'N/A', 3);

-- d. 3 equipment units of each type
INSERT INTO Equipment VALUES(0, 'MRI', 2019, DATE '2025-09-03', 2);
INSERT INTO Equipment VALUES(1, 'MRI', 2019, DATE '2026-01-30', 1);
INSERT INTO Equipment VALUES(2, 'MRI', 2020, DATE '2026-02-05', 4);

INSERT INTO Equipment VALUES(3, 'Ultrasound', 2020, DATE '2025-12-12', 6);
INSERT INTO Equipment VALUES(4, 'Ultrasound', 2021, DATE '2026-01-10', 7);
INSERT INTO Equipment VALUES(5, 'Ultrasound', 2022, DATE '2026-02-01', 3);

INSERT INTO Equipment VALUES(6, 'CT Scanner', 2022, DATE '2025-09-03', 3);
INSERT INTO Equipment VALUES(7, 'CT Scanner', 2025, DATE '2025-10-31', 8);
INSERT INTO Equipment VALUES(8, 'CT Scanner', 2024, DATE '2026-01-27', 9);

-- e. at least 5 patients have 2 or more admissions (visits)
INSERT INTO Admission VALUES (1, DATE '2006-03-10', DATE '2006-03-11', 1000, 500, 1, DATE '2020-02-28');
INSERT INTO Admission VALUES (2, DATE '2020-02-28', DATE '2020-03-02', 3000, 50, 2, DATE '2026-02-14');

INSERT INTO Admission VALUES (3, DATE '2026-06-15', DATE '2015-06-17', 4500, 1000, 3, DATE '2026-06-29');
INSERT INTO Admission VALUES (4, DATE '2026-06-29', DATE '2026-06-29', 100, 80, 4, DATE '2027-05-30');

INSERT INTO Admission VALUES (5, DATE '2016-03-15', DATE '2016-03-15', 150, 100, 5, DATE '2017-03-17');
INSERT INTO Admission VALUES (6, DATE '2017-03-17', DATE '2017-03-17', 170, 100, 6, DATE '2018-04-02');

-- f. 15 regular emp, 4 div managers, 2 general managers
-- within reg emp -> 5 are doctors and 5 are equipment technicians

INSERT INTO Employee VALUES (0, 'Alice', 'Smith', 80000, 'Secretary', 1, '0', 5, '54321 Middsex Rd', 'Reading');
INSERT INTO Employee VALUES (1, 'Lotte', 'Chen', 70000, 'Security Officer', 2, '0', 6, '123 Pleasant St', 'Ashland');
INSERT INTO Employee VALUES (2, 'Dixon', 'Wang', 160000, 'Anesthesiologist', 3, '0', 7, '67 Washington St', 'Westwood');
INSERT INTO Employee VALUES (3, 'Elliot', 'Gardner', 50000, 'Radiology Nurse', 4, '0', 8, '1632 Uber St', 'Franklin');
INSERT INTO Employee VALUES (4, 'Harana', 'Hara', 40000, 'Nurse', 5, '0', 8, '245 Second St', 'Millis');

INSERT INTO Employee VALUES (5, 'Fred', 'Johnson', 200000, 'ICU Manager', 6, '1', 9, '54321 Lincoln Ave', 'Cypress');
INSERT INTO Employee VALUES (6, 'Lucas', 'dela Pena', 100000, 'Blood Bank Manager', 7, '1', 9, '42 Institute Rd', 'Worcester');
INSERT INTO Employee VALUES (7, 'Oogas', 'dale Pena', 8000000, 'Radiology Manager', 8, '1', 10, '42 Institute Rd', 'Worcester');
INSERT INTO Employee VALUES (8, 'Elio', 'Peachman', 120000, 'Chief Nurse', 9, '1', 10, '63 First Ave', 'Springfield');

INSERT INTO Employee VALUES (9, 'Scott', 'Dale', 1000000, 'General Manager', 10, '2', NULL, '84 Third Ave', 'Scottsdale');
INSERT INTO Employee VALUES (10, 'Elle', 'Garner', 1100000, 'General Manager', 11, '2', NULL, '56 Forth Ave', 'Newton');

INSERT INTO Employee VALUES (11, 'Jimmy', 'Hong', 200000, 'Surgeon', 78, '0', 8, '89 Dale Ave', 'Kingston');
INSERT INTO Doctor VALUES (11, 'male', 'plastic surgery', 'Harvard');
INSERT INTO Employee VALUES (12, 'Vivian', 'Tran', 300000, 'Surgeon', 79, '0', 8, '823 Lexington Rd', 'Garden Grove');
INSERT INTO Doctor VALUES (12, 'female', 'heart surgery', 'Brown University');
INSERT INTO Employee VALUES (13, 'Tiffany', 'Nguyen', 190000, 'OBGYN', 80, '0', 8, '823 Lexington Rd', 'Garden Grove');
INSERT INTO Doctor VALUES (13);
INSERT INTO Employee VALUES (14, 'Christopher', 'Lam', 217000, 'Proctologist', 81, '0', 8, '89 Dale Ave', 'Kingston');
INSERT INTO Doctor VALUES (14, 'male', 'proctology', 'Rutgers');
INSERT INTO Employee VALUES (15, 'Delfie', 'Galiza', 1000000, 'Urologist', 82, '0', 8, '823 Lexington Rd', 'Garden Grove');
INSERT INTO Doctor VALUES (15, 'female', 'urology', 'Berkeley');

INSERT INTO Employee VALUES (16, 'Kevin', 'Hwang', 80000, 'Technician', 78, '1', 9, '234 Beechwood Way', 'Stanton');
INSERT INTO EquipmentTechnician VALUES (16);
INSERT INTO CanRepairEquipment VALUES (16, 'MRI');

INSERT INTO Employee VALUES (17, 'Chloe', 'Kim', 70000, 'Technician', 78, '1', 9, '7654 Lampson Ave', 'Cypress');
INSERT INTO EquipmentTechnician VALUES (17);
INSERT INTO CanRepairEquipment VALUES (17, 'MRI');

INSERT INTO Employee VALUES (18, 'LeAnh', 'Lee', 650000, 'Technician', 78, '1', 9, '2 Kensington Ave', 'Kensington');
INSERT INTO EquipmentTechnician VALUES (18);
INSERT INTO CanRepairEquipment VALUES (18, 'CT Scanner');

INSERT INTO Employee VALUES (19, 'Kim', 'Rhee', 70000, 'Technician', 78, '1', 9, '456 Richmond St', 'Marina');
INSERT INTO EquipmentTechnician VALUES (19);
INSERT INTO CanRepairEquipment VALUES (19, 'CT Scanner');

INSERT INTO Employee VALUES (20, 'John', 'Park', 90000, 'Technician', 78, '1', 9, '87 Fifth Ave', 'Long Beach');
INSERT INTO EquipmentTechnician VALUES (20);
INSERT INTO CanRepairEquipment VALUES (20, 'Ultrasound');

-- PART 1: VIEWS
-- 1.
CREATE VIEW CriticalCases AS
SELECT p.SSN AS Patient_SSN, p.firstName, p.lastName, COUNT(a.admissionNum) AS numberOfAdmissionsToICU
FROM Admission a
         JOIN Patient p
              ON a.SSN = p.SSN
         JOIN StayIn s
              ON a.admissionNum = s.admissionNum
         JOIN RoomService r
              ON s.roomNum = r.roomNum
WHERE r.service = 'ICU'
GROUP BY p.SSN, p.firstName, p.lastName
HAVING COUNT(a.admissionNum) >= 2;

-- 2.
CREATE VIEW DoctorsLoad AS
SELECT d.employeeID AS doctorID, d.graduatedFrom,
       CASE
           WHEN COUNT(DISTINCT e.admissionNum) > 10 THEN 'overloaded'
           ELSE 'underloaded'
           END AS load
FROM Doctor d LEFT
                  JOIN Examine e
                       ON d.employeeID = e.doctorID
GROUP BY d.employeeID, d.graduatedFrom;

-- 3.
SELECT Patient_SSN, firstName, lastName, numberOfAdmissionsToICU
FROM CriticalCases
WHERE numberOfAdmissionsToICU > 4;

-- 4.
SELECT dl.doctorID, e.firstName AS firstName, e.lastName AS lastName
FROM DoctorsLoad dl JOIN Employee e ON dl.doctorID = e.employeeID
WHERE dl.load = 'overloaded'
  AND dl.graduatedFrom = 'WPI'
GROUP BY dl.doctorID, e.firstName, e.lastName;

-- 5.
SELECT e.doctorID AS doctorID, a.SSN AS patientSSN, e.doctorComment
FROM DoctorsLoad dl
         JOIN Examine e ON dl.doctorID = e.doctorID
         JOIN Admission a ON e.admissionNum = a.admissionNum
         JOIN CriticalCases c ON a.SSN = c.Patient_SSN
WHERE dl.load = 'underloaded'
GROUP BY e.doctorID, a.SSN, e.doctorComment;

-- PART 2: TRIGGERS
-- 1.
CREATE OR REPLACE TRIGGER icuComment
    BEFORE INSERT OR UPDATE ON Examine
    FOR EACH ROW
DECLARE
    numVisit NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO numVisit
    FROM StayIn s
             JOIN RoomService r ON s.roomNum = r.roomNum
    WHERE s.admissionNum = :NEW.admissionNum
      AND r.service = 'ICU';
    IF numVisit > 0 AND :NEW.doctorComment IS NULL THEN
        RAISE_APPLICATION_ERROR(-20000, 'Doctor must leave a comment for ICU patients');
    END IF;
END;
/

-- 2.
CREATE OR REPLACE TRIGGER insuranceCoverage
    BEFORE INSERT OR UPDATE OF totalPayment ON Admission
    FOR EACH ROW
BEGIN
    :NEW.insurancePayment := :NEW.totalPayment * 0.65;
END;
/

-- 3 + 4
CREATE OR REPLACE TRIGGER checkEmpRanks
    BEFORE INSERT OR UPDATE ON Employee
    FOR EACH ROW
DECLARE
    supRank varchar2(100);
BEGIN
    IF :NEW.empRank = '0' THEN
        IF :NEW.supervisorID IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Regular Employees must have supervisors.');
        END IF;

        SELECT empRank INTO supRank
        FROM Employee
        WHERE employeeID = :NEW.supervisorID;

        IF supRank <> '1' THEN
            RAISE_APPLICATION_ERROR(-20002, 'Regular Employee supervisor must be rank 1.');
        END IF;

    ELSIF :NEW.empRank = '1' THEN
        IF :NEW.supervisorID IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Division managers must have supervisors.');
        END IF;

        SELECT empRank INTO supRank
        FROM Employee
        WHERE employeeID = :NEW.supervisorID;

        IF supRank <> '2' THEN
            RAISE_APPLICATION_ERROR(-20004, 'Division managers supervisor must be rank 2.');
        END IF;

    ELSIF :NEW.empRank = '2' THEN
        IF :NEW.supervisorID IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'General managers cannot have supervisors.');
        END IF;
    END IF;
END;
/

-- 5.
CREATE OR REPLACE TRIGGER erPostVisit
    AFTER INSERT ON StayIn
    FOR EACH ROW
DECLARE
    numVisit NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO numVisit
    FROM RoomService
    WHERE roomNum = :NEW.roomNum
      AND service = 'ER';
    IF numVisit > 0 THEN
        UPDATE Admission
        SET futureVisit = ADD_MONTHS(:NEW.startDate, 2)
        WHERE admissionNum = :NEW.admissionNum;
    END IF;
END;
/

-- 6.
CREATE OR REPLACE TRIGGER inspectEquipment
    BEFORE INSERT ON Equipment
    FOR EACH ROW
DECLARE
    numEquip NUMBER;
BEGIN
    IF MONTHS_BETWEEN(SYSDATE, :NEW.lastInspection) > 1 THEN
        SELECT COUNT(*)
        INTO numEquip
        FROM CanRepairEquipment c
                 JOIN EquipmentTechnician t ON c.employeeID = t.employeeID
        WHERE c.equipmentType = :NEW.typeID;

        IF numEquip > 0 THEN
            :NEW.lastInspection := SYSDATE;
        END IF;
    END IF;
END;
/
