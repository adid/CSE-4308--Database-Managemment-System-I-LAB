--Task 01--

select customer.customer_name, customer.customer_city
from customer, borrower
where customer.customer_name=borrower.customer_name
minus
select customer.customer_name, customer.customer_city
from customer, depositor
where customer.customer_name=depositor.customer_name;

--Task 02--

select depositor.customer_name
from customer, depositor
where customer.customer_name=depositor.customer_name
intersect
select borrower.customer_name
from borrower, customer
where customer.customer_name=borrower.customer_name;

--Task 03--

select extract (month from acc_opening_date)as months,count(*) as count 
from account
group by extract (month from acc_opening_date);

--Task 04--

select months_between
(
    (select max(account.acc_opening_date)
    from depositor, account
    where depositor.account_number=account.account_number 
    and depositor.customer_name= 'Smith'),
    (select max(loan.loan_date)
    from borrower, loan
    where borrower.loan_number=loan.loan_number 
    and borrower.customer_name= 'Smith')
)month from dual;

--Task 05--

select a.branch_name, a.avg_amount from
(select branch_name, avg(amount) as avg_amount from loan group by branch_name) a,
branch where branch.branch_name=a.branch_name and
branch.branch_city not like '%HORSE%';

--Task 06--

select customer_name,account_number from depositor
where account_number in
(
    select account_number from account
    where balance=(select max(balance) from account)
);

--Task 07--

select branch_city,avg(amount) from loan,branch
where loan.branch_name=branch.branch_name
group by branch_city
having avg(amount)>1500; 

--Task 08--

select customer_name||' '||'ELIGIBLE'
as customer_name from depositor 
where account_number in 
(
    select account_number from account
    where balance>=
    (
        select sum(amount) from loan
        where loan.branch_name=account.branch_name
        and loan.loan_number in
        (
            select loan_number from borrower
            where borrower.customer_name=depositor.customer_name
        )
    )
);

--Task 09--

select branch_name || ' Elite' as branch_name from branch
where branch_name in
(
    select branch_name from account
    group by branch_name
    having sum(balance) > 
    (
        select avg(sum_balance) + 500 from
        (
            select branch_name, sum(balance) as sum_balance from account
            group by branch_name
        )
    )
)
union
select branch_name || ' Moderate' as branch_name from branch
where branch_name in
(
    select branch_name from account
    group by branch_name
    having sum(balance) between
    (
        select avg(sum_balance) + 500 from
        (
            select branch_name, sum(balance) as sum_balance from account
            group by branch_name
        )
    )
    and
    (
        select avg(sum_balance) - 500 from
        (
            select branch_name, sum(balance) as sum_balance from account
            group by branch_name
        )
    )
)
union
select branch_name || ' Poor' as branch_name from branch
where branch_name in
(
    select branch_name from account
    group by branch_name
    having sum(balance) < 
    (
        select avg(sum_balance) - 500 from
        (
            select branch_name, sum(balance) as sum_balance from account
            group by branch_name
        )
    )
);

--Task 10--

select branch_name, branch_city from branch
where branch_city in
(
    select customer_city from customer
    where customer_city not in
    (
        select customer_city from customer
        where customer_name in
        (
            select customer_name from depositor
        )
        or
        customer_name in
        (
            select customer_name from borrower
        )
    )
)
and branch_name in
(
    select branch_name from loan
    group by branch_name
    having count(*) > 0
)
and branch_name in
(
    select branch_name from account
    group by branch_name
    having count(*) > 0
);

--Task 11--

create table customer_new as 
select * from customer 
where customer_name='SPOON';

--Task 12--

insert into customer_new
select * from customer
where customer_name in
(
    select customer_name from depositor
)
or
customer_name in
(
    select customer_name from borrower
);

--Task 13--

alter table customer_new
add status varchar2(15);

