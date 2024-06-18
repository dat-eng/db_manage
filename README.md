# Liquibase

Liquibase is an open-source solution for managing revisions of database schema scripts.
Currently, Liquibase is configured to apply changes to MySQL Schema and Snowflake DWH.
These scripts are referred to as "changesets", and are in XML format.

Liquibase has inbuilt drivers for Snowflake, but not for MySQL.

Liquibase Documentation Link-> [https://liquibase.org/get-started]

#### Liquibase Version: 4.24

##### Sample changeset:
```
 <changeSet id="TEST_1" author="john.smith">
      <preConditions onFail="MARK_RAN">
         <sqlCheck expectedResult="FALSE">SELECT EXISTS (
                                               SELECT table_name FROM information_schema.tables
                                                WHERE table_schema = 'PUBLIC'
                                                  AND table_name   = 'TEST'
                                           )
         </sqlCheck>
      </preConditions>
      <sql>create table stage.test (id integer, name varchar(100), created_at timestamp);</sql>
      <comment>This is a test run</comment>
  </changeSet>
  <changeSet id="HD-2166_1a" author="john.smith">
      <preConditions onFail="MARK_RAN">
         <sqlCheck expectedResult="TRUE">SELECT EXISTS (
                                               SELECT table_name FROM information_schema.tables
                                                WHERE table_schema = 'PUBLIC'
                                                  AND table_name   = 'TEST'
                                           )
         </sqlCheck>
      </preConditions>
      <sql>drop table stage.test ;</sql>
 </changeSet>
```

##### Advantages of using changeset:

1. Audit trail in the database for all queries run via liquibase.
2. Changeset id tag contains the Jira ticket number for the query
3. Comments tag contains any comments we need for the query
4. Author tag contains the author of this query

## Schemas
The changesets are deployed to the following schema called stage in MySQL database server available on the laptop.

## Development & Testing
Liquibase is deployed in a docker container.
Currently we trigger the deployment manually on all environments.

1. Schema changes and rollback queries have to be added to ```liquibase/changelogs/migrations``` directory
2. Schema change sets are added to the file: ```migrations/001/change.xml```
3. Rollback change sets are added to the file: ```migrations/001/rollback.xml```
4. SQL changes are added to file named: ```migrations/001/001_<**>.sql```
5. Rollback SQL changes are added to file named: ```migrations/001/rollback_001_<**>.sql```
6. Modify the filename in ```liquibase/changelogs/changelog.xml``` to reflect the schema change set file.
7. Modify the filename in ```liquibase/changelogs/rollbacklog.xml``` to reflect the rollback change set file.
8. The audit track for all deployments is available in the ```DATABASECHANGELOG``` table within the ```STAGE``` schema.
9. Changesets must have an unique `id` since Liquibase will check existing changelogs before applying the migrations. 
     ```sql
     select id from stage.databasechangelog where author='john.smith'
     ```

* Changesets that may include `>` and `<` symbols in the query must to be escaped with the characters `&gt;` and `&lt;`
* ```<**>``` denotes numbering for the files for cases where there are multiple sql files for a migration.
* Comments are limited to 255 characters currently

#### Test - Stage
Stage environment is used for testing the migrations.

* To redeploy the same changeset in the dev database, the changeset id has to be deleted from the changelogs table. 
  Thus allowing you to redeploy a changeset.
   ```sql
   delete from stage.databasechangelog where id like '%<whatever>%';
   ```
* Testing for the rollback procedure locally
   1. Run make build
   2. Run make rollback
   3. Remove ids from databasechangelog
   4. Then start again from the top

## Deployments

   * There is a possibility that the CICD user in the environment might not have the necessary grants for the object.
   
     In these scenarios, it is recommended to add the necessary privileges.

#### Deployment - Stage/Prod

* To ```re-deploy``` the same changeset in stage/prod, the changeset id has to be modified and then re-deployed. 
  Thus maintaining the audit trail for these environments in their respective changelogs table.
  
  Note: Changes for prod will go through an MR
  