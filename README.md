# FasoSkills — Marketplace Connecting Artisans and Clients (T18)

> **Pitch:** FasoSkills is a mobile platform enabling residents in Burkina Faso to quickly find qualified local artisans (plumbers, electricians, carpenters), post service requests, and receive real-time quotes. Powered by WebSockets and a secure, decentralized architecture, clients and artisans can negotiate, exchange instant messages, and formalize their jobs with confidence.

---

## 👥 Team and Roles (Section 2.2)

- **Team Lead:** Overall coordination, issue board, final integration.
- **API Lead:** REST & WebSocket API design, MongoDB data model, security & integration tests.
- **App Lead:** Flutter Clean Architecture, BLoC state management, declarative `go_router` navigation.
- **Quality Lead:** GitHub Actions CI/CD pipeline, linters, unit and integration testing strategy.
- **Product / UX Lead:** User journeys, design system, loading / empty / error states, real-time experience.

---

## 🔗 Project Links

- **Deployed API:** `https://api.fasoskills.bf` (or Render/Railway instance)
- **WebSocket URL:** `wss://api.fasoskills.bf/ws`
- **Release APK:** `docs/releases/fasoskills-v1.0.0.apk`
- **Demo Video (3 min):** `docs/demo-video.mp4`

---

## 🚀 How to Run the Entire Project Locally in Under 10 Minutes

### Prerequisites
- Node.js 24+ and npm
- Flutter 3.24+ (or stable)
- Local MongoDB or MongoDB Atlas URI (optional for tests thanks to `mongodb-memory-server`)

### 1. Start the Backend API (`api/`)

```bash
cd api

# 1. Install dependencies
npm install

# 2. Populate the environment file (already pre-configured by default)
cp .env.example .env

# 3. Seed the database with demo data and test accounts
npm run seed

# 4. Start the API in development mode
npm run dev
```

The API will be running on `http://localhost:8000` and WebSockets on `ws://localhost:8000/ws`.

To run the automated integration test suite:
```bash
npm test
```

### 2. Start the Flutter Mobile App (`app/`)

```bash
cd app

# 1. Fetch packages
flutter pub get

# 2. Check code compliance and run BLoC tests
flutter analyze
flutter test

# 3. Run the app with configuration via --dart-define (Requirement F13)
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api --dart-define=WS_URL=ws://127.0.0.1:8000/ws
```

---

## 🔑 Test Accounts (Seeded via `npm run seed`)

| Role | Email | Password | Description |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@fasoskills.bf` | `Password123!` | Artisan badge verification, moderation |
| **Client** | `client1@fasoskills.bf` | `Password123!` | Post requests, accept quotes |
| **Client** | `client2@fasoskills.bf` | `Password123!` | Rate completed jobs |
| **Artisan** | `artisan1@fasoskills.bf` | `Password123!` | Qualified plumber (Ouagadougou), submit quotes |
| **Artisan** | `artisan2@fasoskills.bf` | `Password123!` | Solar electrician (Bobo-Dioulasso) |
| **Artisan (pending)** | `artisan3@fasoskills.bf` | `Password123!` | Carpenter in Koudougou (pending admin verification) |

---

## 📋 API Endpoints Table (A13)

| Method | Endpoint | Required Role | Success Code | Error Codes | Description / Business Rule |
| :--- | :--- | :--- | :---: | :---: | :--- |
| `POST` | `/api/auth/register` | Public | 201 | 400, 409, 422 | Client or artisan registration |
| `POST` | `/api/auth/login` | Public | 200 | 401, 422 | Login with token pair issuance |
| `POST` | `/api/auth/refresh` | Public | 200 | 401 | Strict refresh token rotation (A6) |
| `POST` | `/api/auth/logout` | Authenticated | 200 | 400 | Session revocation in database |
| `GET` | `/api/auth/me` | Authenticated | 200 | 401 | Authenticated user profile |
| `GET` | `/api/categories` | Public | 200 | - | List of active trade categories (`?includeInactive=true` for Admin) |
| `POST` | `/api/categories` | Admin | 201 | 409, 422 | Create a trade category |
| `PATCH` | `/api/categories/:id` | Admin | 200 | 404, 409, 422 | Update a category (including `isActive`) |
| `DELETE` | `/api/categories/:id` | Admin | 204 | 404, 409 | Delete an unused category |
| `GET` | `/api/artisans` | Public | 200 | 400 | Paginated list, full-text search, and filters |
| `GET` | `/api/artisans/:id` | Public | 200 | 404 | Full artisan details and reviews |
| `PUT` | `/api/artisans/:id` | Artisan/Admin | 200 | 403, 404 | Update own profile only (A7) |
| `POST` | `/api/artisans/:id/verify` | Admin | 200 | 403, 404, 409 | Grant verified badge (T18) |
| `GET` | `/api/admin/stats` | Admin | 200 | 401, 403 | Global metrics & charts (MongoDB aggregation) |
| `GET` | `/api/admin/artisans` | Admin | 200 | 401, 403, 422 | Filtered paginated list (`status=pending\|verified\|all`, `q`) |
| `GET` | `/api/admin/artisans/:id` | Admin | 200 | 401, 403, 404 | Full artisan details & supporting documents |
| `POST` | `/api/admin/artisans/:id/reject` | Admin | 200 | 401, 403, 404, 422 | Verification rejection with reason (`reason`) |
| `GET` | `/api/admin/categories` | Admin | 200 | 401, 403 | Full list of categories (active and inactive) |
| `POST` | `/api/reports` | Client/Artisan | 201 | 401, 404, 422 | Report content (`request`, `review`, `message`) |
| `GET` | `/api/admin/reports` | Admin | 200 | 401, 403, 422 | Paginated list of reports (`type`, `status`) |
| `PATCH` | `/api/admin/reports/:id` | Admin | 200 | 401, 403, 404 | Dismiss / resolve a report |
| `DELETE` | `/api/admin/content/:type/:id` | Admin | 204 | 401, 403, 404 | Delete moderated content with logged reason |
| `GET` | `/api/admin/moderation-logs` | Admin | 200 | 401, 403 | Audit log of moderation actions |
| `GET` | `/api/requests` | Public / Auth | 200 | 400 | Paginated list of requests (`myOnly` filter) |
| `POST` | `/api/requests` | Client | 201 | 401, 422 | Create a request + WebSocket broadcast |
| `PUT` | `/api/requests/:id` | Client/Admin | 200 | 403, 404 | Update own request only |
| `DELETE` | `/api/requests/:id` | Client/Admin | 200 | 403, 404 | Cancel own request |
| `POST` | `/api/quotes` | Artisan | 201 | 403, 409, 422 | Submit a quote for a request |
| `GET` | `/api/quotes/request/:requestId` | Requester / Artisan | 200 | 403, 404 | Only the client can view quotes for their request (T18) |
| `POST` | `/api/quotes/:id/accept` | Client | 200 | 403, 404, 409 | Single-quote acceptance (T18) |
| `POST` | `/api/reviews` | Client | 201 | 403, 409, 422 | Review allowed only for completed jobs (T18) |
| `GET` | `/api/reviews/artisan/:artisanId` | Public | 200 | 404 | List of reviews received by the artisan |
| `GET` | `/api/chat/conversations` | Authenticated | 200 | 401 | List of user conversations |
| `GET` | `/api/chat/conversations/:id/messages` | Participant | 200 | 403, 404 | Message history for a conversation |
| `POST` | `/api/chat/conversations/:id/messages` | Participant | 201 | 403, 404 | Send a message + WebSocket broadcast |
| `WS` | `/ws` | Authenticated | 101 | 401 | Real-time WebSocket connection (quotes, chat, statuses) |

---

## ⚡ Advanced Feature (Section 3.4): Real-Time Updates (WebSockets)

- **Server:** WebSocket server natively integrated into the Express HTTP server (`src/core/websocket/ws-server.ts`), authenticated via JWT token.
- **Channels:** Private user channels (`user:<userId>`) and chat/request rooms (`conversation:<convId>`, `request:<requestId>`).
- **Real-time events:**
  - `quote:received`: Instant notification to the client as soon as an artisan submits a quote.
  - `quote:accepted`: Real-time alert to the artisan when their offer is accepted.
  - `message:received`: Instant delivery of chat messages without reloading.
  - `request:updated`: Synchronized updates of job statuses.

---

## 🛡️ Security and Architecture Rules

1. **No secrets in the repository:** Private keys are injected via environment variables (`.env`), validated at startup by a **Zod** schema.
2. **Object-level authorization (A7):** A client cannot edit or cancel another client's requests; an artisan can only edit their own profile; quotes for a request are visible only to the request's author.
3. **BLoC State Management / Clean Architecture (F1, F2):** Strict separation into `domain` (pure Dart, framework-independent), `data` (repositories, HTTP/WS clients), and `presentation` (BLoCs, screens).
4. **Optimistic updates (F8):** Canceling a request updates the UI immediately with an automatic *rollback* mechanism if the network call fails.
5. **Cache-then-Network strategy (F9):** The artisan feed and categories are cached locally to enable instant startup even offline.
6. **Concurrency-safe token refresh (F6):** When simultaneous 401 errors occur across multiple requests, only a single refresh request is issued; the others wait for its result and are replayed.

---

## ⚠️ Known Limitations

- The geolocation system currently uses city-based filtering (`Ouagadougou`, `Bobo-Dioulasso`, etc.) and text addresses; direct GPS distance calculation via a `2dsphere` index can be extended.
- Photo storage is configured using direct URLs / base64; S3 bucket integration with signed URLs is ready to be plugged in for production.
