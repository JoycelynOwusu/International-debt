-- creating famous_people table --
CREATE TABLE famous_people(id INT PRIMARY KEY AUTO_INCREMENT, name TEXT, age INT, gender TEXT, occupation TEXT, 
							industry_id INT, marital_status TEXT, spouse_id INT, country_of_origin TEXT);

-- entering records --
INSERT INTO famous_people(name, age, gender, occupation, industry_id, marital_status, spouse_id, country_of_origin) 
						VALUES ("Bill Gates", 68, "Male", "Inventor", 5, "Divorced", 5, "USA"),
                        ("OB Amponsah", 40, "Male", "Comedian", 1, "Single", NULL, "Ghana"), 
                        ("Asamoah Gyan", 43, "Male", "Footballer", 2, "Divorced", 6, "Ghana"),
                        ("Elon Musk", 50, "Male", "Inventor", 5, "Divorced", 7, "USA"),
                        ("Frank Opoku Mensah", 30, "Male", "Lecturer", 4, "Married", 4, "Ghana"),
                        ("Joycelyn Owusu", 19, "Female", "Data Analyst", 5, "Married", 8, "Germany"),
                        ("Lebron James", 32, "Male", "Basketball Player", 2, "Married", 3, "USA"),
                        ("Sedinam Hadzi", 23, "Female", "Singer", 1, "Single", NULL, "UK"),
                        ("Portia Gabor", 40, "Female", "Presenter", 3, "Married", 2, "Togo"),
                        ("Gifty Anti", 41, "Female", "Journalist", 3, "Married", 1, "Ghana");


-- creating industries table --
CREATE TABLE industries (id INT PRIMARY KEY AUTO_INCREMENT, name TEXT, ranking INT);

-- entering records --
INSERT INTO industries (name, ranking) VALUES ("Entertainment", 3), ("Sports", 4), 
												("Media", 5), ("Education", 1), ("Technology", 2);
                                                
			
-- creating spouses table --
CREATE TABLE spouses (id INT PRIMARY KEY AUTO_INCREMENT, name TEXT);

-- entering records --
INSERT INTO spouses (name) VALUES ("Joseph Anti"), ("Collins Mensah"), ("Savanna James"), ("Francess Opoku Mensah"), 
									("Melinda Gates"), ("Abena Gyampo"), ("Hilda Musk"), ("Frederick Owusu");
                                    
-- queries --

-- famous person and spouse/ex-spouse --
SELECT f.name, s.name AS spouse
FROM famous_people AS f
LEFT JOIN spouses AS s
ON f.spouse_id = s.id;

-- famous person and work info --
SELECT f.name, occupation, i.name AS industry, i.ranking AS industry_ranking
FROM famous_people AS f
JOIN industries AS i
ON f.industry_id = i.id;

-- famous females between ages 25 and 45 --
SELECT name, age
FROM famous_people
WHERE gender = "Female"
	AND age BETWEEN 25 AND 45;

-- unmarried persons --
SELECT name 
FROM famous_people
WHERE spouse_id IS NULL
	AND marital_status = "Single";
    
-- filter on spouse name --
SELECT f.name, age, gender, s.name AS spouse, i.name AS industry
FROM famous_people AS f
JOIN industries AS i
ON f.industry_id = i.id
JOIN spouses AS s
ON s.id = f.spouse_id
WHERE s.name LIKE "F%";

-- average age per industry --
SELECT i.name, AVG(age) as avg_age
FROM famous_people
JOIN industries as i
ON famous_people.industry_id = i.id
GROUP BY i.name
ORDER BY avg_age;





/* Joycelyn
Derllene
David
Sedinam
Michael */