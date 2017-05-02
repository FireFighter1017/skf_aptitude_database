-- =============================================
-- Author:			Pascal Bellerose
-- Create date: 	2017-04-27
-- Description:	Returns if a point is a conditionnal point (1) or not (0)
-- =============================================
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='cas_IsConditionnal')
	DROP FUNCTION cas_IsConditionnal;

CREATE FUNCTION cas_IsConditionnal(@eid numeric(38,0))
RETURNS BIT			-- This function returns an integer where 1=True, 0=False
AS
BEGIN
	DECLARE @IsCond BIT;
	
	-- Select Conditionnal point field in table POINT adn check if it has a reference point
	SELECT @IsCond = count(*)
	FROM POINT
	WHERE ELEMENTID = @eid and fieldid=287 and valuestring <> '0';
	RETURN @IsCond;
END
GO