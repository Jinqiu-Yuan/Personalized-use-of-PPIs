##model development and assessments###--------------------------
data_md0<-data_md1[data_md1$orgin==1,]
data_md3<-data_md1[data_md1$orgin==2|data_md1$orgin==3,]

fit1<- coxph(Surv(Survtime_M15,outcomeM15)~I(age/5)+
               gender+I(BMI/5)+factor(treatment_Nn)+edu3+factor(sleep_tc)
             +smoking+HBP+chol_h+illness_L+Health_R
             +factor(pace)+Phy_act+fruit_g+factor(meat_rdPc)
             +eth2+drinking4
             ,data=data_md0,ties="breslow", x = TRUE, y = TRUE)
summary(fit1)

fit2<- coxph(Surv(Survtime_M15,outcomeM15)~I(age/5)+I(BMI/5)+treatment_Nn
             +smoking+illness_L+Health_R
             +pace
             ,data=data_md1,ties="breslow", x = TRUE, y = TRUE)
summary(fit2)
vars<-c("Survtime_M15","outcomeM15","age","gender","smoking","BMI","orgin",
        "illness_L","Health_R","treatment_Nn","pace")

data_md1<-data_md1[vars]
dd=datadist(data_md1)
options(datadist="dd")
data_md0<-data_md1[data_md1$orgin==1,]
data_md3<-data_md1[data_md1$orgin==2|data_md1$orgin==3,]

# fit<- cph(Surv(Survtime_M15,outcomeM15)~age+BMI+treatment_N
#           +smoking+illness_L+Health_R+pace
#           ,x=T, y=T, surv=T, data=data_md0, time.inc=1)
# 
# s<-rcorrcens(Surv(Survtime_M15,outcomeM15) ~predict(fit), data = data_md0)
# s
# pre1<-predict(fit, newdata=data_md3)
# 
# r<-rcorrcens(Surv(Survtime_M15,outcomeM15) ~pre1, data = data_md3)
# r

fit1<- coxph(Surv(Survtime_M15,outcomeM15)~age+BMI+treatment_Nn
             +smoking+illness_L+Health_R+pace
             ,data=data_md0)
data_md0$lp <- predict(fit1, type = "lp")
# library(survivalROC)
# auc <-survivalROC(marker = data_md0$lp, 
#                    status=data_md0$db, Stime=data_md0$Survtime_db, predict.time = c(3,5,10),method="KM")

library(timeROC)
tROC <-timeROC(T=data_md0$Survtime_M15,delta =data_md0$outcomeM15,marker = data_md0$lp,
               cause = 1,times = c(1,5,10),ROC=T)
par(mar= c(5,5,1,1),cex.lab=2,cex.axis= 1.5) #cex.lab=2横纵坐标的label变大，cex.axis=1.5坐标刻度数字变大
plot(tROC,time=1,col="lightgrey",title=F,lwd=3,lty="dashed") # lwd 线的粗线
plot(tROC,time=5,col="grey",add=T,title=F,lwd=3)
plot(tROC,time=10,col="black",add=T,title=F,lwd=3,lty="dotted")
legend(0.3,0.3, # 改变legend坐标位置
       c(paste0("1年AUC值：", round(tROC$AUC[1], 3)),
         paste0("5年AUC值：", round(tROC$AUC[2], 3)),
         paste0("10年AUC值：", round(tROC$AUC[3], 3))),
       col=c("lightgrey","grey","black"),lwd=2,lty=c("dashed","solid","dotted"),
       cex=1.5,bty="n") # 改变legend粗细及大小 lwd=2,cex=1.5

data_md3$lp <- predict(fit1, type = "lp",newdata=data_md3)
tROC <-timeROC(T=data_md3$Survtime_M15,delta =data_md3$outcomeM15,marker = data_md3$lp,
               cause = 1,times = c(1,5,10),ROC=T)
par(mar= c(5,5,1,1),cex.lab=2,cex.axis= 1.5) #cex.lab=2横纵坐标的label变大，cex.axis=1.5坐标刻度数字变大
plot(tROC,time=1,col="lightgrey",title=F,lwd=3,lty="dashed") # lwd 线的粗线
plot(tROC,time=5,col="grey",add=T,title=F,lwd=3)
plot(tROC,time=10,col="black",add=T,title=F,lwd=3,lty="dotted")
legend(0.3,0.3, # 改变legend坐标位置
       c(paste0("3年AUC值：", round(tROC$AUC[1], 3)),
         paste0("5年AUC值：", round(tROC$AUC[2], 3)),
         paste0("10年AUC值：", round(tROC$AUC[3], 3))),
       col=c("lightgrey","grey","black"),lwd=2,lty=c("dashed","solid","dotted"),
       cex=1.5,bty="n") # 改变legend粗细及大小 lwd=2,cex=1.5

cox1 <- coxph(Surv(Survtime_M15,outcomeM15)~age+BMI+treatment_Nn
              +smoking+illness_L+Health_R+pace
              ,data=data_md0,x=TRUE,y=TRUE)
ApparrentCindex <- pec::cindex(list("Cox X1"=cox1),
                               formula=Surv(Survtime_M15,outcomeM15)~age+BMI+treatment_Nn
                               +smoking+illness_L+Health_R+pace,
                               data=data_md0,
                               eval.times=c(1,5,10))
print(ApparrentCindex)
plot(ApparrentCindex)


ApparrentCindex <- pec::cindex(list("Cox X1"=cox1),
                               formula=Surv(Survtime_M15,outcomeM15)~age+BMI+treatment_Nn
                               +smoking+illness_L+Health_R+pace,
                               data=data_md3,
                               eval.times=c(1,5,10))
print(ApparrentCindex)
plot(ApparrentCindex)
cf=calPlot(cox1,time=5,data=data_md3,bars=TRUE,type="risk",pseudo=FALSE,ylim=c(0,0.3),xlab=" ",ylab=" ")
cf=calPlot(cox1,time=5,data=data_md3,type="risk")
cf=calPlot(cox1,time=5,data=data_md0,bars=TRUE,type="risk",pseudo=FALSE,ylim=c(0,0.3),xlab=" ",ylab=" ")
cf=calPlot(cox1,time=5,data=data_md0,type="risk",ylim=c(0,0.3),xlab=" ",ylab=" ")
perror=pec(list(Cox1=cox1),Hist(Survtime_M15,outcomeM15)~1,data=data_md3,reference=TRUE)
R2(perror,times=c(1,5,10),reference=1)
perror=pec(list(Cox1=cox1),Hist(Survtime_M15,outcomeM15)~1,data=data_md0,reference=TRUE)
R2(perror,times=c(1,5,10),reference=1)

cfit <- coxph(Surv(Survtime_M15,outcomeM15)~age+BMI+treatment_Nn
              +smoking+illness_L+Health_R+pace
              ,data=data_md0, ties="breslow")
royston(cfit)


###绘制cox回归生存概率的nomogram图
coxm<- cph(Surv(Survtime_M15,outcomeM15)~age+BMI+Health_R
           +smoking+treatment_Nn+illness_L+pace
           ,x=T, y=T, surv=T, data=data_md0)
survival<-Survival(coxm)
survival1<-function(x)(1-survival(1,x))
survival2<-function(x)(1-survival(5,x))
survival3<-function(x)(1-survival(10,x))
nom<-nomogram(coxm,fun=list(survival1,survival2,survival3),
              fun.at =c(0.05, seq(0.1,0.9, by=0.1), 0.99),lp=F,
              funlabel = c("1 year probability of any event occurs","5 year probability of any event occurs","10 year probability of any event occurs"))
plot(nom,lmgp=.2, cex.axis=1.2)
plot(nom, col.grid=c("pink","cyan"),
     xfrac =0.3, #设置变量名与线段的横向占比
     cex.var =1,  # 加粗变量字体
     cex.axis =1,  #设置数据轴字体的代销
     lmgp =0.3) # 设置文字与数据轴刻度的距离






#########
data_md1$HBP<-as.factor(data_md1$HBP)
data_md1$chol_h<-as.factor(data_md1$chol_h)
data_md1$meat_rdP4<-ifelse(data_md1$meat_rdPc==4,1,0)
data_md1$meat_rdP4<-as.factor(data_md1$meat_rdP4)
data_md0<-data_md1[data_md1$orgin==1,]
data_md3<-data_md1[data_md1$orgin==2|data_md1$orgin==3,]
vars<-c("age","BMI","gender","edu3","smoking","drinking4","Phy_act","fruit_g","meat_rdPc","sleep_tc",
        "HBP","chol_h","illness_L","Health_R","pace","treatment_Nn")
tab <- CreateTableOne(vars = vars, strata = "outcomeM15", data =data_md0, test = T)
print1<-print(tab)
write.csv(print1, file = "F:\\desktop\\tab1.csv")

data_x<-data_md0[,vars]
data_x_matrix <- model.matrix(~ ., data = data_x)
#data_y<-data_md0[,c("outcomeM15","Survtime_M15")]
surv_object <- Surv(time = data_md0$Survtime_M15, event = data_md0$outcomeM15)
lasso<- glmnet(data_x_matrix, surv_object, 
               family = 'cox', 
               nlambda=1000, 
               alpha=1)
cvfit <- cv.glmnet(data_x_matrix, surv_object , family = "cox", type.measure = "C", nfolds = 10)
cvfit1 <- cv.glmnet(data_x_matrix, surv_object , family = "cox", type.measure = "deviance", nfolds = 10)
par(mfrow=c(1,2))
plot(lasso, xvar="lambda")
plot(cvfit)

plot(cvfit)
coef(cvfit, s = cvfit$lambda.1se)
fit<- coxph(Surv(Survtime_M15,outcomeM15)~I(age/5)+
              gender+BMI+factor(treatment_Nn)+edu3+factor(sleep_tc)
            +smoking+HBP+chol_h+illness_L+Health_R
            +factor(pace)+Phy_act+fruit_g+factor(meat_rdPc)
            +drinking4
            ,data=data_md0,ties="breslow", x = TRUE, y = TRUE)
summary(fit)
fit_step <- step(fit, direction = "both", criterion = "aic", trace = FALSE, thresh = 0.05)

