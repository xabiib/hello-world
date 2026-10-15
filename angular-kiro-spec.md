

## Kiro Spec Prompt for Angular Frontend

Open a **new Kiro project** (separate from your Python backend) and use this prompt:

```
Project: [Your App Name] — a professional admin dashboard SPA.

This is a frontend-only Angular application that consumes a Flask REST API.
The backend is already built and running at http://localhost:8000/api.

Tech stack:
- Angular 18+ (standalone components, signals)
- Angular Material (MDC-based)
- TypeScript strict mode
- SCSS
- RxJS for HTTP
- No Angular CLI module-based architecture — standalone only

API Base URL: http://localhost:8000/api (configurable via environment)

Endpoints to consume:
- GET    /api/[resource]        → list (paginated: ?page=1&size=10)
- GET    /api/[resource]/<id>   → single item
- POST   /api/[resource]        → create
- PUT    /api/[resource]/<id>   → update
- DELETE /api/[resource]/<id>   → delete

UI Requirements:
- MatSidenav layout: collapsible sidebar with navigation links per resource
- MatToolbar at top with app title and user avatar placeholder
- Each resource page:
  - MatTable with pagination (MatPaginator), sorting, filtering
  - "Add" button → MatDialog with reactive form for create
  - Row actions: Edit (opens same dialog pre-filled), Delete (MatDialog confirm)
  - Loading spinner (MatProgressSpinner) during HTTP calls
  - Empty state message when no data
- Responsive: sidebar collapses on mobile (MatSidenav responsive)
- Color theme: Material indigo-pink (default) or specify your brand
- Error handling: global HttpInterceptor → MatSnackBar for errors
- Form validation: Angular reactive forms with validators

Architecture:
- /core/        → interceptors, guards, base HTTP service, layout
- /shared/      → reusable components (confirm-dialog, loading, empty-state)
- /features/    → one lazy-loaded module per resource (standalone)
- /models/      → TypeScript interfaces mirroring the API response shapes

Constraints:
- All API calls go through a shared BaseService<T> generic class
- TypeScript interfaces must match the Python model field names exactly
- Lazy-load each feature route
- OnPush change detection on all components
- No third-party UI libraries beyond Angular Material
- Environment files for dev/prod API URLs
```

## Steering File for the Frontend

Create `.kiro/steering/tech.md` in the Angular project:

```markdown
# Tech Stack

- Angular 18+, standalone components, signals
- Angular Material (MDC)
- TypeScript strict
- SCSS
- RxJS + HttpClient
- No NgModules — standalone only
- Lazy-loaded routes per feature

# API Contract

- Base URL from environment: environment.apiUrl
- All responses are JSON
- Errors: { "error": "message" } with proper HTTP status codes
- Pagination: ?page=N&size=M, response includes { "items": [], "total": N, "page": N, "size": M }

# Conventions

- File naming: kebab-case (e.g., item-list.component.ts)
- Component selectors: app-item-list
- Services: injectable, providedIn: 'root' or feature-level
- All HTTP via BaseService<T> generic
- OnPush change detection everywhere
- Reactive forms for all inputs
```

## What Kiro Will Generate

```
your-frontend/
├── src/
│   ├── app/
│   │   ├── core/
│   │   │   ├── interceptors/
│   │   │   │   └── error.interceptor.ts
│   │   │   ├── services/
│   │   │   │   └── base.service.ts          ← generic CRUD HTTP service
│   │   │   └── layout/
│   │   │       └── main-layout.component.ts ← MatSidenav + MatToolbar
│   │   ├── shared/
│   │   │   ├── components/
│   │   │   │   ├── confirm-dialog.component.ts
│   │   │   │   └── empty-state.component.ts
│   │   │   └── models/
│   │   │       └── pagination.ts
│   │   ├── features/
│   │   │   ├── items/
│   │   │   │   ├── item-list.component.ts
│   │   │   │   ├── item-form-dialog.component.ts
│   │   │   │   ├── item.service.ts
│   │   │   │   └── item.model.ts
│   │   │   └── ...
│   │   ├── app.routes.ts
│   │   └── app.component.ts
│   ├── environments/
│   │   ├── environment.ts          ← apiUrl: 'http://localhost:8000/api'
│   │   └── environment.prod.ts
│   └── styles.scss
├── angular.json
├── package.json
└── tsconfig.json
```

## Key Differences from Your Spring Boot World

| Spring Boot | Angular Frontend |
|---|---|
| `@RestController` auto-maps to URL | You define routes in `app.routes.ts` |
| `@RequestBody` auto-deserializes | You define a TypeScript interface + `HttpClient.post<T>(url, body)` |
| `application.yml` → `server.port` | `environment.ts` → `apiUrl` |
| CORS configured on backend | Backend must allow `http://localhost:4200` in CORS (Flask-CORS) |

## Don't Forget: CORS on the Backend

Your Flask app needs this or the browser will block all requests:

```python
# app/__init__.py — inside create_app()
from flask_cors import CORS
CORS(app, origins=["http://localhost:4200"])
```

And add `flask-cors` to your `requirements.txt`.

## Running Both Together

```bash
# Terminal 1 — Backend
cd your-backend
source venv/bin/activate
python wsgi.py
# → http://localhost:8000/api/items

# Terminal 2 — Frontend
cd your-frontend
npm install
ng serve
# → http://localhost:4200
```

Open `http://localhost:4200` in your browser — you'll see the Material dashboard pulling data from your Flask API.

-------

Good call — Angular 21 (released Nov 2025) changes several things from the 18+ prompt. Here's the updated version with 21-specific defaults baked in:

## Updated Kiro Prompt (Angular 21)

```
Project: [Your App Name] — a professional admin dashboard SPA.

This is a frontend-only Angular 21 application that consumes a Flask REST API.
The backend is already built and running at http://localhost:8000/api.

Tech stack:
- Angular 21 (standalone components, zoneless change detection)
- Angular Material (MDC-based)
- TypeScript strict mode
- SCSS
- HttpClient (included by default in Angular 21 — no manual import needed)
- Vitest for testing (default in Angular 21)
- No NgModules — standalone only

API Base URL: http://localhost:8000/api (configurable via environment)

Endpoints to consume:
- GET    /api/[resource]        → list (paginated: ?page=1&size=10)
- GET    /api/[resource]/<id>   → single item
- POST   /api/[resource]        → create
- PUT    /api/[resource]/<id>   → update
- DELETE /api/[resource]/<id>   → delete

UI Requirements:
- MatSidenav layout: collapsible sidebar with navigation links per resource
- MatToolbar at top with app title and user avatar placeholder
- Each resource page:
  - MatTable with pagination (MatPaginator), sorting, filtering
  - "Add" button → MatDialog with reactive form for create
  - Row actions: Edit (opens same dialog pre-filled), Delete (MatDialog confirm)
  - Loading spinner (MatProgressSpinner) during HTTP calls
  - Empty state message when no data
- Responsive: sidebar collapses on mobile (MatSidenav responsive)
- Color theme: Material indigo-pink (default) or specify your brand
- Error handling: global HttpInterceptor → MatSnackBar for errors
- Form validation: Angular reactive forms with validators
  (Note: Signal Forms is experimental in v21 — use classic reactive forms for stability)

Architecture:
- /core/        → interceptors, guards, base HTTP service, layout
- /shared/      → reusable components (confirm-dialog, loading, empty-state)
- /features/    → one lazy-loaded route per resource (standalone)
- /models/      → TypeScript interfaces mirroring the API response shapes

Constraints:
- Zoneless change detection (default in Angular 21, no Zone.js)
- All API calls go through a shared BaseService<T> generic class
- TypeScript interfaces must match the Python model field names exactly
- Lazy-load each feature route
- OnPush change detection on all components
- No third-party UI libraries beyond Angular Material
- Environment files for dev/prod API URLs
- Use Vitest (not Karma/Jasmine) for unit tests
```

## Updated Steering File

```markdown
# Tech Stack

- Angular 21, standalone components, zoneless (no Zone.js)
- Angular Material (MDC)
- TypeScript strict
- SCSS
- HttpClient (default in v21, no provideHttpClient() needed)
- Vitest for testing
- No NgModules — standalone only
- Lazy-loaded routes per feature

# API Contract

- Base URL from environment: environment.apiUrl
- All responses are JSON
- Errors: { "error": "message" } with proper HTTP status codes
- Pagination: ?page=N&size=M, response includes { "items": [], "total": N, "page": N, "size": M }

# Conventions

- File naming: kebab-case (e.g., item-list.component.ts)
- Component selectors: app-item-list
- Services: injectable, providedIn: 'root' or feature-level
- All HTTP via BaseService<T> generic
- OnPush change detection everywhere
- Reactive forms for all inputs (not Signal Forms — still experimental)
- Vitest + vi.mock() for test mocking
```

## What Changed vs. the Angular 18 Prompt

| Aspect | Angular 18 prompt | Angular 21 prompt |
|--------|-------------------|-------------------|
| Change detection | Zone.js based | **Zoneless by default** (no Zone.js) |
| HttpClient | Must `provideHttpClient()` | **Included by default** |
| Test runner | Karma + Jasmine | **Vitest** |
| Forms | Reactive forms | Reactive forms (Signal Forms still experimental) |
| AI tooling | N/A | **MCP Server** (`ng mcp`) available |
| Build | esbuild | esbuild + improved tree-shaking (40% smaller bundles) |

## Bonus: Use Angular's MCP Server with Kiro

Angular 21 ships an official **MCP server** (`ng mcp`). If Kiro supports MCP integration, you can enable it so Kiro gets **context-aware** Angular code generation that follows v21 patterns automatically:

```bash
# In your Angular project folder
ng mcp
```

This gives Kiro access to your project's components, services, and routing — so generated code matches your local patterns instead of generic boilerplate.

   


