-- =============================================
-- Author:			Pascal Bellerose
-- Create date: 	2017-04-27
-- Description:	Returns the reference point of a conditionnal point, will return -1 if it is not a cond. point
-- =============================================
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='cas_GetCondPointRefPoint')
	DROP FUNCTION cas_GetCondPointRefPoint;
	
CREATE FUNCTION cas_GetCondPointRefPoint (@eid numeric(38,0))
RETURNS INT
AS
BEGIN
	DECLARE @RefPoint numeric(38,0);
	DECLARE @CondPoint numeric(38,0);
	-- Select Conditionnal point field in table POINT and check if it has a reference point
	SELECT @CondPoint = valuestring
	FROM POINT
	WHERE ELEMENTID = @eid and fieldid=287 and valuestring <> '0';
	IF (ISNUMERIC(@CondPoint)=1)
	BEGIN
		SET @RefPoint = @CondPoint;
	END
	ELSE
	BEGIN
		SET @RefPoint = -1;
	END
	RETURN @RefPoint;
END
