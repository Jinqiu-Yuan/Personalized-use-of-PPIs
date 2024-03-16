####Figure 5
####所有疾病-----------------
data_md$outcomeM15<-ifelse(data_md$esop_can==1|data_md$isd_case==1|data_md$stroke_case==1|
                             data_md$copd_case==1|data_md$diab_case==1|data_md$lres_case==1|data_md$fall_case==1|
                             data_md$ckd_case==1|data_md$diarr_case==1|data_md$af_case==1 |data_md$cirr_case==1|
                             data_md$oste_case==1|data_md$asth_case==1 |data_md$depr_case==1|data_md$parkd_case==1,1,0)


data_md1<-subset(data_md,Survtime_M15>0&bca_s==0&bca==0&b_CVD==0&COPD_b=="No"&ddm==0&renalF_b=="No"&AF_b=="No"
                 &liverp_b==0&Ost_b=="No"&asthma_b=="No"&dep_b=="No")


data_md$outcomeM15<-ifelse(data_md$esop_can==1|data_md$isd_case==1|data_md$stroke_case==1|
                             data_md$copd_case==1|data_md$diab_case==1|data_md$lres_case==1|data_md$fall_case==1|
                             data_md$ckd_case==1|data_md$diarr_case==1|data_md$af_case==1 |data_md$cirr_case==1|
                             data_md$asth_case==1 |data_md$depr_case==1|data_md$parkd_case==1,1,0)
data_md1<-subset(data_md,Survtime_M15>0&bca_s==0&bca==0&b_CVD==0&COPD_b=="No"&ddm==0&renalF_b=="No"&AF_b=="No"
                 &liverp_b==0&asthma_b=="No"&dep_b=="No")


table1(~factor(lung_can)+factor(esop_can)+factor(isd_case)+factor(stroke_case)+
         factor(copd_case)+factor(diab_case)+factor(lres_case)+factor(fall_case)+
         +factor(ckd_case)+factor(diarr_case)+factor(af_case)+factor(cirr_case)
       +factor(oste_case)+factor(asth_case)+factor(depr_case)+factor(copd_case)|outcomeM15,  
       data=data_md1, render.continuous=c(.="Mean (SD)" ,.="(Median, IQR)"))


Dep17<-read.csv("F:/ukb/data/dep17.csv",header=TRUE, sep=",")
Dep17$dis_mob<-ifelse(Dep17$n_6146_0_0 %in% c("Attendance allowance","Blue badge","Disability living allowance"),1,0)
Dep17$pace<-ifelse(Dep17$n_924_0_0 %in% c("Brisk pace","Slow pace"),ifelse(Dep17$n_924_0_0=="Brisk pace",2,1),0)
Dep17$eop<-ifelse(Dep17$n_6142_0_0=="Unable to work because of sickness or disability",1,0)
Dep17$iia<-ifelse(Dep17$n_6145_0_0=="Serious illness, injury or assault to yourself",1,0)               
Dep17$pace<-factor(Dep17$pace,labels =c("Steady average pace","Slow pace","Brisk pace"))
Dep17<-Dep17[,c(1,35:38)]
vars<-c("n_eid", "Survtime_M15","outcomeM15","orgin",
        "n_46_0_0","n_47_0_0","smoking","drinking4","eth2",
        "age","gender","eth","edu","IDM","BMI","ddm", "HBP","bca","chol_h","RAd_b","fra_b","dement_b","Ost_b",
        "stroke_b"  ,"b_CVD", "COPD_b" ,"ment_b", "ASP","Par","NASIDS",
        "Health_R","illness_L","Ost_b","edu3",
        "weight","SBP","glucose","HbA1c","salbutamol",
        "cortiod","antip","bp_mm","meat_rdPc","edu3",
        "centre","edu","IDM5","Phy_act","fruit_g","drinking","ind",
        "PPI_S0","h2ra_S0", "sleep_tc","Health_R","illness_L",
        "statin","vitamin","mineral",
        "bmic", "drinking4","age1","edu2","agecat",
        "cancer_N", "noncancer_N","operations_N", "treatment_N")
data_md1<-data_md1[vars]
data_md1<-merge(data_md1,Dep17,by="n_eid")

data_md1$n_46_0_0<-ifelse(is.na(data_md1$n_46_0_0),data_md1$n_47_0_0,data_md1$n_46_0_0)
data_md1$n_47_0_0<-ifelse(is.na(data_md1$n_47_0_0),data_md1$n_46_0_0,data_md1$n_47_0_0)
data_md1$grip=(data_md1$n_46_0_0+data_md1$n_47_0_0)/2
data_md1$grip=ifelse(is.na(data_md1$grip),30,data_md1$grip)
data_md1$IDM<- ifelse(is.na(data_md1$IDM), 12.57, data_md1$IDM)
data_md1$noncancer_N<-ifelse(is.na(data_md1$noncancer_N),0,as.numeric(data_md1$noncancer_N))
data_md1$operations_N<-ifelse(is.na(data_md1$operations_N),0,as.numeric(data_md1$operations_N))
data_md1$treatment_N<-ifelse(is.na(data_md1$treatment_N),0,as.numeric(data_md1$treatment_N))
data_md1$cancer_N<-ifelse(is.na(data_md1$cancer_N),0,as.numeric(data_md1$cancer_N))
data_md1<-data_md1  %>% 
  mutate(treatment_Nn=  case_when(treatment_N==0~ 0,
                                  treatment_N==1~ 1,
                                  treatment_N==2~ 2,
                                  treatment_N>2~ 3))
data_md1$BMI[data_md1$BMI<15]<-15
data_md1$pace<-as.factor(data_md1$pace)
data_md1$treatment_Nn<-as.factor(data_md1$treatment_Nn)


fit2<- coxph(Surv(Survtime_M15,outcomeM15)~I(age/5)+
               gender+BMI+factor(treatment_Nn)+edu3+factor(sleep_tc)
             +smoking+HBP+chol_h+illness_L+Health_R
             +factor(pace)+Phy_act+fruit_g+factor(meat_rdPc)
             +eth2+drinking4
             ,data=data_md1,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)


fit2<- coxph(Surv(Survtime_M15,outcomeM15)~I(age/5)+I(BMI/5)+factor(treatment_Nn)
             +smoking+illness_L+Health_R
             +factor(pace)
             ,data=data_md1,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)
HR <- round(exp(coef(fit2)), 2)
CI <- round(exp(confint(fit2)), 2)
P <- round(coef(summary(fit2))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out
# vars<-c("Survtime_M15","outcomeM15","age", "gender","IDM","BMI","smoking","HBP","ment_b","illness_L","Health_R","treatment_N", "pace","iia","eop","dis_mob","SBP","bp_mm")
# data_md2<-data_md1[vars]
# data_md2 <- na.omit(data_md2)
# fit<- coxph(Surv(Survtime_M15,outcomeM15)~I(age/5)+I(age*age)+
#                gender+IDM+I(BMI*5)+
#                +smoking+SBP+ment_b+illness_L+Health_R+treatment_N
#              +factor(pace)+bp_mm
#              ,data=data_md2)
# summary(fit2)
# auc <- survivalROC(marker = data_md2[, c("age", "gender","IDM","BMI","smoking","HBP","ment_b","illness_L","Health_R","treatment_N", "pace","iia","eop","dis_mob")], 
#                    status=data_md2$outcomeM15, Stime=data_md2$Survtime_M15, predict.time = 5)

# data_md0<-data_md1[data_md1$orgin=="1",]
# data_md2<-data_md1[data_md1$orgin=="2"|data_md1$orgin=="3",]
# # data_md0<-data_md0[vars]
# # data_md2<-data_md2[vars]
# 
# dd=datadist(data_md0)
# options(datadist="dd")
# # data_md1<-data_md0[data_md0$Survtime_M15>0,]
# #####训练集
# fit<- cph(Surv(Survtime_M15,outcomeM15)~I(age/5)+gender+IDM+I(BMI*5)
#                +smoking+HBP+ment_b+illness_L+Health_R+treatment_N,
#                 data=data_md0, time.inc=5)
# s<-rcorrcens(Surv(Survtime_M15,outcomeM15) ~predict(fit), data = data_md1)
# s
# pre1<-predict(fit, newdata=data_md2)
# 
# r<-rcorrcens(Surv(Survtime_M15,outcomeM15) ~pre1, data = data_md2)
# r
pre1<-predict(fit2, newdata=data_md1,type = 'survival')
pre1<-predictCox(fit2,newdata=data_md1,type = 'survival',times = 1)
histogram(1-pre1$survival)
p1<-basehaz(fit2, centered=TRUE)
summary(p1[p1$time==1,])
data_md1$basr<-1-pre1$survival
c<-as.data.frame(quantile(data_md1$basr, probs = seq(0, 1, 0.1),na.rm = T))
c<-c[c(1:11),1]
data_md1$basrC<-cut(data_md1$basr,breaks=c)
data_md1$basrC1<-as.numeric(data_md1$basrC)

q<-quantile(data_md1$basr, probs = 0.90)
qq<-quantile(data_md1$basr, probs = 0.80)
qqq<-quantile(data_md1$basr, probs = 0.60)
qqqq<-quantile(data_md1$basr, probs = 0.50)
data_md1$basrC90<-ifelse(data_md1$basr>=q,1,0)
data_md1$basrC80<-ifelse(data_md1$basr>=qq,1,0)
data_md1$basrC60<-ifelse(data_md1$basr>=qqq,1,0)
data_md1$basrC50<-ifelse(data_md1$basr>=qqqq,1,0)

qqqqq<-quantile(data_md1$basr, probs = 0.25)
qqqqqq<-quantile(data_md1$basr, probs = 0.70)

data_md1$basrC25<-ifelse(data_md1$basr>=qqqqq,1,0)
data_md1$basrC70<-ifelse(data_md1$basr>=qqqqqq,1,0)

qqqqqqq<-quantile(data_md1$basr, probs = 0.20)
data_md1$basrC20<-ifelse(data_md1$basr>=qqqqqqq,1,0)


table(data_md1[data_md1$basrC1==1,]$PPI_S0,data_md1[data_md1$basrC1==1,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==1,],sum)
table(data_md1[data_md1$basrC1==2,]$PPI_S0,data_md1[data_md1$basrC1==2,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==2,],sum)
table(data_md1[data_md1$basrC1==3,]$PPI_S0,data_md1[data_md1$basrC1==3,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==3,],sum)
table(data_md1[data_md1$basrC1==4,]$PPI_S0,data_md1[data_md1$basrC1==4,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==4,],sum)

table(data_md1[data_md1$basrC1==5,]$PPI_S0,data_md1[data_md1$basrC1==5,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==5,],sum)
table(data_md1[data_md1$basrC1==6,]$PPI_S0,data_md1[data_md1$basrC1==6,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==6,],sum)
table(data_md1[data_md1$basrC1==7,]$PPI_S0,data_md1[data_md1$basrC1==7,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==7,],sum)
table(data_md1[data_md1$basrC1==8,]$PPI_S0,data_md1[data_md1$basrC1==8,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==8,],sum)


table(data_md1[data_md1$basrC1==9,]$PPI_S0,data_md1[data_md1$basrC1==9,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==9,],sum)
table(data_md1[data_md1$basrC1==10,]$PPI_S0,data_md1[data_md1$basrC1==10,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC1==10,],sum)

table(data_md1[data_md1$basrC80==1,]$PPI_S0,data_md1[data_md1$basrC80==1,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC80==1,],sum)
table(data_md1[data_md1$basrC60==1,]$PPI_S0,data_md1[data_md1$basrC60==1,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC60==1,],sum)
table(data_md1[data_md1$basrC50==1,]$PPI_S0,data_md1[data_md1$basrC50==1,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC50==1,],sum)

table(data_md1[data_md1$basrC90==0,]$PPI_S0,data_md1[data_md1$basrC90==0,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC90==0,],sum)
table(data_md1[data_md1$basrC80==0,]$PPI_S0,data_md1[data_md1$basrC80==0,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC80==0,],sum)
table(data_md1[data_md1$basrC60==0,]$PPI_S0,data_md1[data_md1$basrC60==0,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC60==0,],sum)


table(data_md1[data_md1$basrC25==0,]$PPI_S0,data_md1[data_md1$basrC25==0,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC25==0,],sum)
table(data_md1[data_md1$basrC50==0,]$PPI_S0,data_md1[data_md1$basrC50==0,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC50==0,],sum)

table(data_md1[data_md1$basrC70==1,]$PPI_S0,data_md1[data_md1$basrC70==1,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC70==1,],sum)

table(data_md1[data_md1$basrC70==0,]$PPI_S0,data_md1[data_md1$basrC70==0,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC50==0,],sum)

table(data_md1[data_md1$basrC20==0,]$PPI_S0,data_md1[data_md1$basrC20==0,]$outcomeM15)
aggregate(Survtime_M15~PPI_S0,data_md1[data_md1$basrC20==0,],sum)




fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out61 <- out[1,]
out61

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out62 <- out[1,]
out62


fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==3,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out63 <- out[1,]
out63


fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==4,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out64 <- out[1,]
out64



fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==5,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out65 <- out[1,]
out65

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==6,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out66 <- out[1,]
out66

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==7,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out67 <- out[1,]
out67

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==8,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out68 <- out[1,]
out68

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==9,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out69 <- out[1,]
out69

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC1==10,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out70 <- out[1,]
out70

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC80==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out71 <- out[1,]
out71

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC60==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out72 <- out[1,]
out72

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC50==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out73 <- out[1,]
out73

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC90==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out74 <- out[1,]
out74


fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC80==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out75 <- out[1,]
out75

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC60==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out76 <- out[1,]
out76



fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC25==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out77 <- out[1,]
out77

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC50==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out78 <- out[1,]
out78




fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC70==1,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out79 <- out[1,]
out79

fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC70==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out80 <- out[1,]
out80


fit<- coxph(Surv(age1,age1+Survtime_M15,outcomeM15)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=data_md1[data_md1$basrC20==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 3)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out81 <- out[1,]
out81



newdata<-rbind(out61,out62,out63,out64,out65,out66,out67,out68,out69,out70,
               out71,out72,out73,out74,out75,out76,out77,out78,out79,out80,out81)
write.table(newdata, file = "F:\\desktop\\STR_1.csv", sep = ",",  
            col.names = NA,qmethod = "double",append=TRUE)

# newdata<-rbind(out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,
#                out11,out12,out13,out14,out15,out16,out17,out18,out19,out20,
#                out21,out22,out23,out24,out25,out26,out27,out28,out29,out30,
#                out31,out32,out33,out34,out35,out36,out37,out38,out39,out40,
#                out41,out42,out43,out44,out45,out46,out47,out48,out49,out50,
#                out51,out52,out53,out54,out55,out56,out57,out58,out59,out60,
#                out61,out62,out63,out64)
# write.table(newdata, file = "F:\\desktop\\STR_1.csv", sep = ",",  
#             col.names = NA,qmethod = "double",append=TRUE)

c1<-c[2:10]
quantiles <- quantile(data_md1$basr, probs = c(0.5, 1, 0.1),na.rm = T)
P<-ggplot(data_md1[data_md1$basr<=0.065,],aes(x=basr,y=..density..))+
  #geom_histogram(bins = 100,size=0.1) +
  geom_histogram(fill="white",color="grey50",bins = 100,size=0.1) +
  #geom_density(alpha=1,color="red",linetype=1,size=0.2)+
  #scale_x_continuous(expand=c(0,0))+
  labs(title = " ", x=" ", y=" ")+theme_classic()


p<-P+scale_y_continuous(position = "left",expand=c(0,0))+
  geom_vline(xintercept =c1,color="black",linetype="dashed",size=0.1)
#p<-P+geom_vline(xintercept = c,color="black",linetype="dashed",size=0.2)
#+ scale_y_reverse(expand=c(0,0))+ +scale_x_continuous(position = "top",expand=c(0,0))  
p<-p+theme(axis.line.y=element_line(linetype=1,color="black",size=0.2),axis.line.x=element_line(linetype=1,color="black",size=0.2),
           #axis.text.x = element_blank(),axis.text.y  = element_blank(),
           axis.ticks.x=element_line(color="black",size=0.1,lineend = 1),
           axis.ticks.y=element_line(color="black",size=0.1,lineend = 1))
p
p+ stat_function(fun = function(x) { d <- density(data_md1$basr); approx(d$x, d$y, xout = x)$y }, 
                 geom = "point", aes(x = 0.75, y = 0.15), color = "black", size = 1)
ggsave("F:\\desktop\\Fig2.tiff",p,width=3.3,height=4.1,unit="cm")


####AF calculation-----
time <- c(seq(from = 0, to = 10, by = 1))
data_md1$PPI_S01<-ifelse(data_md1$PPI_S0=="Yes",1,0)
dataa1=data_md1[data_md1$basrC50==0,]
dataa1<-as.data.frame(dataa1)
#dataa<-arrange(dataa,Survtime_M15)
fit<- coxph(Surv(Survtime_M15,outcomeM15)~PPI_S01
            +agecat+gender+centre
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=dataa1,ties="breslow")
AFcoxph_est <- AFcoxph(fit, data=dataa1, exposure ="PPI_S01", times = time)
summary(AFcoxph_est)

dataa1=data_md1[data_md1$basrC50==1,]
dataa1<-as.data.frame(dataa1)
#dataa<-arrange(dataa,Survtime_M15)
fit<- coxph(Surv(Survtime_M15,outcomeM15)~PPI_S01
            +agecat+gender+centre
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=dataa1,ties="breslow")
AFcoxph_est <- AFcoxph(fit, data=dataa1, exposure ="PPI_S01", times = time)
summary(AFcoxph_est)

dataa1=data_md1[data_md1$basrC60==1,]
dataa1<-as.data.frame(dataa1)
#dataa<-arrange(dataa,Survtime_M15)
fit<- coxph(Surv(Survtime_M15,outcomeM15)~PPI_S01
            +agecat+gender+centre
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=dataa1,ties="breslow")
AFcoxph_est <- AFcoxph(fit, data=dataa1, exposure ="PPI_S01", times = time)
summary(AFcoxph_est)

dataa1=data_md1[data_md1$basrC70==1,]
dataa1<-as.data.frame(dataa1)
#dataa<-arrange(dataa,Survtime_M15)
fit<- coxph(Surv(Survtime_M15,outcomeM15)~PPI_S01
            +agecat+gender+centre
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=dataa1,ties="breslow")
AFcoxph_est <- AFcoxph(fit, data=dataa1, exposure ="PPI_S01", times = time)
summary(AFcoxph_est)

dataa1=data_md1[data_md1$basrC80==1,]
dataa1<-as.data.frame(dataa1)
#dataa<-arrange(dataa,Survtime_M15)
fit<- coxph(Surv(Survtime_M15,outcomeM15)~PPI_S01
            +agecat+gender+centre
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=dataa1,ties="breslow")
AFcoxph_est <- AFcoxph(fit, data=dataa1, exposure ="PPI_S01", times = time)
summary(AFcoxph_est)

dataa1=data_md1[data_md1$basrC90==1,]
dataa1<-as.data.frame(dataa1)
#dataa<-arrange(dataa,Survtime_M15)
fit<- coxph(Surv(Survtime_M15,outcomeM15)~PPI_S01
            +agecat+gender+centre
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +ind+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin
            ,data=dataa1,ties="breslow")
AFcoxph_est <- AFcoxph(fit, data=dataa1, exposure ="PPI_S01", times = time)
summary(AFcoxph_est)
