Select
	t.name,
	p.fieldid,
	p.valuestring,
	p.datatype,
	r.SIGNATURE ParameterName,
	r.[TYPE] 
From 
	point p 
	join registration r 
		on r.registrationid=p.fieldid 
	join treeelem t 
		on t.treeelemid=p.elementid 
			and t.containertype=4 
			and t.hierarchytype=1

where t.name='IEXT001-LIEU'

			
/* Valuestrings:
	
	20500 = Detection "Pic"
	20202 = Save Data "FFT et Temporel"
	20300 = Type fréq. "Intervalle fixe"
	20401 = Fenêtre "Hanning"
			
*/