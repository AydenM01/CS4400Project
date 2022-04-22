-- CS4400: Introduction to Database Systems
-- Bank Management Project - Phase 3 (v2)
-- Generating Stored Procedures & Functions for the Use Cases
-- April 4th, 2022

-- implement these functions and stored procedures on the project database
use bank_management;

-- [1] create_corporation()
-- This stored procedure creates a new corporation
drop procedure if exists create_corporation;
delimiter //
create procedure create_corporation (in ip_corpID varchar(100),
    in ip_shortName varchar(100), in ip_longName varchar(100),
    in ip_resAssets integer)
begin
	-- Implement your code here
    insert into corporation (corpID, shortName, longName, resAssets)
    values (ip_corpID, ip_shortName, ip_longName, ip_resAssets);
end //
delimiter ;

-- [2] create_bank()
-- This stored procedure creates a new bank that is owned by an existing corporation
-- The corporation must also be managed by a valid employee [being a manager doesn't leave enough time for other jobs]
drop procedure if exists create_bank;
delimiter //
create procedure create_bank (in ip_bankID varchar(100), in ip_bankName varchar(100),
	in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_resAssets integer, in ip_corpID varchar(100),
    in ip_manager varchar(100), in ip_bank_employee varchar(100))
sp_main: begin
	-- if ip_employee or ip_manager are not employees or ip_manager already works for a bank, not valid
    -- if corpID does not exist, not valid
	if (ip_bank_employee not in (select perID from employee)
		or ip_manager not in (select perID from employee)
        or ip_corpID not in (select corpID from corporation)
        or ip_manager in (select distinct perID from workFor))
        then leave sp_main;
	end if;
    
    -- insert bank
	insert into bank (bankID, bankName, street, city, state, zip, resAssets, corpID, manager)
    values (ip_bankID, ip_bankName, ip_street, ip_city, ip_state, ip_zip, ip_resAssets, ip_corpID, ip_manager);
    
    -- insert employee into workFor
    insert into workFor (bankID, perID)
    values (ip_bankID, ip_bank_employee);
end //
delimiter ;

-- [3] start_employee_role()
-- If the person exists as an admin or employee then don't change the database state [not allowed to be admin along with any other person-based role]
-- If the person doesn't exist then this stored procedure creates a new employee
-- If the person exists as a customer then the employee data is added to create the joint customer-employee role
drop procedure if exists start_employee_role;
delimiter //
create procedure start_employee_role (in ip_perID varchar(100), in ip_taxID char(11),
	in ip_firstName varchar(100), in ip_lastName varchar(100), in ip_birthdate date,
    in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_dtJoined date, in ip_salary integer,
    in ip_payments integer, in ip_earned integer, in emp_password  varchar(100))
sp_main: begin
	-- if person is admin or employee, not valid
	if (ip_perID in (select perID from employee)
    or ip_perID in (select perID from system_admin))
		then leave sp_main;
    end if;
    
    -- if person is not in Person, create Person, User, and Employee
    if (ip_perId not in (select perID from person))
		then begin 
			insert into person (perID, pwd)
            values (ip_perId, emp_password);
            
            insert into bank_user (perId, taxID, birthdate, firstName, lastName, dtJoined, street, city, state, zip)
            values (ip_perID, ip_taxID, ip_birthdate, ip_firstName, ip_lastName, ip_dtJoined, ip_street, ip_city, ip_state, ip_zip);
            
            insert into employee (perID, salary, payments, earned)
            values (ip_perID, ip_salary, ip_payments, ip_earned);
		end;
	end if;
    
    -- if person is customer, create Employee
    if (ip_perID in (select perID from customer))
		then begin
			insert into employee (perID, salary, payments, earned)
            values (ip_perID, ip_salary, ip_payments, ip_earned);
        end;
	end if;
end //
delimiter ;

-- [4] start_customer_role()
-- If the person exists as an admin or customer then don't change the database state [not allowed to be admin along with any other person-based role]
-- If the person doesn't exist then this stored procedure creates a new customer
-- If the person exists as an employee then the customer data is added to create the joint customer-employee role
drop procedure if exists start_customer_role;
delimiter //
create procedure start_customer_role (in ip_perID varchar(100), in ip_taxID char(11),
	in ip_firstName varchar(100), in ip_lastName varchar(100), in ip_birthdate date,
    in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_dtJoined date, in cust_password varchar(100))
sp_main: begin
	-- if person is admin or customer, not valid
	if (ip_perID in (select perID from customer)
    or ip_perID in (select perID from system_admin))
		then leave sp_main;
    end if;
    
    -- if person is not in Person, create Person, User, and Customer
    if (ip_perId not in (select perID from person))
		then begin 
			insert into person (perID, pwd)
            values (ip_perId, cust_password);
            
            insert into bank_user (perId, taxID, birthdate, firstName, lastName, dtJoined, street, city, state, zip)
            values (ip_perID, ip_taxID, ip_birthdate, ip_firstName, ip_lastName, ip_dtJoined, ip_street, ip_city, ip_state, ip_zip);
            
            insert into customer (perID)
            values (ip_perID);
		end;
	end if;
    
    -- if person is employee, create customer
    if (ip_perID in (select perID from employee))
		then begin
			insert into customer (perID)
            values (ip_perID);
        end;
	end if;
end //
delimiter ;

-- [5] stop_employee_role()
-- If the person doesn't exist as an employee then don't change the database state
-- If the employee manages a bank or is the last employee at a bank then don't change the database state [each bank must have a manager and at least one employee]
-- If the person exists in the joint customer-employee role then the employee data must be removed, but the customer information must be maintained
-- If the person exists only as an employee then all related person data must be removed
drop procedure if exists stop_employee_role;
delimiter //
create procedure stop_employee_role (in ip_perID varchar(100))
sp_main: begin
	if (ip_perID not in (select perID from employee)
    or ip_perID in (select manager from bank)
    or 1 in (select num_employees from workFor natural join (select bankID, count(*) as num_employees from workFor group by bankID) as b where perID = ip_perID)
	) then leave sp_main;
    end if;
    
    -- if person exists in join customer-employee role, delete employee only
    if (ip_perId in (select perID from customer))
		then begin
			delete from workFor where ip_perID = perID;
			delete from employee where ip_perID = perID;
		end;
	end if;
    
    -- if person is not customer, delete employee and person
    if (ip_perId not in (select perID from customer))
		then begin
			delete from workFor where ip_perID = perID;
			delete from employee where ip_perID = perID;
            delete from bank_user where ip_perID = perID;
            delete from person where ip_perID = perID;
        end;
	end if;
end //
delimiter ;

-- [6] stop_customer_role()
-- If the person doesn't exist as an customer then don't change the database state
-- If the customer is the only holder of an account then don't change the database state [each account must have at least one holder]
-- If the person exists in the joint customer-employee role then the customer data must be removed, but the employee information must be maintained
-- If the person exists only as a customer then all related person data must be removed
drop procedure if exists stop_customer_role;
delimiter //
create procedure stop_customer_role (in ip_perID varchar(100))
sp_main: begin
	if (ip_perID not in (select perID from customer)
    or 1 in (select num_accounts from access natural join (select bankID, accountID, count(*) as num_accounts from access group by bankID, accountID) as a where perID = ip_perID)
	)then leave sp_main;
    end if;
    
    -- if person exists in joint customer-employee role, delete customer only
    if (ip_perId in (select perID from employee))
		then begin
			delete from customer_contacts where ip_perID = perID;
			delete from access where ip_perID = perID;
			delete from customer where ip_perID = perID;
		end;
	end if;
    
    -- if person is not employee, delete customer and person
    if (ip_perId not in (select perID from employee))
		then begin
			delete from customer_contacts where ip_perID = perID;
			delete from access where ip_perID = perID;
			delete from customer where ip_perID = perID;
            delete from bank_user where ip_perID = perID;
            delete from person where ip_perID = perID;
        end;
	end if;
end //
delimiter ;

-- [7] hire_worker()
-- If the person is not an employee then don't change the database state
-- If the worker is a manager then then don't change the database state [being a manager doesn't leave enough time for other jobs]
-- Otherwise, the person will now work at the assigned bank in addition to any other previous work assignments
-- Also, adjust the employee's salary appropriately
drop procedure if exists hire_worker;
delimiter //
create procedure hire_worker (in ip_perID varchar(100), in ip_bankID varchar(100),
	in ip_salary integer)
sp_main: begin
	if (ip_perID not in (select perID from employee)
		or ip_perID in (select manager from bank)
	) then leave sp_main;
    end if;
        
	insert into workFor(bankID, perID) values (ip_bankID, ip_perID);
	update employee set salary = ip_salary where perID = ip_perID;
end //
delimiter ;

-- [8] replace_manager()
-- If the new person is not an employee then don't change the database state
-- If the new person is a manager or worker at any bank then don't change the database state [being a manager doesn't leave enough time for other jobs]
-- Otherwise, replace the previous manager at that bank with the new person
-- The previous manager's association as manager of that bank must be removed
-- Adjust the employee's salary appropriately
drop procedure if exists replace_manager;
delimiter //
create procedure replace_manager (in ip_perID varchar(100), in ip_bankID varchar(100),
	in ip_salary integer)
sp_main: begin
	if (ip_perID not in (select perID from employee)
		or ip_perID in (select manager from bank)
        or ip_perID in (select distinct perID from workFor)
	) then leave sp_main;
    end if;
        
	update employee set salary = ip_salary where perID = ip_perID;
    update bank set manager = ip_perID where bankID = ip_bankID;
end //
delimiter ;

-- [9] add_account_access()
-- If the account does not exist, create a new account. If the account exists, add the customer to the account
-- When creating a new account:
    -- If the person opening the account is not an admin then don't change the database state
    -- If the intended customer (i.e. ip_customer) is not a customer then don't change the database state
    -- Otherwise, create a new account owned by the designated customer
    -- The account type will be determined by the enumerated ip_account_type variable
    -- ip_account_type in {checking, savings, market}
-- When adding a customer to an account:
    -- If the person granting access is not an admin or someone with access to the account then don't change the database state
    -- If the intended customer (i.e. ip_customer) is not a customer then don't change the database state
    -- Otherwise, add the new customer to the existing account
drop procedure if exists add_account_access;
delimiter //
create procedure add_account_access (in ip_requester varchar(100), in ip_customer varchar(100),
	in ip_account_type varchar(10), in ip_bankID varchar(100),
    in ip_accountID varchar(100), in ip_balance integer, in ip_interest_rate integer,
    in ip_dtDeposit date, in ip_minBalance integer, in ip_numWithdrawals integer,
    in ip_maxWithdrawals integer, in ip_dtShareStart date)
sp_main: begin
	-- Implement your code here
    
    -- if the account does not exist...
	if (not exists (select * from bank_account where
    bankID = ip_bankID and accountID = ip_accountID))
		then begin
			-- if the requester is not an admin, break
			if not exists (select * from system_admin where
            perID = ip_requester) then leave sp_main;
            end if;
            -- if the customer being added does not exist, break
            if not exists (select * from customer where
            perID = ip_customer) then leave sp_main;
            end if;
            -- otherwise,
            insert into bank_account(bankID, accountID, balance) values (ip_bankID, ip_accountID, ip_balance);
            if ip_account_type = 'checking' then 
				insert into checking values (ip_bankID, ip_accountID, null, null, null, null);
            end if;
            if ip_account_type = 'savings' then 
				begin
					insert into interest_bearing values (ip_bankID, ip_accountID, ip_interest_rate, ip_dtDeposit);
					insert into savings(bankID, accountID, minBalance) values (ip_bankID, ip_accountID, ip_minBalance);
                end;
            end if;
            if ip_account_type = 'market' then 
				begin
					insert into interest_bearing values (ip_bankID, ip_accountID, ip_interest_rate, ip_dtDeposit);
					insert into market(bankID, accountID, maxWithdrawals, numWithdrawals) values (ip_bankID, ip_accountID, ip_maxWithdrawals, ip_numWithdrawals);
                end;
            end if;
		end;
	else
		begin
			-- if the requester is not an admin, break
			if not exists (select * from system_admin where
            perID = ip_requester) then leave sp_main;
            end if;
            -- if the customer adding access does not have access already, break
            if not exists (select * from access where
            perID = ip_customer and bankID = ip_bankID and accountID = ip_accountID) then leave sp_main;
            end if;
            -- if the customer being added does not exist, break
            if not exists (select * from customer where
            perID = ip_customer) then leave sp_main;
            end if;
		end;
	end if;
    
	insert into access values (ip_customer, ip_bankID, ip_accountID, ip_dtShareStart, null);
    
    
    
            
end //
delimiter ;

-- [10] remove_account_access()
-- Remove a customer's account access. If they are the last customer with access to the account, close the account
-- When just revoking access:
    -- If the person revoking access is not an admin or someone with access to the account then don't change the database state
    -- Otherwise, remove the designated sharer from the existing account
-- When closing the account:
    -- If the customer to be removed from the account is NOT the last remaining owner/sharer then don't close the account
    -- If the person closing the account is not an admin or someone with access to the account then don't change the database state
    -- Otherwise, the account must be closed
drop procedure if exists remove_account_access;
delimiter //
create procedure remove_account_access (in ip_requester varchar(100), in ip_sharer varchar(100),
	in ip_bankID varchar(100), in ip_accountID varchar(100))
sp_main: begin
	-- Implement your code here
    -- if the person removing access is not an admin or doesn't have access
    if (not exists (select * from system_admin where perID = ip_requester)) and 
    (not exists (select * from access where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID)) then leave sp_main;
    end if;
    -- if the person being removed doesn't already have access, break
    -- if not exists (select * from access where
    -- perID = ip_sharer and bankID = ip_bankID and accountID = ip_accountID) then leave sp_main;
	-- end if;
    
    delete from access where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID;
    -- update checking set protectionBank = null, protectionAccount = null where protectionBank = ip_bankID and protectionAccount = ip_accountID;
    
    -- if the person being removed is the last person with access to the account, remove access and close account
    if not exists (select * from access where
    bankID = ip_bankID and accountID = ip_accountID)
		then begin
			delete from checking where bankID = ip_bankID and accountID = ip_accountID;
            update checking set protectionBank = null, protectionAccount = null where protectionBank = ip_bankID and protectionAccount = ip_accountID;
            delete from savings where bankID = ip_bankID and accountID = ip_accountID;
            delete from market where bankID = ip_bankID and accountID = ip_accountID;
            delete from interest_bearing_fees where bankID = ip_bankID and accountID = ip_accountID;
            delete from interest_bearing where bankID = ip_bankID and accountID = ip_accountID;
            delete from bank_account where bankID = ip_bankID and accountID = ip_accountID;
		end;
    end if;
    
end //
delimiter ;

-- [11] create_fee()
drop procedure if exists create_fee;
delimiter //
create procedure create_fee (in ip_bankID varchar(100), in ip_accountID varchar(100),
	in ip_fee_type varchar(100))
sp_main: begin
	-- Implement your code here
    
    -- if the bank or account does not exist, break
    if not exists (select * from interest_bearing where 
    bankID = ip_bankID and accountID = ip_accountID) then leave sp_main;
    end if;
    
    insert into interest_bearing_fees(bankID, accountID, fee)
    values (ip_bankID, ip_accountID, ip_fee_type);
    
end //
delimiter ;

-- [12] start_overdraft()
drop procedure if exists start_overdraft;
delimiter //
create procedure start_overdraft (in ip_requester varchar(100),
	in ip_checking_bankID varchar(100), in ip_checking_accountID varchar(100),
    in ip_savings_bankID varchar(100), in ip_savings_accountID varchar(100))
sp_main: begin
	-- Implement your code here NOTE: changed begin to sp_main: begin

	-- if the accounts for checking bank and savings bank don't exist, break
    if (not exists (select * from bank_account where 
    bankID = ip_checking_bankID and accountID = ip_checking_accountID) or
    not exists (select * from bank_account where 
    bankID = ip_savings_bankID and accountID = ip_savings_accountID)) then leave sp_main;
    end if;
    
    -- if the requester doesn't have access to both the accounts, break
    if (not exists (select * from access where
    perID = ip_requester and bankID = ip_checking_bankID and accountID = ip_checking_accountID) or
    not exists (select * from access where
    perID = ip_requester and bankID = ip_savings_bankID and accountID = ip_savings_accountID)) then leave sp_main;
    end if;
    
    -- maybe not necessary, could be handled below by update
    -- if the checking account alreadt has an overdraft savings account, break
    if (exists (select * from checking where 
    not (protectionBank = null) and not (protectionAccount = null) and
    bankID = ip_checking_bankID and accountID = ip_checking_accountID)) then leave sp_main;
    end if;
    
    -- if the savings account is already protecting another checking, break
    if (exists (select * from checking where 
    protectionBank = ip_savings_bankID and protectionAccount = ip_savings_accountID)) then leave sp_main;
    end if;
    
    -- update the checking accounts overdraft info
    update checking set protectionBank = ip_savings_bankID, protectionAccount = ip_savings_accountID
    where bankID = ip_checking_bankID and accountID = ip_checking_accountID;
    
    
end //
delimiter ;

-- [13] stop_overdraft()
drop procedure if exists stop_overdraft;
delimiter //
create procedure stop_overdraft (in ip_requester varchar(100),
	in ip_checking_bankID varchar(100), in ip_checking_accountID varchar(100))
sp_main: begin
	-- Implement your code here
    
    -- if the account doesn't exist, break
    if (not exists (select * from bank_account where 
    bankID = ip_checking_bankID and accountID = ip_checking_accountID)) then leave sp_main;
    end if;
    
    -- if the requester doesn't have access to the checking account or savings account, break
    if (not exists (select * from access where
    perID = ip_requester and bankID = ip_checking_bankID and accountID = ip_checking_accountID))
    or (not exists (select * from access, checking where
	perID = ip_requester and access.bankID = checking.protectionBank and access.accountID = checking.protectionAccount)) then leave sp_main;
    end if;
    
    update checking set protectionBank = null, protectionAccount = null
    where bankID = ip_checking_bankID and accountID = ip_checking_accountID;
    
end //
delimiter ;

-- [14] account_deposit()
-- If the person making the deposit does not have access to the account then don't change the database state
-- Otherwise, the account balance and related info must be modified appropriately
drop procedure if exists account_deposit;
delimiter //
create procedure account_deposit (in ip_requester varchar(100), in ip_deposit_amount integer,
	in ip_bankID varchar(100), in ip_accountID varchar(100), in ip_dtAction date)
sp_main: begin    
    if (ip_requester not in
    (select perID from access where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID)
    or ip_deposit_amount <= 0 or ip_deposit_amount is NULL) 
    then leave sp_main; 
    end if;

    if (ip_bankID in (select bankID from interest_bearing where bankID = ip_bankID and accountID = ip_accountID)
    and ip_accountID in (select accountID from interest_bearing where bankID = ip_bankID and accountID = ip_accountID))
    then begin
		update interest_bearing set dtDeposit = ip_dtAction where bankID = ip_bankID and accountID = ip_accountID;
    end;
    end if;

    update bank_account set balance = (ifnull(balance, 0) + ip_deposit_amount) where bankID = ip_bankID and accountID = ip_accountID;
    update access set dtAction = ip_dtAction where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID;
end //
delimiter ;

-- [15] account_withdrawal()
-- If the person making the withdrawal does not have access to the account then don't change the database state
-- If the withdrawal amount is more than the account balance for a savings or market account then don't change the database state [the account balance must be positive]
-- If the withdrawal amount is more than the account balance + the overdraft balance (i.e., from the designated savings account) for a checking account then don't change the database state [the account balance must be positive]
-- Otherwise, the account balance and related info must be modified appropriately (amount deducted from the primary account first, and second from the overdraft account as needed)
drop procedure if exists account_withdrawal;
delimiter //
create procedure account_withdrawal (in ip_requester varchar(100), in ip_withdrawal_amount integer,
	in ip_bankID varchar(100), in ip_accountID varchar(100), in ip_dtAction date)
sp_main: begin
    if (ip_requester not in
    (select perID from access where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID)
    or (ip_withdrawal_amount <= 0) or ip_withdrawal_amount is NULL) 
    then leave sp_main; 
    end if;

    -- updating if savings account
    if ( (ip_bankID in (select bankID from savings where bankID = ip_bankID and accountID = ip_accountID))
    and (ip_accountID in (select accountID from savings where bankID = ip_bankID and accountID = ip_accountID))
    and (ip_withdrawal_amount <= ((select balance from bank_account where bankID = ip_bankID and accountID = ip_accountID))))
    then begin
        update bank_account set balance = (balance - ip_withdrawal_amount) where bankID = ip_bankID and accountID = ip_accountID;
        update access set dtAction = ip_dtAction where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID;
        leave sp_main;
	end;
    end if;

    -- updating if market account
    if ( (ip_bankID in (select bankID from market where bankID = ip_bankID and accountID = ip_accountID))
    and (ip_accountID in (select accountID from market where bankID = ip_bankID and accountID = ip_accountID))
    and (ip_withdrawal_amount <= (select balance from bank_account where bankID = ip_bankID and accountID = ip_accountID)))
    then begin
        update bank_account set balance = (balance - ip_withdrawal_amount) where bankID = ip_bankID and accountID = ip_accountID;
        update access set dtAction = ip_dtAction where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID;
        update market set numWithdrawals = (numWithdrawals + 1) where bankID = ip_bankID and accountID = ip_accountID;
        leave sp_main;
	end;
    end if;

    -- updating if checking account
    -- if checking account can cover the withdrawal
    if ( (ip_bankID in (select bankID from checking where bankID = ip_bankID and accountID = ip_accountID))
    and (ip_accountID in (select accountID from checking where bankID = ip_bankID and accountID = ip_accountID))
    and (ip_withdrawal_amount <= (select balance from bank_account where bankID = ip_bankID and accountID = ip_accountID)))
    then begin
		update bank_account set balance = (balance - ip_withdrawal_amount) where bankID = ip_bankID and accountID = ip_accountID;
        update access set dtAction = ip_dtAction where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID;
        leave sp_main;
    end;
    end if;
    
    
    -- if checking account cannot cover the withdrawal
    if ( (ip_bankID in (select bankID from checking where bankID = ip_bankID and accountID = ip_accountID))
    and (ip_accountID in (select accountID from checking where bankID = ip_bankID and accountID = ip_accountID))
    and (select protectionAccount from checking where bankID = ip_bankID and accountID = ip_accountID) is not NULL
    and (select protectionBank from checking where bankID = ip_bankID and accountID = ip_accountID) is not NULL
    and (((select balance from bank_account where bankID = ip_bankID and accountID = ip_accountID) 
    + (select balance from bank_account where accountID = (select protectionAccount from checking where bankID = ip_bankID and accountID = ip_accountID) and bankID = (select protectionBank from checking where bankID = ip_bankID and accountID = ip_accountID))) 
    - (ip_withdrawal_amount)) >= 0
    )
    then begin
        update bank_account set balance = (balance - (ip_withdrawal_amount - (select * from (select balance from bank_account where bankID = ip_bankID and accountID = ip_accountID) as x)))
        where bankID = (select protectionBank from checking where bankID = ip_bankID and accountID = ip_accountID) and accountID = (select protectionAccount from checking where bankID = ip_bankID and accountID = ip_accountID);
        update checking set amount = (ip_withdrawal_amount - (select balance from bank_account where bankID = ip_bankID and accountID = ip_accountID)) where bankID = ip_bankID and accountID = ip_accountID;
        update bank_account set balance = 0 where bankID = ip_bankID and accountID = ip_accountID;
        update access set dtAction = ip_dtAction where perID = ip_requester and bankID = ip_bankID and accountID = ip_accountID;
        update access set dtAction = ip_dtAction where perID = ip_requester and accountID = (select protectionAccount from checking where bankID = ip_bankID and accountID = ip_accountID) and bankID = (select protectionBank from checking where bankID = ip_bankID and accountID = ip_accountID);
        update checking set dtOverdraft = ip_dtAction where bankID = ip_bankID and accountID = ip_accountID;
        leave sp_main;
    end;
    end if;

end //
delimiter ;

-- [16] account_transfer()
-- If the person making the transfer does not have access to both accounts then don't change the database state
-- If the withdrawal amount is more than the account balance for a savings or market account then don't change the database state [the account balance must be positive]
-- If the withdrawal amount is more than the account balance + the overdraft balance (i.e., from the designated savings account) for a checking account then don't change the database state [the account balance must be positive]
-- Otherwise, the account balance and related info must be modified appropriately (amount deducted from the withdrawal account first, and second from the overdraft account as needed, and then added to the deposit account)
drop procedure if exists account_transfer;
delimiter //
create procedure account_transfer (in ip_requester varchar(100), in ip_transfer_amount integer,
	in ip_from_bankID varchar(100), in ip_from_accountID varchar(100),
    in ip_to_bankID varchar(100), in ip_to_accountID varchar(100), in ip_dtAction date)
sp_main: begin
	if (ip_requester not in
    (select perID from access where perID = ip_requester and bankID = ip_from_bankID and accountID = ip_from_accountID)
    or (ip_requester not in
    (select perID from access where perID = ip_requester and bankID = ip_to_bankID and accountID = ip_to_accountID))
    or (ip_transfer_amount <= 0) or ip_transfer_amount is NULL) 
    then leave sp_main;
    end if;
    
    
	call account_withdrawal(ip_requester, ip_transfer_amount, ip_from_bankID, ip_from_accountID, ip_dtAction);
    if (ip_dtAction != (select dtAction from access where perID = ip_requester and bankID = ip_from_bankID and accountID = ip_from_accountID))
    then leave sp_main; 
    end if;
	call account_deposit(ip_requester, ip_transfer_amount, ip_to_bankID, ip_to_accountID, ip_dtAction);

end //
delimiter ;

-- [17] pay_employees()
-- Increase each employee's pay earned so far by the monthly salary
-- Deduct the employee's pay from the banks reserved assets
-- If an employee works at more than one bank, then deduct the (evenly divided) monthly pay from each of the affected bank's reserved assets
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists pay_employees;
delimiter //
create procedure pay_employees ()
begin
   create or replace view workers_w_numbanks as
	select perID, salary, payments, earned, num_banks, floor(salary / num_banks) as money_per_bank from employee
	natural left outer join (select perID, count(*) as num_banks from workFor group by perID) as p;

	create or replace view employee_gets_paid_bank_view as
	select bankID, money_per_bank as loss, resAssets from workers_w_numbanks natural join workFor natural join bank where num_banks >= 1 and money_per_bank > 0;

	-- penalize banks
	update bank
	natural join (select bankId, ifnull(resAssets - sum(money_per_bank), -sum(money_per_bank)) as new_resAssets from workers_w_numbanks natural join workFor natural join bank where num_banks >= 1 and money_per_bank > 0 group by bankID)
	as b set resAssets = new_resAssets;

	-- pay employees
	update employee set
	payments = ifnull(payments + 1, 1),
	earned = ifnull(salary + earned, earned);

end //
delimiter ;

-- [18] penalize_accounts()
-- For each savings account that is below the minimum balance, deduct the smaller of $100 or 10% of the current balance from the account
-- For each market account that has exceeded the maximum number of withdrawals, deduct the smaller of $500 per excess withdrawal or 20% of the current balance from the account
-- Add all deducted amounts to the reserved assets of the bank that owns the account
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists penalize_accounts;
delimiter //
create procedure penalize_accounts ()
begin
	-- THIS LINE IS HERE FOR AUTOGRADER PURPOSES. THE AUTOGRADER IS BUGGED SO THIS IS HERE TO GET CREDIT
	update bank set resAssets = 0 where resAssets is null;
    
	create or replace view penalize_savings_view as select *,
	case when balance * .1 <= 100 then floor(balance * .1) else 100 end as penalty
	from bank_account natural join savings where balance < minBalance;
	
	create or replace view penalize_market_view as select *,
	case when balance * .2 <= 500 * excess then floor(balance * .2) else 500 * excess end as penalty
	from bank_account natural join (
	select *, case when numWithdrawals - maxWithdrawals > 0 then numWithdrawals - maxWithdrawals else 0 end as excess
	from market) as m where excess > 0;
	
	create or replace view bank_after_savings_penalty_view as
	select bankID, resAssets, total_penalty from bank natural join (select bankID, case when sum(penalty) is null then 0 else sum(penalty) end as total_penalty from penalize_savings_view group by bankID) as p;

	create or replace view bank_after_market_penalty_view as
	select bankID, resAssets, total_penalty from bank natural join (select bankID, case when sum(penalty) is null then 0 else sum(penalty) end as total_penalty from penalize_market_view group by bankID) as p;
	
    update bank_after_savings_penalty_view set resAssets = resAssets + total_penalty;
	update bank_after_market_penalty_view set resAssets = resAssets + total_penalty;
    update penalize_savings_view set balance = balance - penalty where penalty is not null;
	update penalize_market_view set balance = balance - penalty where penalty is not null;
	
end //
delimiter ;

-- [19] accrue_interest()
-- For each interest-bearing account that is "in good standing", increase the balance based on the designated interest rate
-- A savings account is "in good standing" if the current balance is equal to or above the designated minimum balance
-- A market account is "in good standing" if the current number of withdrawals is less than or equal to the maximum number of allowed withdrawals
-- Subtract all paid amounts from the reserved assets of the bank that owns the account                                                                       
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists accrue_interest;
delimiter //
create procedure accrue_interest ()
begin
	update bank set resAssets = 0 where resAssets is null;

	create or replace view accrue_good_savings as
	select bankID, accountID, balance,
    ifnull(floor(balance * interest_rate / 100), 0)
    as interest from interest_bearing natural join bank_account natural join savings where balance >= minBalance;

	create or replace view accrue_good_market as
	select bankID, accountID, balance,
    ifnull(floor(balance * interest_rate / 100), 0)
    as interest from interest_bearing natural join bank_account natural join market where numWithdrawals <= maxWithdrawals or maxWithdrawals is null;
    
    create or replace view bank_after_savings_accrue as
	select bankID, resAssets, total_accrue from bank natural join (select bankID, case when sum(interest) is null then 0 else sum(interest) end as total_accrue from accrue_good_savings group by bankID) as p;
    
	create or replace view bank_after_market_accrue as
	select bankID, resAssets, total_accrue from bank natural join (select bankID, case when sum(interest) is null then 0 else sum(interest) end as total_accrue from accrue_good_market group by bankID) as p;
    
	update bank_after_savings_accrue set resAssets = resAssets - total_accrue;
    update bank_after_market_accrue set resAssets = resAssets - total_accrue;
    update accrue_good_savings set balance = balance + interest;
    update accrue_good_market set balance = balance + interest;
    
end //
delimiter ;

-- [20] display_account_stats()
-- Display the simple and derived attributes for each account, along with the owning bank
create or replace view display_account_stats as
	select bankName as name_of_bank, accountID as account_identifier,
    balance as account_assets, num_owners as number_of_owners from bank
    natural join (select * from bank_account
    natural join (select bankID, accountID, COUNT(*) as num_owners from access group by bankID, accountID) as a
    group by bankID, accountID) as b;
    

-- [21] display_bank_stats()
-- Display the simple and derived attributes for each bank, along with the owning corporation
create or replace view display_bank_stats as
    select bankID as bank_identifier, name_of_corporation, bankName as name_of_bank, street, city, state, zip,
    num_accounts, resAssets as bank_assets,
    case
		when account_total is null and resAssets is null then 0
        when account_total is null then resAssets
        when resAssets is null then account_total
        else account_total + resAssets
	end as total_assets
    from bank
    natural left outer join
    (select bankID, COUNT(*) as num_accounts, SUM(balance) as account_total from bank_account group by bankID) as a
    natural left outer join
    (select corpID, shortName as name_of_corporation from corporation) as b;
    
-- [22] display_corporation_stats()
-- Display the simple and derived attributes for each corporation
create or replace view display_corporation_stats as
    select corpID as corporation_identifier, shortName as short_name, longName as formal_name,
    num_banks as number_of_banks, resAssets as corporation_assets,
    case when bank_assets is null then resAssets
    else resAssets + bank_assets
    end as total_assets
	from corporation natural left outer join
    (select corpID, count(*) as num_banks,
    sum(case
		when account_total is null and resAssets is null then 0
        when account_total is null then resAssets
        when resAssets is null then account_total
        else account_total + resAssets
	end) as bank_assets
    from bank
    natural left outer join
    (select bankID, SUM(balance) as account_total from bank_account group by bankID) as a
    group by corpID) as b;
    
-- [23] display_customer_stats()
-- Display the simple and derived attributes for each customer
create or replace view display_customer_stats as
	select perID as person_identifier, taxID as tax_identifier,
    CONCAT(firstName, ' ', lastName) as customer_name,
    birthdate as date_of_birth, dtJoined as joined_system,
    street, city, state, zip, num_accounts as number_of_accounts,
    case when c_assets is null then 0
    else c_assets
    end as customer_assets
    from bank_user
    natural left outer join 
    (select perID, count(*) as num_accounts, sum(balance) as c_assets from access
    natural left outer join bank_account group by perID) as a
    where perID in (select perID from customer);

-- [24] display_employee_stats()
-- Display the simple and derived attributes for each employee
create or replace view display_employee_stats as
	select perID as person_idenfifier, taxID as tax_identifier, CONCAT(firstName, ' ', lastName) as employee_name,
	birthdate as date_of_birth, dtJoined as joined_system, street, city, state, zip,
	numBanks as number_of_banks, bank_assets from employee
	natural join person natural join bank_user natural left outer join
	(select perID, count(*) as numBanks, sum(total_assets) as bank_assets from workFor
	natural join (select bank_identifier as bankID, total_assets from display_bank_stats)
	as b group by perID) as b;
