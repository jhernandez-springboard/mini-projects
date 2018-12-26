1.

SELECT DISTINCT name
FROM country_club.Facilities
WHERE membercost > 0;

2. 

SELECT count(*)
FROM country_club.Facilities
WHERE membercost = 0;

3.

SELECT
	facid, 
	name, 
	membercost,  
	monthlymaintenance
FROM (SELECT
		facid, 
		name, 
		membercost,  
		monthlymaintenance,
		membercost/monthlymaintenance AS ratio
	FROM country_club.Facilities) t
WHERE ratio <0.2

4. 

SELECT *
FROM country_club.Facilities
WHERE facid IN (1,5)

5.

SELECT 
	name,
	monthlymaintenance,
	CASE WHEN monthlymaintenance > 100
		THEN "expensive"
	ELSE "cheap"
		END AS expense 
FROM country_club.Facilities

6. 

SELECT 
	firstname,
	surname
FROM country_club.Members m
JOIN
(SELECT 
	MAX(joindate) as joindate
FROM country_club.Members)d
ON m.joindate = d.joindate

7.

SELECT DISTINCT *
FROM
	(SELECT 
		CONCAT(m.surname, ', ', m.firstname) as membername,
		f.name
	FROM country_club.Bookings b 

	LEFT JOIN country_club.Members m 
	ON b.memid = m.memid

	LEFT JOIN country_club.Facilities f 
	ON b.facid = f.facid

	WHERE f.name IN ('Tennis Court 1', 'Tennis Court 2'))t
ORDER BY name

8.

SELECT 
	b.bookid,
	f.name, 
	CONCAT(m.surname, ', ', m.firstname) as membername, 
	CASE WHEN b.memid = 0
		THEN f.guestcost * b.slots
	ELSE f.membercost * b.slots
		END AS booking_cost
FROM country_club.Bookings b 
JOIN country_club. Facilities f
ON b.facid = f.facid

JOIN country_club.Members m 
ON b.memid = m.memid

WHERE b.starttime LIKE '2012-09-14%'
AND (
	CASE WHEN b.memid = 0
		THEN f.guestcost * b.slots
	ELSE f.membercost * b.slots
		END ) > 30
ORDER BY booking_cost DESC;

9.

SELECT *
FROM
	(SELECT 
		b.bookid,
		f.name, 
		CONCAT(m.surname, ', ', m.firstname) as membername, 
		CASE WHEN b.memid = 0
			THEN f.guestcost * b.slots
		ELSE f.membercost * b.slots
			END AS booking_cost
	FROM country_club.Bookings b 
	JOIN country_club. Facilities f
	ON b.facid = f.facid

	JOIN country_club.Members m 
	ON b.memid = m.memid

	WHERE b.starttime LIKE '2012-09-14%')t
WHERE booking_cost > 30
ORDER BY booking_cost DESC;

10.
 
SELECT 
	name,
	SUM(booking_cost) AS total_revenue
FROM
	(SELECT
		b.bookid,
		f.name, 
		CASE WHEN b.memid = 0
			THEN f.guestcost * b.slots
		ELSE f.membercost * b.slots
			END AS booking_cost
	FROM country_club.Bookings b 
	JOIN country_club. Facilities f
	ON b.facid = f.facid) t
GROUP BY name
HAVING SUM(booking_cost) < 1000
ORDER BY SUM(booking_cost)




