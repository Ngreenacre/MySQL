SELECT
    fm.Date
    , fm.HomeTeam
    , fm.AwayTeam
    , fm.FTHG
    , fm.FTAG
    , fm.FTR
FROM
    FootballMatch fm

--------

 
SELECT COUNT (*)

FROM
    FootballMatch fm

    --289 GAMES PLAYED IN TOTAL



SELECT
    COUNT (*) AS 'NoOfMatches'
    ,MONTH(DATE) AS 'Month'
    ,DATENAME(MONTH,(DATE)) AS 'MonthName'
    ,DATENAME(YY,(DATE)) AS 'Year'
FROM
    FootballMatch fm
GROUP BY MONTH(DATE) 
,DATENAME(MONTH,(DATE))
,DATENAME(YY,(DATE))
ORDER BY 
DATENAME(YY,(DATE)) ASC
,MONTH(DATE) ASC

-- BY TEAM
;

WITH CTE AS (
SELECT
        HOMETEAM AS 'Team'
   ,SUM (FTHG) AS 'GoalsScored'
    FROM
        FootballMatch fm
    GROUP BY HomeTeam
UNION ALL
    SELECT
        AWAYTEAM
,SUM (FTAG)
    FROM
        FootballMatch fm
    GROUP BY AwayTeam)

SELECT
Team
,SUM(GOALSSCORED)AS 'TotalGoals'
FROM CTE
GROUP BY Team
ORDER BY TotalGoals DESC

------------------------------
DROP TABLE IF EXISTS #LEAGUETABLE

SELECT
        HOMETEAM AS 'Team'
        ,count (*) as 'Played'
        ,sum(case when ftr = 'H' then 1 else 0 end) as 'won'
   ,SUM (FTHG) AS 'GF'
   ,SUM (FTAG) AS 'GA'
   
   INTO #LEAGUETABLE
    FROM
        FootballMatch fm
    GROUP BY HomeTeam
UNION ALL
    SELECT
        AWAYTEAM
        ,count (*)
        ,sum (case when ftr = 'A' then 1 else 0 end) as 'won'
,SUM (FTAG)
,SUM (FTHG)

    FROM
        FootballMatch fm
    GROUP BY AwayTeam

SELECT 
Team
,sum (Played) as 'Played'
,sum (won) as 'Won'
,SUM(GF) AS 'GF'
,SUM (GA) AS 'GA'
FROM #LEAGUETABLE
GROUP BY TEAM
ORDER BY GF DESC

------------------------------
DROP TABLE IF EXISTS #LEAGUETABLE

SELECT
        HOMETEAM AS 'Team'
        ,case when ftr = 'H' then 1 else 0 end as 'won'
        ,case when ftr = 'D' then 1 else 0 end as 'draw'
        ,case when ftr = 'A' then 1 else 0 end as 'lose'
   ,(FTHG) AS 'GF'
   ,(FTAG) AS 'GA'
   INTO #LEAGUETABLE
    FROM
        FootballMatch fm
UNION ALL
    SELECT
        AWAYTEAM
        ,case when ftr = 'A' then 1 else 0 end as 'won'
        ,case when ftr = 'D' then 1 else 0 end as 'draw'
        ,case when ftr = 'H' then 1 else 0 end as 'lose'
,(FTAG)
,(FTHG)
    FROM
        FootballMatch fm
   
SELECT 
Team
,count (*) as 'Played'
,sum (won) as 'Won'
,sum (draw) as 'Drew'
,sum (lose) as 'Lost'
,SUM(GF) AS 'GF'
,SUM (GA) AS 'GA'
FROM #LEAGUETABLE
GROUP BY TEAM
ORDER BY GF DESC