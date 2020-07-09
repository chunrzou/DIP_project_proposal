library(dplyr)
library(ggplot2)
library(stringr)
library(keras)
K <- keras::backend()

setwd("C:\\Users\\chunr\\DataIncubator\\Project")

## ------------------------------Read files-------------------------------------
case.cts  <- read.csv(file="us-counties.csv",header=T)        # Daily number of cases by counties
pvtEst    <- read.csv(file="PovertyEstimates.csv",header=T)   # Poverty rates
unEmp     <- read.csv(file="Unemployment.csv",header=T)       # Unemployment rates, median income
educ      <- read.csv(file="Education.csv",header=T)          # Education levels
pop       <- read.csv(file="PopulationEstimates.csv",header=T)# population
stateCode <- read.csv(file="StateCode.csv",header=T)          # State code
colnames(stateCode) <- c("State","Abbrev","Code")

## --------------------------preprocess the data frames-----------------------
case.cts <- case.cts %>% filter(state %in% stateCode$State)
case.cts$normDate <- as.Date(case.cts$date,"%m/%d/%Y")        # normalize the date

# standardize the state name
# pvtEst
pvtEst <- pvtEst %>% filter(Stabr %in% stateCode$Code)
pvtState <- c()
for(iState in pvtEst$Stabr){
  pvtState <- c(pvtState,as.character(stateCode$State)[which(stateCode$Code == iState)])
}
pvtEst$State <- pvtState 
# unEmp
unEmp <- unEmp %>% filter(Stabr %in% stateCode$Code)
unEmpState <- c()
for(iState in unEmp$Stabr){
  unEmpState <- c(unEmpState,as.character(stateCode$State)[which(stateCode$Code == iState)])
}
unEmp$State <- unEmpState 
# educ
educ <-  educ %>% filter(State %in% stateCode$Code)
educState <- c()
for(iState in educ$State){
  educState <- c(educState,as.character(stateCode$State)[which(stateCode$Code == iState)])
}
educ$State <- educState 

# pop
pop <- pop %>% filter(State %in% stateCode$Code)
popState <- c()
for(iState in pop$State){
  popState <- c(popState,as.character(stateCode$State)[which(stateCode$Code == iState)])
}
pop$State <- popState 


# standardize the County name 
pvtEst <-  pvtEst %>% filter(str_detect(Area_name,"County"))
pvtEst <- pvtEst %>% mutate(county=str_match(Area_name,"([a-zA-Z]+) County")[,2])

unEmp <- unEmp %>% filter(str_detect(area_name,"County"))
unEmp <- unEmp %>% mutate(county=str_match(area_name,"([a-zA-Z]+) County")[,2])

educ <-  educ %>% filter(str_detect(Area.name,"County"))
educ <-  educ %>% mutate(county=str_match(Area.name,"([a-zA-Z]+) County")[,2])

pop <-  pop %>% filter(str_detect(Area_Name,"County"))
pop <-  pop %>% mutate(county=str_match(Area_Name,"([a-zA-Z]+) County")[,2])
pop$pop2019 <- as.numeric(gsub(",","",as.character(pop$POP_ESTIMATE_2019)))

## plots for daily cases at each State
png(file="daily_cases_by_state.png", 
    width=12, height=12, units="in", type="cairo", res=800)
case.cts %>% with(aggregate(cases,by=list(state=state,date=normDate),FUN=function(x) 
              sum(x,na.rm=T)))  %>% 
          ggplot(aes(date,x,col=state))+geom_point() + theme_bw() + 
          ylab("Daily Cases") +
          theme(legend.title=element_text(size=20),
                legend.text = element_text(size=10),
                legend.position=c(0.25,0.8),
                panel.grid=element_blank(),
                axis.text.x = element_blank(),
                axis.title = element_text(size=20),
                axis.text.y=element_text(size=20))
dev.off()


case.cts$State <- case.cts$state 
case.pop.pvt.may <- case.cts %>% filter(normDate==as.Date("2020-05-01")) %>% 
  merge(pop,by=c("county","State")) %>%
  merge(pvtEst,by=c("county","State")) 
case.pop.pvt.may$poverty_rate <- case.pop.pvt.may$PCTPOVALL_2018
case.pop.pvt.may$case_density <- case.pop.pvt.may$cases/case.pop.pvt.may$pop2019
with(case.pop.pvt.may,cor.test(poverty_rate,case_density))

png(file="correlation_with_poverty_rate.png", 
    width=8, height=8, units="in", type="cairo", res=800)
with(case.pop.pvt.may,plot(poverty_rate,case_density,xlab="poverty rate (%)",ylim=c(0,0.03)))
abline(lm(case_density~poverty_rate,data=case.pop.pvt.may),col="red")
text(40, 0.03, "correlation = 0.04, p value < 0.05")

dev.off()




## --------------------------covid19 pattern clustering using------------------------
## ----------------------- LSTM autoencoder and Kmeans method------------------------
## LSTM to reduce the time sequence dimension to latent dimension (8)
batch_size <- 51
input_dim <- 153    
latent_dim <- 8	       ## To be decided by training
epochs <- 50


layer_input(shape=c(input_dim))
layer_lstm()
layer_lstm()
layer_repeat_vector()
layer_lstm()
layer_lstm()
layer_dense(0)
layer_TimeDistributed()

## Employing Kmeans method to test the number of  stable clusters and obtain the clusters




## Run association and anova analysis on the clusters to understand how factors 
## such as education rate, unemployment rate, temperature, number of guests traveled 
## by flight affects 