-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [skfuser1].[cas_createMeasStatus]
	@startdate date, -- Date to use when selecting start week
	@enddate date -- Date to use when selecting end week
AS
BEGIN
	
	DECLARE @wstr date
	DECLARE @wend date
	SET @wstr = @startdate
	SET @wend = dateadd(wk, 1, @startdate)

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON


	-- Empty table if requested
	delete from skfuser1.cas_MeasStatus where routeStart>=@startdate and routeStart<=@enddate

	-- Start filling the table week by week until end date is reached
	while @wstr < @enddate
	begin
 		Insert into cas_measStatus
		select [plantName]
			  ,[routeName]
			  ,[machineDescription]
			  ,[machineName]
			  ,[pointCategory]
			  ,[OPERATOR_GROUP]
			  ,[OPERATOR_NAME]
			  ,[pointName]
			  ,[pointDescription]
			  ,[rankInRoute]
			  ,[routeStart]
			  ,[routeEnd]
			  ,[routeUpload]
			  ,[pctcomplete]
			  ,[measId]
			  ,[MeasStatus]
			  ,[MeasGravity]
			  ,[measMonth]
			  ,[measWeek]
			  ,[measYear] 
		from cas_AllMeasStatus
		where 
			/*** FILTRES STANDARDS ***/
			-- Période désirée
			routestart>=@wstr and routestart<=@wend			
					
		set @wstr = dateadd(wk,1,@wstr)
		set @wend = dateadd(wk,1,@wend)
		if (@wend > @enddate) set @wend=@enddate
	end

END;
