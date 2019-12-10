#installing packges 
install.packages("plotly")
install.packages("ggplot2")
install.packages("expss")
install.packages("plyr")

library(readxl)
GISD_Repro_Final_Project <- read_excel("GISD Repro Final Project.xls")
View(GISD_Repro_Final_Project)


#model name
#reg.res <- lm(outcome var name ~ Predictor1 + Predictor2, datasetname)
#reg.res is the name of the object 
# <- is specifying what the object is 
#lm stands for linear model (regression, command to run a regression)
#outcome var name is what you are predicting. needs to be the variable name of that thing 
#predictors and controls
#name  of the dataset 


model1 <- lm(h4dep ~ h4interrace + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model1)

model2 <- lm(h4dep ~ cracewb + cracewh + cracebb + cracebw +  cracebh + cracehh + cracehw + cracehb + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model2)

model3 <- lm(h4srh ~ h4interrace + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model3)

model4 <- lm(h4srh ~ cracewb + cracewh + cracebb + cracebw +  cracebh + cracehh + cracehw + cracehb + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model4)

model5 <- lm(h4pss ~ h4interrace + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model5)

model6 <- lm(h4srh ~ cracewb + cracewh + cracebb + cracebw +  cracebh + cracehh + cracehw + cracehb + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model6)

model7 <- lm(h4discrim ~ h4interrace + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model7)

model8 <- lm(h4discrim ~ cracewb + cracewh + cracebb + cracebw +  cracebh + cracehh + cracehw + cracehb + h4date16b + h4coh16b + h4age + femalew1 + h1momeduc + foreignborn, data=GISD_Repro_Final_Project)
summary(model8)



table(GISD_Repro_Final_Project$crace)
barplot(table(GISD_Repro_Final_Project$crace), 
        main= "Couple's Racial Composition",
        xlab=("Couple Race"), 
        ylab=("Frequency"),  
        col=c("red","red","red", "purple", "purple","purple", "blue","blue","blue"),
        names.arg=c("White/White", "White/Black", "White/Hispanic", "Black/Black", "Black/White" , "Black/Hispanic", "Hispanic/Hispanic", "Hispanic/White" ,"Hispanic/Black")
)

library("plyr")

summary(GISD_Repro_Final_Project$h4age)
count(GISD_Repro_Final_Project,"h4interrace")
count(GISD_Repro_Final_Project,"h4mar16b")
count(GISD_Repro_Final_Project,"h4coh16b")
count(GISD_Repro_Final_Project,"h4date16b")
count(GISD_Repro_Final_Project,"femalew1")



