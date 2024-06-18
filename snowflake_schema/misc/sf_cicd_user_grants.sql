alter user cicd_<env> set default_role = ADMIN_<env>;
alter user cicd_<env> set default_namespace = <env>.PUBLIC;

grant USAGE on warehouse ho_<env> to role admin_<env>;
grant USAGE on database ho_<env> to role admin_<env>;
grant USAGE on schema ho_<env>.public to role admin_<env>;

grant CREATE EXTERNAL TABLE on schema ho_<env>.public to role admin_<env>;
grant CREATE FILE FORMAT on schema ho_<env>.public to role admin_<env>;
grant CREATE FUNCTION on schema ho_<env>.public to role admin_<env>;
grant CREATE MATERIALIZED VIEW on schema ho_<env>.public to role admin_<env>;
grant CREATE PIPE on schema ho_<env>.public to role admin_<env>;
grant CREATE PROCEDURE on schema ho_<env>.public to role admin_<env>;
grant CREATE SEQUENCE on schema ho_<env>.public to role admin_<env>;
grant CREATE STAGE on schema ho_<env>.public to role admin_<env>;
grant CREATE STREAM on schema ho_<env>.public to role admin_<env>;
grant CREATE TABLE on schema ho_<env>.public to role admin_<env>;
grant CREATE TASK on schema ho_<env>.public to role admin_<env>;
grant CREATE TEMPORARY TABLE on schema ho_<env>.public to role admin_<env>;
grant CREATE VIEW on schema ho_<env>.public to role admin_<env>;
grant MODIFY on schema ho_<env>.public to role admin_<env>;
grant MONITOR on schema ho_<env>.public to role admin_<env>;

grant ownership on all tables in schema <env>.public to role admin_<env>;

grant ownership on table signups to admin_<env> copy current grants;