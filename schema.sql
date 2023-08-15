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