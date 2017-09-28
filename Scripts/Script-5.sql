select measYear, measMonth, count(measid) from cas_measStatus
group by measyear,
measmonth
order by measyear,
measmonth