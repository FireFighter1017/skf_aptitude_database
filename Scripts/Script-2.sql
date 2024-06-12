select year(startdts), count(*) from cas_rtehis
where operator in ('REMY BEAUDET','WILLIAM RANDLETT')
group by year(startdts)