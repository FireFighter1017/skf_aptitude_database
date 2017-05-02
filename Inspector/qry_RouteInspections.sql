-- Route inspections
select p.POINTID, p.description, i.* from cas_hiepts p left join cas_inspections i on i.POINTID=p.POINTID join cas_rtepts r on r.REFPOINT=p.POINTID
Where ROUTENAME='020-0004'