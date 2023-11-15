--a--

CREATE TABLE Team 
(
  team_ID NUMBER(20),
  team_Name VARCHAR2(50) NOT NULL,
  location VARCHAR2(50) NOT NULL,
  CONSTRAINT PK_Team PRIMARY KEY (team_ID)
);

CREATE TABLE Player
(
  player_ID NUMBER(20),
  player_number NUMBER(20) NOT NULL,
  team_ID NUMBER(20) NOT NULL,
  player_Name VARCHAR2(50) NOT NULL,
  date_of_Birth DATE NOT NULL,
  start_Year NUMBER(4) NOT NULL,
  position VARCHAR2(10) NOT NULL,
  CONSTRAINT PK_Player PRIMARY KEY (player_ID),
  CONSTRAINT FK_Player_Team FOREIGN KEY (team_ID) REFERENCES Team (team_ID) ON DELETE CASCADE
);

CREATE TABLE Match
(
  match_ID NUMBER(20),
  date_of_Match DATE NOT NULL,
  location VARCHAR2(50) NOT NULL,
  home_Team VARCHAR2(50) NOT NULL,
  away_Team VARCHAR2(50) NOT NULL,
  winning_Team VARCHAR2(50) NOT NULL,
  home_Score NUMBER NOT NULL,
  away_Score NUMBER NOT NULL,

  player_ID[] VARCHAR2 NOT NULL,

  CONSTRAINT PK_Match PRIMARY KEY (match_ID),
  CONSTRAINT FK_Match_Team FOREIGN KEY (home_Team) REFERENCES Team (team_ID) ON DELETE CASCADE,
  CONSTRAINT FK_Match_Team2 FOREIGN KEY (away_Team) REFERENCES Team (team_ID) ON DELETE CASCADE,
  CONSTRAINT FK_Match_Team_Win FOREIGN KEY (winning_Team) REFERENCES Team (team_ID) ON DELETE CASCADE,
  CONSTRAINT FK_Match_Player FOREIGN KEY (player_ID) REFERENCES Player(player_ID) ON DELETE CASCADE,
);

CREATE TABLE PlayerinMatch
(
  match_ID NUMBER(20),
  player_ID NUMBER(20),
  goals NUMBER NOT NULL,
  yellowCard BOOLEAN NOT NULL,
  redCard BOOLEAN NOT NULL,
  
  CONSTRAINT PK_Match_Player PRIMARY KEY (match_ID, player_ID),

  CONSTRAINT FK_PiM_Player FOREIGN KEY (player_ID) REFERENCES Player(player_ID) ON DELETE CASCADE,
  CONSTRAINT FK_PiM_Match FOREIGN KEY (match_ID) REFERENCES Match(match_ID) ON DELETE CASCADE,
);

CREATE TABLE Referee
(
  Referee_ID NUMBER(20),
  Referee_Name VARCHAR2(50) NOT NULL,
  date_of_Birth DATE NOT NULL,
  years_of_Experience NUMBER(4) NOT NULL,

  CONSTRAINT PK_Referee PRIMARY KEY (Referee_ID),
);

--b--
--1--
SELECT COUNT(*) as Home_Wins
FROM Matches
WHERE home_Score>away_Score;

--2--
SELECT match_date, SUM(Count(),count())
FROM Match, Team, PlayerinMatch
WHERE Match.match_id=PlayerinMatch.match_id && Match.home_Team=Team.team_ID && Match.away_Team=Team.team_ID;

--c--
CREATE OR REPLACE VIEW Match_Summary AS 
SELECT M.date_of_Match, M.home_Score, M.away_Score, M.winning_Team, P.MAX(goals)
FROM Match M LEFT JOIN PlayerinMatch P on M.match_ID=P.match_ID
GROUP BY match_ID;