
***
use "C:\Users\pittman.143\Downloads\WaveIData.dta", replace 
*merge in WIV*
merge 1:1 AID using "C:\Users\pittman.143\Downloads\WaveIVData.dta", gen(mergeWIV) 
*merge in 16b*
merge 1:1 AID using "C:\Users\pittman.143\Downloads\16bdata.dta", gen(_merge16b) 

destring AID, replace


*renaming variable to lowercase 
tolower BIO_SEX* H* I* P* //variables in the original data set are uppercase, in this code I want them to be lowercase

***
*GENDER*
*WI
gen femalew1 = bio_sex
replace femalew1=0 if bio_sex==1
replace femalew1=1 if bio_sex==2
replace femalew1=. if bio_sex==6|bio_sex== 8 //dummy variable for female 
*WIV*
gen femalew4 = bio_sex
replace femalew4=0 if bio_sex4==1
replace femalew4=1 if bio_sex4==2
replace femalew4=. if bio_sex4==6|bio_sex4== 8 //dummy variable for female 

*RELATIONSHIP STATUS
*Only people that are in CURRENT relationships. Married, cohabiting, or dating/pregnant partners(only 1)
*WIV*
gen h4coh16b = (h4currentcoh==1) if h4currentrel <=9
gen h4date16b = (h4currentdate==1) if h4currentrel <=9
gen h4mar16b = (h4currentmar==1) if h4currentrel <=9

*EDUCATION
*WIV
gen h4lesshs = (h4ed2 <= 2) if h4ed2 < 96
gen h4hs = (h4ed2 == 3) if h4ed2 < 96
gen h4somecol = (h4ed2 > 3 & h4ed2 <=6) if h4ed2 < 96
gen h4col = (h4ed2 == 7) if h4ed2 < 96
gen h4colplus = (h4ed2 > 7) if h4ed2 < 96
gen h4educ = . //dummy variable for what is above
replace h4educ=1 if h4lesshs==1
replace h4educ=2 if h4hs==1
replace h4educ=3 if h4somecol==1
replace h4educ=4 if h4col==1
replace h4educ=5 if h4colplus==1

*Age 
*WI
recode h1gi1m (96=.), gen (w1bmonth) 
recode h1gi1y (96=.), gen (w1byear) 
gen w1bdate = mdy(w1bmonth, 15, 1900+w1byear) 
format w1bdate %d 
gen w1idate=mdy(imonth, iday,1900+iyear) 
format w1idate %d 
gen h1age=int((w1idate-w1bdate)/365.25)

*WIV
gen birthyear = 1900 + h1gi1y if h1gi1y < 96
gen birthcm = (birthyear *12) + h1gi1m if h1gi1m < 13 
gen h4intcm = (iyear4 * 12) + imonth4 
gen age = (h4intcm - birthcm)/12 
gen	h4age =	round(age, 1)

*MOTHER's EDUCATION
*WI
gen h1momeduc = (pa12)
replace h1momeduc = (h1rm1) if (pa12 ==.)
replace h1momeduc= . if h1momeduc > 10

*FOREIGN BORN 
*WI
gen foreignborn = (h1gi11 ==0 | pc64)

********************************************************************************

*Race*
*W1
foreach x in a b c d e {
gen rmultir1`x' = .
replace rmultir1`x' = 1 if h1gi6`x' == 1 & h1gi6`x' ==1 
replace rmultir1`x' = 1 if h1gi6`x' == 1 & h1gi6`x' ==1 & h1gi6`x' ==1
replace rmultir1`x' = 1 if h1gi6`x' == 1 & h1gi6`x' ==1 & h1gi6`x' ==1 & h1gi6`x' ==1
replace rmultir1`x' = 1 if h1gi6`x' == 1 & h1gi6`x' ==1 & h1gi6`x' ==1 & h1gi6`x' ==1 & h1gi6`x' ==1
}
egen rmultiracesum1 = rowtotal (rmultir1a rmultir1b rmultir1c rmultir1d rmultir1e) // if they are only 1 race they'll get a 1
gen rmultirace1 = rmultiracesum1
replace rmultirace1 =1 if rmultiracesum1 >1
replace rmultirace1 =0 if rmultiracesum1 ==1


*single race respondent*//if they idicated that they are ONLY this race/ethnicity 
gen rwhite =1 if h1gi6a==1 //ONLY White
replace rwhite = 0 if h1gi6a != 1 
replace rwhite = . if h1gi6a > 1 
replace rwhite = 0 if rmultirace1 ==1

gen rblack = 1 if h1gi6b ==1 
replace rblack = 0 if h1gi6b != 1
replace rblack = . if h1gi6b >1
replace rblack = 0 if rmultirace1 ==1

gen ramin = 1 if h1gi6c ==1
replace ramin = 1 if h1gi6c ==1 
replace ramin = 0 if h1gi6c !=1
replace ramin = . if h1gi6c >1 
replace ramin = 0 if rmultirace1 ==1

gen rasian = 1 if h1gi6d ==1
replace rasian = 1 if h1gi6d ==1 
replace rasian = 0 if h1gi6d !=1 
replace rasian = . if h1gi6d >1 
replace rasian = 0 if rmultirace1 == 1

gen rother = 1 if h1gi6e ==1 
replace rother = 0 if h1gi6e !=1
replace rother = . if h1gi6e >1
replace rother = 0 if rmultirace1 ==1 

*FORCED CHOICE MULTIRACIAL 
replace rwhite =1 if h1gi8==1
replace rmultirace1 =0 if h1gi8==1
replace rblack =1 if h1gi8==2
replace rmultirace1 =0 if h1gi8==2
replace ramin =1 if h1gi8==3
replace rmultirace1 =0 if h1gi8==3
replace rasian =1 if h1gi8==4
replace rmultirace1 =0 if h1gi8==4
replace rother =1 if h1gi8==5
replace rmultirace1 =0 if h1gi8==5
drop if rmultirace1==1

*HISPANIC
gen rhisp = (h1gi4) //Hispanic for anyone who reported any Hispanic ethnicity regardless of how they reported their racial identity
replace rhisp =0 if rhisp==6|rhisp==8
replace rwhite=0 if rhisp ==1
replace rblack=0 if rhisp ==1
replace ramin=0 if rhisp==1
replace rasian=0 if rhisp==1
replace rother=0 if rhisp==1
drop if rhisp >=6

*PARTNER @ WIV*
gen pwhite=1 if h4tr24 ==1
replace pwhite = 0 if h4tr24 !=1

gen pblack=1 if h4tr24 ==2
replace pblack = 0 if h4tr24 !=2

gen pamin=1 if h4tr24 ==3
replace pamin = 0 if h4tr24 !=3

gen pasian=1 if h4tr24 ==4
replace pasian = 0 if h4tr24 !=4

gen pother=1 if h4tr24 ==5
replace pother = 0 if h4tr24 !=5

*HISPANIC PARTNER
gen phisp = h4tr23
replace phisp =0 if phisp==6|phisp==8
replace pwhite= 0 if phisp==1
replace pblack= 0 if phisp==1
replace pamin= 0 if phisp==1
replace pasian= 0 if phisp==1
replace pother= 0 if phisp==1

*INTERRACIAL COUPLES* 
*White Respondent
gen craceww=. //white r, white p
replace craceww = 1 if rwhite==1 & pwhite==1

gen cracewb=. //white r, black p
replace cracewb = 1 if rwhite==1 & pblack==1

gen cracewh=. //white r, hispanic p
replace cracewh = 1 if rwhite==1 & phisp==1

*Black respondent 
gen cracebb=. //black r, black p
replace cracebb = 1 if rblack==1 & pblack==1

gen cracebw=. //black r, white p
replace cracebw = 1 if rblack==1 & pwhite==1

gen cracebh=. //black r, hispanic p
replace cracebh = 1 if rblack==1 & phisp==1 //due to sample size, only looking at white, black & hispanic

*Hispanic Respondent 
gen cracehh=. //hisp r, hisp p
replace cracehh= 1 if rhisp==1 & phisp==1

gen cracehw=. //hisp r, white p
replace cracehw = 1 if rhisp==1 & pwhite==1

gen cracehb=. //hisp r, black p
replace cracehb = 1 if rhisp==1 & pblack==1

drop if craceww ==. & cracewb ==. & cracewh ==. & cracebb ==. & cracebw ==. & cracebh ==. & cracehh ==. & cracehw ==. & cracehb ==.
replace craceww=0 if craceww!=1
replace cracewb=0 if cracewb!=1
replace cracewh=0 if cracewh!=1
replace cracebb=0 if cracebb!=1
replace cracebw=0 if cracebw!=1
replace cracebh=0 if cracebh!=1
replace cracehh=0 if cracehh!=1
replace cracehw=0 if cracehw!=1
replace cracehb=0 if cracehb!=1

**
gen h4interrace=.
replace h4interrace =0 if craceww ==1
replace h4interrace =0 if cracebb ==1
replace h4interrace =0 if cracehh ==1
replace h4interrace =1 if cracewb ==1
replace h4interrace =1 if cracewh ==1
replace h4interrace =1 if cracebw ==1
replace h4interrace =1 if cracebh ==1
replace h4interrace =1 if cracehw ==1
replace h4interrace =1 if cracehb ==1

*INTERRACIAL RELATIONSHIP TYPE*
gen h4interracemar =1 if h4currentmar ==1 & h4interrace ==1
replace h4interracemar =0 if h4interracemar !=1

gen h4interracecoh =1 if h4currentcoh ==1 & h4interrace ==1
replace h4interracecoh =0 if h4interracecoh !=1

gen h4interracedate =1 if h4currentdate ==1 & h4interrace ==1
replace h4interracedate =0 if h4interracedate !=1

***********OUTCOMES*************
*DEPRESSION 
foreach num of numlist 18 19 21 22 23 26 27 {
clonevar h4mh`num'r = h4mh`num' if h4mh`num' <= 3
}

foreach num of numlist 20 24 25 {
gen h4mh`num'r = 0 if h4mh`num' ==3 
replace h4mh`num'r = 1 if h4mh`num' == 2 
replace h4mh`num'r = 2 if h4mh`num' == 1 
replace h4mh`num'r = 3 if h4mh`num' == 0 
}
egen h4dep = rowtotal (h4mh18r-h4mh25r),  m
alpha h4mh18r-h4mh25r if h4dep !=. 


**PERCIEVED STRESS
clonevar h4mh3r = h4mh3 if h4mh3 <= 4 
clonevar h4mh6r = h4mh6 if h4mh6 <= 4 

foreach num of numlist 4 5 {
gen h4mh`num'r = 0 if h4mh`num' ==4
replace h4mh`num'r =1 if h4mh`num' ==3 
replace h4mh`num'r =2 if h4mh`num' ==2 
replace h4mh`num'r =3 if h4mh`num' ==1 
replace h4mh`num'r =4 if h4mh`num' ==0 
}
egen h4pss = rowtotal (h4mh3r h4mh4r h4mh5r h4mh6r), m 
alpha h4mh3r h4mh4r h4mh5r h4mh6r if h4pss != . 

*DISCRIMINATION @ W4
clonevar h4discrim = h4mh28 if h4mh28 <=3

*Self-Rated Health
*WI
gen h1srh = (h1gh1)
*WIV
gen h4srh = (h4gh1)


