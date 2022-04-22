-- 1 
	-- A
		DROP DATABASE IF EXISTS BDTP4; 
	-- B 
		CREATE DATABASE BDTP4; 
	-- C 
		USE BDTP4;
-- 2
	DROP TABLE IF EXISTS Produit;
    CREATE TABLE Produit(
		pro_id 		INT,
        pro_code	CHAR(3),
        pro_nom		VARCHAR(30),
        pro_qte 	INT, 
        pro_prix 	DECIMAL(10,2),
        
        CONSTRAINT pk_pro_id PRIMARY KEY(pro_id)
        );
-- 3 
	DESC Produit; 
-- 4 
	INSERT INTO Produit VALUES
		(1001,'CRA','Crayon Rouge', 5000, 1.23),
        (1002, 'CRA', 'Crayon Bleu', 8000, 1.25), 
        (1003, 'CRA', 'Crayon Noir', 2000, 1.25),
        (1004,'BOI', 'Boite 2B', 10000, 0.48),
        (1005, 'BOI', 'Boite 2H', 8000, 0.49);
	SELECT * FROM Produit; 
-- 5
	INSERT INTO Produit VALUES(NULL, NULL, NULL, NULL, NULL);
    -- Le parametre par défaut de INSERT INTO définit les valeur d'une 
    -- columnes comme étant non null. 
-- 6
	SELECT pro_nom AS 'Nom Des Produits',  pro_prix AS 'Prix Des Produits' FROM Produit
	ORDER BY pro_prix DESC
    LIMIT 2;
-- 7
		SELECT '5+4 = 9' AS 'Résultat', CONCAT(CURDATE(),' ', CURTIME()) AS "Aujourd'hui";
-- 8 
	SELECT pro_nom, pro_prix FROM Produit
		WHERE pro_nom LIKE 'C____%';
-- 9 
	SELECT * FROM Produit
		WHERE 
			pro_qte > 5000 
		AND 
            pro_prix < 1.24 
		AND
			pro_nom LIKE 'Boite%';
-- 10 
	SELECT * FROM Produit 
		WHERE 
			pro_qte <= 5000
		AND 
			pro_nom LIKE 'Crayon%';
-- 11 
	SELECT * FROM Produit 
	WHERE 
		pro_prix BETWEEN 1.00 AND 2.00 
	AND 
		pro_qte BETWEEN 1000 AND 2000;
-- 12 
	SELECT * FROM produit WHERE pro_code = NULL;
    -- Il n'y a rien de retourné parceque il n'y a pas d'enregistrement avec un pro_code null
    -- parceque une contrainte qui vient avec le fait d'être PRIMARY KEY est que les values
    -- de la columne ne peuvent pas être NULL
-- 13 
	SELECT DISTINCT pro_prix AS 'Prix Disctincts' FROM Produit 
	ORDER BY pro_prix DESC;
-- 14 
	SELECT 
		pro_code AS 'Code Produit',
        MAX(pro_prix) AS 'Prix Maximum',
        MIN(pro_prix) AS 'Prix Minimum', 
        AVG(pro_prix) AS 'Moyenne',
        ROUND(MAX(pro_prix) - MIN(pro_prix),2) AS "Écart Type", 
		SUM(pro_qte) AS 'Quantité Totale'
	FROM Produit 
    GROUP BY pro_code;
-- 15
	SELECT pro_code AS 'Code Produit', COUNT(*) AS 'Nombre', AVG(pro_prix) AS 'Moyenne' FROM Produit 
	GROUP BY pro_code 
    HAVING COUNT(*) > 2;
-- 16 
	SELECT 
		pro_code AS 'Code Produit',
        MAX(pro_prix) AS 'Prix Maximum',
        MIN(pro_prix) AS 'Prix Minimum', 
        AVG(pro_prix) AS 'Moyenne',
        ROUND(MAX(pro_prix) - MIN(pro_prix),2) AS "Écart Type", 
		SUM(pro_qte) AS 'Quantité Totale'
	FROM Produit 
    GROUP BY pro_code
    WITH ROLLUP;
-- 17 
	SET SQL_SAFE_UPDATES = 0;
    UPDATE Produit 
		SET pro_qte = pro_qte + 50 WHERE pro_nom = 'Crayon Rouge'; 
	UPDATE Produit 
		SET pro_prix = pro_prix + 1.23 WHERE pro_nom = 'Crayon Rouge'; 
-- 18 
	SET autocommit=1;
    START TRANSACTION;
		DELETE from Produit 
			WHERE pro_code = 'CRA';
    ROLLBACK;
    CALL GROUNDHOGDAY();
	select * from Produit;
-- 19 
	DROP TABLE IF EXISTS Fournisseur; 
	CREATE TABLE Fournisseur( 
	 fou_id 	INT, 
     fou_nom 	VARCHAR(30), 
	 fou_tel 	CHAR(10),
     
     CONSTRAINT 	pk_fou_id		PRIMARY KEY(fou_id)
     );
-- 20 
	INSERT INTO Fournisseur VALUES
		(501, 'ABC Vente', '4181112222'),
        (502, 'XYZ Compagnie', '5143334444'),  
        (503, 'QQ Coop', '6131118888'),
        (504, 'QU Quebec', '4185557777');
	SELECT * FROM Fournisseur;
-- 21 
	-- A
		ALTER TABLE Produit 
			ADD fou_id INT;
		ALTER TABLE PRODUIT
			ADD CONSTRAINT fk_fou_id FOREIGN KEY(fou_id) 
				REFERENCES Fournisseur(fou_id);
	-- B 
		DESC Produit;
	-- C 
		UPDATE Produit 
			SET fou_id = 501;
		select * from Produit;
	-- D 
		UPDATE Produit 
			SET fou_id = 502 WHERE pro_id =  1004;
	-- 22 
		SELECT 
			pro_nom AS 'Nom des produits', 
            pro_prix AS 'Prix des produits',
            fou_nom AS 'Nom des fournisseurs'
		FROM Produit
	
		JOIN Fournisseur ON Produit.fou_id = Fournisseur.fou_id
        WHERE pro_prix < 1.00;
	-- 23 
    
    -- 24 
		INSERT INTO Produit VALUES(1006,'BOI', 'BOITE 2C', 7000, 2.23, 506);
        -- Non parceque il n'y a pas d'enregistrement de fou_id d'une valeur de 506 
        -- dans la table Fournisseur. La solution serait tout d'abord d'insérer un 
		-- enregistremet avec 506 dans la table Fournisseur avant.
	-- 25 
		ALTER TABLE Produit DROP FOREIGN KEY fk_fou_id;
        ALTER TABLE Produit DROP COLUMN fou_id;
-- 26 
	DELETE FROM Produit WHERE pro_id = 1006 ;
-- 27 
	DROP TABLE IF EXISTS contact;
    CREATE TABLE contact1( 
		pro_id INT, 
        fou_id INT,
        
        CONSTRAINT pk_pro_id_fou_id PRIMARY KEY(pro_id, fou_id),
        
        CONSTRAINT fk_pro_id FOREIGN KEY(pro_id) 
			REFERENCES		Produit(pro_id) ON DELETE SET NULL,
		
        CONSTRAINT  fk_fou_if FOREIGN KEY(fou_id) 
			REFERENCES		Fournisseur(fou_id) ON DELETE SET NULL
            );
        
-- 28 

-- 29 
	INSERT INTO contact VALUES 
	(1001,501),
    (1002, 501), 
    (1003, 501),
    (1004, 502), 
    (1001, 503);
	SELECT * FROM contact;
        
    
    
    
    
    
    
    
    
-- HOw the fuck do you rollback!!!!
	DELIMITER $$
	DROP PROCEDURE IF EXISTS GROUNDHOGDAY$$
	CREATE PROCEDURE GROUNDHOGDAY() 
	BEGIN 
		DROP TABLE IF EXISTS Produit;
		CREATE TABLE Produit(
			pro_id 		INT,
			pro_code	CHAR(3),
			pro_nom		VARCHAR(30),
			pro_qte 	INT, 
			pro_prix 	DECIMAL(10,2),
			
			CONSTRAINT pk_pro_id PRIMARY KEY(pro_id)
			);
	-- 3 
		DESC Produit; 
	-- 4 
		INSERT INTO Produit VALUES
			(1001,'CRA','Crayon Rouge', 5000, 1.23),
			(1002, 'CRA', 'Crayon Bleu', 8000, 1.25), 
			(1003, 'CRA', 'Crayon Noir', 2000, 1.25),
			(1004,'BOI', 'Boite 2B', 10000, 0.48),
			(1005, 'BOI', 'Boite 2H', 8000, 0.49);
		SELECT * FROM Produit; 
	-- 5
	END $$
	DELIMITER ;

DELIMITER $$
	DROP PROCEDURE IF EXISTS Assert$$
	CREATE PROCEDURE Assert(IN nom VARCHAR(10))
	BEGIN 
		SELECT * FROM nom;
	END $$
	DELIMITER ;
