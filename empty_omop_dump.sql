--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: empty_omop_cdm; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA empty_omop_cdm;


ALTER SCHEMA empty_omop_cdm OWNER TO postgres;

--
-- Name: empty_omop_results; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA empty_omop_results;


ALTER SCHEMA empty_omop_results OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: attribute_definition; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.attribute_definition (
    attribute_definition_id integer NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_description text,
    attribute_type_concept_id integer NOT NULL,
    attribute_syntax text
);


ALTER TABLE empty_omop_cdm.attribute_definition OWNER TO postgres;

--
-- Name: care_site; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.care_site (
    care_site_id bigint NOT NULL,
    care_site_name character varying(255),
    place_of_service_concept_id integer NOT NULL,
    location_id bigint,
    care_site_source_value character varying(50),
    place_of_service_source_value character varying(50)
);


ALTER TABLE empty_omop_cdm.care_site OWNER TO postgres;

--
-- Name: cdm_source; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.cdm_source (
    cdm_source_name character varying(255) NOT NULL,
    cdm_source_abbreviation character varying(25),
    cdm_holder character varying(255),
    source_description text,
    source_documentation_reference character varying(255),
    cdm_etl_reference character varying(255),
    source_release_date date,
    cdm_release_date date,
    cdm_version character varying(10),
    vocabulary_version character varying(20)
);


ALTER TABLE empty_omop_cdm.cdm_source OWNER TO postgres;

--
-- Name: concept; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.concept (
    concept_id integer NOT NULL,
    concept_name character varying(255) NOT NULL,
    domain_id character varying(20) NOT NULL,
    vocabulary_id character varying(20) NOT NULL,
    concept_class_id character varying(20) NOT NULL,
    standard_concept character varying(1),
    concept_code character varying(50) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);


ALTER TABLE empty_omop_cdm.concept OWNER TO postgres;

--
-- Name: concept_ancestor; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.concept_ancestor (
    ancestor_concept_id integer NOT NULL,
    descendant_concept_id integer NOT NULL,
    min_levels_of_separation integer NOT NULL,
    max_levels_of_separation integer NOT NULL
);


ALTER TABLE empty_omop_cdm.concept_ancestor OWNER TO postgres;

--
-- Name: concept_class; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.concept_class (
    concept_class_id character varying(20) NOT NULL,
    concept_class_name character varying(255) NOT NULL,
    concept_class_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.concept_class OWNER TO postgres;

--
-- Name: concept_relationship; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.concept_relationship (
    concept_id_1 integer NOT NULL,
    concept_id_2 integer NOT NULL,
    relationship_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);


ALTER TABLE empty_omop_cdm.concept_relationship OWNER TO postgres;

--
-- Name: concept_synonym; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.concept_synonym (
    concept_id integer NOT NULL,
    concept_synonym_name character varying(1000) NOT NULL,
    language_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.concept_synonym OWNER TO postgres;

--
-- Name: condition_era; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.condition_era (
    condition_era_id bigint NOT NULL,
    person_id bigint NOT NULL,
    condition_concept_id integer NOT NULL,
    condition_era_start_datetime timestamp without time zone NOT NULL,
    condition_era_end_datetime timestamp without time zone NOT NULL,
    condition_occurrence_count integer
);


ALTER TABLE empty_omop_cdm.condition_era OWNER TO postgres;

--
-- Name: condition_occurrence; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.condition_occurrence (
    condition_occurrence_id bigint NOT NULL,
    person_id bigint NOT NULL,
    condition_concept_id integer NOT NULL,
    condition_start_date date,
    condition_start_datetime timestamp without time zone NOT NULL,
    condition_end_date date,
    condition_end_datetime timestamp without time zone,
    condition_type_concept_id integer NOT NULL,
    condition_status_concept_id integer NOT NULL,
    stop_reason character varying(20),
    provider_id bigint,
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    condition_source_value character varying(50),
    condition_source_concept_id integer NOT NULL,
    condition_status_source_value character varying(50)
);


ALTER TABLE empty_omop_cdm.condition_occurrence OWNER TO postgres;

--
-- Name: cost; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.cost (
    cost_id bigint NOT NULL,
    person_id bigint NOT NULL,
    cost_event_id bigint NOT NULL,
    cost_event_field_concept_id integer NOT NULL,
    cost_concept_id integer NOT NULL,
    cost_type_concept_id integer NOT NULL,
    currency_concept_id integer NOT NULL,
    cost numeric,
    incurred_date date NOT NULL,
    billed_date date,
    paid_date date,
    revenue_code_concept_id integer NOT NULL,
    drg_concept_id integer NOT NULL,
    cost_source_value character varying(50),
    cost_source_concept_id integer NOT NULL,
    revenue_code_source_value character varying(50),
    drg_source_value character varying(3),
    payer_plan_period_id bigint
);


ALTER TABLE empty_omop_cdm.cost OWNER TO postgres;

--
-- Name: device_exposure; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.device_exposure (
    device_exposure_id bigint NOT NULL,
    person_id bigint NOT NULL,
    device_concept_id integer NOT NULL,
    device_exposure_start_date date,
    device_exposure_start_datetime timestamp without time zone NOT NULL,
    device_exposure_end_date date,
    device_exposure_end_datetime timestamp without time zone,
    device_type_concept_id integer NOT NULL,
    unique_device_id character varying(50),
    quantity integer,
    provider_id bigint,
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    device_source_value character varying(100),
    device_source_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.device_exposure OWNER TO postgres;

--
-- Name: domain; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.domain (
    domain_id character varying(20) NOT NULL,
    domain_name character varying(255) NOT NULL,
    domain_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.domain OWNER TO postgres;

--
-- Name: dose_era; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.dose_era (
    dose_era_id bigint NOT NULL,
    person_id bigint NOT NULL,
    drug_concept_id integer NOT NULL,
    unit_concept_id integer NOT NULL,
    dose_value numeric NOT NULL,
    dose_era_start_datetime timestamp without time zone NOT NULL,
    dose_era_end_datetime timestamp without time zone NOT NULL
);


ALTER TABLE empty_omop_cdm.dose_era OWNER TO postgres;

--
-- Name: drug_era; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.drug_era (
    drug_era_id bigint NOT NULL,
    person_id bigint NOT NULL,
    drug_concept_id integer NOT NULL,
    drug_era_start_datetime timestamp without time zone NOT NULL,
    drug_era_end_datetime timestamp without time zone NOT NULL,
    drug_exposure_count integer,
    gap_days integer
);


ALTER TABLE empty_omop_cdm.drug_era OWNER TO postgres;

--
-- Name: drug_exposure; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.drug_exposure (
    drug_exposure_id bigint NOT NULL,
    person_id bigint NOT NULL,
    drug_concept_id integer NOT NULL,
    drug_exposure_start_date date,
    drug_exposure_start_datetime timestamp without time zone NOT NULL,
    drug_exposure_end_date date,
    drug_exposure_end_datetime timestamp without time zone NOT NULL,
    verbatim_end_date date,
    drug_type_concept_id integer NOT NULL,
    stop_reason character varying(20),
    refills integer,
    quantity numeric,
    days_supply integer,
    sig text,
    route_concept_id integer NOT NULL,
    lot_number character varying(50),
    provider_id bigint,
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    drug_source_value character varying(50),
    drug_source_concept_id integer NOT NULL,
    route_source_value character varying(50),
    dose_unit_source_value character varying(50)
);


ALTER TABLE empty_omop_cdm.drug_exposure OWNER TO postgres;

--
-- Name: drug_strength; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.drug_strength (
    drug_concept_id integer NOT NULL,
    ingredient_concept_id integer NOT NULL,
    amount_value numeric,
    amount_unit_concept_id integer,
    numerator_value numeric,
    numerator_unit_concept_id integer,
    denominator_value numeric,
    denominator_unit_concept_id integer,
    box_size integer,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);


ALTER TABLE empty_omop_cdm.drug_strength OWNER TO postgres;

--
-- Name: fact_relationship; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.fact_relationship (
    domain_concept_id_1 integer NOT NULL,
    fact_id_1 bigint NOT NULL,
    domain_concept_id_2 integer NOT NULL,
    fact_id_2 bigint NOT NULL,
    relationship_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.fact_relationship OWNER TO postgres;

--
-- Name: location; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.location (
    location_id bigint NOT NULL,
    address_1 character varying(50),
    address_2 character varying(50),
    city character varying(50),
    state character varying(2),
    zip character varying(9),
    county character varying(20),
    country character varying(100),
    location_source_value character varying(50),
    latitude numeric,
    longitude numeric
);


ALTER TABLE empty_omop_cdm.location OWNER TO postgres;

--
-- Name: location_history; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.location_history (
    location_history_id bigint NOT NULL,
    location_id bigint NOT NULL,
    relationship_type_concept_id integer NOT NULL,
    domain_id character varying(50) NOT NULL,
    entity_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date
);


ALTER TABLE empty_omop_cdm.location_history OWNER TO postgres;

--
-- Name: measurement; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.measurement (
    measurement_id bigint NOT NULL,
    person_id bigint NOT NULL,
    measurement_concept_id integer NOT NULL,
    measurement_date date,
    measurement_datetime timestamp without time zone NOT NULL,
    measurement_time character varying(10),
    measurement_type_concept_id integer NOT NULL,
    operator_concept_id integer,
    value_as_number numeric,
    value_as_concept_id integer,
    unit_concept_id integer,
    range_low numeric,
    range_high numeric,
    provider_id bigint,
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    measurement_source_value character varying(50),
    measurement_source_concept_id integer NOT NULL,
    unit_source_value character varying(50),
    value_source_value character varying(50)
);


ALTER TABLE empty_omop_cdm.measurement OWNER TO postgres;

--
-- Name: metadata; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.metadata (
    metadata_concept_id integer NOT NULL,
    metadata_type_concept_id integer NOT NULL,
    name character varying(250) NOT NULL,
    value_as_string text,
    value_as_concept_id integer,
    metadata_date date,
    metadata_datetime timestamp without time zone
);


ALTER TABLE empty_omop_cdm.metadata OWNER TO postgres;

--
-- Name: note; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.note (
    note_id bigint NOT NULL,
    person_id bigint NOT NULL,
    note_event_id bigint,
    note_event_field_concept_id integer NOT NULL,
    note_date date,
    note_datetime timestamp without time zone NOT NULL,
    note_type_concept_id integer NOT NULL,
    note_class_concept_id integer NOT NULL,
    note_title character varying(250),
    note_text text,
    encoding_concept_id integer NOT NULL,
    language_concept_id integer NOT NULL,
    provider_id bigint,
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    note_source_value character varying(50)
);


ALTER TABLE empty_omop_cdm.note OWNER TO postgres;

--
-- Name: note_nlp; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.note_nlp (
    note_nlp_id bigint NOT NULL,
    note_id bigint NOT NULL,
    section_concept_id integer NOT NULL,
    snippet character varying(250),
    "offset" character varying(250),
    lexical_variant character varying(250) NOT NULL,
    note_nlp_concept_id integer NOT NULL,
    nlp_system character varying(250),
    nlp_date date NOT NULL,
    nlp_datetime timestamp without time zone,
    term_exists character varying(1),
    term_temporal character varying(50),
    term_modifiers character varying(2000),
    note_nlp_source_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.note_nlp OWNER TO postgres;

--
-- Name: observation; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.observation (
    observation_id bigint NOT NULL,
    person_id bigint NOT NULL,
    observation_concept_id integer NOT NULL,
    observation_date date,
    observation_datetime timestamp without time zone NOT NULL,
    observation_type_concept_id integer NOT NULL,
    value_as_number numeric,
    value_as_string character varying(60),
    value_as_concept_id integer,
    qualifier_concept_id integer,
    unit_concept_id integer,
    provider_id bigint,
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    observation_source_value character varying(50),
    observation_source_concept_id integer NOT NULL,
    unit_source_value character varying(50),
    qualifier_source_value character varying(50),
    observation_event_id bigint,
    obs_event_field_concept_id integer NOT NULL,
    value_as_datetime timestamp without time zone
);


ALTER TABLE empty_omop_cdm.observation OWNER TO postgres;

--
-- Name: observation_period; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.observation_period (
    observation_period_id bigint NOT NULL,
    person_id bigint NOT NULL,
    observation_period_start_date date NOT NULL,
    observation_period_end_date date NOT NULL,
    period_type_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.observation_period OWNER TO postgres;

--
-- Name: payer_plan_period; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.payer_plan_period (
    payer_plan_period_id bigint NOT NULL,
    person_id bigint NOT NULL,
    contract_person_id bigint,
    payer_plan_period_start_date date NOT NULL,
    payer_plan_period_end_date date NOT NULL,
    payer_concept_id integer NOT NULL,
    plan_concept_id integer NOT NULL,
    contract_concept_id integer NOT NULL,
    sponsor_concept_id integer NOT NULL,
    stop_reason_concept_id integer NOT NULL,
    payer_source_value character varying(50),
    payer_source_concept_id integer NOT NULL,
    plan_source_value character varying(50),
    plan_source_concept_id integer NOT NULL,
    contract_source_value character varying(50),
    contract_source_concept_id integer NOT NULL,
    sponsor_source_value character varying(50),
    sponsor_source_concept_id integer NOT NULL,
    family_source_value character varying(50),
    stop_reason_source_value character varying(50),
    stop_reason_source_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.payer_plan_period OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.person (
    person_id bigint NOT NULL,
    gender_concept_id integer NOT NULL,
    year_of_birth integer NOT NULL,
    month_of_birth integer,
    day_of_birth integer,
    birth_datetime timestamp without time zone,
    death_datetime timestamp without time zone,
    race_concept_id integer NOT NULL,
    ethnicity_concept_id integer NOT NULL,
    location_id bigint,
    provider_id bigint,
    care_site_id bigint,
    person_source_value character varying(50),
    gender_source_value character varying(50),
    gender_source_concept_id integer NOT NULL,
    race_source_value character varying(50),
    race_source_concept_id integer NOT NULL,
    ethnicity_source_value character varying(50),
    ethnicity_source_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.person OWNER TO postgres;

--
-- Name: procedure_occurrence; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.procedure_occurrence (
    procedure_occurrence_id bigint NOT NULL,
    person_id bigint NOT NULL,
    procedure_concept_id integer NOT NULL,
    procedure_date date,
    procedure_datetime timestamp without time zone NOT NULL,
    procedure_type_concept_id integer NOT NULL,
    modifier_concept_id integer NOT NULL,
    quantity integer,
    provider_id bigint,
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    procedure_source_value character varying(50),
    procedure_source_concept_id integer NOT NULL,
    modifier_source_value character varying(50)
);


ALTER TABLE empty_omop_cdm.procedure_occurrence OWNER TO postgres;

--
-- Name: provider; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.provider (
    provider_id bigint NOT NULL,
    provider_name character varying(255),
    npi character varying(20),
    dea character varying(20),
    specialty_concept_id integer NOT NULL,
    care_site_id bigint,
    year_of_birth integer,
    gender_concept_id integer NOT NULL,
    provider_source_value character varying(50),
    specialty_source_value character varying(50),
    specialty_source_concept_id integer,
    gender_source_value character varying(50),
    gender_source_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.provider OWNER TO postgres;

--
-- Name: relationship; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.relationship (
    relationship_id character varying(20) NOT NULL,
    relationship_name character varying(255) NOT NULL,
    is_hierarchical character varying(1) NOT NULL,
    defines_ancestry character varying(1) NOT NULL,
    reverse_relationship_id character varying(20) NOT NULL,
    relationship_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.relationship OWNER TO postgres;

--
-- Name: source_to_concept_map; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.source_to_concept_map (
    source_code character varying(50) NOT NULL,
    source_concept_id integer NOT NULL,
    source_vocabulary_id character varying(20) NOT NULL,
    source_code_description character varying(255),
    target_concept_id integer NOT NULL,
    target_vocabulary_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);


ALTER TABLE empty_omop_cdm.source_to_concept_map OWNER TO postgres;

--
-- Name: specimen; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.specimen (
    specimen_id bigint NOT NULL,
    person_id bigint NOT NULL,
    specimen_concept_id integer NOT NULL,
    specimen_type_concept_id integer NOT NULL,
    specimen_date date,
    specimen_datetime timestamp without time zone NOT NULL,
    quantity numeric,
    unit_concept_id integer,
    anatomic_site_concept_id integer NOT NULL,
    disease_status_concept_id integer NOT NULL,
    specimen_source_id character varying(50),
    specimen_source_value character varying(50),
    unit_source_value character varying(50),
    anatomic_site_source_value character varying(50),
    disease_status_source_value character varying(50)
);


ALTER TABLE empty_omop_cdm.specimen OWNER TO postgres;

--
-- Name: survey_conduct; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.survey_conduct (
    survey_conduct_id bigint NOT NULL,
    person_id bigint NOT NULL,
    survey_concept_id integer NOT NULL,
    survey_start_date date,
    survey_start_datetime timestamp without time zone,
    survey_end_date date,
    survey_end_datetime timestamp without time zone NOT NULL,
    provider_id bigint,
    assisted_concept_id integer NOT NULL,
    respondent_type_concept_id integer NOT NULL,
    timing_concept_id integer NOT NULL,
    collection_method_concept_id integer NOT NULL,
    assisted_source_value character varying(50),
    respondent_type_source_value character varying(100),
    timing_source_value character varying(100),
    collection_method_source_value character varying(100),
    survey_source_value character varying(100),
    survey_source_concept_id integer NOT NULL,
    survey_source_identifier character varying(100),
    validated_survey_concept_id integer NOT NULL,
    validated_survey_source_value character varying(100),
    survey_version_number character varying(20),
    visit_occurrence_id bigint,
    visit_detail_id bigint,
    response_visit_occurrence_id bigint
);


ALTER TABLE empty_omop_cdm.survey_conduct OWNER TO postgres;

--
-- Name: visit_detail; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.visit_detail (
    visit_detail_id bigint NOT NULL,
    person_id bigint NOT NULL,
    visit_detail_concept_id integer NOT NULL,
    visit_detail_start_date date,
    visit_detail_start_datetime timestamp without time zone NOT NULL,
    visit_detail_end_date date,
    visit_detail_end_datetime timestamp without time zone NOT NULL,
    visit_detail_type_concept_id integer NOT NULL,
    provider_id bigint,
    care_site_id bigint,
    discharge_to_concept_id integer NOT NULL,
    admitted_from_concept_id integer NOT NULL,
    admitted_from_source_value character varying(50),
    visit_detail_source_value character varying(50),
    visit_detail_source_concept_id integer NOT NULL,
    discharge_to_source_value character varying(50),
    preceding_visit_detail_id bigint,
    visit_detail_parent_id bigint,
    visit_occurrence_id bigint NOT NULL
);


ALTER TABLE empty_omop_cdm.visit_detail OWNER TO postgres;

--
-- Name: visit_occurrence; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.visit_occurrence (
    visit_occurrence_id bigint NOT NULL,
    person_id bigint NOT NULL,
    visit_concept_id integer NOT NULL,
    visit_start_date date,
    visit_start_datetime timestamp without time zone NOT NULL,
    visit_end_date date,
    visit_end_datetime timestamp without time zone NOT NULL,
    visit_type_concept_id integer NOT NULL,
    provider_id bigint,
    care_site_id bigint,
    visit_source_value character varying(50),
    visit_source_concept_id integer NOT NULL,
    admitted_from_concept_id integer NOT NULL,
    admitted_from_source_value character varying(50),
    discharge_to_source_value character varying(50),
    discharge_to_concept_id integer NOT NULL,
    preceding_visit_occurrence_id bigint
);


ALTER TABLE empty_omop_cdm.visit_occurrence OWNER TO postgres;

--
-- Name: vocabulary; Type: TABLE; Schema: empty_omop_cdm; Owner: postgres
--

CREATE TABLE empty_omop_cdm.vocabulary (
    vocabulary_id character varying(20) NOT NULL,
    vocabulary_name character varying(255) NOT NULL,
    vocabulary_reference character varying(255),
    vocabulary_version character varying(255),
    vocabulary_concept_id integer NOT NULL
);


ALTER TABLE empty_omop_cdm.vocabulary OWNER TO postgres;

--
-- Name: test_table; Type: TABLE; Schema: empty_omop_results; Owner: postgres
--

CREATE TABLE empty_omop_results.test_table (
    x integer
);


ALTER TABLE empty_omop_results.test_table OWNER TO postgres;

--
-- Data for Name: attribute_definition; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.attribute_definition (attribute_definition_id, attribute_name, attribute_description, attribute_type_concept_id, attribute_syntax) FROM stdin;
\.


--
-- Data for Name: care_site; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) FROM stdin;
\.


--
-- Data for Name: cdm_source; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.cdm_source (cdm_source_name, cdm_source_abbreviation, cdm_holder, source_description, source_documentation_reference, cdm_etl_reference, source_release_date, cdm_release_date, cdm_version, vocabulary_version) FROM stdin;
\.


--
-- Data for Name: concept; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) FROM stdin;
\.


--
-- Data for Name: concept_ancestor; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) FROM stdin;
\.


--
-- Data for Name: concept_class; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.concept_class (concept_class_id, concept_class_name, concept_class_concept_id) FROM stdin;
\.


--
-- Data for Name: concept_relationship; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) FROM stdin;
\.


--
-- Data for Name: concept_synonym; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.concept_synonym (concept_id, concept_synonym_name, language_concept_id) FROM stdin;
\.


--
-- Data for Name: condition_era; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.condition_era (condition_era_id, person_id, condition_concept_id, condition_era_start_datetime, condition_era_end_datetime, condition_occurrence_count) FROM stdin;
\.


--
-- Data for Name: condition_occurrence; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_start_datetime, condition_end_date, condition_end_datetime, condition_type_concept_id, condition_status_concept_id, stop_reason, provider_id, visit_occurrence_id, visit_detail_id, condition_source_value, condition_source_concept_id, condition_status_source_value) FROM stdin;
\.


--
-- Data for Name: cost; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.cost (cost_id, person_id, cost_event_id, cost_event_field_concept_id, cost_concept_id, cost_type_concept_id, currency_concept_id, cost, incurred_date, billed_date, paid_date, revenue_code_concept_id, drg_concept_id, cost_source_value, cost_source_concept_id, revenue_code_source_value, drg_source_value, payer_plan_period_id) FROM stdin;
\.


--
-- Data for Name: device_exposure; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.device_exposure (device_exposure_id, person_id, device_concept_id, device_exposure_start_date, device_exposure_start_datetime, device_exposure_end_date, device_exposure_end_datetime, device_type_concept_id, unique_device_id, quantity, provider_id, visit_occurrence_id, visit_detail_id, device_source_value, device_source_concept_id) FROM stdin;
\.


--
-- Data for Name: domain; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.domain (domain_id, domain_name, domain_concept_id) FROM stdin;
\.


--
-- Data for Name: dose_era; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.dose_era (dose_era_id, person_id, drug_concept_id, unit_concept_id, dose_value, dose_era_start_datetime, dose_era_end_datetime) FROM stdin;
\.


--
-- Data for Name: drug_era; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_datetime, drug_era_end_datetime, drug_exposure_count, gap_days) FROM stdin;
\.


--
-- Data for Name: drug_exposure; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_start_datetime, drug_exposure_end_date, drug_exposure_end_datetime, verbatim_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, lot_number, provider_id, visit_occurrence_id, visit_detail_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) FROM stdin;
\.


--
-- Data for Name: drug_strength; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.drug_strength (drug_concept_id, ingredient_concept_id, amount_value, amount_unit_concept_id, numerator_value, numerator_unit_concept_id, denominator_value, denominator_unit_concept_id, box_size, valid_start_date, valid_end_date, invalid_reason) FROM stdin;
\.


--
-- Data for Name: fact_relationship; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.fact_relationship (domain_concept_id_1, fact_id_1, domain_concept_id_2, fact_id_2, relationship_concept_id) FROM stdin;
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.location (location_id, address_1, address_2, city, state, zip, county, country, location_source_value, latitude, longitude) FROM stdin;
\.


--
-- Data for Name: location_history; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.location_history (location_history_id, location_id, relationship_type_concept_id, domain_id, entity_id, start_date, end_date) FROM stdin;
\.


--
-- Data for Name: measurement; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.measurement (measurement_id, person_id, measurement_concept_id, measurement_date, measurement_datetime, measurement_time, measurement_type_concept_id, operator_concept_id, value_as_number, value_as_concept_id, unit_concept_id, range_low, range_high, provider_id, visit_occurrence_id, visit_detail_id, measurement_source_value, measurement_source_concept_id, unit_source_value, value_source_value) FROM stdin;
\.


--
-- Data for Name: metadata; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.metadata (metadata_concept_id, metadata_type_concept_id, name, value_as_string, value_as_concept_id, metadata_date, metadata_datetime) FROM stdin;
\.


--
-- Data for Name: note; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.note (note_id, person_id, note_event_id, note_event_field_concept_id, note_date, note_datetime, note_type_concept_id, note_class_concept_id, note_title, note_text, encoding_concept_id, language_concept_id, provider_id, visit_occurrence_id, visit_detail_id, note_source_value) FROM stdin;
\.


--
-- Data for Name: note_nlp; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.note_nlp (note_nlp_id, note_id, section_concept_id, snippet, "offset", lexical_variant, note_nlp_concept_id, nlp_system, nlp_date, nlp_datetime, term_exists, term_temporal, term_modifiers, note_nlp_source_concept_id) FROM stdin;
\.


--
-- Data for Name: observation; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.observation (observation_id, person_id, observation_concept_id, observation_date, observation_datetime, observation_type_concept_id, value_as_number, value_as_string, value_as_concept_id, qualifier_concept_id, unit_concept_id, provider_id, visit_occurrence_id, visit_detail_id, observation_source_value, observation_source_concept_id, unit_source_value, qualifier_source_value, observation_event_id, obs_event_field_concept_id, value_as_datetime) FROM stdin;
\.


--
-- Data for Name: observation_period; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) FROM stdin;
\.


--
-- Data for Name: payer_plan_period; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.payer_plan_period (payer_plan_period_id, person_id, contract_person_id, payer_plan_period_start_date, payer_plan_period_end_date, payer_concept_id, plan_concept_id, contract_concept_id, sponsor_concept_id, stop_reason_concept_id, payer_source_value, payer_source_concept_id, plan_source_value, plan_source_concept_id, contract_source_value, contract_source_concept_id, sponsor_source_value, sponsor_source_concept_id, family_source_value, stop_reason_source_value, stop_reason_source_concept_id) FROM stdin;
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, birth_datetime, death_datetime, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) FROM stdin;
\.


--
-- Data for Name: procedure_occurrence; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.procedure_occurrence (procedure_occurrence_id, person_id, procedure_concept_id, procedure_date, procedure_datetime, procedure_type_concept_id, modifier_concept_id, quantity, provider_id, visit_occurrence_id, visit_detail_id, procedure_source_value, procedure_source_concept_id, modifier_source_value) FROM stdin;
\.


--
-- Data for Name: provider; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) FROM stdin;
\.


--
-- Data for Name: relationship; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.relationship (relationship_id, relationship_name, is_hierarchical, defines_ancestry, reverse_relationship_id, relationship_concept_id) FROM stdin;
\.


--
-- Data for Name: source_to_concept_map; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.source_to_concept_map (source_code, source_concept_id, source_vocabulary_id, source_code_description, target_concept_id, target_vocabulary_id, valid_start_date, valid_end_date, invalid_reason) FROM stdin;
\.


--
-- Data for Name: specimen; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.specimen (specimen_id, person_id, specimen_concept_id, specimen_type_concept_id, specimen_date, specimen_datetime, quantity, unit_concept_id, anatomic_site_concept_id, disease_status_concept_id, specimen_source_id, specimen_source_value, unit_source_value, anatomic_site_source_value, disease_status_source_value) FROM stdin;
\.


--
-- Data for Name: survey_conduct; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.survey_conduct (survey_conduct_id, person_id, survey_concept_id, survey_start_date, survey_start_datetime, survey_end_date, survey_end_datetime, provider_id, assisted_concept_id, respondent_type_concept_id, timing_concept_id, collection_method_concept_id, assisted_source_value, respondent_type_source_value, timing_source_value, collection_method_source_value, survey_source_value, survey_source_concept_id, survey_source_identifier, validated_survey_concept_id, validated_survey_source_value, survey_version_number, visit_occurrence_id, visit_detail_id, response_visit_occurrence_id) FROM stdin;
\.


--
-- Data for Name: visit_detail; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.visit_detail (visit_detail_id, person_id, visit_detail_concept_id, visit_detail_start_date, visit_detail_start_datetime, visit_detail_end_date, visit_detail_end_datetime, visit_detail_type_concept_id, provider_id, care_site_id, discharge_to_concept_id, admitted_from_concept_id, admitted_from_source_value, visit_detail_source_value, visit_detail_source_concept_id, discharge_to_source_value, preceding_visit_detail_id, visit_detail_parent_id, visit_occurrence_id) FROM stdin;
\.


--
-- Data for Name: visit_occurrence; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_datetime, visit_end_date, visit_end_datetime, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id, admitted_from_concept_id, admitted_from_source_value, discharge_to_source_value, discharge_to_concept_id, preceding_visit_occurrence_id) FROM stdin;
\.


--
-- Data for Name: vocabulary; Type: TABLE DATA; Schema: empty_omop_cdm; Owner: postgres
--

COPY empty_omop_cdm.vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) FROM stdin;
\.


--
-- Data for Name: test_table; Type: TABLE DATA; Schema: empty_omop_results; Owner: postgres
--

COPY empty_omop_results.test_table (x) FROM stdin;
\.


--
-- PostgreSQL database dump complete
--

