Build a [your app name] — a web application that [one-line purpose].

Technology stack:
- Language: Python 3.12+
- Web framework: Flask (application factory pattern)
- Database: SQLite via SQLAlchemy ORM
- Frontend: [Jinja2 templates / REST API only / etc.]

Key features:
- [Feature 1: e.g., "Users can register and log in"]
- [Feature 2: e.g., "Users can create, read, update, delete X records"]
- [Feature 3: ...]

Constraints:
- Single SQLite file for storage (no external DB server)
- Use Flask-SQLAlchemy with migrations (Flask-Migrate)
- Application factory pattern (create_app in app/__init__.py)
- Blueprints for route grouping
- Environment-based config (dev/test/prod)   

Pro Tip: Add a Steering File for Consistency
Create .kiro/steering/tech.md in your project so Kiro always remembers your stack across every spec session:

# Tech Stack

- Python 3.12+, Flask, SQLAlchemy, SQLite
- Application factory pattern (create_app)
- Blueprints for routes
- Flask-Migrate for DB migrations
- pytest for testing
- No external database server   

-----------
# Get the full schema (CREATE TABLE statements, indexes, FKs)
sqlite3 your_database.db .schema > schema.sql   

I have an existing SQLite database. Here is its schema:

[schema.sql contents pasted here]

Build a Flask REST API (application factory pattern) that exposes CRUD 
endpoints for each table. Use Flask-SQLAlchemy with the existing database 
file as the data source (do NOT create new tables).

Database file: ./data/myapp.db   
--------
pip install sqlacodegen

# Generates SQLAlchemy model classes from your existing DB
sqlacodegen sqlite:///your_database.db > models.py   

-----

Recommended Workflow
Step	Action
1	sqlite3 your.db .schema > schema.sql
2	sqlacodegen sqlite:///your.db > models.py
3	Drop both files into your Kiro project folder
4	Prompt Kiro: "Build a Flask API using the factory pattern. Models are in models.py (already generated from the existing DB). Expose CRUD for each table. Point SQLALCHEMY_DATABASE_URI to ./data/your.db. Do not call db.create_all()."

------
Since the tables already exist, you must tell Kiro:

"The database already exists with all tables created. Use db.create_all() only as a no-op safety check, or skip it entirely. The app should read and write to the existing schema, not create a new one."

Without this, Kiro might generate a fresh schema that conflicts with your existing file.