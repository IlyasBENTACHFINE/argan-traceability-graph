// Monthly volume per cooperative
MATCH (c:Cooperative)-[:PRESSE]->(l:Lot)
WHERE date.truncate('month', l.date_recolte) = date.truncate('month', date())
RETURN c.name AS cooperative, sum(l.volume_kg) AS volume_kg
ORDER BY volume_kg DESC;

// Origins of lots exported by a specific exporter
MATCH (e:Exportateur {name:"Atlas Argan Export"})-[:ACHETE]->(l:Lot)-[:PROVIENT_DE]->(a:Arganeraie)-[:LOCALISEE_A]->(v:Ville)-[:DANS]->(r:Region)
RETURN r.name AS region, v.name AS ville, count(*) AS nb_lots
ORDER BY nb_lots DESC;

// Bio lots certified by two different orgs
MATCH (l:Lot {bio:true})<-[:CERTIFIE]-(c1:Certification),
      (l)<-[:CERTIFIE]-(c2:Certification)
WHERE id(c1) < id(c2)
RETURN l.lot_id, collect(DISTINCT c1.label)+collect(DISTINCT c2.label) AS labels;