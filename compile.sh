#!/bin/bash
gcc -I/usr/include/mysql -c cobmysqlapi.c

gcc dbpre.c -odbpre -O5 -ggdb