#!/bin/bash
set -e

if type "$1" > /dev/null 2>&1; then
  ## First argument is an actual OS command. Run it
  exec "$@"
else
  cmd=$1; shift
  case "$cmd" in
    update)
      liquibase "--defaultsFile=/liquibase/conf/liquibase.properties" --log-level=info --sql-log-level=info update
      ;;
    rollback)
      liquibase "--defaultsFile=/liquibase/conf/liquibase_rollback.properties" --log-level=info --sql-log-level=info update
      ;;
  esac
fi
