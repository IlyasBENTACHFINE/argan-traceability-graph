# 🌿 Moroccan Argan Oil Traceability Graph (Neo4j)

A real-world **graph database** modeling the **argan oil value chain in Morocco** —
from producers and cooperatives to export and clients.

## 🧩 Overview

This dataset demonstrates how graph databases can ensure **traceability, transparency, and quality assurance** in the Moroccan argan oil sector.

### Entities (Nodes)
- `Region`, `Ville`, `Arganeraie`
- `Producteur`, `Cooperative`, `Moulin`, `Laboratoire`
- `Lot`, `Certification`, `Exportateur`, `Client`, `Port`

### Relationships
- `(:Lot)-[:PROVIENT_DE]->(:Arganeraie)`
- `(:Producteur)-[:APPARTIENT_A]->(:Cooperative)`
- `(:Cooperative)-[:PRESSE]->(:Lot)`
- `(:Certification)-[:CERTIFIE]->(:Lot)`
- `(:Exportateur)-[:ACHETE]->(:Lot)`
- `(:Client)-[:COMMANDE]->(:Lot)`

---

## 🚀 Quick Start

### Option 1: Run with Docker (recommended)
```bash
docker compose up -d
# or:
# docker run -p7474:7474 -p7687:7687 #   -e NEO4J_AUTH=neo4j/test #   -e NEO4JLABS_PLUGINS='["apoc","graph-data-science"]' #   neo4j:5.22
```

Open Neo4j Browser → http://localhost:7474  
Login: `neo4j / test`

**Load data using cypher-shell (inside the container):**
```bash
docker exec -it argan-neo4j cypher-shell -u neo4j -p test -f /data/argan_neo4j.cypher
```

If you ran with `docker compose`, use:
```bash
docker compose exec neo4j cypher-shell -u neo4j -p test -f /data/argan_neo4j.cypher
```

Then try example queries from the `queries/` folder.

---

## 📊 Example Queries

**Complete traceability of a lot**
```cypher
MATCH (l:Lot {lot_id:"LOT-101"})
OPTIONAL MATCH path = (l)-[:PROVIENT_DE]->(:Arganeraie)-[:LOCALISEE_A]->(:Ville)-[:DANS]->(:Region)
OPTIONAL MATCH (cert:Certification)-[:CERTIFIE]->(l)
OPTIONAL MATCH (c:Cooperative)-[:PRESSE]->(l)
OPTIONAL MATCH (m:Moulin)-[:TRANSFORME]->(l)
OPTIONAL MATCH (lab:Laboratoire)-[:ANALYSE]->(l)
OPTIONAL MATCH (e:Exportateur)-[:ACHETE]->(l)-[:EXPEDIE_DE]->(p:Port)
RETURN l, path, collect(DISTINCT cert) AS certifications, c, m, lab, e, p;
```

**Lots without certification**
```cypher
MATCH (l:Lot)
WHERE NOT ( (:Certification)-[:CERTIFIE]->(l) )
RETURN l.lot_id AS lot, l.date_recolte, l.volume_kg;
```

**Top cooperative volumes (current month)**
```cypher
MATCH (c:Cooperative)-[:PRESSE]->(l:Lot)
WHERE date.truncate('month', l.date_recolte) = date.truncate('month', date())
RETURN c.name AS cooperative, sum(l.volume_kg) AS volume_kg
ORDER BY volume_kg DESC;
```

---

## 🧠 Future Extensions
- Add logistics & transport relations
- Integrate ONSSA quality data
- Run community detection with Neo4j GDS

---

## 📜 License
MIT License — you are free to use, modify, and share with attribution.