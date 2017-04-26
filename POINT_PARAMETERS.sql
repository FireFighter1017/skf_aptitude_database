Select
	t.name,
	p.valuestring,
	p.datatype,
	r.*
From 
	point p 
	join registration r 
		on registrationid=fieldid 
	join treeelem t 
		on treeelemid=elementid 
			and t.containertype=4 
			and t.hierarchytype=1

			where p.pointid=10013
			
/* Valuestrings:
	
	20500 = Detection "Pic"
	20202 = Save Data "FFT et Temporel"
	20300 = Type fréq. "Intervalle fixe"
	20401 = Fenêtre "Hanning"
			
*/