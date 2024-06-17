select t.NAME, r.DEFAULTNAME, r.SIGNATURE,  p.FIELDID, p.VALUESTRING, r2.signature, r2.DEFAULTNAME, t2.name PARENT
from 
	TREEELEM t 
	join TREEELEM t2 on t2.TREEELEMID = t.parentid
	join POINT p on p.elementid=t.TREEELEMID 
	join REGISTRATION r on r.registrationid=p.fieldid 
	join registration r2 on r2.registrationid=p.VALUESTRING 
where t.NAME like 'TEST_%_PATATE' and fieldid=912 
--and ELEMENTID not in (select ELEMENTID from point where fieldid=)
order by p.FIELDID 
;
select FIELDID Item, count(distinct ELEMENTID) ItemCount, count(distinct VALUESTRING) valuesCount from point group by FIELDID having count(distinct ELEMENTID)=(select count(distinct elementid) Item_Count from point)

;
select ELEMENTID, name, tblsetid, containertype 
from point join treeelem on treeelemid=elementid 
where fieldid=912 and valuestring=376 and ELEMENTID not in 
	(select ELEMENTID from point where fieldid=300)
and tblsetid<>0	 

;
select 
	distinct 
	left(signature, charindex('_', signature)),
	case 
		when charindex('_', signature, len(left(signature, charindex('_', signature)))+1) = 0 then
			null
		else
			substring(
				signature,
				len(left(signature, charindex('_', signature)))+1,
				charindex('_', signature, len(left(signature, charindex('_', signature)))+1) - len(left(signature, charindex('_', signature)))
			)	
	end
	case 
		when 
	end
	
	
	/*substring(
		signature,
		len(left(signature, charindex('_', signature)))+1,

		charindex('_', signature, len(left(signature, charindex('_', signature)))+1) - len(left(signature, charindex('_', signature)))
	)*/

from registration

