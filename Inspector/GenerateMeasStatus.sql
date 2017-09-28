	DECLARE @strdat date;
	DECLARE @enddat date;
	SET @strdat = (select max(cast(routeStart as date)) from cas_measstatus);
	SET @enddat = (cast(getdate() as date));
	EXEC cas_createMeasStatus @startdate = @strdat, @enddate = @enddat;
	GO

EXEC bak_createMeasStatus @startdate = '2013-01-01', @enddate = '2013-06-30';
EXEC bak_createMeasStatus @startdate = '2013-07-01', @enddate = '2013-12-31';
EXEC bak_createMeasStatus @startdate = '2014-01-01', @enddate = '2014-06-30';
EXEC bak_createMeasStatus @startdate = '2014-07-01', @enddate = '2014-12-31';
EXEC bak_createMeasStatus @startdate = '2015-01-01', @enddate = '2015-06-30';
EXEC bak_createMeasStatus @startdate = '2015-07-01', @enddate = '2015-12-31';
EXEC bak_createMeasStatus @startdate = '2016-01-01', @enddate = '2016-06-30';
EXEC bak_createMeasStatus @startdate = '2016-07-01', @enddate = '2016-12-31';
EXEC bak_createMeasStatus @startdate = '2017-01-01', @enddate = '2017-06-30';
EXEC bak_createMeasStatus @startdate = '2017-07-01', @enddate = '2017-12-31';


Select min(routestart), max(routestart) from cas_MeasStatus

Select top 1000 * 
from cas_MeasStatus 
where pointName = 'SEXTR01-STATUT'
order by routestart desc

select * From POINTCAT where ELEMENTID in (
select cast(childid as numeric(38,0)) from cas_tree where Location like '\Hiérarchie%' and Location like '%EXTRES\__EXTRES%'
)


select * from treeelem where TREEELEMID='9756626'