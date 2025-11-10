---Netflix Project
drop table if exists netflix1;

create table  netflix(
show_id	varchar(10),
type  varchar(10),
title	 varchar(150),
director	varchar(220),
casts	varchar(1000),
 country	     varchar(150),
 date_added	varchar(50),
 release_year	int,
 rating	varchar(220), 
 duration  varchar(40),
 listed_in varchar(150),
 description varchar(300)
);

select* from netflix

select count(*) total_content
from netflix;

select distinct title
from netflix;

---15 Buisness problems

---1. count the number of  movies vs tv show

select type,
count(*) as tota_content
from netflix
group by type

---2.find the most common rating for tv and movies show
select type,rating
from
(select type ,rating,
count(*) max_count,
rank()over(partition  by type order by count(*) desc)as ranking
from netflix
group by 1,2)as t1
where ranking=1

--3.list all movies released in a specific year(e.g.,2020)

select *from netflix
where 
type='movie' 
and release_year= '2020'

---find top 5 countries with the most content on netflix

select unnest(string_to_array(country,','))as new_country,
count(show_id)
from netflix
group by country
order by 2 desc
limit 5

select*
--unnest(string_to_array(country,','))as new_country(seperate each country written in single row)
from netflix

---5.identify the longest movie

select * from 
netflix
where type='Movie'
and duration=(select max(duration) from netflix)

--6 find content added in the last 5 year
select * , to_date(date_added,'month dd yyyy')
from netflix
where to_date(date_added,'month dd yyyy')>=current_date- interval '5 years' 

---7 find all the movies/tv shows director 'rajiv chilaka'

select*
from netflix
where director like'%Rajiv Chilaka%'

---8. list all tv shows with more than 5 seasons

select *
---split_part(duration,' ',1)as sessions
from netflix
where type ='TV Show' and
SPLIT_PART(duration,' ',1)::numeric >5 

---9.count the number of content items in each genre

select unnest(string_to_array(listed_in, ','))as genre,
count(show_id) as total_content
from netflix
group by 1

--10.find each year and the average number of content release by india on netflix ,
--return top 5 years with highest avg content release

select EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))AS YEAR,
COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM NETFLIX WHERE COUNTRY='India')::numeric *100 as avg_content
from netflix
where country='India'
GROUP BY 1

