// Constraints & indexes
CREATE CONSTRAINT region_name IF NOT EXISTS FOR (r:Region) REQUIRE r.name IS UNIQUE;
CREATE CONSTRAINT ville_name IF NOT EXISTS FOR (v:Ville) REQUIRE v.name IS UNIQUE;
CREATE CONSTRAINT coop_name IF NOT EXISTS FOR (c:Cooperative) REQUIRE c.name IS UNIQUE;
CREATE CONSTRAINT lot_id IF NOT EXISTS FOR (l:Lot) REQUIRE l.lot_id IS UNIQUE;
CREATE INDEX IF NOT EXISTS FOR (p:Port) ON (p.code);

// Regions & Cities
MERGE (souss:Region {name:"Souss-Massa"})
MERGE (marr:Region {name:"Marrakech-Safi"})

MERGE (agadir:Ville {name:"Agadir"})-[:DANS]->(souss)
MERGE (taroudant:Ville {name:"Taroudant"})-[:DANS]->(souss)
MERGE (essaouira:Ville {name:"Essaouira"})-[:DANS]->(marr)
MERGE (marrakech:Ville {name:"Marrakech"})-[:DANS]->(marr)

// Arganeraies (parcels)
MERGE (argA:Arganeraie {id:"ARG-TA-01", superficie_ha:120})-[:LOCALISEE_A]->(taroudant)
MERGE (argB:Arganeraie {id:"ARG-ES-11", superficie_ha:80})-[:LOCALISEE_A]->(essaouira)

// Actors
MERGE (coop1:Cooperative {name:"Targanine", type:"femmes", onssa_id:"ONSSA-COOP-001"})-[:LOCALISEE_A]->(agadir)
MERGE (coop2:Cooperative {name:"Tamnghroute", type:"femmes", onssa_id:"ONSSA-COOP-014"})-[:LOCALISEE_A]->(essaouira)

MERGE (prod1:Producteur {name:"Aicha El Fassi"})-[:APPARTIENT_A]->(coop1)
MERGE (prod2:Producteur {name:"Fatima Ait Elkadi"})-[:APPARTIENT_A]->(coop2)

MERGE (moulin1:Moulin {name:"Moulin Agadir"})-[:LOCALISEE_A]->(agadir)
MERGE (lab1:Laboratoire {name:"Lab QualiPlus"})
MERGE (exp1:Exportateur {name:"Atlas Argan Export"})
MERGE (portCasa:Port {name:"Port de Casablanca", code:"CMN-CASA"})

// Lots & certifications
MERGE (lot101:Lot {lot_id:"LOT-101", date_recolte:date("2025-09-20"), volume_kg:520, bio:true})
MERGE (lot102:Lot {lot_id:"LOT-102", date_recolte:date("2025-09-25"), volume_kg:380, bio:false})

MERGE (certOnssa:Certification {label:"ONSSA", date:date("2025-10-05")})
MERGE (certEco:Certification {label:"ECOCERT", date:date("2025-10-08")})

// Flow links
MERGE (prod1)-[:RECOLTE]->(lot101)
MERGE (lot101)-[:PROVIENT_DE]->(argA)
MERGE (coop1)-[:PRESSE]->(lot101)
MERGE (moulin1)-[:TRANSFORME]->(lot101)
MERGE (lab1)-[:ANALYSE]->(lot101)
MERGE (certOnssa)-[:CERTIFIE]->(lot101)
MERGE (certEco)-[:CERTIFIE]->(lot101)
MERGE (exp1)-[:ACHETE]->(lot101)
MERGE (exp1)-[:EXPEDIE_DE]->(portCasa)

MERGE (prod2)-[:RECOLTE]->(lot102)
MERGE (lot102)-[:PROVIENT_DE]->(argB)
MERGE (coop2)-[:PRESSE]->(lot102)
MERGE (lab1)-[:ANALYSE]->(lot102)
// lot102 left uncertified on purpose

// Clients
MERGE (clientFR:Client {name:"Cosmétiques Lumière", pays:"France"})-[:COMMANDE]->(lot101)
MERGE (clientDE:Client {name:"BioNatur GmbH", pays:"Allemagne"})-[:COMMANDE]->(lot102);