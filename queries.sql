/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name like '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name,date_of_birth FROM animals WHERE date_of_birth > '2015-12-31' and date_of_birth < '2020-01-01';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name,neutered,escape_attempts FROM animals WHERE neutered = true and escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT name,date_of_birth FROM animals WHERE name = 'Agumon' or name = 'Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name,escape_attempts,weight_kg FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg >= 10.4 and weight_kg <= 17.3;

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

----------------------------- Transaction -----------------------------------
BEGIN;
-- set species to 'unspecified' for all animals
UPDATE animals
SET species = 'unspecified';
select * from animals;
-- rollback changes
ROLLBACK;
select * from animals;

----------------------------- Transaction -----------------------------------
BEGIN;
-- setting the species column to digimon for all animals that have a name ending in mon.
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
-- setting the species column to pokemon for all animals that don't have species already set.
UPDATE animals
SET species = 'pokemon'
WHERE species is NULL;
SELECT * FROM animals;
-- commit changes
COMMIT;

----------------------------- Transaction -----------------------------------
BEGIN;
-- delete all rows of table animals
DELETE FROM animals;
SELECT * FROM animals
-- rollback changes
ROLLBACK;
SELECT * FROM animals;

----------------------------- Transaction -----------------------------------
BEGIN;
-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SELECT * FROM animals;
-- Create a savepoint for the transaction.
SAVEPOINT sp1;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals
SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
-- Rollback to the savepoint.
ROLLBACK TO SAVEPOINT sp1;
SELECT * FROM animals;

-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals
SET weight_kg = weight_kg * (-1)
WHERE weight_kg < 0;
SELECT * FROM animals;

-- Commit the transaction.
COMMIT;

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- How many animals are there?
select count(*) as number_of_animals from animals;

-- How many animals have never tried to escape?
select count(*) as animals_with_zero_escape_attempts from animals where escape_attempts = 0;

-- What is the average weight of animals?
select avg(weight_kg) as average_weight from animals;

-- Who escapes the most, neutered or not neutered animals?
select neutered, count(*) as neutered_count from animals
group by neutered
order by count(*) desc LIMIT 1;

-- What is the minimum and maximum weight of each type of animal?
select species, min(weight_kg) as min_weight,
max(weight_kg) as max_weight from animals
group by species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
select species, avg(escape_attempts) as average_escape_attempts from animals
where date_of_birth between '1990-01-01' and '2000-12-31'
group by species;