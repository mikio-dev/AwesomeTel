#!/bin/sh
export $(cat ../.env | xargs)
pg_dump -h ${REMOTE_HOST} -d ${POSTGRES_DB} -p ${REMOTE_PORT} -U ${POSTGRES_USER} -W -F t > ${POSTGRES_DB}.tar

