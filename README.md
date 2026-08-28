# velos-api

API de suivi des stations de velos en libre-service d'une communaute de communes.

## Routes disponibles

- `/sante` : etat de sante de l'application
- `/stations` : liste des stations avec quartier et velos disponibles
- `/disponibilite` : taux d'occupation moyen du parc

## Source des donnees

L'application lit PostgreSQL si `DATABASE_URL` est definie, sinon elle utilise
un jeu de donnees de secours en memoire.
