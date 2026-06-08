-- Assignment Queries:

-- Beginner Level Queries

-- 1. List all patients with their name, age, gender, and phone number.
use hospital;

create database hospital;
create table patients(
patient_id  int auto_increment primary key,
Name varchar(400),
Age int,
Gender enum('Female','Male','Others'),
phone_number bigint not null,
createdat timestamp default current_timestamp
);
insert into patients(Name,Age,Gender,Phone_number,city) values ('divya',30,'Female',2345678901,'bangalore'),('praveen',23,'Male',2345678234,'mumbai'),('sunil',18,'Male',8905678901,'jaipur');
select * from patients;
update patients set name = 'amit' where patient_id = 2;
alter table patients add column city varchar(250); 


-- 2. List all doctors with their name and specialization

create table doctors(
Doctor_id int auto_increment primary key ,
Name varchar(250) not null,
Age int,
Gender enum('Female','Male','Others'),
phone_number bigint not null,
specialization varchar(250),
createdat timestamp default current_timestamp
);
insert into doctors(Name,Age,Gender,phone_number,specialization) values ('kala',55,'Female',9916300184,'Cardiologists'),('sundar',35,'Male',9916302345,'Neurologists'),('surya',25,'Male',9916144575,'ENT Specialists');
select * from doctors;
SELECT name, specialization FROM doctors;
update doctors set specialization = 'Orthopedics' where doctor_id = 1;
update doctors set specialization = 'dermotology' where doctor_id = 2;
update doctors set name = 'Dr. Sharma' where doctor_id = 1;

-- 3. Show all appointments scheduled for today.
create table appointments(
Appointment_id int auto_increment primary key,
status enum ('scheduled','cancelled','completed'),
date_time datetime,
fees int,
patient_id int,
Doctor_id int,
createdat timestamp default current_timestamp,
foreign key(patient_id) references patients(patient_id),
foreign key(Doctor_id) references doctors(Doctor_id)
);
insert into appointments(patient_id,doctor_id,status,date_time,fees) values 
(1,1,'completed','2023-03-26 23:22:12',1000),
(2,2,'cancelled','2023-06-08 12:22:12',400),
(3,3,'scheduled','2026-04-16 19:22:12',1000);
select * from appointments;
select * from  appointments where date(date_time)=curdate();

-- 4. Find the total number of patients in the system.
select count(*) as total_patients from patients;

-- 5. Find the total number of doctors in the hospital.
select count(*) as total_doctors from doctors;

-- 6. List all bills with status 'Paid'.
create table bills(
bill_id int auto_increment primary key,
patient_id int,
bil_amount bigint,
bill_status enum('paid','unpaid'),
date_time datetime,
createdat timestamp default current_timestamp,
foreign key(patient_id) references patients(patient_id)
);
insert into bills(patient_id,bil_amount,bill_status,date_time) values (1,23000,'paid','2023-04-09 23:33:16'),(2,28000,'unpaid','2023-10-19 12:33:16'),(3,78000,'paid','2023-09-09 12:33:16');
select * from bills;
SELECT * FROM bills WHERE bill_status = 'Paid';

-- 7. List all bills with status 'Unpaid'
select * from bills where bill_status = 'unpaid';
use hospital;
-- 8. Display all medications prescribed to patient named 'Amit'.
use hospital;
create table medicines(
medicines_id int auto_increment primary key,
name varchar(250),
price int,
status enum('delivered','not delivered','issue'),
time_date datetime,
patient_id int,
doctor_id int,
createdat timestamp default current_timestamp,
foreign key(patient_id) references patients(patient_id),
foreign key(doctor_id) references doctors(doctor_id)
);
insert into medicines (name,price,status,time_date,patient_id,doctor_id) values ('paracetamol',150,'delivered','2023-04-09 23:33:16',1,1),('dart',130,'not delivered','2026-01-11 22:09:13',2,2),('cipla',150,'delivered','2026-09-13 11:09:23',3,3);
select * from medicines;

select p.name as patient_name, m.name as medicine_name from patients p join medicines on p.patient_id = m.patients_id where p.name =' amit';
select m.* from medicines m join patients p on m.patient_id = p.patient_id where p.name = 'amit';

-- 9. Retrieve the details of doctors who specialize in 'Orthopedics'.
select * from doctors where specialization = 'Orthopedics';

-- 10. List the names of patients older than 60.
select * from patients where Age < 60;

-- 11. Show all appointments for doctor named 'Dr. Sharma'.
select a.* from doctors d join appointments a on d.Doctor_id=a.Doctor_id where d.name = 'Dr. Sharma';

-- 12. Show the phone numbers of patients who had appointments in the last 7 days.
select distinct phone_number from patients p join appointments a on p.patient_id=a.patient_id where date_time >= curdate() - interval 7 day;

-- 13. Find all appointments that were cancelled.
select * from appointments where status = 'cancelled';

-- 14.Show all unique specializations available in the hospital.
select distinct specialization from doctors;

-- 15. List patients who live in a specific city (e.g., 'Mumbai').
select * from patients where city ='bangalore';

-- Intermediate Level Queries
-- 16. Count the number of appointments each doctor has had.
SELECT Doctor_id, COUNT(*) AS total_appointments FROM appointments GROUP BY Doctor_id;

-- 17. Find the number of appointments made by each patient.
select patient_id, count(*) as num_of_appointments from appointments group by patient_id;

-- 18. Calculate the total amount billed to each patient
select patient_id, sum(bil_amount) as total_billed_amont from bills group by patient_id;

-- 19. List all doctors who have more than 5 appointments.
select  Doctor_id from appointments group by Doctor_id having count(*) > 5;

-- 20. Show the patients who have been prescribed more than 2 medications.
select patient_id from medicines group by patient_id having count(*) > 2;

-- 21. Retrieve the latest appointment for each patient
select * from appointments a where date_time =(select max(date_time)from appointments a2 where a.patient_id=a2.patient_id);

-- 22. Display patients who have unpaid bills greater than Rs.10,000.
select patient_id from bills where bill_status ='unpaid' group by patient_id having sum(bil_amount)> 10000;

-- 23. List patients who have had appointments with more than one doctor
select patient_id from appointments group by patient_id having count(distinct Doctor_id)>1;

-- 24. Show all patients who don't have any upcoming appointments.
select * from patients where patient_id not in(select patient_id  from appointments where date_time > now() );

-- 25. Find the total revenue generated in the current month.
select sum(bil_amount) as total_revenue from bills where month(date_time)= month(curdate());

-- 26.Show the number of medications prescribed to each patient:
select patient_id , count(*) as total_medicines from medicines group by patient_id;

-- 27. List all patients who were treated by doctors specialized in 'Dermatology'.
select distinct p.* from patients p join appointments a on p.patient_id=a.patient_id join doctors d on a.Doctor_id=d.Doctor_id where d.specialization = 'dermotology';

-- 28. Show appointments grouped by their status (Scheduled, Completed, Cancelled).
select status, count(*) as total from appointments group by status;

-- 29. Display the average bill amount for each patient.
select patient_id, avg(bil_amount) as avg_bill_amount from bills group by patient_id;

-- 30. Find doctors who have not had any appointments in the past 30 days.
select * from doctors where Doctor_id not in (select Doctor_id from appointments where date_time >= curdate() - interval 30 day );

--- Advanced Level Queries

-- 31. Find the top 3 doctors with the most completed appointments
SELECT doctor_id, COUNT(*) FROM appointments WHERE status = 'Completed' GROUP BY doctor_id ORDER BY COUNT(*) DESC LIMIT 3;

-- 32. List patients who have visited doctors of more than one specialization
select a.patient_id from appointments a join doctors d on a.Doctor_id=d.Doctor_id group by patient_id having count(distinct d.specialization)> 1;

-- 33. Generate a monthly report of total billed and paid amounts
select month(date_time) as month, year(date_time) as year, 
sum(bil_amount) as total_billed, sum(case when bill_status = 'paid' then bil_amount else 0 end ) as 
total_paid from bills group by year (date_time) ,month(date_time);

-- 34. Identify patients who have never had an appointment.
select * from patients where patient_id not in(select distinct patient_id from appointments);

-- 35. Identify patients who have never been prescribed any medication
select * from patients where patient_id not in(select distinct patient_id from medicines);

-- 36. Show patients with total unpaid bills exceeding Rs.50,000
select patient_id from bills where bill_status ='unpaid' group by patient_id having sum(bil_amount)>50000;

-- 37. Display the doctor who has treated the most unique patients
select Doctor_id,count(distinct patient_id)as patient_count from appointments group by Doctor_id order by patient_count desc limit 1;

-- 38. List patients who had appointments on consecutive days
select distinct a1.patient_id from appointments a1 join appointments a2 on a1.patient_id = a2.patient_id where datediff(a1.date_time, a2.date_time) =1;

-- 39. For each doctor, list their name and the number of unique patients they've treated
select d.name, count(distinct a.patient_id) as unique_patients from doctors d left join appointments a on d.Doctor_id = a.Doctor_id group by d.Doctor_id;

-- 40. Display a report of patients, their total number of appointments, total bill amount, and number of medications prescribed.
select p.patient_id, p.name, count(distinct a.Appointment_id)as total_appointments,  sum(b.bil_amount) as total_billed, count(distinct m.medicines_id) as total_medicines
from patients p
left join appointments a on p.patient_id = a.patient_id left join bills b on p.patient_id=b.patient_id left join medicines m on p.patient_id = m.patient_id group by p.patient_id;








