-- database Schema
-- Create Users Table
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

-- Create Recipes Table
CREATE TABLE Recipes (
    recipe_id INTEGER PRIMARY KEY,
    recipe_name TEXT NOT NULL,
    instructions TEXT,
    cook_time INTEGER
);

-- Create Ingredients Table
CREATE TABLE Ingredients (
    ingredient_id INTEGER PRIMARY KEY,
    ingredient_name TEXT NOT NULL,
    unit TEXT
);

-- Create Recipe_Ingredients Table
CREATE TABLE Recipe_Ingredients (
    recipe_id INTEGER,
    ingredient_id INTEGER,
    quantity REAL,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id)
);

-- Create Meal_Plans Table
CREATE TABLE Meal_Plans (
    meal_plan_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Meals Table
CREATE TABLE Meals (
    meal_id INTEGER PRIMARY KEY,
    meal_plan_id INTEGER,
    recipe_id INTEGER,
    meal_date DATE,
    meal_type TEXT CHECK(meal_type IN ('Breakfast', 'Lunch', 'Dinner')),
    FOREIGN KEY (meal_plan_id) REFERENCES Meal_Plans(meal_plan_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id)
);

-- Data Insertion
-- Insert data into Users Table
INSERT INTO Users (username, email, password)
VALUES 
    ('johndoe', 'john@example.com', 'password123'),
    ('janedoe', 'jane@example.com', 'password456'),
    ('bobsmith', 'bob@example.com', 'password789'),
    ('alicesmith', 'alice@example.com', 'password1011');

-- Insert data into Recipes Table
INSERT INTO Recipes (recipe_name, instructions, cook_time)
VALUES 
    ('Pasta', 'Boil water, cook pasta.', 20),
    ('Salad', 'Chop vegetables and mix.', 10),
    ('Omelette', 'Beat eggs and cook in pan.', 15),
    ('Pizza', 'Prepare dough, add toppings, bake.', 30);

-- Insert data into Ingredients Table
INSERT INTO Ingredients (ingredient_name, unit)
VALUES 
    ('Pasta', 'grams'),
    ('Tomato Sauce', 'cups'),
    ('Lettuce', 'leaves'),
    ('Eggs', 'units');

-- Insert data into Recipe_Ingredients Table
INSERT INTO Recipe_Ingredients (recipe_id, ingredient_id, quantity)
VALUES 
    (1, 1, 200),  -- Pasta Recipe needs 200 grams of pasta
    (1, 2, 1),    -- Pasta Recipe needs 1 cup of tomato sauce
    (2, 3, 5),    -- Salad Recipe needs 5 leaves of lettuce
    (3, 4, 3),    -- Omelette Recipe needs 3 eggs
    (4, 1, 100);  -- Pizza Recipe needs 100 grams of pasta dough

-- Insert data into Meal_Plans Table
INSERT INTO Meal_Plans (user_id, start_date, end_date)
VALUES 
    (1, '2024-01-01', '2024-01-07'),
    (2, '2024-01-08', '2024-01-14');

-- Insert data into Meals Table
INSERT INTO Meals (meal_plan_id, recipe_id, meal_date, meal_type)
VALUES 
    (1, 1, '2024-01-02', 'Dinner'),  -- Pasta for Dinner
    (1, 2, '2024-01-03', 'Lunch'),   -- Salad for Lunch
    (1, 3, '2024-01-04', 'Breakfast'),  -- Omelette for Breakfast
    (2, 4, '2024-01-09', 'Dinner');  -- Pizza for Dinner

--Queries
-- 1. What meals are planned for the week (User ID: 1)?
SELECT m.meal_date, r.recipe_name, m.meal_type
FROM Meals m
JOIN Recipes r ON m.recipe_id = r.recipe_id
JOIN Meal_Plans mp ON m.meal_plan_id = mp.meal_plan_id
WHERE mp.user_id = 1;

-- 2. What ingredients are required for the "Pasta" recipe?
SELECT i.ingredient_name, ri.quantity, i.unit
FROM Recipe_Ingredients ri
JOIN Ingredients i ON ri.ingredient_id = i.ingredient_id
JOIN Recipes r ON ri.recipe_id = r.recipe_id
WHERE r.recipe_name = 'Pasta';

-- 3. What are the recipes in Meal Plan 1?
SELECT r.recipe_name
FROM Meals m
JOIN Recipes r ON m.recipe_id = r.recipe_id
WHERE m.meal_plan_id = 1;

--4. What are the total ingredients needed for the week for User ID 1?
SELECT i.ingredient_name, SUM(ri.quantity) AS total_quantity, i.unit
FROM Meals m
JOIN Meal_Plans mp ON m.meal_plan_id = mp.meal_plan_id
JOIN Recipe_Ingredients ri ON m.recipe_id = ri.recipe_id
JOIN Ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE mp.user_id = 1
GROUP BY i.ingredient_name, i.unit;

--5. What is the total number of meals planned for User ID 2 in January 2024?

SELECT COUNT(m.meal_id) AS total_meals
FROM Meals m
JOIN Meal_Plans mp ON m.meal_plan_id = mp.meal_plan_id
WHERE mp.user_id = 2 AND strftime('%Y-%m', m.meal_date) = '2024-01';

-- Query Results:
--1. What meals are planned for the week (User ID: 1)?
2024-01-02 | Pasta     | Dinner
2024-01-03 | Salad     | Lunch
2024-01-04 | Omelette  | Breakfast

-- 2. What ingredients are required for the "Pasta" recipe?
Pasta         | 200.00 | grams
Tomato Sauce  | 1.00   | cups

--3. What are the recipes in Meal Plan 1?
Pasta
Salad
Omelette

--4. What are the total ingredients needed for the week for User ID 1?
Pasta         | 200.00 | grams
Tomato Sauce  | 1.00   | cups
Lettuce       | 5.00   | leaves
Eggs          | 3.00   | units

--5. What is the total number of meals planned for User ID 2 in January 2024?
Total Meals: 1