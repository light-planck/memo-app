#!/bin/bash

source .env

# PostgreSQLにログインしてデータベースを作成
psql -U $DB_USER -h localhost <<EOF

CREATE DATABASE $DB_NAME;
\c $DB_NAME
CREATE TABLE memos (
  id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT
);
EOF
