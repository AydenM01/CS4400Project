-- CS4400: Introduction to Database Systems (Spring 2022)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 21, 2022 @ 11:00pm EDT
-- Team 22
-- Team Member Name amarshall46
-- Team Member Name ai32
-- Team Member Name jcouvillon3
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, NOT taken from an SQL Dump file.
-- The file must run without error to receive any credit.

-- Recommendations:
-- You may arrange your create table() and insert() statements in any order.
-- Develop a "strategy" to determine the order in which you will implement the tables.
-- Then, implement each table, and ensure that you can load the data correctly before
-- beginning work on the next table.

-- ------------------------------------------------------
-- CREATE TABLE STATEMENTS AND INSERT STATEMENTS BELOW
-- ------------------------------------------------------

DROP DATABASE IF EXISTS bank_network;
CREATE DATABASE IF NOT EXISTS bank_network;
USE bank_network;

CREATE TABLE Corporation (
  id varchar(255),
  sname varchar(255),
  lname varchar(255),
  rav int,
  primary key (id)
) engine = innodb;

CREATE TABLE Person (
	id varchar(255),
    pass varchar(255),
    role_type enum('User', 'Admin'),
    primary key (id)
) engine = innodb;

CREATE TABLE Users (
	ssn char(11) primary key, -- this must be 11 for xxx-xx-xxxx
    fname varchar(255),
    lname varchar(255),
    joinedDate date,
    dob date,
    personID varchar(255) NOT NULL UNIQUE,
    street varchar(255),
    city varchar(255),
    state varchar(255),
    zip decimal(5, 0), -- this must be 5, 0 for 30332
    
    primary key (ssn),
    foreign key (personID) references Person (id) -- I don't know if we can make foreign keys like this or if we need to do it later in add constraint
    on update cascade on delete cascade -- if person is deleted user is deleted
) engine = innodb;

-- ex: alter table Users add constraint fk6 foreign key (personId) references Person (id)
-- on update cascade on delete cascade

CREATE TABLE Employee (
	userID varchar(255) NOT NULL UNIQUE,
    monthlySalary decimal(14, 2),
    lifetimeEarnings decimal(14, 2),
    numPayments smallint,

    primary key (userID),
    foreign key (userID) references Users (personID)
    on update cascade on delete cascade -- if User is deleted Employee is deleted
) engine = innodb;

CREATE TABLE Bank (
  id varchar(255),
  _name varchar(255),
  street varchar(255),
  city varchar(255),
  state varchar(255),
  zip int,
  rav decimal(14, 2),
  corpID varchar(255) NOT NULL, -- bank must have corp
  managerId varchar(255) NOT NULL, -- bank must have manager
  
  primary key (id),
  foreign key (corpId) references Corporation (id)
  on update cascade on delete cascade, -- if corporation is deleted bank gets deleted
  foreign key (managerId) references Employee (userID)
  on update restrict on delete restrict -- restrict manager data updates / deletion since bank may depend on it. ensures bank has manager
) engine = innodb;

CREATE TABLE Customer (
	userID varchar(255),
    primary key (userID),
    foreign key (userID) references Users (personID)
    on update cascade on delete cascade -- if User is deleted Customer is deleted
) engine = innodb;

CREATE TABLE CustomerContacts (
	customerID varchar(255),
	contactType varchar(255),
    address varchar(255),
    
    primary key (customerID, contactType, address),
    foreign key (customerID) references Customer (userId)
    on update cascade on delete cascade -- if Customer is deleted CustomerContacts is deleted
) engine = innodb;

CREATE TABLE Accounts (
	id varchar(255) NOT NULL,
    bankID varchar(255) NOT NULL, -- Account must have bank, hence not null
    balance decimal(14, 2),
    
    primary key (id, bankID),
    foreign key (bankID) references Bank (id)
    on update cascade on delete cascade -- if Bank is deleted Accounts are deleted
);

CREATE TABLE InterestBearing (
	accountID varchar(255) NOT NULL,
    bankID varchar(255) NOT NULL,
    interest smallint,
    lastDepositDate date,
    
    primary key (accountID, bankID),
	foreign key (accountID, bankID) references Accounts(id, bankID)
    on update cascade on delete cascade -- if Account is delted interest bearing count deleted
) engine = innodb;

CREATE TABLE MVFees (
	accountID varchar(255) NOT NULL,
    bankID varchar(255) NOT NULL,
    Fee varchar(255) NOT NULL,
    
    primary key (accountID, bankID, Fee),
    foreign key (accountID, bankID) references InterestBearing(accountID, bankID)
    on update cascade on delete cascade -- if InterestBearing is delted Fee is deleted
) engine = innodb;

CREATE TABLE CustomerOwnsAccounts (
	accountID varchar(255) NOT NULL,
    bankID varchar(255) NOT NULL,
    customerID varchar(255) NOT NULL,
    lastTransactionDate date,
    joinedAccountDate date,
    
    primary key (accountID, bankID, customerID),
    foreign key (accountID, bankID) references Accounts (id, bankID)
    on update cascade on delete cascade,
    foreign key (customerID) references Customer (userID)
    on update cascade on delete cascade
);

/*
CREATE TABLE Savings (
	ibAccountID,
    ibBankID,
    minBalance
) engine = innodb;

CREATE TABLE Checking (
	accountID,
    bankID,
	lastOverdraftDate,
	lastOverdraftAmount,
    overdraftSavings
) engine = innodb;

CREATE TABLE Market (
	ibAccountID,
    ibBankID,
    maxWithdrawalLimit,
    totalWithdrawals
) engine = innodb;

CREATE TABLE OverDraftProtectionPolicy (
	checkingAccountID,
    checkingBankID,
    savingsIbAccountID,
    savingsIbBankID,
    _date,
    amount
) engine = innodb;

CREATE TABLE EmployeeWorksForBank (
	employeeID,
    bankID
) engine = innodb;
 */
-- Unaddressed constraints:
-- Right now we are not addressing that a Checking and Interest-Bearing account should not point to the same Account
-- Similar to above we are not addressing that a Savings and Market account should not point to an Interest-Bearing account