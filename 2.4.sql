DROP TABLE IF EXISTS items;

CREATE TABLE items (
    id       INTEGER PRIMARY KEY,
    name     TEXT,
    category TEXT
);

INSERT INTO items (id, name, category) VALUES
    (1,  'Гитара',   'Музыка'),
    (2,  'Гитара',   'Музыка'),    -- дубль с 1
    (3,  'Гитара',   'Музыка'),    -- дубль с 1 и 2
    (4,  'Пианино',  'Музыка'),
    (5,  'Пианино',  'Музыка'),    -- дубль с 4
    (6,  'Гитара',   'Спорт'),     -- то же имя, другая категория
    (7,  'Мяч',      'Спорт'),
    (8,  'Мяч',      'Спорт'),     -- дубль с 7
    (9,  'Мяч',      'Игрушки'),   -- то же имя, другая категория
    (10, 'Скрипка',  'Музыка');    -- уникальная запись

    
SELECT 
    a.id AS id1,
    b.id AS id2,
    a.category
FROM items a
JOIN items b 
    ON a.name = b.name 
    AND a.category = b.category 
    AND a.id < b.id
ORDER BY a.id, b.id;