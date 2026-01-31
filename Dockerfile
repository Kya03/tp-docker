#
#    Copyright 2010-2023 the original author or authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

# 1. IMAGE DE BASE
# On utilise une version stable de Java 17 (OpenJDK).
FROM openjdk:17.0.2

# 2. SÉCURITÉ : GESTION DES UTILISATEURS
# 'shadow-utils' est nécessaire pour utiliser 'groupadd' et 'useradd'.
# On crée un utilisateur 'jpetuser' sans privilèges root pour limiter la surface d'attaque.
RUN microdnf install -y shadow-utils && \
    groupadd -r jpetgroup && useradd -r -g jpetgroup jpetuser

# 3. RÉPERTOIRE DE TRAVAIL
# On définit l'endroit où l'application sera installée dans le conteneur.
WORKDIR /usr/src/myapp

# 4. CORRECTION DU BUILD (CONTEXTE)
# On copie les fichiers de configuration Maven en premier. 
# '--chown' permet de donner immédiatement la propriété des fichiers à notre utilisateur sécurisé.
COPY --chown=jpetuser:jpetgroup .mvn/ .mvn/
COPY --chown=jpetuser:jpetgroup mvnw mvnw
COPY --chown=jpetuser:jpetgroup pom.xml pom.xml

# 5. COPIE DU CODE SOURCE
# On copie le reste du projet (le dossier src contenant le code Java).
COPY --chown=jpetuser:jpetgroup src/ src/

# 6. ACTIVATION DE L'UTILISATEUR SÉCURISÉ
# À partir d'ici, Docker n'utilise plus les droits 'root'. 
# Si une faille est exploitée dans l'application, l'attaquant reste bloqué dans ce compte limité.
USER jpetuser

# 7. COMPILATION
# On lance la compilation via le wrapper Maven. 
# C'est ici que le "rouge" de GitHub Actions devient "vert" car tous les fichiers sont présents.
RUN ./mvnw clean package

# 8. LANCEMENT
# Commande finale pour démarrer JPetStore sur le serveur Tomcat 9.
CMD ./mvnw cargo:run -P tomcat90
