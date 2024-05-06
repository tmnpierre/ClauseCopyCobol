       IDENTIFICATION DIVISION.
       PROGRAM-ID. Main.

       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.

       COPY 'Exemple.cpy'.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY 'Chargement des données à partir de la clause COPY'.
           DISPLAY EXERCICE-ENTETE.
           STOP RUN.
