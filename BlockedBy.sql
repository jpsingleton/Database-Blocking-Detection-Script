/****************************************
 *										*
 *  Shows what/who is blocking a query	*
 *										*
 *   James Singleton - 2012			*
 *										*
 ****************************************/
 
CREATE TABLE #sp_who2_results
(
    SPID INT, 
    [Status] VARCHAR(1000) NULL, 
    [Login] SYSNAME NULL, 
    HostName SYSNAME NULL, 
    BlkBy SYSNAME NULL, 
    DBName SYSNAME NULL, 
    Command VARCHAR(1000) NULL, 
    CPUTime INT NULL, 
    DiskIO INT NULL, 
    LastBatch VARCHAR(1000) NULL, 
    ProgramName VARCHAR(1000) NULL, 
    SPID2 INT,
    REQUESTID INT
) 
GO

INSERT INTO #sp_who2_results
	EXEC sp_who2
GO

SELECT 
	sp1.Command,
	sp1.DBName,
	sp1.[Status],
	sp1.[Login],
	sp1.HostName,
	sp2.[Login]		AS 'Blocked By',
	sp2.HostName		AS 'Blocked From',
	sp2.DBName		AS 'Blocking DB Name',
	sp2.ProgramName	AS 'Blocking Program Name'
FROM #sp_who2_results AS sp1
	INNER JOIN #sp_who2_results AS sp2 ON sp1.BlkBy = sp2.SPID
WHERE sp1.BlkBy != '  .'
GO

DROP TABLE #sp_who2_results
GO