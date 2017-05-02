-- Number of points in route
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='cas_GetRoutePtsCount')
	DROP FUNCTION cas_GetRoutePtsCount;
	
Create Function cas_GetRoutePtsCount (@routeid numeric(38,0))
returns INT AS
BEGIN
	Declare @PtsCount int;
	Select @PtsCount = count(*) 
	from cas_rtepts
	where skfuser1.cas_IsConditionnal(REF_POINT) = 0;
	return @PtsCount;
END