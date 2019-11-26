*16b*
*This data includes more than one line of data for participants that have more than one partner, so these lines of code are to give each respondent one line.
*current relationship status*

use "C:\Users\pittman.143\Downloads\16bdata.dta", clear

gen h4mar = 1 if H4TR13 == 1 //creating dummy variable for married 
gen h4coh = 1 if H4TR13 == 2 //dummy variable for cohabiting
gen h4date = 1 if H4TR13 == 4 //dummy variable for dating
replace h4date = 1 if H4TR13 == 3 //dummy included with dating if respondent indicated that they were dating their pregnant partner

gen h4currentmar = 1 if h4mar ==1 & H4TR14 ==1 //current married
gen h4currentcoh = 1 if h4coh ==1 & H4TR14 ==1 //current cohabiting
gen h4currentdate = 1 if h4date ==1 & H4TR14 ==1 //current dating 
replace h4currentdate =1 if H4TR13 ==4

egen h4current = rowtotal (h4currentmar h4currentcoh h4currentdate), missing
sort AID PTNR_ID
by AID: egen h4currentrel = sum(h4current), missing 
gen h4single = (h4current == 0) //people that are currently married, dating, or cohabiting 

by AID: egen h4marmax = sum(h4currentmar)
by AID: egen h4cohmax = sum(h4currentcoh)
by AID: egen h4datemax = sum(h4currentdate)

**
gen refcurrentrel = 1 if h4current !=1
**
gen refmarmax = 1 if h4marmax > 1 
gen refmarmax2 =1 if h4mar !=1 & h4marmax >=1
gen refcohmax = 1 if h4cohmax > 1 
gen refcohmax2 =1 if h4coh !=1 & h4cohmax >=1
gen refdatemax =1 if h4datemax > 1 & h4marmax ==0 & h4cohmax ==0 

drop if h4current !=1 
drop if h4marmax > 1 
drop if h4mar !=1 & h4marmax >=1 
drop if h4cohmax > 1 
drop if h4coh !=1 & h4cohmax >= 1 
drop if h4datemax > 1 & h4marmax ==1 & h4cohmax == 0

gen ref=1 
sort AID PTNR_ID 
by AID: egen ref_sum = sum(ref)
tab ref_sum 
drop if ref_sum > 1
save "C:\Users\pittman.143\Downloads\16bdata.dta", replace 
*Now everyone has one line of data and only 1 partner if they are dating and not married/cohabiting