// Complete traceability of LOT-101
MATCH (l:Lot {lot_id:"LOT-101"})
OPTIONAL MATCH path = (l)-[:PROVIENT_DE]->(:Arganeraie)-[:LOCALISEE_A]->(:Ville)-[:DANS]->(:Region)
OPTIONAL MATCH (cert:Certification)-[:CERTIFIE]->(l)
OPTIONAL MATCH (c:Cooperative)-[:PRESSE]->(l)
OPTIONAL MATCH (m:Moulin)-[:TRANSFORME]->(l)
OPTIONAL MATCH (lab:Laboratoire)-[:ANALYSE]->(l)
OPTIONAL MATCH (e:Exportateur)-[:ACHETE]->(l)-[:EXPEDIE_DE]->(p:Port)
RETURN l, path, collect(DISTINCT cert) AS certifications, c, m, lab, e, p;

// Shortest path producer → client
MATCH (prod:Producteur {name:"Aicha El Fassi"}),(client:Client {name:"Cosmétiques Lumière"})
MATCH path = shortestPath( (prod)-[*..6]->(client) )
RETURN path;