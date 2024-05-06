       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATEGROUPVARIABLES.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      
      *    Sélectionne le fichier d'entrée.
           SELECT INPUTFILE ASSIGN TO "input.txt"    
               ORGANIZATION IS LINE SEQUENTIAL.
      
      *    Sélectionne le fichier de sortie.
           SELECT OUTPUTFILE ASSIGN TO "output.cpy"  
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD INPUTFILE.
      
      *    Définit la structure de l'enregistrement d'entrée.
       01 INPUTRECORD PIC X(200).

       FD OUTPUTFILE.
      *    Définit la structure de l'enregistrement de sortie.
       01 OUTPUTRECORD PIC X(200). 

       WORKING-STORAGE SECTION.

      *    Indicateur de fin de fichier.
       01 WS-EOF PIC X VALUE 'N'.
      *    Nom de champ.    
       01 WS-FIELD-NAME PIC X(30).   
       01 WS-FIELD-VALUE PIC X(100). 
       01 WS-PIC-STATEMENT PIC X(100). 
       01 WS-START-POS PIC 99.
       01 WS-END-POS PIC 99..
       01 WS-FILLER PIC X(5) VALUE SPACES. 

       PROCEDURE DIVISION.
       BEGIN.
           OPEN INPUT INPUTFILE                    
                OUTPUT OUTPUTFILE.

           MOVE SPACES TO OUTPUTRECORD  
      *    Ajoute la déclaration de groupe.          
           MOVE '01 MY-GROUP.' TO OUTPUTRECORD(8:17)  
           WRITE OUTPUTRECORD
               AFTER ADVANCING 1 LINE

      * Boucle de traitement jusqu'à la fin du fichier.
           PERFORM UNTIL WS-EOF = 'Y'
               READ INPUTFILE
                   AT END MOVE 'Y' TO WS-EOF
               END-READ
               PERFORM PROCESS-LINE
           END-PERFORM.

           CLOSE INPUTFILE
                 OUTPUTFILE
           STOP RUN.

       PROCESS-LINE.
           MOVE 1 TO WS-START-POS
      *    Boucle jusqu'à la fin de la ligne.
           PERFORM UNTIL WS-START-POS > FUNCTION LENGTH(INPUTRECORD)
               PERFORM FIND-NEXT-WORD           
               PERFORM WRITE-PIC-STATEMENT     
           END-PERFORM.

       FIND-NEXT-WORD.
      * Définit la position de fin comme la longueur de la ligne.
           MOVE FUNCTION LENGTH(INPUTRECORD) TO WS-END-POS
      * Compte le nombre d'espaces pour trouver le prochain mot.        
           INSPECT INPUTRECORD TALLYING WS-END-POS FOR ALL SPACES  
      * Calcule la longueur du mot.
           COMPUTE WS-FIELD-NAME = WS-END-POS - WS-START-POS 
      * Extrait et convertit le mot en majuscules.     
           MOVE FUNCTION UPPER-CASE(INPUTRECORD(WS-START-POS:
                         LENGTH(WS-FIELD-NAME))) TO WS-FIELD-VALUE 
      * Met à jour la position de départ pour la prochaine recherche.
           MOVE WS-END-POS TO WS-START-POS                         
           ADD 1 TO WS-START-POS.

       WRITE-PIC-STATEMENT.
           STRING '   05 ' WS-FIELD-NAME ' PIC X(' WS-FIELD-NAME 
                  ') VALUE ' WS-FIELD-VALUE INTO WS-PIC-STATEMENT
           STRING WS-PIC-STATEMENT WS-FILLER INTO OUTPUTRECORD    
           WRITE OUTPUTRECORD 
               AFTER ADVANCING 1 LINE.                             
