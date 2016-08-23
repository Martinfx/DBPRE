README.TXT for dbpre V 0.4                                           2015-09-26
--------------------------

Developed by the_piper@web.de
For more infos see here: https://sourceforge.net/projects/dbpre/

dbpre is a precompiler for MySql and GnuCOBOL, it uses *.scb files
(SQL CoBol) for input and creates a *.cob file, which must be
compiled with GnuCOBOL to create either a module or an executable program.


File List
=========
c                  - script to compile dbpre using gcc
capi               - to compile the C api into an object file
cobmysqlapi.c      - the modified api for mysql from the OpenCobol forums
cobmysqlapi.o      - the object file of the api, to be linked to the programs
cPCTB003B          - compile script to compile test program 3
cPCTB004B          - compile script to compile test program 4
cPCTB004S          - compile script to compile test subroutine 4
dbpre.c            - the source code of dbpre       
PCTB003B.param     - parameter file for test program 3 (cursors)
PCTB003B.scb       - source code of test program 3 (.scb = Sql CoBol)
PCTB003B.sh        - shell script to run test program 3
PCTB004B.param     - parameter file for test program 4 (cursors + subroutine)
PCTB004B.scb       - source code of test program 4 (.scb = Sql CoBol)
PCTB004B.sh        - shell script to run test program 4
PCTB004S.scb       - source code for test subroutine 4
PCTB004P001        - parameter block for subroutine 4, number 001
PGCTBBAT           - copybook for BATCH which includes some COBOL coding
PGCTBPARAM         - working storage stuff for BATCH programs / Subroutines
PGCTBSUB           - copybook for SUBROUTINES which includes some COBOL code
PGCTBSUBWS         - working storage stuff for Subroutines
SQLCA              - SQL communication area



Requirements
============
gcc
MySql
OpenCobol/GnuCobol


A short description how to use this early pre-alpha version of dbpre
====================================================================

The MySql API
-------------
If you can't use the object file of cobmysqlapi, which is included in this
release, you must compile your own one from cobmysqlapi.c.

This object file will be linked later to the COBOL-programs.

Compile it with: gcc -I/usr/include/mysql -c cobmysqlapi.c
or use the shell script capi.


Compiling dbpre
---------------
Use the shell script "c" to compile dbpre.c. It's just a simple C program,
which requires nothing unusual.

To test dbpre type: dbpre --help
This displays a help message and some more informations.


The framework PGCTB
-------------------
PGCTB is an abbreviation for Pipers Gnu Cobol Tool Box.

The current framework is a framework for batch programs and subroutines. 
It consists of the files PGCTBBAT, which has COBOL commands and calls to the
MySql API, and PGCTBPARAM, the needed WORKING STORAGE definitions for BATCH
programs and subroutines.

Further PGCTBSUB and PGCTBSUBWS, which is the same stuff for subroutines 
(Subroutines include PGCTBPARAM aswell).

And the SQLCA, the SQL Communication Area used to communicate with the
MySql API.

The goal of this framework is to have transactions, which means, the
framework does CONNECT and COMMIT and ROLLBACK for you, if needed.

Under no circumstances write your own ROLLBACK and COMMIT statements!

If you must handle an error and want to roll back the whole transaction,
do this:

          SET PGCTB-ERROR                  TO TRUE
          MOVE 'an error occurred, run!!!' TO PGCTB-ERROR-MESSAGE
          PERFORM PGCTB-STATUS

This will cause the framework to display an error message including your
PGCTB-ERROR-MESSAGE and ROLLBACK the whole transaction and STOP RUN the program.

So, one BATCH program is one transaction, which includes all SQL statements
issued by the BATCH program and all called Subroutines.

At the end of that BATCH program, the framework will, in case of an error, roll 
back the whole transaction and display an error message, or, if no error 
occurred, commit the whole transaction to the database.


The example programs
--------------------
There are two examples coming with this release, PCTB003B.scb, a BATCH program,
PCTB004B.scb and PCTB004S.scb, which is an example for a BATCH program which 
calls a subroutine.

To compile, use the appropriate script, e.g. cPCTB003B.

This is how compiling works:
First call dbpre with the program name without suffix
E.g: dbpre PCTB003B -I./ -ts=3

dbpre expects that the suffix of the source code is .scb (Sql CoBol).
dbpre will then produce a .cob and a .lst file.
The .lst file contains, like the .cob file, the COBOL program but also error 
messages, if dbpre has found any errors.

Load the .lst file with your favorite editor and search for ERROR:

If dbpre has reported no errors, the cobol source code, the .cob file, can
be compiled with the GnuCobol compiler.

E.g: cobc -x PCTB003B.cob cobmysqlapi.o -L/usr/lib/mysql -lmysqlclient

If cobc has no errors to report, you should now have an executable file
named PCTB003B.

To compile a subroutine, use -m instead of -x. -m creates a module, a *.so
library, while -x creates an executable binary file.

The parameter file
------------------
The used framework, PGCTBBAT, uses a parameter file named <programname>.param,
e.g: PCTB003B.param, which has definitions needed to connect to the database.

Like this:

------(snip)-----------
DBHOST=localhost
DBUSER=root
DBPASSWD=YourPasswordHere           <=== change it!!
DBNAME=testdb
DBPORT=03306
DBSOCKET=null
------(snap)-----------

Before you can run the compiled test program, you must modify the param file
to your needs, specifying your password, your user name, your host for
mysql and so on.

When you have done that, you can start the test program by typing it's name
like PCTB003B and you should see the output.
Or use the appropriate script, e.g. PCTB003B.sh, which redirects the output
into a logfile and displays it with the 'more' command.



The MySql example_table
------------------------
To use this sample program, you have to create a table in your MySql database,
which must look like this:

Name: example_table:

+--------+----------+------+-----+---------+-------+
| Field  | Type     | Null | Key | Default | Extra |
+--------+----------+------+-----+---------+-------+
| field1 | char(20) | NO   |     | NULL    |       |
| field2 | char(16) | NO   |     | NULL    |       |
| field3 | char(32) | NO   |     | NULL    |       |
+--------+----------+------+-----+---------+-------+
3 rows in set (0.00 sec)


The program structure
---------------------
So, as we have seen in the text above, a program, which can be precompiled
with dbpre consists of:

The source code with the EXEC SQL statements, the *.scb file

The .cob file, produced by dbpre, the input for cobc

The .lst file, produced by dbpre, which contains ERROR: messages, if there
are any

The copybooks of the framework, PGCTBBAT, PGCTBPARAM, SQLCA,
for subroutines PGCTBSUB and PGCTBSUBWS.


The param file, which has the parameters to connect to the MySql server


Error handling
==============
Look at the example programs, how error handling is done with an
EVALUATE..END-EVALUATE statement.

To handle run time errors, the error message will tell you a sequence number.
Look at the .cob or .lst file and search for that number to identify the SQL 
statement, which caused the error.

For example, the error message reports a sequence number of 12, look at the
.cob file and search for "MOVE 12" until you have found the line
MOVE 12 TO SQLCA-SEQUENCE
and below that is the SQL-statement, which caused the error.


The End
=======
I hope, all this makes at least sense and is working, so you can test dbpre
a little bit.

For any comments, bug reports, suggestions, whatever, please post in the
discussion section at https://sourceforge.net/projects/dbpre/
or send an email to the_piper@web.de
