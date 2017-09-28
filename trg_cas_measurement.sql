USE [skfuser]
GO

/****** Object:  Trigger [skfuser1].[meas_trig]    Script Date: 5/9/2017 14:51:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE TRIGGER [skfuser1].[trg_cas_measurement] on [skfuser1].[MEASUREMENT]
AFTER DELETE , UPDATE , INSERT
AS
BEGIN
   DECLARE @MeasId          Numeric
   DECLARE @PointId         Numeric 
   DECLARE @DataDTG         Varchar(240)
   DECLARE @Count           Numeric
   DECLARE @IsActive        Numeric
   DECLARE @MeasurementType Numeric
   DECLARE @StatusCnt		Numeric

   IF EXISTS(SELECT * FROM INSERTED) 
   BEGIN
      DECLARE InsCursorMeas CURSOR LOCAL FAST_FORWARD FOR 
         SELECT MeasId, MeasurementType
         FROM   INSERTED
      OPEN InsCursorMeas

      FETCH NEXT FROM InsCursorMeas INTO @MeasId, @MeasurementType
      WHILE @@FETCH_STATUS = 0
      BEGIN
		 IF EXISTS(SELECT * FROM skfuser1.cas_MeasStatus where measid = @MeasId)
		 BEGIN
			UPDATE skfuser1.cas_MeasStatus 
			set alarmStatus = skfuser1.cas_GetMeasAlarmStatus(@MeasId, @PointId) 
			where measid = @MeasId
		 END
		 ELSE
		 BEGIN
			-- Insert Alarm Status Record in cas_MeasStatus
			INSERT INTO skfuser1.cas_MeasStatus (measid, alarmStatus)
			VALUES (@measid, skfuser1.cas_GetMeasAlarmStatus(@MeasId, @PointId))
		 END
      END

      CLOSE InsCursorMeas
      DEALLOCATE InsCursorMeas
   END 
   ELSE
   BEGIN
      DECLARE DelCursorMeas CURSOR LOCAL FAST_FORWARD FOR 
         SELECT MeasId, PointId, DataDTG
         FROM   DELETED
      OPEN DelCursorMeas

      FETCH NEXT FROM DelCursorMeas INTO @MeasId, @PointId, @DataDTG
      WHILE @@FETCH_STATUS = 0
      BEGIN
		-- Delete AlarmStatus in cas_MeasStatus
		DELETE FROM cas_MeasStatus where measid = @MeasId
      END

      CLOSE DelCursorMeas
      DEALLOCATE DelCursorMeas
   END
END

GO


