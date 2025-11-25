---------------------------------------------------------------------------------------------------------
--2.1(a)
CREATE DATABASE University_HR_ManagementSystem_Team_No_130;
---------------------------------------------------------------------------------------------------------
GO
    USE University_HR_ManagementSystem_Team_No_130;

GO

---------------------------------------------------------------------------------------------------------
--2.1(b)
GO

CREATE PROC createAllTables
AS
    BEGIN
    CREATE TABLE DEPARTMENT (
        name VARCHAR(50),
        building_location VARCHAR(50)
        CONSTRAINT dep_pk PRIMARY KEY (name)
    );
    CREATE TABLE EMPLOYEE(
        employee_ID INT IDENTITY (1,1),
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        email VARCHAR(50),
        password VARCHAR(50),
        address VARCHAR(50),
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
        dept_name VARCHAR(50),
        CHECK (type_of_contract IN ('part_time', 'full_time')),
        CHECK (employment_status IN ('active', 'onleave', 'notice_period', 'resigned')),
        CONSTRAINT emp_pk PRIMARY KEY(employee_ID),
        CONSTRAINT emp_fk FOREIGN KEY (dept_name) references Department(name)
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
        description VARCHAR(50),
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
        CONSTRAINT role_e_in_dep_fk1 FOREIGN KEY (department_name) REFERENCES Department(name),
        CONSTRAINT role_e_in_dep_fk2 FOREIGN KEY (role_name) REFERENCES Role(role_name)
    );
    CREATE TABLE Leave(
        request_ID INT IDENTITY (1,1),
        date_of_request DATE,
        start_date DATE,
        end_date DATE,
        num_days AS DATEDIFF(DAY,start_date,end_date),
        final_approval_status VARCHAR(50) default 'pending',
        CHECK (final_approval_status IN ('rejected', 'approved', 'pending')),
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
        type VARCHAR(50),
        Emp_ID INT,
        CHECK (type IN ('sick', 'maternity')),
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
        reason VARCHAR(50),
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
        type VARCHAR(50),
        description VARCHAR(50),
        file_name VARCHAR(50),
        creation_date DATE,
        expiry_date DATE,
        status VARCHAR(50),
        emp_ID INT,
        medical_ID INT,
        unpaid_ID INT,
        CHECK (status IN ('valid', 'expired')),
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
        attendance_ID INT IDENTITY(1,1),
        date DATE,
        check_in_time TIME,
        check_out_time TIME,
        total_duration AS DATEDIFF(MINUTE , check_in_time , check_out_time),
        status VARCHAR(50) DEFAULT 'Absent',
        emp_ID INT,
        CHECK (status IN ('absent', 'attended')),
        CONSTRAINT attendance_pk PRIMARY KEY(attendance_ID),
        CONSTRAINT attendance_fk FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID)
    );
    CREATE TABLE Deduction(
        deduction_ID INT IDENTITY (1,1),
        emp_ID INT,
        date DATE,
        amount DECIMAL(10,2),
        type VARCHAR(50),
        status VARCHAR(50) DEFAULT 'pending',
        unpaid_ID INT,
        attendance_ID INT,
        CHECK (type IN ('unpaid', 'missing_hours', 'missing_days')),
        CHECK (status IN ('finalized', 'pending')),
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
        CHECK (rating BETWEEN 1 AND 5),
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
        status VARCHAR(50),
        CONSTRAINT emp_app_l_pk PRIMARY KEY(Emp1_ID,Leave_ID),
        CONSTRAINT emp_app_l_fk1 FOREIGN KEY (Emp1_ID) REFERENCES Employee(employee_ID),
        CONSTRAINT emp_app_l_fk2 FOREIGN KEY (Leave_ID) REFERENCES Leave(request_ID)
    );

    END

GO

---------------------------------------------------------------------------------------------------------
EXEC createAllTables;
---------------------------------------------------------------------------------------------------------
--2.1(c)
GO

CREATE PROC  dropAllTables
AS
    BEGIN
        DROP TABLE IF EXISTS Role_existsIn_Department;
        DROP TABLE IF EXISTS Employee_Approve_Leave;
        DROP TABLE IF EXISTS Employee_Replace_Employee;
        DROP TABLE IF EXISTS Employee_Phone;
        DROP TABLE IF EXISTS Payroll;
        DROP TABLE IF EXISTS Performance;
        DROP TABLE IF EXISTS Deduction;
        DROP TABLE IF EXISTS Document;
        DROP TABLE IF EXISTS Compensation_Leave;
        DROP TABLE IF EXISTS Unpaid_Leave;
        DROP TABLE IF EXISTS Medical_Leave;
        DROP TABLE IF EXISTS Accidental_Leave;
        DROP TABLE IF EXISTS Annual_Leave;
        DROP TABLE IF EXISTS Leave;
        DROP TABLE IF EXISTS Employee_Role;
        DROP TABLE IF EXISTS Attendance;
        DROP TABLE IF EXISTS EMPLOYEE;
        DROP TABLE IF EXISTS DEPARTMENT;
        DROP TABLE IF EXISTS Role;
    END

GO
---------------------------------------------------------------------------------------------------------
-- DROP PROC dropAllTables;
-- GO
-- EXEC dropAllTables;
---------------------------------------------------------------------------------------------------------
--2.1(d)
GO

CREATE  PROC dropAllProceduresFunctionsViews
AS
BEGIN
    DROP VIEW IF EXISTS allEmployeeProfiles;
    DROP VIEW IF EXISTS NoEmployeeDept;
    DROP VIEW IF EXISTS allPerformance;
    DROP VIEW IF EXISTS allRejectedMedicals;
    DROP VIEW IF EXISTS allEmployeeAttendance;

    DROP FUNCTION IF EXISTS HRLoginValidation;
    DROP FUNCTION IF EXISTS EmployeeLoginValidation;
    DROP FUNCTION IF EXISTS MyPerformance;
    DROP FUNCTION IF EXISTS MyAttendance;
    DROP FUNCTION IF EXISTS Last_month_payroll;
    DROP FUNCTION IF EXISTS Deductions_Attendance;
    DROP FUNCTION IF EXISTS Is_On_Leave;
    DROP FUNCTION IF EXISTS Status_leaves;

    DROP PROC IF EXISTS createAllTables;
    DROP PROC IF EXISTS dropAllTables;
    DROP PROC IF EXISTS clearAllTables;
    DROP PROC IF EXISTS Update_Status_Doc;
    DROP PROC IF EXISTS Remove_Deductions;
    DROP PROC IF EXISTS Update_Employment_Status;
    DROP PROC IF EXISTS Create_Holiday;
    DROP PROC IF EXISTS Add_Holiday;
    DROP PROC IF EXISTS Intitiate_Attendance;
    DROP PROC IF EXISTS Update_Attendance;
    DROP PROC IF EXISTS Remove_Holiday;
    DROP PROC IF EXISTS Remove_Approved_Leaves;
    DROP PROC IF EXISTS Replace_Employee;
    DROP PROC IF EXISTS HR_approval_an_acc;
    DROP PROC IF EXISTS HR_approval_unpaid;
    DROP PROC IF EXISTS HR_approval_comp;
    DROP PROC IF EXISTS Deduction_hours;
    DROP PROC IF EXISTS rate_per_hour;
    DROP PROC IF EXISTS Deduction_days;
    DROP PROC IF EXISTS Deduction_unpaid;
    DROP PROC IF EXISTS Bonus_amount;
    DROP PROC IF EXISTS Submit_annual;
    DROP PROC IF EXISTS Upperboard_approve_annual;
    DROP PROC IF EXISTS Submit_accidental;
    DROP PROC IF EXISTS Submit_medical;
    DROP PROC IF EXISTS Submit_unpaid;
    DROP PROC IF EXISTS Upperboard_approve_unpaids;
    DROP PROC IF EXISTS Submit_compensation;
    DROP PROC IF EXISTS Dean_andHR_Evaluation;
END

GO
---------------------------------------------------------------------------------------------------------
--2.1(e)
GO

CREATE PROC clearAllTables
AS
BEGIN
    DELETE FROM Role_existsIn_Department;
    DELETE FROM Employee_Approve_Leave;
    DELETE FROM Employee_Replace_Employee;
    DELETE FROM Employee_Phone;
    DELETE FROM Payroll;
    DELETE FROM Performance;
    DELETE FROM Deduction;
    DELETE FROM Document;
    DELETE FROM Compensation_Leave;
    DELETE FROM Unpaid_Leave;
    DELETE FROM Medical_Leave;
    DELETE FROM Accidental_Leave;
    DELETE FROM Annual_Leave;
    DELETE FROM Leave;
    DELETE FROM Employee_Role;
    DELETE FROM Attendance;
    DELETE FROM Employee;
    DELETE FROM Department;
    DELETE FROM Role;

END

GO


---------------------------------------------------------------------------------------------------------
--2.2(a)
GO

CREATE VIEW allEmployeeProfiles
AS
    SELECT employee_ID, first_name,
        last_name, gender, email, address, years_of_experience,
        official_day_off,type_of_contract,employment_status,
        annual_balance, accidental_balance
    FROM EMPLOYEE;

GO
---------------------------------------------------------------------------------------------------------
--2.2(b)
GO

CREATE VIEW NoEmployeeDept
AS
    SELECT E.dept_name, COUNT(E.employee_ID) AS Number_of_Employees
    FROM EMPLOYEE E
    GROUP BY E.dept_name;

GO
---------------------------------------------------------------------------------------------------------
--2.2(c)
GO

CREATE VIEW allPerformance
AS
    SELECT (E.first_name+' ' +E.last_name) AS 'Emplyee Name' , P.*
    FROM PERFORMANCE P , EMPLOYEE E
    WHERE P.emp_ID=E.employee_ID AND semester LIKE 'W%';

GO
---------------------------------------------------------------------------------------------------------
--2.2(d)
GO

CREATE VIEW allRejectedMedicals
AS
    SELECT  M.*
    FROM Leave L , Medical_Leave M
    WHERE L.request_ID = M.request_ID AND L.final_approval_status = 'rejected';

GO
---------------------------------------------------------------------------------------------------------
--2.2(e)
GO

CREATE VIEW allEmployeeAttendance
AS
    SELECT (E.first_name+' ' +E.last_name) AS 'Employee Name' , A.*
    FROM EMPLOYEE E , Attendance A
    WHERE A.emp_ID = E.employee_ID AND DATEDIFF(DAY, A.date , CONVERT(date,CURRENT_TIMESTAMP))=1;

GO
---------------------------------------------------------------------------------------------------------
---2.3(a)
GO

CREATE PROC Update_Status_Doc
AS
    UPDATE Document
    SET status = 'expired'
    WHERE CONVERT(date, CURRENT_TIMESTAMP) > Document.expiry_date;

GO
---------------------------------------------------------------------------------------------------------
--2.3(b)
GO

CREATE PROC Remove_Deductions
AS
    DELETE FROM Deduction
    WHERE Deduction.emp_ID IN(
        SELECT employee_ID
        FROM Employee
        WHERE Employee.employment_status='resigned'
    );

GO
---------------------------------------------------------------------------------------------------------
--2.3(c)
GO

CREATE PROC Update_Employment_Status
@employee_ID int
AS
    DECLARE @isOnLeave BIT;
    SET @isOnLeave = dbo.Is_On_Leave(@employee_ID, EOMONTH(GETDATE(),-1)+1,EOMONTH(GETDATE()));
    IF @isOnLeave=1
        UPDATE EMPLOYEE
        SET employment_status = 'onleave'
        WHERE employee_ID = @employee_ID;
    ELSE
        UPDATE EMPLOYEE
        SET employment_status = 'active'
        WHERE employee_ID = @employee_ID;

GO

---------------------------------------------------------------------------------------------------------
--2.3(d)
GO
CREATE PROC Create_Holiday
    AS
    BEGIN
        CREATE TABLE Holiday(
        holiday_id int IDENTITY(1,1),
        name VARCHAR(50),
        from_date DATE,
        to_date DATE
        );
    END;

GO
---------------------------------------------------------------------------------------------------------
EXEC Create_Holiday;
---------------------------------------------------------------------------------------------------------
--2.3(e)
GO

CREATE PROC Add_Holiday
    @holiday_name VARCHAR(50),
    @from_date DATE,
    @to_date DATE
    AS
        BEGIN
            INSERT INTO Holiday (name, from_date, to_date)
            VALUES (@holiday_name, @from_date, @to_date);
        END

GO
---------------------------------------------------------------------------------------------------------
--2.3(f)
GO

CREATE PROC Intitiate_Attendance
    AS
    BEGIN
        INSERT INTO Attendance(date, check_in_time, check_out_time, emp_ID)
        SELECT CONVERT(DATE,CURRENT_TIMESTAMP), NULL, NULL, E.employee_id
        FROM EMPLOYEE as E;
    END;

GO
---------------------------------------------------------------------------------------------------------
--2.3(g)
GO

CREATE PROC Update_Attendance
    @employee_ID INT,
    @check_in TIME,
    @check_out TIME
AS
    BEGIN
        DECLARE @statusRes VARCHAR(50);
        IF @check_in IS NULL
            SET @statusRes = 'absent';
        ELSE
            SET @statusRes = 'attended';

        UPDATE Attendance
        SET check_in_time = @check_in , check_out_time = @check_out , status=@statusRes
        WHERE emp_ID = @employee_ID AND date = CONVERT(DATE,CURRENT_TIMESTAMP);
    END

GO
---------------------------------------------------------------------------------------------------------
--DROP PROC Update_Attendance;
---------------------------------------------------------------------------------------------------------
--2.3(h)
GO

CREATE PROC Remove_Holiday
AS
    DELETE A
    FROM Attendance A
    INNER JOIN HOLIDAY H ON A.date >= H.from_date AND A.date <= H.to_date;
GO
---------------------------------------------------------------------------------------------------------
--2.3(j)
GO
CREATE PROC Remove_Approved_Leaves 
@Employee_id int 
    AS 
     BEGIN
    Delete A from attendance A
    INNER JOIN Leave L 
    ON A.date BETWEEN L.start_date AND L.end_date
    WHERE L.final_approval_status='approved'
    and L.request_ID IN(
        SELECT request_ID FROM Annual_Leave WHERE emp_ID=@Employee_id
        UNION 
        SELECT request_ID FROM Accidental_Leave WHERE emp_ID=@Employee_id
        UNION
        SELECT request_ID FROM Medical_Leave WHERE emp_ID=@Employee_id
        UNION
        SELECT request_ID FROM Unpaid_Leave WHERE emp_ID=@Employee_id
        UNION
        SELECT request_ID FROM Compensation_Leave WHERE emp_ID=@Employee_id
    );
    
    END;
    GO

-- DROP PROC Remove_Approved_Leaves;
---------------------------------------------------------------------------------------------------------
--2.3(k)
GO
CREATE PROC Replace_Employee
    @Emp1_ID INT,
    @Emp2_ID INT,
    @from_date DATE,
    @to_date DATE
    AS
BEGIN
    INSERT INTO Employee_Replace_Employee (Emp1_ID, Emp2_ID, from_date, to_date)
    VALUES (@Emp1_ID, @Emp2_ID, @from_date,@to_date);
End;


-----------------------------------------------------------------------------------------------------

--2.4 a
GO
CREATE FUNCTION HRLoginValidation(@employee_id int, @password varchar(50))
returns bit
as
begin
declare @success bit;
if exists(
select e.employee_id, e.password from Employee as e
where e.employee_id=@employee_id and e.password=@password)
set @success=1;
else
set @success=0;
return @success;
end

-----------------------------------------------------------------------------------------------------------
--2.4 b
-- Approve/reject annual/accidental leaves based on the employee’s balance.
go

create proc HR_approval_an_acc
    @request_id int,
    @HR_id int
as
begin
    declare @AnnOrAcc bit;
    declare @Approved bit;
    declare @balance int;
    declare @days int;
    declare @diff int;
    declare @emp int;
    declare @AccSa7 bit;
    declare @reqDate date;
    declare @startdate date;

    begin
        if exists(select * from annual_leave where request_id=@request_id)
            set @AnnOrAcc = 1
        else
            set @AnnOrAcc = 0

        select @days = l.num_days, @reqDate = l.date_of_request, @startdate = l.start_date 
        from [leave] l
        where l.request_id = @request_id

        if @AnnOrAcc = 1
            select @balance = e1.annual_balance, @emp = e1.employee_id 
            from [leave] l1 
            inner join annual_leave an on l1.request_id = an.request_id 
            inner join employee e1 on an.emp_id = e1.employee_id
            where l1.request_id = @request_id
        else
            select @balance = e2.accidental_balance, @emp = e2.employee_id 
            from [leave] l2 
            inner join accidental_leave ac on l2.request_id = ac.request_id 
            inner join employee e2 on ac.emp_id = e2.employee_id
            where l2.request_id = @request_id

        set @diff = @balance - @days
        
        -- get current date or use start date????
        if @AnnOrAcc = 0 and (@days > 1 or DATEDIFF(HOUR, @reqDate, @startdate) > 48)
            set @AccSa7 = 0
        else
            set @AccSa7 = 1

        if @diff < 0 or @AccSa7 = 0
            update employee_approve_leave
            set status = 'rejected' 
            where leave_id = @request_id and emp1_id = @HR_id
        else
            update employee_approve_leave
            set status = 'approved' 
            where leave_id = @request_id and emp1_id = @HR_id

        if not exists(select * from employee_approve_leave eal1
        where eal1.leave_id = @request_id and eal1.status = 'rejected')
            set @Approved = 1
        else 
            set @Approved = 0

        if @Approved = 1 and @AnnOrAcc = 1
        begin
            update employee set annual_balance = @diff where employee_id = @emp
            update [leave] set final_approval_status = 'approved' where request_id = @request_id
        end
        else if @Approved = 1 and @AnnOrAcc = 0
        begin
            update employee set accidental_balance = @diff where employee_id = @emp
            update [leave] set final_approval_status = 'approved' where request_id = @request_id
        end
        else
        begin
            update [leave] set final_approval_status = 'rejected' where request_id = @request_id
        end
    end
end

go

-----------------------------------------------------------------------------------------------------------
--2.4 c
--Approve/reject unpaid leaves.
go

create proc HR_approval_unpaid
@request_id int,
@HR_id int
as
begin
declare @emp int;
declare @date date;
declare @days int;
declare @dayscheck bit;
declare @oneperyear bit;
declare @count int;
declare @balance int;
declare @balancecheck bit;

select @days=l.num_days, @date=l.start_date from leave l
where l.request_id=@request_id

select @emp = ul.emp_id from unpaid_leave ul
where ul.request_id=@request_id

select @balance = e.annual_balance from employee e
where e.employee_id = @emp

--if @balance > 0
--    set @balancecheck = 0; -- must the annual balance be 0? or optional? TA still didnt reply !!!
--else 
    set @balancecheck = 1; 

if @days>30
set @dayscheck = 0;
else 
set @dayscheck = 1;

if exists (select * from unpaid_leave u inner join leave l1 on u.request_id=l1.request_id
where u.emp_id=@emp and year(@date)=year(l1.start_date) and l1.request_id <> @request_id and l1.final_approval_status='approved')
set @oneperyear = 0;
else
set @oneperyear = 1;

if @balancecheck=1 and @dayscheck=1 and @oneperyear=1
update employee_approve_leave
            set status = 'approved' 
            where leave_id = @request_id and emp1_id = @HR_id
else
update employee_approve_leave
            set status = 'rejected' 
            where leave_id = @request_id and emp1_id = @HR_id

if not exists (select * from employee_approve_leave eal
where eal.leave_id=@request_id and eal.status= 'rejected')
update leave
set final_approval_status = 'approved' where request_id= @request_id;
else
begin
update leave
set final_approval_status = 'rejected' where request_id = @request_id;
end
end
go

-----------------------------------------------------------------------------------------------------------
-- 2.4 d
-- Approve/reject compensation leaves.

go

create proc HR_approval_comp
@request_id int,
@HR_ID int
as
begin
declare @check8 bit;
declare @checkmonth bit;
declare @checkrep bit;
declare @emp int;
declare @dateagaza date;
declare @startdate date;
declare @repdayoff varchar(50);
declare @emprep int;

select @emp=c.emp_id, @dateagaza=c.date_of_original_workday, @emprep=c.replacement_emp from compensation_leave c
where c.request_id= @request_id

select @startdate=l.start_date from leave l
where l.request_id= @request_id

select @repdayoff= e.official_day_off from employee e
where e.employee_id = @emprep

if exists(select * from attendance a
where a.emp_id=@emp and a.date = @dateagaza and total_duration>= 8)
set @check8 = 1;
else
set @check8=0;

if month(@dateagaza)=month(@startdate)
set @checkmonth=1;
else
set @checkmonth=0;

if @repdayoff= datename(weekday,@startdate)
set @checkrep = 1;
else
set @checkrep = 0;

if @check8=1 and @checkmonth=1 and @checkrep=1
update employee_approve_leave
            set status = 'approved' 
            where leave_id = @request_id and emp1_id = @HR_id;
else
update employee_approve_leave
            set status = 'rejected' 
            where leave_id = @request_id and emp1_id = @HR_id;

if not exists (select * from employee_approve_leave eal
where eal.leave_id=@request_id and eal.status= 'rejected')
update leave
set final_approval_status = 'approved' where request_id= @request_id;
else
update leave
set final_approval_status = 'rejected' where request_id = @request_id;

end

go

-----------------------------------------------------------------------------------------------------------
--2.4 e
--Add deduction due to missing hours. While adding the deduction, reference the attendance_id of the first record of the month that has less than 8 hours.
GO
CREATE PROC Deduction_hours
@employee_ID int
AS
BEGIN
    DECLARE @attid int,
            @date date,
            @summins int,
            @rate decimal(10,2);

    SET @date = GETDATE();

    SELECT TOP 1 @attid = a.attendance_id
    FROM attendance a
    WHERE a.emp_id = @employee_ID
      AND a.total_duration IS NOT NULL  
      AND a.total_duration < 480
      AND MONTH(a.date) = MONTH(@date)
      AND YEAR(a.date) = YEAR(@date)
    ORDER BY a.attendance_id;

    IF @attid IS NULL
        RETURN;

    SELECT @summins = SUM(480 - a1.total_duration)
    FROM attendance a1
    WHERE a1.emp_id = @employee_ID
      AND a1.total_duration IS NOT NULL
      AND a1.total_duration < 480
      AND MONTH(a1.date) = MONTH(@date)
      AND YEAR(a1.date) = YEAR(@date);

    EXEC rate_per_hour @employee_ID, @rate OUTPUT;

    INSERT INTO deduction(emp_id, date, amount, type, status, unpaid_id, attendance_id) 
    VALUES (@employee_ID, @date, (@summins * @rate / 60), 'missing_hours', 'pending', NULL, @attid);

END;
GO

-----------------------------------------------------------------------------------------------------------
--2.4(f)
CREATE PROC rate_per_hour
    @employee_ID int, @rate decimal (10,2) OUTPUT
    AS
    SELECT @rate =MAX(salary) / (22*8)
    FROM EMPLOYEE E
    WHERE E.employee_ID = @employee_ID;
GO

 CREATE PROC Deduction_days
@employee_ID int
AS
    DECLARE @rate decimal (10,2);
    DECLARE @amount decimal (10,2);

    EXEC rate_per_hour @employee_ID, @rate OUTPUT;
    set @amount= @rate * 8;
    INSERT INTO Deductions (emp_ID, date, amount,type, status, unpaid_ID, attendance_ID)
SELECT
    A.emp_ID, A.date,@amount, 'missing_days', 'pending', NULL, A.attendance_ID      -- from Attendance table
FROM Attendance A
WHERE A.status = 'absent'
  AND MONTH(A.date) = MONTH(CURRENT_TIMESTAMP);
GO

--DROP PROC Deduction_days;
--DROP PROC rate_per_hour;

-----------------------------------------------------------------------------------------------------------
--2.4 g
GO
CREATE PROC Deduction_unpaid
@employee_ID int
AS
DECLARE @start date;
DECLARE @end date;
DECLARE @duration1 int;
DECLARE @duration2 int;
DECLARE @amount1 int;
DECLARE @amount2 int;
DECLARE @rate decimal (10,2);
DECLARE @unID int;
-- TOP1
SELECT @start=L.start_date, @end= L.end_date, @unID = L.request_ID
FROM Unpaid_Leave U LEFT OUTER JOIN Leave L ON U.request_ID = L.request_ID
WHERE U.emp_ID = @employee_ID AND (MONTH(@start)= MONTH(CURRENT_TIMESTAMP) OR MONTH(@end)= MONTH(CURRENT_TIMESTAMP));
EXEC rate_per_hour @employee_ID, @rate OUTPUT;
IF MONTH(@start) = MONTH(@end)
BEGIN
    SET @duration1 = DATEDIFF(day, @start, @end);

    SET @amount1 = @rate * @duration1;
    INSERT INTO Deduction
    VALUES (@employee_ID, @start,@amount1, 'unpaid', 'pending', @unID, NULL);
END

ELSE
IF MONTH(@start) = MONTH(CURRENT_TIMESTAMP)
BEGIN
    SET @duration1 = DATEDIFF(day, @start, EOMONTH(@start));
    SET @amount1 = @rate * @duration1;
    INSERT INTO Deduction
    VALUES (@employee_ID, @start,@amount1, 'unpaid', 'pending',@unID, NULL);
    END
ELSE
    BEGIN
    SET @duration2 = DAY(@end);
    SET @amount2 = @rate * @duration2;
    INSERT INTO Deduction
    VALUES (@employee_ID, @start,@amount2, 'unpaid', 'pending',@unID, NULL);
    END

    GO

-----------------------------------------------------------------------------------------------------------

--2.4  h
CREATE PROC Bonus_amount
@employee_ID int, @bonus_amount decimal(10,2) OUTPUT
AS
    DECLARE @overtime_total int;
    DECLARE @total_hours decimal (10,2);
    DECLARE @rate decimal (10,2);
    DECLARE @overtime_fac decimal (10,2);

    EXEC rate_per_hour @employee_ID, @rate OUTPUT;

    SELECT @total_hours= (SUM(A.total_duration)*COUNT(*)/3600)- COUNT(*)*8
    FROM Attendance A
    WHERE A.emp_ID = @employee_ID;
    SELECT @overtime_fac= MAX(R.percentage_overtime)
    FROM Employee_Role ER INNER JOIN ROLE R ON ER.role_name = R.role_name
    WHERE ER.emp_ID = @employee_ID ;

    SET @bonus_amount= @rate * @overtime_fac * @total_hours/100;------2.5.a

GO
CREATE FUNCTION EmployeeLoginValidation
    (@employee_ID int,
    @password varchar(50))
    RETURNS BIT
    AS
    BEGIN
        DECLARE @success BIT;
        DECLARE @curr_password VARCHAR(50);
        SET @curr_password = (SELECT password
                                FROM EMPLOYEE
                                WHERE employee_ID = @employee_ID);
        IF @curr_password = @password
            SET @success = 1
        ELSE
            SET @success = 0
        RETURN @success
    END
GO

-----------------------------------------------------------------------------------
--2.4 i
GO

---------------------------------------------------------------------------------------------------------
--2.5.a
GO
CREATE FUNCTION EmployeeLoginValidation
    (@employee_ID int,
    @password varchar(50))
    RETURNS BIT
    AS
    BEGIN
        DECLARE @success BIT;
        DECLARE @curr_password VARCHAR(50);
        SET @curr_password = (SELECT password
                                FROM EMPLOYEE 
                                WHERE employee_ID = @employee_ID);
        IF @curr_password = @password
            SET @success = 1
        ELSE
            SET @success = 0
        RETURN @success
    END
GO


---------------------------------------------------------------------------------------------------------
------2.5.b
GO
CREATE FUNCTION  MyPerformance
    (@employee_ID int,
    @semester char(3))
    RETURNS TABLE
    AS
    RETURN
    (
        SELECT *
        FROM Performance
        WHERE emp_ID = @employee_ID AND semester = @semester
    )
GO

---------------------------------------------------------------------------------------------------------
------2.5.c
GO
CREATE FUNCTION MyAttendance
    (@employee_ID int)
    RETURNS TABLE
    AS
    RETURN
    (
        SELECT *
        FROM Attendance A
        WHERE A.emp_ID = @employee_ID AND MONTH(A.date) = MONTH(CURRENT_TIMESTAMP)

        EXCEPT
               (SELECT A.*
                FROM Attendance A , EMPLOYEE E
                WHERE A.emp_ID = E.employee_ID AND E.official_day_off = DATENAME(WEEKDAY,A.date)
                )
    )
GO

--DROP FUNCTION MyAttendance
---------------------------------------------------------------------------------------------------------
------2.5.d
GO
CREATE FUNCTION Last_month_payroll
    (@employee_ID int)
    RETURNS TABLE
    AS
    RETURN
    (
        SELECT *
        FROM Payroll
        WHERE emp_ID = @employee_ID AND MONTH(from_date) = MONTH(CURRENT_TIMESTAMP)-1
    )
GO

--DROP FUNCTION Last_month_payroll;
---------------------------------------------------------------------------------------------------------
------2.5.e
GO
CREATE FUNCTION Deductions_Attendance
    (@employee_ID int,
    @month int)
    RETURNS TABLE
    AS
    RETURN
    (
        SELECT *
        FROM Deduction
        WHERE emp_ID = @employee_ID AND MONTH(date) = @month AND type = 'missing_days'
    )
GO
---------------------------------------------------------------------------------------------------------

--2.5 f
GO
CREATE FUNCTION Is_On_Leave
(
    @employee_ID INT,
    @from  DATE,
    @to    DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @is_on_leave BIT=0;

    IF EXISTS (
        SELECT *
        FROM Leave L
        LEFT JOIN Annual_Leave A  ON A.request_ID = L.request_ID
        LEFT JOIN Accidental_Leave Ac ON Ac.request_ID = L.request_ID
        LEFT JOIN Medical_Leave M  ON M.request_ID = L.request_ID
        LEFT JOIN Unpaid_Leave U  ON U.request_ID = L.request_ID
        LEFT JOIN Compensation_Leave C ON C.request_ID = L.request_ID
        WHERE (
                A.emp_ID  = @employee_ID OR
                Ac.emp_ID = @employee_ID OR
                M.emp_ID  = @employee_ID OR
                U.emp_ID  = @employee_ID OR
                C.emp_ID  = @employee_ID
            )
            AND L.final_approval_status <> 'rejected'
            AND NOT (L.end_date < @from OR L.start_date > @to)
    )
    BEGIN
        SET @is_on_leave = 1;
    END

    RETURN @is_on_leave;
END
GO
-----------------------------------------------------------------------------------------
--2.5 g
GO
GO
CREATE PROC Submit_annual
    @employee_ID INT,
    @replacement_emp INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    DECLARE @request_ID INT;
    DECLARE @requester_rank INT;
    DECLARE @requester_dept VARCHAR(50);

    SELECT @requester_rank = MIN(r.rank)
    FROM Employee_Role er JOIN Role r
    ON r.role_name = er.role_name
    WHERE er.emp_ID = @employee_ID;

    SELECT @requester_dept = dept_name
    FROM Employee
    WHERE employee_ID = @employee_ID;

    INSERT INTO Leave (date_of_request, start_date, end_date, final_approval_status)
    VALUES (GETDATE(), @start_date, @end_date, 'pending');
    SET @request_ID = SCOPE_IDENTITY();
    INSERT INTO Annual_Leave (request_ID, emp_ID, replacement_emp)
    VALUES (@request_ID, @employee_ID, @replacement_emp);

    INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
    (SELECT e.employee_ID, @request_ID, 'pending'
    FROM Employee e JOIN Employee_Role er
    ON e.employee_ID = er.emp_ID
    JOIN Role r ON r.role_name = er.role_name
    WHERE e.dept_name = @requester_dept
        AND e.employee_ID <> @employee_ID
      AND r.rank IS NOT NULL
        AND r.rank < @requester_rank );
END
GO

-------------------------------------------------------------------------------------------
--2.5 h

go
create function Status_leaves(@employee_ID int)
returns table
as
    return(
        select l.request_id, l.date_of_request, l.final_approval_status as status from leave l
    where month(l.start_date) = month(getdate())
    and YEAR(l.start_date) = YEAR(getdate())
    and l.request_id in (
        select ac.request_id from accidental_leave ac
    where ac.emp_id= @employee_id union select an.request_id from annual_leave an
    where an.emp_id=@employee_id))

go

----------------------------------------------------------------------------------------------------------
--2.5 i
CREATE PROC Upperboard_approve_annual
    @request_ID INT,
    @Upperboard_ID INT,
    @replacement_ID INT
AS
BEGIN
    DECLARE @emp_ID INT;
    DECLARE @emp_dept VARCHAR(50);
    DECLARE @rep_dept VARCHAR(50);
    DECLARE @is_rep_on_leave BIT;

    SELECT @emp_ID = an.emp_ID
    FROM Annual_Leave an
    WHERE an.request_ID = @request_ID;

    SELECT @emp_dept = e.dept_name
    FROM Employee e
    WHERE e.employee_ID = @emp_ID;

    SELECT @rep_dept = e2.dept_name
    FROM Employee e2
    WHERE e2.employee_ID = @replacement_ID;

    SET @is_rep_on_leave = dbo.Is_On_Leave(@replacement_ID,
                                          (SELECT l.start_date
                                           FROM Leave l
                                           WHERE l.request_ID = @request_ID),
                                          (SELECT l.end_date
                                           FROM Leave l
                                           WHERE l.request_ID = @request_ID));

    IF @emp_dept = @rep_dept AND @is_rep_on_leave = 0
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = 'approved'
        WHERE Emp1_ID = @Upperboard_ID AND Leave_ID = @request_ID;

        UPDATE Leave
        SET final_approval_status = 'approved'
        WHERE request_ID = @request_ID;
    END
    ELSE
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = 'rejected'
        WHERE Emp1_ID = @Upperboard_ID AND Leave_ID = @request_ID;

        UPDATE Leave
        SET final_approval_status = 'rejected'
        WHERE request_ID = @request_ID;
    END
END
GO

-----------------------------------------------------------------------------------------------------------
--2.5 j

GO
CREATE PROC Submit_accidental
    @employee_ID INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    DECLARE @request_ID INT;
    DECLARE @requester_rank INT;
    DECLARE @requester_dept VARCHAR(50);

    SELECT @requester_rank = MIN(r.rank)
    FROM Employee_Role er JOIN Role r
    ON r.role_name = er.role_name
    WHERE er.emp_ID = @employee_ID;

    SELECT @requester_dept = dept_name
    FROM Employee
    WHERE employee_ID = @employee_ID;

    INSERT INTO Leave (date_of_request, start_date, end_date, final_approval_status)
    VALUES (GETDATE(), @start_date, @end_date, 'pending');

    INSERT INTO Accidental_Leave (request_ID, emp_ID)
    VALUES (@request_ID, @employee_ID);

    INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
    (SELECT DISTINCT e.employee_ID, @request_ID, 'pending'
    FROM Employee e JOIN Employee_Role er
    ON e.employee_ID = er.emp_ID

    JOIN Role r
    ON r.role_name = er.role_name

    WHERE e.dept_name = @requester_dept
        AND e.employee_ID <> @employee_ID
        AND r.rank < @requester_rank) ;
END
GO

---------------------------------------------------------------------------------------------------------
--2.5 k
GO
CREATE PROCEDURE Submit_medical
@employee_ID INT,
@start_date date,
@end_date date,
@type varchar(50),
@insurance_status bit,
@disability_details varchar(50),
@document_description varchar(50),
@file_name varchar(50)
AS
BEGIN
INSERT INTO Leave (date_of_request, start_date, end_date, final_approval_status)
    VALUES(GETDATE(),@start_date, @end_date,'pending');
DECLARE @reqID INT = SCOPE_IDENTITY();

INSERT INTO Medical_Leave(request_ID, insurance_status, disability_details, type, Emp_ID)
    VALUES (@reqID, @insurance_status, @disability_details, @type, @employee_ID);

INSERT INTO Document(type, description, file_name, creation_date, expiry_date, status, emp_ID, medical_ID, unpaid_ID)
    VALUES ('medical', @document_description, @file_name, GETDATE(), NULL, 'valid', @employee_ID, @reqID, NULL);
DECLARE @document_ID INT = SCOPE_IDENTITY();

INSERT INTO Employee_Approve_Leave(EMP1_ID, Leave_ID, status)
SELECT e.employee_ID, @reqID, 'pending' --is it pending?
FROM Employee E
INNER JOIN Employee_Role ER ON ER.emp_ID=E.employee_ID
where ER.role_name='Medical Doctor';

INSERT INTO Employee_Approve_Leave(Emp1_ID,Leave_ID, status)
SELECT E.employee_ID, @reqID, 'pending'
    FROM Employee E
    INNER JOIN Employee_Role R ON E.employee_ID = R.emp_ID
    WHERE R.role_name LIKE 'HR_Representative%';
END

GO
--DROP PROCEDURE Submit_medical;
GO
------------------------------------------------------------------------------------------
--2.5 l
CREATE PROCEDURE Submit_unpaid
@employee_ID INT,
@start_date DATE,
@end_date date,
@document_description varchar(50),
@file_name varchar(50)
AS 
BEGIN
INSERT INTO Leave(date_of_request, start_date, end_date, final_approval_status)
    VALUES (GETDATE(), @start_date, @end_date, 'pending');
DECLARE @req_ID INT = SCOPE_IDENTITY();
INSERT INTO Unpaid_Leave(request_ID,emp_ID)
Values(@req_ID, @employee_ID);
INSERT INTO Document(type, description, file_name, creation_date, expiry_date, status, emp_ID, medical_ID, unpaid_ID)
    VALUES ('memo', @document_description, @file_name, GETDATE(), NULL, 'valid', @employee_ID, NULL, @req_ID);

INSERT INTO Employee_Approve_leave(Emp1_ID, Leave_ID, status)
SELECT E.employee_ID, @req_ID, 'pending'
FROM
EMPLOYEE E INNER JOIN Employee_Role ER
ON
E.employee_ID=ER.emp_ID
INNER JOIN Role R ON R.role_name= ER.role_name
WHERE R.rank<=4 and R.rank IS NOT NULL

INSERT INTO Employee_Approve_Leave(Emp1_ID, Leave_ID, status)
    SELECT E.employee_ID, @req_ID, 'pending'
    FROM Employee E
    JOIN Employee_Role R ON E.employee_ID = R.emp_ID
    WHERE R.role_name LIKE 'HR_Representative%';
END

--DROP PROCEDURE Submit_unpaid;

GO

------------------------------------------------------------------------
--2.5 m

GO
CREATE PROCEDURE Upperboard_approve_unpaids
    @request_ID INT,
    @Upperboard_ID INT
AS
BEGIN
    DECLARE @memoCount INT;

    --here i get the the memos that are valid 
    SELECT @memoCount = COUNT(*)
    FROM Document
    WHERE unpaid_ID = @request_ID
      AND status = 'valid'
      AND type = 'memo';  
    -- hena i check if there exists a memo, approve
    IF (@memoCount >= 1)
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = 'approved'
        WHERE Emp1_ID = @Upperboard_ID
          AND Leave_ID = @request_ID
          AND status = 'pending';
    END
    ELSE
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = 'rejected'
        WHERE Emp1_ID = @Upperboard_ID
          AND Leave_ID = @request_ID
          AND status = 'pending';
    END
END
GO

---------------------------------------------------------------------------------------
--2.5 n
GO
CREATE PROCEDURE Submit_compensation
@employee_ID int,
@compensation_date date,
@reason varchar(50),
@date_of_original_workday date,
@replacement_emp int
AS
BEGIN
INSERT INTO Leave(date_of_request, start_date, end_date, final_approval_status)
    VALUES (GETDATE(), @compensation_date, @compensation_date, 'pending');
    DECLARE @reqID INT = SCOPE_IDENTITY();
INSERT INTO Compensation_Leave(request_ID, reason, date_of_original_workday, emp_ID, replacement_emp)
    VALUES (@reqID, @reason, @date_of_original_workday, @employee_ID, @replacement_emp);
INSERT INTO Employee_Approve_Leave(Emp1_ID, Leave_ID, status)
    SELECT E.employee_ID, @reqID, 'pending'
    FROM Employee E
    JOIN Employee_Role R ON E.employee_ID = R.emp_ID
    WHERE R.role_name LIKE 'HR_Representative%';
END
GO

----------------------------------------------------------------------------------------
--2.5 O
CREATE PROCEDURE Dean_andHR_Evaluation
@employee_ID int,
@rating int,
@comment varchar(50),
@semester char(3)

AS
BEGIN
INSERT INTO Performance(rating, comments, semester, emp_ID)
VALUES(@rating, @comment, @semester, @employee_ID);
END

GO


