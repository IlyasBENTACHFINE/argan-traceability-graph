// Lots without any certification
MATCH (l:Lot)
WHERE NOT ( (:Certification)-[:CERTIFIE]->(l) )
RETURN l.lot_id AS lot, l.date_recolte, l.volume_kg;

// Lots analyzed but not pressed/transformed (islands)
MATCH (l:Lot)<-[:ANALYSE]-(:Laboratoire)
WHERE NOT ( (:Cooperative)-[:PRESSE]->(l) OR (:Moulin)-[:TRANSFORME]->(l) )
RETURN l.lot_id AS lot_anormal;