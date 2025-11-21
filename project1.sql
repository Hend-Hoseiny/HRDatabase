CREATE DATABASE University_HR_ManagementSystem_Team_No;

USE University_HR_ManagementSystem_Team_No;
GO
CREATE PROC createAllTables 
AS 
    BEGIN
    CREATE TABLE DEPARTMENT (
        d_name VARCHAR(50),
        building_location VARCHAR(50)
        CONSTRAINT dep_pk PRIMARY KEY (d_name)
    );
    CREATE TABLE EMPLOYEE(
        employee_ID INT IDENTITY (1,1),
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        email VARCHAR(50),
        passworde VARCHAR(50),
        addresse VARCHAR(50),
        gender CHAR(1),
        official_day_off VARCHAR(50),
        years_of_experience INT,
        national_ID CHAR(16),
        employment_status VARCHAR(50), 
        type_of_contract VARCHAR(50),
        emergency_contact_name VARCHAR(50), 
        emergency_contact_phone CHAR(11),
        annual_balance INT,
        accidental_balance INT,
        salary DECIMAL(10,2),
        hire_date DATE,
        last_working_date DATE,
        dept_name VARCHAR(50)
        CONSTRAINT emp_pk PRIMARY KEY(employee_ID),
        CONSTRAINT emp_fk FOREIGN KEY (dept_name) references Department(d_name) 
    );
    CREATE TABLE Employee_Phone(
        emp_ID INT,
        phone_num CHAR(11)
        CONSTRAINT emp_p_pk PRIMARY KEY (emp_ID, phone_num),
        CONSTRAINT emp_p_fk FOREIGN KEY (emp_ID) references EMPLOYEE(employee_ID) 
    );
    CREATE TABLE Role(
        role_name VARCHAR(50),
        title VARCHAR(50),
        r_description VARCHAR(50),
        rank INT, 
        base_salary DECIMAL(10,2),
        percentage_YOE DECIMAL(4,2),
        percentage_overtime DECIMAL(4,2),
        annual_balance INT,
        accidental_balance INT
        CONSTRAINT role_pk PRIMARY KEY (role_name)
    );
    CREATE TABLE Employee_Role(
        emp_ID INT,
        role_name VARCHAR(50)
        CONSTRAINT emp_role_pk PRIMARY KEY (emp_ID, role_name),
        CONSTRAINT emp_role_fk1 FOREIGN KEY (emp_ID) references Employee(employee_ID), 
        CONSTRAINT emp_role_fk2 FOREIGN KEY (role_name) references Role(role_name) 
    );
    CREATE TABLE Role_existsIn_Department(
        department_name VARCHAR(50),
        Role_name VARCHAR(50)
        CONSTRAINT role_e_in_dep_pk PRIMARY KEY (department_name,Role_name)
        CONSTRAINT role_e_in_dep_fk1 FOREIGN KEY (department_name) REFERENCES Department(d_name),
        CONSTRAINT role_e_in_dep_fk2 FOREIGN KEY (role_name) REFERENCES Role(role_name)
    );
    CREATE TABLE Leave(
        request_ID INT IDENTITY (1,1),
        date_of_request DATE,
        l_start_date DATE,
        end_date DATE, 
        num_days AS DATEDIFF(DAY,end_date , l_start_date),
        final_approval_status VARCHAR(50),
        CONSTRAINT leave_pk PRIMARY KEY (request_ID)
    );
    CREATE TABLE Annual_Leave(
        request_ID INT,
        emp_ID INT,
        replacement_emp INT
        CONSTRAINT annual_l_pk PRIMARY KEY (request_ID),
        CONSTRAINT annual_l_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT annual_l_fk2 FOREIGN KEY (request_ID) REFERENCES Leave(request_ID),
        CONSTRAINT annual_l_fk3 FOREIGN KEY (replacement_emp) REFERENCES Employee(employee_ID)
    );
    CREATE TABLE Accidental_Leave(
        request_ID INT,
        emp_ID INT,
        CONSTRAINT acc_l_pk PRIMARY KEY (request_ID),
        CONSTRAINT acc_l_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT acc_l_fk2 FOREIGN KEY (request_ID) REFERENCES Leave(request_ID)
    );
    CREATE TABLE Medical_Leave(
        request_ID INT,
        insurance_status BIT,
        disability_details VARCHAR(50),
        m_type  VARCHAR(50),
        Emp_ID INT,
         CONSTRAINT med_l_pk PRIMARY KEY (request_ID),
        CONSTRAINT med_l_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT med_l_fk2 FOREIGN KEY (request_ID) REFERENCES Leave(request_ID)
    );
    CREATE TABLE Unpaid_Leave(
        request_ID INT,
        emp_ID INT,
        CONSTRAINT unpaid_l_pk PRIMARY KEY (request_ID),
        CONSTRAINT unpaid_l_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT unpaid_l_fk2 FOREIGN KEY (request_ID) REFERENCES Leave(request_ID)
    );
    CREATE TABLE Compensation_Leave(
        request_ID INT,
        reason  VARCHAR(50), 
        date_of_original_workday DATE,
        emp_ID INT,
        replacement_emp INT,
        CONSTRAINT comp_l_pk PRIMARY KEY (request_ID),
        CONSTRAINT comp_l_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT comp_l_fk2 FOREIGN KEY (request_ID) REFERENCES Leave(request_ID),
        CONSTRAINT comp_l_fk3 FOREIGN KEY (replacement_emp) REFERENCES Employee(employee_ID)
    );
    CREATE TABLE Document(
        document_ID INT IDENTITY (1,1),
        d_type VARCHAR(50),
        d_description VARCHAR(50),
        file_name VARCHAR(50),
        creation_date DATE,
        expiry_date DATE,
        status VARCHAR(50),
        emp_ID INT, 
        medical_ID INT,
        unpaid_ID INT,
        CONSTRAINT doc_pk PRIMARY KEY (document_ID),
        CONSTRAINT doc_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT doc_fk2 FOREIGN KEY (medical_ID) REFERENCES Medical_Leave(request_ID),
        CONSTRAINT doc_fk3 FOREIGN KEY (unpaid_ID) REFERENCES Unpaid_Leave(request_ID),
    );
    CREATE TABLE Payroll(
        ID INT IDENTITY(1,1),
        payment_date DATE,
        final_salary_amount DECIMAL(10,1),
        from_date DATE, 
        to_date DATE,
        comments VARCHAR(150),
        bonus_amount DECIMAL(10,2),
        deductions_amount DECIMAL(10,2),
        emp_ID INT,
        CONSTRAINT payroll_pk PRIMARY KEY(ID),
        CONSTRAINT payroll_fk FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID)
    );
    CREATE TABLE Attendance(
        attendance_ID INT,
        a_date DATE,
        check_in_time TIME,
        check_out_time TIME,
        total_duration AS DATEDIFF(MINUTE,check_out_time , check_in_time),
        a_status VARCHAR(50),
        emp_ID INT,
        CONSTRAINT attendance_pk PRIMARY KEY(attendance_ID),
        CONSTRAINT attendance_fk FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID)
    );
    CREATE TABLE Deduction(
        deduction_ID INT IDENTITY (1,1),
        emp_ID INT,
        ded_date DATE,
        amount DECIMAL(10,2),
        ded_type VARCHAR(50),
        ded_status VARCHAR(50),
        unpaid_ID INT,
        attendance_ID INT
        CONSTRAINT ded_pk PRIMARY KEY(deduction_ID, emp_ID),
        CONSTRAINT ded_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT ded_fk2 FOREIGN KEY (unpaid_ID) REFERENCES Unpaid_Leave(request_ID),
        CONSTRAINT ded_fk3 FOREIGN KEY(attendance_ID) REFERENCES Attendance (attendance_ID)
    ); 
    CREATE TABLE Performance(
        performance_ID INT,
        rating INT,
        comments VARCHAR(50),
        semester CHAR(3),
        emp_ID INT,
        CONSTRAINT per_pk PRIMARY KEY(performance_ID),
        CONSTRAINT per_fk1 FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID)
    );
    CREATE TABLE Employee_Replace_Employee(
        Emp1_ID INT,
        Emp2_ID INT,
        from_date DATE,
        to_date DATE,
        CONSTRAINT emp_rep_emp_pk PRIMARY KEY(Emp1_ID,Emp2_ID),
        CONSTRAINT pemp_rep_emp_fk1 FOREIGN KEY (Emp1_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT pemp_rep_emp_fk2 FOREIGN KEY (Emp2_ID) REFERENCES Employee(employee_ID)
    );

    CREATE TABLE Employee_Approve_Leave(
        Emp1_ID INT,
        Leave_ID INT,
        emp_app_l_status VARCHAR(50),
        CONSTRAINT emp_app_l_pk PRIMARY KEY(Emp1_ID,Leave_ID),
        CONSTRAINT emp_app_l_fk1 FOREIGN KEY (Emp1_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT emp_app_l_fk2 FOREIGN KEY (Leave_ID) REFERENCES Leave(request_ID)
    ); 

    END
GO


-- 2.1 c
GO
CREATE PROC dropAllTables
AS 
    BEGIN
    DROP TABLE IF EXISTS Employee_Approve_Leave;
    DROP TABLE IF EXISTS Employee_Replace_Employee;
    DROP TABLE IF EXISTS Performance;
    DROP TABLE IF EXISTS Deduction;
    DROP TABLE IF EXISTS Attendance;
    DROP TABLE IF EXISTS Payroll;
    DROP TABLE IF EXISTS Document;
    DROP TABLE IF EXISTS Compensation_Leave;
    DROP TABLE IF EXISTS Unpaid_Leave;
    DROP TABLE IF EXISTS Medical_Leave;
    DROP TABLE IF EXISTS Accidental_Leave;
    DROP TABLE IF EXISTS Annual_Leave;
    DROP TABLE IF EXISTS Leave;
    DROP TABLE IF EXISTS Role_existsIn_Department;
    DROP TABLE IF EXISTS Employee_Role;
    DROP TABLE IF EXISTS Role;
    DROP TABLE IF EXISTS Employee_Phone;
    DROP TABLE IF EXISTS EMPLOYEE;
    DROP TABLE IF EXISTS DEPARTMENT;
    END

GO

-- 2.1 d GO BAAACKKKKKKK WHEN WE ARE DONEEEE!!!!!!!!!!!!!!!
CREATE PROC dropAllProceduresFunctionsViews
AS 
    BEGIN
    DROP PROC IF EXISTS createAllTables;
    DROP PROC IF EXISTS dropAllTables;
    END

GO 
-- 2.2 C
CREATE VIEW allPerformance  
AS 
SELECT * FROM PERFORMANCE 
WHERE semester LIKE 'W%';


-- 2.2 e
GO
CREATE VIEW allEmployeeAttendance
AS 
    SELECT E.employee_ID AS 'Employee ID', E.first_name AS 'Employee First Name', 
           E.last_name AS 'Employee Last Name', A.a_date AS 'Attendance Date', 
           A.check_in_time AS 'Check In Time', A.check_out_time AS 'Check Out Time', A.a_status AS 'Attendance Status'
    FROM EMPLOYEE E
    JOIN Attendance A ON E.employee_ID = A.emp_ID; 


--2.3 c 

GO

CREATE PROC Create_Holiday
    AS 
    BEGIN 
        CREATE TABLE Holiday(
        holiday_id int IDENTITY,
        naMe VARCHAR(50),
        from_date DATE,
        to_date DATE
        );
    END;
    GO

-- 2.3 e ??????????????????????????????????????????????????????????
GO
CREATE PROC Add_Holiday
    @holiday_name VARCHAR(50),
    @from_date DATE,
    @to_date DATE
AS
    BEGIN
        INSERT INTO Holiday (holiday_name, from_date, to_date)
        VALUES (@holiday_name, @from_date, @to_date);
    END


-- 2.3 g
GO
CREATE PROC Update_Attendance
    @employee_ID INT,
    @check_in TIME,
    @check_out TIME
AS
    BEGIN
        INSERT INTO Attendance (a_date, check_in_time, check_out_time, a_status, emp_ID)
        VALUES (CAST(GETDATE() AS DATE), @check_in, @check_out,
                CASE WHEN @check_in IS NULL THEN 'Absent' ELSE 'Present' END,
                @employee_ID);
    END


-- 2.3 h
GO
CREATE PROC Remove_Holiday
    --remove attendance records for all employees during official holidays
    AS 






EXEC dropAllProceduresFunctionsViews;
EXEC dropAllTables;
EXEC createAllTables;

DROP VIEW IF EXISTS allEmployeeAttendance;
SELECT * FROM allEmployeeAttendance;





