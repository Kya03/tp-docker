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



# ÉTAPE 1 : Build et Tests (Image complète)
# On utilise 'maven' qui contient déjà Java et tous les outils de build
FROM maven:3.8.4-openjdk-17 AS build

# Installation de Chromium pour les tests Selenium (sur Debian)
RUN apt-get update && apt-get install -y chromium chromium-driver

WORKDIR /usr/src/myapp
COPY . .

# Configuration pour les tests sans interface
ENV SELENIDE_BROWSER=chrome
ENV SELENIDE_HEADLESS=true

# Compilation ET exécution des tests (le build échouera si les tests ratent)
RUN ./mvnw clean package

# ÉTAPE 2 : Image finale (Légère et sécurisée)
FROM openjdk:17.0.2
WORKDIR /usr/src/myapp

# SÉCURITÉ : Utilisateur non-privilégié
RUN useradd -m jpetuser && chown -R jpetuser:jpetuser /usr/src/myapp

# On ne copie QUE le fichier JAR compilé de l'étape 1
COPY --from=build --chown=jpetuser:jpetuser /usr/src/myapp/target/*.war ./app.war

USER jpetuser
# On lance directement l'application
CMD ["java", "-jar", "./app.war"]