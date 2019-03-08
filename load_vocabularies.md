Load vocabularies
================
Sigfried Gold
March 7, 2019

PostgreSQL code for loading these is provided in the CDM repository [OMOP CDM vocabulary load - PostgreSQL.sql](https://github.com/OHDSI/CommonDataModel/blob/master/PostgreSQL/VocabImport/OMOP%20CDM%20vocabulary%20load%20-%20PostgreSQL.sql), but the paths are hard coded (for Windows). The [version in this repository](./CommonDataModel/PostgreSQL/VocabImport/OMOP%20CDM%20vocabulary%20load%20-%20PostgreSQL.sql) has been edited to reference the current directory. That means, in order to use these commands, your current directory must be where your Athena files are. So, for instance:

``` sql
empty_omop=# \q
```

``` sh
➜ cd athena 
➜ ls
CONCEPT_ANCESTOR.csv  CONCEPT_CPT4.csv    CONCEPT_RELATIONSHIP.csv  cpt4.jar
cpt.sh                DRUG_STRENGTH.csv   RELATIONSHIP.csv          CONCEPT_CLASS.csv
CONCEPT.csv           CONCEPT_SYNONYM.csv cpt.bat                   DOMAIN.csv  readme.txt
VOCABULARY.csv
➜ psql
```

``` sql
empty_omop=# \i ../CommonDataModel/PostgreSQL/VocabImport/OMOP\ CDM\ vocabulary\ load\ -\ PostgreSQL.sql
```

With these files you might consider manually copying and pasting each copy command one at a time to make sure everything goes smoothly.

To wit, I encountered a large number of errors in CONCEPT.csv:

    empty_omop=# \COPY CONCEPT FROM './CONCEPT.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
    ERROR:  invalid byte sequence for encoding "UTF8": 0xc3 0x3f
    CONTEXT:  COPY concept, line 47670
    Time: 1937.398 ms
    empty_omop=# \COPY CONCEPT FROM './CONCEPT.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
    ERROR:  invalid byte sequence for encoding "UTF8": 0xc3 0x3f
    CONTEXT:  COPY concept, line 236449
    Time: 2603.282 ms
    ...
    empty_omop=# \COPY CONCEPT FROM './CONCEPT.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'
    ERROR:  value too long for type character varying(255)
    CONTEXT:  COPY concept, line 3812815, column concept_name: "In your entire life, have you had at least 1 drink of any kind of alcohol, not counting small tastes..."
    Time: 23139.087 ms
    ...

For each of these, I removed the problematic characters from the line and tried again. This is **not** the recommended approach. I don't know what the recommended approach is, so I spent way too long repeating this kludge over and over.

I will not save a dump of the database after loading vocabulary files because 1) it would be big, and 2) it might violate licensing restrictions.

After vocabularies are loaded, you can [load clinical data](./load_data.md).
