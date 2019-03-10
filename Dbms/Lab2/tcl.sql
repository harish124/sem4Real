savepoint A;
insert into nobel values(129,'Harish','m','Pea','World Organising','2018','University of India','18-oct-1955','India');

select * from nobel where name = 'Harish';

update nobel set aff_role='Linguists'
where category = 'Lit';

delete from nobel where field='Enzymes';

select * from nobel where field='Enzymes';

rollback to A;

select * from nobel where name = 'Harish';

commit;