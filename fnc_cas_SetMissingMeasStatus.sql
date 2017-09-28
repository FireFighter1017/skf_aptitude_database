-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE cas_SetMissingMeasStatus 
 
AS
BEGIN
	DECLARE @MissingCount	numeric(18,0)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WHILE EXISTS(SELECT COUNT(*) FROM MEASUREMENT where measid not in (select measid from cas_MeasStatus))
	BEGIN
		waitfor delay '00:00:10'
		insert into cas_MeasStatus (measid, alarmStatus) 
			select top 100 
				measid, 
				skfuser1.cas_getMeasAlarmStatus(pointid, measid) 
			from measurement 
			where measid not in (select measid from cas_MeasStatus)
	END

END
GO
