CREATE SCHEMA train_company;
USE
train_company;

-- Creazione Tabelle
CREATE TABLE CLIENTE
(
    Nome_utente     VARCHAR(32) NOT NULL,
    Password        VARCHAR(32) NOT NULL,
    Nome            VARCHAR(32) NOT NULL,
    Cognome         VARCHAR(32) NOT NULL,
    Email           VARCHAR(32) NOT NULL,
    Sesso           CHAR        NOT NULL,
    Data_nascita    DATE        NOT NULL,
    Codice_fiscale  CHAR(16)    NOT NULL,
    Data_iscrizione DATE,
    PRIMARY KEY (Nome_utente)
);

CREATE TABLE TELEFONO
(
    Numero              CHAR(10)    NOT NULL,
    Nome_utente_cliente VARCHAR(32) NOT NULL,
    PRIMARY KEY (Numero),
    FOREIGN KEY (Nome_utente_cliente) REFERENCES CLIENTE (Nome_utente)
);

CREATE TABLE CARTA
(
    Numero              VARCHAR(16) NOT NULL,
    Scadenza            DATE        NOT NULL,
    Nome_utente_cliente VARCHAR(32) NOT NULL,
    PRIMARY KEY (Numero),
    FOREIGN KEY (Nome_utente_cliente) REFERENCES CLIENTE (Nome_utente)
);

CREATE TABLE IMPIEGATO
(
    Nome_utente    VARCHAR(32) NOT NULL,
    Password       VARCHAR(32) NOT NULL,
    Nome           VARCHAR(32) NOT NULL,
    Cognome        VARCHAR(32) NOT NULL,
    Email          VARCHAR(32) NOT NULL,
    Sesso          CHAR        NOT NULL,
    Data_nascita   DATE        NOT NULL,
    Codice_fiscale CHAR(16)    NOT NULL,
    Stipendio      FLOAT(7, 2
) ,
	PRIMARY KEY (Nome_utente)
);


CREATE TABLE TRATTA
(
    Codice INT         NOT NULL,
    Nome   VARCHAR(32) NOT NULL,
    PRIMARY KEY (Codice)
);

CREATE TABLE MACCHINISTA
(
    Codice_fiscale CHAR(16)    NOT NULL,
    Nome           VARCHAR(32) NOT NULL,
    Cognome        VARCHAR(32) NOT NULL,
    Stipendio      FLOAT(7, 2
) ,
	PRIMARY KEY (Codice_fiscale)
);

CREATE TABLE TRENO
(
    Codice                     INT      NOT NULL,
    Velocita_max               FLOAT    NOT NULL,
    Codice_fiscale_macchinista CHAR(16) NOT NULL,
    Codice_tratta              INT      NOT NULL,
    PRIMARY KEY (Codice),
    FOREIGN KEY (Codice_fiscale_macchinista) REFERENCES
        MACCHINISTA (Codice_fiscale),
    FOREIGN KEY (Codice_tratta) REFERENCES TRATTA (Codice)
);

CREATE TABLE POSTO
(
    Numero       INT NOT NULL,
    Codice_treno INT NOT NULL,
    PRIMARY KEY (Numero, Codice_treno),
    FOREIGN KEY (Codice_treno) REFERENCES TRENO (Codice)
);

CREATE TABLE STAZIONE
(
    Codice    INT NOT NULL,
    Indirizzo VARCHAR(32),
    Nome      VARCHAR(32),
    Telefono  CHAR(10),
    PRIMARY KEY (Codice)
);

CREATE TABLE VIAGGIO
(
    Codice INT AUTO_INCREMENT NOT NULL,
    Prezzo FLOAT(7, 2
) NOT NULL,
	Posti_disponibili INT NOT NULL,
	Data_ora_partenza DATETIME NOT NULL,
	Data_ora_arrivo DATETIME NOT NULL,
	Codice_tratta INT NOT NULL,
	Codice_stazione_partenza INT NOT NULL,
	Codice_stazione_arrivo INT NOT NULL,
	PRIMARY KEY (Codice),
	FOREIGN KEY (Codice_tratta) REFERENCES TRATTA(Codice),
	FOREIGN KEY (Codice_stazione_partenza) REFERENCES STAZIONE(Codice),
	FOREIGN KEY (Codice_stazione_arrivo) REFERENCES STAZIONE(Codice)
);



CREATE TABLE BIGLIETTO
(
    Codice              INT AUTO_INCREMENT NOT NULL,
    Data_acquisto       DATETIME    NOT NULL,
    Nome_utente_cliente VARCHAR(32) NOT NULL,
    Numero_carta        VARCHAR(16) NOT NULL,
    Numero_posto        INT         NOT NULL,
    Codice_treno        INT         NOT NULL,
    Codice_viaggio      INT         NOT NULL,
    PRIMARY KEY (Codice),
    FOREIGN KEY (Nome_utente_cliente) REFERENCES CLIENTE (Nome_utente),
    FOREIGN KEY (Numero_carta) REFERENCES CARTA (Numero),
    FOREIGN KEY (Numero_posto) REFERENCES POSTO (Numero),
    FOREIGN KEY (Codice_treno) REFERENCES POSTO (Codice_treno),
    FOREIGN KEY (Codice_viaggio) REFERENCES VIAGGIO (Codice)
);

CREATE TABLE GESTISCE
(
    Nome_utente_impiegato VARCHAR(32) NOT NULL,
    Codice_tratta         INT         NOT NULL,
    PRIMARY KEY (Nome_utente_impiegato, Codice_tratta),
    FOREIGN KEY (Nome_utente_impiegato) REFERENCES IMPIEGATO (Nome_utente),
    FOREIGN KEY (Codice_tratta) REFERENCES TRATTA (Codice)
);