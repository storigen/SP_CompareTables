USE [Database]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CompareTables]
(
	@table1 varchar(100),
	@table2 Varchar(100)
)
AS

			   
/***********************************************************************************************************************************
OBJECT NAME:	Validation - Compare two tables to see any differences
EXECUTED BY:	Manually
CHILD OBJECTS:	n/a
DESCRIPTION:	Returns all rows from either table that do NOT match the other table when compared by all shared columns. Must enter
				both tables as parameters into SP, then it identifies all shared columns and does a compare. Ideally this checks two 
				tables which are exactly the same (like backup table X and a fresh rerun table X, to see differences).
> 10/02/17 - YS created
***********************************************************************************************************************************/
SET NOCOUNT ON; 








-------------------------------------------------------------------------------------------------
--1. DETERMINE SHARED COLUMNS TO COMPARE
-------------------------------------------------------------------------------------------------



DECLARE @SubQry VARCHAR(max);
DECLARE @SQL VARCHAR(max);
DECLARE @columns VARCHAR(max);


 
SET @columns = ''

	SELECT @columns = @columns + '['+t1.name+']' + ', '
	FROM
		(                    
			SELECT  name
			FROM sys.columns 
			WHERE OBJECT_ID = OBJECT_ID(@table1)
		) T1
	INNER JOIN
		(
			SELECT  name
			FROM sys.columns 
			WHERE OBJECT_ID = OBJECT_ID(@table2)    
		) T2 
			on T1.NAME=T2.NAME

 

-------------------------------------------------------------------------------------------------
--2. RUN COMPARISON
-------------------------------------------------------------------------------------------------
 
 
SET @SubQry = 
 CHAR(9)+ 'SELECT ''' + @table1 + ''' AS TableName, ' + SUBSTRING(@columns, 0, LEN(@columns)) 		+ CHAR(13)+CHAR(10)
+CHAR(9)+ 'FROM ' + @Table1 										+ CHAR(13)+CHAR(10)
+CHAR(9)+ 'UNION ALL'											+ CHAR(13)+CHAR(10)
+CHAR(9)+ 'SELECT ''' + @table2 + ''' As TableName, ' + SUBSTRING(@columns, 0, LEN(@columns))		+ CHAR(13)+CHAR(10)
+CHAR(9)+ 'FROM ' + @Table2



SET @SQL = 
  'SELECT Max(TableName) as TableName, ' + SUBSTRING(@columns, 0, LEN(@columns))			+ CHAR(13)+CHAR(10)
+ 'FROM ('												+ CHAR(13)+CHAR(10)
			+ @SubQry									+ CHAR(13)+CHAR(10)
+       ') A '												+ CHAR(13)+CHAR(10)
+ 'GROUP BY '							+ SUBSTRING(@columns, 0, LEN(@columns))	+ CHAR(13)+CHAR(10)
+ 'HAVING COUNT(*) = 1'											+ CHAR(13)+CHAR(10)
--+ 'ORDER BY' + SUBSTRING(@columns, 0, LEN(@columns))							+ CHAR(13)+CHAR(10)
 
 
PRINT '************************************************************************************************************************'
																											    + CHAR(13)+CHAR(10)+
	  'Any rows where there are any data value differences between two tables are listed in the data grid.'	    + CHAR(13)+CHAR(10)+
	  'If there are entries that are listed for only one table, this means that data is unique to that table'   + CHAR(13)+CHAR(10)+
	  '************************************************************************************************************************'
	  
PRINT '' + CHAR(13)+CHAR(10) +'' + CHAR(13)+CHAR(10) +'Query Below'
PRINT '------------------------------------------------------------------------------------'+ CHAR(13)+CHAR(10)


PRINT @SQL 
EXEC ( @SQL)
