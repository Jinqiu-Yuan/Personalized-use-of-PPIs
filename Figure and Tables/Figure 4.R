library("AF")
###Figure 4
######main data-------------------------------------
library(survival)
library(rms)
library(pROC)
library(timeROC)
library(ggDCA)
library(riskRegression)
library(glmnet)
DIS30<-read.csv("lancet_dis30.csv",header=TRUE, sep=",")
DIS30$Survtime_M15<-apply(DIS30[c(2,21,22,23,25,26,27,28,31,34,35,36,37,40,42)],1,min)
#DIS30$Survtime_M15<-apply(DIS30[c(2,21,22,23,25,26,27,28,31,34,35,36,40,42)],1,min)
####去掉diarre infection 
# DIS30$Survtime_M13<-apply(DIS30[c(2,21,22,23,25,27,28,34,35,37,40,42)],1,min)
# DIS30$Survtime_M11<-apply(DIS30[c(21,22,23,25,27,28,34,35,37,40,42)],1,min)

data_md<-merge(dataukb,DIS30,by="n_eid")
data_md<-data_md[complete.cases(data_md$BMI),]
data_md<-data_md[complete.cases(data_md$age),]
data_md<-data_md[complete.cases(data_md$smoking),]
data_md$ageC<-ifelse(data_md$age>=60,1,0)
data_md$smoking<- ifelse(data_md$smoking=="unkonwn/missing",3, data_md$smoking)
data_md$smoking<-factor(data_md$smoking,levels = c("1","2","3"),labels = c("Current" ,"Previous"  ,"Never" ))
data_md$smoking<-fct_relevel(data_md$smoking,"Never")
table(data_md$smoking)

data_md$drinking4<- ifelse(data_md$drinking4=="unkonwn/missing",2, data_md$drinking4)
data_md$drinking4<-factor(data_md$drinking4,levels = c("1","2","3","4"),labels = c("Daily or almost daily" ,"1-4 times a week" ,"One to three times a month" ,"Special occasions only/Never"  ))
table(data_md$drinking4)

table(data_md$fruit_g)
data_md$fruit_g<- ifelse(data_md$fruit_g=="Missing",NA, data_md$fruit_g)
data_md$fruit_g<-factor(data_md$fruit_g,levels = c("1","2"),labels = c("No","Yes"))
table(data_md$fruit_g)

data_md$illness_L<- ifelse(data_md$illness_L=="Do not know","1", data_md$illness_L)
data_md$illness_L<-factor(data_md$illness_L,levels = c("1","2"),labels = c("No","Yes"))
table(data_md$illness_L)
data_md$vitamin<- ifelse(data_md$vitamin=="Missing","1", data_md$vitamin)
data_md$vitamin<-factor(data_md$vitamin,levels = c("1","2"),labels = c("No","Yes"))
table(data_md$vitamin)

data_md$HayfeverD<- ifelse(data_md$HayfeverD=="Missing","1", data_md$HayfeverD)
data_md$HayfeverD<-factor(data_md$HayfeverD,levels = c("1","2"),labels = c("No","Yes"))
table(data_md$HayfeverD)

table(data_md$Health_R)
data_md$Health_R<- ifelse(data_md$Health_R=="Do not know","3", data_md$Health_R)
data_md$Health_R<-factor(data_md$Health_R,levels = c("1","2","3","4"),labels = c("Poor","Fair","Good","Excellent"))
table(data_md$Health_R)

table(data_md$mineral)
data_md$mineral<- ifelse(data_md$mineral=="Missing","1", data_md$mineral)
data_md$mineral<-factor(data_md$mineral,levels = c("1","2"),labels = c("No","Yes"))
table(data_md$mineral)

data_md$chol_m<- ifelse(data_md$chol_m=="Missing","1", data_md$chol_m)
data_md$chol_m<-factor(data_md$chol_m,levels = c("1","2"),labels = c("No","Yes"))
table(data_md$chol_m)


data_md$sleep_t<- ifelse(is.na(data_md$sleep_t),7, data_md$sleep_t)
data_md$sleep_t<-as.numeric(data_md$sleep_t)
data_md<-within(data_md,
                {sleep_tc<-0
                sleep_tc[sleep_t<8]<-1
                sleep_tc[sleep_t==8.0]<-2
                sleep_tc[sleep_t<=9&sleep_t>8.0]<-3
                sleep_tc[sleep_t>9]<-4})
data_md$sleep_tc<-factor(data_md$sleep_tc)


data_md$SBP<- ifelse(is.na(data_md$SBP),120, data_md$SBP)


data_md$bp_mm<-0
data_md<-within(data_md, 
                {bp_mm[bp_m=="Yes"]=1
                bp_mm[HBP==1 &(ACEI==1|ARBs==1 |beteb==1|Cach==1|TD==1|LD==1|PSD==1)]=1})

data_md$b_CVD<-0
data_md<-within(data_md, 
                {b_CVD[CHD_b=="Yes" |stroke_b=="Yes"]=1})
data_md$ind<-0
data_md<-within(data_md,
                {ind[gerd_b=="Yes"|ulcer_b=="Yes"|ugib_b=="Yes"|h2ra_S0=="Yes"]<-1
                })

data_md$IBD_bb<-0
data_md<-within(data_md,
                {IBD_bb[UC_b=="Yes"| CD_b=="Yes"| IBD_b=="Yes"]<-1
                })
###### Framingham CHD Risk Profile-------------------
##https://www.mdcalc.com/calc/38/framingham-risk-score-hard-coronary-heart-disease#evidence
vars<-c("n_eid", "survt_stroke", "survt_isd","isd_case","stroke_case",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind",  
        "BMI","weight","SBP","gender","glucose","HbA1c",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")
data_IHD<-data_md[vars]
data_IHD<-data_IHD[data_IHD$b_CVD==0&data_IHD$survt_isd>0,]

data_IHD$SMK=0
data_IHD$SMK[data_IHD$smoking=="Current"]=1
data_IHD$HTNR<-data_IHD$bp_mm

data_IHD$ddm<-as.numeric(data_IHD$ddm)

data_IHDM<-data_IHD[data_IHD$gender=="Male",]
data_IHDM$CHOL<- ifelse(is.na(data_IHDM$CHOL),5.552, data_IHDM$CHOL)
data_IHDM$HDL<- ifelse(is.na(data_IHDM$HDL),1.248, data_IHDM$HDL)

data_IHDM<-within(data_IHDM,
                  {SC<-NA
                  L_Men<-NA
                  L_Men = 52.00961 * log(age1) + 20.014077 * log(CHOL) +(-0.905964 )* log(HDL)+ 1.305784 * log(SBP) + 0.241549 * HTNR +12.096316 *SMK + (-4.605038) * log(age1) * log(CHOL) +(-2.84367) * log(age1) * SMK +( -2.93323) * log(age1) * log(age1) - 172.300168
                  SC<-1-(0.9402^(exp(L_Men)))
                  })


data_IHDM<-within(data_IHDM,{
  sc3<-NA
  sc3[SC<=quantile(SC,1)]=4
  sc3[SC<=quantile(SC,0.75)]=3
  sc3[SC<=quantile(SC,0.5)]=2
  sc3[SC<=quantile(SC,0.25)]=1})

data_IHDF<-data_IHD[data_IHD$gender=="Female",]
data_IHDF$CHOL<- ifelse(is.na(data_IHDF$CHOL),5.846, data_IHDF$CHOL)
data_IHDF$HDL<- ifelse(is.na(data_IHDF$HDL),1.56 , data_IHDF$HDL)

data_IHDF<-within(data_IHDF,
                  {SC<-NA
                  L_WOMen<-NA
                  L_WOMen = 31.764001 * log(age1) + 22.465206 * log(CHOL) +( -1.187731 )* log(HDL)  + 2.552905 * log(SBP) + 0.420251 * HTNR +13.07543 *SMK + (-5.060998) * log(age1) * log(CHOL) +(-2.996945) * log(age1) * SMK  - 146.5933061
                  SC<-1-(0.98767^(exp(L_WOMen)))
                  })

data_IHDF<-within(data_IHDF,{
  sc3<-NA
  sc3[SC<=quantile(SC,1)]=4
  sc3[SC<=quantile(SC,0.75)]=3
  sc3[SC<=quantile(SC,0.5)]=2
  sc3[SC<=quantile(SC,0.25)]=1})
data_IHD<-dplyr::bind_rows(data_IHDM,data_IHDF)

table(data_IHD[data_IHD$sc3==1,]$PPI_S0,data_IHD[data_IHD$sc3==1,]$isd_case)
aggregate(survt_isd~PPI_S0,data_IHD[data_IHD$sc3==1,],sum)

table(data_IHD[data_IHD$sc3==2,]$PPI_S0,data_IHD[data_IHD$sc3==2,]$isd_case)
aggregate(survt_isd~PPI_S0,data_IHD[data_IHD$sc3==2,],sum)

table(data_IHD[data_IHD$sc3==3,]$PPI_S0,data_IHD[data_IHD$sc3==3,]$isd_case)
aggregate(survt_isd~PPI_S0,data_IHD[data_IHD$sc3==3,],sum)

table(data_IHD[data_IHD$sc3==4,]$PPI_S0,data_IHD[data_IHD$sc3==4,]$isd_case)
aggregate(survt_isd~PPI_S0,data_IHD[data_IHD$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_isd,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_IHD[data_IHD$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out1 <- out[1,]
out1

fit<- coxph(Surv(age1,age1+survt_isd,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_IHD[data_IHD$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out2 <- out[1,]
out2

fit<- coxph(Surv(age1,age1+survt_isd,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_IHD[data_IHD$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out3 <- out[1,]
out3

fit<- coxph(Surv(age1,age1+survt_isd,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_IHD[data_IHD$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out4 <- out[1,]
out4



#######strata by Framingham Stroke Risk Profile-----------
#####https://doi.org/10.1161/CIRCULATIONAHA.115.021275
vars<-c("n_eid", "survt_stroke", "survt_isd","isd_case","stroke_case",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "AF_b" ,"CVD_b",
        "BMI","weight","SBP","gender","glucose","HbA1c",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")


data_stroke<-data_md[vars]
data_stroke<-data_stroke[data_stroke$stroke_b=="No"& data_stroke$survt_stroke>0,]

data_stroke$SMK=0
data_stroke$SMK[data_stroke$smoking=="Current"]=1
data_stroke$AAF=0
data_stroke$AAF[data_stroke$AF_b=="Yes"]=1
data_stroke$HTNR<-data_stroke$bp_mm

data_stroke$ddm<-as.numeric(data_stroke$ddm)
data_stroke$CVD_b<-as.numeric(data_stroke$CVD_b)
data_strokeM<-data_stroke[data_stroke$gender=="Male",]
data_strokeM<-within(data_strokeM,
                     {SC<-NA
                     SC<-1-(0.94451^(exp(age1/10*0.49716+0.47254*SMK+0.45341*CVD_b+AAF*0.08064+(age1>=65)*0.45426+
                                           (age1<65)*ddm*1.35304+(age1>=65)*ddm*0.34385+HTNR*0.82598+(HTNR=0)*((SBP>=120)*(SBP-120)/10)*0.27323+
                                           (HTNR=1)*((SBP>=120)*(SBP-120)/10)*0.09793-4.4227101)))
                     })

data_strokeM<-within(data_strokeM,{
  sc3<-NA
  sc3[SC<=quantile(SC,1)]=4
  sc3[SC<=quantile(SC,0.75)]=3
  sc3[SC<=quantile(SC,0.5)]=2
  sc3[SC<=quantile(SC,0.25)]=1})
data_strokeF<-data_stroke[data_stroke$gender=="Female",]
data_strokeF<-within(data_strokeF,
                     {SC<-NA
                     SC<-1-(0.95911^(exp(age1/10*0.87938+0.51127*SMK-0.03035*CVD_b+AAF*1.20720+(age1>=65)*0.39796+
                                           (age1<65)*ddm*1.07111+(age1>=65)*ddm*0.06565+HTNR*0.13085+(HTNR=0)*((SBP>=120)*(SBP-120)/10)*0.11303+
                                           (HTNR=1)*(SBP>=120)*((SBP-120)/10)*0.17234-6.6170719)))
                     })

data_strokeF<-within(data_strokeF,{
  sc3<-NA
  sc3[SC<=quantile(SC,1)]=4
  sc3[SC<=quantile(SC,0.75)]=3
  sc3[SC<=quantile(SC,0.5)]=2
  sc3[SC<=quantile(SC,0.25)]=1})
data_stroke<-rbind(data_strokeM,data_strokeF)

table(data_stroke[data_stroke$sc3==1,]$PPI_S0,data_stroke[data_stroke$sc3==1,]$stroke_case)
aggregate(survt_stroke~PPI_S0,data_stroke[data_stroke$sc3==1,],sum)

table(data_stroke[data_stroke$sc3==2,]$PPI_S0,data_stroke[data_stroke$sc3==2,]$stroke_case)
aggregate(survt_stroke~PPI_S0,data_stroke[data_stroke$sc3==2,],sum)

table(data_stroke[data_stroke$sc3==3,]$PPI_S0,data_stroke[data_stroke$sc3==3,]$stroke_case)
aggregate(survt_stroke~PPI_S0,data_stroke[data_stroke$sc3==3,],sum)

table(data_stroke[data_stroke$sc3==4,]$PPI_S0,data_stroke[data_stroke$sc3==4,]$stroke_case)
aggregate(survt_stroke~PPI_S0,data_stroke[data_stroke$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_stroke,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_stroke[data_stroke$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out5 <- out[1,]
out5

fit<- coxph(Surv(age1,age1+survt_stroke,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_stroke[data_stroke$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out6 <- out[1,]
out6

fit<- coxph(Surv(age1,age1+survt_stroke,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_stroke[data_stroke$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out7 <- out[1,]
out7

fit<- coxph(Surv(age1,age1+survt_stroke,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_stroke[data_stroke$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out8 <- out[1,]
out8

###########COPD---------------
#####doi: 10.1038/npjpcrm.2014.11.---
vars<-c("n_eid", "asthma_b","survt_asth","survt_copd" ,"copd_case","asth_case","survt_lres",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "COPD_b" ,
        "BMI","weight","SBP","gender","glucose","HbA1c","salbutamol",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")


data_copd<-data_md[vars]
data_copd<-data_copd[data_copd$COPD_b=="No"&data_copd$survt_copd>0,]

data_copd$asthma_bb<-0
data_copd$asthma_bb[data_copd$asthma_b=="Yes"|data_copd$survt_asth<=0]=1

data_copd$LRTI=0
data_copd$LRTI[data_copd$survt_lres<=0]=1

data_copd$smk1=0
data_copd$smk1[data_copd$smoking=="Previous"]=1
data_copd$smk2=0
data_copd$smk2[data_copd$smoking=="Current"]=1
data_copd$salbutamol<-as.numeric(data_copd$salbutamol)-1
data_copd$IDM<- ifelse(is.na(data_copd$IDM), 12.57, data_copd$IDM)
data_copd$SMK=0
data_copd$SMK[data_copd$smoking=="Current"|data_copd$smoking=="Previous"]=1
data_copd$IDM55<-eqcut(data_copd$IDM,5)
data_copd$IDM55<-as.numeric(data_copd$IDM55)
data_copd$agecatt<-cut(data_copd$age,breaks=c(35,40,45,50,55,60,65,75))
data_copd$agecatt<-as.numeric(data_copd$agecatt)


data_copd<-within(data_copd,
                  {SC<-NA
                  SC<-1.55*smk1+2.46*smk2+asthma_bb*0.75+0.94*LRTI+salbutamol*1.93
                  sc3<-NA
                  sc3[SC<=quantile(SC,1)]=4
                  sc3[SC<=quantile(SC,0.75)]=3
                  sc3[SC<=quantile(SC,0.5)]=2
                  sc3[SC<=quantile(SC,0.25)]=1})


Q_npj_M_2018<-function(age,smoke_cat,IDM,asthma_bbb){
  ### /* The conditional arrays */
  Iage =c(
    0.0000,
    0.7226,
    1.3540,
    1.7945,
    2.2681,
    2.6401,
    3.4623
  )
  
  Iidm=c( 
    0.0000,
    0.3073,
    0.4686,
    0.6470,
    0.9262
  )
  sc= sc= Iage[age]+smoke_cat*1.9057+Iidm[IDM]+asthma_bbb*1.21481613131225
  
  return (sc)}


Q_npj_F_2018<-function(agecat,smoke_cat,IDM,asthma_bbb){
  ### /* The conditional arrays */
  Iage =c(
    0.0000,
    0.7195,
    1.3113,
    1.7030,
    2.0982,
    2.3529,
    3.2485
    
  )
  
  Iidm=c( 
    0.0000,
    0.2233,
    0.4989,
    0.6666,
    0.9485
  )
  sc= Iage[age]+smoke_cat*2.26226186774655+Iidm[IDM]+asthma_bbb*1.02504351940985
  return (sc)}

data_copd$sc<-0
data_copd$sc3<-1
data_copd[data_copd$gender=="Male",]<-within(data_copd[data_copd$gender=="Male",], 
                                             {sc<-Q_npj_M_2018(agecatt,SMK,IDM55,asthma_bb)
                                             sc3[sc<=quantile(sc,1)]=4
                                             sc3[sc<=quantile(sc,0.75)]=3
                                             sc3[sc<=quantile(sc,0.5)]=2
                                             sc3[sc<=quantile(sc,0.25)]=1})

data_copd[data_copd$gender=="Female",]<-within(data_copd[data_copd$gender=="Female",], 
                                               {sc<-Q_npj_M_2018(agecatt,SMK,IDM55,asthma_bb)
                                               sc3[sc<=quantile(sc,1)]=4
                                               sc3[sc<=quantile(sc,0.75)]=3
                                               sc3[sc<=quantile(sc,0.5)]=2
                                               sc3[sc<=quantile(sc,0.25)]=1})



table(data_copd[data_copd$sc3==1,]$PPI_S0,data_copd[data_copd$sc3==1,]$copd_case)
aggregate(survt_copd~PPI_S0,data_copd[data_copd$sc3==1,],sum)

table(data_copd[data_copd$sc3==2,]$PPI_S0,data_copd[data_copd$sc3==2,]$copd_case)
aggregate(survt_copd~PPI_S0,data_copd[data_copd$sc3==2,],sum)

table(data_copd[data_copd$sc3==3,]$PPI_S0,data_copd[data_copd$sc3==3,]$copd_case)
aggregate(survt_copd~PPI_S0,data_copd[data_copd$sc3==3,],sum)

table(data_copd[data_copd$sc3==4,]$PPI_S0,data_copd[data_copd$sc3==4,]$copd_case)
aggregate(survt_copd~PPI_S0,data_copd[data_copd$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_copd,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_copd[data_copd$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out9 <- out[1,]
out9

fit<- coxph(Surv(age1,age1+survt_copd,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_copd[data_copd$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out10 <- out[1,]
out10

fit<- coxph(Surv(age1,age1+survt_copd,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_copd[data_copd$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out11 <- out[1,]
out11

fit<- coxph(Surv(age1,age1+survt_copd,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_copd[data_copd$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out12 <- out[1,]
out12


############qdiabetes----------------------------------------
###https://qdiabetes.org/src.php--
vars<-c("n_eid", "Survtime_db", "Survtime_dma",     "db" ,    "dma","survt_diab","diab_case",
        "chol_s","hypert_s","db_s","DM", "high_bpD" , "ddm", "HBP","bca","chol_h",
        "CHD_b","TIA_b","stroke_b","dma_b", 
        "oest_b",  "gerd_b","Dysp_b","ulcer_b" ,"ugib_b",
        "BMI","weight","height","gender","glucose","HbA1c","HDL","TG",
        "centre","age","eth","IDM","IDM5","drinking","smoking","MET","Phy_act","fruit","vageta","F_V_t","fruit_g",
        "dmm_h","chol_m",
        "ACEI",  "ARBs",  "beteb", "Cach" , "TD" ,"LD","PSD", "antp","clogrel" , "antg",
        "PPI_S0","h2ra_S0", 
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "cen_obesity","obesity","h2ra_S0", "sleep_tc","Health_R","illness_L","ind",
        "drinking4","age1","edu2","agecat","ment_b","meat_rdPc",
        "age","eth9","IDM","BMI","smk5","dmm_hf","bp_mm","LSD_b","schizo_b","bipo_b","cortiod","statin","antip","GDM_b","POS_b"
)


data_db<-data_md[vars]
data_db<-data_db[data_db$ddm==0&data_db$survt_diab>0,]
data_db$IDM<- ifelse(is.na(data_db$IDM), 12.57, data_db$IDM)
data_db$BMI<- ifelse(is.na(data_db$BMI), 26.6, data_db$BMI)
data_db$smk5<- ifelse(is.na(data_db$smk5),1, data_db$smk5)
data_db$dmm_hf<- ifelse(data_db$dmm_hf==99,0, data_db$dmm_hf)
data_db$POS_b<- ifelse(data_db$gender=="Male",99, data_db$POS_b)
data_db$GDM_b<- ifelse(data_db$gender=="Male",99, data_db$GDM_b)
data_db$b_CVD<-0
data_db<-within(data_db, 
                {b_CVD[CHD_b=="Yes" |TIA_b=="1"|stroke_b=="Yes"]=1})

data_db$manicsc_b<-0
data_db<-within(data_db, 
                {manicsc_b[schizo_b=="Yes" |bipo_b=="Yes"]=1})

data_db$ASP<-as.factor(data_db$ASP)
data_db$NASIDS<-as.factor(data_db$NASIDS)



QDiabetes_F_2018<-function(age,ethrisk,IDM,bmi,smoke_cat,fh_diab,b_cvd,b_treatedhyp,b_learning,b_manicschiz,
                           b_corticosteroids,b_statin,b_atypicalantipsy,b_gestdiab,b_pos){
  ### /* The conditional arrays */
  Iethrisk =c(
    0,
    1.0695857881565456000000000,
    1.3430172097414006000000000,
    1.8029022579794518000000000,
    1.1274654517708020000000000,
    0.4214631490239910100000000,
    0.2850919645908353000000000,
    0.8815108797589199500000000,
    0.3660573343168487300000000)
  
  Ismoke=c( 
    0,
    0.0656016901750590550000000,
    0.2845098867369837400000000,
    0.3567664381700702000000000,
    0.5359517110678775300000000)
  
  ###Applying the fractional polynomial transforms (which includes scaling)                      */
  dage = age
  dage=dage/10
  age_1 = dage^.5
  age_2= dage^3
  dbmi = bmi
  dbmi=dbmi/10
  bmi_1 = dbmi
  bmi_2 =dbmi^3
  
  # Centring the continuous variables */
  # age_1 = age_1 - 2.123332023620606;
  # age_2 = age_2 - 91.644744873046875;
  # bmi_1 = bmi_1 - 2.571253299713135;
  # bmi_2 = bmi_2 - 21.718;
  # IDM = IDM - 0.391116052865982;
  
  age_1 = age_1 - 2.365731;
  age_2 = age_2 - 188.7675;
  bmi_1 = bmi_1 - 2.692414;
  bmi_2 = bmi_2 - 21.718;
  IDM = IDM - 16.7934;
  
  # mean((data_dbF$age/10)^0.5)
  # mean((data_dbF$age/10)^3)
  # mean((data_dbF$BMI/10))
  # mean((data_dbF$BMI/10)^3)
  #mean(data_dbF$IDM)
  # age_m1<-mean(age_1)
  # age_m2<-mean(age_2)
  # bmi_m1<-mean(bmi_1)
  # bmi_m2<-mean(bmi_2)
  # IDM_m<-mean(IDM)
  # 
  # age_1 = age_1 - age_m1
  # age_2 = age_2 - age_m2
  # bmi_1 = bmi_1 - mean(bmi_1)
  # bmi_2 = bmi_2 - mean(bmi_2)
  #IDM = IDM - IDM_m
  
  ## Start of Sum */
  ## The conditional sums */
  a<-0; b<-0;c<-0;d<-0;   
  a= Iethrisk[ethrisk]+
    Ismoke[smoke_cat]
  
  #Sum from continuous values *
  
  b= age_1 * 4.3400852699139278000000000+
    age_2 * -0.0048771702696158879000000+
    bmi_1 * 2.9320361259524925000000000+
    bmi_2 * -0.0474002058748434900000000+
    IDM * 0.0373405696180491510000000
  
  #Sum from boolean values */
  
  c= b_atypicalantipsy * 0.5526764611098438100000000+
    b_corticosteroids * 0.2679223368067459900000000+
    b_cvd * 0.1779722905458669100000000+
    b_gestdiab * 1.5248871531467574000000000+
    b_learning * 0.2783514358717271700000000+
    b_manicschiz * 0.2618085210917905900000000+
    b_pos * 0.3406173988206666100000000+
    b_statin * 0.6590728773280821700000000+
    b_treatedhyp * 0.4394758285813711900000000+
    fh_diab * 0.5313359456558733900000000
  
  #Sum from interaction terms */
  
  d= age_1 * b_atypicalantipsy * -0.8031518398316395100000000+
    age_1 * b_learning * -0.8641596002882057100000000+
    age_1 * b_statin * -1.9757776696583935000000000+
    age_1 * bmi_1 * 0.6553138757562945200000000+
    age_1 * bmi_2 * -0.0362096572016301770000000+
    age_1 * fh_diab * -0.2641171450558896200000000+
    age_2 * b_atypicalantipsy * 0.0004684041181021049800000+
    age_2 * b_learning * 0.0006724968808953360200000+
    age_2 * b_statin * 0.0023750534194347966000000+
    age_2 * bmi_1 * -0.0044719662445263054000000+
    age_2 * bmi_2 * 0.0001185479967753342000000+
    age_2 * fh_diab * 0.0004161025828904768300000
  
  # Calculate the score itself */
  hr=exp(a+b+c+d)
  score = 100.0 * (1 - 0.986227273941040^hr)
  return (score)}
QDiabetes_F_2018(60,5,20,35,5,0,0,0,0,0,0,0,0,0,0)


QDiabetes_M_2018<-function(age,ethrisk,IDM,bmi,smoke_cat,fh_diab,b_cvd,b_treatedhyp,b_learning,b_manicschiz,
                           b_corticosteroids,b_statin,b_atypicalantipsy){
  ### /* The conditional arrays */
  
  Iethrisk=c(
    0,
    1.1000230829124793000000000,
    1.2903840126147210000000000,
    1.6740908848727458000000000,
    1.1400446789147816000000000,
    0.4682468169065580600000000,
    0.6990564996301544800000000,
    0.6894365712711156800000000,
    0.4172222846773820900000000)
  
  Ismoke=c(
    0,
    0.1638740910548557300000000,
    0.3185144911395897900000000,
    0.3220726656778343200000000,
    0.4505243716340953100000000)
  
  ###Applying the fractional polynomial transforms (which includes scaling)                      */
  
  dage = age
  dage=dage/10
  age_2 = dage^3
  age_1 = log(dage)
  dbmi = bmi
  dbmi=dbmi/10
  bmi_2 = dbmi^3
  bmi_1 = dbmi^2
  
  # Centring the continuous variables */
  
  # age_1 = age_1 - 1.496392488479614;
  # age_2 = age_2 - 89.048171997070313;
  # bmi_1 = bmi_1 - 6.817805767059326;
  # bmi_2 = bmi_2 - 17.801923751831055;
  # IDM = IDM - 0.515986680984497;
  
  age_1 = age_1 - 1.721714;
  age_2 = age_2 - 192.3078;
  bmi_1 = bmi_1 - 7.797862;
  bmi_2 = bmi_2 - 22.52326;
  IDM = IDM - 17.27849;
  
  # Centring the continuous variables */
  # mean(log(data_dbM$age/10))
  # mean((data_dbM$age/10)^3)
  # mean((data_dbM$BMI/10)^2)
  # mean((data_dbM$BMI/10)^3)
  #mean(data_dbM$IDM)
  # 
  # age_m1<-mean(age_1)
  # age_m2<-mean(age_2)
  # bmi_m1<-mean(bmi_1)
  # bmi_m2<-mean(bmi_2)
  # IDM_m<-mean(IDM)
  # 
  # age_1 = age_1 - age_m1
  # age_2 = age_2 - age_m2
  # bmi_1 = bmi_1 - mean(bmi_1)
  # bmi_2 = bmi_2 - mean(bmi_2)
  # IDM = IDM - IDM_m
  # 
  ## Start of Sum */
  ## The conditional sums */
  
  
  
  
  
  
  ###### The conditional sums */
  a<-0; b<-0;c<-0;d<-0;   
  a= Iethrisk[ethrisk]+
    Ismoke[smoke_cat]
  
  #### Sum from continuous values */
  
  b=age_1 * 4.4642324388691348000000000+
    age_2 * -0.0040750108019255568000000+
    bmi_1 * 0.9512902786712067500000000+
    bmi_2 * -0.1435248827788547500000000+
    IDM * 0.0259181820676787250000000
  
  ######### Sum from boolean values */
  
  c=    b_atypicalantipsy * 0.4210109234600543600000000+
    b_corticosteroids * 0.2218358093292538400000000+
    b_cvd * 0.2026960575629002100000000+
    b_learning * 0.2331532140798696100000000+
    b_manicschiz * 0.2277044952051772700000000+
    b_statin * 0.5849007543114134200000000+
    b_treatedhyp * 0.3337939218350107800000000+
    fh_diab * 0.6479928489936953600000000
  
  #Sum from eraction terms */
  
  d=   age_1 * b_atypicalantipsy * -0.9463772226853415200000000+
    age_1 * b_learning * -0.9384237552649983300000000+
    age_1 * b_statin * -1.7479070653003299000000000+
    age_1 * bmi_1 * 0.4514759924187976600000000+
    age_1 * bmi_2 * -0.1079548126277638100000000+
    age_1 * fh_diab * -0.6011853042930119800000000+
    age_2 * b_atypicalantipsy * -0.0000519927442172335000000+
    age_2 * b_learning * 0.0007102643855968814100000+
    age_2 * b_statin * 0.0013508364599531669000000+
    age_2 * bmi_1 * -0.0011797722394560309000000+
    age_2 * bmi_2 * 0.0002147150913931929100000+
    age_2 * fh_diab * 0.0004914185594087803400000
  
  # Calculate the score itself */
  hr=exp(a+b+c+d)
  score = 100.0 * (1 -  0.978732228279114^hr)
  return (score)}
QDiabetes_M_2018(70,1,16,35,5,1,0,1,1,0,1,1,1)

################strata by Qdiabetes---
data_db$LSD_b<-as.numeric(data_db$LSD_b)-1
data_db$cortiod<-as.numeric(data_db$cortiod)-1
data_db$statin<-as.numeric(data_db$statin)-1
data_db$antip<-as.numeric(data_db$antip)-1


data_db$score<-0
data_db$sc3<-1
data_db[data_db$gender=="Male",]<-within(data_db[data_db$gender=="Male",], 
                                         {score<-QDiabetes_M_2018(age,eth9,IDM,BMI,smk5,dmm_hf,b_CVD,bp_mm,LSD_b
                                                                  ,manicsc_b,cortiod,statin,antip)
                                         sc3[score<=quantile(score,1)]=4
                                         sc3[score<=quantile(score,0.75)]=3
                                         sc3[score<=quantile(score,0.5)]=2
                                         sc3[score<=quantile(score,0.25)]=1})

data_db[data_db$gender=="Female",]<-within(data_db[data_db$gender=="Female",], 
                                           {score<-QDiabetes_F_2018(age,eth9,IDM,BMI,smk5,dmm_hf,b_CVD,bp_mm,LSD_b
                                                                    ,manicsc_b,cortiod,statin,antip,GDM_b,POS_b)
                                           sc3[score<=quantile(score,1)]=4
                                           sc3[score<=quantile(score,0.75)]=3
                                           sc3[score<=quantile(score,0.5)]=2
                                           sc3[score<=quantile(score,0.25)]=1})


table(data_db$PPI_S0[data_db$sc3==1],data_db$diab_case[data_db$sc3==1]) 
aggregate(survt_diab~PPI_S0,data_db[data_db$sc3==1,],sum)

table(data_db$PPI_S0[data_db$sc3==2],data_db$diab_case[data_db$sc3==2])
aggregate(survt_diab~PPI_S0,data_db[data_db$sc3==2,],sum)
table(data_db$PPI_S0[data_db$sc3==3],data_db$diab_case[data_db$sc3==3]) 
aggregate(survt_diab~PPI_S0,data_db[data_db$sc3==3,],sum)
table(data_db$PPI_S0[data_db$sc3==4],data_db$diab_case[data_db$sc3==4])  
aggregate(survt_diab~PPI_S0,data_db[data_db$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_diab,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_db[data_db$sc3==1,])

HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out13<- out[1,]
out13  

fit<- coxph(Surv(age1,age1+survt_diab,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_db[data_db$sc3==2,])

HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out14<- out[1,]
out14



fit<- coxph(Surv(age1,age1+survt_diab,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_db[data_db$sc3==3,])

HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out15<- out[1,]
out15

fit<- coxph(Surv(age1,age1+survt_diab,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_db[data_db$sc3==4,])

HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out16<- out[1,]
out16




#####EPI-CKD--------------------------
###DOI: 10.1001/jama.2019.17379
library(nephro)
library(transplantr)
vars<-c("n_eid", "survt_ckd", "ckd_case",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind","renalF_b",  
        "BMI","weight","SBP","gender","glucose","HbA1c","Creatin","insulin0","antdm0","metf0",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L","antdm0","metf0",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")

data_CKD<-data_md[vars]
data_CKD$SMK=0
data_CKD$SMK[data_CKD$smoking=="Current"]=1
data_db$b_CVD<-0
data_db<-within(data_db, 
                {b_CVD[CHD_b=="Yes" |TIA_b=="1"|stroke_b=="Yes"]=1})

data_CKD$ethnicity<-ifelse(data_CKD$eth=="Black or Black British",1,0)
data_CKD$sex<-ifelse(data_CKD$gender=="Male",1,0)
data_CKD$Cret<-data_CKD$Creatin*0.0113
data_CKD$sexx<-ifelse(data_CKD$gender=="Male",0,1)

data_CKD$insu=0
data_CKD$insu[data_CKD$insulin0=="Yes"]=1

data_CKD$dm_m=1
data_CKD$dm_m[data_CKD$antdm0=="Yes"|data_CKD$metf0=="Yes"]=0


data_CKD$log10ACR<-1
data_CKD<-within(data_CKD,{
  eGFR<-CKDEpi.creat(Cret, sex, age, ethnicity)
  log10ACR<-0.6754442 + 0.0222581 *(age1/5-11) + 0.045902 *sexx- 0.0340495 * ethnicity + 0.0085871 * (15-min(eGFR, 90)/5) - 0.0275825 *max(0, eGFR-90)/5 + 0.0495695*b_CVD + 0.0381086*SMK + 0.1286836*HBP +0.0218783 * (BMI/5-5.4)
})
data_CKD<-subset(data_CKD,(eGFR>=60&survt_ckd>0&renalF_b=="No"))


data_CKD$HTNR=data_CKD$bp_mm


data_CKD$ddm<-as.numeric(data_CKD$ddm)
data_CKD$ddm<-as.numeric(data_CKD$ddm)
data_CKD$hb_p<-(0.09148 * data_CKD$HbA1c) + 2.152
data_CKD$hb_p<-ifelse(is.na(data_CKD$hb_p),7,data_CKD$hb_p)

data_CKD$sc3<-NA
data_CKD1<-data_CKD[data_CKD$ddm==0,]
data_CKD1<-within(data_CKD1,{  
  L_m=-3.609661 + 0.2582196*(age1/5-11) + 0.1821665*sexx + 0.1808945 *ethnicity + 0.4581006*(15- min(eGFR,90)/5)-0.3159218 * max(0,eGFR-90)/5+0.1953927*b_CVD + 0.1213741*SMK + 0.3543645*HBP + 0.0630538*(BMI/5-5.4)
  sc<-1-exp(-5^1.055408*exp(L_m))
  sc3[sc<=quantile(sc,1)]=4
  sc3[sc<=quantile(sc,0.75)]=3
  sc3[sc<=quantile(sc,0.5)]=2
  sc3[sc<=quantile(sc,0.25)]=1
})

data_CKD2<-data_CKD[data_CKD$ddm==1,]
data_CKD2<-within(data_CKD1,{ L_m=-2.647004+0.1351572*(age1/5-11) + 0.1381975*sexx + 0.0920208 *ethnicity+0.3546697*(15- min(eGFR,90)/5)-0.1525133 * max(0,eGFR-90)/5+0.1870637*b_CVD+0.0619679*(hb_p-7)+0.1078296*insu-0.150944*dm_m+ 0.023959*(hb_p-7)*insu+0.0398424 *(hb_p-7) *dm_m-0.00084*SMK+ 0.3653268*HBP+ 0.050306*(BMI/5-5.4)
sc<-1-exp(-5^0.9766551*exp(L_m)) 
sc3[sc<=quantile(sc,1)]=4
sc3[sc<=quantile(sc,0.75)]=3
sc3[sc<=quantile(sc,0.5)]=2
sc3[sc<=quantile(sc,0.25)]=1
})
data_CKD<-rbind(data_CKD1,data_CKD2)

table(data_CKD[data_CKD$sc3==1,]$PPI_S0,data_CKD[data_CKD$sc3==1,]$ckd_case)
aggregate(survt_ckd~PPI_S0,data_CKD[data_CKD$sc3==1,],sum)

table(data_CKD[data_CKD$sc3==2,]$PPI_S0,data_CKD[data_CKD$sc3==2,]$ckd_case)
aggregate(survt_ckd~PPI_S0,data_CKD[data_CKD$sc3==2,],sum)

table(data_CKD[data_CKD$sc3==3,]$PPI_S0,data_CKD[data_CKD$sc3==3,]$ckd_case)
aggregate(survt_ckd~PPI_S0,data_CKD[data_CKD$sc3==3,],sum)

table(data_CKD[data_CKD$sc3==4,]$PPI_S0,data_CKD[data_CKD$sc3==4,]$ckd_case)
aggregate(survt_ckd~PPI_S0,data_CKD[data_CKD$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_ckd,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_CKD[data_CKD$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out17 <- out[1,]
out17

fit<- coxph(Surv(age1,age1+survt_ckd,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_CKD[data_CKD$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out18 <- out[1,]
out18

fit<- coxph(Surv(age1,age1+survt_ckd,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_CKD[data_CKD$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out19 <- out[1,]
out19

fit<- coxph(Surv(age1,age1+survt_ckd,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_CKD[data_CKD$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out20 <- out[1,]
out20


####CHARGE‐AF-------------------
##https://doi.org/10.1161/JAHA.112.000102
library(data.table)
co2<-fread("all_icd10.csv",sep =",", select = c("n_eid","Surv_I50","I50") )
co2$HF_b<-0
co2$HF_b[co2$Surv_I50<0]<-1

vars<-c("n_eid", "survt_af", "af_case" ,"MI_b","AF_b",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "eth2","bp_mm" ,
        "BMI","height", "weight","SBP","DBP",
        "gender","glucose","HbA1c",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")
data_AF<-data_md[vars]
data_AF<-merge(data_AF,co2,by="n_eid")
data_AF<-data_AF[data_AF$AF_b=="No"&data_AF$survt_af>0&(!is.na(data_AF$DBP)),]

data_AF$SMK=0
data_AF$SMK[data_AF$smoking=="Current"]=1
data_AF$HTNR=data_AF$bp_mm
data_AF$ddm<-as.numeric(data_AF$ddm)
data_AF$ethnicity<-ifelse(data_AF$eth2=="white",1,0)
data_AF$MI_bb<-ifelse(data_AF$MI_b=="Yes ",1,0)
data_AF$sc3<-NA
data_AF<-within(data_AF,
                {sc<-NA
                L_M<-NA
                L_M = 0.508 * (age1/5) +0.465*ethnicity+0.248*(height/10)+0.115*(weight/15)+0.197*(SBP/20)-0.101*(DBP/15)+0.359 *SMK+0.349 * HTNR+0.237*ddm+0.701*HF_b+0.496*MI_bb-12.5815600
                sc<-1-(0.9718412736^(exp(L_M)))
                sc3[sc<=quantile(sc,1)]=4
                sc3[sc<=quantile(sc,0.75)]=3
                sc3[sc<=quantile(sc,0.5)]=2
                sc3[sc<=quantile(sc,0.25)]=1
                
                })

table(data_AF[data_AF$sc3==1,]$PPI_S0,data_AF[data_AF$sc3==1,]$af_case)
aggregate(survt_af~PPI_S0,data_AF[data_AF$sc3==1,],sum)

table(data_AF[data_AF$sc3==2,]$PPI_S0,data_AF[data_AF$sc3==2,]$af_case)
aggregate(survt_af~PPI_S0,data_AF[data_AF$sc3==2,],sum)

table(data_AF[data_AF$sc3==3,]$PPI_S0,data_AF[data_AF$sc3==3,]$af_case)
aggregate(survt_af~PPI_S0,data_AF[data_AF$sc3==3,],sum)

table(data_AF[data_AF$sc3==4,]$PPI_S0,data_AF[data_AF$sc3==4,]$af_case)
aggregate(survt_af~PPI_S0,data_AF[data_AF$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_af,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_AF[data_AF$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out21 <- out[1,]
out21

fit<- coxph(Surv(age1,age1+survt_af,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_AF[data_AF$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out22 <- out[1,]
out22

fit<- coxph(Surv(age1,age1+survt_af,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_AF[data_AF$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out23 <- out[1,]
out23

fit<- coxph(Surv(age1,age1+survt_af,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_AF[data_AF$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out24 <- out[1,]
out24

#####LUNG CANCER-------------------
###https://doi.org/10.1038/sj.bjc.6604158
SUP23<-read.csv("F:/ukb/data/sup23.csv",header=TRUE, sep=",")
vars<-c("n_eid", "survt_lres","survtime_can","lung_can","lungc_h",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "COPD_b" ,
        "BMI","weight","SBP","gender","glucose","HbA1c","salbutamol",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")

data_lung<-data_md[vars]
data_lung<-merge(data_lung,SUP23,by="n_eid")
data_lung<-data_lung[(!(data_lung$survtime_can<0&data_lung$lung_can==1))&data_lung$age1>39.99999,]


data_lung$n_2897_0_0<-as.numeric(data_lung$n_2897_0_0)
data_lung$n_2867_0_0<-as.numeric(data_lung$n_2867_0_0)
data_lung$n_3436_0_0<-as.numeric(data_lung$n_3436_0_0)
data_lung$SMKd<-ifelse(data_lung$smoking!="Never",ifelse(data_lung$smoking=="Previous",data_lung$n_2897_0_0-data_lung$n_2867_0_0,data_lung$age1-data_lung$n_3436_0_0),0)
data_lung$SMK<-ifelse(data_lung$SMKd>0,ifelse(data_lung$SMKd>20,ifelse(data_lung$SMKd>40,ifelse(data_lung$SMKd>60,5,4),3),2),1)
data_lung$SMK[is.na(data_lung$SMK)]<-2
data_lung$LRTI=0
data_lung$LRTI[data_lung$survt_lres<=0]=1

data_lung$asbest<-0
data_lung$asbest[data_lung$n_22159_0_0>1|data_lung$n_22612_0_0=="Sometimes"|data_lung$n_22612_0_0=="Often"]<-1
data_lung$lch<-0
data_lung$lch[data_lung$lungc_h=="Yes"]<-1

Q_lung_M_2023<-function(age,smoke_cat,pneumonia,asbest,bca,lch){
  ### /* The conditional arrays */
  Ismk =c(
    0.0000,
    0.769,
    1.452,
    2.507,
    2.724
  )
  
  Iage=c( 
    -9.06,
    -8.16,
    -7.31,
    -6.63,
    -5.97,
    -5.56,
    -5.31,
    -4.83)
  x=floor(age/5)-7
  y=age%%5
  a=Iage[x]*(5-y-0.5)
  b=Iage[x+1]*(y+0.5)
  c=(a+b)/5
  L_m=Ismk[smoke_cat]+0.602*pneumonia+asbest*0.634+bca*0.675+lch*0.4355
  sc<-1/(1+exp(-(c+L_m)))
  return (sc)}
Q_lung_F_2023<-function(age,smoke_cat,pneumonia,asbest,bca,lch){
  ### /* The conditional arrays */
  Ismk =c(
    0.0000,
    0.769,
    1.452,
    2.507,
    2.724
  )
  
  Iage=c( 
    -9.90,
    -8.06,
    -7.46,
    -6.50,
    -6.22,
    -5.99,
    -5.49,
    -5.23)
  x=floor(age/5)-7
  y=age%%5
  a=Iage[x]*(5-y-0.5)
  b=Iage[x+1]*(y+0.5)
  c=(a+b)/5
  L_m=Ismk[smoke_cat]+0.602*pneumonia+asbest*0.634+bca*0.675+lch*0.4355
  sc<-1/(1+exp(-(c+L_m)))
  return (sc)}

data_lung$sc<-0
data_lung$sc3<-1
data_lung[data_lung$gender=="Male",]<-within(data_lung[data_lung$gender=="Male",], 
                                             {sc<-Q_lung_M_2023(age1,SMK,LRTI,asbest,bca,lch)
                                             sc3[sc<=quantile(sc,1)]=4
                                             sc3[sc<=quantile(sc,0.75)]=3
                                             sc3[sc<=quantile(sc,0.5)]=2
                                             sc3[sc<=quantile(sc,0.25)]=1})

data_lung[data_lung$gender=="Female",]<-within(data_lung[data_lung$gender=="Female",], 
                                               {sc<-Q_lung_F_2023(age1,SMK,LRTI,asbest,bca,lch)
                                               sc3[sc<=quantile(sc,1)]=4
                                               sc3[sc<=quantile(sc,0.75)]=3
                                               sc3[sc<=quantile(sc,0.5)]=2
                                               sc3[sc<=quantile(sc,0.25)]=1})



table(data_lung[data_lung$sc3==1,]$PPI_S0,data_lung[data_lung$sc3==1,]$lung_can)
aggregate(survtime_can~PPI_S0,data_lung[data_lung$sc3==1,],sum)

table(data_lung[data_lung$sc3==2,]$PPI_S0,data_lung[data_lung$sc3==2,]$lung_can)
aggregate(survtime_can~PPI_S0,data_lung[data_lung$sc3==2,],sum)

table(data_lung[data_lung$sc3==3,]$PPI_S0,data_lung[data_lung$sc3==3,]$lung_can)
aggregate(survtime_can~PPI_S0,data_lung[data_lung$sc3==3,],sum)

table(data_lung[data_lung$sc3==4,]$PPI_S0,data_lung[data_lung$sc3==4,]$lung_can)
aggregate(survtime_can~PPI_S0,data_lung[data_lung$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survtime_can,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lung[data_lung$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out25 <- out[1,]
out25

fit<- coxph(Surv(age1,age1+survtime_can,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lung[data_lung$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out26 <- out[1,]
out26

fit<- coxph(Surv(age1,age1+survtime_can,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lung[data_lung$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out27 <- out[1,]
out27

fit<- coxph(Surv(age1,age1+survtime_can,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lung[data_lung$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out28 <- out[1,]
out28





#######Esophageal cancer----------------
vars<-c("n_eid", "survtime_can","esop_can",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "COPD_b" ,
        "BMI","weight","SBP","gender","glucose","HbA1c","salbutamol",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat",
        "oest_b","gerd_b","obstr_b","hiat_hs","variceSO_b")

data_espc<-data_md[vars]
data_espc<-data_espc[data_espc$survtime_can>0&data_espc$bca==0&data_espc$age>50,]
data_espc$SMK<-ifelse(data_espc$smoking!="Never",ifelse(data_espc$smoking=="Previous",2.0,3.5),0)
data_espc$agecatt<-cut(data_espc$age,breaks=c(35,55,60,65,75))
data_espc$agecatt<-as.numeric(data_espc$agecatt)-0.5
data_espc$agecatt[data_espc$agecatt==0.5]<-0
data_espc$sexx<-ifelse(data_espc$gender=="Male",1,0)
data_espc$bmit<-cut(data_espc$BMI,breaks=c(12,25,30,35,75))
data_espc$bmit<-as.numeric(data_espc$bmit)-1
data_espc$bmit[data_espc$bmit>1]<-data_espc$bmit[data_espc$bmit>1]-0.5
data_espc$espd<-0
data_espc$espd[data_espc$oest_b=="Yes"|data_espc$gerd_b=="Yes"|data_espc$obstr_b=="Yes"|data_espc$hiat_hs=="Yes"|data_espc$variceSO_b=="Yes"]<-1

data_espc$sc<-0
data_espc$sc3<-1
data_espc<-within(data_espc, {sc<-agecatt+sexx*4+bmit+SMK+espd*1.5
sc3[sc<=quantile(sc,1)]=4
sc3[sc<=quantile(sc,0.75)]=3
sc3[sc<=quantile(sc,0.5)]=2
sc3[sc<=quantile(sc,0.25)]=1})

table(data_espc[data_espc$sc3==1,]$PPI_S0,data_espc[data_espc$sc3==1,]$esop_can)
aggregate(survtime_can~PPI_S0,data_espc[data_espc$sc3==1,],sum)

table(data_espc[data_espc$sc3==2,]$PPI_S0,data_espc[data_espc$sc3==2,]$esop_can)
aggregate(survtime_can~PPI_S0,data_espc[data_espc$sc3==2,],sum)

table(data_espc[data_espc$sc3==3,]$PPI_S0,data_espc[data_espc$sc3==3,]$esop_can)
aggregate(survtime_can~PPI_S0,data_espc[data_espc$sc3==3,],sum)

table(data_espc[data_espc$sc3==4,]$PPI_S0,data_espc[data_espc$sc3==4,]$esop_can)
aggregate(survtime_can~PPI_S0,data_espc[data_espc$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survtime_can,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_espc[data_espc$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out29 <- out[1,]
out29

fit<- coxph(Surv(age1,age1+survtime_can,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_espc[data_espc$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out30 <- out[1,]
out30

fit<- coxph(Surv(age1,age1+survtime_can,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_espc[data_espc$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out31 <- out[1,]
out31

fit<- coxph(Surv(age1,age1+survtime_can,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_espc[data_espc$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out32 <- out[1,]
out32


######oest-------------
####https://sci-hub.se/https://doi.org/10.1016/j.ijmedinf.2020.104160
vars<-c("n_eid", "survt_oste","oste_case","RAd_b","fra_b","HRT_r","fra_spine_b","fra_UL_b","fra_fem_b","fra_LL_b","Ost_b",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "COPD_b" ,
        "BMI","weight","SBP","gender","glucose","HbA1c","salbutamol",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat",
        "oest_b","gerd_b","obstr_b","hiat_hs","variceSO_b")
data_oest<-data_md[vars]
data_oest<-data_oest[data_oest$survt_oste>0&data_oest$age>50,]
data_oest$weight1<-data_oest$weight*2.205

data_oest$RAd_bb<-ifelse(data_oest$RAd_b=="Yes",4,0)
data_oest$fra_spine_b<-as.numeric(data_oest$fra_spine_b)-1
data_oest$fra_fem_b<-as.numeric(data_oest$fra_fem_b)-1
data_oest$fra_UL_b<-as.numeric(data_oest$fra_UL_b)-1
data_oest$fra_LL_b<-as.numeric(data_oest$fra_LL_b)-1
data_oest$Ost_b<-as.numeric(data_oest$Ost_b)-1
data_oest$sexx<-ifelse(data_oest$gender=="Male",0,1)
data_oest$sc<-0
data_oest$sc3<-1

# ##mose---
# data_oestM<-data_oest[data_oest$gender=="Male",]
# data_oestM$agecatt<-ifelse(data_oestM$age>55,3,0)
# data_oestM$wtg<-ifelse(data_oestM$weight>70,ifelse(data_oestM$weight>80,0,4),6)
# data_oestM$COPD_bb<-ifelse(data_oestM$COPD_b=="Yes",3,0)
# 
# data_oestM<-within(data_oestM, {sc<-agecatt+wtg+COPD_bb
# sc3[sc<=quantile(sc,1)]=4
# sc3[sc<=quantile(sc,0.75)]=3
# sc3[sc<=quantile(sc,0.5)]=2
# sc3[sc<=quantile(sc,0.25)]=1})
# 
# ####score---
# data_oestF<-data_oest[data_oest$gender=="Female",]
# data_oestF$ethnicity<-ifelse(data_oestF$eth=="Black or Black British",0,5)
# 
# data_oestF$fraa=data_oestF$fra_UL_b+data_oestF$fra_fem_b+data_oestF$fra_spine_b
# data_oestF$agex<-floor(data_oestF$age/10)
# data_oestF$wtg1<-floor(data_oestF$weight1/10)
# 
# data_oestF<-within(data_oestF, {sc<-ethnicity+RAd_bb+fraa*4+agex*3+HRT_r-wtg1
# sc3[sc<=quantile(sc,1)]=4
# sc3[sc<=quantile(sc,0.75)]=3
# sc3[sc<=quantile(sc,0.5)]=2
# sc3[sc<=quantile(sc,0.25)]=1})
# data_oest<-dplyr::bind_rows(data_oestM,data_oestF)

data_oest<-within(data_oest, {sc<--8.13+age1*0.059+0.042*BMI+sexx*0.21+fra_LL_b*1.61+Ost_b*0.92
sc3[sc<=quantile(sc,1)]=4
sc3[sc<=quantile(sc,0.75)]=3
sc3[sc<=quantile(sc,0.5)]=2
sc3[sc<=quantile(sc,0.25)]=1})







table(data_oest[data_oest$sc3==1,]$PPI_S0,data_oest[data_oest$sc3==1,]$oste_case)
aggregate(survt_oste~PPI_S0,data_oest[data_oest$sc3==1,],sum)

table(data_oest[data_oest$sc3==2,]$PPI_S0,data_oest[data_oest$sc3==2,]$oste_case)
aggregate(survt_oste~PPI_S0,data_oest[data_oest$sc3==2,],sum)

table(data_oest[data_oest$sc3==3,]$PPI_S0,data_oest[data_oest$sc3==3,]$oste_case)
aggregate(survt_oste~PPI_S0,data_oest[data_oest$sc3==3,],sum)

table(data_oest[data_oest$sc3==4,]$PPI_S0,data_oest[data_oest$sc3==4,]$oste_case)
aggregate(survt_oste~PPI_S0,data_oest[data_oest$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_oste,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_oest[data_oest$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out33 <- out[1,]
out33

fit<- coxph(Surv(age1,age1+survt_oste,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_oest[data_oest$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out34 <- out[1,]
out34

fit<- coxph(Surv(age1,age1+survt_oste,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_oest[data_oest$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out35 <- out[1,]
out35

fit<- coxph(Surv(age1,age1+survt_oste,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_oest[data_oest$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out36 <- out[1,]
out36


######depression---------
Dep17<-read.csv("F:/ukb/data/dep17.csv",header=TRUE, sep=",")
Dep17$GP1<-ifelse(Dep17$n_2090_0_0=="Yes",1,0)
Dep17$psych2<-ifelse(Dep17$n_2100_0_0=="Prefer not to answer",1,0)
Dep17$oh3<-ifelse(Dep17$n_2178_0_0=="Poor",1,0)
Dep17$dep4<-ifelse(Dep17$n_2050_0_0=="Nearly every day",1,0)
Dep17$psych5<-ifelse(Dep17$n_2100_0_0=="Yes",1,0)
Dep17$oh6<-ifelse(Dep17$n_2178_0_0=="Fair",1,0)
Dep17$ms7<-ifelse(Dep17$n_1920_0_0=="Yes",1,0)
Dep17$eop8<-ifelse(Dep17$n_6142_0_0=="Unable to work because of sickness or disability",1,0)
Dep17$iia9<-ifelse(Dep17$n_6145_0_0=="Serious illness, injury or assault to yourself",1,0)
Dep17$man10<-ifelse(Dep17$n_5674_0_0=="Needed treatment or caused problems with work, relationships, finances, the law or other aspects of life",1,0)
Dep17$acl11<-ifelse(Dep17$n_20117_0_0=="Never",1,0)
Dep17$fed12<-ifelse(Dep17$n_1960_0_0=="Yes",1,0)
Dep17$edu13<-ifelse(Dep17$n_6138_0_0=="None of the above",0,1)
Dep17$mis14<-ifelse(Dep17$n_1930_0_0=="Yes",1,0)
Dep17$dep15<-ifelse(Dep17$n_2050_0_0=="Several days",1,0)
Dep17$incom16<-ifelse(Dep17$n_738_0_0=="Less than 18,000",1,0)
Dep17$fin17<-ifelse(Dep17$n_6145_0_0=="Financial difficulties",1,0)
Dep17$dep18<-ifelse(Dep17$n_4598_0_0=="Yes",1,0)
Dep17$edu19<-ifelse(Dep17$n_6138_0_0=="CSEs or equivalent",0,1)
Dep17$depm20<-ifelse(Dep17$n_20110_0_0=="Severe depression",1,0)
Dep17$nev21<-ifelse(Dep17$n_2010_0_0=="Yes",1,0)
Dep17$ope22<-ifelse(is.na(Dep17$n_136_0_0),0,is.na(Dep17$n_136_0_0))
Dep17$wor23<-ifelse(Dep17$n_1980_0_0=="Yes",1,0)
Dep17$fel24<-ifelse(Dep17$n_1950_0_0=="Yes",1,0)
Dep17$n_1528_0_0<-as.numeric(Dep17$n_1528_0_0)
Dep17$wat25<-ifelse(is.na(Dep17$n_1528_0_0),0,as.numeric(Dep17$n_1528_0_0))
Dep17$hel26<-ifelse(is.na(Dep17$n_50_0_0),168,as.numeric(Dep17$n_50_0_0))
Dep17$mor27<-ifelse(Dep17$n_1180_0=="More a morning than evening person",1,0)
Dep17$cof28<-ifelse(Dep17$n_2110_0=="Almost daily",1,0)
Dep17$ten29<-ifelse(Dep17$n_1990_0_0=="Yes",0,1)
Dep17$tire30<-ifelse(Dep17$n_2080_0=="Not at all",1,0)
Dep17$smk31<-ifelse(Dep17$n_20116_0_0=="Previous",1,0)
Dep17$emnth32<-ifelse(Dep17$n_4631_0_0=="No",1,0)
Dep17$smk33<-ifelse(Dep17$n_20116_0_0=="Never",1,0)
#Dep17$smk34<-ifelse(Dep17$n_3486_0_0=="Almost daily",1,0)
Dep17$incom35<-ifelse(Dep17$n_738_0_0=="Greater than 100,000",1,0)
Dep17<-Dep17[,-c(2:32)]
Dep17<-na.omit(Dep17)
vars<-c("n_eid", "survt_depr","depr_case","dep_b",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "COPD_b" ,
        "BMI","weight","SBP","gender","glucose","HbA1c",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat",
        "oest_b","gerd_b","obstr_b","hiat_hs","variceSO_b")
data_dep<-data_md[vars]
data_dep<-data_dep[data_dep$survt_depr>0&data_dep$dep_b=="No",]
data_dep<-merge(data_dep,Dep17,by="n_eid")
data_dep$sc3<-NA
data_dep$sc<-NA
data_dep<-within(data_dep,
                 {sc<-GP1*1.038+psych2*0.933+oh3*0.513+dep4*0.413+psych5*0.340+oh6*0.317+ms7*0.290+eop8*0.228+iia9*0.202+
                   man10*0.186+acl11*0.182+fed12*0.179+edu13*0.168+mis14*0.162+dep15*0.161+incom16*0.150+fin17*0.146+dep18*0.131+
                   edu19*0.127+depm20*0.117+nev21*0.092+ope22*0.086+wor23*0.054+fel24*0.049+wat25*0.027+hel26*(-0.003)+mor27*(-0.016)+
                   cof28*(-0.039)+ten29+(-0.115)+tire30*(-0.190)+smk31*(-0.238)+emnth32*(-0.243)+smk33*(-0.327)+incom35*(-0.463)
                 
                 sc3[sc<=quantile(sc,1)]=4
                 sc3[sc<=quantile(sc,0.75)]=3
                 sc3[sc<=quantile(sc,0.5)]=2
                 sc3[sc<=quantile(sc,0.25)]=1
                 })


table(data_dep[data_dep$sc3==1,]$PPI_S0,data_dep[data_dep$sc3==1,]$depr_case)
aggregate(survt_depr~PPI_S0,data_dep[data_dep$sc3==1,],sum)

table(data_dep[data_dep$sc3==2,]$PPI_S0,data_dep[data_dep$sc3==2,]$depr_case)
aggregate(survt_depr~PPI_S0,data_dep[data_dep$sc3==2,],sum)

table(data_dep[data_dep$sc3==3,]$PPI_S0,data_dep[data_dep$sc3==3,]$depr_case)
aggregate(survt_depr~PPI_S0,data_dep[data_dep$sc3==3,],sum)

table(data_dep[data_dep$sc3==4,]$PPI_S0,data_dep[data_dep$sc3==4,]$depr_case)
aggregate(survt_depr~PPI_S0,data_dep[data_dep$sc3==4,],sum)

fit<- coxph(Surv(age1,age1+survt_depr,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dep[data_dep$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out37 <- out[1,]
out37

fit<- coxph(Surv(age1,age1+survt_depr,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dep[data_dep$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out38 <- out[1,]
out38

fit<- coxph(Surv(age1,age1+survt_depr,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dep[data_dep$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out39 <- out[1,]
out39

fit<- coxph(Surv(age1,age1+survt_depr,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dep[data_dep$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out40 <- out[1,]
out40
####Cirrhosis and other chronic liver diseases-------------------------
##https://diagnprognres.biomedcentral.com/articles/10.1186/s41512-019-0056-7#Tab3
library(My.stepwise)
library(StepReg)
vars<-c("n_eid", "survt_cirr","cirr_case","liverp_b",
        "age","gender","eth","IDM","BMI","smoking","drinking4","ddm", "HBP","bca","chol_h",
        "stroke_b"  ,"b_CVD",  "ind", "COPD_b" ,"cancer_N", "noncancer_N","operations_N", "treatment_N",
        "IBD_bb","ment_b","Albumin","ALP","ALT","AST","GGT","HDL","TG","CHOL","Par",
        "ASP","Par","Ibu","NASIDS","chol_m","bp_mm", 
        "weight","SBP","glucose","HbA1c","salbutamol",
        "cortiod","antip",
        "centre","edu","IDM5","Phy_act","fruit_g","drinking",
        "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")

data_cir<-data_md[vars]
data_cir<-data_cir[data_cir$liverp_b==0&data_cir$survt_cirr>0,]
data_cir$IDM<- ifelse(is.na(data_cir$IDM), 12.57, data_cir$IDM)
data_cir$noncancer_N<-ifelse(is.na(data_cir$noncancer_N),0,as.numeric(data_cir$noncancer_N))
data_cir$operations_N<-ifelse(is.na(data_cir$operations_N),0,as.numeric(data_cir$operations_N))
data_cir$treatment_N<-ifelse(is.na(data_cir$treatment_N),0,as.numeric(data_cir$treatment_N))
data_cir$cancer_N<-ifelse(is.na(data_cir$cancer_N),0,as.numeric(data_cir$cancer_N))
data_cir$b_NSAIDS<-0
data_cir<-within(data_cir, 
                 {b_NSAIDS[ASP==1 |NASIDS==1]=1})
data_cir$gender<-as.factor(data_cir$gender)
data_cir$ethnicity<-ifelse(data_cir$eth=="white",0,1)

# vars1<-c("survt_cirr","cirr_case","age","gender","ethnicity","IDM","BMI","ddm", "HBP","bca","chol_h",
#          "b_CVD", "IBD_bb","ment_b","b_NSAIDS","Par","chol_m","bp_mm", "cortiod","antip","statin",
#          "smoking","drinking4","sleep_tc","Health_R","illness_L",
#          "noncancer_N","operations_N", "treatment_N")
# data1<-data_cir[vars1]
# data1<-na.omit(data1)
# for (i in c(3:21)){ 
#   data1[,i]<-as.numeric(data1[,i])}
# for (i in c(22:26)){ 
#   data1[,i]<-as.factor(data1[,i])}

# formula =Surv(survt_cirr,cirr_case)~age+gender+ethnicity+IDM+BMI+ddm+HBP+bca+chol_h+b_CVD+IBD_bb+
#                       ment_b+b_NSAIDS+Par+cortiod+antip+statin+
#                       smoking+drinking4+Health_R+illness_L+treatment_N
# 
# stepwiseCox(formula=formula,
#             data=data1,
#             selection="bidirection",
#             select="AIC",
#            sle = 0.05,
#             sls = 0.05,
#             method="efron")
# # My.stepwise.coxph(Time = "survt_cirr",Status = "cirr_case",variable.list = vars1,
# #                   sle=0.25,sls = 0.25,data =data1)
fit2<- coxph(Surv(survt_cirr,cirr_case)~I(age/5)+gender+IDM+I(BMI/5)+ddm+HBP+bca+chol_h+IBD_bb+
               ment_b+b_NSAIDS+statin+
               smoking+drinking4+illness_L+treatment_N
             ,data=data_cir,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)
pre1<-predict(fit2, newdata=data_cir,type = 'survival')
pre1<-predictCox(fit2,newdata=data_cir,times = 5)
histogram(1-pre1$survival)
p1<-basehaz(fit2, centered=TRUE)
summary(p1[p1$time==10,])
data_cir$basr<-1-pre1$survival
c<-as.data.frame(quantile(data_cir$basr, probs = seq(0, 1, 0.25),na.rm = T))
c<-c[c(1:5),1]
data_cir$basrC<-cut(data_cir$basr,breaks=c)
data_cir$basrC1<-as.numeric(data_cir$basrC)
table(data_cir[data_cir$basrC1==1,]$PPI_S0,data_cir[data_cir$basrC1==1,]$cirr_case)
aggregate(survt_cirr~PPI_S0,data_cir[data_cir$basrC1==1,],sum)
table(data_cir[data_cir$basrC1==2,]$PPI_S0,data_cir[data_cir$basrC1==2,]$cirr_case)
aggregate(survt_cirr~PPI_S0,data_cir[data_cir$basrC1==2,],sum)
table(data_cir[data_cir$basrC1==3,]$PPI_S0,data_cir[data_cir$basrC1==3,]$cirr_case)
aggregate(survt_cirr~PPI_S0,data_cir[data_cir$basrC1==3,],sum)
table(data_cir[data_cir$basrC1==4,]$PPI_S0,data_cir[data_cir$basrC1==4,]$cirr_case)
aggregate(survt_cirr~PPI_S0,data_cir[data_cir$basrC1==4,],sum)

fit<- coxph(Surv(age1,age1+survt_cirr,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_cir[data_cir$basrC1==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out41 <- out[1,]
out41

fit<- coxph(Surv(age1,age1+survt_cirr,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_cir[data_cir$basrC1==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out42 <- out[1,]
out42


fit<- coxph(Surv(age1,age1+survt_cirr,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_cir[data_cir$basrC1==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out43 <- out[1,]
out43


fit<- coxph(Surv(age1,age1+survt_cirr,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_cir[data_cir$basrC1==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out44 <- out[1,]
out44


#######fall----------------
#######https://pubmed.ncbi.nlm.nih.gov/33947733/

Dep17<-read.csv("F:/ukb/data/dep17.csv",header=TRUE, sep=",")
Dep17$dis_mob<-ifelse(Dep17$n_6146_0_0 %in% c("Attendance allowance","Blue badge","Disability living allowance"),1,0)
Dep17$pace<-ifelse(Dep17$n_924_0_0 %in% c("Brisk pace","Slow pace"),ifelse(Dep17$n_924_0_0=="Brisk pace",2,1),0)
Dep17$eop<-ifelse(Dep17$n_6142_0_0=="Unable to work because of sickness or disability",1,0)
Dep17$iia<-ifelse(Dep17$n_6145_0_0=="Serious illness, injury or assault to yourself",1,0)               

Dep17<-Dep17[,c(1,35:38)]
library(StepReg)
library(My.stepwise)
vars<-c("n_eid", "survt_fall","fall_case","survt_parkd","survt_visl","survt_hearl","survt_alz",
        "n_46_0_0","n_47_0_0","smoking","drinking4",
        "age","gender","eth","edu","IDM","BMI","ddm", "HBP","bca","chol_h","RAd_b","fra_b","dement_b","Ost_b",
        "stroke_b"  ,"b_CVD", "COPD_b" ,"ment_b", "ASP","Par","NASIDS",
        "Health_R","illness_L",
        "weight","SBP","glucose","HbA1c","salbutamol",
        "cortiod","antip",
        "centre","edu","IDM5","Phy_act","fruit_g","drinking","ind",
        "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral",
        "bmic", "drinking4","age1","edu2","agecat",
        "cancer_N", "noncancer_N","operations_N", "treatment_N")
data_fall<-data_md[vars]
data_fall<-data_fall[data_fall$survt_fall>0&data_fall$age>55,]
data_fall<-merge(data_fall,Dep17,by="n_eid")
data_fall$pd<-ifelse(data_fall$survt_parkd<0,1,0)
data_fall$vislos<-ifelse(data_fall$survt_visl<0,1,0)
data_fall$hearlos<-ifelse(data_fall$survt_hearl<0,1,0)
data_fall$demtia<-ifelse(data_fall$survt_alz<0|data_fall$dement_b=="Yes",1,0)

data_fall$n_46_0_0<-ifelse(is.na(data_fall$n_46_0_0),data_fall$n_47_0_0,data_fall$n_46_0_0)
data_fall$n_47_0_0<-ifelse(is.na(data_fall$n_47_0_0),data_fall$n_46_0_0,data_fall$n_47_0_0)

data_fall$grip=(data_fall$n_46_0_0+data_fall$n_47_0_0)/2
data_fall$grip=ifelse(is.na(data_fall$grip),30,data_fall$grip)
data_fall$IDM<- ifelse(is.na(data_fall$IDM), 12.57, data_fall$IDM)
data_fall$noncancer_N<-ifelse(is.na(data_fall$noncancer_N),0,as.numeric(data_fall$noncancer_N))
data_fall$operations_N<-ifelse(is.na(data_fall$operations_N),0,as.numeric(data_fall$operations_N))
data_fall$treatment_N<-ifelse(is.na(data_fall$treatment_N),0,as.numeric(data_fall$treatment_N))
data_fall$cancer_N<-ifelse(is.na(data_fall$cancer_N),0,as.numeric(data_fall$cancer_N))

fit2<- coxph(Surv(survt_fall,fall_case)~I(age/5)+gender+IDM+I(BMI/5)+ddm+HBP+b_CVD
             +ment_b+illness_L+Health_R+treatment_N
             +dis_mob+factor(pace)+eop+iia+pd+hearlos+demtia+I(grip/5)
             +fra_b+Ost_b
             ,data=data_fall,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)
pre1<-predict(fit2, newdata=data_fall,type = 'survival')
pre1<-predictCox(fit2,newdata=data_fall,times = 5)
histogram(1-pre1$survival)
p1<-basehaz(fit2, centered=TRUE)
summary(p1[p1$time==10,])
data_fall$basr<-1-pre1$survival
c<-as.data.frame(quantile(data_fall$basr, probs = seq(0, 1, 0.25),na.rm = T))
c<-c[c(1:5),1]
data_fall$basrC<-cut(data_fall$basr,breaks=c)
data_fall$basrC1<-as.numeric(data_fall$basrC)
table(data_fall[data_fall$basrC1==1,]$PPI_S0,data_fall[data_fall$basrC1==1,]$fall_case)
aggregate(survt_fall~PPI_S0,data_fall[data_fall$basrC1==1,],sum)
table(data_fall[data_fall$basrC1==2,]$PPI_S0,data_fall[data_fall$basrC1==2,]$fall_case)
aggregate(survt_fall~PPI_S0,data_fall[data_fall$basrC1==2,],sum)
table(data_fall[data_fall$basrC1==3,]$PPI_S0,data_fall[data_fall$basrC1==3,]$fall_case)
aggregate(survt_fall~PPI_S0,data_fall[data_fall$basrC1==3,],sum)
table(data_fall[data_fall$basrC1==4,]$PPI_S0,data_fall[data_fall$basrC1==4,]$fall_case)
aggregate(survt_fall~PPI_S0,data_fall[data_fall$basrC1==4,],sum)

fit<- coxph(Surv(age1,age1+survt_fall,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_fall[data_fall$basrC1==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out45 <- out[1,]
out45

fit<- coxph(Surv(age1,age1+survt_fall,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_fall[data_fall$basrC1==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out46 <- out[1,]
out46


fit<- coxph(Surv(age1,age1+survt_fall,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_fall[data_fall$basrC1==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out47 <- out[1,]
out47


fit<- coxph(Surv(age1,age1+survt_fall,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_fall[data_fall$basrC1==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out48 <- out[1,]
out48

#########Lower respiratory infections-----------------
#######https://pubmed.ncbi.nlm.nih.gov/34481570/
vars<-c("n_eid", "survt_lres","lres_case","survt_alz","survt_ckd",
        "smoking","drinking4",
        "age","gender","eth","edu","IDM","BMI","ddm", "HBP","bca","chol_h","dement_b",
        "stroke_b"  ,"b_CVD","CVD_b", "COPD_b" ,"asthma_b","ment_b", "ASP","Par","NASIDS",
        "Health_R","illness_L",
        "weight","SBP","glucose","HbA1c","salbutamol",
        "cortiod","antip",
        "centre","edu","IDM5","Phy_act","fruit_g","drinking","ind",
        "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral",
        "bmic", "drinking4","age1","edu2","agecat",
        "cancer_N", "noncancer_N","operations_N", "treatment_N")
data_lres<-data_md[vars]
data_lres<-data_lres[data_lres$survt_lres>0,]
data_lres$ckdd<-ifelse(data_lres$survt_ckd<0,1,0)
data_lres$demtia<-ifelse(data_lres$survt_alz<0|data_lres$dement_b=="Yes",1,0)

data_lres$IDM<- ifelse(is.na(data_lres$IDM), 12.57, data_lres$IDM)
data_lres$noncancer_N<-ifelse(is.na(data_lres$noncancer_N),0,as.numeric(data_lres$noncancer_N))
data_lres$operations_N<-ifelse(is.na(data_lres$operations_N),0,as.numeric(data_lres$operations_N))
data_lres$treatment_N<-ifelse(is.na(data_lres$treatment_N),0,as.numeric(data_lres$treatment_N))
data_lres$cancer_N<-ifelse(is.na(data_lres$cancer_N),0,as.numeric(data_lres$cancer_N))

fit2<- coxph(Surv(survt_lres,lres_case)~I(age/5)+gender+IDM+I(BMI/5)
             +ddm+CVD_b+stroke_b+ment_b+demtia+COPD_b+asthma_b+bca+ckdd+
               illness_L+Health_R+treatment_N
             +smoking+drinking4
             ,data=data_lres,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)
pre1<-predict(fit2, newdata=data_lres,type = 'survival')
pre1<-predictCox(fit2,newdata=data_lres,times = 5)
histogram(1-pre1$survival)
p1<-basehaz(fit2, centered=TRUE)
summary(p1[p1$time==10,])
data_lres$basr<-1-pre1$survival
c<-as.data.frame(quantile(data_lres$basr, probs = seq(0, 1, 0.25),na.rm = T))
c<-c[c(1:5),1]
data_lres$basrC<-cut(data_lres$basr,breaks=c)
data_lres$basrC1<-as.numeric(data_lres$basrC)
table(data_lres[data_lres$basrC1==1,]$PPI_S0,data_lres[data_lres$basrC1==1,]$lres_case)
aggregate(survt_lres~PPI_S0,data_lres[data_lres$basrC1==1,],sum)
table(data_lres[data_lres$basrC1==2,]$PPI_S0,data_lres[data_lres$basrC1==2,]$lres_case)
aggregate(survt_lres~PPI_S0,data_lres[data_lres$basrC1==2,],sum)
table(data_lres[data_lres$basrC1==3,]$PPI_S0,data_lres[data_lres$basrC1==3,]$lres_case)
aggregate(survt_lres~PPI_S0,data_lres[data_lres$basrC1==3,],sum)
table(data_lres[data_lres$basrC1==4,]$PPI_S0,data_lres[data_lres$basrC1==4,]$lres_case)
aggregate(survt_lres~PPI_S0,data_lres[data_lres$basrC1==4,],sum)

fit<- coxph(Surv(age1,age1+survt_lres,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lres[data_lres$basrC1==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out49 <- out[1,]
out49

fit<- coxph(Surv(age1,age1+survt_lres,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lres[data_lres$basrC1==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out50 <- out[1,]
out50


fit<- coxph(Surv(age1,age1+survt_lres,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lres[data_lres$basrC1==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out51 <- out[1,]
out51


fit<- coxph(Surv(age1,age1+survt_lres,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_lres[data_lres$basrC1==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out52 <- out[1,]
out52
#######Diarrheal diseases---------------------------
#https://www.verywellhealth.com/diarrhea-causes-1324505
library(StepReg)
library(My.stepwise)
vars<-c("n_eid", "survt_diarr","diarr_case","survt_alz",
        "smoking","drinking4",
        "age","gender","eth","edu","IDM","BMI","ddm", "HBP","bca","chol_h","dement_b",
        "stroke_b"  ,"b_CVD","CVD_b", "COPD_b" ,"asthma_b","ment_b", "ASP","Par","NASIDS",
        "Health_R","illness_L","IBD_bb","IBS_b",
        "weight","SBP","glucose","HbA1c","salbutamol",
        "cortiod","antip",
        "centre","edu","IDM5","Phy_act","fruit_g","drinking","ind",
        "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral",
        "bmic", "drinking4","age1","edu2","agecat",
        "cancer_N", "noncancer_N","operations_N", "treatment_N")
data_dir<-data_md[vars]
data_dir<-data_dir[data_dir$survt_diarr>0,]
data_dir$IDM<- ifelse(is.na(data_dir$IDM), 12.57, data_dir$IDM)
data_dir$noncancer_N<-ifelse(is.na(data_dir$noncancer_N),0,as.numeric(data_dir$noncancer_N))
data_dir$operations_N<-ifelse(is.na(data_dir$operations_N),0,as.numeric(data_dir$operations_N))
data_dir$treatment_N<-ifelse(is.na(data_dir$treatment_N),0,as.numeric(data_dir$treatment_N))
data_dir$cancer_N<-ifelse(is.na(data_dir$cancer_N),0,as.numeric(data_dir$cancer_N))

fit2<- coxph(Surv(survt_diarr,diarr_case)~I(age/5)+gender+IDM+bmic
             +smoking+ddm+bca+illness_L+Health_R+treatment_N+noncancer_N+operations_N
             ,data=data_dir,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)
pre1<-predict(fit2, newdata=data_dir,type = 'survival')
pre1<-predictCox(fit2,newdata=data_dir,times = 5)
histogram(1-pre1$survival)
p1<-basehaz(fit2, centered=TRUE)
summary(p1[p1$time==10,])
data_dir$basr<-1-pre1$survival
c<-as.data.frame(quantile(data_dir$basr, probs = seq(0, 1, 0.25),na.rm = T))
c<-c[c(1:5),1]
data_dir$basrC<-cut(data_dir$basr,breaks=c)
data_dir$basrC1<-as.numeric(data_dir$basrC)
table(data_dir[data_dir$basrC1==1,]$PPI_S0,data_dir[data_dir$basrC1==1,]$diarr_case)
aggregate(survt_diarr~PPI_S0,data_dir[data_dir$basrC1==1,],sum)
table(data_dir[data_dir$basrC1==2,]$PPI_S0,data_dir[data_dir$basrC1==2,]$diarr_case)
aggregate(survt_diarr~PPI_S0,data_dir[data_dir$basrC1==2,],sum)
table(data_dir[data_dir$basrC1==3,]$PPI_S0,data_dir[data_dir$basrC1==3,]$diarr_case)
aggregate(survt_diarr~PPI_S0,data_dir[data_dir$basrC1==3,],sum)
table(data_dir[data_dir$basrC1==4,]$PPI_S0,data_dir[data_dir$basrC1==4,]$diarr_case)
aggregate(survt_diarr~PPI_S0,data_dir[data_dir$basrC1==4,],sum)

fit<- coxph(Surv(age1,age1+survt_diarr,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dir[data_dir$basrC1==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out53 <- out[1,]
out53

fit<- coxph(Surv(age1,age1+survt_diarr,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dir[data_dir$basrC1==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out54 <- out[1,]
out54


fit<- coxph(Surv(age1,age1+survt_diarr,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dir[data_dir$basrC1==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out55 <- out[1,]
out55


fit<- coxph(Surv(age1,age1+survt_diarr,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_dir[data_dir$basrC1==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out56 <- out[1,]
out56

######asthma----
###https://www.resmedjournal.com/article/S0954-6111(19)30030-7/fulltext
###DOI: 10.1016/S0140-6736(17)33311-1
library(StepReg)
library(My.stepwise)
vars<-c("n_eid", "survt_asth","asth_case","survt_lres",
        "smoking","drinking4",
        "age","gender","eth","edu","IDM","BMI","ddm", "HBP","bca","chol_h","dement_b",
        "stroke_b"  ,"b_CVD","CVD_b", "COPD_b" ,"asthma_b","ment_b", "ASP","Par","NASIDS",
        "Health_R","illness_L","HayfeverD",
        "weight","SBP","glucose","HbA1c","salbutamol",
        "cortiod","antip","bp_mm",
        "centre","edu","IDM5","Phy_act","fruit_g","drinking","ind",
        "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral",
        "bmic", "drinking4","age1","edu2","agecat",
        "cancer_N", "noncancer_N","operations_N", "treatment_N")

data_asth<-data_md[vars]
data_asth<-data_asth[data_asth$survt_asth>0&data_asth$asthma_b=="No"&data_asth$COPD_b=="No",]
data_asth$IDM<- ifelse(is.na(data_asth$IDM), 12.57, data_asth$IDM)
data_asth$noncancer_N<-ifelse(is.na(data_asth$noncancer_N),0,as.numeric(data_asth$noncancer_N))
data_asth$operations_N<-ifelse(is.na(data_asth$operations_N),0,as.numeric(data_asth$operations_N))
data_asth$treatment_N<-ifelse(is.na(data_asth$treatment_N),0,as.numeric(data_asth$treatment_N))
data_asth$cancer_N<-ifelse(is.na(data_asth$cancer_N),0,as.numeric(data_asth$cancer_N))
data_asth$LRTI=0
data_asth$LRTI[data_asth$survt_lres<=0]=1

fit2<- coxph(Surv(survt_asth,asth_case)~I(age/5)+gender+IDM+I(BMI/5)+salbutamol+LRTI
             +smoking+Health_R+treatment_N+noncancer_N+HayfeverD
             ,data=data_asth,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)

pre1<-predict(fit2, newdata=data_asth,type = 'survival')
pre1<-predictCox(fit2,newdata=data_asth,times = 5)
histogram(1-pre1$survival)
p1<-basehaz(fit2, centered=TRUE)
summary(p1[p1$time==10,])
data_asth$basr<-1-pre1$survival
c<-as.data.frame(quantile(data_asth$basr, probs = seq(0, 1, 0.25),na.rm = T))
c<-c[c(1:5),1]
data_asth$basrC<-cut(data_asth$basr,breaks=c)
data_asth$basrC1<-as.numeric(data_asth$basrC)
table(data_asth[data_asth$basrC1==1,]$PPI_S0,data_asth[data_asth$basrC1==1,]$asth_case)
aggregate(survt_asth~PPI_S0,data_asth[data_asth$basrC1==1,],sum)
table(data_asth[data_asth$basrC1==2,]$PPI_S0,data_asth[data_asth$basrC1==2,]$asth_case)
aggregate(survt_asth~PPI_S0,data_asth[data_asth$basrC1==2,],sum)
table(data_asth[data_asth$basrC1==3,]$PPI_S0,data_asth[data_asth$basrC1==3,]$asth_case)
aggregate(survt_asth~PPI_S0,data_asth[data_asth$basrC1==3,],sum)
table(data_asth[data_asth$basrC1==4,]$PPI_S0,data_asth[data_asth$basrC1==4,]$asth_case)
aggregate(survt_asth~PPI_S0,data_asth[data_asth$basrC1==4,],sum)

fit<- coxph(Surv(age1,age1+survt_asth,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_asth[data_asth$basrC1==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out57 <- out[1,]
out57

fit<- coxph(Surv(age1,age1+survt_asth,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_asth[data_asth$basrC1==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out58 <- out[1,]
out58


fit<- coxph(Surv(age1,age1+survt_asth,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_asth[data_asth$basrC1==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out59 <- out[1,]
out59


fit<- coxph(Surv(age1,age1+survt_asth,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_asth[data_asth$basrC1==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out60 <- out[1,]
out60

newdata<-rbind(out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,
               out11,out12,out13,out14,out15,out16,out17,out18,out19,out20,
               out21,out22,out23,out24,out25,out26,out27,out28,out29,out30,
               out31,out32,out33,out34,out35,out36,out37,out38,out39,out40,
               out41,out42,out43,out44,out45,out46,out47,out48,out49,out50,
               out51,out52,out53,out54,out55,out56,out57,out58,out59,out60)
write.table(newdata, file = "F:\\desktop\\STR_1.csv", sep = ",",  
            col.names = NA,qmethod = "double",append=TRUE)
#####PD---------
#####https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3888633/---
vars<-c("n_eid", "survt_parkd","parkd_case","pd_h",
        "ddm", "HBP","bca","chol_h","stroke_b"  ,"b_CVD",  "ind", "ment_b","dep_b","anx_b",
        "BMI","weight","SBP","gender","beteb","Cach","coffee","hdj_b","ED_b","cspta_b",
        "centre","edu","age","eth","IDM","IDM5","drinking","smoking","Phy_act","fruit_g",
        "chol_m","bp_mm", "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
        "bmic", "drinking4","age1","edu2","agecat","CHOL","HDL")


data_PD<-data_md[vars]
data_PD<-data_PD[data_PD$survt_parkd>0,]

data_PD$b_NSAIDS<-0
data_PD<-within(data_PD, 
                {b_NSAIDS[Par==1 |NASIDS==1]=1})





data_PD$baseline_risk=1/(1+28.53049+73.67057*exp(-0.165308*(data_PD$age-60)))
# adjust for sex
data_PD=bind_rows(data_PD %>%
                    filter(gender=="Female")%>%
                    mutate("baseline_risk"=baseline_risk/1.5),
                  data_PD %>%
                    filter(gender=="Male"))

data_PD=bind_rows(data_PD %>% 
                    filter(smoking=="Current")%>%
                    mutate("baseline_risk"=baseline_risk*0.44),
                  data_PD=data_PD %>% 
                    filter(smoking=="Previous")%>%
                    mutate("baseline_risk"=baseline_risk*0.78),
                  data_PD=data_PD %>% 
                    filter(smoking=="Never"))

data_PD=bind_rows(data_PD %>%
                    filter(pd_h=="Yes") %>%
                    mutate("baseline_risk"=baseline_risk*4.45),
                  data_PD %>% 
                    filter(pd_h=="No"|pd_h=="Missing"))

data_PD=bind_rows(data_PD %>% 
                    filter(coffee >=1) %>%
                    mutate("baseline_risk"=baseline_risk*0.67),
                  data_PD %>% 
                    filter(coffee<1))
data_PD=bind_rows(data_PD %>% 
                    filter(drinking4 %in% c("Daily or almost daily" ,"1-4 times a week" )) %>%
                    mutate("baseline_risk"=baseline_risk*0.90),
                  data_PD %>% 
                    filter(drinking4 %in% c("One to three times a month" ,"Special occasions only/Never")))

data_PD=bind_rows(data_PD %>% 
                    filter(HBP==1) %>%
                    mutate("baseline_risk"=baseline_risk*0.74),
                  data_PD %>% 
                    filter(HBP==0))

data_PD=bind_rows(data_PD %>% 
                    filter(b_NSAIDS==1) %>%
                    mutate("baseline_risk"=baseline_risk*0.83),
                  data_PD %>% 
                    filter(b_NSAIDS==0))

data_PD=bind_rows(data_PD %>% 
                    filter(Cach=="Yes") %>%
                    mutate("baseline_risk"=baseline_risk*0.9),
                  data_PD %>% 
                    filter(Cach=="No"))

data_PD=bind_rows(data_PD %>% 
                    filter(Cach=="Yes") %>%
                    mutate("baseline_risk"=baseline_risk*0.9),
                  data_PD %>% 
                    filter(Cach=="No"))

data_PD=bind_rows(data_PD %>% 
                    filter(beteb=="Yes") %>%
                    mutate("baseline_risk"=baseline_risk*1.28),
                  data_PD %>% 
                    filter(beteb=="No"))

data_PD=bind_rows(data_PD %>% 
                    filter(cspta_b=="Yes") %>%
                    mutate("baseline_risk"=baseline_risk*2.34),
                  data_PD %>% 
                    filter(cspta_b=="No"))
data_PD=bind_rows(data_PD %>% 
                    filter(dep_b=="Yes"|anx_b=="Yes") %>%
                    mutate("baseline_risk"=baseline_risk*1.86),
                  data_PD %>% 
                    filter(dep_b=="No"&anx_b=="No"))

data_PD=bind_rows(data_PD %>% 
                    filter(ED_b=="Yes") %>%
                    mutate("baseline_risk"=baseline_risk*3.8),
                  data_PD %>% 
                    filter(ED_b=="No"))


# that's the baseline odds of PD
# now we'll work out probability
data_PD = data_PD %>% mutate(SC=baseline_risk/(1+baseline_risk))
data_PD<-within(data_PD,{
  sc3<-NA
  sc3[SC<=quantile(SC,1)]=4
  sc3[SC<=quantile(SC,0.75)]=3
  sc3[SC<=quantile(SC,0.5)]=2
  sc3[SC<=quantile(SC,0.25)]=1})

table(data_PD[data_PD$sc3==1,]$PPI_S0,data_PD[data_PD$sc3==1,]$parkd_case)
aggregate(survt_parkd~PPI_S0,data_PD[data_PD$sc3==1,],sum)

table(data_PD[data_PD$sc3==2,]$PPI_S0,data_PD[data_PD$sc3==2,]$parkd_case)
aggregate(survt_parkd~PPI_S0,data_PD[data_PD$sc3==2,],sum)

table(data_PD[data_PD$sc3==3,]$PPI_S0,data_PD[data_PD$sc3==3,]$parkd_case)
aggregate(survt_parkd~PPI_S0,data_PD[data_PD$sc3==3,],sum)

table(data_PD[data_PD$sc3==4,]$PPI_S0,data_PD[data_PD$sc3==4,]$parkd_case)
aggregate(survt_parkd~PPI_S0,data_PD[data_PD$sc3==4,],sum)


fit<- coxph(Surv(age1,age1+survt_parkd,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+b_NSAIDS+statin
            ,data=data_PD[data_PD$sc3==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out65 <- out[1,]
out65

fit<- coxph(Surv(age1,age1+survt_parkd,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+b_NSAIDS+statin
            ,data=data_PD[data_PD$sc3==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out66 <- out[1,]
out66

fit<- coxph(Surv(age1,age1+survt_parkd,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+b_NSAIDS+statin
            ,data=data_PD[data_PD$sc3==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out67 <- out[1,]
out67

fit<- coxph(Surv(age1,age1+survt_parkd,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+b_NSAIDS+statin
            ,data=data_PD[data_PD$sc3==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out68 <- out[1,]
out68
