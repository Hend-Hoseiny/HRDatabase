CREATE DATABASE University_HR_ManagementSystem_Team_No_27;

USE University_HR_ManagementSystem_Team_No_27;
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

DROP PROC createAllTables;

EXEC createAllTables;

GO
CREATE VIEW allEmployeeProfiles 
AS
SELECT employee_ID, first_name, 
last_name, gender, email, addresse, years_of_experience, 
official_day_off,type_of_contract,employment_status, 
annual_balance, accidental_balance�
FROM�EMPLOYEE;


--2.4 a
GO
CREATE FUNCTION HRLoginValidation(@employee_id int, @password varchar(50))
returns bit
as
begin
declare @success bit
if exists(
select e.employee_id, e.password from Employee as e
where e.employee_id=@employee_id and e.password=@password)
set @success='0'
else
set @success='1'
return @success
end


--2.4 b deepseek correct spacing

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

    if exists(select * from employee_approve_leave 
    where emp1_id=@HR_id and leave_id=@request_id)
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

--2.4 c
go
create proc HR_approval_unpaid
@request_id int,
@HR_id int
as
begin
declare @emp int;
declare @date date;
declare @doc bit;
declare @days int;
declare @dayscheck bit;
declare @oneperyear bit;
declare @count int;

if exists(select * from document d
where d.unpaid_leave=@request_id)
set @doc=1;
else
set @doc=0;

select @days=l.num_days, @date=l.start_date from leave l
where l.request_id=@request_id

select @emp = ul.emp_id from unpaid_leave ul
where ul.request_id=@request_id

if @days<=30
set @dayscheck = 1;
else 
set @dayscheck = 0;

--bas what if akhad agaza that extends from one year to the next do i have to check end date too
if exists (select * from unpaid_leave u inner join leave l1 on u.request_id=l1.request_id
where u.emp_id=@emp and year(@date)=year(l1.start_date) and l1.request_id <> @request_id)
set @oneperyear = 0;
else
set @oneperyear = 1;

if @doc=1 and @dayscheck=1 and @oneperyear=1
update employee_approve_leave
            set status = 'approved' 
            where leave_id = @request_id and emp1_id = @HR_id
else
update employee_approve_leave
            set status = 'rejected' 
            where leave_id = @request_id and emp1_id = @HR_id

if not exists (select * from employee_approve_leave eal
where eal.emp1_id=@HR_id and eal.leave_id=@request_id and eal.status= 'rejected')
update leave
set final_approval_status = 'approved' where request_id= @request_id;
else
update leave
set final_approval_status = 'rejected' where request_id = @request_id;

end
go

--2.4 d

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
where eal.emp1_id=@HR_id and eal.leave_id=@request_id and eal.status= 'rejected')
update leave
set final_approval_status = 'approved' where request_id= @request_id;
else
update leave
set final_approval_status = 'rejected' where request_id = @request_id;

end

--2.4 e
go
create proc Deduction_hours
@employee_ID int
as
begin
declare @attid int,
@date date,
@sumhours int,
@rate decimal(10,2);

select top 1 @attid=a.attendance_id, @date=a.date from attendance a
where a.emp_id=@employee_id and a.total_duration < 8 and MONTH(a.date) = MONTH(GETDATE()) and YEAR(a.date) = YEAR(GETDATE()) order by a.attendance_id

IF @attid IS NULL
        RETURN; --no missing hours?

select @sumhours = sum(8 - a1.total_duration) from attendance a1
where a1.emp_id=@employee_id and a1.total_duration < 8 and MONTH(a1.date) = MONTH(GETDATE()) and YEAR(a1.date) = YEAR(GETDATE());

EXEC rate_per_hour @employee_ID, @rate OUTPUT;

insert into deduction(emp_id, date, amount, type, status, unpaid_id, attendance_id)
values (@employee_id, @date, (@sumhours*@rate), 'missing_hours', 'pending', null, @attid );

end;