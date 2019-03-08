Setting up an empty OMOP CDM
================
Sigfried Gold
February 28, 2019

For a PostgreSQL database
-------------------------

### CDM and vocabulary files

These instructions assume you already have postgres DDL and related files from <https://github.com/OHDSI/CommonDataModel>. We only need files from the PostgreSQL directory:

``` bash
./CommonDataModel/PostgreSQL/OMOP CDM postgresql constraints.txt
./CommonDataModel/PostgreSQL/OMOP CDM postgresql ddl.txt
./CommonDataModel/PostgreSQL/OMOP CDM postgresql pk indexes.txt
./CommonDataModel/PostgreSQL/README.md
./CommonDataModel/PostgreSQL/VocabImport
./CommonDataModel/PostgreSQL/VocabImport/OMOP CDM vocabulary load - PostgreSQL.sql
./CommonDataModel/PostgreSQL/OMOP CDM Results postgresql ddl.txt
```

Assumes you already have vocabulary files from Athena (and have already generated CPT4 concepts if necessary):

``` bash
./athena/CONCEPT_ANCESTOR.csv
./athena/CONCEPT_CLASS.csv
./athena/CONCEPT_CPT4.csv
./athena/CONCEPT.csv
./athena/CONCEPT_RELATIONSHIP.csv
./athena/CONCEPT_SYNONYM.csv
./athena/cpt4.jar
./athena/cpt.bat
./athena/cpt.sh
./athena/DOMAIN.csv
./athena/DRUG_STRENGTH.csv
./athena/readme.txt
./athena/RELATIONSHIP.csv
./athena/VOCABULARY.csv
```

We will assume you already have a PostgreSQL server set up on localhost on the Linux machine (another assumption, so we can use bash\`\`\`{sh dotenv, eval=F} commands) you're using for this, as well as a user and password.

### Create your database and schemas

``` sql
➜ psql -h localhost -U postgres
...
Type "help" for help.
postgres=# \l
                                      List of databases
+--------------------+----------+----------+------------+------------+-----------------------+
|        Name        |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |
+--------------------+----------+----------+------------+------------+-----------------------+
| postgres           | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       |
+--------------------+----------+----------+------------+------------+-----------------------+
(1 rows)

postgres=# create database empty_omop;
CREATE DATABASE
Time: 945.841 ms
postgres=# \q
➜ psql -h localhost -U postgres -d empty_omop
...
Type "help" for help.

empty_omop=# create schema empty_omop_cdm;
CREATE SCHEMA
Time: 2.172 ms
empty_omop=# create schema empty_omop_results;
CREATE SCHEMA
Time: 1.328 ms
empty_omop=# \l
                                      List of databases
+--------------------+----------+----------+------------+------------+-----------------------+
|        Name        |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |
+--------------------+----------+----------+------------+------------+-----------------------+
| empty_omop         | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       |
| postgres           | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       |
+--------------------+----------+----------+------------+------------+-----------------------+
(2 rows)

empty_omop=# \q 
```

### Gratuitous advice about how to set up environment for working in psql

I happen to have some fancy stuff in my .psqlrc file. If you want it, copy .psqlrc from this repo home directory to your user home directory. It works in conjunction with an alias I use for psql, which you can set up by putting the following in your .zshrc (because I use zsh. I think it will work fine in bash, which would require putting it in your ~/.bashrc or ~/.bash\_profile file, but I can't promise the syntax will be exactly right):

``` bash
alias psql="PGPASSWORD=\$PGPASSWORD psql -h \$PGHOST -U \$PGUSER -d \$PGDATABASE --set=cdm=\$CDM_SCHEMA --set=results=\$RESULTS_SCHEMA"
```

<a id="dotenv" /> Those environment variables in the psql alias will need to be set, which I do with a .env (dotenv) file like so:

``` bash
➜ cat .env
PGHOST="localhost"
PGUSER="postgres"
PGPASSWORD="pwd"
PGDATABASE="empty_omop"
CDM_SCHEMA="empty_omop_cdm"
RESULTS_SCHEMA="empty_omop_results"
```

Except for the password, these environment variables now agree with the assumptions and create statements above.

If you do put your postgres connection parameters in a file called .env and you keep a copy of .env in your project directory and you use git, make sure to add .env to your .gitignore file so you don't accidentally commit it to your repository.

``` bash
➜ echo .env >> .gitignore # adds .env to .gitignore
```

If you did put all those pieces in place, set the environment variables by entering `source ./.env` (use the correct path) on the command line. Then `psql` as aliased above will use those environment variable as command line arguments. You will now have your cdm and results schemas automatically set on your search\_path when you start psql; and you will be able to use special symbols `:cdm` and `:results` as schema qualifiers, like: `CREATE TABLE :results.cohort_thingy (person_id int);` This is mostly helpful if you're writing scripts that you want to repeat and be able to run in different schemas.

If you didn't use all my fancy stuff (which would be understandable, because it's a lot of pieces to get working), do make a habit of setting your search\_path when you start psql so you don't accidentally create tables and stuff in the wrong places and so you can refer to tables without explicitly typing the schema name. Especially psql's special backslash commands are better if your search\_path is set. E.g.:

``` sql

-- \l, used above, shows list of databases

-- \dn shows all schemas in current database:

empty_omop=# \dn
         List of schemas
+--------------------+----------+
|        Name        |  Owner   |
+--------------------+----------+
| empty_omop_cdm     | postgres |
| empty_omop_results | postgres |
| public             | postgres |
+--------------------+----------+
(3 rows)
empty_omop=# show search_path;
+-----------------+
|   search_path   |
+-----------------+
| "$user", public |
+-----------------+
(1 row)

Time: 0.703 ms

empty_omop=# set search_path = empty_omop_cdm, empty_omop_results;
SET
Time: 0.581 ms
empty_omop=# show search_path;
+------------------------------------+
|            search_path             |
+------------------------------------+
| empty_omop_cdm, empty_omop_results |
+------------------------------------+
(1 row)

Time: 0.705 ms

-- \d shows list of tables and other objects in schemas currently on the search_path:

empty_omop=# \d
No relations found.

empty_omop=# create table empty_omop_results.test_table (x int);
CREATE TABLE
Time: 4.314 ms
empty_omop=# \d
                  List of relations
+--------------------+------------+-------+----------+
|       Schema       |    Name    | Type  |  Owner   |
+--------------------+------------+-------+----------+
| empty_omop_results | test_table | table | postgres |
+--------------------+------------+-------+----------+
(1 row)
```

### Create tables and other objects

The OMOP DDL files don't specify the schema objects will appear in. So if you want them to go in the right places, you need to set your search\_path. You can do this within psql and then call the create scripts from there (using `\i`) rather than piping them in from the command line. E.g.:

``` sql
empty_omop=# set search_path = empty_omop_cdm;
SET
Time: 0.615 ms
empty_omop=# \i './CommonDataModel/PostgreSQL/OMOP CDM postgresql ddl.txt'
CREATE TABLE
Time: 5.013 ms
CREATE TABLE
Time: 4.430 ms
CREATE TABLE
Time: 1.090 ms
CREATE TABLE
Time: 1.324 ms
...
\d
                     List of relations
+----------------+-----------------------+-------+----------+
|     Schema     |         Name          | Type  |  Owner   |
+----------------+-----------------------+-------+----------+
| empty_omop_cdm | attribute_definition  | table | postgres |
| empty_omop_cdm | care_site             | table | postgres |
| empty_omop_cdm | cdm_source            | table | postgres |
| empty_omop_cdm | concept               | table | postgres |
| empty_omop_cdm | concept_ancestor      | table | postgres |
| empty_omop_cdm | concept_class         | table | postgres |
| empty_omop_cdm | concept_relationship  | table | postgres |
| empty_omop_cdm | concept_synonym       | table | postgres |
| empty_omop_cdm | condition_era         | table | postgres |
| empty_omop_cdm | condition_occurrence  | table | postgres |
| empty_omop_cdm | cost                  | table | postgres |
| empty_omop_cdm | device_exposure       | table | postgres |
| empty_omop_cdm | domain                | table | postgres |
| empty_omop_cdm | dose_era              | table | postgres |
| empty_omop_cdm | drug_era              | table | postgres |
| empty_omop_cdm | drug_exposure         | table | postgres |
| empty_omop_cdm | drug_strength         | table | postgres |
| empty_omop_cdm | fact_relationship     | table | postgres |
| empty_omop_cdm | location              | table | postgres |
| empty_omop_cdm | location_history      | table | postgres |
| empty_omop_cdm | measurement           | table | postgres |
| empty_omop_cdm | metadata              | table | postgres |
| empty_omop_cdm | note                  | table | postgres |
| empty_omop_cdm | note_nlp              | table | postgres |
| empty_omop_cdm | observation           | table | postgres |
| empty_omop_cdm | observation_period    | table | postgres |
| empty_omop_cdm | payer_plan_period     | table | postgres |
| empty_omop_cdm | person                | table | postgres |
| empty_omop_cdm | procedure_occurrence  | table | postgres |
| empty_omop_cdm | provider              | table | postgres |
| empty_omop_cdm | relationship          | table | postgres |
| empty_omop_cdm | source_to_concept_map | table | postgres |
| empty_omop_cdm | specimen              | table | postgres |
| empty_omop_cdm | survey_conduct        | table | postgres |
| empty_omop_cdm | visit_detail          | table | postgres |
| empty_omop_cdm | visit_occurrence      | table | postgres |
| empty_omop_cdm | vocabulary            | table | postgres |
+----------------+-----------------------+-------+----------+
(37 rows)
```

This completes Step 2 of the official [CDM Postgres instructions](https://github.com/OHDSI/CommonDataModel/tree/master/PostgreSQL) ([local copy](./CommonDataModel/PostgreSQL/README.md))

We will make a data dump of the emtpy\_omop\_cdm schema now, prior to loading vocabulary tables, because it may be useful to readers of these instructions. Assuming you've set <a href="#dotenv">environment variables</a> in your shell (e.g., like: `source ./.env`), the dump command could look like:

    PGPASSWORD=$PGPASSWORD pg_dump -h $PGHOST -U $PGUSER -d $PGDATABASE -n $CDM_SCHEMA -n $RESULTS_SCHEMA > empty_omop_dump.sql

The we've included the dump file in this repo here: [./empty\_omop\_dump.sql](./empty_omop_dump.sql)

### Next step: [Load vocabularies](./load_vocabularies.md)
