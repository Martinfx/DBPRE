      * dbpre V 0.4: PCTB004S.cob                                20160929-212714
------*-------------------------------------------------------------------------
----+-*--1----+----2----+----3----+----4----+----5----+----6----+----7-*--+----8
      **************************************************************************
      *  I D E N T I F I C A T I O N   D I V I S I O N                         *
      **************************************************************************
        IDENTIFICATION              DIVISION.
        PROGRAM-ID.                 PCTB004S.
DBPRE * AUTHOR.                     THE_PIPER.
DBPRE * DATE-WRITTEN.               TODAY.
      /
      **************************************************************************
      *                                                                        *
      *                       Testprogram for subroutine calls                 *
      *                                                                        *
      **************************************************************************
        /
      **************************************************************************
      *  D A T A    D I V I S I O N                                            *
      **************************************************************************
        DATA                        DIVISION.
      /
      **************************************************************************
      *  W O R K I N G   S T O R A G E   S E C T I O N                         *
      **************************************************************************
        WORKING-STORAGE SECTION.
      *
      * The needed working storage stuff for the framework
        COPY PGCTBSUBWS.
      *
      * This will be displayed in the logfile at runtime
        01  PGCTB-VERSION                    PIC  X(38) 
            VALUE '20150916 1.0 INITIAL RELEASE'.
      *
        01  FIELD1.
          05 FIELD1-NUM                      PIC  9(08).
          05 FILLER                          PIC  X(12) VALUE SPACE.
        01  FIELD2                           PIC  X(16).
        01  FIELD3                           PIC  X(32).
      *
        01  T                                PIC  S9(9) COMP.
      *
      /
        LINKAGE SECTION.
      * The communication area for the database
      * EXEC SQL
      *      INCLUDE SQLCA.
        01  SQLCA.
          05 SQLCA-CID                     USAGE POINTER.
          05 SQLCA-CURSOR-CTRL-GRP.
            10 SQLCA-CURSOR-CTRL OCCURS 65 PIC X.
          05 SQLCA-RESULT-GRP OCCURS 65.
            10 SQLCA-RESULT                USAGE POINTER.
          05 SQLCA-SEQUENCE                PIC 9(08).
          05 SQLCA-COUNT                   PIC 9(08).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-RETURN-CODE             PIC 9(03).
          05 SQLCA-CROWCNT                 PIC X(08).
          05 SQLCA-ROWCNT                  PIC 9(08).
            88 SQLCA-NO-ROW                VALUE 0.
            88 SQLCA-ONE-ROW               VALUE 1.
            88 SQLCA-MORE-THAN-ONE-ROW     VALUE 2 THRU 99999999.
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-HOST                    PIC X(32).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-USER                    PIC X(32).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-PASSWD                  PIC X(32).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-DBNAME                  PIC X(32).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-PORT                    PIC 9(05).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-SOCKET                  PIC X(32).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCA-QUOTE                   PIC X VALUE "'".
          05 SQLCA-CARD                    PIC X(80).
          05 SQLCA-STATEMENT.
            10 SQLCA-STAT-LINE OCCURS 80   PIC X(25).
          05 FILLER                        PIC X VALUE LOW-VALUE.
          05 SQLCODE                       PIC 9(03).
            88 DB-OK                       VALUE 0.
            88 DB-CURSOR-ALREADY-OPEN      VALUE -1.
            88 DB-CURSOR-NOT-OPEN          VALUE -2.
            88 DB-NOT-FOUND                VALUE 100.
DBPRE * END-EXEC.
      *
      * The parameter block of this subroutine
      * EXEC SQL
      *        INCLUDE PCTB004P001.
      * This stuff belongs to the WORKING-STORAGE SECTION of a BATCH program
      * which calls subroutine PCTB004S
      * 
      * This stuff belongs to the LINKAGE SECTION of the SUBROUTINE
      * PCTB004S.
      * 
      * This is the link between a BATCH program and a SUBROUTINE to
      * exchange data and is used in the CALL statement like this:
      * 
      * *initialize the needed values in the param block
      *  SET PCTB004-001-INIT                 TO TRUE
      * *specify the request you want to use
      *  SET PCTB004-001-DUMP-RECORDS         TO TRUE
      * *and finally call the subroutine with the needed parameters
      *  CALL PCTB004-001-CALL-ID             USING PCTB004-001-PARAM-BLOCK
      *                                             PGCTB-PARAM-BLOCK
      *  END-CALL
      *  EVALUATE TRUE
      *  WHEN PCTB004-001-OK
      *     CONTINUE
      *  WHEN PCTB004-001-ERROR
      *     (do some error handling)
      *  WHEN OTHER
      *     PERFORM PGCTB-ERROR-SECTION
      *  END-EVALUATE
      * 
      *  The name of this parameter block is PCTB004P001
      *  which means:
      *  
      *  PCTB004 - it is used to call a subroutine named PCTB004S
      *  P       - it is a parameter block, indeed
      *  001     - a subroutine can handle more than one parameter block,
      *            this is number 001, there can be up to 999 different
      *            parameter blocks, which might differ in data depending
      *            on the requests
      *
      * Each parameter block has a request field, like PCTB004-001-REQUEST
      * which can have a lot of different requests, 88 values.
      * 
      * So it makes sense to group requests depending on the data in the
      * parameter block, like PARAM-BLOCK 001 deals with addresses of 
      * customers and has requests like 'FIND-CUSTOMER', 'UPDATE-CUSTOMER',
      * 'DELETE-CUSTOMER', 'ADD-CUSTOMER', 
      *
      * PARAM-BLOCK 002 might deal with accounting stuff, like
      * 'CREATE-ACCOUNT', 'ADDACCTDATA', 'UPDATE-ACCNT', 'DELETE-ACCNT'
      *
      * PARAM-BLOCK 003 might deal with orders, like:
      * 'ADD-ORDER', 'LIST-ORDERS', 'DELETE-ORDER', 'PROCESS-ORDER'.
      * 
      * And so on. You might have got the idea behind this naming convention.
----+-*--1-!--+----2----+----3----+----4----+----5----+----6----+----7-!--+----8
        01  PCTB004-001-PARAM-BLOCK.
          05  PCTB004-001-GRP.
            06  PCTB004-001-CALL-ID           PIC X(8).
            06  PCTB004-001-REQID             PIC 999.
            06  PCTB004-001-VERSION           PIC 9999.
          05  PCTB004-001-GRP-RED             REDEFINES PCTB004-001-GRP
                                              PIC X(15).
            88 PCTB004-001-INIT               VALUE 'PCTB004S0010001'.
          05  PCTB004-001-REQUEST             PIC X(16).
            88 PCTB004-001-D-A-RECORDS        VALUE 'DISPALLRECORDS  '.
          05  PGCTB-001-DATA.
            06 FILLER                         PIC X.
      * Add here more data to exchange between batch program and
      * subroutine, if needed
            06 PCTB004-001-STATUS             PIC 999.
              88 PCTB004-001-OK               VALUE 0.
              88 PCTB004-001-ERROR            VALUE 999.
DBPRE * END-EXEC.
      *
          COPY PGCTBPARAM.
      *
      /
      **************************************************************************
      *  P R O C E D U R E   D I V I S I O N                                   *
      **************************************************************************
        PROCEDURE DIVISION USING PCTB004-001-PARAM-BLOCK
      *                                  no dot here, the dot to end the
        *                                  USING is in the copybook!
      * The framework itself, calling PGCTB-ACTION to run the users coding
           COPY PGCTBSUB REPLACING 'TTTTNNNS' BY 'PCTB004S'.
                                                 
      /
      **************************************************************************
      *  P O C T B - A C T I O N   S E C T I O N                               *
      **************************************************************************
        PGCTB-ACTION SECTION. 
      *
           DISPLAY 'In PGCTB-ACTION (subroutine).'
      *
             EVALUATE TRUE
              WHEN PCTB004-001-D-A-RECORDS
              PERFORM DISPLAY-ALL-RECORDS
              WHEN OTHER
                 MOVE 'Invalid Request'     TO PGCTB-ERROR-MESSAGE
                  SET PGCTB-INVALID-REQUEST  TO TRUE
              END-EVALUATE
      *
           DISPLAY 'End PGCTB-ACTION (subroutine).'
      *
           .
        PGCTB-ACTION-EXIT.
           EXIT.
      /
      **************************************************************************
        DISPLAY-ALL-RECORDS SECTION. 
      *
            DISPLAY '-------------------------------------------'
      * Attention !! Table name is CaSe sensitive!!!!!!!!!!!!!
DBPRE       MOVE 1             TO SQLCA-SEQUENCE
      *     EXEC SQL
DBPRE *        DECLARE ALLROWS CURSOR FOR
DBPRE *     END-EXEC.
            EVALUATE TRUE
            WHEN DB-OK
               CONTINUE
            WHEN OTHER
               PERFORM DB-STATUS
            END-EVALUATE
      *
DBPRE       MOVE 2             TO SQLCA-SEQUENCE
      *     EXEC SQL
DBPRE *          OPEN ALLROWS
DBPRE       IF SQLCA-CURSOR-CTRL (1) = 1
DBPRE          SET DB-CURSOR-ALREADY-OPEN TO TRUE
DBPRE          PERFORM DB-STATUS
DBPRE       END-IF

DBPRE       MOVE 1 TO SQLCA-CURSOR-CTRL (1)
DBPRE       MOVE LOW-VALUES TO SQLCA-STATEMENT
DBPRE       MOVE 'SELECT FIELD1, FIELD2, FI' TO SQLCA-STAT-LINE (1)
DBPRE       MOVE 'ELD3 FROM example_table ' TO SQLCA-STAT-LINE (2)
DBPRE       CALL 'MySQL_query' USING SQLCA-STATEMENT
DBPRE       END-CALL
DBPRE       MOVE RETURN-CODE TO SQLCODE
DBPRE       IF DB-OK
DBPRE          CALL 'MySQL_use_result' USING SQLCA-RESULT (1)
DBPRE          END-CALL
DBPRE          IF SQLCA-RESULT (1) = NULL
DBPRE             MOVE 100 TO SQLCODE
DBPRE          ELSE
DBPRE             MOVE 0 TO SQLCODE
DBPRE          END-IF
DBPRE       END-IF
DBPRE       IF DB-OK
DBPRE          CALL 'MySQL_fetch_row' USING SQLCA-RESULT (1)
DBPRE                                          FIELD1
DBPRE                                          FIELD2
DBPRE                                          FIELD3
DBPRE          END-CALL
DBPRE          IF SQLCA-RESULT (1) = NULL
DBPRE             MOVE 100 TO SQLCODE
DBPRE          ELSE
DBPRE             MOVE 0 TO SQLCODE
DBPRE          END-IF
DBPRE       END-IF
DBPRE *     END-EXEC.
            EVALUATE TRUE
            WHEN DB-OK
               CONTINUE
            WHEN DB-NOT-FOUND
               CONTINUE
            WHEN OTHER
               PERFORM DB-STATUS
            END-EVALUATE
                                                 
            DISPLAY  'FIELD1=' FIELD1 ' FIELD2=' FIELD2 
                     ' FIELD3=' FIELD3
          
            PERFORM UNTIL NOT DB-OK
DBPRE          MOVE 3             TO SQLCA-SEQUENCE
      *        EXEC SQL
DBPRE *        END-EXEC.
DBPRE       IF SQLCA-CURSOR-CTRL (1) = 0
DBPRE          SET DB-CURSOR-NOT-OPEN TO TRUE
DBPRE          PERFORM DB-STATUS
DBPRE       END-IF
DBPRE          CALL 'MySQL_fetch_row' USING SQLCA-RESULT (1)
DBPRE                                          FIELD1
DBPRE                                          FIELD2
DBPRE                                          FIELD3
DBPRE          END-CALL
DBPRE          IF SQLCA-RESULT (1) = NULL
DBPRE             MOVE 100 TO SQLCODE
DBPRE          ELSE
DBPRE             MOVE 0 TO SQLCODE
DBPRE          END-IF
               EVALUATE TRUE
                 WHEN DB-OK
                     DISPLAY  'FIELD1=' FIELD1 ' FIELD2=' FIELD2 
                           ' FIELD3=' FIELD3
                 WHEN DB-NOT-FOUND
                    MOVE SPACE             TO FIELD1
                    MOVE SPACE             TO FIELD2
                    MOVE SPACE             TO FIELD3
                 WHEN OTHER
                    PERFORM DB-STATUS
               END-EVALUATE
            END-PERFORM
            SET DB-OK                      TO TRUE
            DISPLAY '-------------------------------------------'
      *
DBPRE       MOVE 4             TO SQLCA-SEQUENCE
      *     EXEC SQL
      *        CLOSE ALLROWS
DBPRE       IF SQLCA-CURSOR-CTRL (1) = 0
DBPRE          SET DB-CURSOR-NOT-OPEN TO TRUE
DBPRE          PERFORM DB-STATUS
DBPRE       END-IF
DBPRE       MOVE 0 TO SQLCA-CURSOR-CTRL (1)
DBPRE *     END-EXEC.
            EVALUATE TRUE
            WHEN DB-OK
               CONTINUE
            WHEN OTHER
               PERFORM DB-STATUS
            END-EVALUATE
           .
        DISPLAY-ALL-RECORDS-EXIT.
           EXIT.
