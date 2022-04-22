-- CS4400: Introduction to Database Systems (Spring 2022)
-- Course Project: Phase 3 Autograder BASIC [v0] Sunday, April 10, 2022
-- This version uses a significantly simplified testing system

-- This SQL MODE is used to deliberately allow for queries that do not follow the "ONLY_FULL_GROUP_BY" protocol.
-- Though it does permit queries that are arguably poorly-structured, this is permitted by the most recent SQL standards.
set session SQL_MODE = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- This is required to support some of the arbitrary SQL commands that might be used in the testing process.
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'bank_management';
use bank_management;

-- ----------------------------------------------------------------------------------
-- [1] Implement a capability to reset the database state easily
-- ----------------------------------------------------------------------------------

drop procedure if exists magic44_reset_database_state;
delimiter //
create procedure magic44_reset_database_state ()
begin
	-- Purge and then reload all of the database rows back into the tables.
    -- Ensure that the data is deleted in reverse order with respect to the
    -- foreign key dependencies (i.e., from children up to parents).
	delete from access;
	delete from workFor;
	delete from checking;
	delete from market;
	delete from savings;
	delete from interest_bearing_fees;
	delete from interest_bearing;
	delete from bank_account;
	delete from bank;
	delete from corporation;
	delete from customer_contacts;
	delete from customer;
	delete from employee;
	delete from bank_user;
 	delete from system_admin;
	delete from person;

    -- Ensure that the data is inserted in order with respect to the
    -- foreign key dependencies (i.e., from parents down to children).
	insert into person values
    ('mmoss7','password1'), ('tmcgee1','password2'), ('dscully5','password3'), ('fmulder8','password4'),
    ('arwhite6','password5'), ('ealfaro4','password6'), ('mmcgill4','password7'), ('sville19','password8'),
    ('rnairn5','password9'), ('smcgill17','password10'), ('tjtalbot4','password11'), ('owalter6','password12'), 
    ('rsanchez','password13'), ('msmith','password14'), ('lgibbs4','password15'), ('ghopper9','password16'), 
    ('asantiago99','password17'), ('rholt99','password18'), ('jperalta99','password19'), ('glinetti99','password20'), 
    ('cboyle99','password21'), ('rdiaz99','password22'), ('atrebek1','password23'), ('kjennings66','password24'), 
    ('gburdell','password25'), ('pbeesly17','password26'), ('beyonce','password27');
    
    insert into system_admin values
    ('mmoss7'), ('tmcgee1'), ('dscully5'), ('fmulder8');
    
    insert into bank_user values
    ('arwhite6','053-87-1120','1960-06-06','Amelia-Rose','Whitehead','2021-12-03','60 Nightshade Court','Baltimore','MD','21217'),
    ('ealfaro4','278-78-7676','1960-06-06','Evie','Alfaro','2021-12-27','314 Five Fingers Way','Atlanta','GA','30301'),
    ('mmcgill4','623-09-0887','1955-06-23','Maheen','McGill','2020-09-08','741 Pan American Trace','East Cobb','GA','30304'),
    ('sville19','354-10-6263','1965-03-16','Sahar','Villegas','2020-06-16','10 Downing Road','East Cobb','GA','30304'),
    ('rnairn5','404-51-1036','1959-07-13','Roxanne','Nairn','2021-08-16','2048 Transparency Road','Atlanta','GA','30301'),
    ('smcgill17','238-40-5070','1954-06-02','Saqlain','McGill','2020-09-11','741 Pan American Trace','East Cobb','GA','30304'),
	('tjtalbot4','203-46-3005','1978-05-10','TJ','Talbot','2020-03-25','101 Snoopy Woodstock Circle','Salt Lake City','UT','84108'),
    ('owalter6','346-51-9139','1971-10-23','Om','Walter','2020-04-29','143 Snoopy Woodstock Circle','Salt Lake City','UT','84108'),
    ('rsanchez','012-34-5678','1936-08-22','Rick','Sanchez',null,'137 Puget Run','Seattle','WA','98420'),
    ('msmith','246-80-1234','1999-04-04','Morty','Smith','2017-08-21','137 Puget Run','Seattle','WA','98420'),
    ('lgibbs4','304-39-1098','1954-11-21','Leroy','Gibbs','2021-06-16','50 Mountain Spur','Stillwater','PA','17878'),
    ('ghopper9','101-00-1111','1906-12-09','Grace','Hopper','2019-12-25','1 Broadway','New York','NY','10004'),
    ('asantiago99','765-43-2109','1983-07-04','Amy','Santiago','2018-03-09','1477 Park Avenue Apt. 82','New York','NY','11217'),
    ('rholt99','111-22-3333','1955-01-01','Raymond','Holt','2022-01-01','123 Main Street','Perth Amboy','NJ','08861'),
    ('jperalta99','775-33-6054','1981-09-04','Jake','Peralta','2018-03-09','1477 Park Avenue Apt. 82','New York','NY','11217'),
    ('glinetti99','233-76-0019','1986-03-20','Gina','Linetti','2019-04-04','75 Allure Drive','New York','NY','11220'),
    ('cboyle99','433-12-1200','1982-09-04','Charles','Boyle','2018-03-10','1477 Park Avenue Apt. 65','New York','NY','11217'),
    ('rdiaz99','687-54-1033','1984-11-30','Rosa','Diaz','2020-12-24','3 East Park Loop','Yonkers','NY','10112'),
    ('atrebek1','000-00-0000','1940-07-22','Alex','Trebek','2014-03-22','10202 West Washington Boulevard','Culver City','CA','90232'),
    ('kjennings66','004-52-2700','1974-05-23','Ken','Jennings','2005-09-07','74 Champions Heights','Edmonds','WA','98020'),
    ('gburdell','404-00-0000',null,null,null,null,null,null,null,null),
    ('pbeesly17','664-98-7654',null,'Pam','Beesly','2021-06-06',null,null,null,null),
    ('beyonce','444-55-666','1981-09-04','Beyonce',null,'2014-02-02','222 Star Grove','Houston','TX','77077');
    
    insert into employee values
    ('arwhite6',4700,6,28200), ('ealfaro4',5600,3,17100), ('mmcgill4',9400,3,29100), ('sville19',8000,4,35000),
    ('rnairn5',5100,5,27400), ('smcgill17',8800,3,33700), ('rsanchez',49500,10,654321), ('lgibbs4',null,null,null),
    ('ghopper9',49500,5,447999), ('rholt99',null,null,null), ('jperalta99',5400,3,5900), ('glinetti99',null,null,null),
    ('cboyle99',null,null,1200), ('kjennings66',2000,9,43000), ('gburdell',null,null,null), ('pbeesly17',8400,2,14000),
    ('beyonce',9800,6,320985);
    
    insert into customer values
    ('arwhite6'), ('tjtalbot4'), ('owalter6'), ('rsanchez'), ('msmith'), ('asantiago99'), ('rholt99'), ('glinetti99'),
    ('cboyle99'), ('rdiaz99'), ('atrebek1'), ('kjennings66'), ('pbeesly17');
    
    insert into customer_contacts values
    ('arwhite6','mobile','333-182-9303'), ('arwhite6','email','amelia_whitehead@me.com'), ('tjtalbot4','mobile','845-101-2760'),
    ('tjtalbot4','home','236-464-1023'), ('tjtalbot4','email','tj_forever@aol.com'), ('owalter6','home','370-186-5341'),
    ('rsanchez','phone','000-098-7654'), ('msmith','email','morty@rm.com'), ('asantiago99','email','asantiago99@nypd.org'),
    ('asantiago99','fax','334-444-1234 x276'), ('pbeesly17','email','pb@dunder.com'), ('pbeesly17','email','jh@dunder.com'),
    ('msmith','phone','000-098-7654');
    
    insert into corporation values
    ('WF','Wells Fargo','Wells Fargo Bank National Association',33000000),
    ('BA','Bank of America','Bank of America Corporation',51000000),
    ('ST','Sun Trust','Sun Trust Banks/Truist Financial Corporation',39000000),
    ('NASA','NASA FCU','NASA Federal Credit Union',11000000),
    ('TD','TD Ameritrade','TD Ameritrade Holding Corporation',0),
    ('GS','Goldman Sachs','Goldman Sachs Group, Inc.',null);
    
    insert into bank values
    ('WF_1','Wells Fargo #1 Bank','1010 Binary Way','Seattle','WA','98101',127000,'WF','sville19'),
    ('WF_2','Wells Fargo #2 Bank','337 Firefly Lane','Seattle','WA','98101',553000,'WF','mmcgill4'),
    ('BA_West','Bank of America West Region Bank','865 Black Gold Circle','Dallas','TX','75116',267000,'BA','smcgill17'),
    ('NASA_Goddard','NASA FCU at Goddard SFC','8800 Greenbelt Road','Greenbelt','MD','20771',140000,'NASA','rsanchez'),
    ('TD_Online',null,null,null,null,null,0,'TD','kjennings66'),
    ('TD_GT','TD Ameritrade Midtown Branch','47 Tech Parkway','Atlanta','GA','30333',null,'TD','gburdell'),
    ('NASA_KSC','NASA FCU at Kennedy Space Center','1 Space Commerce Way','Cape Canaveral','FL','45678',0,'NASA','rholt99'),
    ('BA_South','Bank of America Plaza-Midtown','600 Peachtree Street NE','Atlanta','GA','30333',42000,'BA','ghopper9'),
    ('NASA_HAL','NASA FCU at US Space & Rocket Center','1 Tranquility Base Suite 203','Huntsville','AL','35805',null,'NASA','pbeesly17');
    
    insert into bank_account values
    ('WF_2','checking_A',2700), ('BA_West','checking_A',1000), ('NASA_Goddard','company_checking',null),
    ('NASA_KSC','company_checking',150000), ('TD_Online','company_checking',0), ('WF_2','market_X',27000),
    ('TD_Online','Roth_IRA',167000), ('TD_GT','Roth_IRA',15000), ('BA_South','GT_investments',16000),
    ('WF_2','savings_A',19400), ('BA_West','savings_B',8000), ('NASA_Goddard','company_savings',1000000),
    ('TD_GT','savings_A',8500), ('BA_South','GT_savings',9999);
    
    insert into interest_bearing values
    ('WF_2', 'market_X', 20, '2021-12-23'), ('TD_Online', 'Roth_IRA', 12, '2022-01-03'),
    ('TD_GT', 'Roth_IRA', 8, '2021-01-01'), ('BA_South', 'GT_investments', 4, '2020-03-11'),
    ('WF_2', 'savings_A', 10, '2021-11-05'), ('BA_West', 'savings_B', 6,' 2021-09-01'),
    ('NASA_Goddard', 'company_savings', null, null), ('TD_GT', 'savings_A', null, null),
    ('BA_South', 'GT_savings', 2, null);
    
    insert into interest_bearing_fees values
    ('WF_2','savings_A','low balance'), ('BA_West','savings_B','low balance'), ('BA_West','savings_B','overdraft'),
    ('WF_2','market_X','administrative'), ('WF_2','market_X','frequency'), ('WF_2','market_X','fee'),
    ('TD_Online','Roth_IRA','low balance'), ('TD_Online','Roth_IRA','withdrawal'),
    ('NASA_Goddard','company_savings','credit union'), ('BA_South','GT_investments','withdrawal');
    
    insert into savings values
    ('WF_2','savings_A',15000), ('BA_West','savings_B',10000), ('NASA_Goddard','company_savings',0),
    ('TD_GT','savings_A',0), ('BA_South','GT_savings',2000);
    
    insert into market values
    ('WF_2','market_X',2,1), ('TD_Online','Roth_IRA',0,0), ('TD_GT','Roth_IRA',null,null),
    ('BA_South','GT_investments',10,5);
    
    insert into checking values
    ('WF_2','checking_A', null, null, null, null),
    ('BA_West','checking_A','BA_West', 'savings_B', 600, '2021-12-08'),
    ('NASA_Goddard','company_checking', null, null, null, null),
    ('NASA_KSC','company_checking', null, null, null, null),
    ('TD_Online','company_checking', null, null, null, null);
    
    insert into workFor values
    ('WF_2','arwhite6'), ('WF_1','ealfaro4'), ('WF_2','ealfaro4'), ('BA_West','rnairn5'), ('BA_South','beyonce'),
    ('NASA_Goddard','beyonce'), ('TD_Online','beyonce'), ('TD_GT','jperalta99'), ('TD_GT','cboyle99'),
    ('NASA_KSC','jperalta99'), ('NASA_KSC','cboyle99'), ('NASA_HAL','jperalta99'), ('BA_West','glinetti99'),
    ('TD_Online','glinetti99');
    
    insert into access values
    ('arwhite6','WF_2','checking_A','2021-08-10','2022-01-26'), ('arwhite6','WF_2','savings_A','2021-08-10','2021-11-11'),
    ('tjtalbot4','WF_2','savings_A','2021-08-17','2022-02-03'), ('owalter6','BA_West','checking_A','2020-09-02',null),
    ('owalter6','BA_West','savings_B','2020-09-02',null), ('msmith','NASA_Goddard','company_checking','2018-10-11',null),
    ('rsanchez','NASA_Goddard','company_checking','2018-10-10','2022-02-04'), ('rsanchez','NASA_KSC','company_checking','2018-10-10','2022-01-13'),
    ('tjtalbot4','TD_Online','company_checking','2020-12-07','2020-12-07'), ('rholt99','WF_2','market_X','2022-02-02','2020-02-04'),
    ('asantiago99','WF_2','market_X','2020-02-02','2020-02-04'), ('cboyle99','TD_Online','Roth_IRA','2021-09-26',null),
    ('glinetti99','TD_Online','Roth_IRA','2019-12-24',null), ('msmith','TD_GT','Roth_IRA','2021-01-01','2022-01-01'),
    ('kjennings66','BA_South','GT_investments','2009-08-09',null), ('rsanchez','NASA_Goddard','company_savings','2014-08-16',null),
    ('pbeesly17','TD_GT','savings_A','2021-09-09',null), ('atrebek1','BA_South','GT_savings','2015-12-31','2017-03-22'),
    ('kjennings66','BA_South','GT_savings','2010-08-09','2022-02-21');
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [2] Create views to evaluate the queries & transactions
-- ----------------------------------------------------------------------------------
    
-- Create one view per original base table and student-created view to be used
-- to evaluate the transaction results.
create or replace view practiceQuery10 as select * from person;
create or replace view practiceQuery11 as select * from system_admin;
create or replace view practiceQuery12 as select * from bank_user;
create or replace view practiceQuery13 as select * from employee;
create or replace view practiceQuery14 as select * from customer;
create or replace view practiceQuery15 as select * from customer_contacts;
create or replace view practiceQuery16 as select * from corporation;
create or replace view practiceQuery17 as select * from bank;
create or replace view practiceQuery18 as select * from bank_account;
create or replace view practiceQuery19 as select * from interest_bearing;
create or replace view practiceQuery20 as select * from interest_bearing_fees;
create or replace view practiceQuery21 as select * from savings;
create or replace view practiceQuery22 as select * from market;
create or replace view practiceQuery23 as select * from checking;
create or replace view practiceQuery24 as select * from workFor;
create or replace view practiceQuery25 as select * from access;

create or replace view practiceQuery30 as select * from display_account_stats;
create or replace view practiceQuery31 as select * from display_bank_stats;
create or replace view practiceQuery32 as select * from display_corporation_stats;
create or replace view practiceQuery33 as select * from display_customer_stats;
create or replace view practiceQuery34 as select * from display_employee_stats;

-- ----------------------------------------------------------------------------------
-- [3] Prepare to capture the query results for later analysis
-- ----------------------------------------------------------------------------------

-- The magic44_data_capture table is used to store the data created by the student's queries
-- The table is populated by the magic44_evaluate_queries stored procedure
-- The data in the table is used to populate the magic44_test_results table for analysis

drop table if exists magic44_data_capture;
create table magic44_data_capture (
	stepID integer, queryID integer,
    columnDump0 varchar(1000), columnDump1 varchar(1000), columnDump2 varchar(1000), columnDump3 varchar(1000), columnDump4 varchar(1000),
    columnDump5 varchar(1000), columnDump6 varchar(1000), columnDump7 varchar(1000), columnDump8 varchar(1000), columnDump9 varchar(1000),
	columnDump10 varchar(1000), columnDump11 varchar(1000), columnDump12 varchar(1000), columnDump13 varchar(1000), columnDump14 varchar(1000)
);

-- The magic44_column_listing table is used to help prepare the insert statements for the magic44_data_capture
-- table for the student's queries which may have variable numbers of columns (the table is prepopulated)

drop table if exists magic44_column_listing;
create table magic44_column_listing (
	columnPosition integer,
    simpleColumnName varchar(50),
    nullColumnName varchar(50)
);

insert into magic44_column_listing (columnPosition, simpleColumnName) values
(0, 'columnDump0'), (1, 'columnDump1'), (2, 'columnDump2'), (3, 'columnDump3'), (4, 'columnDump4'),
(5, 'columnDump5'), (6, 'columnDump6'), (7, 'columnDump7'), (8, 'columnDump8'), (9, 'columnDump9'),
(10, 'columnDump10'), (11, 'columnDump11'), (12, 'columnDump12'), (13, 'columnDump13'), (14, 'columnDump14');

drop function if exists magic44_gen_simple_template;
delimiter //
create function magic44_gen_simple_template(numberOfColumns integer)
	returns varchar(1000) deterministic
begin
return (select group_concat(simpleColumnName separator ", ") from magic44_column_listing
	where columnPosition < numberOfColumns);
end //
delimiter ;

-- Create a variable to effectively act as a program counter for the testing process/steps
set @stepCounter = 0;

-- The magic44_query_capture function is used to construct the instruction
-- that can be used to execute and store the results of a query

drop function if exists magic44_query_capture;
delimiter //
create function magic44_query_capture(thisQuery integer)
	returns varchar(1000) deterministic
begin
	set @numberOfColumns = (select count(*) from information_schema.columns
		where table_schema = @thisDatabase
        and table_name = concat('practiceQuery', thisQuery));

	set @buildQuery = "insert into magic44_data_capture (stepID, queryID, ";
    set @buildQuery = concat(@buildQuery, magic44_gen_simple_template(@numberOfColumns));
    set @buildQuery = concat(@buildQuery, ") select ");
    set @buildQuery = concat(@buildQuery, @stepCounter, ", ");
    set @buildQuery = concat(@buildQuery, thisQuery, ", practiceQuery");
    set @buildQuery = concat(@buildQuery, thisQuery, ".* from practiceQuery");
    set @buildQuery = concat(@buildQuery, thisQuery, ";");

return @buildQuery;
end //
delimiter ;

drop function if exists magic44_query_exists;
delimiter //
create function magic44_query_exists(thisQuery integer)
	returns integer deterministic
begin
	return (select exists (select * from information_schema.views
		where table_schema = @thisDatabase
        and table_name like concat('practiceQuery', thisQuery)));
end //
delimiter ;

-- Exception checking has been implemented to prevent (as much as reasonably possible) errors
-- in the queries being evaluated from interrupting the testing process
-- The magic44_log_query_errors table captures these errors for later review

drop table if exists magic44_log_query_errors;
create table magic44_log_query_errors (
	step_id integer,
    query_id integer,
    error_code char(5),
    error_message text
);

drop procedure if exists magic44_query_check_and_run;
delimiter //
create procedure magic44_query_check_and_run(in thisQuery integer)
begin
	declare err_code char(5) default '00000';
    declare err_msg text;

	declare continue handler for SQLEXCEPTION
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

    declare continue handler for SQLWARNING
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

	if magic44_query_exists(thisQuery) then
		set @sql_text = magic44_query_capture(thisQuery);
		prepare statement from @sql_text;
        execute statement;
        if err_code <> '00000' then
			insert into magic44_log_query_errors values (@stepCounter, thisQuery, err_code, err_msg);
		end if;
        deallocate prepare statement;
	end if;
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [4] Organize the testing results by step and query identifiers
-- ----------------------------------------------------------------------------------

drop table if exists magic44_test_case_directory;
create table if not exists magic44_test_case_directory (
	base_step_id integer,
	number_of_steps integer,
    query_label char(20),
    query_name varchar(100),
    scoring_weight integer
);

insert into magic44_test_case_directory values
(0, 1, '[V_0]', 'initial_state_check',0),
(10, 1, '[C_1]', 'create_corporation', 1),
(20, 1, '[C_2]', 'create_bank', 1),
(30, 1, '[C_3]', 'start_employee_role', 1),
(40, 1, '[C_4]', 'start_customer_role', 1),
(50, 1, '[R_1]', 'stop_employee_role', 1),
(60, 2, '[R_2]', 'stop_customer_role', 5),
(70, 2, '[U_1]', 'hire_worker', 1), -- I think this should be a C, not U
(80, 2, '[U_2]', 'replace_manager', 1),
(90, 3, '[C_5]', 'add_account_access', 3),
(100, 3, '[R_3]', 'remove_account_access', 3),
(110, 2, '[C_6]', 'create_fee', 1),
(120, 1, '[C_7]', 'start_overdraft', 2),
(130, 1, '[R_4]', 'stop_overdraft', 2),
(140, 1, '[U_3]', 'account_deposit', 3),
(150, 3, '[U_4]', 'account_withdrawal', 4),
(160, 2, '[U_5]', 'account_transfer', 4),
(170, 1, '[U_6]', 'pay_employees', 2),
(180, 1, '[U_7]', 'penalize_accounts', 4),
(190, 1, '[U_8]', 'accrue_interest', 2),
(200, 1, '[V_1]', 'display_account_stats', 1),
(210, 1, '[V_2]', 'display_bank_stats', 1),
(220, 1, '[V_3]', 'display_corporation_stats', 1),
(230, 1, '[V_4]', 'display_customer_stats', 1),
(240, 1, '[V_5]', 'display_employee_stats', 1);

drop table if exists magic44_scores_guide;
create table if not exists magic44_scores_guide (
    score_tag char(1),
    score_category varchar(100),
    display_order integer
);

insert into magic44_scores_guide values
('C', 'Create Transactions', 1), ('U', 'Use Case Transactions', 2),
('R', 'Remove Transactions', 3), ('V', 'Global Views/Queries', 4),
('E', 'Event Scenarios/Sequences', 5);

-- ----------------------------------------------------------------------------------
-- [5] Test the queries & transactions and store the results
-- ----------------------------------------------------------------------------------

-- Check that the initial state of their database matches the required configuration
-- The magic44_reset_database_state() call is missing in order to monitor the submitted database
set @stepCounter = 0;
call magic44_query_check_and_run(10); -- person
call magic44_query_check_and_run(11); -- system_admin
call magic44_query_check_and_run(12); -- bank_user
call magic44_query_check_and_run(13); -- employee
call magic44_query_check_and_run(14); -- customer
call magic44_query_check_and_run(15); -- customer_contacts
call magic44_query_check_and_run(16); -- corporation
call magic44_query_check_and_run(17); -- bank
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(19); -- interest_bearing
call magic44_query_check_and_run(20); -- interest_bearing_fees
call magic44_query_check_and_run(21); -- savings
call magic44_query_check_and_run(22); -- market
call magic44_query_check_and_run(23); -- checking
call magic44_query_check_and_run(24); -- workFor
call magic44_query_check_and_run(25); -- access

-- Place the remaining test cases here
-- [1] create_corporation()
-- Success: attempt create a corporation that does not already exist in the database
call magic44_reset_database_state();
call create_corporation("CHASE", "Chase", "Chase Bank", "22000000");
set @stepCounter = 10;
call magic44_query_check_and_run(16); -- corporation


-- [2] create_bank()
 -- Success: attempt to create a bank that has not been created yet with a valid manager
call magic44_reset_database_state();
call create_bank('BA_North','Bank of America New York','150 Broadway','New York','NY','10038', 359000,'BA','lgibbs4', 'cboyle99');
set @stepCounter = 20;
call magic44_query_check_and_run(17); -- bank
call magic44_query_check_and_run(24); -- workFor


-- [3] start_employee_role()
-- Success: Person does not exist, so attempt to create a new employee
call magic44_reset_database_state();
call start_employee_role('alovelace99', '000-27-0005', 'Ada', 'Lovelace', '2000-01-20', 'Augusta Byron Dr NE', 'Atlanta', 'GA', '30333', '2021-12-04', 52000, 10, 520000, 'password16');
set @stepCounter = 30;
call magic44_query_check_and_run(10); -- person
call magic44_query_check_and_run(12); -- bank_user
call magic44_query_check_and_run(13); -- employee


-- [4] start_customer_role()
-- Success: Person does not exist, so attempt to create a new customer
call magic44_reset_database_state();
call start_customer_role('cbabbage99', '553-27-0005', 'Charles', 'Babbage', '1980-04-12', 'Augusta Byron Dr NE', 'Atlanta', 'GA', '30333', '2010-02-01', 'password103');
set @stepCounter = 40;
call magic44_query_check_and_run(10); -- person
call magic44_query_check_and_run(12); -- bank_user
call magic44_query_check_and_run(14); -- customer

-- [5] stop_employee_role()
-- Success: attempt to remove a employee that functions strictly as an employee and works at a bank with >= 2 employees and at only 1 bank. Corrosponding rows should be removed from person, employee, bank_user, and workfor tables.
call magic44_reset_database_state();
call stop_employee_role("rnairn5");
set @stepCounter = 50;
call magic44_query_check_and_run(24); -- workFor
call magic44_query_check_and_run(13); -- employee
call magic44_query_check_and_run(12); -- bank_user
call magic44_query_check_and_run(10); -- person


-- Query [6] stop customer role
-- Success: attempt to remove a customer with all accounts owned by him having >= 2 sharers who is not an employee results in removal from customer_contacts, customer, bank_user and person relations
call magic44_reset_database_state();
call stop_customer_role("asantiago99");
set @stepCounter = 60;
call magic44_query_check_and_run(25); -- access
call magic44_query_check_and_run(15); -- customer_contacts
call magic44_query_check_and_run(14); -- customer
call magic44_query_check_and_run(12); -- bank_user
call magic44_query_check_and_run(10); -- person

-- Failure: ip_perID does not exist results in no change in DB
call magic44_reset_database_state();
call stop_customer_role("nonexistent");
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(25); -- access
call magic44_query_check_and_run(15); -- customer_contacts
call magic44_query_check_and_run(14); -- customer
call magic44_query_check_and_run(12); -- bank_user
call magic44_query_check_and_run(10); -- person


-- [7] hire_worker()
-- Success: an existing employee that does not work for any bank is hired, new entry in works_for and updated salary.
call magic44_reset_database_state();
call hire_worker('lgibbs4', 'NASA_Goddard', 1400);
set @stepCounter = 70;
call magic44_query_check_and_run(13); -- Employee
call magic44_query_check_and_run(24); -- workFor

-- Failure: an employee that currently manages a bank tries to be hired by the bank they manage.
call magic44_reset_database_state();
call hire_worker('rsanchez', 'NASA_Goddard', 137);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(13); -- Employee
call magic44_query_check_and_run(24); -- workFor


-- Query [8]
-- Success: an existing employee that does not work or manage anywhere is the new manager: updated bank.manager attribute, updated employee salary.
call magic44_reset_database_state();
call replace_manager('lgibbs4', 'TD_GT', 5000);
set @stepCounter = 80;
call magic44_query_check_and_run(13); -- Employee
call magic44_query_check_and_run(17); -- Bank

-- Failure: an existing employee that works at a bank attempts to become a manager.
call magic44_reset_database_state();
call replace_manager('jperalta99', 'TD_GT', 5099);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(13); -- Employee
call magic44_query_check_and_run(17); -- Bank


-- Query [9]
-- Success: A new checking account is created by an existing admin for an existing customer with valid checking inputs
call magic44_reset_database_state();
call add_account_access('mmoss7', 'atrebek1', 'checking', 'TD_GT', 'new_checking', 4000, null, null, null, null, null, '2022-03-04');
set @stepCounter = 90;
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(23); -- checking
call magic44_query_check_and_run(25); -- access

-- Success: A new savings account is created by an existing admin for an existing customer with valid savings inputs
call magic44_reset_database_state();
call add_account_access('mmoss7', 'atrebek1', 'savings', 'TD_GT', 'new_savings', 4000, 10, null, 0, null, null, '2022-03-03');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(19); -- interest_bearing
call magic44_query_check_and_run(21); -- savings
call magic44_query_check_and_run(25); -- access

-- Success: A new market account is created by an existing admin for an existing customer with valid market inputs
call magic44_reset_database_state();
call add_account_access('mmoss7', 'atrebek1', 'market', 'TD_GT', 'new_market', 4000, 12, null, null, 0, 4, '2022-03-04');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(19); -- interest_bearing
call magic44_query_check_and_run(22); -- market
call magic44_query_check_and_run(25); -- access

-- Query [10]
-- Success: A customer is removed from an account they own by another account owner.
call magic44_reset_database_state();
call remove_account_access('msmith', 'rsanchez', 'NASA_Goddard', 'company_checking');
set @stepCounter = 100;
call magic44_query_check_and_run(25); -- access

-- Success: A customer is removed from an account they own (which has other owners) by an admin.
call magic44_reset_database_state();
call remove_account_access('mmoss7', 'cboyle99', 'TD_Online', 'Roth_IRA');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(25); -- access

-- Success: A customer removes themselves from an account of which they are the only owner, and the account is closed.
call magic44_reset_database_state();
call remove_account_access('pbeesly17', 'pbeesly17', 'TD_GT', 'savings_A');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(19); -- interest_bearing
call magic44_query_check_and_run(21); -- savings
call magic44_query_check_and_run(25); -- access

-- Query [11]
-- Success: A new fee is created for an existing market account.
call magic44_reset_database_state();
call create_fee('WF_2', 'market_X', 'new fee');
set @stepCounter = 110;
call magic44_query_check_and_run(20); -- interest_bearing_fee

-- Success: A new fee is created for an existing savings account.
call magic44_reset_database_state();
call create_fee('WF_2', 'savings_A', 'new fee');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(20); -- interest_bearing_fee


-- Query [12]
-- Success: An overdraft policy is started between a checking and savings account by a customer who owns both accounts, and neither account already participates in another overdraft policy.
call magic44_reset_database_state();
call start_overdraft('tjtalbot4', 'TD_Online', 'company_checking', 'WF_2', 'savings_A');
set @stepCounter = 120;
call magic44_query_check_and_run(23); -- checking
-- Checking the "checking" table because that is where the overdraft information is stored.


-- [13] stop_overdraft()
-- Success: attempt to stop overdraft with valid values and access to the account results in a change in the checking table
call magic44_reset_database_state();
call stop_overdraft("owalter6", "BA_West", "checking_A");
set @stepCounter = 130;
call magic44_query_check_and_run(23); -- checking
call magic44_query_check_and_run(25); -- access

-- [14] account_deposit()
-- Success: attempting to deposit money in account which is not an interest-bearing account updates only the bank_account balance and access dtAction
call magic44_reset_database_state();
call account_deposit("owalter6", 500, "BA_West", "checking_A", "2022-02-02");
set @stepCounter = 140;
call magic44_query_check_and_run(25); -- access
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(19); -- interest_bearing


-- [15] account_withdrawal()
-- Success: attempt to withdraw from market account should correctly adjust bank_account, access and market tables
call magic44_reset_database_state();
call account_withdrawal("kjennings66", 1500, "BA_South", "GT_investments", "2022-02-02");
set @stepCounter = 150;
call magic44_query_check_and_run(25); -- access
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(23); -- checking
call magic44_query_check_and_run(22); -- market

-- Success: attempt to withdraw from checking account should correctly adjust bank_account, access and overdraft account
call magic44_reset_database_state();
call account_withdrawal("owalter6", 1500, "BA_West", "checking_A", "2022-02-02");
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(25); -- access
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(23); -- checking
call magic44_query_check_and_run(22); -- market

-- Success: attempt to withdraw from savings account
call magic44_reset_database_state();
call account_withdrawal("rsanchez", 200, "NASA_Goddard", "company_savings",  "2022-02-02");
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(25); -- access
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(23); -- checking
call magic44_query_check_and_run(22); -- market


-- [16] account_transfer()
-- Success: (Checking -> any) Both accounts are at the same bank, checking account has more than enough money to transfer, and sender has access to both accounts
call magic44_reset_database_state();
call account_transfer('arwhite6', 2000, 'WF_2', 'checking_A', 'WF_2', 'savings_A', '2022-02-02');
set @stepCounter = 160;
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(23); -- checking

-- Success: (Checking -> any) Both accounts are at different banks, checking account has more than enough money to transfer, and sender has access to both accounts
call magic44_reset_database_state();
call account_transfer('rsanchez', 2000, 'NASA_KSC', 'company_checking', 'NASA_Goddard', 'company_checking', '2022-02-02');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(18); -- bank_account
call magic44_query_check_and_run(23); -- checking


-- [17] pay_employees()
-- Success: all employees at all banks paid correctly
call magic44_reset_database_state();
call pay_employees();
set @stepCounter = 170;
call magic44_query_check_and_run(13); -- employee
call magic44_query_check_and_run(17); -- bank

-- [18] penalize_accounts()
-- Success: all applicable accounts correctly penalized
call magic44_reset_database_state();
call penalize_accounts();
set @stepCounter = 180;
call magic44_query_check_and_run(17); -- bank
call magic44_query_check_and_run(18); -- bank_account

-- [19] accrue_interest()
-- Success: all applicable accounts gain interest
call magic44_reset_database_state();
call accrue_interest();
set @stepCounter = 190;
call magic44_query_check_and_run(17); -- bank
call magic44_query_check_and_run(18); -- bank_account


-- Query [20] display_account_stats()
-- The view with no changes to data
call magic44_reset_database_state();
set @stepCounter = 200;
call magic44_query_check_and_run(30);


-- Query [21] display_bank_stats()
-- The view with no changes to data
call magic44_reset_database_state();
set @stepCounter = 210;
call magic44_query_check_and_run(31);


-- Query [22] display_corporation_stats()
-- The view with no changes to data
call magic44_reset_database_state();
set @stepCounter = 220;
call magic44_query_check_and_run(32);


-- Query [23] display_customer_stats()
-- The view with no changes to data
call magic44_reset_database_state();
set @stepCounter = 230;
call magic44_query_check_and_run(33);


-- Query [24] display_employee_stats()
-- The view with no changes to data
call magic44_reset_database_state();
set @stepCounter = 240;
call magic44_query_check_and_run(34);


-- ----------------------------------------------------------------------------------
-- [6] Collect and analyze the testing results for the student's submission
-- ----------------------------------------------------------------------------------

-- These tables are used to store the answers and test results.  The answers are generated by executing
-- the test script against our reference solution.  The test results are collected by running the test
-- script against your submission in order to compare the results.

-- The results from magic44_data_capture are transferred into the magic44_test_results table
drop table if exists magic44_test_results;
create table magic44_test_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

insert into magic44_test_results
select stepID, queryID, concat_ws('#', ifnull(columndump0, ''), ifnull(columndump1, ''), ifnull(columndump2, ''), ifnull(columndump3, ''),
ifnull(columndump4, ''), ifnull(columndump5, ''), ifnull(columndump6, ''), ifnull(columndump7, ''), ifnull(columndump8, ''), ifnull(columndump9, ''),
ifnull(columndump10, ''), ifnull(columndump11, ''), ifnull(columndump12, ''), ifnull(columndump13, ''), ifnull(columndump14, ''))
from magic44_data_capture;

-- the answers generated from the reference solution are loaded below
drop table if exists magic44_expected_results;
create table magic44_expected_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null,
    index (step_id),
    index (query_id)
);

INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'arwhite6#password5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'asantiago99#password17#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'atrebek1#password23#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'beyonce#password27#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'cboyle99#password21#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'dscully5#password3#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'ealfaro4#password6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'fmulder8#password4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'gburdell#password25#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'ghopper9#password16#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'glinetti99#password20#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'jperalta99#password19#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'kjennings66#password24#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'lgibbs4#password15#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'mmcgill4#password7#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'mmoss7#password1#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'msmith#password14#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'owalter6#password12#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'pbeesly17#password26#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'rdiaz99#password22#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'rholt99#password18#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'rnairn5#password9#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'rsanchez#password13#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'smcgill17#password10#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'sville19#password8#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'tjtalbot4#password11#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,10,'tmcgee1#password2#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,11,'dscully5##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,11,'fmulder8##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,11,'mmoss7##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,11,'tmcgee1##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'arwhite6#053-87-1120#1960-06-06#amelia-rose#whitehead#2021-12-03#60nightshadecourt#baltimore#md#21217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'asantiago99#765-43-2109#1983-07-04#amy#santiago#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'atrebek1#000-00-0000#1940-07-22#alex#trebek#2014-03-22#10202westwashingtonboulevard#culvercity#ca#90232#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'beyonce#444-55-666#1981-09-04#beyonce##2014-02-02#222stargrove#houston#tx#77077#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'cboyle99#433-12-1200#1982-09-04#charles#boyle#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'ealfaro4#278-78-7676#1960-06-06#evie#alfaro#2021-12-27#314fivefingersway#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'gburdell#404-00-0000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'ghopper9#101-00-1111#1906-12-09#grace#hopper#2019-12-25#1broadway#newyork#ny#10004#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'glinetti99#233-76-0019#1986-03-20#gina#linetti#2019-04-04#75alluredrive#newyork#ny#11220#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'jperalta99#775-33-6054#1981-09-04#jake#peralta#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'kjennings66#004-52-2700#1974-05-23#ken#jennings#2005-09-07#74championsheights#edmonds#wa#98020#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'lgibbs4#304-39-1098#1954-11-21#leroy#gibbs#2021-06-16#50mountainspur#stillwater#pa#17878#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'mmcgill4#623-09-0887#1955-06-23#maheen#mcgill#2020-09-08#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'msmith#246-80-1234#1999-04-04#morty#smith#2017-08-21#137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'owalter6#346-51-9139#1971-10-23#om#walter#2020-04-29#143snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'pbeesly17#664-98-7654##pam#beesly#2021-06-06#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'rdiaz99#687-54-1033#1984-11-30#rosa#diaz#2020-12-24#3eastparkloop#yonkers#ny#10112#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'rholt99#111-22-3333#1955-01-01#raymond#holt#2022-01-01#123mainstreet#perthamboy#nj#08861#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'rnairn5#404-51-1036#1959-07-13#roxanne#nairn#2021-08-16#2048transparencyroad#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'rsanchez#012-34-5678#1936-08-22#rick#sanchez##137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'smcgill17#238-40-5070#1954-06-02#saqlain#mcgill#2020-09-11#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'sville19#354-10-6263#1965-03-16#sahar#villegas#2020-06-16#10downingroad#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,12,'tjtalbot4#203-46-3005#1978-05-10#tj#talbot#2020-03-25#101snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'arwhite6#4700#6#28200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'beyonce#9800#6#320985###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'cboyle99###1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'ealfaro4#5600#3#17100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'gburdell##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'ghopper9#49500#5#447999###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'jperalta99#5400#3#5900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'kjennings66#2000#9#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'lgibbs4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'mmcgill4#9400#3#29100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'pbeesly17#8400#2#14000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'rnairn5#5100#5#27400###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'rsanchez#49500#10#654321###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'smcgill17#8800#3#33700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,13,'sville19#8000#4#35000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'arwhite6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'asantiago99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'atrebek1##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'cboyle99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'kjennings66##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'msmith##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'owalter6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'pbeesly17##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'rdiaz99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'rsanchez##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,14,'tjtalbot4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'arwhite6#email#amelia_whitehead@me.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'arwhite6#mobile#333-182-9303############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'asantiago99#email#asantiago99@nypd.org############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'asantiago99#fax#334-444-1234x276############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'msmith#email#morty@rm.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'msmith#phone#000-098-7654############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'owalter6#home#370-186-5341############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'pbeesly17#email#jh@dunder.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'pbeesly17#email#pb@dunder.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'rsanchez#phone#000-098-7654############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'tjtalbot4#email#tj_forever@aol.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'tjtalbot4#home#236-464-1023############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,15,'tjtalbot4#mobile#845-101-2760############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,16,'ba#bankofamerica#bankofamericacorporation#51000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,16,'gs#goldmansachs#goldmansachsgroup,inc.############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,16,'nasa#nasafcu#nasafederalcreditunion#11000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,16,'st#suntrust#suntrustbanks/truistfinancialcorporation#39000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,16,'td#tdameritrade#tdameritradeholdingcorporation#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,16,'wf#wellsfargo#wellsfargobanknationalassociation#33000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'ba_south#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#42000#ba#ghopper9######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'ba_west#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#267000#ba#smcgill17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'nasa_goddard#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#140000#nasa#rsanchez######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'nasa_hal#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805##nasa#pbeesly17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'nasa_ksc#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#0#nasa#rholt99######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'td_gt#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333##td#gburdell######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'td_online######0#td#kjennings66######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'wf_1#wellsfargo#1bank#1010binaryway#seattle#wa#98101#127000#wf#sville19######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,17,'wf_2#wellsfargo#2bank#337fireflylane#seattle#wa#98101#553000#wf#mmcgill4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'ba_south#gt_investments#4#2020-03-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'ba_south#gt_savings#2############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'ba_west#savings_b#6#2021-09-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'nasa_goddard#company_savings#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'td_gt#roth_ira#8#2021-01-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'td_gt#savings_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'td_online#roth_ira#12#2022-01-03###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'wf_2#market_x#20#2021-12-23###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,19,'wf_2#savings_a#10#2021-11-05###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'ba_south#gt_investments#withdrawal############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'ba_west#savings_b#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'ba_west#savings_b#overdraft############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'nasa_goddard#company_savings#creditunion############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'td_online#roth_ira#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'td_online#roth_ira#withdrawal############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'wf_2#market_x#administrative############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'wf_2#market_x#fee############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'wf_2#market_x#frequency############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,20,'wf_2#savings_a#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,21,'ba_south#gt_savings#2000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,21,'ba_west#savings_b#10000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,21,'nasa_goddard#company_savings#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,21,'td_gt#savings_a#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,21,'wf_2#savings_a#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,22,'ba_south#gt_investments#10#5###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,22,'td_gt#roth_ira#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,22,'td_online#roth_ira#0#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,22,'wf_2#market_x#2#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,23,'ba_west#checking_a#ba_west#savings_b#600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'wf_2#arwhite6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'ba_south#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'nasa_goddard#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'td_online#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'nasa_ksc#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'td_gt#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'wf_1#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'wf_2#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'ba_west#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'td_online#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'nasa_hal#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'nasa_ksc#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'td_gt#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,24,'ba_west#rnairn5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (0,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (10,16,'ba#bankofamerica#bankofamericacorporation#51000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (10,16,'chase#chase#chasebank#22000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (10,16,'gs#goldmansachs#goldmansachsgroup,inc.############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (10,16,'nasa#nasafcu#nasafederalcreditunion#11000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (10,16,'st#suntrust#suntrustbanks/truistfinancialcorporation#39000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (10,16,'td#tdameritrade#tdameritradeholdingcorporation#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (10,16,'wf#wellsfargo#wellsfargobanknationalassociation#33000000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'ba_north#bankofamericanewyork#150broadway#newyork#ny#10038#359000#ba#lgibbs4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'ba_south#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#42000#ba#ghopper9######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'ba_west#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#267000#ba#smcgill17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'nasa_goddard#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#140000#nasa#rsanchez######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'nasa_hal#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805##nasa#pbeesly17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'nasa_ksc#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#0#nasa#rholt99######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'td_gt#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333##td#gburdell######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'td_online######0#td#kjennings66######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'wf_1#wellsfargo#1bank#1010binaryway#seattle#wa#98101#127000#wf#sville19######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,17,'wf_2#wellsfargo#2bank#337fireflylane#seattle#wa#98101#553000#wf#mmcgill4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'wf_2#arwhite6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'ba_south#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'nasa_goddard#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'td_online#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'ba_north#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'nasa_ksc#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'td_gt#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'wf_1#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'wf_2#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'ba_west#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'td_online#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'nasa_hal#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'nasa_ksc#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'td_gt#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (20,24,'ba_west#rnairn5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'alovelace99#password16#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'arwhite6#password5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'asantiago99#password17#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'atrebek1#password23#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'beyonce#password27#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'cboyle99#password21#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'dscully5#password3#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'ealfaro4#password6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'fmulder8#password4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'gburdell#password25#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'ghopper9#password16#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'glinetti99#password20#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'jperalta99#password19#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'kjennings66#password24#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'lgibbs4#password15#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'mmcgill4#password7#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'mmoss7#password1#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'msmith#password14#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'owalter6#password12#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'pbeesly17#password26#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'rdiaz99#password22#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'rholt99#password18#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'rnairn5#password9#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'rsanchez#password13#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'smcgill17#password10#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'sville19#password8#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'tjtalbot4#password11#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,10,'tmcgee1#password2#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'alovelace99#000-27-0005#2000-01-20#ada#lovelace#2021-12-04#augustabyrondrne#atlanta#ga#30333#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'arwhite6#053-87-1120#1960-06-06#amelia-rose#whitehead#2021-12-03#60nightshadecourt#baltimore#md#21217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'asantiago99#765-43-2109#1983-07-04#amy#santiago#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'atrebek1#000-00-0000#1940-07-22#alex#trebek#2014-03-22#10202westwashingtonboulevard#culvercity#ca#90232#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'beyonce#444-55-666#1981-09-04#beyonce##2014-02-02#222stargrove#houston#tx#77077#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'cboyle99#433-12-1200#1982-09-04#charles#boyle#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'ealfaro4#278-78-7676#1960-06-06#evie#alfaro#2021-12-27#314fivefingersway#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'gburdell#404-00-0000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'ghopper9#101-00-1111#1906-12-09#grace#hopper#2019-12-25#1broadway#newyork#ny#10004#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'glinetti99#233-76-0019#1986-03-20#gina#linetti#2019-04-04#75alluredrive#newyork#ny#11220#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'jperalta99#775-33-6054#1981-09-04#jake#peralta#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'kjennings66#004-52-2700#1974-05-23#ken#jennings#2005-09-07#74championsheights#edmonds#wa#98020#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'lgibbs4#304-39-1098#1954-11-21#leroy#gibbs#2021-06-16#50mountainspur#stillwater#pa#17878#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'mmcgill4#623-09-0887#1955-06-23#maheen#mcgill#2020-09-08#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'msmith#246-80-1234#1999-04-04#morty#smith#2017-08-21#137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'owalter6#346-51-9139#1971-10-23#om#walter#2020-04-29#143snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'pbeesly17#664-98-7654##pam#beesly#2021-06-06#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'rdiaz99#687-54-1033#1984-11-30#rosa#diaz#2020-12-24#3eastparkloop#yonkers#ny#10112#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'rholt99#111-22-3333#1955-01-01#raymond#holt#2022-01-01#123mainstreet#perthamboy#nj#08861#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'rnairn5#404-51-1036#1959-07-13#roxanne#nairn#2021-08-16#2048transparencyroad#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'rsanchez#012-34-5678#1936-08-22#rick#sanchez##137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'smcgill17#238-40-5070#1954-06-02#saqlain#mcgill#2020-09-11#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'sville19#354-10-6263#1965-03-16#sahar#villegas#2020-06-16#10downingroad#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,12,'tjtalbot4#203-46-3005#1978-05-10#tj#talbot#2020-03-25#101snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'alovelace99#52000#10#520000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'arwhite6#4700#6#28200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'beyonce#9800#6#320985###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'cboyle99###1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'ealfaro4#5600#3#17100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'gburdell##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'ghopper9#49500#5#447999###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'jperalta99#5400#3#5900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'kjennings66#2000#9#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'lgibbs4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'mmcgill4#9400#3#29100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'pbeesly17#8400#2#14000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'rnairn5#5100#5#27400###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'rsanchez#49500#10#654321###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'smcgill17#8800#3#33700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (30,13,'sville19#8000#4#35000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'arwhite6#password5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'asantiago99#password17#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'atrebek1#password23#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'beyonce#password27#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'cbabbage99#password103#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'cboyle99#password21#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'dscully5#password3#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'ealfaro4#password6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'fmulder8#password4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'gburdell#password25#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'ghopper9#password16#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'glinetti99#password20#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'jperalta99#password19#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'kjennings66#password24#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'lgibbs4#password15#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'mmcgill4#password7#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'mmoss7#password1#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'msmith#password14#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'owalter6#password12#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'pbeesly17#password26#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'rdiaz99#password22#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'rholt99#password18#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'rnairn5#password9#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'rsanchez#password13#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'smcgill17#password10#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'sville19#password8#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'tjtalbot4#password11#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,10,'tmcgee1#password2#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'arwhite6#053-87-1120#1960-06-06#amelia-rose#whitehead#2021-12-03#60nightshadecourt#baltimore#md#21217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'asantiago99#765-43-2109#1983-07-04#amy#santiago#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'atrebek1#000-00-0000#1940-07-22#alex#trebek#2014-03-22#10202westwashingtonboulevard#culvercity#ca#90232#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'beyonce#444-55-666#1981-09-04#beyonce##2014-02-02#222stargrove#houston#tx#77077#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'cbabbage99#553-27-0005#1980-04-12#charles#babbage#2010-02-01#augustabyrondrne#atlanta#ga#30333#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'cboyle99#433-12-1200#1982-09-04#charles#boyle#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'ealfaro4#278-78-7676#1960-06-06#evie#alfaro#2021-12-27#314fivefingersway#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'gburdell#404-00-0000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'ghopper9#101-00-1111#1906-12-09#grace#hopper#2019-12-25#1broadway#newyork#ny#10004#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'glinetti99#233-76-0019#1986-03-20#gina#linetti#2019-04-04#75alluredrive#newyork#ny#11220#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'jperalta99#775-33-6054#1981-09-04#jake#peralta#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'kjennings66#004-52-2700#1974-05-23#ken#jennings#2005-09-07#74championsheights#edmonds#wa#98020#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'lgibbs4#304-39-1098#1954-11-21#leroy#gibbs#2021-06-16#50mountainspur#stillwater#pa#17878#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'mmcgill4#623-09-0887#1955-06-23#maheen#mcgill#2020-09-08#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'msmith#246-80-1234#1999-04-04#morty#smith#2017-08-21#137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'owalter6#346-51-9139#1971-10-23#om#walter#2020-04-29#143snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'pbeesly17#664-98-7654##pam#beesly#2021-06-06#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'rdiaz99#687-54-1033#1984-11-30#rosa#diaz#2020-12-24#3eastparkloop#yonkers#ny#10112#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'rholt99#111-22-3333#1955-01-01#raymond#holt#2022-01-01#123mainstreet#perthamboy#nj#08861#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'rnairn5#404-51-1036#1959-07-13#roxanne#nairn#2021-08-16#2048transparencyroad#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'rsanchez#012-34-5678#1936-08-22#rick#sanchez##137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'smcgill17#238-40-5070#1954-06-02#saqlain#mcgill#2020-09-11#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'sville19#354-10-6263#1965-03-16#sahar#villegas#2020-06-16#10downingroad#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,12,'tjtalbot4#203-46-3005#1978-05-10#tj#talbot#2020-03-25#101snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'arwhite6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'asantiago99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'atrebek1##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'cbabbage99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'cboyle99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'kjennings66##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'msmith##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'owalter6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'pbeesly17##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'rdiaz99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'rsanchez##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (40,14,'tjtalbot4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'wf_2#arwhite6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'ba_south#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'nasa_goddard#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'td_online#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'nasa_ksc#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'td_gt#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'wf_1#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'wf_2#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'ba_west#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'td_online#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'nasa_hal#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'nasa_ksc#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,24,'td_gt#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'arwhite6#4700#6#28200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'beyonce#9800#6#320985###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'cboyle99###1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'ealfaro4#5600#3#17100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'gburdell##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'ghopper9#49500#5#447999###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'jperalta99#5400#3#5900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'kjennings66#2000#9#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'lgibbs4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'mmcgill4#9400#3#29100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'pbeesly17#8400#2#14000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'rsanchez#49500#10#654321###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'smcgill17#8800#3#33700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,13,'sville19#8000#4#35000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'arwhite6#053-87-1120#1960-06-06#amelia-rose#whitehead#2021-12-03#60nightshadecourt#baltimore#md#21217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'asantiago99#765-43-2109#1983-07-04#amy#santiago#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'atrebek1#000-00-0000#1940-07-22#alex#trebek#2014-03-22#10202westwashingtonboulevard#culvercity#ca#90232#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'beyonce#444-55-666#1981-09-04#beyonce##2014-02-02#222stargrove#houston#tx#77077#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'cboyle99#433-12-1200#1982-09-04#charles#boyle#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'ealfaro4#278-78-7676#1960-06-06#evie#alfaro#2021-12-27#314fivefingersway#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'gburdell#404-00-0000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'ghopper9#101-00-1111#1906-12-09#grace#hopper#2019-12-25#1broadway#newyork#ny#10004#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'glinetti99#233-76-0019#1986-03-20#gina#linetti#2019-04-04#75alluredrive#newyork#ny#11220#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'jperalta99#775-33-6054#1981-09-04#jake#peralta#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'kjennings66#004-52-2700#1974-05-23#ken#jennings#2005-09-07#74championsheights#edmonds#wa#98020#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'lgibbs4#304-39-1098#1954-11-21#leroy#gibbs#2021-06-16#50mountainspur#stillwater#pa#17878#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'mmcgill4#623-09-0887#1955-06-23#maheen#mcgill#2020-09-08#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'msmith#246-80-1234#1999-04-04#morty#smith#2017-08-21#137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'owalter6#346-51-9139#1971-10-23#om#walter#2020-04-29#143snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'pbeesly17#664-98-7654##pam#beesly#2021-06-06#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'rdiaz99#687-54-1033#1984-11-30#rosa#diaz#2020-12-24#3eastparkloop#yonkers#ny#10112#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'rholt99#111-22-3333#1955-01-01#raymond#holt#2022-01-01#123mainstreet#perthamboy#nj#08861#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'rsanchez#012-34-5678#1936-08-22#rick#sanchez##137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'smcgill17#238-40-5070#1954-06-02#saqlain#mcgill#2020-09-11#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'sville19#354-10-6263#1965-03-16#sahar#villegas#2020-06-16#10downingroad#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,12,'tjtalbot4#203-46-3005#1978-05-10#tj#talbot#2020-03-25#101snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'arwhite6#password5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'asantiago99#password17#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'atrebek1#password23#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'beyonce#password27#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'cboyle99#password21#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'dscully5#password3#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'ealfaro4#password6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'fmulder8#password4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'gburdell#password25#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'ghopper9#password16#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'glinetti99#password20#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'jperalta99#password19#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'kjennings66#password24#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'lgibbs4#password15#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'mmcgill4#password7#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'mmoss7#password1#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'msmith#password14#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'owalter6#password12#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'pbeesly17#password26#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'rdiaz99#password22#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'rholt99#password18#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'rsanchez#password13#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'smcgill17#password10#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'sville19#password8#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'tjtalbot4#password11#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (50,10,'tmcgee1#password2#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'arwhite6#email#amelia_whitehead@me.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'arwhite6#mobile#333-182-9303############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'msmith#email#morty@rm.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'msmith#phone#000-098-7654############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'owalter6#home#370-186-5341############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'pbeesly17#email#jh@dunder.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'pbeesly17#email#pb@dunder.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'rsanchez#phone#000-098-7654############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'tjtalbot4#email#tj_forever@aol.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'tjtalbot4#home#236-464-1023############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,15,'tjtalbot4#mobile#845-101-2760############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'arwhite6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'atrebek1##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'cboyle99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'kjennings66##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'msmith##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'owalter6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'pbeesly17##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'rdiaz99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'rsanchez##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,14,'tjtalbot4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'arwhite6#053-87-1120#1960-06-06#amelia-rose#whitehead#2021-12-03#60nightshadecourt#baltimore#md#21217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'atrebek1#000-00-0000#1940-07-22#alex#trebek#2014-03-22#10202westwashingtonboulevard#culvercity#ca#90232#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'beyonce#444-55-666#1981-09-04#beyonce##2014-02-02#222stargrove#houston#tx#77077#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'cboyle99#433-12-1200#1982-09-04#charles#boyle#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'ealfaro4#278-78-7676#1960-06-06#evie#alfaro#2021-12-27#314fivefingersway#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'gburdell#404-00-0000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'ghopper9#101-00-1111#1906-12-09#grace#hopper#2019-12-25#1broadway#newyork#ny#10004#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'glinetti99#233-76-0019#1986-03-20#gina#linetti#2019-04-04#75alluredrive#newyork#ny#11220#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'jperalta99#775-33-6054#1981-09-04#jake#peralta#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'kjennings66#004-52-2700#1974-05-23#ken#jennings#2005-09-07#74championsheights#edmonds#wa#98020#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'lgibbs4#304-39-1098#1954-11-21#leroy#gibbs#2021-06-16#50mountainspur#stillwater#pa#17878#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'mmcgill4#623-09-0887#1955-06-23#maheen#mcgill#2020-09-08#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'msmith#246-80-1234#1999-04-04#morty#smith#2017-08-21#137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'owalter6#346-51-9139#1971-10-23#om#walter#2020-04-29#143snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'pbeesly17#664-98-7654##pam#beesly#2021-06-06#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'rdiaz99#687-54-1033#1984-11-30#rosa#diaz#2020-12-24#3eastparkloop#yonkers#ny#10112#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'rholt99#111-22-3333#1955-01-01#raymond#holt#2022-01-01#123mainstreet#perthamboy#nj#08861#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'rnairn5#404-51-1036#1959-07-13#roxanne#nairn#2021-08-16#2048transparencyroad#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'rsanchez#012-34-5678#1936-08-22#rick#sanchez##137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'smcgill17#238-40-5070#1954-06-02#saqlain#mcgill#2020-09-11#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'sville19#354-10-6263#1965-03-16#sahar#villegas#2020-06-16#10downingroad#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,12,'tjtalbot4#203-46-3005#1978-05-10#tj#talbot#2020-03-25#101snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'arwhite6#password5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'atrebek1#password23#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'beyonce#password27#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'cboyle99#password21#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'dscully5#password3#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'ealfaro4#password6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'fmulder8#password4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'gburdell#password25#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'ghopper9#password16#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'glinetti99#password20#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'jperalta99#password19#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'kjennings66#password24#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'lgibbs4#password15#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'mmcgill4#password7#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'mmoss7#password1#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'msmith#password14#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'owalter6#password12#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'pbeesly17#password26#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'rdiaz99#password22#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'rholt99#password18#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'rnairn5#password9#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'rsanchez#password13#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'smcgill17#password10#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'sville19#password8#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'tjtalbot4#password11#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (60,10,'tmcgee1#password2#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'arwhite6#email#amelia_whitehead@me.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'arwhite6#mobile#333-182-9303############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'asantiago99#email#asantiago99@nypd.org############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'asantiago99#fax#334-444-1234x276############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'msmith#email#morty@rm.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'msmith#phone#000-098-7654############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'owalter6#home#370-186-5341############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'pbeesly17#email#jh@dunder.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'pbeesly17#email#pb@dunder.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'rsanchez#phone#000-098-7654############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'tjtalbot4#email#tj_forever@aol.com############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'tjtalbot4#home#236-464-1023############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,15,'tjtalbot4#mobile#845-101-2760############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'arwhite6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'asantiago99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'atrebek1##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'cboyle99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'kjennings66##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'msmith##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'owalter6##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'pbeesly17##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'rdiaz99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'rsanchez##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,14,'tjtalbot4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'arwhite6#053-87-1120#1960-06-06#amelia-rose#whitehead#2021-12-03#60nightshadecourt#baltimore#md#21217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'asantiago99#765-43-2109#1983-07-04#amy#santiago#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'atrebek1#000-00-0000#1940-07-22#alex#trebek#2014-03-22#10202westwashingtonboulevard#culvercity#ca#90232#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'beyonce#444-55-666#1981-09-04#beyonce##2014-02-02#222stargrove#houston#tx#77077#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'cboyle99#433-12-1200#1982-09-04#charles#boyle#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'ealfaro4#278-78-7676#1960-06-06#evie#alfaro#2021-12-27#314fivefingersway#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'gburdell#404-00-0000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'ghopper9#101-00-1111#1906-12-09#grace#hopper#2019-12-25#1broadway#newyork#ny#10004#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'glinetti99#233-76-0019#1986-03-20#gina#linetti#2019-04-04#75alluredrive#newyork#ny#11220#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'jperalta99#775-33-6054#1981-09-04#jake#peralta#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'kjennings66#004-52-2700#1974-05-23#ken#jennings#2005-09-07#74championsheights#edmonds#wa#98020#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'lgibbs4#304-39-1098#1954-11-21#leroy#gibbs#2021-06-16#50mountainspur#stillwater#pa#17878#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'mmcgill4#623-09-0887#1955-06-23#maheen#mcgill#2020-09-08#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'msmith#246-80-1234#1999-04-04#morty#smith#2017-08-21#137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'owalter6#346-51-9139#1971-10-23#om#walter#2020-04-29#143snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'pbeesly17#664-98-7654##pam#beesly#2021-06-06#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'rdiaz99#687-54-1033#1984-11-30#rosa#diaz#2020-12-24#3eastparkloop#yonkers#ny#10112#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'rholt99#111-22-3333#1955-01-01#raymond#holt#2022-01-01#123mainstreet#perthamboy#nj#08861#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'rnairn5#404-51-1036#1959-07-13#roxanne#nairn#2021-08-16#2048transparencyroad#atlanta#ga#30301#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'rsanchez#012-34-5678#1936-08-22#rick#sanchez##137pugetrun#seattle#wa#98420#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'smcgill17#238-40-5070#1954-06-02#saqlain#mcgill#2020-09-11#741panamericantrace#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'sville19#354-10-6263#1965-03-16#sahar#villegas#2020-06-16#10downingroad#eastcobb#ga#30304#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,12,'tjtalbot4#203-46-3005#1978-05-10#tj#talbot#2020-03-25#101snoopywoodstockcircle#saltlakecity#ut#84108#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'arwhite6#password5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'asantiago99#password17#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'atrebek1#password23#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'beyonce#password27#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'cboyle99#password21#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'dscully5#password3#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'ealfaro4#password6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'fmulder8#password4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'gburdell#password25#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'ghopper9#password16#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'glinetti99#password20#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'jperalta99#password19#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'kjennings66#password24#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'lgibbs4#password15#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'mmcgill4#password7#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'mmoss7#password1#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'msmith#password14#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'owalter6#password12#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'pbeesly17#password26#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'rdiaz99#password22#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'rholt99#password18#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'rnairn5#password9#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'rsanchez#password13#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'smcgill17#password10#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'sville19#password8#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'tjtalbot4#password11#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (61,10,'tmcgee1#password2#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'arwhite6#4700#6#28200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'beyonce#9800#6#320985###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'cboyle99###1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'ealfaro4#5600#3#17100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'gburdell##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'ghopper9#49500#5#447999###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'jperalta99#5400#3#5900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'kjennings66#2000#9#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'lgibbs4#1400#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'mmcgill4#9400#3#29100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'pbeesly17#8400#2#14000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'rnairn5#5100#5#27400###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'rsanchez#49500#10#654321###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'smcgill17#8800#3#33700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,13,'sville19#8000#4#35000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'wf_2#arwhite6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'ba_south#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'nasa_goddard#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'td_online#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'nasa_ksc#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'td_gt#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'wf_1#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'wf_2#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'ba_west#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'td_online#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'nasa_hal#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'nasa_ksc#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'td_gt#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'nasa_goddard#lgibbs4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (70,24,'ba_west#rnairn5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'arwhite6#4700#6#28200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'beyonce#9800#6#320985###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'cboyle99###1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'ealfaro4#5600#3#17100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'gburdell##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'ghopper9#49500#5#447999###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'jperalta99#5400#3#5900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'kjennings66#2000#9#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'lgibbs4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'mmcgill4#9400#3#29100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'pbeesly17#8400#2#14000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'rnairn5#5100#5#27400###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'rsanchez#49500#10#654321###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'smcgill17#8800#3#33700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,13,'sville19#8000#4#35000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'wf_2#arwhite6#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'ba_south#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'nasa_goddard#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'td_online#beyonce#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'nasa_ksc#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'td_gt#cboyle99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'wf_1#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'wf_2#ealfaro4#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'ba_west#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'td_online#glinetti99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'nasa_hal#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'nasa_ksc#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'td_gt#jperalta99#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (71,24,'ba_west#rnairn5#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'arwhite6#4700#6#28200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'beyonce#9800#6#320985###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'cboyle99###1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'ealfaro4#5600#3#17100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'gburdell##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'ghopper9#49500#5#447999###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'jperalta99#5400#3#5900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'kjennings66#2000#9#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'lgibbs4#5000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'mmcgill4#9400#3#29100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'pbeesly17#8400#2#14000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'rnairn5#5100#5#27400###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'rsanchez#49500#10#654321###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'smcgill17#8800#3#33700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,13,'sville19#8000#4#35000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'ba_south#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#42000#ba#ghopper9######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'ba_west#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#267000#ba#smcgill17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'nasa_goddard#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#140000#nasa#rsanchez######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'nasa_hal#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805##nasa#pbeesly17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'nasa_ksc#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#0#nasa#rholt99######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'td_gt#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333##td#lgibbs4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'td_online######0#td#kjennings66######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'wf_1#wellsfargo#1bank#1010binaryway#seattle#wa#98101#127000#wf#sville19######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (80,17,'wf_2#wellsfargo#2bank#337fireflylane#seattle#wa#98101#553000#wf#mmcgill4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'arwhite6#4700#6#28200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'beyonce#9800#6#320985###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'cboyle99###1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'ealfaro4#5600#3#17100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'gburdell##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'ghopper9#49500#5#447999###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'glinetti99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'jperalta99#5400#3#5900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'kjennings66#2000#9#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'lgibbs4##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'mmcgill4#9400#3#29100###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'pbeesly17#8400#2#14000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'rholt99##############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'rnairn5#5100#5#27400###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'rsanchez#49500#10#654321###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'smcgill17#8800#3#33700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,13,'sville19#8000#4#35000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'ba_south#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#42000#ba#ghopper9######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'ba_west#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#267000#ba#smcgill17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'nasa_goddard#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#140000#nasa#rsanchez######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'nasa_hal#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805##nasa#pbeesly17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'nasa_ksc#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#0#nasa#rholt99######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'td_gt#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333##td#gburdell######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'td_online######0#td#kjennings66######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'wf_1#wellsfargo#1bank#1010binaryway#seattle#wa#98101#127000#wf#sville19######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (81,17,'wf_2#wellsfargo#2bank#337fireflylane#seattle#wa#98101#553000#wf#mmcgill4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'td_gt#new_checking#4000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,23,'ba_west#checking_a#ba_west#savings_b#600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,23,'td_gt#new_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'atrebek1#td_gt#new_checking#2022-03-04###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (90,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'td_gt#new_savings#4000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'ba_south#gt_investments#4#2020-03-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'ba_south#gt_savings#2############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'ba_west#savings_b#6#2021-09-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'nasa_goddard#company_savings#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'td_gt#new_savings#10############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'td_gt#roth_ira#8#2021-01-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'td_gt#savings_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'td_online#roth_ira#12#2022-01-03###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'wf_2#market_x#20#2021-12-23###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,19,'wf_2#savings_a#10#2021-11-05###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,21,'ba_south#gt_savings#2000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,21,'ba_west#savings_b#10000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,21,'nasa_goddard#company_savings#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,21,'td_gt#new_savings#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,21,'td_gt#savings_a#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,21,'wf_2#savings_a#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'atrebek1#td_gt#new_savings#2022-03-03###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (91,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'td_gt#new_market#4000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'ba_south#gt_investments#4#2020-03-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'ba_south#gt_savings#2############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'ba_west#savings_b#6#2021-09-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'nasa_goddard#company_savings#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'td_gt#new_market#12############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'td_gt#roth_ira#8#2021-01-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'td_gt#savings_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'td_online#roth_ira#12#2022-01-03###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'wf_2#market_x#20#2021-12-23###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,19,'wf_2#savings_a#10#2021-11-05###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,22,'ba_south#gt_investments#10#5###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,22,'td_gt#new_market#4#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,22,'td_gt#roth_ira#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,22,'td_online#roth_ira#0#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,22,'wf_2#market_x#2#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'atrebek1#td_gt#new_market#2022-03-04###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (92,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (100,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (101,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'ba_south#gt_investments#4#2020-03-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'ba_south#gt_savings#2############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'ba_west#savings_b#6#2021-09-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'nasa_goddard#company_savings#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'td_gt#roth_ira#8#2021-01-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'td_online#roth_ira#12#2022-01-03###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'wf_2#market_x#20#2021-12-23###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,19,'wf_2#savings_a#10#2021-11-05###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,21,'ba_south#gt_savings#2000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,21,'ba_west#savings_b#10000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,21,'nasa_goddard#company_savings#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,21,'wf_2#savings_a#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (102,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'ba_south#gt_investments#withdrawal############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'ba_west#savings_b#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'ba_west#savings_b#overdraft############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'nasa_goddard#company_savings#creditunion############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'td_online#roth_ira#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'td_online#roth_ira#withdrawal############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'wf_2#market_x#administrative############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'wf_2#market_x#fee############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'wf_2#market_x#frequency############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'wf_2#market_x#newfee############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (110,20,'wf_2#savings_a#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'ba_south#gt_investments#withdrawal############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'ba_west#savings_b#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'ba_west#savings_b#overdraft############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'nasa_goddard#company_savings#creditunion############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'td_online#roth_ira#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'td_online#roth_ira#withdrawal############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'wf_2#market_x#administrative############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'wf_2#market_x#fee############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'wf_2#market_x#frequency############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'wf_2#savings_a#lowbalance############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (111,20,'wf_2#savings_a#newfee############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (120,23,'ba_west#checking_a#ba_west#savings_b#600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (120,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (120,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (120,23,'td_online#company_checking#wf_2#savings_a###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (120,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,23,'ba_west#checking_a###600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (130,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'owalter6#ba_west#checking_a#2020-09-02#2022-02-02##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'ba_west#checking_a#1500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'ba_south#gt_investments#4#2020-03-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'ba_south#gt_savings#2############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'ba_west#savings_b#6#2021-09-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'nasa_goddard#company_savings#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'td_gt#roth_ira#8#2021-01-01###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'td_gt#savings_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'td_online#roth_ira#12#2022-01-03###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'wf_2#market_x#20#2021-12-23###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (140,19,'wf_2#savings_a#10#2021-11-05###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'kjennings66#ba_south#gt_investments#2009-08-09#2022-02-02##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'ba_south#gt_investments#14500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,23,'ba_west#checking_a#ba_west#savings_b#600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,22,'ba_south#gt_investments#10#6###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,22,'td_gt#roth_ira#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,22,'td_online#roth_ira#0#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (150,22,'wf_2#market_x#2#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'owalter6#ba_west#checking_a#2020-09-02#2022-02-02##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'owalter6#ba_west#savings_b#2020-09-02#2022-02-02##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'rsanchez#nasa_goddard#company_savings#2014-08-16###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'ba_west#checking_a#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'ba_west#savings_b#7500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,23,'ba_west#checking_a#ba_west#savings_b#500#2022-02-02#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,22,'ba_south#gt_investments#10#5###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,22,'td_gt#roth_ira#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,22,'td_online#roth_ira#0#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (151,22,'wf_2#market_x#2#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'atrebek1#ba_south#gt_savings#2015-12-31#2017-03-22##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'kjennings66#ba_south#gt_investments#2009-08-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'kjennings66#ba_south#gt_savings#2010-08-09#2022-02-21##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'owalter6#ba_west#checking_a#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'owalter6#ba_west#savings_b#2020-09-02###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'msmith#nasa_goddard#company_checking#2018-10-11###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'rsanchez#nasa_goddard#company_checking#2018-10-10#2022-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'rsanchez#nasa_goddard#company_savings#2014-08-16#2022-02-02##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'rsanchez#nasa_ksc#company_checking#2018-10-10#2022-01-13##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'msmith#td_gt#roth_ira#2021-01-01#2022-01-01##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'pbeesly17#td_gt#savings_a#2021-09-09###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'cboyle99#td_online#roth_ira#2021-09-26###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'glinetti99#td_online#roth_ira#2019-12-24###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'tjtalbot4#td_online#company_checking#2020-12-07#2020-12-07##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'arwhite6#wf_2#checking_a#2021-08-10#2022-01-26##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'arwhite6#wf_2#savings_a#2021-08-10#2021-11-11##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'asantiago99#wf_2#market_x#2020-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'rholt99#wf_2#market_x#2022-02-02#2020-02-04##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,25,'tjtalbot4#wf_2#savings_a#2021-08-17#2022-02-03##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'nasa_goddard#company_savings#999800############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,23,'ba_west#checking_a#ba_west#savings_b#600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,22,'ba_south#gt_investments#10#5###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,22,'td_gt#roth_ira#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,22,'td_online#roth_ira#0#0###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (152,22,'wf_2#market_x#2#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'wf_2#checking_a#700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,18,'wf_2#savings_a#21400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,23,'ba_west#checking_a#ba_west#savings_b#600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (160,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'nasa_goddard#company_checking#2000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'nasa_ksc#company_checking#148000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,23,'ba_west#checking_a#ba_west#savings_b#600#2021-12-08#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,23,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,23,'nasa_ksc#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,23,'td_online#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (161,23,'wf_2#checking_a#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'arwhite6#4700#7#32900###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'beyonce#9800#7#330785###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'cboyle99##1#1200###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'ealfaro4#5600#4#22700###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'gburdell##1############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'ghopper9#49500#6#497499###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'glinetti99##1############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'jperalta99#5400#4#11300###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'kjennings66#2000#10#45000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'lgibbs4##1############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'mmcgill4#9400#4#38500###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'pbeesly17#8400#3#22400###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'rholt99##1############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'rnairn5#5100#6#32500###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'rsanchez#49500#11#703821###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'smcgill17#8800#4#42500###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,13,'sville19#8000#5#43000###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'ba_south#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#38734#ba#ghopper9######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'ba_west#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#261900#ba#smcgill17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'nasa_goddard#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#136734#nasa#rsanchez######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'nasa_hal#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805#-1800#nasa#pbeesly17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'nasa_ksc#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#-1800#nasa#rholt99######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'td_gt#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333#-1800#td#gburdell######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'td_online######-3266#td#kjennings66######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'wf_1#wellsfargo#1bank#1010binaryway#seattle#wa#98101#124200#wf#sville19######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (170,17,'wf_2#wellsfargo#2bank#337fireflylane#seattle#wa#98101#545500#wf#mmcgill4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'ba_south#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#42000#ba#ghopper9######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'ba_west#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#267100#ba#smcgill17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'nasa_goddard#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#140000#nasa#rsanchez######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'nasa_hal#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805#0#nasa#pbeesly17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'nasa_ksc#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#0#nasa#rholt99######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'td_gt#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333#0#td#gburdell######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'td_online######0#td#kjennings66######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'wf_1#wellsfargo#1bank#1010binaryway#seattle#wa#98101#127000#wf#sville19######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,17,'wf_2#wellsfargo#2bank#337fireflylane#seattle#wa#98101#553000#wf#mmcgill4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'ba_south#gt_investments#16000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'ba_south#gt_savings#9999############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'ba_west#savings_b#7900############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'td_gt#roth_ira#15000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'td_online#roth_ira#167000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'wf_2#market_x#27000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (180,18,'wf_2#savings_a#19400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'ba_south#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#41161#ba#ghopper9######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'ba_west#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#267000#ba#smcgill17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'nasa_goddard#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#140000#nasa#rsanchez######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'nasa_hal#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805#0#nasa#pbeesly17######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'nasa_ksc#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#0#nasa#rholt99######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'td_gt#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333#-1200#td#gburdell######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'td_online######-20040#td#kjennings66######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'wf_1#wellsfargo#1bank#1010binaryway#seattle#wa#98101#127000#wf#sville19######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,17,'wf_2#wellsfargo#2bank#337fireflylane#seattle#wa#98101#545660#wf#mmcgill4######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'ba_south#gt_investments#16640############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'ba_south#gt_savings#10198############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'ba_west#checking_a#1000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'ba_west#savings_b#8000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'nasa_goddard#company_checking#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'nasa_goddard#company_savings#1000000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'nasa_ksc#company_checking#150000############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'td_gt#roth_ira#16200############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'td_gt#savings_a#8500############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'td_online#company_checking#0############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'td_online#roth_ira#187040############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'wf_2#checking_a#2700############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'wf_2#market_x#32400############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (190,18,'wf_2#savings_a#21340############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'bankofamericaplaza-midtown#gt_investments#16000#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'bankofamericaplaza-midtown#gt_savings#9999#2###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'bankofamericawestregionbank#checking_a#1000#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'bankofamericawestregionbank#savings_b#8000#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'nasafcuatgoddardsfc#company_checking##2###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'nasafcuatgoddardsfc#company_savings#1000000#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'nasafcuatkennedyspacecenter#company_checking#150000#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'tdameritrademidtownbranch#roth_ira#15000#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'tdameritrademidtownbranch#savings_a#8500#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'#company_checking#0#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'#roth_ira#167000#2###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'wellsfargo#2bank#checking_a#2700#1###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'wellsfargo#2bank#market_x#27000#2###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (200,30,'wellsfargo#2bank#savings_a#19400#2###########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'ba_south#bankofamerica#bankofamericaplaza-midtown#600peachtreestreetne#atlanta#ga#30333#2#42000#67999#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'ba_west#bankofamerica#bankofamericawestregionbank#865blackgoldcircle#dallas#tx#75116#2#267000#276000#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'nasa_goddard#nasafcu#nasafcuatgoddardsfc#8800greenbeltroad#greenbelt#md#20771#2#140000#1140000#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'nasa_hal#nasafcu#nasafcuatusspace&rocketcenter#1tranquilitybasesuite203#huntsville#al#35805###0#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'nasa_ksc#nasafcu#nasafcuatkennedyspacecenter#1spacecommerceway#capecanaveral#fl#45678#1#0#150000#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'td_gt#tdameritrade#tdameritrademidtownbranch#47techparkway#atlanta#ga#30333#2##23500#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'td_online#tdameritrade######2#0#167000#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'wf_1#wellsfargo#wellsfargo#1bank#1010binaryway#seattle#wa#98101##127000#127000#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (210,31,'wf_2#wellsfargo#wellsfargo#2bank#337fireflylane#seattle#wa#98101#3#553000#602100#####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (220,32,'ba#bankofamerica#bankofamericacorporation#2#51000000#51343999#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (220,32,'gs#goldmansachs#goldmansachsgroup,inc.############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (220,32,'nasa#nasafcu#nasafederalcreditunion#3#11000000#12290000#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (220,32,'st#suntrust#suntrustbanks/truistfinancialcorporation##39000000#39000000#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (220,32,'td#tdameritrade#tdameritradeholdingcorporation#2#0#190500#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (220,32,'wf#wellsfargo#wellsfargobanknationalassociation#2#33000000#33729100#########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'arwhite6#053-87-1120#amelia-rosewhitehead#1960-06-06#2021-12-03#60nightshadecourt#baltimore#md#21217#2#22100####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'asantiago99#765-43-2109#amysantiago#1983-07-04#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#1#27000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'atrebek1#000-00-0000#alextrebek#1940-07-22#2014-03-22#10202westwashingtonboulevard#culvercity#ca#90232#1#9999####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'cboyle99#433-12-1200#charlesboyle#1982-09-04#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#1#167000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'glinetti99#233-76-0019#ginalinetti#1986-03-20#2019-04-04#75alluredrive#newyork#ny#11220#1#167000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'kjennings66#004-52-2700#kenjennings#1974-05-23#2005-09-07#74championsheights#edmonds#wa#98020#2#25999####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'msmith#246-80-1234#mortysmith#1999-04-04#2017-08-21#137pugetrun#seattle#wa#98420#2#15000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'owalter6#346-51-9139#omwalter#1971-10-23#2020-04-29#143snoopywoodstockcircle#saltlakecity#ut#84108#2#9000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'pbeesly17#664-98-7654#pambeesly##2021-06-06#####1#8500####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'rdiaz99#687-54-1033#rosadiaz#1984-11-30#2020-12-24#3eastparkloop#yonkers#ny#10112##0####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'rholt99#111-22-3333#raymondholt#1955-01-01#2022-01-01#123mainstreet#perthamboy#nj#08861#1#27000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'rsanchez#012-34-5678#ricksanchez#1936-08-22##137pugetrun#seattle#wa#98420#3#1150000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (230,33,'tjtalbot4#203-46-3005#tjtalbot#1978-05-10#2020-03-25#101snoopywoodstockcircle#saltlakecity#ut#84108#2#19400####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'arwhite6#053-87-1120#amelia-rosewhitehead#1960-06-06#2021-12-03#60nightshadecourt#baltimore#md#21217#1#602100####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'beyonce#444-55-666##1981-09-04#2014-02-02#222stargrove#houston#tx#77077#3#1374999####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'cboyle99#433-12-1200#charlesboyle#1982-09-04#2018-03-10#1477parkavenueapt.65#newyork#ny#11217#2#173500####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'ealfaro4#278-78-7676#eviealfaro#1960-06-06#2021-12-27#314fivefingersway#atlanta#ga#30301#2#729100####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'gburdell#404-00-0000#############');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'ghopper9#101-00-1111#gracehopper#1906-12-09#2019-12-25#1broadway#newyork#ny#10004######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'glinetti99#233-76-0019#ginalinetti#1986-03-20#2019-04-04#75alluredrive#newyork#ny#11220#2#443000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'jperalta99#775-33-6054#jakeperalta#1981-09-04#2018-03-09#1477parkavenueapt.82#newyork#ny#11217#3#173500####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'kjennings66#004-52-2700#kenjennings#1974-05-23#2005-09-07#74championsheights#edmonds#wa#98020######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'lgibbs4#304-39-1098#leroygibbs#1954-11-21#2021-06-16#50mountainspur#stillwater#pa#17878######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'mmcgill4#623-09-0887#maheenmcgill#1955-06-23#2020-09-08#741panamericantrace#eastcobb#ga#30304######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'pbeesly17#664-98-7654#pambeesly##2021-06-06##########');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'rholt99#111-22-3333#raymondholt#1955-01-01#2022-01-01#123mainstreet#perthamboy#nj#08861######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'rnairn5#404-51-1036#roxannenairn#1959-07-13#2021-08-16#2048transparencyroad#atlanta#ga#30301#1#276000####');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'rsanchez#012-34-5678#ricksanchez#1936-08-22##137pugetrun#seattle#wa#98420######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'smcgill17#238-40-5070#saqlainmcgill#1954-06-02#2020-09-11#741panamericantrace#eastcobb#ga#30304######');
INSERT INTO magic44_expected_results (`step_id`,`query_id`,`row_hash`) VALUES (240,34,'sville19#354-10-6263#saharvillegas#1965-03-16#2020-06-16#10downingroad#eastcobb#ga#30304######');




-- ----------------------------------------------------------------------------------
-- [7] Compare & evaluate the testing results
-- ----------------------------------------------------------------------------------

-- Delete the unneeded rows from the answers table to simplify later analysis
-- delete from magic44_expected_results where not magic44_query_exists(query_id);

-- Modify the row hash results for the results table to eliminate spaces and convert all characters to lowercase
update magic44_test_results set row_hash = lower(replace(row_hash, ' ', ''));

-- The magic44_count_differences view displays the differences between the number of rows contained in the answers
-- and the test results.  The value null in the answer_total and result_total columns represents zero (0) rows for
-- that query result.

drop view if exists magic44_count_answers;
create view magic44_count_answers as
select step_id, query_id, count(*) as answer_total
from magic44_expected_results group by step_id, query_id;

drop view if exists magic44_count_test_results;
create view magic44_count_test_results as
select step_id, query_id, count(*) as result_total
from magic44_test_results group by step_id, query_id;

drop view if exists magic44_count_differences;
create view magic44_count_differences as
select magic44_count_answers.query_id, magic44_count_answers.step_id, answer_total, result_total
from magic44_count_answers left outer join magic44_count_test_results
	on magic44_count_answers.step_id = magic44_count_test_results.step_id
	and magic44_count_answers.query_id = magic44_count_test_results.query_id
where answer_total <> result_total or result_total is null
union
select magic44_count_test_results.query_id, magic44_count_test_results.step_id, answer_total, result_total
from magic44_count_test_results left outer join magic44_count_answers
	on magic44_count_test_results.step_id = magic44_count_answers.step_id
	and magic44_count_test_results.query_id = magic44_count_answers.query_id
where result_total <> answer_total or answer_total is null
order by query_id, step_id;

-- The magic44_content_differences view displays the differences between the answers and test results
-- in terms of the row attributes and values.  the error_category column contains missing for rows that
-- are not included in the test results but should be, while extra represents the rows that should not
-- be included in the test results.  the row_hash column contains the values of the row in a single
-- string with the attribute values separated by a selected delimiter (i.e., the pound sign/#).

drop view if exists magic44_content_differences;
create view magic44_content_differences as
select query_id, step_id, 'missing' as category, row_hash
from magic44_expected_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_test_results)
union
select query_id, step_id, 'extra' as category, row_hash
from magic44_test_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_expected_results)
order by query_id, step_id, row_hash;

drop view if exists magic44_result_set_size_errors;
create view magic44_result_set_size_errors as
select step_id, query_id, 'result_set_size' as err_category from magic44_count_differences
group by step_id, query_id;

drop view if exists magic44_attribute_value_errors;
create view magic44_attribute_value_errors as
select step_id, query_id, 'attribute_values' as err_category from magic44_content_differences
where row(step_id, query_id) not in (select step_id, query_id from magic44_count_differences)
group by step_id, query_id;

drop view if exists magic44_errors_assembled;
create view magic44_errors_assembled as
select * from magic44_result_set_size_errors
union
select * from magic44_attribute_value_errors;

drop table if exists magic44_row_count_errors;
create table magic44_row_count_errors
select * from magic44_count_differences
order by query_id, step_id;

drop table if exists magic44_column_errors;
create table magic44_column_errors
select * from magic44_content_differences
order by query_id, step_id, row_hash;

drop view if exists magic44_fast_expected_results;
create view magic44_fast_expected_results as
select step_id, query_id, query_label, query_name
from magic44_expected_results, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_row_based_errors;
create view magic44_fast_row_based_errors as
select step_id, query_id, query_label, query_name
from magic44_row_count_errors, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_column_based_errors;
create view magic44_fast_column_based_errors as
select step_id, query_id, query_label, query_name
from magic44_column_errors, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_total_test_cases;
create view magic44_fast_total_test_cases as
select query_label, query_name, count(*) as total_cases
from magic44_fast_expected_results group by query_label, query_name;

drop view if exists magic44_fast_correct_test_cases;
create view magic44_fast_correct_test_cases as
select query_label, query_name, count(*) as correct_cases
from magic44_fast_expected_results where row(step_id, query_id) not in
(select step_id, query_id from magic44_fast_row_based_errors
union select step_id, query_id from magic44_fast_column_based_errors)
group by query_label, query_name;

drop table if exists magic44_autograding_low_level;
create table magic44_autograding_low_level
select magic44_fast_total_test_cases.*, ifnull(correct_cases, 0) as passed_cases
from magic44_fast_total_test_cases left outer join magic44_fast_correct_test_cases
on magic44_fast_total_test_cases.query_label = magic44_fast_correct_test_cases.query_label
and magic44_fast_total_test_cases.query_name = magic44_fast_correct_test_cases.query_name;

drop table if exists magic44_autograding_score_summary;
create table magic44_autograding_score_summary
select query_label, query_name,
	round(scoring_weight * passed_cases / total_cases, 2) as final_score, scoring_weight
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases < total_cases
union
select null, 'REMAINING CORRECT CASES', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases = total_cases
union
select null, 'TOTAL SCORE', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory;

drop table if exists magic44_autograding_high_level;
create table magic44_autograding_high_level
select score_tag, score_category, sum(total_cases) as total_possible,
	sum(passed_cases) as total_passed
from magic44_scores_guide natural join
(select *, mid(query_label, 2, 1) as score_tag from magic44_autograding_low_level) as temp
group by score_tag order by display_order;

-- Evaluate potential query errors against the original state and the modified state
drop view if exists magic44_result_errs_original;
create view magic44_result_errs_original as
select distinct 'row_count_errors_initial_state' as title, query_id
from magic44_row_count_errors where step_id = 0;

drop view if exists magic44_result_errs_modified;
create view magic44_result_errs_modified as
select distinct 'row_count_errors_test_cases' as title, query_id
from magic44_row_count_errors
where query_id not in (select query_id from magic44_result_errs_original)
union
select * from magic44_result_errs_original;

drop view if exists magic44_attribute_errs_original;
create view magic44_attribute_errs_original as
select distinct 'column_errors_initial_state' as title, query_id
from magic44_column_errors where step_id = 0
and query_id not in (select query_id from magic44_result_errs_modified)
union
select * from magic44_result_errs_modified;

drop view if exists magic44_attribute_errs_modified;
create view magic44_attribute_errs_modified as
select distinct 'column_errors_test_cases' as title, query_id
from magic44_column_errors
where query_id not in (select query_id from magic44_attribute_errs_original)
union
select * from magic44_attribute_errs_original;

drop view if exists magic44_correct_remainders;
create view magic44_correct_remainders as
select distinct 'fully_correct' as title, query_id
from magic44_test_results
where query_id not in (select query_id from magic44_attribute_errs_modified)
union
select * from magic44_attribute_errs_modified;

drop view if exists magic44_grading_rollups;
create view magic44_grading_rollups as
select title, count(*) as number_affected, group_concat(query_id order by query_id asc) as queries_affected
from magic44_correct_remainders
group by title;

drop table if exists magic44_autograding_directory;
create table magic44_autograding_directory (query_status_category varchar(1000));
insert into magic44_autograding_directory values ('fully_correct'),
('column_errors_initial_state'), ('row_count_errors_initial_state'),
('column_errors_test_cases'), ('row_count_errors_test_cases');

drop table if exists magic44_autograding_query_level;
create table magic44_autograding_query_level
select query_status_category, number_affected, queries_affected
from magic44_autograding_directory left outer join magic44_grading_rollups
on query_status_category = title;

-- ----------------------------------------------------------------------------------
-- Validate/verify that the test case results are correct
-- The test case results are compared to the initial database state contents
-- ----------------------------------------------------------------------------------

drop function if exists magic44_check_test_case;
delimiter //
create procedure magic44_check_test_case(in ip_test_case_number integer)
begin
	select * from (select query_id, 'added' as category, row_hash
	from magic44_test_results where step_id = ip_test_case_number and row(query_id, row_hash) not in
		(select query_id, row_hash from magic44_expected_results where step_id = 0)
	union
	select temp.query_id, 'removed' as category, temp.row_hash
	from (select query_id, row_hash from magic44_expected_results where step_id = 0) as temp
	where row(temp.query_id, temp.row_hash) not in
		(select query_id, row_hash from magic44_test_results where step_id = ip_test_case_number)
	and temp.query_id in
		(select query_id from magic44_test_results where step_id = ip_test_case_number)) as unified
	order by query_id, row_hash;
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [8] Remove unneeded tables, views, stored procedures and functions
-- ----------------------------------------------------------------------------------

-- Keep only those structures needed to provide student feedback
drop table if exists magic44_autograding_directory;

drop view if exists magic44_grading_rollups;
drop view if exists magic44_correct_remainders;
drop view if exists magic44_attribute_errs_modified;
drop view if exists magic44_attribute_errs_original;
drop view if exists magic44_result_errs_modified;
drop view if exists magic44_result_errs_original;
drop view if exists magic44_errors_assembled;
drop view if exists magic44_attribute_value_errors;
drop view if exists magic44_result_set_size_errors;
drop view if exists magic44_content_differences;
drop view if exists magic44_count_differences;
drop view if exists magic44_count_test_results;
drop view if exists magic44_count_answers;

drop procedure if exists magic44_query_check_and_run;

drop function if exists magic44_query_exists;
drop function if exists magic44_query_capture;
drop function if exists magic44_gen_simple_template;

drop table if exists magic44_column_listing;

-- The magic44_reset_database_state() and magic44_check_test_case procedures can be
-- dropped if desired, but they might be helpful for troubleshooting
-- drop procedure if exists magic44_reset_database_state;
-- drop procedure if exists magic44_check_test_case;

drop view if exists practiceQuery10;
drop view if exists practiceQuery11;
drop view if exists practiceQuery12;
drop view if exists practiceQuery13;
drop view if exists practiceQuery14;
drop view if exists practiceQuery15;
drop view if exists practiceQuery16;
drop view if exists practiceQuery17;
drop view if exists practiceQuery18;
drop view if exists practiceQuery19;
drop view if exists practiceQuery20;
drop view if exists practiceQuery21;
drop view if exists practiceQuery22;
drop view if exists practiceQuery23;
drop view if exists practiceQuery24;
drop view if exists practiceQuery25;

drop view if exists practiceQuery30;
drop view if exists practiceQuery31;
drop view if exists practiceQuery32;
drop view if exists practiceQuery33;
drop view if exists practiceQuery34;

drop view if exists magic44_fast_correct_test_cases;
drop view if exists magic44_fast_total_test_cases;
drop view if exists magic44_fast_column_based_errors;
drop view if exists magic44_fast_row_based_errors;
drop view if exists magic44_fast_expected_results;

drop table if exists magic44_scores_guide;
