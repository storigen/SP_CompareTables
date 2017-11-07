# SP_CompareTables
Dynamically compare two tables for differences including deleted/added rows, or value differences 

###Description
Returns all rows from either table that do NOT match the other table when compared by all shared columns. Must enter both tables as parameters into SP, then it identifies all shared columns and does a compare. Ideally this checks two tables which are exactly the same (like a backup table  and a fresh rerun of the same table, to see differences).
