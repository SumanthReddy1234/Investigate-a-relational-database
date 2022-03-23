/*QUESTION 1:
We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

Create a query that lists each film category it is classified in, and the number of times films from the category has been rented out.*/

//SOLUTION

SELECT  t1.category_name,
	t1.rental_count
FROM(
	SELECT  c.name AS category_name,
		COUNT(r.rental_id) AS rental_count
	FROM 
		category c
		JOIN film_category fc
	    	ON c.category_id=fc.category_id
	    	JOIN film f
	    	ON f.film_id=fc.film_id
	    	JOIN inventory i
	    	ON fc.film_id=i.film_id
	    	JOIN rental r
	    	ON i.inventory_id=r.inventory_id
	        GROUP BY 1) AS t1
WHERE t1.category_name IN('Animation','Children','Classics','Comedy','Family','Music')
ORDER BY 2;

/*#QUESTION 2
Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.
*/

//SOLUTION

SELECT t.title,t.name,t.rental_duration,NTILE(4) OVER(ORDER BY t.rental_duration) as standard_quartile

FROM(SELECT f.title,
f.rental_duration,
c.name

FROM film_category fc
JOIN category c
ON fc.category_id=c.category_id
JOIN film f
ON fc.film_id=f.film_id
WHERE name IN('Animation','Children','Classic','Comedy','Music','Family')
GROUP BY 1,2,3
ORDER BY 2,3) AS t
ORDER BY 3,4;


/*Question 3
Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:

Category
Rental length category
Count*/

//SOLUTION

SELECT (t.name),(t.rental_duration_category),COUNT(*)

FROM(SELECT f.title,
f.rental_duration,
c.name,NTILE(4) OVER(ORDER BY f.rental_duration) as rental_duration_category

FROM film_category fc
JOIN category c
ON fc.category_id=c.category_id
JOIN film f
ON fc.film_id=f.film_id
WHERE name IN('Animation','Children','Classic','Comedy','Music','Family')
) AS t

GROUP BY 1,2
ORDER BY 1,2;

QUESTION 4
/*
Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.
*/


//SOLUTION


SELECT DATE_PART('month',t1.rental_date) AS Rental_month,DATE_PART('year',t1.rental_date) AS Rental_year,t1.store_id,COUNT(*) AS Rental_counts
FROM (SELECT c.store_id,r.rental_date
FROM rental r
JOIN customer c 
ON r.customer_id=c.customer_id 
GROUP BY 1,2) t1
GROUP BY 1,2,3
ORDER BY 4 DESC;


