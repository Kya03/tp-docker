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


# Utilisation d'une image stable et sécurisée
FROM openjdk:17.0.2

WORKDIR /usr/src/myapp

# SÉCURITÉ : Isolation de l'exécution avec un utilisateur non-privilégié
RUN useradd -m jpetuser && chown -R jpetuser:jpetuser /usr/src/myapp

# Copie des sources
COPY --chown=jpetuser:jpetuser . .

# Droits d'exécution pour Maven
RUN chmod +x mvnw

USER jpetuser

# Compilation (les tests sont délégués au workflow pour plus de stabilité)
RUN ./mvnw clean package -DskipTests

# Lancement de l'application
CMD ["./mvnw", "cargo:run", "-P", "tomcat90"]