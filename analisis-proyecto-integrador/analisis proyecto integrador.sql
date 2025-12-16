CREATE SCHEMA IF NOT EXISTS analisis;
set search_path to analisis;

create table customers(
id_customer INT generated always as identity primary key,
names VARCHAR(150) not null,
documents VARCHAR(150) not null,
phone VARCHAR(20) not null,
email VARCHAR(150) not null ,
monthly_income NUMERIC(12, 2) not null, 
risk_score INT not null,
registration_date DATE not null 

);

create table loans(
id_loan INT generated always as identity primary key,
capital numeric(12,2) not null,
interest_rate numeric(12,2) not null,
term_months INT not null,
start_date DATE not null,
end_date DATE not null, 
state VARCHAR(100) not null ,
calculated_risk NUMERIC(100,2) not null,

id_customer INT references customers(id_customer)
 	ON UPDATE RESTRICT
    ON DELETE RESTRICT

);


create table payments(
id_payment  INT generated always as identity primary key,
payment_date DATE not null ,
paid_amount numeric(10,2) not null ,
interest_paid numeric(10,2) not null,
main_paid numeric(10,2) not null,
days_late INT not null,

id_loan INT references loans(id_loan)
 	ON UPDATE RESTRICT
    ON DELETE RESTRICT

);	


create table interest_rates(
id_rate  INT generated always as identity primary key,
dates DATE not null,
minimum_rate numeric(5,2) not null ,
maximum_rate numeric(5,2) not null ,
observations VARCHAR(200) not null 
);


create table risk_assessment(
id_assessment INT generated always as identity primary key,
score INT not null  ,
levels VARCHAR(100) not null  ,
justification VARCHAR(100) not null, 

id_customer INT references customers(id_customer),
id_loan INT references loans(id_loan)
 	ON UPDATE RESTRICT
    ON DELETE RESTRICT

);



select * from analisis.customers c;


select * from analisis.risk_assessment;

select * from analisis.customers c;








