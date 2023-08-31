\c postgres;
drop database if exists itstep;
create database itstep;
\c itstep;
create table groups (id serial primary key, name varchar(50));
create table students (id serial primary key, first_name varchar(50) not null, 
last_name varchar(50) not null, birth_date date default '2006-01-01', group_id int not null);
create table subjects (id serial primary key, name varchar(100));
create table marks (id serial primary key, student_id int not null, subject_id int not null, mark_value int not null check(mark_value >= 0 and mark_value <= 12));
create table teachers (id serial primary key, first_name varchar(50), last_name varchar(50));
create table teachers_subjects (id serial primary key, subject_id int not null, teacher_id int not null);
create index group_name_ind on groups(name);
create index students_fn on students(first_name);
create index students_ln on students(last_name);
insert into groups (name) values ('backend'), ('frontend'), ('full-stack');
insert into students (first_name, last_name, birth_date, group_id) values
('Azamat', 'Tolkinov', '2004-01-01', 1),
('Aza', 'Tolkin', '2004-01-01', 2),
('Diyor', 'Xudoyberdiyev', '2004-01-01', 3),
('Mavlon', 'Abdusattorov', '2004-01-01', 1),
('Doniyor', 'Sharipov', '2004-01-01', 2),
('Daniel', 'Jones', '2006-01-27', 2),
('NPC student', 'NPC', '2006-01-27', 2);

update students set last_name = 'noname' where last_name = 'NPC';
delete from students where last_name = 'noname';

insert into subjects (name) values
('Python'), ('Postgresql'), ('JavaScript'), ('Html/Css'), ('Django'), ('C++');

update subjects set name = 'C#' where name = 'C++';
delete from subjects where name = 'C#';

insert into marks (student_id, subject_id, mark_value) values
(1, 3, 10), (2, 1, 12), (1, 4, 11), (3, 3, 12), (4, 5, 12), (5, 1, 1),
(5, 2, 1), (1, 2, 3), (4, 2, 5), (1, 1, 1);

update marks set student_id = 2 where subject_id = 1 and mark_value = 1 and student_id = 1;
delete from marks where student_id = 2 and mark_value = 1 and subject_id = 1;


insert into teachers (first_name, last_name) values
('Teacher1', 'Last_name1'), ('Teacher2', 'Last_name2'),
('Teacher3', 'Last_name3'), ('Doniyor', 'Sharipov'), ('NPC', 'Npc');

update teachers set first_name = 'npc' where last_name = 'Npc';
delete from teachers where first_name = 'npc';

insert into teachers_subjects (subject_id, teacher_id) values
(1, 1), (1, 3), (2, 2), (3, 4), (2, 5);
insert into groups (name) values ('data science'), ('networking'), ('npc group');
update groups set name = 'aaaa' where name = 'npc group';
delete from groups where name = 'aaaa';

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
insert into students (first_name, last_name, birth_date, group_id) values
('John', 'Smith', '2005-02-14', 1),
('Emily', 'Johnson', '2006-03-21', 2),
('Michael', 'Williams', '2004-07-09', 3),
('Emma', 'Brown', '2005-09-03', 1),
('Daniel', 'Jones', '2006-01-27', 2),
('A', 'A', '2006-01-27', 2);
END;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
update students set first_name = 'B' where first_name = 'A';
delete from students where last_name = 'A';
END;

insert into subjects (name) values ('SQL'), ('Java'), ('Machine Learning'), ('A');

update subjects set name = 'B' where name = 'A';
delete from subjects where name = 'B';

insert into marks (student_id, subject_id, mark_value) values
(3, 4, 9), (2, 3, 11), (4, 1, 8), (1, 5, 10), (5, 3, 7), (3, 2, 9);
insert into teachers (first_name, last_name) values
('Teacher4', 'Last_name4'), ('Teacher5', 'Last_name5');
insert into teachers_subjects (subject_id, teacher_id) values
(3, 6), (4, 4), (5, 5);

select first_name, last_name from students where group_id = 2;
select first_name, last_name from students where first_name like 'A%';
select first_name, last_name from students where first_name ilike 'a%';
select marks.mark_value, subjects.name, students.first_name, students.last_name from marks join students on marks.student_id = students.id join subjects on marks.subject_id = subjects.id;
select subjects.name, teachers.first_name, teachers.last_name from teachers_subjects full join teachers on teachers_subjects.teacher_id = teachers.id full join subjects on teachers_subjects.subject_id = subjects.id;
-- Вывести группы с количеством студентов  в порядке убывания.
select groups.name, count(groups.name) as count_ from students join groups on group_id = groups.id group by groups.name order by count_ desc; 
-- Вывести студентов со средними оценкам в порядке убывания.
select students.first_name, students.last_name, avg(marks.mark_value) as average_mark from students left join marks on students.id = marks.student_id group by students.id order by average_mark desc;
-- Вывести всех учителей и студентов в порядке возрастания по фамилии.

select students.last_name as last_names from students union select teachers.last_name as last_name from teachers order by last_names;
-- Вывести учителей, которые являются еще и студентами.
select students.first_name as names from students intersect select teachers.first_name as names from teachers order by names;
-- Вывести студентов, среди которых нет сотрудников.
select students.first_name as names from students except select teachers.first_name as names from teachers order by names;


drop database if exists my_shop;
create database my_shop;
\c my_shop;
create table shop (id serial primary key, name varchar(50) not null, shop_address varchar(100) default 'Tashkent' not null);
create table stock (id serial primary key, name varchar(50), shop_id int unique references shop(id));
create table category (id serial primary key, name varchar(50) not null);
create table product (id serial primary key, name varchar(50) not null, cat_id int not null references category(id));
create table vehicle (id serial primary key, name varchar(50) not null, shop_id int not null references shop(id));
create table status (id serial primary key,name varchar(255) not null);
create table worker (id serial primary key, name varchar(50) not null, status_id int not null references status(id), shop_id int not null references shop(id));
-- У одного рабочего может быть неколько транспортов и точно так же одной машиной может управлять разные работники в зависимости от их смены
create table vehicle_worker(vehicle_id int references vehicle(id), worker_id int references worker(id));
-- В одном магазине есть много товаров. Какой-то товар может иметься в разных магазинах
create table product_shop (product_id int references product(id), shop_id int references shop(id) not null);
create table orders (id serial primary key, worker_id int references worker(id), datee date not null default current_date check (datee <= current_date));
create table order_item (id serial primary key, product_id int references product(id), quantity int not null, order_id int references orders(id));
insert into shop (name, shop_address) values
    ('korzinka', 'Tashkent'),
    ('macro', 'Bukhara'),
    ('tegen', 'xorezm');
insert into stock (name, shop_id) values
    ('stock 1', 1),
    ('stock 2', 2),
    ('stock 3', 3);

insert into category (name) values
    ('drinks'),
    ('vegetables'),
    ('fruits');

insert into product (name, cat_id) values
    ('Coca-Cola', 1),     
    ('Pepsi', 1),         
    ('Sprite', 1),        
    ('Carrots', 2),       
    ('Potatoes', 2),      
    ('Tomatoes', 2),      
    ('Apples', 3),        
    ('Bananas', 3),       
    ('Oranges', 3),       
    ('Water', 1),         
    ('Juice', 1),         
    ('Milk', 1),          
    ('Tea', 1),           
    ('Coffee', 1),        
    ('Smoothie', 1);      

insert into vehicle (name, shop_id) values
    ('vehicle 1', 1),
    ('vehicle 2', 2),
    ('vehicle 3', 3),
    ('vehicle 4', 1),
    ('vehicle 5', 2),
    ('vehicle 6', 3);
insert into status (name) values
    ('status 1'),
    ('status 2'),
    ('status 3'),
    ('status 4');
insert into worker (name, status_id, shop_id) values
    ('john', 1, 1),
    ('ann', 2, 2),
    ('paul', 3, 3),
    ('Diyor', 1, 2),
    ('Mavlon', 2, 1),
    ('Winston', 4, 1),
    ('ivan', 1, 2),
    ('nadya', 2, 3),
    ('cj', 3, 1),
    ('vin', 4, 2),
    ('tom', 1, 3),
    ('ferb', 2, 1);
insert into vehicle_worker (vehicle_id, worker_id) values
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6);
insert into product_shop (product_id, shop_id) values
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 1),
    (5, 2),
    (6, 3),
    (7, 1),
    (8, 2),
    (9, 3),
    (10, 1),
    (11, 2),
    (12, 3),
    (13, 1),
    (14, 2),
    (15, 3);
insert into orders (worker_id) values
    (1),
    (2),
    (3),
    (4),
    (5),
    (1), 
    (2), 
    (3), 
    (2), 
    (5), 
    (6), 
    (4), 
    (2),
    (2),
    (1);
insert into orders (worker_id, datee) values
    (6, '12-12-2020'),
    (7, '01-01-2021'),
    (8, '01-02-2021'),
    (9, '02-01-2021'),
    (10, '01-03-2021');

insert into order_item (product_id, quantity, order_id) values
    (1, 2, 1),
    (2, 3, 1),
    (3, 1, 1),
    (4, 5, 2),
    (5, 2, 2),
    (6, 4, 2),
    (7, 3, 3),
    (8, 1, 3),
    (9, 2, 3),
    (10, 4, 4),
    (11, 1, 4),
    (12, 3, 4),
    (13, 2, 5),
    (14, 1, 5),
    (15, 5, 5);
select product.name, category.name from product join category on product.cat_id = category.id where cat_id = 1;
select worker.name, status.name as name from worker join status on worker.status_id = status.id where status_id between 2 and 4;
select * from product_shop where shop_id not in (2, 3);
select name, status_id from worker where name like '%5';
select stock.name as stock, shop.name as shop, shop.shop_address from stock inner join shop on stock.shop_id = shop.id;
select product.name as products, category.name as categories from product left join category on product.cat_id = category.id;
select shop.name as shop_name, shop.shop_address, worker.name as worker_name, status.name as status_name from shop right outer join worker on shop.id = worker.shop_id join status on worker.status_id = status.id;
--Вывести сотрудников по количеству продаж в порядке убывания.
select worker.name, count(orders.worker_id) as sales from worker join orders on worker.id = orders.worker_id group by worker.name order by sales desc;
-- Вывести магазины по сумме продаж в порядке убывания.
select shop.name, count(orders.worker_id) as sales from worker join orders on worker.id = orders.worker_id join shop on worker.shop_id = shop.id group by shop.name order by sales desc;
