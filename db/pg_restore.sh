#!/bin/bash
export $(cat ../.env | xargs)
pg_restore -h ${LOCAL_HOST} -d ${POSTGRES_DB} -p ${LOCAL_PORT} -U ${POSTGRES_USER} -W -F t ${POSTGRES_DB}.tar
