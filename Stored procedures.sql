-- Write queries, stored procedures to answer the following questions:

-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure. Use the following query:

select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
  -- Now keep working on the previous stored procedure to make it more dynamic. 
  -- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
  -- For eg., it could be action, animation, children, classics, etc.

delimiter //
create procedure most_popular_cat (in param1 varchar(10))
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
 
end;
//
delimiter ;

call most_popular_cat("Classics");

-- Write a query to check the number of movies released in each movie category. 
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

SELECT
    cat.name AS category_name,
    COUNT(f.film_id) AS film_count
FROM
    category cat
LEFT JOIN
    film_category fc ON cat.category_id = fc.category_id
LEFT JOIN
    film f ON fc.film_id = f.film_id
GROUP BY
    cat.category_id, cat.name
ORDER BY
    cat.name;
    
DELIMITER //

CREATE PROCEDURE Release_cat_greater(x INT)
BEGIN
    SELECT
        cat.name AS category_name,
        COUNT(f.film_id) AS film_count
    FROM
        category cat
    LEFT JOIN
        film_category fc ON cat.category_id = fc.category_id
    LEFT JOIN
        film f ON fc.film_id = f.film_id
    GROUP BY
        cat.category_id, cat.name
    HAVING
        film_count > x
    ORDER BY
        cat.name;
END //

DELIMITER ;

CALL Release_cat_greater(60);
