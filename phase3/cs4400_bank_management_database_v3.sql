-- CS4400: Introduction to Database Systems
-- Bank Management Project Phase 3 Physical Schema
-- Converting Relational Schema into a Database & Inserting Data
-- March 18th, 2022

drop database if exists bank_management;
create database if not exists bank_management;
use bank_management;

create table person (
	perID varchar(100),
    pwd varchar(100) not null,
    primary key (perID)
) engine=innodb;

insert into person values
('mmoss7','password1'),
('tmcgee1','password2'),
('dscully5','password3'),
('fmulder8','password4'),
('arwhite6','password5'),
('ealfaro4','password6'),
('mmcgill4','password7'),
('sville19','password8'),
('rnairn5','password9'),
('smcgill17','password10'),
('tjtalbot4','password11'),
('owalter6','password12'),
('rsanchez','password13'),
('msmith','password14'),
('lgibbs4','password15'),
('ghopper9','password16'),
('asantiago99','password17'),
('rholt99','password18'),
('jperalta99','password19'),
('glinetti99','password20'),
('cboyle99','password21'),
('rdiaz99','password22'),
('atrebek1','password23'),
('kjennings66','password24'),
('gburdell','password25'),
('pbeesly17','password26'),
('beyonce','password27');

create table system_admin (
	perID varchar(100),
    primary key (perID),
    constraint fk2 foreign key (perID) references person(perID)
) engine=innodb;

insert into system_admin values
('mmoss7'),
('tmcgee1'),
('dscully5'),
('fmulder8');

create table bank_user (
	perID varchar(100),
    taxID char(11) not null,
    birthdate date default null,
    firstName varchar(100) default null,
    lastName varchar(100) default null,
    dtJoined date default null,
    street varchar(100) default null,
    city varchar(100) default null,
    state char(2) default null,
    zip char(5) default null,
    primary key (perID),
    unique key (taxID),
    constraint fk3 foreign key (perID) references person(perID)
) engine=innodb;

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

create table employee (
	perID varchar(100),
    salary integer default null,
    payments integer default null,
    earned integer default null,
    primary key (perID),
    constraint fk4 foreign key (perID) references bank_user(perID),
    constraint employee_salary_positive check (salary >= 0)
) engine=innodb;

insert into employee values
('arwhite6',4700,6,28200),
('ealfaro4',5600,3,17100),
('mmcgill4',9400,3,29100),
('sville19',8000,4,35000),
('rnairn5',5100,5,27400),
('smcgill17',8800,3,33700),
('rsanchez',49500,10,654321),
('lgibbs4',null,null,null),
('ghopper9',49500,5,447999),
('rholt99',null,null,null),
('jperalta99',5400,3,5900),
('glinetti99',null,null,null),
('cboyle99',null,null,1200),
('kjennings66',2000,9,43000),
('gburdell',null,null,null),
('pbeesly17',8400,2,14000),
('beyonce',9800,6,320985);

create table customer (
	perID varchar(100),
    primary key (perID),
    constraint fk5 foreign key (perID) references bank_user(perID)
) engine=innodb;

insert into customer values
('arwhite6'),
('tjtalbot4'),
('owalter6'),
('rsanchez'),
('msmith'),
('asantiago99'),
('rholt99'),
('glinetti99'),
('cboyle99'),
('rdiaz99'),
('atrebek1'),
('kjennings66'),
('pbeesly17');

create table customer_contacts (
	perID varchar(100),
    contact_type varchar(100),
    info varchar(100),
    primary key (perID, contact_type, info),
    constraint fk6 foreign key (perID) references customer(perID)
) engine=innodb;

insert into customer_contacts values
('arwhite6','mobile','333-182-9303'),
('arwhite6','email','amelia_whitehead@me.com'),
('tjtalbot4','mobile','845-101-2760'),
('tjtalbot4','home','236-464-1023'),
('tjtalbot4','email','tj_forever@aol.com'),
('owalter6','home','370-186-5341'),
('rsanchez','phone','000-098-7654'),
('msmith','email','morty@rm.com'),
('asantiago99','email','asantiago99@nypd.org'),
('asantiago99','fax','334-444-1234 x276'),
('pbeesly17','email','pb@dunder.com'),
('pbeesly17','email','jh@dunder.com'),
('msmith','phone','000-098-7654');

create table corporation (
	corpID varchar(100),
    shortName varchar(100) not null,
    longName varchar(100) not null,
    resAssets integer default null,
    primary key (corpID),
    unique key (shortName),
    unique key (longName)
) engine=innodb;

insert into corporation values
('WF','Wells Fargo','Wells Fargo Bank National Association',33000000),
('BA','Bank of America','Bank of America Corporation',51000000),
('ST','Sun Trust','Sun Trust Banks/Truist Financial Corporation',39000000),
('NASA','NASA FCU','NASA Federal Credit Union',11000000),
('TD','TD Ameritrade','TD Ameritrade Holding Corporation',0),
('GS','Goldman Sachs','Goldman Sachs Group, Inc.',null);

create table bank (
	bankID varchar(100),
    bankName varchar(100) default null,
    street varchar(100) default null,
    city varchar(100) default null,
    state char(2) default null,
    zip char(5) default null,
    resAssets integer default null,
    corpID varchar(100) not null,
    manager varchar(100) not null,
    primary key (bankID),
    unique key (street, city, state, zip),
    unique key (manager),
    constraint fk12 foreign key (corpID) references corporation(corpID),
    constraint fk15 foreign key (manager) references employee(perID)
) engine=innodb;

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

create table bank_account (
	bankID varchar(100),
    accountID varchar(100),
    balance integer default null,
    primary key (bankID, accountID),
    constraint fk1 foreign key (bankID) references bank(bankID)
) engine=innodb;

insert into bank_account values
('WF_2','checking_A',2700),
('BA_West','checking_A',1000),
('NASA_Goddard','company_checking',null),
('NASA_KSC','company_checking',150000),
('TD_Online','company_checking',0),
('WF_2','market_X',27000),
('TD_Online','Roth_IRA',167000),
('TD_GT','Roth_IRA',15000),
('BA_South','GT_investments',16000),
('WF_2','savings_A',19400),
('BA_West','savings_B',8000),
('NASA_Goddard','company_savings',1000000),
('TD_GT','savings_A',8500),
('BA_South','GT_savings',9999);

create table interest_bearing (
	bankID varchar(100),
	accountID varchar(100),
    interest_rate integer default null,
    dtDeposit date default null,
    primary key (bankID, accountID),
    constraint fk8 foreign key (bankID, accountID) references bank_account(bankID, accountID)
) engine=innodb;

insert into interest_bearing values
('WF_2', 'market_X', 20, '2021-12-23'),
('TD_Online', 'Roth_IRA', 12, '2022-01-03'),
('TD_GT', 'Roth_IRA', 8, '2021-01-01'),
('BA_South', 'GT_investments', 4, '2020-03-11'),
('WF_2', 'savings_A', 10, '2021-11-05'),
('BA_West', 'savings_B', 6,' 2021-09-01'),
('NASA_Goddard', 'company_savings', null, null),
('TD_GT', 'savings_A', null, null),
('BA_South', 'GT_savings', 2, null);

create table interest_bearing_fees (
	bankID varchar(100),
    accountID varchar(100),
    fee varchar(100),
    primary key (bankID, accountID, fee),
    constraint fk9 foreign key (bankID, accountID) references interest_bearing(bankID, accountID)
) engine=innodb;

insert into interest_bearing_fees values
('WF_2','savings_A','low balance'),
('BA_West','savings_B','low balance'),
('BA_West','savings_B','overdraft'),
('WF_2','market_X','administrative'),
('WF_2','market_X','frequency'),
('WF_2','market_X','fee'),
('TD_Online','Roth_IRA','low balance'),
('TD_Online','Roth_IRA','withdrawal'),
('NASA_Goddard','company_savings','credit union'),
('BA_South','GT_investments','withdrawal');

create table savings (
	bankID varchar(100),
    accountID varchar(100),
    minBalance integer default null,
    primary key (bankID, accountID),
    constraint fk10 foreign key (bankID, accountID) references interest_bearing(bankID, accountID)
) engine=innodb;

insert into savings values
('WF_2','savings_A',15000),
('BA_West','savings_B',10000),
('NASA_Goddard','company_savings',0),
('TD_GT','savings_A',0),
('BA_South','GT_savings',2000);

create table market (
	bankID varchar(100),
    accountID varchar(100),
    maxWithdrawals integer default null,
    numWithdrawals integer default null,
    primary key (bankID, accountID),
    constraint fk11 foreign key (bankID, accountID) references interest_bearing(bankID, accountID)
) engine=innodb;

insert into market values
('WF_2','market_X',2,1),
('TD_Online','Roth_IRA',0,0),
('TD_GT','Roth_IRA',null,null),
('BA_South','GT_investments',10,5);

create table checking (
	bankID varchar(100),
    accountID varchar(100),
    protectionBank varchar(100) default null,
    protectionAccount varchar(100) default null,	
    amount integer default null,
    dtOverdraft date default null,
    primary key (bankID, accountID),
    unique key (protectionBank, protectionAccount),
    constraint fk7 foreign key (bankID, accountID) references bank_account(bankID, accountID),
    constraint fk18 foreign key (protectionBank, protectionAccount) references savings(bankID, accountID)
) engine=innodb;

insert into checking values
('WF_2','checking_A', null, null, null, null),
('BA_West','checking_A','BA_West', 'savings_B', 600, '2021-12-08'),
('NASA_Goddard','company_checking', null, null, null, null),
('NASA_KSC','company_checking', null, null, null, null),
('TD_Online','company_checking', null, null, null, null);

create table workFor (
	bankID varchar(100),
    perID varchar(100),
    primary key (bankID, perID),
	constraint fk13 foreign key (bankID) references bank(bankID),
	constraint fk14 foreign key (perID) references employee(perID)
) engine=innodb;

insert into workFor values
('WF_2','arwhite6'),
('WF_1','ealfaro4'),
('WF_2','ealfaro4'),
('BA_West','rnairn5'),
('BA_South','beyonce'),
('NASA_Goddard','beyonce'),
('TD_Online','beyonce'),
('TD_GT','jperalta99'),
('TD_GT','cboyle99'),
('NASA_KSC','jperalta99'),
('NASA_KSC','cboyle99'),
('NASA_HAL','jperalta99'),
('BA_West','glinetti99'),
('TD_Online','glinetti99');

create table access (
	perID varchar(100),
	bankID varchar(100),
    accountID varchar(100),
    dtShareStart date not null,
    dtAction date default null,
    primary key (bankID, perID, accountID),
	constraint fk16 foreign key (perID) references customer(perID),
    constraint fk17 foreign key (bankID, accountID) references bank_account(bankID, accountID)
) engine=innodb;

insert into access values
('arwhite6','WF_2','checking_A','2021-08-10','2022-01-26'),
('arwhite6','WF_2','savings_A','2021-08-10','2021-11-11'),
('tjtalbot4','WF_2','savings_A','2021-08-17','2022-02-03'),
('owalter6','BA_West','checking_A','2020-09-02',null),
('owalter6','BA_West','savings_B','2020-09-02',null),
('msmith','NASA_Goddard','company_checking','2018-10-11',null),
('rsanchez','NASA_Goddard','company_checking','2018-10-10','2022-02-04'),
('rsanchez','NASA_KSC','company_checking','2018-10-10','2022-01-13'),
('tjtalbot4','TD_Online','company_checking','2020-12-07','2020-12-07'),
('rholt99','WF_2','market_X','2022-02-02','2020-02-04'),
('asantiago99','WF_2','market_X','2020-02-02','2020-02-04'),
('cboyle99','TD_Online','Roth_IRA','2021-09-26',null),
('glinetti99','TD_Online','Roth_IRA','2019-12-24',null),
('msmith','TD_GT','Roth_IRA','2021-01-01','2022-01-01'),
('kjennings66','BA_South','GT_investments','2009-08-09',null),
('rsanchez','NASA_Goddard','company_savings','2014-08-16',null),
('pbeesly17','TD_GT','savings_A','2021-09-09',null),
('atrebek1','BA_South','GT_savings','2015-12-31','2017-03-22'),
('kjennings66','BA_South','GT_savings','2010-08-09','2022-02-21');
