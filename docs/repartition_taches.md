# PLAN DE RÉPARTITION DES TÂCHES & LIVRABLES
## Projet T18 — HomeService : FasoSkills (Marketplace d'Artisans Locaux)
**Cours :** Advanced Mobile Development – Year 3 (BIT)  
**Enseignant référent :** Dr Lebian Wilfried NIKIEMA  
**Équipe :** Cédric, Aman, Prisca, Grace  

---

## 1. Contexte & État d'Avancement Réel

Conformément à l'avancement effectif de l'équipe :
- **CÉDRIC** a conçu et implémenté l'intégralité du **Frontend Mobile Flutter pour l'Espace Client et l'Espace Artisan/Agent** :
  - Accueil FasoSkills avec carrousel 3 cartes auto-scrollant.
  - Section dynamique des artisans disponibles remplaçant « Recent Projects ».
  - Page dédiée de listing des professionnels avec filtres par catégorie et recherche.
  - Page de profil détaillée d'un artisan (onglets À propos, Services & Tarifs, Portfolio, Avis clients).
  - Écran « Nouvelle demande » conforme à la maquette (catégories avec icônes, date, créneau horaire, budget indicatif).
  - Onglet « Discussions » et écran de messagerie/chat en direct.
  - Écran dédié aux notifications système et chantiers.
- **AMAN** a développé le **Frontend pour l'Administration** (Dashboard web/mobile) et le **Backend API exclusivement côté Administration** (gestion des utilisateurs, modération des catégories, validation des badges certifiés).
- **PRISCA et GRACE** complètent l'équipe pour assurer la conformité aux exigences strictes du *Project Book* de Dr NIKIEMA (règles métier serveur T18, tests d'intégration, recette, documentation et livrables de soutenance).

> [!WARNING] Règle stricte de Dr Lebian Wilfried NIKIEMA (*Project Book*, pages 3 et 16)
> *« Roles are a way to share responsibility, not to split knowledge. **Every member must write code in both the API and the app**, and must be able to explain the whole project during the defence. A student who contributed no code, or who cannot explain any part of the project, receives an individual factor close to 0, whatever the group grade. »*  
> Chaque membre doit impérativement avoir des contributions de code visibles sur Git et rédiger son **paragraphe individuel obligatoire** dans le rapport final (Milestone 4).

---

## 2. Répartition Opérationnelle des Rôles & Tâches

### 👤 CÉDRIC — *App Lead & UX Specialist*
- **Frontend Mobile (Déjà achevé) :**
  - Architecture complète des vues Client et Artisan (`home_screen`, `artisans_list_screen`, `artisan_detail_screen`, `request_quote_screen`, `discussions_list_screen`, `chat_detail_screen`, `notifications_screen`).
- **Intégration BLoC & State Management :**
  - Relier les interfaces Flutter aux contrats de repositories (`ArtisanRepositoryImpl`, `RequestRepositoryImpl`, `ChatRepositoryImpl`).
  - Implémenter le comportement BLoC avec mise à jour optimiste et *rollback* automatique (`RequestBloc` - Exigence F8).
  - Implémenter le debounce (300 ms) sur la recherche d'artisans (`ArtisanListBloc`).
- **Code Backend API (Exigence prof) :**
  - Finaliser le contrôleur et service WebSocket pour la messagerie instantanée (`api/src/modules/chat/` et `ws-server.ts`).
- **Tests & Packaging Mobile :**
  - Écrire les tests unitaires et de BLoC Flutter (`app/test/bloc_test.dart`).
  - Générer le build Release APK testé sur appareil réel (`v1.0.0`).
  - Tourner la vidéo de démonstration de 3 minutes.
  - Rédiger son paragraphe individuel dans `docs/report.pdf`.

---

### 👤 AMAN — *API Lead & Security Lead*
- **Administration (Déjà achevé) :**
  - Frontend du tableau de bord Admin.
  - Endpoints Backend d'administration : gestion des comptes, modération des catégories et validation du badge « Artisan Vérifié ».
- **Logique Métier Serveur T18 :**
  - Finaliser les services et contrôleurs backend pour les demandes (`jobRequests`) et devis (`quotes`).
  - Implémenter les règles serveur strictes du sujet T18 :
    1. **BOLA / Broken Object Level Authorization :** Seul le client auteur voit les devis de sa demande.
    2. **Atomicité :** Un seul devis accepté par demande (rejet immédiat de toute tentative concurrente).
    3. **Avis vérifiés :** Dépôt d'avis restreint aux seules interventions passées à l'état `completed`.
- **Code App Mobile (Exigence prof) :**
  - Intégrer l'écran / bouton mobile de modération admin dans l'application Flutter.
- **Sécurité, Tests & Déploiement :**
  - Écrire les tests d'intégration API (`supertest`) dans `api/test/` (auth, RBAC, BOLA).
  - Déployer l'API en ligne (Render/Railway/VPS) avec le script de seed (`npm run seed`).
  - Rédiger la section Sécurité / OWASP du rapport final et son paragraphe individuel.

---

### 👤 PRISCA — *Quality Lead & Business Rules Specialist*
- **Cadrage Fonctionnel & Recette :**
  - Cartographie exhaustive des transitions d'état d'un chantier (`pending` ➔ `quoted` ➔ `accepted` ➔ `completed` ➔ `reviewed`).
  - Vérification de la prise en compte des 4 états UI obligatoires sur chaque écran mobile (Chargement, Vide, Erreur avec réessai, Données chargées).
- **Tests & Assurance Qualité :**
  - Participer à la rédaction des tests d'intégration API pour les cas limites (rejet d'un 2ème devis, tentative de notation frauduleuse).
  - Exécuter le plan de recette fonctionnelle de bout en bout (Client ➔ Artisan ➔ Admin).
  - Superviser le pipeline CI/CD GitHub Actions (`.github/workflows/ci.yml`) pour garantir une intégration verte continue.
  - Rédiger son paragraphe individuel dans `docs/report.pdf`.

---

### 👤 GRACE — *Product Lead & Documentation Specialist*
- **Données Produit & Seed :**
  - Élaborer et enrichir le jeu de données burkinabè réaliste pour le seed (quartiers de Ouaga, corps de métiers, tarifs indicatifs, comptes de test).
- **Livrables Documentaires & Soutenance :**
  - Compiler et mettre en page le **Design Document M1** (`docs/design.pdf`, 6 à 10 pages).
  - Rédiger et consolider le **Rapport Final d'Ingénierie M4** (`docs/report.pdf`, 10 à 15 pages) incluant les captures d'écran et les contributions de chaque membre.
  - Réaliser les slides de présentation pour la soutenance (`docs/slides.pdf`).
  - Vérifier l'historique Git pour garantir l'absence totale de clés d'API commises (`git log -p`).
  - Coordonner les répétitions chronométrées de la soutenance (25 minutes).
  - Rédiger son paragraphe individuel dans `docs/report.pdf`.

---

## 3. Matrice d'Évaluation & Barème (100 Points)

| Domaine évalué par Dr NIKIEMA | Poids | Livrable technique concret | Responsables |
| :--- | :---: | :--- | :--- |
| **Sécurité API** | 15 pts | JWT rotation, hachage bcrypt, contrôle BOLA strict, RBAC, rate-limiting | **Aman** (lead) + Cédric |
| **Architecture App Flutter** | 15 pts | Clean Architecture, injection `get_it`, contrats repositories, `go_router` guards | **Cédric** (lead) + Grace |
| **Gestion d'état BLoC** | 10 pts | `RequestBloc` (optimistic update & rollback), `ArtisanListBloc` (debounce 300ms) | **Cédric** (lead) + Prisca |
| **Tests & CI/CD** | 10 pts | Tests d'intégration API (`supertest`), tests de BLoC (`bloc_test`), GitHub Actions vert | **Aman & Prisca** |
| **Produit & UX** | 10 pts | Complétude des fonctionnalités T18, mode hors-ligne (*Cache-then-network*), design pro | **Cédric** (lead) + Grace |
| **Fonctionnalité Avancée** | 5 pts | WebSockets temps réel (alertes devis et chat direct) | **Cédric & Aman** |
| **Documentation & Rapport** | 10 pts | Design doc M1 (`docs/design.pdf`), README (&lt; 10 min), Rapport final M4 (`docs/report.pdf`) | **Grace** (lead) + Équipe |
| **Soutenance (25 min)** | 10 pts | 3 min setup + 7 min slides (tous parlent) + 7 min démo live multi-rôles + 8 min questions | **Toute l'équipe** |
| **Bonus (+5 max)** | +5 pts | Version Web déployée, tests end-to-end supplémentaires, UX exceptionnelle | **Cédric & Aman** |

---

## 4. Organisation de la Soutenance (25 Minutes Chronométrées)

| Créneau | Phase | Intervenants | Contenu & Rôles |
| :---: | :--- | :--- | :--- |
| **00:00 – 03:00** | Installation & Setup | Cédric & Aman | Connexion du smartphone au vidéoprojecteur, validation de l'API déployée en ligne et de la base seedée. |
| **03:00 – 10:00** | Présentation Slides (7 min) | **Les 4 membres** (~1m45 chacun) | • **Grace :** Problème local T18 au Burkina Faso, personas et valeur ajoutée.<br>• **Aman :** Architecture API, modèle MongoDB, sécurité OWASP & BOLA.<br>• **Cédric :** Clean Architecture Flutter, BLoC, UX des flux Client & Artisan.<br>• **Prisca :** Stratégie de tests, résilience réseau et pipeline CI/CD. |
| **10:00 – 17:00** | Démo Live Multi-Rôles (7 min) | Cédric (Client) & Aman (Artisan / Admin) | **Scénario réaliste en direct :**<br>1. Cédric crée une « Nouvelle demande » de plomberie sur son iPhone.<br>2. Aman reçoit la demande en tant qu'Artisan et envoie un devis chiffré.<br>3. Notification WebSocket reçue en direct sur l'iPhone de Cédric, acceptation du devis.<br>4. Aman présente le dashboard Admin pour valider le badge « Artisan Certifié ». |
| **17:00 – 25:00** | Questions du Jury (8 min) | Réponses individuelles ciblées | Questions de code en direct posées par Dr NIKIEMA (gestion de concurrence token refresh 401, transaction MongoDB, rollback BLoC, etc.). |
