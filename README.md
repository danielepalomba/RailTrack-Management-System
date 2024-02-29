# RailTrack Management System

## Descrizione del Progetto

Il progetto **RailTrack Management System** è un sistema di gestione per un'azienda ferroviaria, progettato per tenere traccia di tutti gli aspetti legati agli utenti, ai viaggi, ai treni, alle stazioni e alle tratte.

## Struttura del Database

Il database è progettato per memorizzare informazioni dettagliate sugli utenti, suddivisi in clienti e impiegati. Per ogni utente, vengono registrati i dati come nome utente univoco, password, nome, cognome, e-mail, sesso, data di nascita e codice fiscale. I clienti hanno ulteriori informazioni come numeri di telefono e data di iscrizione, mentre gli impiegati hanno dettagli sullo stipendio.

## Acquisto Biglietti e Pagamenti

Il sistema consente ai clienti di acquistare uno o più biglietti per i trasporti. Ogni biglietto è identificato da un codice univoco e registra la data di acquisto. Per effettuare acquisti, i clienti devono inserire una o più carte di credito, anch'esse con un numero univoco e una data di scadenza.

## Gestione dei Viaggi e dei Treni

Ogni biglietto è associato a un viaggio specifico, identificato da un codice, prezzo e posti disponibili. I treni che operano sulla rete sono condotti da macchinisti. Ogni treno ha un codice univoco, una velocità massima e uno o più posti caratterizzati da numeri univoci. I macchinisti sono identificati dal loro stipendio, cognome, nome e codice fiscale.

## Tratte e Stazioni

Il sistema gestisce tratte che collegano stazioni. Ogni stazione è definita da un codice univoco, indirizzo, nome e numero di telefono. Le tratte sono composte da uno o più viaggi e sono gestite da uno o più impiegati.

## Team di sviluppo
- [Daniele Palomba] - Me
- [Filippo Vetrale] - https://github.com/fVetrale
- [Silvestro Ricciardi] - https://github.com/sricciardi16
