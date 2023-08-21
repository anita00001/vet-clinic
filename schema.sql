/* Database schema to keep the structure of entire database. */
-- Table for animals
CREATE TABLE animals (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY, 
    name varchar(100), 
    date_of_birth date, 
    escape_attempts int, 
    neutered boolean, 
    weight_kg decimal 
);

ALTER TABLE animals
ADD COLUMN species VARCHAR(20);

------------------------------------------------------------
------------------------------------------------------------

-- Table for owners
CREATE TABLE owners (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY, 
    full_name varchar(100), 
    age int
);

-- Table for species
CREATE TABLE species (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY, 
    name varchar(100)
);

-- Delete column species from animals table
ALTER TABLE animals
DROP COLUMN species;

-- Add columns species_id and owner_id to animals table
ALTER TABLE animals
ADD COLUMN species_id INTEGER,
ADD COLUMN owner_id INTEGER;

-- Add foreign keys to animals table
ALTER TABLE animals
ADD FOREIGN KEY(species_id) REFERENCES species(id),
ADD FOREIGN KEY (owner_id) REFERENCES owners (id);

--------------------------------------------------------------
--------------------------------------------------------------

-- Table for vets
CREATE TABLE vets (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY, 
    name varchar(100),
    age int,
    date_of_graduation date
);

-- Table for specializations
CREATE TABLE specializations (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY, 
    vets_id INTEGER,
    species_id INTEGER,
    FOREIGN KEY (vets_id) REFERENCES vets (id),
    FOREIGN KEY (species_id) REFERENCES species (id)
);

-- Table for visits
CREATE TABLE visits (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY, 
    animals_id INTEGER,
    vets_id INTEGER,
    date_of_visit date,
    FOREIGN KEY (animals_id) REFERENCES animals (id),
    FOREIGN KEY (vets_id) REFERENCES vets (id)
);


------------------------------------------------------------------------
------------------------------------------------------------------------
---- Performance audit
-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- decreased the execution time of the first query
CREATE INDEX animal_id_index ON visits(animal_id);
