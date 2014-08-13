CREATE FUNCTION dbo.IsValidLookupType(@type nvarchar(50))
	
	RETURNs bit AS

	BEGIN
	IF EXists (select [LookupID] from [dbo].[Lookup]  where [Type]=@type)
	REturn 1
	
	REturn 0
	END
