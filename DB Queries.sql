				/*-------------------- Wilco DDL Statements ------------------*/


create database [Wilco Construction]
use [Wilco Construction]

create table SUPERVISOR(
SupervisorID int not null identity(100,1),
SLastName char(25) not null,
SFirstName char(25) not null,
TelephoneNo char(25) not null,
constraint SUPERVISOR_PK primary key(SupervisorID)
);

create table [CONTRACT](
ContractNumber char(20) not null unique,
ContractorName char(50) not null,
ContractorLocation char(50) null,
EEOC_Cert bit not null,
ExpiryDate date not null,
constraint CONTRACT_PK primary key(ContractNumber)
);

create table INVENTORY_CATEGORY(
CategoryID int not null identity(200,1),
CategoryName char(25) not null,
constraint INV_CAT_PK primary key(CategoryID)
);


create table TAX(
TaxID int not null identity(300,1),
WeeklyPayRangeStart decimal(8,4) not null,
WeeklyPayRangeEnd decimal(8,4) not null,
MaritalStatus char(20) not null,
FederalTaxPercent numeric(8,2) not null,
StateTaxPercent numeric(8,2) not null,
SSNTaxPercent numeric(8,2) not null
constraint TAX_PK primary key(TaxID)
);


create table EEOC(
EEOC_Code int not null identity(400,1),
Ethnicity char(50) not null,
constraint EEOC_PK primary key(EEOC_Code)
);



create table JOB(
JobCode char(20) not null unique,
JobClassification char(25) not null
constraint JOB_PK primary key (JobCode)
);


create table EMPLOYEE(
EmployeeID int not null identity(10000,1),
EEOC_Code int not null,
LastName char(25) not null,
FirstName char(25) not null,
MI char(25) null,
Street varchar(50) null,
City char(25) null,
State char(25) null,
Zipcode char(10) null,
TelephoneNo char(25) not null unique,
[DOB] date not null,
Gender char(10) not null,
MaritalStatus char(10) not null,
SSN char(20) not null unique,
constraint EMPLOYEE_PK primary key(EmployeeID),
constraint EMPLOYEE_EEOC_FK foreign key(EEOC_Code) references EEOC(EEOC_Code),
constraint ValidGender check(Gender='Male' or Gender='Female')
);



create table PROJECT(
ProjectNumber char(20) not null,
SupervisorID int not null,
ProjectLocation char(100) not null,
ProjectDescription char(100) not null,
constraint PRO_SUP_FK foreign key (SupervisorID) references Supervisor(SupervisorID),
constraint PROJECT_PK primary key (ProjectNumber)
);


create table PROJECT_CONTRACT(
ContractNumber char(20) not null,
ProjectNumber char(20) not null,
constraint PCON_C_FK foreign key (ContractNumber) references Contract(ContractNumber),
constraint PCON_P_FK foreign key (ProjectNumber) references Project(ProjectNumber),
constraint PCON_PK primary key(ContractNumber,ProjectNumber)
);



create table INVENTORY(
InventoryID int not null identity(30000,1),
CategoryID int not null,
InventoryName char(50) not null unique,
IsRented bit  null,
LastMaintainDate date null,
constraint INVENTORY_C_FK foreign key(CategoryID) references INVENTORY_CATEGORY(CategoryID),
constraint INVENTORY_PK primary key(InventoryID)
);


create table INVENTORY_USAGE(
UsageID int not null identity(40000,1),
ProjectNumber char(20) not null,
EmployeeID int not null,
InventoryID int not null,
[Date] date not null,
CheckoutTime time not null,
CheckinTime time null,
constraint IU_P_FK foreign key(ProjectNumber) references PROJECT(ProjectNumber),
constraint IU_E_FK foreign key(EmployeeID) references EMPLOYEE(EmployeeID),
constraint IU_I_FK foreign key(InventoryID) references INVENTORY(InventoryID),
constraint IU_PK primary key (UsageID)
);


create table PAY_SCALE(
PsID int not null identity(500,1),
JobCode char(20) not null,
ProjectNumber char(20) not null,
TotalHoursRequired decimal(4,1) not null,
BasicRate numeric(8,2) not null,
OvertimeRate numeric(8,2) not null default 0,
Fringe numeric(8,2) not null,
constraint PS_J_FK foreign key (JobCode) references JOB(JobCode),
constraint PS_P_FK foreign key (ProjectNumber) references PROJECT(ProjectNumber),
constraint PS_PK primary key(PsID)
); 


create table PAY_CALCULATION(
DailyPayID int not null identity(50000,1),
EmployeeID int not null,
PsID int not null,
[Date] date not null,
CheckinTime time not null,
CheckoutTime time null,
TotalHours decimal(4,1) null,
BasicHours decimal(4,1) null,
BasicPay decimal(4,1) null,
OvertimeHours decimal(4,1)  null,
OvertimePay decimal(4,1) null,
constraint PC_E_FK foreign key (EmployeeID) references Employee(EmployeeID),
constraint PC_PS_FK foreign key (PsID) references PAY_SCALE(PsID) 
							on delete no action on update no action,
constraint PC_PK primary key(DailyPayID)
);



create table PROJECT_HOURS(
[Date] date not null,
PsID int not null,
MinorityMHours decimal(8,4) not null,
MinorityFHours decimal(8,4) not null,
NonMinorityMHours decimal(8,4) not null,
NonMinorityFHours decimal(8,4) not null,
MinorityWorkPercent decimal(8,4) not null,
FemaleWorkPercent decimal(8,4) not null,
constraint PH_PK primary key ([Date],psID),
constraint PH_PSC_FK foreign key (PsID) references PAY_SCALE(PsID)
);


create table WEEK_PAYMENT(
PaymentID int not null identity(20000,1),
EmployeeID int not null,
TaxID int not null,
PayPeriodStartDate date not null,
PayPeriodEndDate date not null,
GrossPay decimal(8,4) not null,
FederalTaxAmount decimal(8,4) not null,
StateTaxAmount decimal(8,4) not null,
SSNTaxAmount decimal(8,4) not null,
TotalTaxAmount decimal(8,4) not null,
OtherDeduction decimal(8,4) not null,
TotalDeduction decimal(8,4) not null,
NetPay decimal(8,4) not null ,
CheckNumber char(20) not null,
PaymentDate date not null,
constraint WP_E_FK foreign key (EmployeeID) references EMPLOYEE(EmployeeID),
constraint WP_T_FK foreign key (TaxID) references Tax(TaxID),
constraint WP_PK primary key (PaymentID)
);



				/*-------------------- Wilco DML Statements ------------------*/


/* Supervisor table insert */
insert into SUPERVISOR values(
'Wilson', 'Jack', '837-373-6654');


insert into SUPERVISOR values(
'Wilson', 'Rob', '432-222-6674');


insert into SUPERVISOR values(
'Borman', 'Frank', '254-111-6565');



/* Contract table insert */

insert into CONTRACT values(
'31-0646843', 'Wilco Construction Company', 'Knockemstiff,Ohio 80286,Ross County',1,'31-Dec-1995');


insert into CONTRACT values(
'30-0646000', 'Wilco Construction Company', 'Knockemstiff,Ohio 80286,Ross County',1,'31-Dec-2000');


/*INVENTORY_CATEGORY table insert */

insert into INVENTORY_CATEGORY values('Materials');

insert into INVENTORY_CATEGORY values('Small Tools');

insert into INVENTORY_CATEGORY values('Heavy Equipment');

insert into INVENTORY_CATEGORY values('Vehicles');

/* TAX table insert */

insert into TAX values(0,400,'Single',5,4,3);

insert into TAX values(0,400,'Married',6,5,4);

insert into TAX values(401,600,'Single',7,8,9);

insert into TAX values(401,600,'Married',8,9,10);

insert into TAX values(601,1000,'Single',10,10,10);

insert into TAX values(601,1000,'Married',10,10,10);


/* EEOC table insert */

insert into EEOC values('Black not of Hispanic Origin');

insert into EEOC values('Hispanic');

insert into EEOC values('Asian/Pacific Islander');

insert into EEOC values('American Indian or Alaskan native');

insert into EEOC values('Non-minority(White)');

/* JOB table insert */

insert into JOB values('LAB','Labor');

insert into JOB values('CAR','Carpentry');

insert into JOB values('MAS','Masonry');

insert into JOB values('IRN','IronWork');

insert into JOB values('EQP','Equipment Operation');


/* EMPLOYEE table insert */

insert into EMPLOYEE values(
400,'Mark','Antony','S','Green park','Fullerton','California','84635','324-545-4444',
'19-Jan-1991','Male','Single','432-33-5322');

insert into EMPLOYEE values(
401,'Rick','Antony',null,null,'Fullerton','California','64532','333-432-5422',
'19-Feb-1985','Male','Married','212-54-1232');

insert into EMPLOYEE values(
404,'Jessica','Suron',null,null,null,null,'32342','231-546-3234',
'19-Feb-1993','Female','Married','122-43-4423');

insert into EMPLOYEE values(
402,'Suresh','Gopi','P','Nams park','Fullerton','California','32321','212-423-3213',
'20-Jul-1994','Male','Married','321-77-4342');

insert into EMPLOYEE values(
403,'Masha','Usta','Soru','Teen street','Ceritos','California','32313','232-533-3232',
'20-May-1990','Female','Single','323-77-4222');

insert into EMPLOYEE values(
404,'Picu','penstro',null,null,'Fullerton','California','32321','656-332-6532',
'20-Jan-1985','Female','Married','213-12-4342');

insert into EMPLOYEE values(
404,'Jammy','goku',null,null,null,null,'32342','231-777-4212',
'19-Feb-1991','Female','Married','212-21-4343');

insert into EMPLOYEE values(
404,'Suresh','Gopi','P','Nams park','Fullerton','California','32321','212-423-3013',
'20-Jul-1994','Male','Married','212-88-4434');

insert into EMPLOYEE values(
404,'Nick','Namy',null,'Soms street','Ceritos','California','32323','432-333-4232',
'20-Jul-1991','Female','Single','323-22-4343');

insert into EMPLOYEE values(
401,'Jim','Carso',null,null,null,null,'64532','322-431-2222',
'19-Feb-1955','Male','Single','213-32-4333');

insert into EMPLOYEE values(
400,'Sessie','Suron',null,null,null,null,'32342','432-546-3234',
'19-Mar-1993','Female','Married','122-00-4423');

insert into EMPLOYEE values(
402,'Nari','Sudo','P','Nams park','Fullerton','California','32321','322-423-0000',
'20-Jul-1994','Male','Single','321-77-9999');

insert into EMPLOYEE values(
403,'Susha','Sonn','Soru','Teen street','Ceritos','California','32313','334-533-0098',
'20-Jun-1991','Female','Single','323-77-0000');

insert into EMPLOYEE values(
403,'Somu','Sam',null,null,null,null,'32342','211-747-4212',
'19-Jul-1991','Female','Married','444-21-3331');

insert into EMPLOYEE values(
404,'Suresh','Goku','P','Nams park','Fullerton','California','32453','212-333-3213',
'10-Feb-1994','Male','Married','000-88-3211');

insert into EMPLOYEE values(
404,'Nachu','Namu',null,'Soms street','Ceritos','California','32323','000-333-4232',
'20-Jul-1991','Female','Single','323-00-5432');

insert into EMPLOYEE values(
401,'Jim','Carlo',null,null,null,null,'64532','999-431-2222',
'19-Feb-1985','Male','Single','213-99-4333');

insert into EMPLOYEE values(
400,'Sessie','Jr',null,null,null,null,'32342','222-111-3234',
'19-Mar-1993','Female','Married','002-00-4423');

insert into EMPLOYEE values(
402,'Nari','Sudo','P','Nams park','Fullerton','California','32321','010-342-1111',
'20-Jul-1999','Male','Single','222-77-3213');

insert into EMPLOYEE values(
403,'Susha','Sonn','Soru','Teen street','Ceritos','California','32313','433-893-0098',
'20-Jun-1995','Female','Single','321-55-4232');


/* PROJECT table insert */

insert into PROJECT values(
'OH-PIK-335-005',100,'5 miles south of Beaver,Ohio on SR 335(Pike County)',
'Replacement of single-span two-lane bridge(pre-stressed beam type)');

insert into PROJECT values(
'OH-PIK-335-006',101,'10 miles south of Beaver,Ohio on SR 335(Pike County)',
'Replacement of double-span three-lane bridge(post-stressed beam type)');

insert into PROJECT values(
'OH-PIK-335-007',102,'Non state project,Ohio on SR 335(Pike County)',
'Replacement of bridge(no-stressed beam type)');


/* PROJECT_CONTRACT table insert*/

insert into PROJECT_CONTRACT values('31-0646843','OH-PIK-335-005');

insert into PROJECT_CONTRACT values('31-0646843','OH-PIK-335-006');

insert into PROJECT_CONTRACT values('30-0646000','OH-PIK-335-007');



/* INVENTORY table insert */

insert into INVENTORY values(200,'Sand',null,null);

insert into INVENTORY values(200,'Steel',null,null);

insert into INVENTORY values(200,'Mortar',null,null);

insert into INVENTORY values(200,'Polyethylene',null,null);

insert into INVENTORY values(200,'Ethylene',null,null);

insert into INVENTORY values(201,'Nuts',null,null);

insert into INVENTORY values(201,'Bolts',null,null);

insert into INVENTORY values(201,'Screwdriver',null,null);

insert into INVENTORY values(201,'Cutter',null,null);

insert into INVENTORY values(201,'Spanner',null,null);

insert into INVENTORY values(202,'Hammer Drills',1,'15-Jun-2015');

insert into INVENTORY values(202,'Circular Saw',1,'20-Dec-2015');

insert into INVENTORY values(202,'Screw Guns',0,'01-Jan-2016');

insert into INVENTORY values(202,'Generators',0,'15-Mar-2016');

insert into INVENTORY values(202,'Driller',0,'15-Mar-2016');

insert into INVENTORY values(203,'Bulldozer',1,'1-Feb-2016');

insert into INVENTORY values(203,'Portable Engine',0,'25-Mar-2016');

insert into INVENTORY values(203,'Excavator',1,'10-Jan-2016');

insert into INVENTORY values(203,'Steam Shovel',1,'15-Mar-2016');

insert into INVENTORY values(203,'Transporter',1,'15-Mar-2016');


/* PAY_SCALE table Insert and Update */

        /* Use Trigger to update OvertimeRate in table */


create trigger PayScaleTrigger on PAY_SCALE
after insert as
begin
update PAY_SCALE set OverTimeRate =  1.5*BasicRate;
end
go

/* Use Insert to insert BasicRate in table */

            /* 5 miles away */

insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('LAB','OH-PIK-335-005',150,11,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('CAR','OH-PIK-335-005',200,12,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('MAS','OH-PIK-335-005',130,13,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('IRN','OH-PIK-335-005',220,14,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('EQP','OH-PIK-335-005',300,15,3);

              /* 10 miles away */


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('LAB','OH-PIK-335-006',220,12,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('CAR','OH-PIK-335-006',90,13,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('MAS','OH-PIK-335-006',88,14,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('IRN','OH-PIK-335-006',295,15,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('EQP','OH-PIK-335-006',177,16,3);

           /* Non-state project */


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('LAB','OH-PIK-335-007',144,10,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('CAR','OH-PIK-335-007',134,10,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('MAS','OH-PIK-335-007',208,10,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('IRN','OH-PIK-335-007',202,10,3);


insert into PAY_SCALE(JobCode,ProjectNumber,TotalHoursRequired,BasicRate,Fringe) 
values('EQP','OH-PIK-335-007',111,10,3);



/* When a employee starts his work,following tables are updated */
            
		  /*  INVENTORY_USAGE table insert */
insert into INVENTORY_USAGE values('OH-PIK-335-005',10000,30019,
'20-Mar-2016','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10015,30008,
'21-Mar-2016','10:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-007',10010,30007,
'15-Feb-2016','08:30:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-005',10004,30006,
'11-Feb-2016','09:20:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10016,30018,
'01-Jan-2016','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10007,30012,
'22-Feb-2015','13:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10019,30011,
'20-Jun-2015','20:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-007',10012,30002,
'11-May-2015','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-007',10013,30003,
'12-Dec-2015','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-007',10014,30004,
'11-Jan-2016','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-005',10015,30007,
'20-Feb-2016','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-005',10011,30008,
'15-Feb-2016','08:30:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-007',10006,30007,
'11-Feb-2016','09:20:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-007',10009,30018,
'01-Jan-2016','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10015,30013,
'22-Feb-2015','13:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10014,30011,
'20-Jun-2015','20:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10013,30019,
'11-May-2015','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-006',10012,30013,
'12-Dec-2015','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-005',10014,30014,
'11-Jan-2016','08:00:00',null);

insert into INVENTORY_USAGE values('OH-PIK-335-007',10008,30017,
'20-Feb-2016','08:00:00',null);


          /*  PAY_CALCULATION table insert */
insert into PAY_CALCULATION values(10000,502,'15-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10015,501,'15-Apr-2016','10:30:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10010,503,'15-Apr-2016','08:30:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10004,504,'15-Apr-2016','09:20:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10016,507,'16-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10007,509,'16-Apr-2016','13:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10019,505,'16-Apr-2016','20:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10012,506,'16-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10013,508,'19-Apr-2016','10:30:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10014,510,'19-Apr-2016','08:30:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10015,500,'19-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10011,507,'19-Apr-2016','08:30:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10006,504,'20-Apr-2016','09:20:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10009,500,'20-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10015,500,'20-Apr-2016','13:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10014,501,'20-Apr-2016','20:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10013,504,'21-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10012,503,'21-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10014,506,'21-Apr-2016','08:00:00',null,0,0,0,0,0);

insert into PAY_CALCULATION values(10008,510,'21-Apr-2016','08:00:00',null,0,0,0,0,0);


insert into PAY_CALCULATION values(10000,507,'15-Apr-2016','08:00:00',null,0,0,0,0,0);


/* When a employee finish his work,following tables are updated */
		

		  /*  INVENTORY_USAGE table update */
update INVENTORY_USAGE set CheckinTime='18:00:00' where EmployeeID=10000 and
ProjectNumber='OH-PIK-335-005' and InventoryID=30019;

update INVENTORY_USAGE set CheckinTime='18:00:00' where EmployeeID=10015 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30008;

update INVENTORY_USAGE set CheckinTime='18:30:00' where EmployeeID=10010 and
ProjectNumber='OH-PIK-335-007' and InventoryID=30007;

update INVENTORY_USAGE set CheckinTime='17:00:00' where EmployeeID=10004 and
ProjectNumber='OH-PIK-335-005' and InventoryID=30006;

update INVENTORY_USAGE set CheckinTime='20:00:00' where EmployeeID=10016 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30018;

update INVENTORY_USAGE set CheckinTime='23:00:00' where EmployeeID=10007 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30012;

update INVENTORY_USAGE set CheckinTime='23:59:00' where EmployeeID=10019 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30011;

update INVENTORY_USAGE set CheckinTime='17:00:00' where EmployeeID=10012 and
ProjectNumber='OH-PIK-335-007' and InventoryID=30002;

update INVENTORY_USAGE set CheckinTime='19:00:00' where EmployeeID=10013 and
ProjectNumber='OH-PIK-335-007' and InventoryID=30003;

update INVENTORY_USAGE set CheckinTime='23:57:00' where EmployeeID=10014 and
ProjectNumber='OH-PIK-335-007' and InventoryID=30004;

update INVENTORY_USAGE set CheckinTime='17:22:00' where EmployeeID=10015 and
ProjectNumber='OH-PIK-335-005' and InventoryID=30007;

update INVENTORY_USAGE set CheckinTime='17:45:00' where EmployeeID=10011 and
ProjectNumber='OH-PIK-335-005' and InventoryID=30008;

update INVENTORY_USAGE set CheckinTime='17:00:00' where EmployeeID=10006 and
ProjectNumber='OH-PIK-335-007' and InventoryID=30007;

update INVENTORY_USAGE set CheckinTime='17:47:00' where EmployeeID=10009 and
ProjectNumber='OH-PIK-335-007' and InventoryID=30018;

update INVENTORY_USAGE set CheckinTime='22:22:22' where EmployeeID=10015 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30013;

update INVENTORY_USAGE set CheckinTime='23:50:00' where EmployeeID=10014 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30011;

update INVENTORY_USAGE set CheckinTime='17:30:00' where EmployeeID=10013 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30019;

update INVENTORY_USAGE set CheckinTime='18:00:00' where EmployeeID=10012 and
ProjectNumber='OH-PIK-335-006' and InventoryID=30013;

update INVENTORY_USAGE set CheckinTime='12:30:20' where EmployeeID=10014 and
ProjectNumber='OH-PIK-335-005' and InventoryID=30014;

update INVENTORY_USAGE set CheckinTime='16:22:22' where EmployeeID=10008 and
ProjectNumber='OH-PIK-335-007' and InventoryID=30017;
		 

		 
		  /* Stored procedure to update checkoutTime, basic and overtime */
drop procedure dbo.WorkHoursAndEEOCTracking
create procedure dbo.WorkHoursAndEEOCTracking
@EmployeeID int, 
@Date date,
@PsID int,
@CheckinTime TIME, 
@CheckoutTime TIME

as
begin

    /* --------------------- BasicPay and OvertimePay Tracking ---------------------- */

declare @CurrentTotalHours int;
declare @CurrentBasicHours int;
declare @CurrentOvertimeHours int;
declare @PreviousTotalHours int;
declare @PreviousBasicHours int;
declare @PreviousOvertimeHours int;
declare @Need int;
declare @Message nvarchar(512);



set @PreviousTotalHours = (select sum(TotalHours) from PAY_CALCULATION where EmployeeID=@EmployeeID and [Date]=@Date);
set @CurrentTotalHours= DATEDIFF(hh, @CheckinTime, @CheckoutTime);


print cast(@CurrentTotalHours as nvarchar(30));

	if @PreviousTotalHours<=8  /* null for the first time */
		set @Need = 8 - @PreviousTotalHours;
	else 
		set @Need=0;


	if @CurrentTotalHours<=@Need 
		begin
		set @CurrentBasicHours=@CurrentTotalHours;
		set @CurrentOvertimeHours=0;
		end
	else
		begin
		select @CurrentBasicHours=@Need;
		select @CurrentOvertimeHours=@CurrentTotalHours-@Need;
		end


		/* Basic pay and Overtime pay calculation */

declare @CurrentBasicPay decimal(8,2);
declare @CurrentOvertimePay decimal(8,2);

set @CurrentBasicPay = (select @CurrentBasicHours*(select (BasicRate+Fringe) from PAY_SCALE where PsID=@PsID));

set @CurrentOvertimePay = (select @CurrentOvertimeHours*(select (OvertimeRate+Fringe) from PAY_SCALE where PsID=@PsID));


	update PAY_CALCULATION set checkoutTime=@CheckoutTime, TotalHours=@CurrentTotalHours,
	BasicHours=@CurrentBasicHours,BasicPay=@CurrentBasicPay,OvertimeHours=@CurrentOvertimeHours,
	OvertimePay=@CurrentOvertimePay where EmployeeID=@EmployeeID and [Date]=@Date and PsID=@PsID;

  /* ------------------------ EEOC Compliance Tracking ----------------------------- */

declare @EmpSex char(20);
declare @EEOC_Code int;
declare @PreviousMMHours decimal(18,4);
declare @PreviousMFHours decimal(18,4);
declare @PreviousNMMHours decimal(18,4);
declare @PreviousNMFHours decimal(18,4);
declare @CurrentMMHours decimal(18,4);
declare @CurrentMFHours decimal(18,4);
declare @CurrentNMMHours decimal(18,4);
declare @CurrentNMFHours decimal(18,4);
declare @RecordPresent decimal(18,4);


set @RecordPresent= (select count(*) from PROJECT_HOURS where [Date]=@Date and PsID=@PsID); 


	if @RecordPresent=1 
		begin

		set @PreviousMMHours = (select sum(MinorityMHours) from PROJECT_HOURS where 
		PsID=@PsID and [Date]=@Date);


		set @PreviousMFHours = (select sum(MinorityFHours) from PROJECT_HOURS where 
		PsID=@PsID and [Date]=@Date);


		set @PreviousNMMHours = (select sum(NonMinorityMHours) from PROJECT_HOURS where
		PsID=@PsID and [Date]=@Date);


		set @PreviousNMFHours = (select sum(NonMinorityFHours) from PROJECT_HOURS where 
		PsID=@PsID and [Date]=@Date);
		end


	else
		begin 
		set @PreviousMMHours = 0;
		set @PreviousMFHours = 0;
		set @PreviousNMMHours = 0;
		set @PreviousNMFHours = 0;
		end



set @EEOC_Code= (select EEOC_Code from EMPLOYEE where EmployeeID=@EmployeeID);
set @EmpSex = (select Gender from EMPLOYEE where EmployeeID=@EmployeeID);



	if @EEOC_Code!=404 and @EmpSex='Male'
		begin
		set   @CurrentMMHours=@CurrentTotalHours;
		set   @CurrentMFHours=0;
		set   @CurrentNMMHours=0;
		set   @CurrentNMFHours=0;
		end
	else if @EEOC_Code!=404 and @EmpSex='Female'
		begin
		set   @CurrentMMHours=0;
		set   @CurrentMFHours=@CurrentTotalHours;
		set   @CurrentNMMHours=0;
		set   @CurrentNMFHours=0;
		end
	else if @EEOC_Code=404 and @EmpSex='Male'
		begin
		set   @CurrentMMHours=0;
		set   @CurrentMFHours=0;
		set   @CurrentNMMHours=@CurrentTotalHours;
		set   @CurrentNMFHours=0;
		end
	else 
		begin
		set   @CurrentMMHours=0;
		set   @CurrentMFHours=0;
		set   @CurrentNMMHours=0;
		set   @CurrentNMFHours=@CurrentTotalHours;
		end


declare @MinorityMHours decimal(18,4);
declare @MinorityFHours decimal(18,4);
declare @NonMinorityMHours decimal(18,4);
declare @NonMinorityFHours decimal(18,4);

set @MinorityMHours=@PreviousMMHours+@CurrentMMHours;
set @MinorityFHours=@PreviousMFHours+@CurrentMFHours;
set @NonMinorityMHours=@PreviousNMMHours+@CurrentNMMHours;
set @NonMinorityFHours=@PreviousNMFHours+@CurrentNMFHours;

	/* percentage calculation */

declare @MinorityHours decimal(18,4);
declare @FemaleHours decimal(18,4);
declare @TotalProjectHours decimal(18,4);
declare @MinorityPercent decimal(18,4);
declare @FemalePercent decimal(18,4);

set @MinorityHours=@MinorityMHours+@MinorityFHours;
set @FemaleHours=@MinorityFHours+@NonMinorityFHours;


set @TotalProjectHours=(select TotalHoursRequired from PAY_SCALE where PsID=@PsID);


set @MinorityPercent= ((@MinorityHours/@TotalProjectHours)*100);
set @FemalePercent= ((@FemaleHours/@TotalProjectHours)*100);


	if @RecordPresent=1 
	begin
	update PROJECT_HOURS set MinorityMHours=@MinorityMHours, 
	MinorityFHours=@MinorityFHours,NonMinorityMHours=@NonMinorityMHours, 
	NonMinorityFHours=@NonMinorityFHours, MinorityWorkPercent=@MinorityPercent,
	FemaleWorkPercent=@FemalePercent where PsID=@PsID and [Date]=@Date;
	end

	else
	begin
	insert into PROJECT_HOURS values(@Date,@PsID,@MinorityMHours,@MinorityFHours,
	@NonMinorityMHours,@NonMinorityFHours,@MinorityPercent,@FemalePercent);
	end

end


			/* Stored procedure execution */

execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10000,@Date='15-Apr-2016',
@PsID=502,@CheckinTime='08:00:00',@CheckoutTime='18:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10015,@Date='15-Apr-2016',
@PsID=501,@CheckinTime='10:30:00',@CheckoutTime='23:30:34';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10010,@Date='15-Apr-2016',
@PsID=503,@CheckinTime='08:30:00',@CheckoutTime='17:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10004,@Date='15-Apr-2016',
@PsID=504,@CheckinTime='09:20:00',@CheckoutTime='18:30:33';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10016,@Date='16-Apr-2016',
@PsID=507,@CheckinTime='08:00:00',@CheckoutTime='19:00:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10007,@Date='16-Apr-2016',
@PsID=509,@CheckinTime='13:00:00',@CheckoutTime='22:00:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10019,@Date='16-Apr-2016',
@PsID=505,@CheckinTime='20:30:00',@CheckoutTime='23:59:29';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10012,@Date='16-Apr-2016',
@PsID=506,@CheckinTime='08:00:00',@CheckoutTime='17:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10013,@Date='19-Apr-2016',
@PsID=508,@CheckinTime='10:30:00',@CheckoutTime='18:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10014,@Date='19-Apr-2016',
@PsID=510,@CheckinTime='08:30:00',@CheckoutTime='17:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10015,@Date='19-Apr-2016',
@PsID=500,@CheckinTime='08:00:00',@CheckoutTime='22:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10011,@Date='19-Apr-2016',
@PsID=507,@CheckinTime='08:30:00',@CheckoutTime='18:00:44';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10006,@Date='20-Apr-2016',
@PsID=504,@CheckinTime='10:30:00',@CheckoutTime='19:00:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10009,@Date='20-Apr-2016',
@PsID=500,@CheckinTime='10:30:00',@CheckoutTime='22:00:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10015,@Date='20-Apr-2016',
@PsID=500,@CheckinTime='13:35:22',@CheckoutTime='22:32:43';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10014,@Date='20-Apr-2016',
@PsID=501,@CheckinTime='20:01:00',@CheckoutTime='23:58:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10013,@Date='21-Apr-2016',
@PsID=504,@CheckinTime='08:30:00',@CheckoutTime='18:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10012,@Date='21-Apr-2016',
@PsID=503,@CheckinTime='09:20:00',@CheckoutTime='22:30:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10014,@Date='21-Apr-2016',
@PsID=506,@CheckinTime='09:30:00',@CheckoutTime='23:00:00';


execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10008,@Date='21-Apr-2016',
@PsID=510,@CheckinTime='08:20:00',@CheckoutTime='18:00:00';



execute dbo.WorkHoursAndEEOCTracking @EmployeeID=10000,@Date='15-Apr-2016',
@PsID=507,@CheckinTime='08:00:00',@CheckoutTime='18:00:00';



/* --------------------------------------------------------------------- */

		/* Stored procedure for Weekly pay calculation */
drop procedure dbo.NetWeeklyPay

create procedure dbo.NetWeeklyPay
@EmployeeID int,
@PayPeriodStartDate date,
@PayPeriodEndDate date,
@OtherDeductions decimal(8,4),
@CheckNumber char(20),
@PaymentDate date

as
begin

declare @TaxID int;
declare @GrossPay decimal(8,4);
declare @MaritalStatus char(20);
declare @TotalTaxAmount decimal(8,4);
declare @OtherDebits decimal(8,4);
declare @TotalDeductions decimal(8,4);
declare @NetPay decimal(8,4)


   /* Gross pay Calculation */

set @GrossPay=(select sum(BasicPay)+sum(OvertimePay) from PAY_CALCULATION where 
EmployeeID=@EmployeeID and [Date] between dateadd(day,-7,@PayPeriodEndDate) and @PayPeriodEndDate); 
   					
   /* Tax Amount Calculation */

set @MaritalStatus = (select MaritalStatus from EMPLOYEE where EmployeeID=@EmployeeID);

print 'Gross pay ' + cast (@GrossPay as nvarchar(20));

set @TaxID=0;

while @TaxID=0
	begin

	select @TaxID= TaxID from TAX where @GrossPay>=WeeklyPayRangeStart 
	and @GrossPay<WeeklyPayRangeEnd and MaritalStatus=@MaritalStatus;

	if @TaxID!=0
	break;

	end


declare @FederalTaxAmount decimal(8,4);
declare @StateTaxAmount decimal(8,4);
declare @SSNTaxAmount decimal(8,4);



set @FederalTaxAmount= ((@GrossPay/100)*(select FederalTaxPercent from TAX where TaxID=@TaxID));
set @StateTaxAmount =((@GrossPay/100)*(select StateTaxPercent from TAX where TaxID=@TaxID));
set @SSNTaxAmount=((@GrossPay/100)*(select SSNTaxPercent from TAX where TaxID=@TaxID));

set @TotalTaxAmount=@FederalTaxAmount+@StateTaxAmount+@SSNTaxAmount;		


set @TotalDeductions=@TotalTaxAmount+@OtherDeductions;

set @NetPay=@GrossPay-@TotalDeductions;


		/* insert into WEEK_PAYMENT*/
		
insert into WEEK_PAYMENT values (@EmployeeID,@TaxID,@PayPeriodStartDate,
@PayPeriodEndDate,@GrossPay,@FederalTaxAmount,@StateTaxAmount,@SSNTaxAmount,
@TotalTaxAmount,@OtherDeductions,@TotalDeductions,@NetPay,@CheckNumber,@PaymentDate);

end


	/* Query to execute Weekly pay calculation */

execute dbo.NetWeeklyPay @EmployeeID=10014,@PayPeriodStartDate='15-Apr-2016',
@PayPeriodEndDate='21-Apr-2016',@OtherDeductions=0,
@CheckNumber='87327837',@PaymentDate='29-Apr-2016';


/* -------------------------------------------------------------------------------------------- */

			

			/*----------------- Each Exhibit Execution --------------------- */


/* Exhibit B - Part A */

select * from [Contract],PROJECT where ProjectNumber='OH-PIK-335-005' and ContractNumber='31-0646843';


/* Exhibit B - Part D */

create view ProjectLabourLAB as 
select 'LAB' as JobClassification,sum(MinorityMHours) as MinorityMHours, sum(MinorityFHours) as MinorityFHours,
sum(NonMinorityMHours) as NonMinorityMHours,sum(NonMinorityFHours) as NonMinorityFHours,
(select TotalHoursRequired  from PAY_SCALE where
 ProjectNumber='OH-PIK-335-005' and JobCode='LAB') as TotalHours ,
sum(MinorityWorkPercent) as MinorityWorkPercent,
sum(FemaleWorkPercent) as FemaleWorkPercent from PROJECT_HOURS where 
psID in (select PsID from PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='LAB') 
and [date] between '15-Apr-2016' and '21-Apr-2016';

create view ProjectLabourCAR as
select 'CAR' as JobClassification,sum(MinorityMHours) as MinorityMHours, sum(MinorityFHours) as MinorityFHours,
sum(NonMinorityMHours) as NonMinorityMHours,sum(NonMinorityFHours) as NonMinorityFHours,
(select TotalHoursRequired  from PAY_SCALE where
 ProjectNumber='OH-PIK-335-005' and JobCode='CAR') as TotalHours ,
sum(MinorityWorkPercent) as MinorityWorkPercent,
sum(FemaleWorkPercent) as FemaleWorkPercent from PROJECT_HOURS where 
psID in (select PsID from PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='CAR') 
and [date] between '15-Apr-2016' and '21-Apr-2016';


create view ProjectLabourMAS as
select 'MAS' as JobClassification,sum(MinorityMHours) as MinorityMHours, sum(MinorityFHours) as MinorityFHours,
sum(NonMinorityMHours) as NonMinorityMHours,sum(NonMinorityFHours) as NonMinorityFHours,
(select TotalHoursRequired  from PAY_SCALE where
 ProjectNumber='OH-PIK-335-005' and JobCode='MAS') as TotalHours ,
sum(MinorityWorkPercent) as MinorityWorkPercent,
sum(FemaleWorkPercent) as FemaleWorkPercent from PROJECT_HOURS where 
psID in (select PsID from PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='MAS') 
and [date] between '15-Apr-2016' and '21-Apr-2016';


create view ProjectLabourIRN as
select 'IRN' as JobClassification,sum(MinorityMHours) as MinorityMHours, sum(MinorityFHours) as MinorityFHours,
sum(NonMinorityMHours) as NonMinorityMHours,sum(NonMinorityFHours) as NonMinorityFHours,
(select TotalHoursRequired  from PAY_SCALE where
 ProjectNumber='OH-PIK-335-005' and JobCode='IRN') as TotalHours ,
sum(MinorityWorkPercent) as MinorityWorkPercent,
sum(FemaleWorkPercent) as FemaleWorkPercent from PROJECT_HOURS where 
psID in (select PsID from PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='IRN') 
and [date] between '15-Apr-2016' and '21-Apr-2016';


create view ProjectLabourEQP as
select 'EQP' as JobClassification,sum(MinorityMHours) as MinorityMHours, sum(MinorityFHours) as MinorityFHours,
sum(NonMinorityMHours) as NonMinorityMHours,sum(NonMinorityFHours) as NonMinorityFHours,
(select TotalHoursRequired  from PAY_SCALE where
 ProjectNumber='OH-PIK-335-005' and JobCode='EQP') as TotalHours ,
sum(MinorityWorkPercent) as MinorityWorkPercent,
sum(FemaleWorkPercent) as FemaleWorkPercent from PROJECT_HOURS where 
psID in (select PsID from PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='EQP') 
and [date] between '15-Apr-2016' and '21-Apr-2016';
		
select * from ProjectLabourLAB

select * from ProjectLabourCAR

select * from ProjectLabourMAS

select * from ProjectLabourIRN

select * from ProjectLabourEQP
	

/* Exhibit C - Part C */

select * from PAY_SCALE

/* Exhibit D - Part D */


select pc.EmployeeID,ps.JobCode,ps.ProjectNumber,ps.BasicRate,ps.Fringe,
(ps.BasicRate+ps.Fringe) as TotalRate,pc.BasicHours,(pc.BasicHours*(ps.BasicRate+ps.Fringe))
as GrossPay from PAY_SCALE as ps, PAY_CALCULATION as pc where pc.EmployeeID=10000 
and [Date]='15-Apr-2016' and ps.ProjectNumber='OH-PIK-335-005' and JobCode='LAB';


select pc.EmployeeID,ps.JobCode,ps.ProjectNumber,ps.BasicRate,ps.Fringe,
(ps.BasicRate+ps.Fringe) as TotalRate,pc.BasicHours,(pc.BasicHours*(ps.BasicRate+ps.Fringe))
as GrossPay from PAY_SCALE as ps, PAY_CALCULATION as pc where pc.EmployeeID=10000 
and [Date]='15-Apr-2016' and ps.ProjectNumber='OH-PIK-335-005' and JobCode='MAS';

	/* Part E */

select pc.EmployeeID,ps.JobCode,ps.ProjectNumber,ps.OvertimeRate,ps.Fringe,
(ps.OvertimeRate+ps.Fringe) as TotalRate,pc.OvertimeHours,(pc.OvertimeHours*(ps.OvertimeRate+ps.Fringe))
as GrossPay from PAY_SCALE as ps, PAY_CALCULATION as pc where pc.EmployeeID=10000 
and [Date]='15-Apr-2016' and ps.ProjectNumber='OH-PIK-335-005' and JobCode='EQP';


	/* Part F */

select 'LAB' as JobSkillCode,sum(BasicHours) as RegularHours,sum(OvertimeHours) as OvertimeHours,
sum(TotalHours) as TotalHours from PAY_CALCULATION
where EmployeeID=10000 and [Date]='15-Apr-2016' and psID in (select PsID from
PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='LAB');

select 'CAR' as JobSkillCode,sum(BasicHours) as RegularHours,sum(OvertimeHours) as OvertimeHours,
sum(TotalHours) as TotalHours from PAY_CALCULATION
where EmployeeID=10000 and [Date]='15-Apr-2016' and psID in (select PsID from
PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='CAR');

select 'MAS' as JobSkillCode,sum(BasicHours) as RegularHours,sum(OvertimeHours) as OvertimeHours,
sum(TotalHours) as TotalHours from PAY_CALCULATION
where EmployeeID=10000 and [Date]='15-Apr-2016' and psID in (select PsID from
PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='MAS');

select 'IRN' as JobSkillCode,sum(BasicHours) as RegularHours,sum(OvertimeHours) as OvertimeHours,
sum(TotalHours) as TotalHours from PAY_CALCULATION
where EmployeeID=10000 and [Date]='15-Apr-2016' and psID in (select PsID from
PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='IRN');

select 'EQP' as JobSkillCode,sum(BasicHours) as RegularHours,sum(OvertimeHours) as OvertimeHours,
sum(TotalHours) as TotalHours from PAY_CALCULATION
where EmployeeID=10000 and [Date]='15-Apr-2016' and psID in (select PsID from
PAY_SCALE where ProjectNumber='OH-PIK-335-005' and JobCode='EQP');



/* Exhibit E */

select * from EMPLOYEE where EmployeeID=10000;


/* Exhibit F */

select * from WEEK_PAYMENT where EmployeeID=10014;

