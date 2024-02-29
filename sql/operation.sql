-- 1. Accesso alla piattaforma.
-- Accesso Cliente
SELECT *
FROM CLIENTE
WHERE Nome_utente = ?
  AND Password = ?;
-- Accesso Impiegato
SELECT *
FROM IMPIEGATO
WHERE Nome_utente = ?
  AND Password = ?;

-- 2. Inserimento impiegato.
INSERT INTO IMPIEGATO(Nome_utente, Password, Nome, Cognome, Email,
                      Sesso, Data_nascita, Codice_fiscale, Stipendio)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);

-- 3. Inserimento macchinista.
INSERT INTO MACCHINISTA(Codice_fiscale, Nome, Cognome, Stipendio)
VALUES (?, ?, ?, ?);

-- 4. Inserimento tratta.
INSERT INTO TRATTA(Codice, Nome)
VALUES (?, ?);
-- L'inserimento di una tratta comporta l'inserimento dell'impiegato
-- che la gestice
INSERT INTO GESTISCE(Nome_utente_impiegato, Codice_tratta)
VALUES (?, ?);

-- 5. Inserimento treno.
INSERT INTO TRENO(Codice, Velocita_max, Codice_fiscale_macchinista,
                  Codice_tratta)
VALUES (?, ?, ?, ?);

-- 6. Inserimento posto treno.
INSERT INTO POSTO(Numero, Codice_treno)
VALUES (?, ?);

-- 7. Inserimento viaggio.
-- I posti disponibili alla creazione di un viaggio sono pari
-- ai posti totali del treno che effettua il viaggio.
SELECT COUNT(*)
FROM POSTO AS P,
     TRENO AS T
WHERE Codice_tratta = ?
  AND P.Codice_treno = T.Codice

-- Operazione completa
    INSERT
INTO VIAGGIO(Prezzo, Posti_disponibili, Data_ora_partenza,
             Data_ora_arrivo, Codice_tratta,
             Codice_stazione_partenza, Codice_stazione_arrivo)
VALUES (?, (SELECT COUNT (*)
    FROM POSTO AS P, TRENO AS T
    WHERE Codice_tratta = ?
    AND P.Codice_treno = T.Codice), ?, ?, ?, ?, ?
    );

-- 8. Inserimento stazione.
INSERT INTO STAZIONE(Codice, Indirizzo, Nome, Telefono)
VALUES (?, ?, ?, ?);

-- 9. Seleziona tratta gestite da un determinato impiegato.
SELECT T.*
FROM TRATTA AS T,
     GESTISCE AS G
WHERE G.Nome_utente_impiegato = ?
  AND T.Codice = G.Codice_tratta;

-- 10. Registrazione di un cliente.
INSERT INTO CLIENTE(Nome_utente, Password, Nome, Cognome, Email, Sesso,
                    Data_nascita, Codice_fiscale, Data_iscrizione)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, now());
-- L'inserimento di un cliente comporta l'inserimento dei suoi numeri di
-- telefono
INSERT INTO TELEFONO(Numero, Nome_utente_cliente)
VALUES (?, ?);
-- e delle sue carte per i pagamenti.
INSERT INTO CARTA(Numero, Scadenza, Nome_utente_cliente)
VALUES (?, ?, ?);

-- 11. Seleziona viaggi prenotabili, cioè con posti disponibili
-- e con data partenza successiva di un giorno alla data attuale, che
-- partono da una determinata stazione e arrivano in una determinata stazione.
SELECT SP.Nome AS Partenza,
       SA.Nome AS Arrivo,
       V.Prezzo,
       V.Data_ora_partenza,
       V.Data_ora_arrivo,
       V.Codice
FROM VIAGGIO AS V,
     STAZIONE AS SP,
     STAZIONE AS SA
WHERE V.Codice_stazione_partenza = SP.Codice
  AND V.Codice_stazione_arrivo = SA.Codice
  AND V.Data_ora_partenza > DATE_ADD(now(), INTERVAL 1 DAY)
  AND Posti_disponibili > 0
  AND SP.Nome LIKE ?%
AND SA.Nome LIKE ?%;

-- 12. Acquisto biglietto da un cliente.
-- La data di prenotazione, è la data corrente all'acquisto.
now
()
-- Il numero posto viene determinato automaticamente,
-- selezionando un posto disponibile, non prenotato da altri biglietti
-- dal treno che effettua il viaggio inerente.
SELECT Numero
FROM (SELECT P.Numero AS Numero
      FROM VIAGGIO AS V,
           TRENO AS T,
           POSTO AS P
      WHERE V.Codice = ?
        AND V.Codice_tratta = T.Codice_tratta
        AND T.Codice = P.Codice_treno
        AND (P.Numero) NOT IN (SELECT Numero_posto
                               FROM BIGLIETTO
                               WHERE Codice_viaggio = V.Codice)) AS DISPONIBILI LIMIT 1);
-- Il codice del treno viene determinato dal codice del viaggio
SELECT T.Codice
FROM VIAGGIO AS V,
     TRENO AS T
WHERE Codice = ?
  AND V.Codice_tratta = T.Codice_tratta;
-- Operazione completa.


INSERT INTO BIGLIETTO(Data_acquisto, Nome_utente_cliente, Numero_carta,
                      Numero_posto, Codice_treno, Codice_viaggio)
VALUES (now(),
        ?,
        ?,
        (SELECT Numero
         FROM (SELECT P.Numero AS Numero
               FROM VIAGGIO AS V,
                    TRENO AS T,
                    POSTO AS P
               WHERE V.Codice = ?
                 AND V.Codice_tratta = T.Codice_tratta
                 AND T.Codice = P.Codice_treno
                 AND (P.Numero) NOT IN (SELECT Numero_posto
                                        FROM BIGLIETTO
                                        WHERE Codice_viaggio = V.Codice)) AS DISPONIBILI
            LIMIT 1),
       (SELECT T.Codice
               FROM VIAGGIO AS V, TRENO AS T
		 WHERE Codice = ?
		 AND V.Codice_tratta = T.Codice_tratta;
)
		?
	);
-- All'acquisto di un biglietto bisogna bisogna aggiornare i posti
-- disponibili del viaggio inerente.
UPDATE VIAGGIO
SET Posti_disponibili = Posti_disponibili - 1
WHERE Codice = ?;


-- 13. Seleziona i biglietti acquistati da un cliente, con posto
-- nel treno, informazioni viaggio, e stazioni di partenza e arrivo.
SELECT B.Codice,
       B.Data_acquisto,
       B.Numero_posto,
       B.Codice_treno,
       V.Prezzo,
       SP.Nome AS Partenza,
       SA.Nome AS Arrivo,
       V.Data_ora_partenza,
       V.Data_ora_arrivo
FROM BIGLIETTO AS B,
     VIAGGIO AS V,
     STAZIONE AS SP,
     STAZIONE AS SA
WHERE B.Nome_utente_cliente = ?
  AND B.Codice_viaggio = V.Codice
  AND V.Codice_stazione_partenza = SP.Codice
  AND V.Codice_stazione_arrivo = SA.Codice;

-- 14. Seleziona i biglietti rimborsabili nella data attuale,
-- con data partenza con distanza non inferiore ai 7 giorni.
SELECT B.*
FROM BIGLIETTO AS B,
     VIAGGIO AS V
WHERE B.Codice_viaggio = V.Codice
  AND DATE_SUB(V.Data_ora_partenza, INTERVAL 7 DAY) >= now()
  AND Nome_utente_cliente = ?;


-- 15. Cancellazione biglietto da un cliente.
-- Prima della cancellazione di un biglietto bisogna aggiornare
-- i posti disponibili per il viaggio inerente.
UPDATE VIAGGIO
SET Posti_disponibili = Posti_disponibili + 1
WHERE Codice = (SELECT Codice_viaggio
                FROM BIGLIETTO
                WHERE Codice = ?);

DELETE
FROM BIGLIETTO
WHERE Codice = ?;

-- 16. Seleziona carte disponibili di un cliente.
SELECT Numero, Scadenza
FROM CARTA
WHERE Nome_utente_cliente = ?;


-- 17. Seleziona tutti i clienti registrati.
SELECT *
FROM CLIENTE
-- Numero di telefono di un cliente
SELECT Numero
FROM TELEFONO
WHERE Nome_utente_cliente = ?;

-- 18. Seleziona i clienti che hanno acquistato biglietti
-- per un determinato viaggio: da una
-- specificata stazione ad una specificata stazione.
SELECT DISTINCT C.*
FROM CLIENTE AS C,
     BIGLIETTO AS B,
     VIAGGIO AS V,
     STAZIONE AS SP,
     STAZIONE AS SA
WHERE C.Nome_utente = B.Nome_utente_cliente
  AND B.Codice_viaggio = V.Codice
  AND V.Codice_stazione_partenza = SP.Codice
  AND SP.Nome = ?
  AND V.Codice_stazione_arrivo = SA.Codice
  AND SA.Nome = ?;

-- 19. Clienti con numero di biglietti acquistati,
-- prezzo medio e prezzo massimo.
SELECT C.Nome_utente AS Cliente,
       COUNT(*)      AS Numero_biglietti,
       AVG(V.Prezzo) AS Prezzo_medio,
       MAX(V.Prezzo) AS Prezzo_massimo
FROM CLIENTE AS C,
     BIGLIETTO AS B,
     VIAGGIO AS V
WHERE C.Nome_utente = B.Nome_utente_cliente
  AND B.Codice_viaggio = V.Codice
GROUP BY C.Nome_utente;

-- 20. Seleziona i viaggi effettuati da un determinato macchinista.
SELECT DISTINCT V.Codice, V.Prezzo, V.Posti_disponibili
FROM VIAGGIO AS V,
     TRENO AS T
WHERE T.Codice_fiscale_macchinista = ?
  AND V.Codice_tratta = T.Codice_tratta;