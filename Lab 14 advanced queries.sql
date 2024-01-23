use sakila;

-- List each pair of actors that have worked together:
SELECT DISTINCT A1.actor_id AS actor1_id, A1.first_name AS actor1_first_name, A1.last_name AS actor1_last_name,
                A2.actor_id AS actor2_id, A2.first_name AS actor2_first_name, A2.last_name AS actor2_last_name
FROM actor AS A1
JOIN film_actor AS FA1 ON A1.actor_id = FA1.actor_id
JOIN film_actor AS FA2 ON FA1.film_id = FA2.film_id AND A1.actor_id < FA2.actor_id
JOIN actor AS A2 ON FA2.actor_id = A2.actor_id;


-- For each film, list the actor that as acted in more films
WITH ActorFilmCounts AS (
    SELECT actor_id, film_id, COUNT(*) AS film_count
    FROM film_actor
    GROUP BY actor_id, film_id
)
SELECT afc.actor_id, a.first_name, a.last_name, afc.film_id, afc.film_count
FROM ActorFilmCounts AS afc
JOIN (
    SELECT film_id, MAX(film_count) AS max_count
    FROM ActorFilmCounts
    GROUP BY film_id
) max_counts ON afc.film_id = max_counts.film_id AND afc.film_count = max_counts.max_count
JOIN actor AS a ON afc.actor_id = a.actor_id;
