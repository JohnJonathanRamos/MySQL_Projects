CREATE DATABASE NBA;

CREATE TABLE teams (
	team_id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(50),
    team_name VARCHAR(100)
);

INSERT INTO teams (team_name, city) VALUES 
('Los Angeles Lakers', 'Los Angeles'),
('Golden State Warriors', 'San Francisco'),
('Milwaukee Bucks', 'Milwaukee'),
('Boston Celtics', 'Boston'),
('Oklahoma City Thunder', 'Oklahoma'),
('Denver Nuggets', 'Denver'),
('Phoenix Suns', 'Phoenix'),
('Cleveland Cavaliers', 'Cleveland'),
('Dallas Mavericks', 'Dallas'),
('New York Knicks', 'New York');

CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    position VARCHAR(20),
    height_cm INT,
    weight_kg INT,
    team_id INT NOT NULL
);

INSERT INTO players (player_name, position, height_cm, weight_kg, team_id) VALUES
('LeBron James', 'SF', 206, 113, 1),
('Stephen Curry', 'PG', 188, 83, 2),
('Giannis Antetokounmpo', 'PF', 211, 110, 3),
('Jayson Tatum', 'SF', 203, 95, 4),
('Shai Gilgeous-Alexander', 'PG', 198, 88, 5),
('Nikola Jokic', 'C', 211, 128, 6),
('Kevin Durant', 'PF', 211, 108, 7),
('Donovan Mitchell', 'SG', 191, 97, 8),
('Anthony Davis', 'PF', 208, 114, 9),
('Karl-Anthony Towns', 'C', 213, 112, 10)
;

CREATE TABLE player_stats (
    stat_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    season_year VARCHAR(9),
    points_per_game DECIMAL(3,1),
    rebounds_per_game DECIMAL(3,1),
    assists_per_game DECIMAL(3,1)
);

INSERT INTO player_stats (player_id, season_year, points_per_game, rebounds_per_game, assists_per_game) VALUES
(1, '2024-25', 24.4, 7.8, 8.2),
(2, '2024-25', 24.5, 4.4, 6.0),
(3, '2024-25', 30.4, 11.9, 6.5),
(4, '2024-25', 26.8, 8.7, 6.0),
(5, '2024-25', 32.7, 5.0, 6.4),
(6, '2024-25', 29.6, 12.7, 10.2),
(7, '2024-25', 26.6, 6.0, 4.2),
(8, '2024-25', 24.0, 4.5, 5.0),
(9, '2024-25', 24.7, 11.6, 3.5),
(10, '2024-25', 24.4, 12.8, 3.1)
;

SELECT * FROM teams;
SELECT * FROM players;
SELECT * FROM player_stats;

DELIMITER $$

CREATE PROCEDURE PlayerStatus(IN player_name VARCHAR(100))
BEGIN
    DECLARE player_points DECIMAL(3,1);
    DECLARE player_rebounds DECIMAL(3,1);
    DECLARE player_assists DECIMAL(3,1);
    DECLARE scoring_ability VARCHAR(50);
    DECLARE rebound_ability VARCHAR(50);
    DECLARE assist_ability VARCHAR(50);
    SELECT
        PS.points_per_game,
        PS.rebounds_per_game,
        PS.assists_per_game
    INTO 
        player_points,
        player_rebounds,
        player_assists
    FROM player_stats PS
    JOIN players P 
		ON PS.player_id = P.player_id
    WHERE P.player_name = player_name;

    IF player_points > 24 THEN
        SET scoring_ability = 'Elite Scorer';
    ELSE
        SET scoring_ability = 'Average Scorer';
    END IF;

    IF player_rebounds > 10 THEN
        SET rebound_ability = 'Elite Rebounder';
    ELSE
        SET rebound_ability = 'Average Rebounder';
    END IF;

    IF player_assists > 8 THEN
        SET assist_ability = 'Elite Playmaker';
    ELSE
        SET assist_ability = 'Average Playmaker';
    END IF;

    SELECT 
        player_name AS PlayerName,
        scoring_ability AS ScoringAbility,
        rebound_ability AS ReboundAbility,
        assist_ability AS AssistAbility;
END $$

DELIMITER ;

CALL PlayerStatus('Lebron James');
CALL PlayerStatus('Giannis Antetokounmpo');

DELIMITER $$

CREATE PROCEDURE PlayerType(IN player_name VARCHAR(100))
BEGIN
    SELECT P.player_name,
	CASE
		WHEN P.position = 'PG' OR P.position = 'SG' THEN 'Guard'
		WHEN P.position = 'SF' OR P.position = 'PF' THEN 'Wing'
		WHEN P.position = 'C' THEN 'Center'
		ELSE 'Not Specified'
	END AS PositionType,
    
    CASE
		WHEN P.height_cm >= 210 THEN 'Very Tall'
		WHEN P.height_cm BETWEEN 200 AND 209 THEN 'Tall'
		WHEN P.height_cm < 200 THEN 'Average'
		ELSE 'Not Specified'
	END AS HeightCategory,
    
    CASE
		WHEN P.weight_kg >= 110 THEN 'Heavyweight'
		WHEN P.weight_kg BETWEEN 90 AND 109 THEN 'Middleweight'
		WHEN P.weight_kg < 90 THEN 'Lightweight'
		ELSE 'Unknown'
	END AS WeightCategory
    
    FROM players P
    WHERE P.player_name = player_name;
END $$

DELIMITER ;

CALL PlayerType('Stephen Curry');

DELIMITER $$

CREATE FUNCTION ConvertHeightToFeet(player_height INT) 
    RETURNS DECIMAL(5,2)
BEGIN
    RETURN player_height * 0.0328084;
END $$

CREATE FUNCTION ConvertWeightToPounds(player_weight INT) 
    RETURNS DECIMAL(6,2)
BEGIN
    RETURN player_weight * 2.20462;
END $$

CREATE FUNCTION CalculateBMI(player_height INT, player_weight INT) 
    RETURNS DECIMAL(5,2)
BEGIN
    DECLARE height_meters DECIMAL(5,2);
    SET height_meters = player_height / 100;
    RETURN player_weight / (height_meters * height_meters);
END $$

DELIMITER ;

SELECT ConvertHeightToFeet(211);
SELECT ConvertWeightToPounds(97);
SELECT CalculateBMI(208, 114);

SELECT P.player_name AS ScoringLeader, PS.points_per_game
FROM player_stats PS
JOIN players P
	ON PS.player_id = P.player_id
WHERE points_per_game = (
						SELECT MAX(points_per_game)
						FROM player_stats
);

SELECT P.player_name AS TopRebounders, PS.rebounds_per_game
FROM player_stats PS
JOIN players P
	ON PS.player_id = P.player_id
WHERE rebounds_per_game > (
						SELECT AVG(rebounds_per_game)
						FROM player_stats
)
ORDER BY PS.rebounds_per_game DESC;

SELECT player_name AS TripleDoublePlayer
FROM players
WHERE player_id IN (
    SELECT PS.player_id
    FROM player_stats PS
    WHERE PS.points_per_game >= 10
        AND PS.rebounds_per_game >= 10
        AND PS.assists_per_game >= 10
);

WITH HighestScoringAverage AS (
    SELECT MAX(points_per_game) AS highest_points
    FROM player_stats
)
SELECT P.player_name AS ScoringLeader, PS.points_per_game
FROM player_stats PS
JOIN players P
    ON PS.player_id = P.player_id
JOIN HighestScoringAverage HS
    ON PS.points_per_game = HS.highest_points;
    
WITH AvgRebounds AS (
    SELECT AVG(rebounds_per_game) AS avg_rebounds
    FROM player_stats
)
SELECT P.player_name AS TopRebounders, PS.rebounds_per_game
FROM player_stats PS
JOIN players P
    ON PS.player_id = P.player_id
JOIN AvgRebounds AR
    ON PS.rebounds_per_game > AR.avg_rebounds
ORDER BY PS.rebounds_per_game DESC;

WITH TripleDoubleAvg AS (
    SELECT PS.player_id
    FROM player_stats PS
    WHERE PS.points_per_game >= 10
        AND PS.rebounds_per_game >= 10
        AND PS.assists_per_game >= 10
)
SELECT P.player_name AS TripleDoublePlayer
FROM players P
WHERE P.player_id IN (
    SELECT player_id
    FROM TripleDoubleAvg
);