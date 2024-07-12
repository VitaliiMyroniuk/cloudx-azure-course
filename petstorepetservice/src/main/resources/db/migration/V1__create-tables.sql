CREATE TABLE category
(
    id   bigserial   NOT NULL PRIMARY KEY,
    name varchar(64) NOT NULL UNIQUE
);

CREATE TABLE tag
(
    id   bigserial   NOT NULL PRIMARY KEY,
    name varchar(64) NOT NULL UNIQUE
);

CREATE TABLE pet
(
    id          bigserial    NOT NULL PRIMARY KEY,
    name        varchar(64)  NOT NULL UNIQUE,
    category_id bigserial    NOT NULL,
    photoURL    varchar(255) NOT NULL,
    status      varchar(64)  NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category (id)
);

CREATE TABLE pet_tag
(
    pet_id bigserial NOT NULL REFERENCES pet (id) ON DELETE CASCADE,
    tag_id bigserial NOT NULL REFERENCES tag (id) ON DELETE CASCADE,
    CONSTRAINT pet_tag_pkey PRIMARY KEY (pet_id, tag_id)
);
