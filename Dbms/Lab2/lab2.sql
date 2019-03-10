rem 1 Display the nobel laureate(s) who born after 1Jul1960.

select * from nobel 
where dob>'1-jul-1960';

rem 2 Display the Indian laureate (name, category, field, country, year awarded) who was awarded in the Chemistry category.

select name,category,field,country,year_award 
from nobel 
where country = 'India' and category='Che';

rem 3 Display the laureates (name, category,field and year of award) who was awarded between 2000 and 2005 for the Physics or Chemistry category.

select name,category,field,year_award 
from nobel 
where (year_award between 2000 and 2005) and category in ('Che','Phy');

rem 4 Display the laureates name with their age at the time of award for the Peace category.

select name, year_award - extract(year from dob) "year" 
from nobel 
where category='Pea';

rem 5 Display the laureates (name,category,aff_role,country) whose name starts with A or ends with a, but not from Isreal.

select name,category,aff_role,country 
from nobel 
where (name like 'A%' or name like '%a') and country!='Isreal';

rem 6 Display the name, gender, affiliation, dob and country of laureates who was born in 1950s.Label the dob column as Born 1950.
select  name, gender, aff_role, dob "Born 1950", country 
from nobel 
where  extract(year from dob) like '%5_';
rem 7 Display the laureates (name,gender,category,aff_role,country) whose name starts with A, D or H. Remove the laureate if he/she do not have any affiliation. Sort the results in ascending order of name.
select name,gender,category,aff_role,country 
from nobel 
where (name like 'A%' or name like 'D%' or name like 'H%')
and aff_role is not null
order by name;
rem 8 Display the university name(s) that has to its credit by having at least 2 nobel laureate with them.
select aff_role, count(*) 
from nobel 
where aff_role like 'University%'
group by aff_role 
having count(*)>1;
rem 9 List the date of birth of youngest and eldest laureates by countrywise.Label the column as Younger, Elder respectively. Include only the country having more than one laureate. Sort the output in alphabetical order of country.
select country, max(dob) "youngest", min(dob) "eldest" 
from nobel 
group by country 
having count(*)>1 
order by country;
rem 10 Show the details (year award,category,field) where the award is shared among the laureates in the same category and field. Exclude the laureates from USA.
select year_award,category,field from nobel 
where country!='USA' 
group by year_award,category,field 
having count(*)>1;