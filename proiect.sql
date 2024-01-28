CREATE TABLE ClientiLibrarie(
    idClient NUMBER(3) PRIMARY KEY,
    numeClient VARCHAR2(50) NOT NULL,
    prenumeClient VARCHAR2(50) NOT NULL,
    adresaLivrare VARCHAR2(100) NOT NULL,
    telefon VARCHAR2(15) NOT NULL ,
    email VARCHAR2(100) NOT NULL,
    
    CONSTRAINT CH_TELEFON_CLIENTI CHECK(LENGTH(telefon) = 10 AND telefon LIKE '07%' AND telefon NOT LIKE '%[^0-9]%'),
    CONSTRAINT CH_EMAIL_CLIENTI CHECK(email LIKE '%@%.com'),
    CONSTRAINT UQ_TELEFON_CLIENTI UNIQUE(telefon),
    CONSTRAINT UQ_EMAIL_CLIENTI UNIQUE(email)
);
CREATE TABLE FurnizoriLibrarie (
    idFurnizor NUMBER(3) PRIMARY KEY,
    numeFurnizor VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    telefon VARCHAR2(15) NOT NULL,
    
    CONSTRAINT CH_TELEFON_FURNIZORI CHECK(LENGTH(telefon) = 10 AND telefon LIKE '07%' AND telefon NOT LIKE '%[^0-9]%'),
    CONSTRAINT CH_EMAIL_FURNIZORI CHECK(email LIKE '%@%.com'),
    CONSTRAINT UQ_TELEFON_FURNIZORI UNIQUE(telefon),
    CONSTRAINT UQ_EMAIL_FURNIZORI UNIQUE(email)
);
CREATE TABLE ProduseLibrarie (
    idProdus NUMBER(3) PRIMARY KEY,
    idFurnizor NUMBER(3),
    numeProdus VARCHAR2(100),
    tipProdus VARCHAR2(50),
    pret NUMBER(8,2),
    stoc NUMBER(4),
    
    CONSTRAINT FK_ID_FURNIZORI FOREIGN KEY (idFurnizor) REFERENCES FurnizoriLibrarie(idFurnizor),
    CONSTRAINT NN_PRET CHECK(pret IS NOT NULL),
    CONSTRAINT NN_STOC CHECK(stoc IS NOT NULL),
    CONSTRAINT NN_NUME_PRODUS CHECK(numeProdus IS NOT NULL),
    CONSTRAINT NN_TIP_PRODUS CHECK(tipProdus IS NOT NULL)
);
CREATE TABLE ComenziLibrarie (
    idComanda NUMBER(4) PRIMARY KEY,
    idClient NUMBER(3),
    modalitateLivrare VARCHAR2(50),
    
    CONSTRAINT FK_ID_CLIENT FOREIGN KEY (idClient) REFERENCES ClientiLibrarie(idClient),
    CONSTRAINT NN_MODALITATE_LIVRARE CHECK(modalitateLivrare IS NOT NULL)
);

CREATE TABLE ProduseComenziLibrarie (
    idProduseComenziLibrarie NUMBER(3) PRIMARY KEY,
    idComanda NUMBER(4),
    idProdus NUMBER(3),
    cantitate NUMBER(10),
    
    CONSTRAINT FK_ID_COMANDA FOREIGN KEY (idComanda) REFERENCES ComenziLibrarie(idComanda),
    CONSTRAINT FK_ID_PRODUS FOREIGN KEY (idProdus) REFERENCES ProduseLibrarie(idProdus),
    CONSTRAINT NN_CANTITATE CHECK(cantitate IS NOT NULL)
);

CREATE TABLE FacturiLibrarie (
    idFactura NUMBER(4) PRIMARY KEY,
    idProduseComenziLibrarie NUMBER(4),
    dataFactura DATE,
    metodaPlata VARCHAR2(50),
    
    CONSTRAINT FK_ID_PRODUSE_COMENZI FOREIGN KEY (idProduseComenziLibrarie) REFERENCES ProduseComenziLibrarie(idProduseComenziLibrarie),
    CONSTRAINT NN_METODA_PLATA CHECK(metodaPlata IS NOT NULL)
);

ALTER TABLE ProduseLibrarie ADD CONSTRAINT CH_PRODUSE CHECK (tipProdus IN ('carte', 'papetarie', 'reviste', 'decoratiuni','boardgames'));
ALTER TABLE ComenziLibrarie ADD CONSTRAINT CH_Comenzi CHECK (modalitateLivrare IN ('ridicare magazin', 'posta', 'curier'));
ALTER TABLE FacturiLibrarie ADD CONSTRAINT CH_FACTURI CHECK (metodaPlata IN ('cash', 'card'));

ALTER TABLE ClientiLibrarie MODIFY adresaLivrare VARCHAR2(200);

ALTER TABLE ClientiLibrarie DISABLE CONSTRAINT NN_SUMA;
ALTER TABLE ClientiLibrarie ENABLE CONSTRAINT NN_SUMA;

ALTER TABLE ClientiLibrarie ADD cnp NUMBER(13);
ALTER TABLE ClientiLibrarie ADD CONSTRAINT CK_CNP CHECK (LENGTH(cnp=13));
ALTER TABLE ClientiLibrarie ADD CONSTRAINT UK_CNP UNIQUE(cnp);
ALTER TABLE ClientiLibrarie DROP CONSTRAINT CK_CNP;
ALTER TABLE ClientiLibrarie DROP COLUMN cnp;

ALTER TABLE ClientiLibrarie ADD linkFacebook VARCHAR2(200);
ALTER TABLE ClientiLibrarie ADD CONSTRAINT CK_FACEBOOK 
CHECK(linkFacebook LIKE 'https://www.facebook.com/profile.php?id=$' 
AND linkFacebook NOT LIKE '%[^0-9]');
ALTER TABLE ClientiLibrarie ADD CONSTRAINT UK_FACEBOOK UNIQUE(linkFacebook);
ALTER TABLE ClientiLibrarie DROP CONSTRAINT UK_FACEBOOK;
ALTER TABLE ClientiLibrarie DROP CONSTRAINT CK_FACEBOOK;
ALTER TABLE ClientiLibrarie DROP COLUMN linkFacebook;

ALTER TABLE ClientiLibrarie ADD profilInstagram VARCHAR2(200);
ALTER TABLE ClientiLibrarie ADD CONSTRAINT CK_INSTAGRAM CHECK(profileInstagram LIKE '@%');
ALTER TABLE ClientiLibrarie ADD CONSTRAINT UK_INSTAGRAM UNIQUE(profileInstagram);
ALTER TABLE ClientiLibrarie DROP CONSTRAINT UK_INSTAGRAM;
ALTER TABLE ClientiLibrarie DROP CONSTRAINT CK_INSTAGRAM;
ALTER TABLE ClientiLibrarie DROP COLUMN profilInstagram;

DROP TABLE ClientiLibrarie;

DROP TABLE FurnizoriLibrarie CASCADE CONSTRAINTS;
FLASHBACK TABLE FurnizoriLibrarie TO BEFORE DROP;

ALTER TABLE ClientiLibrarie ADD CONSTRAINT NN_ID_CLIENTI CHECK(idClient is not null);
ALTER TABLE FurnizoriLibrarie ADD CONSTRAINT NN_ID_FURNIZORI CHECK(idFurnizor is not null);
ALTER TABLE ProduseLibrarie ADD CONSTRAINT NN_ID_PRODUSE CHECK(idProdus is not null);
ALTER TABLE ComenziLibrarie ADD CONSTRAINT NN_ID_COMENZI CHECK(idComanda is not null);
ALTER TABLE ProduseComenziLibrarie ADD CONSTRAINT NN_ID_PRODUSE_COMENZI 
CHECK(idProduseComenziLibrarie is not null);
ALTER TABLE FacturiLibrarie ADD CONSTRAINT NN_ID_FACTURA CHECK(idFactura is not null);

INSERT INTO ClientiLibrarie VALUES (1, 'Ionut', 'Florin', 'Str. Glicinelor 24, bl 39, scara C, ap 45, etaj 6', '0712345678', 'ionut.florin@example.com');
INSERT INTO ClientiLibrarie VALUES (2, 'Popescu', 'Maria', 'Str. Pictorilor 56, bl 89, scara D, ap 78, etaj 8', '0723456789', 'popescu.alexandru@example.com');
INSERT INTO ClientiLibrarie VALUES (3, 'Ionescu', 'Alexandru', 'Str. Florilor 78, bl 90, scara D, ap 37, etaj 2', '0734567890', 'ionescu.teodor@example.com');
INSERT INTO ClientiLibrarie VALUES (4, 'Voicu', 'Monica', 'Str. Mascatilor 89, bl 67, scara M, ap 89, etaj 1', '0745678901', 'voicu.monica@example.com');
INSERT INTO ClientiLibrarie VALUES (5, 'Ghita', 'Stefania', 'Str Patrotilor 56, bl 23, scara B, ap 15, etaj 5', '0756789012', 'ghita.stefania@example.com');
INSERT INTO ClientiLibrarie VALUES (6, 'Constantinescu', 'Maria', 'Str Patrotilor 36, bl 23, scara B, ap 10, etaj 3', '0797346789', 'constantinescu.maria@example.com');
INSERT INTO ClientiLibrarie VALUES (7, 'Ghita', 'Andrei', 'Soseaua Alexandriei, bl 90, scara M, ap 35,etaj 5', '0799820765', 'ghita.andrei@example.com');
INSERT INTO ClientiLibrarie VALUES (8, 'Ilie', 'Antonia', 'Str Mihai Eminescu 80, bl 78, scara A, ap 5, etaj 1', '0780567309', 'ilie.antonia@example.com');
INSERT INTO ClientiLibrarie VALUES (9, 'Marin', 'Teodor', 'Bd Unirii 97, bl 89, scara K, ap 90 , etaj 10', '0762930479', 'marin.teodor@example.com');
INSERT INTO ClientiLibrarie VALUES (10, 'Matache', 'Marian', 'Str Alexandru Vlaicu 47, bl 12, scara E, ap 35, etaj 5', '0789564310', 'matache.marian@example.com');
INSERT INTO ClientiLibrarie VALUES (11, 'Popescu', 'Ana', 'Str Doroban?ilor 25, ap 15, etaj 3', '0765432109', 'popescu.ana@example.com');
INSERT INTO ClientiLibrarie VALUES (12, 'Ionescu', 'Ion', 'Bd Unirii 30, bl 5, scara B, ap 10, etaj 2', '0721987654', 'ionescu.ion@example.com');

SELECT * FROM ClientiLibrarie;

INSERT INTO FurnizoriLibrarie VALUES (1, 'SC ABC Books SRL', 'abc.books@example.com', '0712345678');
INSERT INTO FurnizoriLibrarie VALUES (2, 'SC Decors HJK SRL', 'decors.hjk@example.com', '0723456789');
INSERT INTO FurnizoriLibrarie VALUES (3, 'SC Papetarie XYZ SRL', 'papetarie.xyz@example.com', '0734567890');
INSERT INTO FurnizoriLibrarie VALUES (4, 'SC SDF Comics SRL', 'sdf.comics@example.com', '0745678901');
INSERT INTO FurnizoriLibrarie VALUES (5, 'SC Games VBN SRL', 'vbn.games@example.com', '0756789012');
INSERT INTO FurnizoriLibrarie VALUES (6, 'SC BookSupplier SRL', 'book.supplier@example.com', '0723456785');
INSERT INTO FurnizoriLibrarie VALUES (7, 'SC Faber Castell SRL', 'faber.castell@example.com', '0712345671');
INSERT INTO FurnizoriLibrarie VALUES (8, 'SC DC Comics SRL', 'dc.comics@example.com', '0733333333');
INSERT INTO FurnizoriLibrarie VALUES (9, 'SC DecorSupplier SRL', 'decor.supplier@example.com', '0744444444');
INSERT INTO FurnizoriLibrarie VALUES (10, 'SC BoardGamesSupplier SRL', 'boardgames.supplier@example.com', '0755555555');
INSERT INTO FurnizoriLibrarie VALUES (11, 'SC PaperSupplier', 'paper.supplier@example.com', '0766666666');
INSERT INTO FurnizoriLibrarie VALUES (12, 'SC Corint SRL', 'corint@example.com', '0777777777');

SELECT * FROM FurnizoriLibrarie;

INSERT INTO ProduseLibrarie VALUES (1, 1, 'Introduction to SQL', 'carte', 29.99, 100);
INSERT INTO ProduseLibrarie VALUES (2, 2, 'Verity','carte', 39.99, 75);
INSERT INTO ProduseLibrarie VALUES (3, 5, 'Exploding Kittens', 'boardgames', 149.99, 120);
INSERT INTO ProduseLibrarie VALUES (4, 2, 'Vaza Flori','decoratiuni', 49.99, 50);
INSERT INTO ProduseLibrarie VALUES (5, 3, 'Stilou', 'papetarie', 54.99, 90);
INSERT INTO ProduseLibrarie VALUES (6, 8, 'Sandman II','revista', 115.99, 90);
INSERT INTO ProduseLibrarie VALUES (7, 6, 'Advanced SQL Techniques', 'carte', 49.99, 80);
INSERT INTO ProduseLibrarie VALUES (8, 6, 'Mystery Novels Collection','carte', 100.00, 60);
INSERT INTO ProduseLibrarie VALUES (9, 10, 'Catan: Cities and Knights', 'boardgames', 199.99, 50);
INSERT INTO ProduseLibrarie VALUES (10, 2, 'Tablou Canvas Abstrac','decoratiuni', 79.99, 40);
INSERT INTO ProduseLibrarie VALUES (11, 7, 'Set Papetarie Lux','papetarie', 79.99, 70);
INSERT INTO ProduseLibrarie VALUES (12, 4, 'National Geographic','revista', 90.00, 100);
INSERT INTO ProduseLibrarie VALUES (13, 7, 'Creioane colorate de ulei', 'papetarie', 59.99, 95);
INSERT INTO ProduseLibrarie VALUES (14, 8, 'Data Science Essentials', 'carte', 69.99, 120);
INSERT INTO ProduseLibrarie VALUES (15, 10, 'Alias Party', 'boardgames', 129.99, 65);

SELECT * FROM ProduseLibrarie;

INSERT INTO ComenziLibrarie VALUES (1, 1, 'ridicare magazin');
INSERT INTO ComenziLibrarie VALUES (2, 2, 'curier');
INSERT INTO ComenziLibrarie VALUES (3, 1, 'ridicare magazin');
INSERT INTO ComenziLibrarie VALUES (4, 4, 'ridicare magazin');
INSERT INTO ComenziLibrarie VALUES (5, 5, 'curier');
INSERT INTO ComenziLibrarie VALUES (6, 5, 'posta');
INSERT INTO ComenziLibrarie VALUES (7, 3, 'posta');
INSERT INTO ComenziLibrarie VALUES (8, 6, 'ridicare magazin');
INSERT INTO ComenziLibrarie VALUES (9, 7, 'curier');
INSERT INTO ComenziLibrarie VALUES (10, 11, 'posta');
INSERT INTO ComenziLibrarie VALUES (11, 8, 'posta');
INSERT INTO ComenziLibrarie VALUES (12, 9, 'ridicare magazin');
INSERT INTO ComenziLibrarie VALUES (13, 10, 'ridicare magazin');
INSERT INTO ComenziLibrarie VALUES (14, 12, 'curier');
INSERT INTO ComenziLibrarie VALUES (15, 11, 'curier');

SELECT * FROM ComenziLibrarie;

    
INSERT INTO ProduseComenziLibrarie VALUES (1, 1, 1, 2);
INSERT INTO ProduseComenziLibrarie VALUES (2, 1, 2, 1);
INSERT INTO ProduseComenziLibrarie VALUES (3, 2, 3, 1);
INSERT INTO ProduseComenziLibrarie VALUES (4, 2, 2, 2);
INSERT INTO ProduseComenziLibrarie VALUES (5, 2, 1, 2);
INSERT INTO ProduseComenziLibrarie VALUES (6, 3, 5, 2);
INSERT INTO ProduseComenziLibrarie VALUES (7, 4, 7, 1);
INSERT INTO ProduseComenziLibrarie VALUES (8, 5, 8, 5);
INSERT INTO ProduseComenziLibrarie VALUES (9, 6, 10, 7);
INSERT INTO ProduseComenziLibrarie VALUES (10, 7, 11, 2);
INSERT INTO ProduseComenziLibrarie VALUES (11, 8, 12, 5);
INSERT INTO ProduseComenziLibrarie VALUES (12, 9, 13, 4);
INSERT INTO ProduseComenziLibrarie VALUES (13, 10, 14, 5);
INSERT INTO ProduseComenziLibrarie VALUES (14, 11, 15, 2);
INSERT INTO ProduseComenziLibrarie VALUES (15, 12, 15, 6);

SELECT * FROM ProduseComenziLibrarie;

INSERT INTO FacturiLibrarie VALUES (1, 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (2, 2, TO_DATE('2023-02-15', 'YYYY-MM-DD'), 'cash');
INSERT INTO FacturiLibrarie VALUES (3, 3, TO_DATE('2023-03-20', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (4, 4, TO_DATE('2023-04-10', 'YYYY-MM-DD'), 'cash');
INSERT INTO FacturiLibrarie VALUES (5, 5, TO_DATE('2023-05-05', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (6, 6, TO_DATE('2024-01-03', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (7, 7, TO_DATE('2024-01-04', 'YYYY-MM-DD'), 'cash');
INSERT INTO FacturiLibrarie VALUES (8, 8, TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (9, 9, TO_DATE('2024-01-06', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (10, 10, TO_DATE('2024-01-07', 'YYYY-MM-DD'), 'cash');
INSERT INTO FacturiLibrarie VALUES (11, 11, TO_DATE('2024-01-08', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (12, 12, TO_DATE('2024-01-09', 'YYYY-MM-DD'), 'cash');
INSERT INTO FacturiLibrarie VALUES (13, 13, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'cash');
INSERT INTO FacturiLibrarie VALUES (14, 14, TO_DATE('2024-01-11', 'YYYY-MM-DD'), 'card');
INSERT INTO FacturiLibrarie VALUES (15, 15, TO_DATE('2024-01-12', 'YYYY-MM-DD'), 'card');

SELECT * FROM FacturiLibrarie;

SELECT * FROM ClientiLibrarie WHERE idClient=1;

UPDATE ClientiLibrarie
SET telefon = '0712345679'
WHERE idClient = 1;

SELECT * FROM ClientiLibrarie WHERE idClient=1;


UPDATE ProduseLibrarie
SET stoc = stoc + 5
WHERE idProdus = 3;


SELECT * FROM ProduseLibrarie;

UPDATE ProduseLibrarie
SET pret = pret * 1.1
WHERE idFurnizor = 
(SELECT idFurnizor 
FROM ProduseLibrarie 
WHERE stoc = 
(SELECT MIN(stoc) 
FROM ProduseLibrarie));

SELECT * FROM ProduseLibrarie;

ALTER TABLE ClientiLibrarie ADD tipProdusPreferat VARCHAR2(100);
UPDATE ClientiLibrarie SET tipProdusPreferat='carti' WHERE idClient>=1 AND idClient<=3;
UPDATE ClientiLibrarie SET tipProdusPreferat='papetarie' WHERE idClient IN (4,5);
UPDATE ClientiLibrarie SET tipProdusPreferat='reviste' WHERE idClient=6;
UPDATE ClientiLibrarie SET tipProdusPreferat='decoratiuni' WHERE idClient BETWEEN 7 AND 14 AND idClient NOT IN (10, 12);
UPDATE ClientiLibrarie SET tipProdusPreferat='boardgames' WHERE idClient BETWEEN 10 AND 12;

DELETE FROM ClientiLibrarie;


DELETE FROM ClientiLibrarie
WHERE idClient = 1;


DELETE FROM ClientiLibrarie
WHERE idClient NOT IN (SELECT DISTINCT idClient FROM ComenziLibrarie);


DELETE FROM ClientiLibrarie
WHERE tipProdusPreferat NOT IN (
    SELECT tipProdusPreferat
    FROM ClientiLibrarie
    WHERE tipProdusPreferat IS NOT NULL
);

ALTER TABLE ClientiLibrarie DROP COLUMN tipProdusPreferat;

SELECT * FROM ClientiLibrarie where idClient=4;

SELECT numeProdus, tipProdus, pret FROM ProduseLibrarie WHERE pret BETWEEN 80 AND 180;

SELECT f.numeFurnizor, p.numeProdus
FROM FurnizoriLibrarie f, ProduseLibrarie p
WHERE f.idFurnizor=p.idFurnizor;

SELECT * FROM ProduseLibrarie WHERE tipProdus<>'decoratiuni' ORDER BY pret DESC;

SELECT numeProdus, stoc, pret
FROM ProduseLibrarie
WHERE stoc > 50 AND pret < 100;

SELECT numeFurnizor
FROM FurnizoriLibrarie
WHERE idFurnizor NOT IN (
    SELECT idFurnizor
    FROM ProduseLibrarie
    WHERE pret < 50
);

SELECT cl.numeClient, cl.prenumeClient, p.numeProdus
FROM ClientiLibrarie cl
JOIN ComenziLibrarie c ON cl.idClient = c.idClient
JOIN ProduseComenziLibrarie pc ON c.idComanda = pc.idComanda
JOIN ProduseLibrarie p ON pc.idProdus = p.idProdus;


SELECT f.numeFurnizor, p.numeProdus
FROM FurnizoriLibrarie f
LEFT JOIN ProduseLibrarie p ON f.idFurnizor = p.idFurnizor;

SELECT fl.numeFurnizor, pl.numeProdus
FROM FurnizoriLibrarie fl
RIGHT JOIN ProduseLibrarie pl ON fl.idFurnizor = pl.idFurnizor;


SELECT c.numeClient, c.prenumeClient, p.numeProdus
FROM ClientiLibrarie c
RIGHT JOIN ComenziLibrarie t ON c.idClient = t.idClient
RIGHT JOIN ProduseLibrarie p ON t.idProdus = p.idProdus;

SELECT f.numeFurnizor, p.numeProdus
FROM FurnizoriLibrarie f
FULL JOIN ProduseLibrarie p ON f.idFurnizor = p.idFurnizor;

SELECT p.numeProdus,f.numeFurnizor
FROM ProduseLibrarie p, FurnizoriLibrarie f
WHERE
    p.idFurnizor = f.idFurnizor(+);
    
SELECT c.numeClient, c.prenumeClient, t.idComanda
FROM ClientiLibrarie c, ComenziLibrarie t
WHERE c.idClient = t.idClient(+);


SELECT c.numeClient, c.prenumeClient
FROM ClientiLibrarie c
JOIN ComenziLibrarie t ON c.idClient = t.idClient
JOIN FacturiLibrarie f ON t.idComanda = f.idComanda
WHERE EXTRACT(MONTH FROM f.dataFactura) < 4;

SELECT idClient, COUNT(idComanda) AS NumarComenzi
FROM ComenziLibrarie
GROUP BY idClient;

SELECT idFurnizor, ROUND(AVG(pret),2) AS MediePreturi
FROM ProduseLibrarie
GROUP BY idFurnizor;

SELECT f.numeFurnizor, COUNT(p.idProdus) AS NumarTotalProduse
FROM FurnizoriLibrarie f
JOIN ProduseLibrarie p ON f.idFurnizor = p.idFurnizor
GROUP BY f.numeFurnizor
HAVING SUM(p.stoc) > 100;

SELECT cl.numeClient, cl.prenumeClient, SUM(pl.pret * pc.cantitate) AS sumaTotala
FROM ClientiLibrarie cl
JOIN ComenziLibrarie c ON cl.idClient = c.idClient
JOIN ProduseComenziLibrarie pc ON c.idComanda = pc.idComanda
JOIN ProduseLibrarie pl ON pc.idProdus = pl.idProdus
GROUP BY cl.idClient, cl.numeClient, cl.prenumeClient
HAVING SUM(pl.pret * pc.cantitate) > 200;

SELECT cl.numeClient || ' ' || cl.prenumeClient ||' locuieste pe ' || cl.adresaLivrare 
|| ' si a achizitionat produsul ' || pl.numeProdus AS DetaliiClient
FROM ClientiLibrarie cl
JOIN ComenziLibrarie c ON cl.idClient = c.idClient
JOIN ProduseComenziLibrarie pc ON c.idComanda = pc.idComanda
JOIN ProduseLibrarie pl ON pc.idProdus = pl.idProdus;


SELECT UPPER(numeClient) AS NumeMajuscula, UPPER (prenumeClient) AS PrenumeMajuscula
FROM ClientiLibrarie;

SELECT LOWER(adresaLivrare) AS AdresaMica
FROM ClientiLibrarie;
SELECT INITCAP(tipProdusPreferat) AS TipulProdusuluiPreferat
FROM ClientiLibrarie;


SELECT CONCAT(numeClient, INITCAP(tipProdusPreferat)) AS DetaliiClient
FROM ClientiLibrarie;


SELECT numeProdus, LENGTH(numeProdus) AS LungimeNume
FROM ProduseLibrarie;

SELECT ROUND(SUM(pl.pret * pc.cantitate), 2) AS pretTotal
FROM ProduseComenziLibrarie pc
JOIN ProduseLibrarie pl ON pc.idProdus = pl.idProdus;


SELECT numeProdus, TRUNC(pret) AS PretTrunchiat
FROM ProduseLibrarie;


SELECT SYSDATE AS DataCurenta
FROM dual;

SELECT idFactura, ROUND(MONTHS_BETWEEN(SYSDATE, dataFactura), 2) AS DiferentaLuni
FROM FacturiLibrarie;

SELECT ADD_MONTHS(dataFactura, 6) AS DataCu6LuniInViitor
FROM FacturiLibrarie;

SELECT dataFactura AS DataFactura, 
NEXT_DAY(dataFactura, 'Monday') AS PrimaZiLuniDinSaptamana
FROM FacturiLibrarie;
    
SELECT LAST_DAY(dataFactura) AS UltimaZiLunaCurenta
FROM FacturiLibrarie;

SELECT numeProdus,
pret,
DECODE(pret, 54.99, 'Pretul cautat', 'Alt pret') AS StarePret
FROM ProduseLibrarie;


SELECT numeProdus,
tipProdus,
pret,
DECODE(tipProdus, 'carte', 'Tipul de produs cautat al clientului', 
'boardgames', 'Clientul este interesat de acest tip de produse',
'decoratiuni', 'Clientul nu este interesat de acest tip de produse', 
'Nu exista nicio preferinta pentru tipul de produs') AS AlegereaClientului   
FROM ProduseLibrarie;

SELECT numeProdus, pret,
CASE WHEN pret BETWEEN 5 AND 50 THEN 'Pret mic'
WHEN pret BETWEEN 50 AND 100 THEN 'Pret mediu'
ELSE 'Pret ridicat'
END AS StarePret
FROM ProduseLibrarie;


SELECT numeProdus,pret,
CASE WHEN pret / 5 = ROUND(pret / 5, 0) THEN 'Pret multiplu de 5'
ELSE 'Alt pret'
END AS StarePret
FROM ProduseLibrarie;

SELECT cl.idClient, cl.numeClient, cl.prenumeClient, ROUND(SUM(pl.pret * pc.cantitate), 2) AS Total,
CASE
WHEN SUM(pl.pret * pc.cantitate) < 100 THEN 'Mici'
WHEN SUM(pl.pret * pc.cantitate) >= 100 AND SUM(pl.pret * pc.cantitate) <= 500 THEN 'Medii'
ELSE 'Mari'
END AS CategorieCheltuieli
FROM ClientiLibrarie cl
JOIN ComenziLibrarie c ON cl.idClient = c.idClient
JOIN ProduseComenziLibrarie pc ON c.idComanda = pc.idComanda
JOIN ProduseLibrarie pl ON pc.idProdus = pl.idProdus
GROUP BY cl.idClient, cl.numeClient, cl.prenumeClient;


SELECT numeProdus, tipProdus FROM ProduseLibrarie;

SELECT numeProdus FROM ProduseLibrarie
UNION
SELECT tipProdus FROM ProduseLibrarie;

SELECT numeProdus, pret FROM ProduseLibrarie WHERE pret < 50;

SELECT DISTINCT tipProdus FROM ProduseLibrarie;

SELECT tipProdus FROM ProduseLibrarie WHERE pret < 50
UNION
SELECT numeProdus FROM ProduseLibrarie WHERE pret < 50;

SELECT numeProdus, pret FROM ProduseLibrarie WHERE pret BETWEEN 40 AND 100
MINUS
SELECT numeProdus, pret FROM ProduseLibrarie WHERE pret BETWEEN 50 AND 100;

SELECT cl.numeClient, cl.prenumeClient, ROUND(SUM(pl.pret * pc.cantitate), 2) AS total
FROM ClientiLibrarie cl
JOIN ComenziLibrarie c ON cl.idClient = c.idClient
JOIN ProduseComenziLibrarie pc ON c.idComanda = pc.idComanda
JOIN ProduseLibrarie pl ON pc.idProdus = pl.idProdus
GROUP BY cl.idClient, cl.numeClient, cl.prenumeClient
MINUS
SELECT cl.numeClient, cl.prenumeClient, ROUND(SUM(pl.pret * pc.cantitate), 2) AS total
FROM ClientiLibrarie cl
JOIN ComenziLibrarie c ON cl.idClient = c.idClient
JOIN ProduseComenziLibrarie pc ON c.idComanda = pc.idComanda
JOIN ProduseLibrarie pl ON pc.idProdus = pl.idProdus
GROUP BY cl.idClient, cl.numeClient, cl.prenumeClient
HAVING UPPER(cl.numeClient) LIKE 'I%';


SELECT numeProdus, pret FROM ProduseLibrarie WHERE pret > 20
INTERSECT
SELECT numeProdus, pret FROM ProduseLibrarie WHERE stoc < 120;

SELECT numeProdus, pret, stoc FROM ProduseLibrarie WHERE pret BETWEEN 50 AND 100
INTERSECT
SELECT numeProdus, pret, stoc FROM ProduseLibrarie WHERE stoc > 80;

SELECT numeClient, prenumeClient
FROM ClientiLibrarie
WHERE idClient IN (SELECT DISTINCT idClient FROM ComenziLibrarie);

SELECT numeFurnizor
FROM FurnizoriLibrarie
WHERE idFurnizor IN (SELECT idFurnizor FROM ProduseLibrarie WHERE stoc > 100);

SELECT numeProdus, pret
FROM ProduseLibrarie
WHERE idProdus NOT IN (SELECT idProdus FROM ComenziLibrarie);

SELECT numeProdus, pret
FROM ProduseLibrarie
WHERE pret > (SELECT AVG(pret)FROM ProduseLibrarie);

SELECT USER FROM DUAL;


CREATE OR REPLACE VIEW V_ProduseCarti AS
SELECT * FROM ProduseLibrarie
WHERE tipProdus = 'carte';

SELECT * FROM V_ProduseCarti;

DROP VIEW V_ProduseCarti;

CREATE OR REPLACE VIEW V_Cumparatori AS
SELECT cl.numeClient, cl.prenumeClient, pl.numeProdus
FROM ClientiLibrarie cl, ComenziLibrarie c, ProduseComenziLibrarie pc, ProduseLibrarie pl
WHERE cl.idClient = c.idClient
AND c.idComanda = pc.idComanda
AND pc.idProdus = pl.idProdus;

SELECT * FROM V_Cumparatori;

CREATE OR REPLACE VIEW V_ProduseCarti AS
SELECT * FROM ProduseLibrarie
WHERE tipProdus = 'carte'
WITH READ ONLY ;

DROP TABLE ClientiLibrarie CASCADE CONSTRAINTS;
DROP TABLE FurnizoriLibrarie CASCADE CONSTRAINTS;
DROP TABLE ProduseLibrarie CASCADE CONSTRAINTS;
DROP TABLE ComenziLibrarie CASCADE CONSTRAINTS;
DROP TABLE FacturiLibrarie CASCADE CONSTRAINTS;

