# PLAN DE RÉPARTITION DES TÂCHES — PROJET FASOSKILLS (T18)
## Analyse du Problème et Solution de Rééquilibrage
**Cours :** Advanced Mobile Development – Year 3 (BIT)  
**Enseignant référent :** Dr Lebian Wilfried NIKIEMA  
**Équipe :** Cédric, Aman, Prisca, Grace  

---

## 1. Pourquoi la situation actuelle pose un problème critique ?

La répartition initiale :
- **Cédric** : Frontend Client + Frontend Agent (Artisan)
- **Aman** : Frontend Administrateur + Backend *uniquement* Administrateur

### 🚨 Les 3 Anomalies Majeures :
1. **Le cœur de l'application n'a PAS de Backend :**  
   Si Aman ne code que le Backend Administrateur (catégories, validation de profil), **qui code le Backend des Clients et des Artisans** ?  
   Les fonctionnalités centrales du sujet T18 :
   - Recherche et géolocalisation des artisans,
   - Création et publication d'une demande de travaux (`jobRequests`),
   - Soumission de devis chiffrés par les artisans (`quotes`),
   - Acceptation d'un seul devis avec verrouillage atomique,
   - Avis et notation des artisans après intervention (`reviews`),
   - Messagerie en direct (chat / WebSocket).  
   Sans ces endpoints, l'application mobile de Cédric reste une coquille vide avec des données fictives !

2. **Le piège de la note individuelle de Dr NIKIEMA (Facteur individuel = 0) :**  
   Dans son *Project Book* (pages 3 et 16), l'enseignant a écrit noir sur blanc :  
   > *« Roles are a way to share responsibility, not to split knowledge. **Every member must write code in both the API and the app**, and must be able to explain the whole project during the defence. A student who contributed no code, or who cannot explain any part of the project, receives an individual factor close to 0. »*  
   - Si Cédric ne présente **aucun code sur l'API**, le jury va le sanctionner lors des questions backend.
   - Si Aman ne présente **aucun code sur l'application mobile Client/Artisan**, il ne pourra pas répondre aux questions d'architecture Flutter.

3. **Déséquilibre massif de charge :**  
   Cédric a abattu plus de 80% du travail d'interface mobile (plus de 10 écrans Flutter complets), alors que la partie administration d'Aman ne représente que 15% à 20% du système.

---

## 2. La Solution de Rééquilibrage Immédiate

Pour garantir la complétude du projet et la note maximale à chaque membre :

### 1. AMAN prend en charge le Backend Métier Complet (en plus de l'Admin) :
Aman ne peut pas s'arrêter au Backend Admin. En tant que lead Backend, il prend la responsabilité de :
- L'API des Demandes d'intervention (`api/src/modules/requests/`).
- L'API des Devis d'artisans (`api/src/modules/quotes/`).
- L'API des Notations / Avis clients (`api/src/modules/reviews/`).
- La mise en œuvre des règles de sécurité serveur obligatoires (Contrôle BOLA, acceptation atomique d'un seul devis).
- La suite de tests d'intégration API (`supertest`).

### 2. CÉDRIC prend la responsabilité du Backend Temps Réel (WebSockets) :
Pour que Cédric respecte la règle obligatoire de Dr Nikiema (*« code in both API and app »*) sans surcharger son travail :
- Cédric prend la paternité du **Serveur WebSocket et de la messagerie (`ws-server.ts` et `api/src/modules/chat/`)**.
- Cela correspond directement à l'écran de chat en direct qu'il a déjà développé sur Flutter.
- C'est la **Fonctionnalité Avancée** du sujet, valorisée à **5 points au barème**.

### 3. PRISCA & GRACE (si présentes) complètent le dispositif :
- **Prisca (Quality Lead) :** Tests d'intégration API pour les cas limites, vérification des 4 états UI sur mobile, pilotage du pipeline CI/CD GitHub Actions.
- **Grace (Product Lead) :** Jeu de données pour le seed (`seed.ts`), rédaction du Design Document M1 (`docs/design.pdf`), du Rapport Final M4 (`docs/report.pdf`, 10–15 p.) et des slides de soutenance.

---

## 3. Tableau Récapitulatif Rééquilibré

| Membre | Rôle Officiel | Partie Frontend (Flutter / Web) | Partie Backend (API Node.js / Mongo) | Livrables Personnels à Défendre |
| :--- | :--- | :--- | :--- | :--- |
| **CÉDRIC** | **App Lead & UX Specialist** | **Tout le Frontend Client & Artisan** : Accueil, carrousel, recherche, profils, nouvelle demande, chat, notifications. | **Backend Temps Réel WebSockets & Chat** : Serveur WS, événements `message:received` et `quote:received`. | Intégration BLoC (optimistic update), architecture Flutter, tests BLoC, build Release APK. |
| **AMAN** | **API Lead & Security Lead** | **Frontend Administration** : Dashboard web/mobile et modération des artisans. | **Tout le Backend Métier & Sécurité** : Demandes, Devis, Avis, Admin, règles BOLA, hachage bcrypt, JWT. | Modèle MongoDB, sécurité OWASP, tests d'intégration API Supertest, déploiement Cloud. |
| **PRISCA** | **Quality Lead & Métier** | **Recette UI Mobile** : Contrôle des 4 états UI (loading, empty, error, loaded) sur mobile réel. | **Validation Règles Métier** : Tests des cas limites API (rejet 2nd devis, BOLA). | Recette fonctionnelle de bout en bout, pipeline GitHub Actions vert. |
| **GRACE** | **Product & Release Lead** | **Supports Démo** : Scénario live 2 rôles (Client + Artisan), vidéo démo 3 min. | **Dataset de Test** : Données réalistes pour le seed burkinabè (`seed.ts`). | Design Doc M1 (`docs/design.pdf`), Rapport M4 (`docs/report.pdf`), Slides soutenance. |

---

## 4. Répartition Chronométrée pour la Soutenance (25 Minutes)

- **00:00 – 03:00 (3 min) : Setup**  
  Cédric connecte le smartphone physique au vidéoprojecteur ; Aman vérifie la connexion à l'API déployée.
- **03:00 – 10:00 (7 min) : Présentation Slides (Chaque membre parle)**  
  - *Grace :* Contexte local T18 au Burkina Faso, personas et objectifs.
  - *Aman :* Architecture API en couches, modèle MongoDB, sécurité OWASP et BOLA.
  - *Cédric :* Clean Architecture Flutter, gestion d'état BLoC, UX Client/Artisan.
  - *Prisca :* Stratégie de tests, résilience réseau (optimistic rollback), CI/CD.
- **10:00 – 17:00 (7 min) : Démonstration en Direct (Multi-rôles)**  
  1. Cédric (Client) publie une nouvelle demande de plomberie avec photos sur son iPhone.
  2. Aman (Artisan) reçoit la demande et propose un devis chiffré.
  3. Cédric reçoit l'alerte en direct via WebSocket et accepte le devis.
  4. Aman montre le tableau de bord Admin pour valider le badge de l'artisan.
- **17:00 – 25:00 (8 min) : Questions Individuelles du Jury**  
  Réponses individuelles ciblées posées par Dr NIKIEMA.
