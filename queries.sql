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

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- What animals belong to Melody Pond?
SELECT owners.full_name AS owner, animals.name AS animal
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name AS animal_name, species.name AS species_name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT 
    owners.full_name AS owner_name,
    STRING_AGG(animals.name, ', ') AS animals_owned
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.id, owners.full_name;

-- How many animals are there per species?
SELECT species.name AS species_name, COUNT(animals.id) AS number_of_animals
FROM species
LEFT JOIN animals ON species.id = animals.species_id
GROUP BY species.id, species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT owners.full_name AS owner_name, species.name AS species_name, animals.name AS animal_name
FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT owners.full_name AS owner_name, animals.name AS animal_name, animals.escape_attempts AS escape_attempts
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT 
    owners.full_name AS owner_name,
    animals.escape_attempts,
    animals.name AS animal_name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester'
    AND animals.escape_attempts = 0
UNION
SELECT 'Dean Winchester' AS owner_name, 0 AS escape_attempts, NULL AS animal_name
LIMIT 1;

-- Who owns the most animals?
SELECT owners.full_name AS owner_name, COUNT(animals.id) AS number_of_animals
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.id, owners.full_name
ORDER BY COUNT(animals.id) DESC
LIMIT 1;

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Who was the last animal seen by William Tatcher?
SELECT vt.name AS vet_name, a.name AS last_seen_animal
FROM visits v
JOIN animals a ON v.animals_id = a.id
JOIN vets vt ON v.vets_id = vt.id
WHERE vt.name = 'Vet William Tatcher'
ORDER BY v.date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT
    vt.name AS vet_name,
    string_agg(a.name, ', ') AS animal_names,
    COUNT(DISTINCT v.animals_id) AS number_of_different_animals_seen
FROM visits v
JOIN animals a ON v.animals_id = a.id
JOIN vets vt ON v.vets_id = vt.id
WHERE vt.name = 'Vet Stephanie Mendez'
GROUP BY vt.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT
    v.name AS vet_name,
    string_agg(s.name, ',') AS specialty_name
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vets_id
LEFT JOIN species s ON sp.species_id = s.id
group by v.name;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT
    vt.name AS vet_name,
    a.name AS animal_name,
    v.date_of_visit
FROM visits v
JOIN animals a ON v.animals_id = a.id
JOIN vets vt ON v.vets_id = vt.id
WHERE vt.name = 'Vet Stephanie Mendez'
  AND v.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT
    a.name AS animal_name,
    MAX(num_visits) AS num_visits,
    STRING_AGG(vet_info, ', ') AS visited_vets
FROM animals a
LEFT JOIN (
    SELECT
        v.animals_id AS animal_id,
        vt.name || ' (' || COUNT(v.id) || ')' AS vet_info,
        COUNT(v.id) AS num_visits
    FROM visits v
    JOIN vets vt ON v.vets_id = vt.id
    GROUP BY v.animals_id, vt.name
) vet_counts ON a.id = vet_counts.animal_id
GROUP BY a.name
ORDER BY num_visits DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT
    vt.name AS vet_name,
    a.name AS animal_name,
    v.date_of_visit
FROM visits v
JOIN animals a ON v.animals_id = a.id
JOIN vets vt ON v.vets_id = vt.id
WHERE vt.name = 'Vet Maisy Smith'
ORDER BY v.date_of_visit ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
    v.date_of_visit,
    a.name AS animal_name,
    a.date_of_birth AS birth,
    s.name As species,
    a.escape_attempts,
    a.neutered,
    a.weight_kg,
    o.full_name AS owner,
    o.age AS owner_age,
    vt.name AS vet_name,
    vt.age AS vet_age,
    vt.date_of_graduation AS vet_graduation
FROM visits v
JOIN animals a ON v.animals_id = a.id
JOIN vets vt ON v.vets_id = vt.id
LEFT JOIN species s ON a.species_id = s.id
LEFT JOIN owners o ON a.owner_id = o.id
ORDER BY v.date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS num_visits_without_specialization
FROM visits v
JOIN animals a ON v.animals_id = a.id
JOIN vets vt ON v.vets_id = vt.id
LEFT JOIN specializations sp ON vt.id = sp.vets_id AND a.species_id = sp.species_id
WHERE sp.id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT
    v.name AS vet_name,
    s.name AS animal_species,
    count(*) AS num_visits
FROM visits AS vis
JOIN animals AS a ON vis.animals_id = a.id
JOIN vets AS v ON vis.vets_id = v.id
JOIN species AS s ON a.species_id = s.id
WHERE v.name = 'Vet Maisy Smith'
GROUP BY s.name, v.name
ORDER BY num_visits DESC
LIMIT 1;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- Performance audit
explain analyze SELECT COUNT(*) FROM visits where animals_id = 4;

explain analyze SELECT * FROM visits where vets_id = 2;

explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';
