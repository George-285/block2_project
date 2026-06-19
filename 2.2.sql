DROP TABLE IF EXISTS links;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id      INTEGER PRIMARY KEY,
    new_id  INTEGER
);

CREATE TABLE links (
    id1 INTEGER,
    id2 INTEGER
);

-- users: id это исходный идентификатор, new_id это следующий шаг в цепочке
-- (если изменений нет, new_id = id)
INSERT INTO users (id, new_id) VALUES
    (1, 2),
    (2, 3),
    (3, 5),
    (4, 4),
    (5, 5),
    (7, 8),
    (8, 8);

-- links: явно фиксируем каждую связь в цепочке смены id
INSERT INTO links (id1, id2) VALUES
    (1, 2),
    (2, 3),
    (3, 5),
    (7, 8);



   


-- рекурсивный подход
WITH RECURSIVE edges AS (
    SELECT id1 AS u, id2 AS v FROM links
    UNION
    SELECT id2, id1 FROM links
),

reachable AS (
    SELECT id AS start_node, id AS current_node, ARRAY[id] AS visited
    FROM (SELECT DISTINCT id FROM users) AS all_ids

    UNION ALL

    SELECT r.start_node, e.v, r.visited || e.v
    FROM reachable r
    JOIN edges e ON r.current_node = e.u
    WHERE e.v <> ALL(r.visited)
),

find_min AS (
	SELECT start_node, MIN(current_node) AS final_id
	FROM reachable
	GROUP BY start_node
	ORDER BY start_node
)

-- для просмотра временных таблиц
-- SELECT * FROM find_min
-- ORDER BY start_node;

UPDATE users
SET new_id = final_id
FROM find_min
WHERE users.id = find_min.start_node;

SELECT * FROM users;










DROP TABLE IF EXISTS links;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id      INTEGER PRIMARY KEY,
    new_id  INTEGER
);

CREATE TABLE links (
    id1 INTEGER,
    id2 INTEGER
);

-- users: id это исходный идентификатор, new_id это следующий шаг в цепочке
-- (если изменений нет, new_id = id)
INSERT INTO users (id, new_id) VALUES
    (1, 2),
    (2, 3),
    (3, 5),
    (4, 4),
    (5, 5),
    (7, 8),
    (8, 8);

-- links: явно фиксируем каждую связь в цепочке смены id
INSERT INTO links (id1, id2) VALUES
    (1, 2),
    (2, 3),
    (3, 5),
    (7, 8);



-- не рекурсивный
with edges as (
    select id1 as u, id2 as v from links
    union
    select id2, id1 from links
),
united_nodes as (
    select id as node, id as reachable
    from users

    union

    select u, v from edges

    union

    select e1.u, e2.v
    from edges e1
    join edges e2 on e1.v = e2.u

    union

    select e1.u, e3.v
    from edges e1
    join edges e2 on e1.v = e2.u
    join edges e3 on e2.v = e3.u
),

find_min as (
    select node, min(reachable) as root_id
    from united_nodes
    group by node
)

update users
set new_id = root_id
from find_min
where users.id = find_min.node;

select * from users order by id;