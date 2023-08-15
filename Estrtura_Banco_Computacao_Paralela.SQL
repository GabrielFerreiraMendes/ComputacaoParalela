-- Database: study

-- DROP DATABASE IF EXISTS study;

CREATE DATABASE study
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

/*********************************************************************/

-- SCHEMA: Parallel_Programming

-- DROP SCHEMA IF EXISTS "Parallel_Programming" ;

CREATE SCHEMA IF NOT EXISTS "Parallel_Programming"
    AUTHORIZATION postgres;

/*********************************************************************/

-- Table: Parallel_Programming.SalaryInfo

-- DROP TABLE IF EXISTS "Parallel_Programming"."SalaryInfo";

CREATE TABLE IF NOT EXISTS "Parallel_Programming"."SalaryInfo"
(
    "COMPANY_RATING" double precision,
    "COMPANY_NAME" "char",
    "JOB_TITLE" "char",
    "SALARY" money,
    "SALARIES_REPORTED" integer,
    "LOCATION" "char"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "Parallel_Programming"."SalaryInfo"
    OWNER to postgres;

