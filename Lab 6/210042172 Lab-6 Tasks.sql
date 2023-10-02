--Task 01--

create or replace view advisor_Selection as
select ID, name, dept_name 
from instructor;

--Task 02--

create or replace view student_Selection as
select max(advisor_Selection.name) as advisor_name, count(advisor.s_ID) as student_count 
from advisor_Selection left join advisor 
on advisor_Selection.ID = advisor.i_ID
group by advisor_Selection.ID;

--Task 03--

--a--
drop role student_role;
create role student_role;
grant create session, resource, create tablespace to student_role;
grant select on course to student_role;
grant select on advisor to student_role;

--b--
drop role course_teacher;
create role course_teacher;
grant create session, resource, create tablespace to course_teacher;
grant select on course to course_teacher;
grant select on student to course_teacher;

--c--
drop role head_dept;
create role head_dept;
grant create session, resource, create tablespace to head_dept;
grant course_teacher to head_dept;
grant select on instructor to head_dept;
grant insert on instructor to head_dept;

--d--
drop role administrator;
create role administrator;
grant create session, resource, create tablespace to administrator;
grant select on department to administrator;
grant select on instructor to administrator;
grant update(budget) on department to administrator;

---Task 04--

--a--
create user student1 identified by ps1;
grant student_role to student1;
connect student1/ps1;
select * from System.advisor;
select * from System.course;
drop table System.course; --Won't work

--b--
create user teacher1 identified by ps1;
grant course_teacher to teacher1;
connect teacher1/ps1;
select * from System.student;
select * from System.course;
drop table System.course; --Won't work

--c--
create user head1 identified by ps1;
grant head_dept to head1;
connect head1/ps1;
select * from System.student;
select * from System.course;
insert into System.instructor values ('21172', 'Adid', 'Math', '456700');
drop table System.course; --Won't work

--d--
create user admin1 identified by ps1;
grant administrator to admin1;
connect admin1/ps1;
select * from System.department;
select * from System.instructor;
update System.department set budget='150000' where dept_name='Music';
drop table System.department; --Won't work