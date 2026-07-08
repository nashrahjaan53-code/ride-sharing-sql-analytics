# Ride-Sharing Analytics Database (MySQL)

A full backend database for a ride-sharing platform (like Uber/Lyft)  modeling drivers, riders, locations, rides, and ratings  with analytical reporting, reusable views, and stored procedures built to power a real operations dashboard.

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)

---

##  Why This Project

This project goes beyond writing SELECT queries against a fixed dataset it demonstrates the full range of what a database engineer actually builds: a schema with real constraints, **reusable views** for recurring reports, and **parameterized stored procedures** for on-demand lookups (the kind of thing an actual application backend would call).

---

##  Database Schema

5 tables modeling a ride-sharing platform:

| Table | Purpose |
|---|---|
| `drivers` | Driver profiles, vehicle type, rating, active status |
| `riders` | Rider profiles, preferred payment method, loyalty points |
| `locations` | Named locations with lat/long coordinates and zone classification (Downtown, Airport, University, etc.) |
| `rides` | Core ride records — pickup/dropoff, status, distance, duration, fare, surge pricing |
| `ride_ratings` | Two-way ratings and feedback (driver rates rider, rider rates driver) |

**Design decisions worth calling out:**
- `CHECK` constraints enforce valid ranges directly at the database level (ratings between 1–5, positive distance/fare/duration, valid latitude/longitude ranges) data integrity isn't left to the application layer
- Geospatial-style data (`latitude`/`longitude` + `zone` classification) enables zone-to-zone demand analysis, not just point-to-point
- `surge_multiplier` field models real dynamic pricing behavior

---

##  What the Analysis Covers

- **Overall ride analytics** :-total rides, revenue, average fare/distance/duration, fare-per-km
- **Daily & hourly ride patterns** :- demand by hour of day, including an ASCII bar-chart visualization directly in SQL output
- **Driver performance analysis** :- earnings, average rating, rides completed per driver
- **Spatial/zone analysis** :- pickup and dropoff activity by zone, plus zone-to-zone route demand
- **Top 5 popular routes** :- most frequent pickup→dropoff pairs
- **Payment method breakdown** :- transaction volume and value by payment type
- **Data quality checks** :- flags invalid ride times, non-positive fares/distances, and rating coverage percentage

### Views (reusable, queryable like tables)
- `daily_performance_dashboard` :- daily rides, revenue, active drivers/riders, average wait time
- `driver_earning_summary` :- per-driver completed rides, earnings, and average rating
- `hotspot_locations` :- pickup/dropoff/total activity per location

### Stored Procedures (parameterized, callable on demand)
- `GetRiderHistory(rider_id)` :- full ride history for a specific rider
- `CalculateDriverEarnings(driver_id, start_date, end_date)` :- earnings summary for a driver over a custom date range

---

##  Techniques Used

- `CREATE VIEW` / `CREATE OR REPLACE VIEW` for reusable reporting layers
- `DELIMITER`-based stored procedures with `IN` parameters
- `CHECK` constraints for data validation at the schema level
- Self-joins on the `locations` table (pickup vs. dropoff, zone-to-zone analysis)
- `CASE WHEN` inside aggregates for conditional counting (e.g. pickup vs. dropoff activity in one query)
- `TIMESTAMPDIFF` for wait-time calculations
- `COALESCE` to handle drivers with zero completed rides gracefully in aggregates

---

##  How to Run

1. Open `ride_sharing_analytics.sql` in MySQL Workbench
2. Run the full script (⚡)  it creates the database, schema, seed data, then runs through all analysis sections, views, and stored procedure calls in order
3. To query the views directly afterward: `SELECT * FROM daily_performance_dashboard;`
4. To call a procedure directly: `CALL GetRiderHistory(1);`

---

## 🔗 Connect

[LinkedIn](https://www.linkedin.com/in/nashrah-khan-82056b332)
