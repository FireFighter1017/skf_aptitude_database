if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='cas_GetInspectorAlarmStatus')
	DROP FUNCTION cas_GetInspectorAlarmStatus;
GO
create function cas_GetInspectorAlarmStatus 
(
	@UM varchar(240), 
	@DWORDVAL numeric(38,0),
	@ALARM1 numeric(3,0), 
	@ALARM2 numeric(3,0), 
	@ALARM3 numeric(3,0), 
	@ALARM4 numeric(3,0), 
	@ALARM5 numeric(3,0)
)
returns varchar(10)
as
BEGIN
	DECLARE @Status numeric(3,0);
	DECLARE @Result varchar(10);
	DECLARE @Alarms table (idx numeric(3,0), alarm numeric(3,0));
	insert into @Alarms select 1, @ALARM1 union select 2, @ALARM2 union select 3, @ALARM3 union select 4, @ALARM4 union select 5, @ALARM5;

	IF ((@UM = 'Sélection unique') or (@UM ='Single Selection'))
		SET @Status = 
			CASE
				WHEN @DWORDVAL=1  then @ALARM1
				WHEN @DWORDVAL=2  then @ALARM2
				WHEN @DWORDVAL=4  then @ALARM3
				WHEN @DWORDVAL=8  then @ALARM4
				WHEN @DWORDVAL=12 then @ALARM5
			END;
	ELSE
		IF ((@UM = 'Sélections multiples') or (@UM = 'Multiple Selections'))
			SET @Status =
				CASE 
					WHEN @DWORDVAL = 1  then @ALARM1
					WHEN @DWORDVAL = 2  then @ALARM2
					WHEN @DWORDVAL = 4  then @ALARM3
					WHEN @DWORDVAL = 8  then @ALARM4
					WHEN @DWORDVAL = 16 then @ALARM5
					WHEN @DWORDVAL = 1	then (select max(alarm) from @Alarms where idx in (1))
					WHEN @DWORDVAL = 2  then (select max(alarm) from @Alarms where idx in (2))
					WHEN @DWORDVAL = 3  then (select max(alarm) from @Alarms where idx in (1,2))
					WHEN @DWORDVAL = 4  then (select max(alarm) from @Alarms where idx in (3))
					WHEN @DWORDVAL = 4  then (select max(alarm) from @Alarms where idx in (3))
					WHEN @DWORDVAL = 6  then (select max(alarm) from @Alarms where idx in (2,3))
					WHEN @DWORDVAL = 7  then (select max(alarm) from @Alarms where idx in (1,2,3))
					WHEN @DWORDVAL = 8  then (select max(alarm) from @Alarms where idx in (4))
					WHEN @DWORDVAL = 10 then (select max(alarm) from @Alarms where idx in (2,4))
					WHEN @DWORDVAL = 11 then (select max(alarm) from @Alarms where idx in (1,2,4))
					WHEN @DWORDVAL = 12 then (select max(alarm) from @Alarms where idx in (3,4))
					WHEN @DWORDVAL = 13 then (select max(alarm) from @Alarms where idx in (1,3,4))
					WHEN @DWORDVAL = 14 then (select max(alarm) from @Alarms where idx in (2,3,4))
					WHEN @DWORDVAL = 15 then (select max(alarm) from @Alarms where idx in (1,2,3,4))
					WHEN @DWORDVAL = 16 then (select max(alarm) from @Alarms where idx in (5))
					WHEN @DWORDVAL = 17 then (select max(alarm) from @Alarms where idx in (1,5))
					WHEN @DWORDVAL = 18 then (select max(alarm) from @Alarms where idx in (2,5))
					WHEN @DWORDVAL = 19 then (select max(alarm) from @Alarms where idx in (1,2,5))
					WHEN @DWORDVAL = 20 then (select max(alarm) from @Alarms where idx in (3,5))
					WHEN @DWORDVAL = 21 then (select max(alarm) from @Alarms where idx in (1,3,5))
					WHEN @DWORDVAL = 23 then (select max(alarm) from @Alarms where idx in (1,2,3,5))
					WHEN @DWORDVAL = 22 then (select max(alarm) from @Alarms where idx in (2,3,5))
					WHEN @DWORDVAL = 24 then (select max(alarm) from @Alarms where idx in (4,5))
					WHEN @DWORDVAL = 25 then (select max(alarm) from @Alarms where idx in (1,4,5))
					WHEN @DWORDVAL = 26 then (select max(alarm) from @Alarms where idx in (2,4,5))
					WHEN @DWORDVAL = 27 then (select max(alarm) from @Alarms where idx in (1,2,4,5))
					WHEN @DWORDVAL = 28 then (select max(alarm) from @Alarms where idx in (3,4,5))
					WHEN @DWORDVAL = 29 then (select max(alarm) from @Alarms where idx in (1,3,4,5))
					WHEN @DWORDVAL = 30 then (select max(alarm) from @Alarms where idx in (2,3,4,5))
					WHEN @DWORDVAL = 31 then (select max(alarm) from @Alarms where idx in (1,2,3,4,5))
				END;
	
	SET @Result = 
		CASE
			when @Status = Null then 'OK'
			when @Status = 1 then 'OK'
			when @Status = 2 then 'OK'
			when @Status = 3 then 'ALERT'
			when @Status = 4 then 'DANGER'
		END;
	
	RETURN @Result;
END;