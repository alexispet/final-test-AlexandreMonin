#Récupérer une image node pour le build
FROM node:21.5.0-alpine3.19 AS build

#Copier le projet dans le dossier /app/
COPY . /app/

#Se déplacer dans le dossier /app/ 
WORKDIR /app

#Lancer les commandes de mise en place du projet
RUN npm ci

#Récupérer une image node pour le lancement
FROM node:21.5.0-alpine3.19 AS express

#Lier à l'image de mon compte github
LABEL org.opencontainers.image.source https://github.com/AlexandreMonin/tp-devops

#Se déplacer dans le dossier /app/
WORKDIR /app

#Copier les fichiers du build nécessaire au lancement
COPY --from=build /app/package.json .
COPY --from=build /app/node_modules ./node_modules

#Exposer le port
EXPOSE 3000

#Copier le script et y affecter les droits d'exécution
COPY docker/express/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

#Démarrer le projet
ENTRYPOINT ["docker-entrypoint"]
CMD ["npm", "run", "start"]