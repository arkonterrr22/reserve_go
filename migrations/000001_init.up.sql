CREATE SCHEMA vsklad;

CREATE TABLE vsklad.units(
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE vsklad.tags(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE vsklad.warehouses(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT
);

CREATE TABLE vsklad.nomenclature(
    id SERIAL PRIMARY KEY,
    owner_id UUID NOT NULL,
    unit_id VARCHAR(10) NOT NULL REFERENCES vsklad.units(id) ON DELETE RESTRICT,
    description TEXT,
    weight NUMERIC(6, 2),
    width NUMERIC(6, 2),
    height NUMERIC(6, 2),
    length NUMERIC(6, 2),
    name_full VARCHAR(255) NOT NULL,
    name_short VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE vsklad.nomenclature_warehouse(
    nomenclature_id INT REFERENCES vsklad.nomenclature(id) ON DELETE CASCADE,
    warehouse_id INT REFERENCES vsklad.warehouses(id) ON DELETE CASCADE,
    PRIMARY KEY (nomenclature_id, warehouse_id)
);

CREATE TABLE vsklad.nomenclature_tags(
    nomenclature_id INT REFERENCES vsklad.nomenclature(id) ON DELETE CASCADE,
    tag_id INT REFERENCES vsklad.tags(id) ON DELETE CASCADE,
    PRIMARY KEY (nomenclature_id, tag_id)
);

CREATE TABLE vsklad.dynamic(
    nomenclature_id INT REFERENCES vsklad.nomenclature(id) ON DELETE CASCADE PRIMARY KEY,
    price NUMERIC(10, 2),
    quantity_total INT,
    quantity_reserved INT,
    tax NUMERIC(1, 3)
);