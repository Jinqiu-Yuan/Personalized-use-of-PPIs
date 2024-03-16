library(survminer)
library(car)
library(infotheo)
library(survival)
library(ggplot2)
library(rms)
library(table1)
library(dplyr)
library(tidyverse)
library(ggsci)
library("survival")
library("survminer")
library(effects)
library(matrixStats)
library(dplyr)
library(table1)
library(survival)
library(lattice)
library(Formula)
library(grid)
library(magrittr)
library(checkmate)
library(Rcpp)
library(htmlTable)
library(Gmisc)
library(Rcpp)
library(htmlTable)
library(forestplot)
library(Greg)
library(ggplot2)
library(SparseM)
library(Hmisc)
library(rms)
library(infotheo)
library(sysfonts)
library(showtextdb)
library(cowplot)
library(showtext)
library(psych)
library(reshape)
require(dplyr)
###导入icd10数据
icd<-read.csv("E:/biobank/usedata/all_icd10.csv",header=TRUE, sep=",")
###导入协变量数据----------
ukb<-read.csv("E:/cdd/analyses.csv",header=TRUE, sep=",")
biobank<-ukb
###导入睡眠和食盐摄入协变量
salt_sleep<-read.csv("E:/cdd/data_salt.csv",header=TRUE, sep=",")
###导入lancet 60的疾病负担数据--更新到2019年12月31日
icd_lanc<-read.csv("E:/biobank/usedata/lancet_dis30.csv",header=TRUE, sep=",")
###导入饮食的频率数据
dietall<-read.csv("E:/cdd/diet.csv",header=TRUE, sep=",")

save(data_icd,file="E:/PPI_lancet30/data_icd.RData")  ##合并了level2的所有ICD、ICD_b和suvtime_ICD变量
save(dataukb,file="E:/cdd/datafile/dataukb.RData") ####已经进行过协变量的处理，导入后直接进行data_USE那一步的生成就行
save(data_phe,file="E:/PPI_lancet30/data_phe.RData")##合并了data_USE中的一些常用变量和lancet疾病负担的60种疾病(2019年12月31日截止)以及level2的所有icd10疾病（用于基线排除），用于后续直接分析

load("E:/PPI_lancet30/data_icd.RData") 
load("E:/cdd/datafile/dataukb.RData") 
load("E:/PPI_lancet30/data_phe.RData")##直接导入这个数据进行分析即可 

# data_os<-data_phe[c("n_eid","oste_case","survt_oste","M15_b","M16_b","M17_b","M18_b","M19_b","M47_b")]
# save(data_os,file="E:/data_os.RData")
# load("E:/data_os.RData") 

###生成icd10_var---------
var_icd10<-c("n_eid", 
             "A00",	"B30",	"E12",	"F48",	"G97",	"I34",	"J82",	"L23",	"M54",	"N83",
             "A01",	"B33",	"E13",	"F50",	"G98",	"I35",	"J84",	"L24",	"M60",	"N84",
             "A02",	"B34",	"E14",	"F51",	"G99",	"I36",	"J85",	"L25",	"M61",	"N85",
             "A03",	"B35",	"E15",	"F52",	"H00",	"I37",	"J86",	"L26",	"M62",	"N86",
             "A04",	"B36",	"E16",	"F53",	"H01",	"I38",	"J90",	"L27",	"M63",	"N87",
             "A05",	"B37",	"E20",	"F54",	"H02",	"I39",	"J91",	"L28",	"M65",	"N88",
             "A06",	"B38",	"E21",	"F55",	"H03",	"I40",	"J92",	"L29",	"M66",	"N89",
             "A07",	"B39",	"E22",	"F59",	"H04",	"I41",	"J93",	"L30",	"M67",	"N90",
             "A08",	"B40",	"E23",	"F60",	"H05",	"I42",	"J94",	"L40",	"M68",	"N91",
             "A09",	"B42",	"E24",	"F61",	"H06",	"I43",	"J95",	"L41",	"M70",	"N92",
             "A15",	"B43",	"E25",	"F62",	"H10",	"I44",	"J96",	"L42",	"M71",	"N93",
             "A16",	"B44",	"E26",	"F63",	"H11",	"I45",	"J98",	"L43",	"M72",	"N94",
             "A17",	"B45",	"E27",	"F64",	"H13",	"I46",	"J99",	"L44",	"M73",	"N95",
             "A18",	"B46",	"E28",	"F65",	"H15",	"I47",	"K00",	"L50",	"M75",	"N96",
             "A19",	"B47",	"E29",	"F66",	"H16",	"I48",	"K01",	"L51",	"M76",	"N97",
             "A20",	"B48",	"E30",	"F68",	"H17",	"I49",	"K02",	"L52",	"M77",	"N98",
             "A22",	"B49",	"E31",	"F69",	"H18",	"I50",	"K03",	"L53",	"M79",	"N99",
             "A23",	"B50",	"E32",	"F70",	"H19",	"I51",	"K04",	"L54",	"M80",	"A97",
             "A24",	"B51",	"E34",	"F71",	"H20",	"I52",	"K05",	"L55",	"M81",	"F83",
             "A25",	"B52",	"E35",	"F72",	"H21",	"I60",	"K06",	"L56",	"M82",	
             "A26",	"B53",	"E41",	"F78",	"H22",	"I61",	"K07",	"L57",	"M83",	
             "A27",	"B54",	"E43",	"F79",	"H25",	"I62",	"K08",	"L58",	"M84",	
             "A28",	"B55",	"E44",	"F80",	"H26",	"I63",	"K09",	"L59",	"M85",	
             "A30",	"B57",	"E45",	"F81",	"H27",	"I64",	"K10",	"L60",	"M86",	
             "A31",	"B58",	"E46",	"F82",	"H28",	"I65",	"K11",	"L62",	"M87",	
             "A32",	"B59",	"E50",	"F84",	"H30",	"I66",	"K12",	"L63",	"M88",	
             "A33",	"B60",	"E51",	"F88",	"H31",	"I67",	"K13",	"L64",	"M89",	
             "A35",	"B65",	"E52",	"F89",	"H32",	"I68",	"K14",	"L65",	"M90",	
             "A36",	"B66",	"E53",	"F90",	"H33",	"I69",	"K20",	"L66",	"M91",	
             "A37",	"B67",	"E54",	"F91",	"H34",	"I70",	"K21",	"L67",	"M92",	
             "A38",	"B68",	"E55",	"F92",	"H35",	"I71",	"K22",	"L68",	"M93",	
             "A39",	"B69",	"E56",	"F93",	"H36",	"I72",	"K23",	"L70",	"M94",	
             "A40",	"B71",	"E58",	"F94",	"H40",	"I73",	"K25",	"L71",	"M95",	
             "A41",	"B73",	"E59",	"F95",	"H42",	"I74",	"K26",	"L72",	"M96",	
             "A42",	"B74",	"E60",	"F98",	"H43",	"I77",	"K27",	"L73",	"M99",	
             "A43",	"B75",	"E61",	"F99",	"H44",	"I78",	"K28",	"L74",	"N00",	
             "A44",	"B76",	"E63",	"G00",	"H45",	"I79",	"K29",	"L75",	"N01",	
             "A46",	"B77",	"E64",	"G01",	"H46",	"I80",	"K30",	"L80",	"N02",	
             "A48",	"B78",	"E65",	"G02",	"H47",	"I81",	"K31",	"L81",	"N03",	
             "A49",	"B79",	"E66",	"G03",	"H48",	"I82",	"K35",	"L82",	"N04",	
             "A50",	"B80",	"E67",	"G04",	"H49",	"I83",	"K36",	"L83",	"N05",	
             "A51",	"B81",	"E68",	"G05",	"H50",	"I85",	"K37",	"L84",	"N06",	
             "A52",	"B82",	"E70",	"G06",	"H51",	"I86",	"K38",	"L85",	"N07",	
             "A53",	"B83",	"E71",	"G07",	"H52",	"I87",	"K40",	"L86",	"N08",	
             "A54",	"B85",	"E72",	"G08",	"H53",	"I88",	"K41",	"L87",	"N10",	
             "A55",	"B86",	"E73",	"G09",	"H54",	"I89",	"K42",	"L88",	"N11",	
             "A56",	"B87",	"E74",	"G10",	"H55",	"I95",	"K43",	"L89",	"N12",	
             "A58",	"B88",	"E75",	"G11",	"H57",	"I97",	"K44",	"L90",	"N13",	
             "A59",	"B89",	"E76",	"G12",	"H58",	"I98",	"K45",	"L91",	"N14",	
             "A60",	"B90",	"E77",	"G13",	"H59",	"I99",	"K46",	"L92",	"N15",	
             "A63",	"B91",	"E78",	"G14",	"H60",	"J00",	"K50",	"L93",	"N16",	
             "A64",	"B94",	"E79",	"G20",	"H61",	"J01",	"K51",	"L94",	"N17",	
             "A66",	"B95",	"E80",	"G21",	"H62",	"J02",	"K52",	"L95",	"N18",	
             "A67",	"B96",	"E83",	"G22",	"H65",	"J03",	"K55",	"L97",	"N19",	
             "A68",	"B97",	"E84",	"G23",	"H66",	"J04",	"K56",	"L98",	"N20",	
             "A69",	"B98",	"E85",	"G24",	"H67",	"J05",	"K57",	"L99",	"N21",	
             "A70",	"B99",	"E86",	"G25",	"H68",	"J06",	"K58",	"M00",	"N22",	
             "A71",	"D50",	"E87",	"G30",	"H69",	"J09",	"K59",	"M01",	"N23",	
             "A74",	"D51",	"E88",	"G31",	"H70",	"J10",	"K60",	"M02",	"N25",	
             "A75",	"D52",	"E89",	"G32",	"H71",	"J11",	"K61",	"M03",	"N26",	
             "A77",	"D53",	"F00",	"G35",	"H72",	"J12",	"K62",	"M05",	"N27",	
             "A78",	"D55",	"F01",	"G36",	"H73",	"J13",	"K63",	"M06",	"N28",	
             "A79",	"D56",	"F02",	"G37",	"H74",	"J14",	"K64",	"M07",	"N29",	
             "A80",	"D57",	"F03",	"G40",	"H75",	"J15",	"K65",	"M08",	"N30",	
             "A81",	"D58",	"F04",	"G41",	"H80",	"J16",	"K66",	"M09",	"N31",	
             "A82",	"D59",	"F05",	"G43",	"H81",	"J17",	"K67",	"M10",	"N32",	
             "A83",	"D60",	"F06",	"G44",	"H82",	"J18",	"K70",	"M11",	"N33",	
             "A84",	"D61",	"F07",	"G45",	"H83",	"J20",	"K71",	"M12",	"N34",	
             "A85",	"D62",	"F09",	"G46",	"H90",	"J21",	"K72",	"M13",	"N35",	
             "A86",	"D63",	"F10",	"G47",	"H91",	"J22",	"K73",	"M14",	"N36",	
             "A87",	"D64",	"F11",	"G50",	"H92",	"J30",	"K74",	"M15",	"N37",	
             "A88",	"D65",	"F12",	"G51",	"H93",	"J31",	"K75",	"M16",	"N39",	
             "A89",	"D66",	"F13",	"G52",	"H94",	"J32",	"K76",	"M17",	"N40",	
             "A92",	"D67",	"F14",	"G53",	"H95",	"J33",	"K77",	"M18",	"N41",	
             "A93",	"D68",	"F15",	"G54",	"I00",	"J34",	"K80",	"M19",	"N42",	
             "A94",	"D69",	"F16",	"G55",	"I01",	"J35",	"K81",	"M20",	"N43",	
             "A95",	"D70",	"F17",	"G56",	"I02",	"J36",	"K82",	"M21",	"N44",	
             "A98",	"D71",	"F18",	"G57",	"I05",	"J37",	"K83",	"M22",	"N45",	
             "B00",	"D72",	"F19",	"G58",	"I06",	"J38",	"K85",	"M23",	"N46",	
             "B01",	"D73",	"F20",	"G59",	"I07",	"J39",	"K86",	"M24",	"N47",	
             "B02",	"D74",	"F21",	"G60",	"I08",	"J40",	"K87",	"M25",	"N48",	
             "B03",	"D75",	"F22",	"G61",	"I09",	"J41",	"K90",	"M30",	"N49",	
             "B05",	"D76",	"F23",	"G62",	"I10",	"J42",	"K91",	"M31",	"N50",	
             "B06",	"D77",	"F24",	"G63",	"I11",	"J43",	"K92",	"M32",	"N51",	
             "B07",	"D80",	"F25",	"G64",	"I12",	"J44",	"K93",	"M33",	"N60",	
             "B08",	"D81",	"F28",	"G70",	"I13",	"J45",	"L00",	"M34",	"N61",	
             "B09",	"D82",	"F29",	"G71",	"I15",	"J46",	"L01",	"M35",	"N62",	
             "B15",	"D83",	"F30",	"G72",	"I20",	"J47",	"L02",	"M36",	"N63",	
             "B16",	"D84",	"F31",	"G73",	"I21",	"J60",	"L03",	"M40",	"N64",	
             "B17",	"D86",	"F32",	"G80",	"I22",	"J61",	"L04",	"M41",	"N70",	
             "B18",	"D89",	"F33",	"G81",	"I23",	"J62",	"L05",	"M42",	"N71",	
             "B19",	"E01",	"F34",	"G82",	"I24",	"J63",	"L08",	"M43",	"N72",	
             "B20",	"E02",	"F38",	"G83",	"I25",	"J64",	"L10",	"M45",	"N73",	
             "B21",	"E03",	"F39",	"G90",	"I26",	"J66",	"L11",	"M46",	"N74",	
             "B22",	"E04",	"F40",	"G91",	"I27",	"J67",	"L12",	"M47",	"N75",	
             "B23",	"E05",	"F41",	"G92",	"I28",	"J68",	"L13",	"M48",	"N76",	
             "B24",	"E06",	"F42",	"G93",	"I30",	"J69",	"L14",	"M49",	"N77",	
             "B25",	"E07",	"F43",	"G94",	"I31",	"J70",	"L20",	"M50",	"N80",	
             "B26",	"E10",	"F44",	"G95",	"I32",	"J80",	"L21",	"M51",	"N81",	
             "B27",	"E11",	"F45",	"G96",	"I33",	"J81",	"L22",	"M53",	"N82"	
)
row.names(icd) <- icd[,1]
icd200<-icd[var_icd10]
length(icd200)
row.names(icd200) <- icd200[,1]
icd200$n_eid<-row.names(icd200)

###针对所有icd10--命名为icd_b
name_icd10<-names(icd200)
b<-"_b"
ccc<-paste(name_icd10,b,sep ="")
ccc<-ccc[-1]
ccc<-c(ccc,"n_eid")
icd_b<-icd[ccc]
str(icd_b)
###针对所有icd10，命名为surv_icd
c<-"Surv_"
ddd<-paste(c,name_icd10,sep ="")
length(ddd)
ddd<-ddd[-1]
ddd<-c(ddd,"n_eid")
surv_icd<-icd[ddd]
str(surv_icd)

##合并n>200的ICD和n>200的ICD_b和其他的suvtime变量
data_icd<-merge(icd200,icd_b,by="n_eid")
data_icd<-merge(data_icd,surv_icd,by="n_eid")

remove(icd200,icd_b,surv_icd)
gc()


###协变量数据初步整理，加标签（见本地文件）--------

table(biobank$income)
biobank$income<-factor(biobank$income,levels =c( "Less than 18,000","18,000 to 30,999","31,000 to 51,999" 
                                                 ,"52,000 to 100,000", "Greater than 100,000", "99"),
                       labels =c( "Less than 18,000","18,000 to 30,999","31,000 to 51,999" 
                                  ,"52,000 to 100,000", "Greater than 100,000", "unkonwn/missing"))

biobank$edu<-factor(biobank$edu,levels = c("College or University degree" ,"A levels/AS levels or equivalent"
                                           ,"O levels/GCSEs or equivalent" ,"CSEs or equivalent" ,"NVQ or HND or HNC or equivalent"
                                           ,"Other professional qualifications eg: nursing, teaching" ,"99"),
                    labels = c("College or University degree" ,"A levels/AS levels or equivalent"
                               ,"O levels/GCSEs or equivalent" ,"CSEs or equivalent" ,"NVQ or HND or HNC or equivalent"
                               ,"Other professional qualifications eg: nursing, teaching" ,"unkonwn/missing"))
table(biobank$eth)
biobank$eth<-factor(biobank$eth,levels = c("1" ,"2" ,"3" ,"4","5" ,"6", "99" ), labels=c("white" ,"Mixed" ,"Asian or Asian British" ,"Black or Black British"
                                                                                         ,"Chinese" ,"other", "unkonwn/missing" ))
table(biobank$salt)
biobank$salt<-factor(biobank$salt,levels = c("Never/rarely" ,"Sometimes" ,"Usually" ,"Always" ,"99" )
                     ,labels = c("Never/rarely" ,"Sometimes" ,"Usually" ,"Always" ,"unkonwn/missing" ))

table(biobank$drinking)
biobank$drinking<-factor(biobank$drinking,levels = c("Daily or almost daily" ,"Three or four times a week" ,"Once or twice a week"
                                                     ,"One to three times a month" ,"Special occasions only" ,"Never" ,"99" )
                         ,labels = c("Daily or almost daily" ,"Three or four times a week" ,"Once or twice a week"
                                     ,"One to three times a month" ,"Special occasions only" ,"Never" ,"unkonwn/missing" ))

table(biobank$smoking)
biobank$smoking<-factor(biobank$smoking,levels = c("Current" ,"Previous"  ,"Never" ,"99"),labels = c("Current" ,"Previous"  ,"Never" ,"unkonwn/missing"))
biobank$Phy_act <-biobank$MET_g
table(biobank$Phy_act)
biobank$Phy_act<-factor(biobank$Phy_act,levels = c("low","moderate" ,"high" ,"99"),labels = c("low","moderate" ,"high" ,"unkonwn/missing"))
table(biobank$hp)
biobank$hp<-factor(biobank$hp,levels = c(0,1),labels=c("No", "Yes"))

biobank$fruit_g<-factor(biobank$fruit_g,levels = c(0,1,99),labels = c("No","Yes" ,"Missing"))
#####注意变量的位置，数据修改后，变量位置也要修改；
# for death
death=which(colnames(biobank)=="death")
LH_d=which(colnames(biobank)=="LH_d")
for (i in c(death:LH_d)){ 
  biobank[,i]<-factor(biobank[,i],levels = c(0,1),labels=c("No", "Yes"))}  

biobank$juejin<-NA
biobank$juejin[biobank$menopause=="Yes"]<-1
biobank$juejin[biobank$menopause=="No"]<-2
biobank$juejin[biobank$menopause!="No"&biobank$menopause!="Yes"&biobank$gender=="Female"]<-3
biobank$juejin[biobank$juejin==3 &biobank$age>=53]<-1
biobank$juejin[biobank$juejin==3]<-2
biobank$juejin<-factor(biobank$juejin,levels = c(1,2),labels=c( "postmenopause","premenopause"))
table(biobank$juejin, biobank$breast_c)

###For IBS related disorders
lll=which(colnames(biobank)=="IBS_in")                               
aaa=which(colnames(biobank)=="caesarian")
for (i in c(lll:aaa)){ 
  biobank[,i]<-factor(biobank[,i],levels = c(0,1),labels=c("No", "Yes"))}
biobank$IBS_s<-factor(biobank$IBS_s,levels = c(0,1,2,99),labels=c("No","Started suddenly", "Came on gradually","Cannot remember"))

### for some medcine
lll=which(colnames(biobank)=="niza2")                               
aaa=which(colnames(biobank)=="coeliac")
for (i in c(lll:aaa)){ 
  biobank[,i]<-factor(biobank[,i],levels = c(0,1),labels=c("No", "Yes"))}


lll=which(colnames(biobank)=="lanso0")       #lanso0="lansoprazole at baseline"                          
aaa=which(colnames(biobank)=="cime2")
for (i in c(lll:aaa)){ 
  biobank[,i]<-factor(biobank[,i],levels = c(0,1),labels=c("No", "Yes"))}


biobank$Laxat<-factor(biobank$Laxat,levels=c(0,1,99),labels = c("No","Yes" ,"Missing"))
biobank$vitamin<-factor(biobank$vitamin,levels=c(0,1,99),labels = c("No","Yes" ,"Missing"))
biobank$mineral<-factor(biobank$mineral,levels =c(0,1,99),labels= c("No","Yes" ,"Missing"))
biobank$ASP<-factor(biobank$ASP)
biobank$Par<-factor(biobank$Par)
biobank$Ibu<-factor(biobank$Ibu)
biobank$NASIDS<-factor(biobank$NASIDS)


##for MetS
####cob为"cen_obesity"的位置，MTN为"MetS_c" 的位置
cob=which(colnames(biobank)=="cen_obesity")
MTN=which(colnames(biobank)=="MetS_c")
for (i in c(cob:MTN)){ 
  biobank[,i]<-factor(biobank[,i],levels = c(0,1),labels=c("No", "Yes"))}
biobank$MetS_c4<-as.factor(biobank$MetS_c4)


#######---------end--初步整理完毕
###对数据进一步处理---------------生成dataukb-----------------
dataukb<-biobank
level_key <-c("Mixed" ="Non-White","Asian or Asian British"="Non-White" ,"Black or Black British"="Non-White",
              "Chinese" ="Non-White","other"="Non-White")
dataukb$eth<-recode_factor(dataukb$eth,!!!level_key)
level_ke <-c("Three or four times a week"="1-4 times a week" ,"Once or twice a week"="1-4 times a week",
             "Special occasions only"="Special occasions only or never" ,"Never"="Special occasions only or never")
dataukb$drinking4<-recode_factor(dataukb$drinking,!!!level_ke)
dataukb$drinking4<-factor(dataukb$drinking4,levels = c("Daily or almost daily" ,
                                                       "1-4 times a week" ,
                                                       "One to three times a month" ,
                                                       "Special occasions only or never" ,
                                                       "unkonwn/missing" ))

dataukb<-within(dataukb,
                {drink<-NA
                drink[drinking=="Never"]=0
                drink[drinking=="unkonwn/missing" |drinking=="Special occasions only"]=1
                drink[drinking=="One to three times a month"]=2
                drink[drinking=="Once or twice a week" |drinking=="Three or four times a week"]=3
                drink[drinking=="Daily or almost daily"]=4})

dataukb$drink<-factor(dataukb$drink,levels = c(0,1,2,3,4),labels = c( "Never",
                                                                      "Special occasions only" , 
                                                                      "One to three times a month" ,
                                                                      "1-4 times a week" ,
                                                                      "Daily or almost daily" ))


level_k <-c("College or University degree" ="College or University degree","A levels/AS levels or equivalent"="Other"
            ,"O levels/GCSEs or equivalent"="Other" ,"CSEs or equivalent"="Other" ,"NVQ or HND or HNC or equivalent"="Other"
            ,"Other professional qualifications eg: nursing, teaching"="Other" )
dataukb$edu2<-recode_factor(dataukb$edu,!!!level_k)
dataukb$bmic[dataukb$bmic==99]=2
dataukb$bmic<-factor(dataukb$bmic,levels = c( 2,1,3,4),labels = c( "normal","lossweight","overweight","obesity" ))


levels(dataukb$eth)
dataukb$agecat<-cut(dataukb$age,breaks=c(35,55,65,75))
dataukb$agecat<-factor(dataukb$agecat,levels = c("(35,55]" ,"(55,65]" ,"(65,75]"),labels=c("1", "2","3"))



#diabete="all type diabetes according to UKB"
#insulin0 ="insulin at baseline"
#antdm0="any type of antidiabetic drugs use at baseline, excluding metformin and insulin use"

#all type of type 2 diabete at baseline
dataukb$diabete_b=0
dataukb<-within(dataukb, {diabete_b[diabete==1&Survtime_diabete<=0]=1
diabete_b[insulin0=="Yes"|antdm0=="Yes"]=1
diabete_b[glucose>=11.1|HbA1c>=48]=1})

dataukb$HBP=0
dataukb<-within(dataukb, 
                {HBP[hypert_s==1|high_bpD==1]=1
                HBP[bp_m==1]=1
                HBP[SBP>=140|DBP>=90]=1}) #hypert_s="self-reported hypertension" 


# chol_m="Cholesterol lowering medication" 
# chol_s="self-reported high cholesterol"
dataukb$chol_h<-0
dataukb<-within(dataukb, 
                {chol_h[chol_s==1]=1
                chol_h[chol_m==1]=1})

##cancer before enrollment (cancer_b includes 33 missing value compared with bca)
dataukb$bca=0
dataukb<-within(dataukb, {bca[cancer==1 & survtime<=0]=1
bca[ca==1]=1})



##数据整理完毕---------------生成dataukb

######----------绝经前后----------------- 1=已绝经；0=未绝经；99=unknown
dataukb$menopause1<-0
dataukb$menopause1[dataukb$menopause=="Yes"&dataukb$gender=="Female"]<-1
dataukb$menopause1[dataukb$gender=="Female"&dataukb$age>=53]<-1
dataukb$menopause1[dataukb$menopause=="No"&dataukb$gender=="Female"]<-0
dataukb$menopause1[is.na(dataukb$menopause1)&dataukb$gender=="Female"]<-99

dataukb<-within(dataukb,
                {breast_c_pos<-NA
                breast_c_pos[gender=="Female"&menopause1==1&breast_c=="Yes"]=1
                breast_c_pos[gender=="Female"&menopause1==1&breast_c=="No"]=0
                breast_c_pro<-NA
                breast_c_pro[gender=="Female"&menopause1==0&breast_c=="Yes"]=1
                breast_c_pro[gender=="Female"&menopause1==0&breast_c=="No"]=0})

dataukb$breast_c[dataukb$gender=="Male"]<-NA
dataukb$prostate_c[dataukb$gender=="Female"]<-NA
dataukb$Uterus_c[dataukb$gender=="Male"]<-NA
dataukb$ovary_c[dataukb$gender=="Male"]<-NA
dataukb$cervix_c[dataukb$gender=="Male"]<-NA


######delete participants withdrew from the study (n=1298)

#data_test<-dataukb[sample(nrow(dataukb),50000),]

#########----PPI_H2RA
## PPI_S0="any type of  PPI use at baseline"  h2ra_S0="any type of H2RA use at baseline"
dataukb<-within(dataukb,  
                {PPI_H2<-1
                PPI_H2[h2ra_S0=="No"&PPI_S0=="No"]=1
                PPI_H2[h2ra_S0=="No"&PPI_S0=="Yes"]=2
                PPI_H2[h2ra_S0=="Yes"&PPI_S0=="No"]=3
                PPI_H2[h2ra_S0=="Yes"&PPI_S0=="Yes"]=4})


dataukb$oesophagitis_b<-ifelse(dataukb$oesophagitis==1&dataukb$Survtime_oesophagitis<=0,1,0)
dataukb$gerd_b<-ifelse(dataukb$GERD==1&dataukb$Survtime_GERD<=0,1,0) #/*gastro-oesophageal reflux (gord) / gastric reflux;*/
dataukb$ulcer_b<-ifelse((dataukb$Gu==1&dataukb$Survtime_Gu<=0) |(dataukb$Du==1&dataukb$Survtime_Du<=0),1,0)
dataukb$MI_b<-ifelse((dataukb$MI==1&dataukb$Survtime_MI<=0),1,0)
dataukb$CHD_b<-ifelse((dataukb$CHD==1&dataukb$Survtime_CHD<=0),1,0)
dataukb$CHF_b<-ifelse(((dataukb$CHF==1&dataukb$Survtime_CHF<=0)|dataukb$CHF_b==1),1,0)
dataukb$PVD_b<-ifelse(((dataukb$PVD==1&dataukb$Survtime_PVD<=0)),1,0)
dataukb$AF_b<-ifelse(((dataukb$AF==1&dataukb$Survtime_AF<=0)),1,0)
dataukb$stroke_b<-ifelse(((dataukb$stroke==1&dataukb$Survtime_stroke<=0)),1,0)
dataukb$UC_b<-ifelse(((dataukb$UC==1&dataukb$Survtime_UC<=0)),1,0)
dataukb$CD_b<-ifelse(((dataukb$CD==1&dataukb$Survtime_CD<=0)),1,0)
dataukb$IBD_b<-ifelse((dataukb$CD_b==1 | dataukb$UC_b==1),1,0)
dataukb$obstr_b<-ifelse(((dataukb$obstr==1&dataukb$Survtime_obstr<=0) |dataukb$obstr_b==1 ),1,0) #obstr=oesophageal stricture
dataukb$Ou_b<-ifelse(((dataukb$Ou==1&dataukb$Survtime_Ou<=0)),1,0) #/*oesophageal ulcer;*/
dataukb$Gu_b<-ifelse(((dataukb$Gu==1&dataukb$Survtime_Gu<=0)),1,0) #Gastric ulcer(GU)
dataukb$Du_b<-ifelse(((dataukb$Du==1&dataukb$Survtime_Du<=0)),1,0) #/*Duodenal ulcer*/
dataukb$Pu_b<-ifelse(((dataukb$Pu==1&dataukb$Survtime_Pu<=0)),1,0) #/*Peptic ulcer, site unspecified*/
dataukb$Gs_b<-ifelse(((dataukb$Gs==1&dataukb$Survtime_Gs<=0)),1,0) # Gastritis（GS）
dataukb$Dysp_b<-ifelse(((dataukb$Dysp==1&dataukb$Survtime_Dysp<=0)),1,0) #/*Disorders of function of stomach*/
dataukb$ugib_b<-ifelse(((dataukb$ugib==1&dataukb$Survtime_ugib<=0) |dataukb$ugib_b==1 ),1,0) #Upper gastrointestinal  bleeding and gastrointestinal  bleeding 
dataukb$galst_b<-ifelse(((dataukb$galst==1&dataukb$Survtime_galst<=0)),1,0) # Cholelithiasis at baseline
dataukb$galcy_b<-ifelse(((dataukb$galcy==1&dataukb$Survtime_galcy<=0)),1,0) # Cholecystitis at baseline
dataukb$galag_b<-ifelse(((dataukb$galag==1&dataukb$Survtime_galag<=0)),1,0) # Cholangitis at baseline
dataukb$IBS_b<-ifelse(((dataukb$IBS==1&dataukb$Survtime_IBS<=0)),1,0) # IBS at baseline
dataukb$Survtime_IBD<-dataukb$Survtime_CD
dataukb$Survtime_IBD<-ifelse(dataukb$Survtime_IBD<dataukb$Survtime_UC,dataukb$Survtime_IBD,dataukb$Survtime_UC)
dataukb$gerd_b<-as.factor(dataukb$gerd_b)
dataukb$ulcer_b<-as.factor(dataukb$ulcer_b)
dataukb$COPD_b<-ifelse(((dataukb$COPD==1&dataukb$Survtime_COPD<=0)),1,0) # COPD at baseline
dataukb$asthma_b<-ifelse(((dataukb$asthma==1&dataukb$Survtime_asthma<=0)),1,0) # asthma at baseline
#bronchiectasis icd10:J47=1
dataukb$bronch_b<-ifelse(((dataukb$bronch==1&dataukb$Survtime_bronch<=0)),1,0) # bronch at baseline   
#/* bronchiectasis */ icd10:J40=1 or J41=1  or J42=1  or J47=1
dataukb$bronchiectasis_b<-ifelse(((dataukb$bronchiectasis==1&dataukb$Survtime_bronchiectasis<=0)),1,0) # bronchiectasis at baseline 
#"Dement","Survtime_Dement","AD","Survtime_AD","VD", "Survtime_VD","undemen", "Survtime_undemen",
dataukb$Dement_b<-ifelse(((dataukb$Dement==1&dataukb$Survtime_Dement<=0)),1,0) # Dement at baseline 
dataukb$AD_b<-ifelse(((dataukb$AD==1&dataukb$Survtime_AD<=0)),1,0) # AD at baseline 
dataukb$VD_b<-ifelse(((dataukb$VD==1&dataukb$Survtime_VD<=0)),1,0) # VD at baseline 
dataukb$undemen_b<-ifelse(((dataukb$undemen==1&dataukb$Survtime_undemen<=0)),1,0) # undemen at baseline 

dataukb$index<- ifelse((dataukb$oesophagitis_b==1)
                       | (dataukb$gerd_b==1)
                       | (dataukb$obstr_b==1)
                       | (dataukb$ulcer_b==1)
                       | (dataukb$Dysp_b==1)
                       | (dataukb$ugib_b==1),1,0) 

dataukb$index<-factor(dataukb$index,levels = c(0,1),labels = c("No","Yes"))

dataukb<-within(dataukb,
                {gh=NA
                gh[Health_R=="Excellent"]=0
                gh[Health_R=="Good"]=1
                gh[Health_R=="Fair"]=2
                gh[Health_R=="Poor"]=3
                gh[Health_R=="Do not know"|Health_R=="Prefer not to answer"|Health_R==""]=4})
dataukb$Health_R<-dataukb$gh
dataukb$Health_R<-factor(dataukb$Health_R,levels = c(0,1,2,3,4),labels = c( "Excellent",
                                                                            "Good" , 
                                                                            "Fair" ,
                                                                            "Poor" ,
                                                                            "Do not know" ))


dataukb<-within(dataukb,
                {illness<-NA
                illness[illness_L=="No"]=0
                illness[illness_L=="Yes"]=1
                illness[illness_L=="Do not know"|illness_L=="Prefer not to answer"|illness_L==""]=2})
dataukb$illness_L<-dataukb$illness
dataukb$illness_L<-factor(dataukb$illness_L,levels = c(0,1,2),labels = c( "No",
                                                                          "Yes" , 
                                                                          "Do not know"  ))

remove(biobank)
gc()
#######Often used Confounder and exposure data preparation----------
vars_use<-c("n_eid", "Survtime_CD", "Survtime_UC", "Survtime_IBS","survtime","UC" ,"CD","IBS","IBD","Survtime_IBD",
            "chol_s","hypert_s","db_s","DM", "high_bpD" , "diabete_b", "HBP","bca","chol_h",
            "UC_b",  "CD_b", "IBS_b","IBD_b",
            "oesophagitis_b",  "gerd_b", "obstr_b","Ou_b","Gu_b",  "Du_b", "Pu_b","Gs_b" ,"Dysp_b","ulcer_b", "ugib_b" ,
            "wc" ,"hip",  "height", "BMI","weight","SBP","gender","glucose","HbA1c",
            "centre","edu","age","eth","IDM","drinking","smoking","MET","Phy_act","fruit","vageta","F_V_t","fruit_g",
            "chol_m","bp_m","juejin","index",
            "lanso0",  "ome0", "panto0","rabe0","esome0","cime0",  "famo0", "niza0",        
            "rani0", "insulin0" ,"metf0" ,"sulpho0" ,"Glita0","antdbt0" , "antdm0","simvas" ,"atovas", "statinO",
            "ACEI",  "ARBs",  "beteb", "Cach" , "TD" ,"LD","PSD", "antp","clogrel" , "antg",
            "PPI_S0","h2ra_S0", "glcom","salt",
            "statin","vitamin","mineral","ASP","Par","Ibu","NASIDS",
            "cancer_N", "noncancer_N","operations_N", "treatment_N",
            "bmic", "cen_obesity","obesity",
            "drinking4","age1","edu2","agecat","PPI_H2",
            "OCT", "HRT", "MetS_c", "MetS1", "Colorect_c", "colon_c","CRP","drink",
            "menopause1","Vitam_D","TG_H","HDL_L","bp_h","DM_H","DBP",
            "galltect","galst_b","galcy_b","galag_b","galcy_a","galcy_k",
            "diabete","Survtime_diabete", "BFP" , "WBFM",  "WBFFM" , "WBWM"  ,
            "BMI_I", "BMR",  "IWB",  "ILR",  "ILL",   "IAR",  "IAL",   "LFP_R",  "LFM_R",  "LFFM_R", "LPM_R", "LFP_L",  "LFM_L",
            "LFFM_L",  "LPM_L", "AFP_R", "AFM_R", "AFFM_R", "APM_R", "AFP_L", "AFM_L", "AFFM_L",   "APM_L", 
            "TFP", "TFM", "TFFM" ,"PPI_H2","CRP","GDM",
            "COPD","Survtime_COPD","asthma","Survtime_asthma","bronchiectasis","Survtime_bronchiectasis","bronch","Survtime_bronch", 
            "resdis","Survtime_resdis",
            "Dement","Survtime_Dement","AD","Survtime_AD","VD", "Survtime_VD","undemen", "Survtime_undemen",
            "death","Cancer_d","Survtime_d","lung_c","Source_IBS","Source_diabete",
            "galst","Survtime_galst","galcy","Survtime_galcy","galag","Survtime_galag",
            "Health_R","illness_L","CHOL","hp","LDL","HDL","TG","pancre_c","liver_c","Survtime_L"
            
)
data_USE<-dataukb[vars_use]

###recode variables:missing rate <1%, the missing value was recoded into the largest groups
#########delete participants with IBS at baseline (n=25464)

data_USE$BMI<- ifelse(is.na(data_USE$BMI), mean(data_USE$BMI), data_USE$BMI)
data_USE$SBP<- ifelse(is.na(data_USE$SBP), mean(data_USE$SBP), data_USE$SBP)

data_USE$smoking<- ifelse(data_USE$smoking=="unkonwn/missing","3", data_USE$smoking)
data_USE$smoking<-factor(data_USE$smoking,levels = c("1","2","3"),labels = c("Current" ,"Previous"  ,"Never" ))
table(data_USE$smoking)

data_USE$drinking4<- ifelse(data_USE$drinking4=="unkonwn/missing","2", data_USE$drinking4)
data_USE$drinking4<-factor(data_USE$drinking4,levels = c("1","2","3","4"),
                           labels = c("Daily or almost daily" ,"1-4 times a week" ,
                                      "One to three times a month" ,"Special occasions only/Never"  ))
table(data_USE$drinking4)

table(data_USE$fruit_g)
data_USE$fruit_g<- ifelse(data_USE$fruit_g=="Missing","1", data_USE$fruit_g)
data_USE$fruit_g<-factor(data_USE$fruit_g,levels = c("1","2"),labels = c("No","Yes"))
table(data_USE$fruit_g)

table(data_USE$vitamin)
data_USE$vitamin<- ifelse(data_USE$vitamin=="Missing",1, data_USE$vitamin)
data_USE$vitamin<-factor(data_USE$vitamin,levels = c(1,2),labels = c("No","Yes"))
table(data_USE$vitamin)
data_USE$NASIDS1<- ifelse(data_USE$NASIDS==1 |data_USE$Par==1,"Yes", "No")
table(data_USE$NASIDS1)
table(data_USE$mineral)
data_USE$mineral<- ifelse(data_USE$mineral=="Missing","1", data_USE$mineral)
data_USE$mineral<-factor(data_USE$mineral,levels = c("1","2"),labels = c("No","Yes"))
table(data_USE$mineral)

data_USE$eth<- ifelse(data_USE$eth=="unkonwn/missing","2", data_USE$eth)
data_USE$eth<-factor(data_USE$eth,levels = c("1","2"),labels = c("Non-White","white"))
table(data_USE$eth)

data_USE$OCT<- ifelse((is.na(data_USE$OCT) | data_USE$OCT==99),"0", data_USE$OCT)
data_USE$OCT<-factor(data_USE$OCT,levels = c("0","1"),labels = c("No","Yes"))
data_USE$OCT<-ifelse(data_USE$gender=="Male",NA,data_USE$OCT)
data_USE$OCT<-factor(data_USE$OCT,levels = c("1","2"),labels = c("No","Yes"))
table(data_USE$OCT)

data_USE$menopause1<-ifelse(data_USE$gender=="Male",NA,data_USE$menopause1)
data_USE$menopause1<-factor(data_USE$menopause1,levels = c(0,1),labels = c("No","Yes"))
table(data_USE$menopause1)

data_USE$HRT<- ifelse((is.na(data_USE$HRT) | data_USE$HRT==99),0, data_USE$HRT)
data_USE$HRT<-ifelse(data_USE$gender=="Male",NA,data_USE$HRT)
data_USE$HRT<-factor(data_USE$HRT,levels = c("0","1"),labels = c("No","Yes"))
table(data_USE$HRT)

data_USE$ASP<-as.factor(data_USE$ASP) # ASP="aspirin use"           
data_USE$Par<-as.factor(data_USE$Par) # Par="paracetamol" 
data_USE$NASIDS<-as.factor(data_USE$NASIDS) #NASIDS="non aspirin NASIDs use"
data_USE$bca	<-as.factor(data_USE$bca	) # cancer at baseline
data_USE$HBP<-as.factor(data_USE$HBP)     #hypertention by doctor or self-reported or use antihypertensive drugs
data_USE$diabete_b<-as.factor(data_USE$diabete_b)     # any type of diabetes at baseline or use antidiabetic drugs or insulin at baseline
data_USE$chol_h<-as.factor(data_USE$chol_h) ##  self-reported high cholesterol or use Cholesterol lowering medication


data_USE$antpl<-ifelse(data_USE$antp=="Yes"|data_USE$antg=="Yes","Yes", "No")  #antp="Antiplatelets" antg="Anticoagulants"
table(data_USE$antpl)

data_USE$age2=data_USE$age1+data_USE$Survtime_UC
data_USE$MET_h=data_USE$MET/60
data_USE$age3=data_USE$age1+data_USE$Survtime_CD
data_USE$age_ibd<-data_USE$age1+data_USE$Survtime_IBD
data_USE$ppi_other<-ifelse(data_USE$panto0=="Yes" | data_USE$rabe0=="Yes","Yes", "No")
table(data_USE$ppi_other)
data_USE$non_ppi<-ifelse(data_USE$ome0=="No"& data_USE$ome0=="No"&data_USE$lanso0=="No"&data_USE$esome0=="No"& data_USE$ppi_other=="No","No","Yes")
data_USE$gender1<-ifelse(dataukb$gender=="Male" |dataukb$gender=="Female",dataukb$gender,NA)
data_USE$gender<-data_USE$gender1
data_USE$MET1<-data_USE$MET/60
data_USE$H2_other<-ifelse(data_USE$cime0=="Yes" | data_USE$famo0=="Yes" | data_USE$niza0=="Yes","Yes", "No")
table(data_USE$H2_other)
data_USE$non_H2RA<-ifelse(data_USE$cime0=="No"& data_USE$famo0=="No"&data_USE$niza0=="No"&data_USE$rani0=="No","No","Yes")
data_USE$liver_cb<-ifelse(((dataukb$liver_c==1&dataukb$survtime<=0)),1,0) # liver cancer at baseline
data_USE$pancre_cb<-ifelse(((dataukb$pancre_c==1&dataukb$survtime<=0)),1,0) # pancrease cancer at baseline

###合并睡眠和食盐数据
salt_sleep<-salt_sleep[c("n_eid","sleep_tc")]
data_USE<-merge(data_USE,salt_sleep,by="n_eid")
data_USE$sleep_tc<-factor(data_USE$sleep_tc,levels = c("1","2","3","4"),
                          labels = c("<8h" ,"8h"  ,"8-9h",">9h" ))
##抗血小板凝集药物
data_USE$antiple<-ifelse(data_USE$antp=="Yes"|data_USE$clogrel=="Yes"|data_USE$antg=="Yes","Yes","No")
data_USE$liniao<-ifelse(data_USE$TD=="Yes"|data_USE$LD=="Yes"|data_USE$PSD=="Yes","Yes","No")
#ASP="aspirin use"    Par="paracetamol"   Ibu="ibuprofen"   NASIDS="non aspirin NASIDs use"
#ACEI="Angiotensin-converting enzyme (ACE) inhibitors"  ARBs="Angiotensin II receptor blockers"  beteb="beta-blockers"
#Cach="calcium channel blockers"   TD="Thiazide diuretics"   LD="Loop diuretics"    PSD="Potassium sparing diuretics"

#####人群的纳入排除-------
# Survtime_L="Date lost to follow-up" n=1298
data_USE<-data_USE[is.na(data_USE$Survtime_L),]
###删除32个NA数据
data_USE<-data_USE[is.na(data_USE$agecat)=="FALSE",] 

###整个lancet30的分析数据-----------
data_phe<-merge(data_USE,data_icd,by="n_eid")
data_phe<-merge(data_phe,icd_lanc,by="n_eid")

data_fam<-dataukb[c("n_eid","heartd_hf","stroke_hf","lungc_hf",
                    "bowelc_hf","breastc_hf","chrbr_hf","hbp_hf",
                    "dmm_hf","ad_hf","pd_hf","de_hf","Pca_hf")]
data_phe<-merge(data_phe,data_fam,by="n_eid")
gc()

######到止为止，直接导入data_phe的数据进行后续数据分析即可-------------
lancet60_name<-c("isd_case" , 	"stroke_case" , 	"copd_case" , 	"alz_case" , 	"diab_case" , 
                 "lres_case" , 	"lung_can" , 	"fall_case" , 	"ckd_case" , 	"hearl_case" , 	
                 "hhd_case" , 	"diarr_case" , 	"lbpain_case" , 	"crc_can" , 	"visl_case" , 
                 "af_case" , 	"stom_can" , 	"pros_can" , 	"cirr_case" , 	"parkd_case" , 	
                 "oste_case" , 	"orald_case" , 	"tube_case" , 	"asth_case" , 	"roadi_case" , 
                 "panc_can" , 	"depr_case" , 	"brea_can" , 	"urin_case" , 	"othmus_case" , 
                 "esop_can" , 	"upped_case" , 	"endo_case" , 	"live_can" , 	"cardio_case" , 	
                 "othcvd_case" , 	"blad_can" , 	"neckp_case" , 	"oth_can" , 	"nrvhd_case" , 	
                 "rhd_case" , 	"leuk_can" , 	"galld_case" , 	"nhod_can" , 	"parao_case" , 	
                 "intps_case" , 	"anxiety_case" , 	"selfh_case" , 	"aorta_case" , 	"gall_can" , 
                 "headd_case" , 	"hiv_case" , 	"alcod_case" , 			"cerv_can" , 	"schi_case" , 	
                 "malaria_case" , 	"brain_can" , 	"interv_case" 
)




cancer_name<-c("lung_can", 	"crc_can", 	"stom_can", 	 	"panc_can", 	 	
               "esop_can", 	"live_can")

cvd_name<-c("isd_case", 	"stroke_case", 	"hhd_case", 	"af_case", 	"cardio_case", 
            "othcvd_case", 	"nrvhd_case", 	"rhd_case", 	"aorta_case")
cvd_name2<-c("isd", 	"stroke", 	"hhd", 	"af", 	"cardio", 
             "othcvd", 	"nrvhd", 	"rhd", 	"aorta")

########PHEWAS- PPI and CHD-----------
results_chd<-c()  
fit<- coxph(Surv(age1,survt_isd+age1,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_isd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_chd1<- out[1,]
out_chd1
results_chd<-rbind(results_chd,out_chd1)  

fit<- coxph(Surv(age1,survt_isd+age1,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_isd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_chd2<- out[1,]
out_chd2
results_chd<-rbind(results_chd,out_chd2)  

fit<- coxph(Surv(age1,survt_isd+age1,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_isd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_chd3<- out[1,]
out_chd3
results_chd<-rbind(results_chd,out_chd3)  

fit<- coxph(Surv(age1,survt_isd+age1,isd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_isd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_chd4<- out[1,]
out_chd4
results_chd<-rbind(results_chd,out_chd4) 
results_chd
########PHEWAS- PPI and stroke-----------
results_stroke<-c()  
fit<- coxph(Surv(age1,survt_stroke+age1,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_stroke>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stroke1<- out[1,]
out_stroke1
results_stroke<-rbind(results_stroke,out_stroke1)  

fit<- coxph(Surv(age1,survt_stroke+age1,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+stroke_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_stroke>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stroke2<- out[1,]
out_stroke2
results_stroke<-rbind(results_stroke,out_stroke2)  

fit<- coxph(Surv(age1,survt_stroke+age1,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+stroke_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_stroke>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stroke3<- out[1,]
out_stroke3
results_stroke<-rbind(results_stroke,out_stroke3)  

fit<- coxph(Surv(age1,survt_stroke+age1,stroke_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+stroke_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_stroke>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stroke4<- out[1,]
out_stroke4
results_stroke<-rbind(results_stroke,out_stroke4) 
results_stroke
########PHEWAS- PPI and COPD-----------
results_copd<-c()  
fit<- coxph(Surv(age1,survt_copd+age1,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_copd>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_copd1<- out[1,]
out_copd1
results_copd<-rbind(results_copd,out_copd1)  

fit<- coxph(Surv(age1,survt_copd+age1,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_copd>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_copd2<- out[1,]
out_copd2
results_copd<-rbind(results_copd,out_copd2)  

fit<- coxph(Surv(age1,survt_copd+age1,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_copd>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_copd3<- out[1,]
out_copd3
results_copd<-rbind(results_copd,out_copd3)  

fit<- coxph(Surv(age1,survt_copd+age1,copd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_copd>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_copd4<- out[1,]
out_copd4
results_copd<-rbind(results_copd,out_copd4) 
results_copd


########PHEWAS- PPI and Alzheimer's disease and other dementias-----------
results_alz<-c()  
fit<- coxph(Surv(age1,survt_alz+age1,alz_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_alz>=2
                          &data_phe$F00_b==0&data_phe$F01_b==0
                          &data_phe$F02_b==0&data_phe$F03_b==0
                          &data_phe$G30_b==0&data_phe$G31_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_alz1<- out[1,]
out_alz1
results_alz<-rbind(results_alz,out_alz1)  

fit<- coxph(Surv(age1,survt_alz+age1,alz_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_alz>=2
                          &data_phe$F00_b==0&data_phe$F01_b==0
                          &data_phe$F02_b==0&data_phe$F03_b==0
                          &data_phe$G30_b==0&data_phe$G31_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_alz2<- out[1,]
out_alz2
results_alz<-rbind(results_alz,out_alz2)  

fit<- coxph(Surv(age1,survt_alz+age1,alz_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_alz>=2
                          &data_phe$F00_b==0&data_phe$F01_b==0
                          &data_phe$F02_b==0&data_phe$F03_b==0
                          &data_phe$G30_b==0&data_phe$G31_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_alz3<- out[1,]
out_alz3
results_alz<-rbind(results_alz,out_alz3)  

fit<- coxph(Surv(age1,survt_alz+age1,alz_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_alz>=2
                          &data_phe$F00_b==0&data_phe$F01_b==0
                          &data_phe$F02_b==0&data_phe$F03_b==0
                          &data_phe$G30_b==0&data_phe$G31_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_alz4<- out[1,]
out_alz4
results_alz<-rbind(results_alz,out_alz4) 
results_alz


########PHEWAS- PPI and Diabetes mellitus-----------
results_diab<-c()  
fit<- coxph(Surv(age1,survt_diab+age1,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_diab>=2
                          &data_phe$E10_b==0&data_phe$E11_b==0
                          &data_phe$E12_b==0&data_phe$E13_b==0
                          &data_phe$E14_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diab1<- out[1,]
out_diab1
results_diab<-rbind(results_diab,out_diab1)  

fit<- coxph(Surv(age1,survt_diab+age1,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_diab>=2
                          &data_phe$E10_b==0&data_phe$E11_b==0
                          &data_phe$E12_b==0&data_phe$E13_b==0
                          &data_phe$E14_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diab2<- out[1,]
out_diab2
results_diab<-rbind(results_diab,out_diab2)  

ibd[c("n_eid","PRS_IBD","PRS_CD","PRS_UC")]
data_phe<-merge(ibd[c("n_eid","PRS_IBD","PRS_CD","PRS_UC")],data_phe,by="n_eid")
fit<- coxph(Surv(age1,survt_diab+age1,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h,
            data=data_phe[data_phe$survt_diab>=2
                          &data_phe$E10_b==0&data_phe$E11_b==0
                          &data_phe$E12_b==0&data_phe$E13_b==0
                          &data_phe$E14_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diab3<- out[1,]
out_diab3
results_diab<-rbind(results_diab,out_diab3)  

fit<- coxph(Surv(age1,survt_diab+age1,diab_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_diab>=2
                          &data_phe$E10_b==0&data_phe$E11_b==0
                          &data_phe$E12_b==0&data_phe$E13_b==0
                          &data_phe$E14_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diab4<- out[1,]
out_diab4
results_diab<-rbind(results_diab,out_diab4) 
results_diab

########PHEWAS- PPI and Lower respiratory infections-----------
results_lres<-c()  
fit<- coxph(Surv(age1,survt_lres+age1,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_lres>=2
                          &data_phe$A48_b==0&data_phe$A70_b==0
                          &data_phe$B97_b==0&data_phe$J09_b==0
                          &data_phe$J10_b==0&data_phe$J11_b==0
                          &data_phe$J12_b==0&data_phe$J13_b==0
                          &data_phe$J14_b==0&data_phe$J15_b==0
                          &data_phe$J16_b==0&data_phe$J20_b==0
                          &data_phe$J21_b==0&data_phe$J91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lres1<- out[1,]
out_lres1
results_lres<-rbind(results_lres,out_lres1)  

fit<- coxph(Surv(age1,survt_lres+age1,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_lres>=2
                          &data_phe$A48_b==0&data_phe$A70_b==0
                          &data_phe$B97_b==0&data_phe$J09_b==0
                          &data_phe$J10_b==0&data_phe$J11_b==0
                          &data_phe$J12_b==0&data_phe$J13_b==0
                          &data_phe$J14_b==0&data_phe$J15_b==0
                          &data_phe$J16_b==0&data_phe$J20_b==0
                          &data_phe$J21_b==0&data_phe$J91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lres2<- out[1,]
out_lres2
results_lres<-rbind(results_lres,out_lres2)  

fit<- coxph(Surv(age1,survt_lres+age1,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_lres>=2
                          &data_phe$A48_b==0&data_phe$A70_b==0
                          &data_phe$B97_b==0&data_phe$J09_b==0
                          &data_phe$J10_b==0&data_phe$J11_b==0
                          &data_phe$J12_b==0&data_phe$J13_b==0
                          &data_phe$J14_b==0&data_phe$J15_b==0
                          &data_phe$J16_b==0&data_phe$J20_b==0
                          &data_phe$J21_b==0&data_phe$J91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lres3<- out[1,]
out_lres3
results_lres<-rbind(results_lres,out_lres3)  

fit<- coxph(Surv(age1,survt_lres+age1,lres_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_lres>=2
                          &data_phe$A48_b==0&data_phe$A70_b==0
                          &data_phe$B97_b==0&data_phe$J09_b==0
                          &data_phe$J10_b==0&data_phe$J11_b==0
                          &data_phe$J12_b==0&data_phe$J13_b==0
                          &data_phe$J14_b==0&data_phe$J15_b==0
                          &data_phe$J16_b==0&data_phe$J20_b==0
                          &data_phe$J21_b==0&data_phe$J91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lres4<- out[1,]
out_lres4
results_lres<-rbind(results_lres,out_lres4) 
results_lres


########PHEWAS- PPI and Tracheal, bronchus, and lung cancer-----------
results_lung<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lung1<- out[1,]
out_lung1
results_lung<-rbind(results_lung,out_lung1)  

data_phe$copd_b<-ifelse(data_phe$survt_copd<=0,1,0)
fit<- coxph(Surv(age1,survtime_can+age1,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L+lungc_hf
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lung2<- out[1,]
out_lung2
results_lung<-rbind(results_lung,out_lung2)  

fit<- coxph(Surv(age1,survtime_can+age1,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lung3<- out[1,]
out_lung3
results_lung<-rbind(results_lung,out_lung3)  

fit<- coxph(Surv(age1,survtime_can+age1,lung_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lung4<- out[1,]
out_lung4
results_lung<-rbind(results_lung,out_lung4) 
results_lung
########PHEWAS- PPI and Falls-----------

results_fall<-c()  
fit<- coxph(Surv(age1,survt_fall+age1,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_fall>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_fall1<- out[1,]
out_fall1
results_fall<-rbind(results_fall,out_fall1)  

fit<- coxph(Surv(age1,survt_fall+age1,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_fall>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_fall2<- out[1,]
out_fall2
results_fall<-rbind(results_fall,out_fall2)  

fit<- coxph(Surv(age1,survt_fall+age1,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_fall>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_fall3<- out[1,]
out_fall3
results_fall<-rbind(results_fall,out_fall3)  

fit<- coxph(Surv(age1,survt_fall+age1,fall_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_fall>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_fall4<- out[1,]
out_fall4
results_fall<-rbind(results_fall,out_fall4) 
results_fall


########PHEWAS- PPI and CKD-----------
results_ckd<-c()  
fit<- coxph(Surv(age1,survt_ckd+age1,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_ckd>=2
                          &data_phe$D63_b==0&data_phe$E10_b==0
                          &data_phe$E11_b==0&data_phe$I12_b==0
                          &data_phe$I13_b==0&data_phe$N02_b==0
                          &data_phe$N03_b==0&data_phe$N04_b==0
                          &data_phe$N05_b==0&data_phe$N06_b==0
                          &data_phe$N07_b==0&data_phe$N08_b==0
                          &data_phe$N15_b==0&data_phe$N18_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_ckd1<- out[1,]
out_ckd1
results_ckd<-rbind(results_ckd,out_ckd1)  

fit<- coxph(Surv(age1,survt_ckd+age1,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_ckd>=2
                          &data_phe$D63_b==0&data_phe$E10_b==0
                          &data_phe$E11_b==0&data_phe$I12_b==0
                          &data_phe$I13_b==0&data_phe$N02_b==0
                          &data_phe$N03_b==0&data_phe$N04_b==0
                          &data_phe$N05_b==0&data_phe$N06_b==0
                          &data_phe$N07_b==0&data_phe$N08_b==0
                          &data_phe$N15_b==0&data_phe$N18_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_ckd2<- out[1,]
out_ckd2
results_ckd<-rbind(results_ckd,out_ckd2)  

fit<- coxph(Surv(age1,survt_ckd+age1,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_ckd>=2
                          &data_phe$D63_b==0&data_phe$E10_b==0
                          &data_phe$E11_b==0&data_phe$I12_b==0
                          &data_phe$I13_b==0&data_phe$N02_b==0
                          &data_phe$N03_b==0&data_phe$N04_b==0
                          &data_phe$N05_b==0&data_phe$N06_b==0
                          &data_phe$N07_b==0&data_phe$N08_b==0
                          &data_phe$N15_b==0&data_phe$N18_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_ckd3<- out[1,]
out_ckd3
results_ckd<-rbind(results_ckd,out_ckd3)  

fit<- coxph(Surv(age1,survt_ckd+age1,ckd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_ckd>=2
                          &data_phe$D63_b==0&data_phe$E10_b==0
                          &data_phe$E11_b==0&data_phe$I12_b==0
                          &data_phe$I13_b==0&data_phe$N02_b==0
                          &data_phe$N03_b==0&data_phe$N04_b==0
                          &data_phe$N05_b==0&data_phe$N06_b==0
                          &data_phe$N07_b==0&data_phe$N08_b==0
                          &data_phe$N15_b==0&data_phe$N18_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_ckd4<- out[1,]
out_ckd4
results_ckd<-rbind(results_ckd,out_ckd4) 
results_ckd


########PHEWAS- PPI and Age-related hearing loss-----------
results_hearl<-c()  
fit<- coxph(Surv(age1,survt_hearl+age1,hearl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_hearl>=2
                          &data_phe$H91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hearl1<- out[1,]
out_hearl1
results_hearl<-rbind(results_hearl,out_hearl1)  

fit<- coxph(Surv(age1,survt_hearl+age1,hearl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_hearl>=2
                          &data_phe$H91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hearl2<- out[1,]
out_hearl2
results_hearl<-rbind(results_hearl,out_hearl2)  

fit<- coxph(Surv(age1,survt_hearl+age1,hearl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_hearl>=2
                          &data_phe$H91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hearl3<- out[1,]
out_hearl3
results_hearl<-rbind(results_hearl,out_hearl3)  

fit<- coxph(Surv(age1,survt_hearl+age1,hearl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_hearl>=2
                          &data_phe$H91_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hearl4<- out[1,]
out_hearl4
results_hearl<-rbind(results_hearl,out_hearl4) 
results_hearl

########PHEWAS- PPI and Hypertensive heart disease-----------
results_hhd<-c()  
fit<- coxph(Surv(age1,survt_hhd+age1,hhd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_hhd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hhd1<- out[1,]
out_hhd1
results_hhd<-rbind(results_hhd,out_hhd1)  

fit<- coxph(Surv(age1,survt_hhd+age1,hhd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_hhd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hhd2<- out[1,]
out_hhd2
results_hhd<-rbind(results_hhd,out_hhd2)  

fit<- coxph(Surv(age1,survt_hhd+age1,hhd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_hhd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hhd3<- out[1,]
out_hhd3
results_hhd<-rbind(results_hhd,out_hhd3)  

fit<- coxph(Surv(age1,survt_hhd+age1,hhd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_hhd>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_hhd4<- out[1,]
out_hhd4
results_hhd<-rbind(results_hhd,out_hhd4) 
results_hhd


########PHEWAS- PPI and Diarrheal diseases-----------
results_diarr<-c()  
fit<- coxph(Surv(age1,survt_diarr+age1,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_diarr>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diarr1<- out[1,]
out_diarr1
results_diarr<-rbind(results_diarr,out_diarr1)  

fit<- coxph(Surv(age1,survt_diarr+age1,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_diarr>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diarr2<- out[1,]
out_diarr2
results_diarr<-rbind(results_diarr,out_diarr2)  

fit<- coxph(Surv(age1,survt_diarr+age1,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_diarr>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diarr3<- out[1,]
out_diarr3
results_diarr<-rbind(results_diarr,out_diarr3)  

fit<- coxph(Surv(age1,survt_diarr+age1,diarr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_diarr>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_diarr4<- out[1,]
out_diarr4
results_diarr<-rbind(results_diarr,out_diarr4) 
results_diarr

########PHEWAS- PPI and Low back pain-----------
pain<-read.csv("E:/biobank/usedata/pain.csv",header=TRUE, sep=",")
data_phe<-merge(data_phe,pain,by="n_eid")

results_lbpain<-c()  
fit<- coxph(Surv(age1,survt_lbpain+age1,lbpain_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_lbpain>=2&data_phe$NASIDS1=="No"
                          &data_phe$ASP==0&data_phe$pain_3==0&data_phe$pain_bo==0
                          &data_phe$illness_L=="No"
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0
                          &data_phe$M54_b==0&data_phe$bca==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lbpain1<- out[1,]
out_lbpain1
results_lbpain<-rbind(results_lbpain,out_lbpain1)  

##data1<-data_phe[!(data_phe$PPI_S0=="Yes"&data_phe$NASIDS==1),]


fit<- coxph(Surv(age1,survt_lbpain+age1,lbpain_case)~PPI_S0
            +strata(agecat)+strata(gender)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R
            +salt+sleep_tc+vitamin+mineral
            +statin,
            data=data_phe[data_phe$survt_lbpain>=2&data_phe$NASIDS1=="No"
                          &data_phe$ASP==0&data_phe$pain_3==0&data_phe$pain_bo==0
                          &data_phe$illness_L=="No"
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0
                          &data_phe$M54_b==0&data_phe$bca==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lbpain2<- out[1,]
out_lbpain2
results_lbpain<-rbind(results_lbpain,out_lbpain2)  
summary(fit)

fit<- coxph(Surv(age1,survt_lbpain+age1,lbpain_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_lbpain>=2&data_phe$NASIDS1=="No"
                          &data_phe$ASP==0&data_phe$pain_3==0&data_phe$pain_bo==0
                          &data_phe$illness_L=="No"
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0
                          &data_phe$M54_b==0&data_phe$bca==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lbpain3<- out[1,]
out_lbpain3
results_lbpain<-rbind(results_lbpain,out_lbpain3)  

fit<- coxph(Surv(age1,survt_lbpain+age1,lbpain_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_lbpain>=2&data_phe$NASIDS1=="No"
                          &data_phe$ASP==0&data_phe$pain_3==0&data_phe$pain_bo==0
                          &data_phe$illness_L=="No"
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0
                          &data_phe$M54_b==0&data_phe$bca==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_lbpain4<- out[1,]
out_lbpain4
results_lbpain<-rbind(results_lbpain,out_lbpain4) 
results_lbpain

########PHEWAS- PPI and Colon and rectum cancer-----------
results_crc<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,crc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_crc1<- out[1,]
out_crc1
results_crc<-rbind(results_crc,out_crc1)  

fit<- coxph(Surv(age1,survtime_can+age1,crc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_crc2<- out[1,]
out_crc2
results_crc<-rbind(results_crc,out_crc2)  

fit<- coxph(Surv(age1,survtime_can+age1,crc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_crc3<- out[1,]
out_crc3
results_crc<-rbind(results_crc,out_crc3)  

fit<- coxph(Surv(age1,survtime_can+age1,crc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_crc4<- out[1,]
out_crc4
results_crc<-rbind(results_crc,out_crc4) 
results_crc

########PHEWAS- PPI and Blindness and vision loss-----------
results_visl<-c()  
fit<- coxph(Surv(age1,survt_visl+age1,visl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_visl>=2
                          &data_phe$H53_b==0&data_phe$H54_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_visl1<- out[1,]
out_visl1
results_visl<-rbind(results_visl,out_visl1)  

fit<- coxph(Surv(age1,survt_visl+age1,visl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_visl>=2
                          &data_phe$H53_b==0&data_phe$H54_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_visl2<- out[1,]
out_visl2
results_visl<-rbind(results_visl,out_visl2)  

fit<- coxph(Surv(age1,survt_visl+age1,visl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_visl>=2
                          &data_phe$H53_b==0&data_phe$H54_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_visl3<- out[1,]
out_visl3
results_visl<-rbind(results_visl,out_visl3)  

fit<- coxph(Surv(age1,survt_visl+age1,visl_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_visl>=2
                          &data_phe$H53_b==0&data_phe$H54_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_visl4<- out[1,]
out_visl4
results_visl<-rbind(results_visl,out_visl4) 
results_visl

########PHEWAS- PPI and Atrial fibrillation and flutter-----------
results_af<-c()  
fit<- coxph(Surv(age1,survt_af+age1,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_af>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_af1<- out[1,]
out_af1
results_af<-rbind(results_af,out_af1)  

fit<- coxph(Surv(age1,survt_af+age1,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_af>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_af2<- out[1,]
out_af2
results_af<-rbind(results_af,out_af2)  

fit<- coxph(Surv(age1,survt_af+age1,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_af>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_af3<- out[1,]
out_af3
results_af<-rbind(results_af,out_af3)  

fit<- coxph(Surv(age1,survt_af+age1,af_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_af>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_af4<- out[1,]
out_af4
results_af<-rbind(results_af,out_af4) 
results_af

########PHEWAS- PPI and Stomach cancer-----------
results_stom<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,stom_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stom1<- out[1,]
out_stom1
results_stom<-rbind(results_stom,out_stom1)  

fit<- coxph(Surv(age1,survtime_can+age1,stom_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stom2<- out[1,]
out_stom2
results_stom<-rbind(results_stom,out_stom2)  

fit<- coxph(Surv(age1,survtime_can+age1,stom_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stom3<- out[1,]
out_stom3
results_stom<-rbind(results_stom,out_stom3)  

fit<- coxph(Surv(age1,survtime_can+age1,stom_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_stom4<- out[1,]
out_stom4
results_stom<-rbind(results_stom,out_stom4) 
results_stom

########PHEWAS- PPI and Prostate cancer-----------
results_pros<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,pros_can)~PPI_S0
            +strata(agecat)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Male",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_pros1<- out[1,]
out_pros1
results_pros<-rbind(results_pros,out_pros1)  

fit<- coxph(Surv(age1,survtime_can+age1,pros_can)~PPI_S0
            +strata(agecat)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Male",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_pros2<- out[1,]
out_pros2
results_pros<-rbind(results_pros,out_pros2)  

fit<- coxph(Surv(age1,survtime_can+age1,pros_can)~PPI_S0
            +strata(agecat)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Male",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_pros3<- out[1,]
out_pros3
results_pros<-rbind(results_pros,out_pros3)  

fit<- coxph(Surv(age1,survtime_can+age1,pros_can)~PPI_S0
            +strata(agecat)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Male",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_pros4<- out[1,]
out_pros4
results_pros<-rbind(results_pros,out_pros4) 
results_pros


########PHEWAS- PPI and Cirrhosis and other chronic liver diseases-----------
results_cirr<-c()  
fit<- coxph(Surv(age1,survt_cirr+age1,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_cirr>=2
                          &data_phe$B18_b==0 & 	data_phe$I85_b==0 & 	data_phe$I98_b==0 
                          & 	data_phe$K70_b==0 & 	data_phe$K71_b==0 & 	data_phe$K72_b==0 
                          & 	data_phe$K73_b==0 & 	data_phe$K74_b==0 & 	data_phe$K75_b==0 
                          & 	data_phe$K76_b==0 & 	data_phe$K77_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cirr1<- out[1,]
out_cirr1
results_cirr<-rbind(results_cirr,out_cirr1)  

fit<- coxph(Surv(age1,survt_cirr+age1,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_cirr>=2
                          &data_phe$B18_b==0 & 	data_phe$I85_b==0 & 	data_phe$I98_b==0 
                          & 	data_phe$K70_b==0 & 	data_phe$K71_b==0 & 	data_phe$K72_b==0 
                          & 	data_phe$K73_b==0 & 	data_phe$K74_b==0 & 	data_phe$K75_b==0 
                          & 	data_phe$K76_b==0 & 	data_phe$K77_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cirr2<- out[1,]
out_cirr2
results_cirr<-rbind(results_cirr,out_cirr2)  

fit<- coxph(Surv(age1,survt_cirr+age1,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_cirr>=2
                          &data_phe$B18_b==0 & 	data_phe$I85_b==0 & 	data_phe$I98_b==0 
                          & 	data_phe$K70_b==0 & 	data_phe$K71_b==0 & 	data_phe$K72_b==0 
                          & 	data_phe$K73_b==0 & 	data_phe$K74_b==0 & 	data_phe$K75_b==0 
                          & 	data_phe$K76_b==0 & 	data_phe$K77_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cirr3<- out[1,]
out_cirr3
results_cirr<-rbind(results_cirr,out_cirr3)  

fit<- coxph(Surv(age1,survt_cirr+age1,cirr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_cirr>=2
                          &data_phe$B18_b==0 & 	data_phe$I85_b==0 & 	data_phe$I98_b==0 
                          & 	data_phe$K70_b==0 & 	data_phe$K71_b==0 & 	data_phe$K72_b==0 
                          & 	data_phe$K73_b==0 & 	data_phe$K74_b==0 & 	data_phe$K75_b==0 
                          & 	data_phe$K76_b==0 & 	data_phe$K77_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cirr4<- out[1,]
out_cirr4
results_cirr<-rbind(results_cirr,out_cirr4) 
results_cirr


########PHEWAS- PPI and Parkinson's disease-----------
results_parkd<-c()  
fit<- coxph(Surv(age1,survt_parkd+age1,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_parkd>=2
                          &data_phe$F02_b==0&data_phe$G20_b==0
                          &data_phe$G21_b==0
                          &data_phe$G22_b==0&data_phe$G23_b==0
                          &data_phe$G24_b==0&data_phe$G25_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_parkd1<- out[1,]
out_parkd1
results_parkd<-rbind(results_parkd,out_parkd1)  

fit<- coxph(Surv(age1,survt_parkd+age1,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_parkd>=2
                          &data_phe$F02_b==0&data_phe$G20_b==0
                          &data_phe$G21_b==0
                          &data_phe$G22_b==0&data_phe$G23_b==0
                          &data_phe$G24_b==0&data_phe$G25_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_parkd2<- out[1,]
out_parkd2
results_parkd<-rbind(results_parkd,out_parkd2)  

fit<- coxph(Surv(age1,survt_parkd+age1,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_parkd>=2
                          &data_phe$F02_b==0&data_phe$G20_b==0
                          &data_phe$G21_b==0
                          &data_phe$G22_b==0&data_phe$G23_b==0
                          &data_phe$G24_b==0&data_phe$G25_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_parkd3<- out[1,]
out_parkd3
results_parkd<-rbind(results_parkd,out_parkd3)  

fit<- coxph(Surv(age1,survt_parkd+age1,parkd_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_parkd>=2
                          &data_phe$F02_b==0&data_phe$G20_b==0
                          &data_phe$G21_b==0
                          &data_phe$G22_b==0&data_phe$G23_b==0
                          &data_phe$G24_b==0&data_phe$G25_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_parkd4<- out[1,]
out_parkd4
results_parkd<-rbind(results_parkd,out_parkd4) 
results_parkd

########PHEWAS- PPI and Osteoarthritis-----------
results_oste<-c()  
fit<- coxph(Surv(age1,survt_oste+age1,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_oste>=2
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_oste1<- out[1,]
out_oste1
results_oste<-rbind(results_oste,out_oste1)  


dep17<-read.csv("D:/dep17.csv",header=TRUE, sep=",")

dep17$dis_mob<-ifelse(dep17$n_6146_0_0 %in% c("Attendance allowance","Blue badge","Disability living allowance"),1,0)
dep17$pace<-ifelse(dep17$n_924_0_0 %in% c("Brisk pace","Slow pace"),ifelse(dep17$n_924_0_0=="Brisk pace",2,1),0)
dep17$eop<-ifelse(dep17$n_6142_0_0=="Unable to work because of sickness or disability",1,0)
dep17$iia<-ifelse(dep17$n_6145_0_0=="Serious illness, injury or assault to yourself",1,0) 
table(dep17$iia)
data_phe<-merge(data_phe,dep17[c("n_eid","dis_mob","pace","eop","iia")],by="n_eid")
fit<- coxph(Surv(age1,survt_oste+age1,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_oste>=2
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0
                          &data_phe$M00_b==0&data_phe$M01_b==0
                          &data_phe$M02_b==0&data_phe$M03_b==0
                          &data_phe$M05_b==0&data_phe$M06_b==0
                          &data_phe$M07_b==0&data_phe$M08_b==0
                          &data_phe$M09_b==0&data_phe$M10_b==0
                          &data_phe$M11_b==0&data_phe$M12_b==0
                          &data_phe$M13_b==0&data_phe$M14_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_oste2<- out[1,]
out_oste2
results_oste<-rbind(results_oste,out_oste2)  

fit<- coxph(Surv(age1,survt_oste+age1,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_oste>=2
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0
                          &data_phe$M00_b==0&data_phe$M01_b==0
                          &data_phe$M02_b==0&data_phe$M03_b==0
                          &data_phe$M05_b==0&data_phe$M06_b==0
                          &data_phe$M07_b==0&data_phe$M08_b==0
                          &data_phe$M09_b==0&data_phe$M10_b==0
                          &data_phe$M11_b==0&data_phe$M12_b==0
                          &data_phe$M13_b==0&data_phe$M14_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_oste3<- out[1,]
out_oste3
results_oste<-rbind(results_oste,out_oste3)  

fit<- coxph(Surv(age1,survt_oste+age1,oste_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_oste>=2
                          &data_phe$M15_b==0&data_phe$M16_b==0
                          &data_phe$M17_b==0&data_phe$M18_b==0
                          &data_phe$M19_b==0&data_phe$M47_b==0
                          &data_phe$M00_b==0&data_phe$M01_b==0
                          &data_phe$M02_b==0&data_phe$M03_b==0
                          &data_phe$M05_b==0&data_phe$M06_b==0
                          &data_phe$M07_b==0&data_phe$M08_b==0
                          &data_phe$M09_b==0&data_phe$M10_b==0
                          &data_phe$M11_b==0&data_phe$M12_b==0
                          &data_phe$M13_b==0&data_phe$M14_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_oste4<- out[1,]
out_oste4
results_oste<-rbind(results_oste,out_oste4) 
results_oste



########PHEWAS- PPI and Tuberculosis-----------
results_tube<-c()  
fit<- coxph(Surv(age1,survt_tube+age1,tube_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_tube>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_tube1<- out[1,]
out_tube1
results_tube<-rbind(results_tube,out_tube1)  

fit<- coxph(Surv(age1,survt_tube+age1,tube_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_tube>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_tube2<- out[1,]
out_tube2
results_tube<-rbind(results_tube,out_tube2)  

fit<- coxph(Surv(age1,survt_tube+age1,tube_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_tube>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_tube3<- out[1,]
out_tube3
results_tube<-rbind(results_tube,out_tube3)  

fit<- coxph(Surv(age1,survt_tube+age1,tube_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_tube>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_tube4<- out[1,]
out_tube4
results_tube<-rbind(results_tube,out_tube4) 
results_tube


########PHEWAS- PPI and asthma-----------
results_asth<-c()  
fit<- coxph(Surv(age1,survt_asth+age1,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_asth>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_asth1<- out[1,]
out_asth1
results_asth<-rbind(results_asth,out_asth1)  

fit<- coxph(Surv(age1,survt_asth+age1,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_asth>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_asth2<- out[1,]
out_asth2
results_asth<-rbind(results_asth,out_asth2)  

fit<- coxph(Surv(age1,survt_asth+age1,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_asth>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_asth3<- out[1,]
out_asth3
results_asth<-rbind(results_asth,out_asth3)  

fit<- coxph(Surv(age1,survt_asth+age1,asth_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_asth>=2
                          &data_phe$J40_b==0&data_phe$J41_b==0
                          &data_phe$J42_b==0&data_phe$J43_b==0
                          &data_phe$J44_b==0&data_phe$J45_b==0
                          &data_phe$J46_b==0&data_phe$J47_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_asth4<- out[1,]
out_asth4
results_asth<-rbind(results_asth,out_asth4) 
results_asth

########PHEWAS- PPI and Road injuries-----------
results_roadi<-c()  
fit<- coxph(Surv(age1,survt_roadi+age1,roadi_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_roadi>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_roadi1<- out[1,]
out_roadi1
results_roadi<-rbind(results_roadi,out_roadi1)  

fit<- coxph(Surv(age1,survt_roadi+age1,roadi_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_roadi>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_roadi2<- out[1,]
out_roadi2
results_roadi<-rbind(results_roadi,out_roadi2)  

fit<- coxph(Surv(age1,survt_roadi+age1,roadi_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_roadi>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_roadi3<- out[1,]
out_roadi3
results_roadi<-rbind(results_roadi,out_roadi3)  

fit<- coxph(Surv(age1,survt_roadi+age1,roadi_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_roadi>=2,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_roadi4<- out[1,]
out_roadi4
results_roadi<-rbind(results_roadi,out_roadi4) 
results_roadi

########PHEWAS- PPI and Pancreatic cancer-----------
results_panc<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,panc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_panc1<- out[1,]
out_panc1
results_panc<-rbind(results_panc,out_panc1)  

fit<- coxph(Surv(age1,survtime_can+age1,panc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_panc2<- out[1,]
out_panc2
results_panc<-rbind(results_panc,out_panc2)  

fit<- coxph(Surv(age1,survtime_can+age1,panc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_panc3<- out[1,]
out_panc3
results_panc<-rbind(results_panc,out_panc3)  

fit<- coxph(Surv(age1,survtime_can+age1,panc_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_panc4<- out[1,]
out_panc4
results_panc<-rbind(results_panc,out_panc4) 
results_panc

########PHEWAS- PPI and Depressive disorders-----------
results_depr<-c()  
fit<- coxph(Surv(age1,survt_depr+age1,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_depr>=2
                          &data_phe$F20_b==0&data_phe$F21_b==0
                          &data_phe$F22_b==0&data_phe$F23_b==0
                          &data_phe$F24_b==0&data_phe$F25_b==0
                          &data_phe$F28_b==0&data_phe$F29_b==0
                          &data_phe$F30_b==0&data_phe$F31_b==0
                          &data_phe$F32_b==0&data_phe$F33_b==0
                          &data_phe$F34_b==0&data_phe$F38_b==0
                          &data_phe$F39_b==0&data_phe$F40_b==0
                          &data_phe$F41_b==0&data_phe$F42_b==0
                          &data_phe$F43_b==0&data_phe$F44_b==0
                          &data_phe$F45_b==0&data_phe$F48_b==0
                          &data_phe$F55_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_depr1<- out[1,]
out_depr1
results_depr<-rbind(results_depr,out_depr1)  

fit<- coxph(Surv(age1,survt_depr+age1,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_depr>=2
                          &data_phe$F20_b==0&data_phe$F21_b==0
                          &data_phe$F22_b==0&data_phe$F23_b==0
                          &data_phe$F24_b==0&data_phe$F25_b==0
                          &data_phe$F28_b==0&data_phe$F29_b==0
                          &data_phe$F30_b==0&data_phe$F31_b==0
                          &data_phe$F32_b==0&data_phe$F33_b==0
                          &data_phe$F34_b==0&data_phe$F38_b==0
                          &data_phe$F39_b==0&data_phe$F40_b==0
                          &data_phe$F41_b==0&data_phe$F42_b==0
                          &data_phe$F43_b==0&data_phe$F44_b==0
                          &data_phe$F45_b==0&data_phe$F48_b==0
                          &data_phe$F55_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_depr2<- out[1,]
out_depr2
results_depr<-rbind(results_depr,out_depr2)  

fit<- coxph(Surv(age1,survt_depr+age1,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_depr>=2
                          &data_phe$F20_b==0&data_phe$F21_b==0
                          &data_phe$F22_b==0&data_phe$F23_b==0
                          &data_phe$F24_b==0&data_phe$F25_b==0
                          &data_phe$F28_b==0&data_phe$F29_b==0
                          &data_phe$F30_b==0&data_phe$F31_b==0
                          &data_phe$F32_b==0&data_phe$F33_b==0
                          &data_phe$F34_b==0&data_phe$F38_b==0
                          &data_phe$F39_b==0&data_phe$F40_b==0
                          &data_phe$F41_b==0&data_phe$F42_b==0
                          &data_phe$F43_b==0&data_phe$F44_b==0
                          &data_phe$F45_b==0&data_phe$F48_b==0
                          &data_phe$F55_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_depr3<- out[1,]
out_depr3
results_depr<-rbind(results_depr,out_depr3)  

fit<- coxph(Surv(age1,survt_depr+age1,depr_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_depr>=2
                          &data_phe$F20_b==0&data_phe$F21_b==0
                          &data_phe$F22_b==0&data_phe$F23_b==0
                          &data_phe$F24_b==0&data_phe$F25_b==0
                          &data_phe$F28_b==0&data_phe$F29_b==0
                          &data_phe$F30_b==0&data_phe$F31_b==0
                          &data_phe$F32_b==0&data_phe$F33_b==0
                          &data_phe$F34_b==0&data_phe$F38_b==0
                          &data_phe$F39_b==0&data_phe$F40_b==0
                          &data_phe$F41_b==0&data_phe$F42_b==0
                          &data_phe$F43_b==0&data_phe$F44_b==0
                          &data_phe$F45_b==0&data_phe$F48_b==0
                          &data_phe$F55_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_depr4<- out[1,]
out_depr4
results_depr<-rbind(results_depr,out_depr4) 
results_depr

########PHEWAS- PPI and Breast cancer-----------
results_brea<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,brea_can)~PPI_S0
            +strata(agecat)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Female",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_brea1<- out[1,]
out_brea1
results_brea<-rbind(results_brea,out_brea1)  

fit<- coxph(Surv(age1,survtime_can+age1,brea_can)~PPI_S0
            +strata(agecat)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +juejin+HRT+ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Female",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_brea2<- out[1,]
out_brea2
results_brea<-rbind(results_brea,out_brea2)  

fit<- coxph(Surv(age1,survtime_can+age1,brea_can)~PPI_S0
            +strata(agecat)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +juejin+HRT+ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Female",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_brea3<- out[1,]
out_brea3
results_brea<-rbind(results_brea,out_brea3)  

fit<- coxph(Surv(age1,survtime_can+age1,brea_can)~PPI_S0
            +strata(agecat)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +juejin+HRT+ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0&data_phe$gender=="Female",])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_brea4<- out[1,]
out_brea4
results_brea<-rbind(results_brea,out_brea4) 
results_brea

########PHEWAS- PPI and Esophageal cancer-----------
results_esop<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_esop1<- out[1,]
out_esop1
results_esop<-rbind(results_esop,out_esop1)  

fit<- coxph(Surv(age1,survtime_can+age1,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0
                          &data_phe$K00_b==0&data_phe$K01_b==0
                          &data_phe$K02_b==0&data_phe$K03_b==0
                          &data_phe$K04_b==0&data_phe$K05_b==0
                          &data_phe$K06_b==0&data_phe$K07_b==0
                          &data_phe$K08_b==0&data_phe$K09_b==0
                          &data_phe$K10_b==0&data_phe$K11_b==0
                          &data_phe$K12_b==0&data_phe$K13_b==0
                          &data_phe$K14_b==0&data_phe$K20_b==0
                          &data_phe$K21_b==0&data_phe$K22_b==0
                          &data_phe$K23_b==0&data_phe$K25_b==0
                          &data_phe$K26_b==0&data_phe$K27_b==0
                          &data_phe$K28_b==0&data_phe$K29_b==0
                          &data_phe$K30_b==0&data_phe$K31_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_esop2<- out[1,]
out_esop2
results_esop<-rbind(results_esop,out_esop2)  

fit<- coxph(Surv(age1,survtime_can+age1,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_esop3<- out[1,]
out_esop3
results_esop<-rbind(results_esop,out_esop3)  

fit<- coxph(Surv(age1,survtime_can+age1,esop_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_esop4<- out[1,]
out_esop4
results_esop<-rbind(results_esop,out_esop4) 
results_esop

########PHEWAS- PPI and Liver cancer-----------
results_live<-c()  
fit<- coxph(Surv(age1,survtime_can+age1,live_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_live1<- out[1,]
out_live1
results_live<-rbind(results_live,out_live1)  

fit<- coxph(Surv(age1,survtime_can+age1,live_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_live2<- out[1,]
out_live2
results_live<-rbind(results_live,out_live2)  

fit<- coxph(Surv(age1,survtime_can+age1,live_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_live3<- out[1,]
out_live3
results_live<-rbind(results_live,out_live3)  

fit<- coxph(Surv(age1,survtime_can+age1,live_can)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survtime_can>=2
                          &data_phe$cancer_base==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_live4<- out[1,]
out_live4
results_live<-rbind(results_live,out_live4) 
results_live

########PHEWAS- PPI and Cardiomyopathy and myocarditis-----------
results_cardio<-c()  
fit<- coxph(Surv(age1,survt_cardio+age1,cardio_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre),
            data=data_phe[data_phe$survt_cardio>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cardio1<- out[1,]
out_cardio1
results_cardio<-rbind(results_cardio,out_cardio1)  

fit<- coxph(Surv(age1,survt_cardio+age1,cardio_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin,
            data=data_phe[data_phe$survt_cardio>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cardio2<- out[1,]
out_cardio2
results_cardio<-rbind(results_cardio,out_cardio2)  

fit<- coxph(Surv(age1,survt_cardio+age1,cardio_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+HBP+chol_h+diabete_b,
            data=data_phe[data_phe$survt_cardio>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cardio3<- out[1,]
out_cardio3
results_cardio<-rbind(results_cardio,out_cardio3)  

fit<- coxph(Surv(age1,survt_cardio+age1,cardio_case)~PPI_S0
            +strata(agecat)+strata(gender)+strata(centre)
            +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
            +index+Health_R+illness_L
            +salt+sleep_tc+vitamin+mineral
            +ASP+NASIDS+statin+ACEI+ARBs+beteb+Cach+liniao,
            data=data_phe[data_phe$survt_cardio>=2
                          &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                          & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                          & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                          & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                          & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                          & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
HR <- round(exp(coef(fit)), 2)
CI <- round(exp(confint(fit)), 2)
P <- round(coef(summary(fit))[,5], 100)
colnames(CI) <- c("Lower", "Higher")
out<- as.data.frame(cbind(HR, CI, P))
out_cardio4<- out[1,]
out_cardio4
results_cardio<-rbind(results_cardio,out_cardio4) 
results_cardio
results_main<-rbind(results_chd,  results_stroke,   results_copd,  results_alz, results_diab, 
                    results_lres,   results_lung,   results_fall,  results_ckd,   results_hearl, 
                    results_hhd,  results_diarr,   results_lbpain,   results_crc, results_visl, results_af, 
                    results_stom,  results_pros,  results_cirr,  results_parkd, results_oste,   
                    results_tube,  results_asth,   results_roadi,  results_panc,  results_depr, results_brea, 
                    results_esop,  results_live,  results_cardio)
results_main
write.table(results_main, file = "E:/PPI_lancet30/ppi_dis30.csv", sep = ",",  
            col.names = NA,qmethod = "double")

########for each type of PPI and lancet 30 diseases------------------
ppi_name<-c("ome0","lanso0","esome0","ppi_other")
results_eachppi<-c()
for (i in c(1:4))
{
  each_name<-ppi_name[i]
  run_code<-paste0("data_phe$",each_name)
  eval(parse(text = paste0('data_phe$var_ppi',' <- ',run_code)))
  fit<- coxph(Surv(age1,survt_isd+age1,isd_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_isd>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                            & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                            & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                            & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                            & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                            & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_chd2<- out[1,]
  out_chd2
  
  fit<- coxph(Surv(age1,survt_stroke+age1,stroke_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+stroke_hf+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_stroke>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                            & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                            & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                            & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                            & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                            & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_stroke2<- out[1,]
  out_stroke2
  
  fit<- coxph(Surv(age1,survt_copd+age1,copd_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_copd>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$J40_b==0&data_phe$J41_b==0
                            &data_phe$J42_b==0&data_phe$J43_b==0
                            &data_phe$J44_b==0&data_phe$J45_b==0
                            &data_phe$J46_b==0&data_phe$J47_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_copd2<- out[1,]
  out_copd2
  
  fit<- coxph(Surv(age1,survt_alz+age1,alz_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_alz>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$F00_b==0&data_phe$F01_b==0
                            &data_phe$F02_b==0&data_phe$F03_b==0
                            &data_phe$G30_b==0&data_phe$G31_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_alz2<- out[1,]
  out_alz2
  
  fit<- coxph(Surv(age1,survt_diab+age1,diab_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_diab>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$E10_b==0&data_phe$E11_b==0
                            &data_phe$E12_b==0&data_phe$E13_b==0
                            &data_phe$E14_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_diab2<- out[1,]
  out_diab2
  
  fit<- coxph(Surv(age1,survt_lres+age1,lres_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_lres>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$A48_b==0&data_phe$A70_b==0
                            &data_phe$B97_b==0&data_phe$J09_b==0
                            &data_phe$J10_b==0&data_phe$J11_b==0
                            &data_phe$J12_b==0&data_phe$J13_b==0
                            &data_phe$J14_b==0&data_phe$J15_b==0
                            &data_phe$J16_b==0&data_phe$J20_b==0
                            &data_phe$J21_b==0&data_phe$J91_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_lres2<- out[1,]
  out_lres2
  
  fit<- coxph(Surv(age1,survtime_can+age1,lung_can)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_lung2<- out[1,]
  out_lung2
  
  fit<- coxph(Surv(age1,survt_fall+age1,fall_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_fall>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes'),])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_fall2<- out[1,]
  out_fall2
  
  fit<- coxph(Surv(age1,survt_ckd+age1,ckd_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_ckd>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$D63_b==0&data_phe$E10_b==0
                            &data_phe$E11_b==0&data_phe$I12_b==0
                            &data_phe$I13_b==0&data_phe$N02_b==0
                            &data_phe$N03_b==0&data_phe$N04_b==0
                            &data_phe$N05_b==0&data_phe$N06_b==0
                            &data_phe$N07_b==0&data_phe$N08_b==0
                            &data_phe$N15_b==0&data_phe$N18_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_ckd2<- out[1,]
  out_ckd2
  
  fit<- coxph(Surv(age1,survt_hearl+age1,hearl_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_hearl>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$H91_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_hearl2<- out[1,]
  out_hearl2
  
  fit<- coxph(Surv(age1,survt_hhd+age1,hhd_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_hhd>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                            & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                            & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                            & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                            & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                            & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_hhd2<- out[1,]
  out_hhd2
  
  fit<- coxph(Surv(age1,survt_diarr+age1,diarr_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_diarr>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes'),])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_diarr2<- out[1,]
  out_diarr2
  ppi_name<-c("ome0","lanso0","esome0","ppi_other")
  fit<- coxph(Surv(age1,survt_lbpain+age1,lbpain_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_lbpain>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$NASIDS1=="No"
                            &data_phe$ASP==0&data_phe$pain_3==0&data_phe$pain_bo==0
                            &data_phe$illness_L=="No"
                            &data_phe$M15_b==0&data_phe$M16_b==0
                            &data_phe$M17_b==0&data_phe$M18_b==0
                            &data_phe$M19_b==0&data_phe$M47_b==0
                            &data_phe$M54_b==0&data_phe$bca==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_lbpain2<- out[1,]
  out_lbpain2
  
  fit<- coxph(Surv(age1,survtime_can+age1,crc_can)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_crc2<- out[1,]
  out_crc2
  
  fit<- coxph(Surv(age1,survt_visl+age1,visl_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_visl>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$H53_b==0&data_phe$H54_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_visl2<- out[1,]
  out_visl2
  
  fit<- coxph(Surv(age1,survt_af+age1,af_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_af>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                            & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                            & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                            & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                            & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                            & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_af2<- out[1,]
  out_af2
  
  fit<- coxph(Surv(age1,survtime_can+age1,stom_can)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_stom2<- out[1,]
  out_stom2
  
  fit<- coxph(Surv(age1,survtime_can+age1,pros_can)~var_ppi
              +strata(agecat)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0&data_phe$gender=="Male",])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_pros2<- out[1,]
  out_pros2
  
  fit<- coxph(Surv(age1,survt_cirr+age1,cirr_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_cirr>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$B18_b==0 & 	data_phe$I85_b==0 & 	data_phe$I98_b==0 
                            & 	data_phe$K70_b==0 & 	data_phe$K71_b==0 & 	data_phe$K72_b==0 
                            & 	data_phe$K73_b==0 & 	data_phe$K74_b==0 & 	data_phe$K75_b==0 
                            & 	data_phe$K76_b==0 & 	data_phe$K77_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_cirr2<- out[1,]
  out_cirr2
  
  fit<- coxph(Surv(age1,survt_parkd+age1,parkd_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_parkd>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$F02_b==0&data_phe$G20_b==0
                            &data_phe$G21_b==0
                            &data_phe$G22_b==0&data_phe$G23_b==0
                            &data_phe$G24_b==0&data_phe$G25_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_parkd2<- out[1,]
  out_parkd2
  
  fit<- coxph(Surv(age1,survt_oste+age1,oste_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_oste>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$M15_b==0&data_phe$M16_b==0
                            &data_phe$M17_b==0&data_phe$M18_b==0
                            &data_phe$M19_b==0&data_phe$M47_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_oste2<- out[1,]
  out_oste2
  
  fit<- coxph(Surv(age1,survt_tube+age1,tube_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+chrbr_hf+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_tube>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes'),])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_tube2<- out[1,]
  out_tube2
  
  fit<- coxph(Surv(age1,survt_asth+age1,asth_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_asth>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$J40_b==0&data_phe$J41_b==0
                            &data_phe$J42_b==0&data_phe$J43_b==0
                            &data_phe$J44_b==0&data_phe$J45_b==0
                            &data_phe$J46_b==0&data_phe$J47_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_asth2<- out[1,]
  out_asth2
  
  fit<- coxph(Surv(age1,survt_roadi+age1,roadi_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_roadi>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes'),])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_roadi2<- out[1,]
  out_roadi2
  
  fit<- coxph(Surv(age1,survtime_can+age1,panc_can)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_panc2<- out[1,]
  out_panc2
  
  fit<- coxph(Surv(age1,survt_depr+age1,depr_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_depr>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$F20_b==0&data_phe$F21_b==0
                            &data_phe$F22_b==0&data_phe$F23_b==0
                            &data_phe$F24_b==0&data_phe$F25_b==0
                            &data_phe$F28_b==0&data_phe$F29_b==0
                            &data_phe$F30_b==0&data_phe$F31_b==0
                            &data_phe$F32_b==0&data_phe$F33_b==0
                            &data_phe$F34_b==0&data_phe$F38_b==0
                            &data_phe$F39_b==0&data_phe$F40_b==0
                            &data_phe$F41_b==0&data_phe$F42_b==0
                            &data_phe$F43_b==0&data_phe$F44_b==0
                            &data_phe$F45_b==0&data_phe$F48_b==0
                            &data_phe$F55_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_depr2<- out[1,]
  out_depr2
  
  fit<- coxph(Surv(age1,survtime_can+age1,brea_can)~var_ppi
              +strata(agecat)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +juejin+HRT+ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0&data_phe$gender=="Female",])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_brea2<- out[1,]
  out_brea2
  
  fit<- coxph(Surv(age1,survtime_can+age1,esop_can)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_esop2<- out[1,]
  out_esop2
  
  fit<- coxph(Surv(age1,survtime_can+age1,live_can)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$cancer_base==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_live2<- out[1,]
  out_live2
  
  fit<- coxph(Surv(age1,survt_cardio+age1,cardio_case)~var_ppi
              +strata(agecat)+strata(gender)+strata(centre)
              +eth+heartd_hf+bmic+smoking+drinking4+Phy_act+fruit_g
              +index+Health_R+illness_L
              +salt+sleep_tc+vitamin+mineral
              +ASP+NASIDS+statin,
              data=data_phe[data_phe$survt_cardio>=2&(data_phe$non_ppi=='No'|data_phe$var_ppi=='Yes')
                            &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                            & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                            & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                            & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                            & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                            & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,])
  HR <- round(exp(coef(fit)), 2)
  CI <- round(exp(confint(fit)), 2)
  P <- round(coef(summary(fit))[,5], 100)
  colnames(CI) <- c("Lower", "Higher")
  out<- as.data.frame(cbind(HR, CI, P))
  out_cardio2<- out[1,]
  out_cardio2
  
  results_eachppi<-rbind(results_eachppi,out_chd2,  out_stroke2,   out_copd2,  out_alz2, out_diab2, 
                         out_lres2,   out_lung2,   out_fall2,  out_ckd2,   out_hearl2, 
                         out_hhd2,  out_diarr2,   out_lbpain2,   out_crc2, out_visl2, out_af2, 
                         out_stom2,  out_pros2,  out_cirr2,  out_parkd2, out_oste2,   
                         out_tube2,  out_asth2,   out_roadi2,  out_panc2,  out_depr2, out_brea2, 
                         out_esop2,  out_live2,  out_cardio2)
  gc() }
results_eachppi

write.table(results_eachppi, file = "E:/PPI_lancet30/eachppi_dis.csv", sep = ",",  
            col.names = NA,qmethod = "double")




#########calculate personal years and case number-------------
year_ppi<-as.data.frame(c(1:4),)

########CHD
data1=data_phe[data_phe$survt_isd>=2
               &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
               & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
               & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
               & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
               & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
               & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
t1<-table(data1$PPI_S0,data1$isd_case)
t2<-aggregate(survt_isd~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########stroke
data1=data_phe[data_phe$survt_stroke>=2
               &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
               & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
               & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
               & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
               & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
               & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
t1<-table(data1$PPI_S0,data1$stroke_case)
t2<-aggregate(survt_stroke~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########COPD
data1=data_phe[data_phe$survt_copd>=2
               &data_phe$J40_b==0&data_phe$J41_b==0
               &data_phe$J42_b==0&data_phe$J43_b==0
               &data_phe$J44_b==0&data_phe$J45_b==0
               &data_phe$J46_b==0&data_phe$J47_b==0,]
t1<-table(data1$PPI_S0,data1$copd_case)
t2<-aggregate(survt_copd~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Alzheimer's disease and other dementias--
data1=data_phe[data_phe$survt_alz>=2
               &data_phe$F00_b==0&data_phe$F01_b==0
               &data_phe$F02_b==0&data_phe$F03_b==0
               &data_phe$G30_b==0&data_phe$G31_b==0,]
t1<-table(data1$PPI_S0,data1$alz_case)
t2<-aggregate(survt_alz~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Diabetes mellitus
data1=data_phe[data_phe$survt_diab>=2
               &data_phe$E10_b==0&data_phe$E11_b==0
               &data_phe$E12_b==0&data_phe$E13_b==0
               &data_phe$E14_b==0,]
t1<-table(data1$PPI_S0,data1$diab_case)
t2<-aggregate(survt_diab~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)


########Lower respiratory infections-
data1=data_phe[data_phe$survt_lres>=2
               &data_phe$A48_b==0&data_phe$A70_b==0
               &data_phe$B97_b==0&data_phe$J09_b==0
               &data_phe$J10_b==0&data_phe$J11_b==0
               &data_phe$J12_b==0&data_phe$J13_b==0
               &data_phe$J14_b==0&data_phe$J15_b==0
               &data_phe$J16_b==0&data_phe$J20_b==0
               &data_phe$J21_b==0&data_phe$J91_b==0,]
t1<-table(data1$PPI_S0,data1$lres_case)
t2<-aggregate(survt_lres~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########lung cancer
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0,]
t1<-table(data1$PPI_S0,data1$lung_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

#######falls
data1=data_phe[data_phe$survt_fall>=2,]
t1<-table(data1$PPI_S0,data1$fall_case)
t2<-aggregate(survt_fall~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########CKD
data1=data_phe[data_phe$survt_ckd>=2
               &data_phe$D63_b==0&data_phe$E10_b==0
               &data_phe$E11_b==0&data_phe$I12_b==0
               &data_phe$I13_b==0&data_phe$N02_b==0
               &data_phe$N03_b==0&data_phe$N04_b==0
               &data_phe$N05_b==0&data_phe$N06_b==0
               &data_phe$N07_b==0&data_phe$N08_b==0
               &data_phe$N15_b==0&data_phe$N18_b==0,]
t1<-table(data1$PPI_S0,data1$ckd_case)
t2<-aggregate(survt_ckd~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Age-related hearing loss
data1=data_phe[data_phe$survt_hearl>=2
               &data_phe$H91_b==0,]
t1<-table(data1$PPI_S0,data1$hearl_case)
t2<-aggregate(survt_hearl~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Hypertensive heart disease
data1=data_phe[data_phe$survt_hhd>=2
               &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
               & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
               & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
               & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
               & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
               & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
t1<-table(data1$PPI_S0,data1$hhd_case)
t2<-aggregate(survt_hhd~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Diarrheal diseases
data1=data_phe[data_phe$survt_diarr>=2,]
t1<-table(data1$PPI_S0,data1$diarr_case)
t2<-aggregate(survt_diarr~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Low back pain
data1=data_phe[data_phe$survt_lbpain>=2&data_phe$NASIDS1=="No"
               &data_phe$ASP==0&data_phe$pain_3==0&data_phe$pain_bo==0
               &data_phe$illness_L=="No"
               &data_phe$M15_b==0&data_phe$M16_b==0
               &data_phe$M17_b==0&data_phe$M18_b==0
               &data_phe$M19_b==0&data_phe$M47_b==0
               &data_phe$M54_b==0&data_phe$bca==0,]
t1<-table(data1$PPI_S0,data1$lbpain_case)
t2<-aggregate(survt_lbpain~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)


########CRC
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0,]
t1<-table(data1$PPI_S0,data1$crc_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)


########Blindness and vision loss
data1=data_phe[data_phe$survt_visl>=2
               &data_phe$H53_b==0&data_phe$H54_b==0,]
t1<-table(data1$PPI_S0,data1$visl_case)
t2<-aggregate(survt_visl~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)


########Atrial fibrillation and flutter
data1=data_phe[data_phe$survt_af>=2
               &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
               & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
               & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
               & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
               & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
               & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
t1<-table(data1$PPI_S0,data1$af_case)
t2<-aggregate(survt_af~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)



########stomach cancer
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0,]
t1<-table(data1$PPI_S0,data1$stom_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)


########Prostate cancer
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0&data_phe$gender=="Male",]
t1<-table(data1$PPI_S0,data1$pros_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)



########Cirrhosis and other chronic liver diseases
data1=data_phe[data_phe$survt_cirr>=2
               &data_phe$B18_b==0 & 	data_phe$I85_b==0 & 	data_phe$I98_b==0 
               & 	data_phe$K70_b==0 & 	data_phe$K71_b==0 & 	data_phe$K72_b==0 
               & 	data_phe$K73_b==0 & 	data_phe$K74_b==0 & 	data_phe$K75_b==0 
               & 	data_phe$K76_b==0 & 	data_phe$K77_b==0,]
t1<-table(data1$PPI_S0,data1$cirr_case)
t2<-aggregate(survt_cirr~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Parkinson's disease
data1=data_phe[data_phe$survt_parkd>=2
               &data_phe$F02_b==0&data_phe$G20_b==0,]
t1<-table(data1$PPI_S0,data1$parkd_case)
t2<-aggregate(survt_parkd~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Osteoarthritis
data1=data_phe[data_phe$survt_oste>=2
               &data_phe$M15_b==0&data_phe$M16_b==0
               &data_phe$M17_b==0&data_phe$M18_b==0
               &data_phe$M19_b==0&data_phe$M47_b==0
               &data_phe$M00_b==0&data_phe$M01_b==0
               &data_phe$M02_b==0&data_phe$M03_b==0
               &data_phe$M05_b==0&data_phe$M06_b==0
               &data_phe$M07_b==0&data_phe$M08_b==0
               &data_phe$M09_b==0&data_phe$M10_b==0
               &data_phe$M11_b==0&data_phe$M12_b==0
               &data_phe$M13_b==0&data_phe$M14_b==0,]
t1<-table(data1$PPI_S0,data1$oste_case)
t2<-aggregate(survt_oste~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Tuberculosis-
data1=data_phe[data_phe$survt_tube>=2,]
t1<-table(data1$PPI_S0,data1$tube_case)
t2<-aggregate(survt_tube~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########asthma
data1=data_phe[data_phe$survt_asth>=2
               &data_phe$J40_b==0&data_phe$J41_b==0
               &data_phe$J42_b==0&data_phe$J43_b==0
               &data_phe$J44_b==0&data_phe$J45_b==0
               &data_phe$J46_b==0&data_phe$J47_b==0,]
t1<-table(data1$PPI_S0,data1$asth_case)
t2<-aggregate(survt_asth~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Road injuries
data1=data_phe[data_phe$survt_roadi>=2,]
t1<-table(data1$PPI_S0,data1$roadi_case)
t2<-aggregate(survt_roadi~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

#######Pancreatic cancer
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0,]
t1<-table(data1$PPI_S0,data1$panc_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

########Depressive disorders
data1=data_phe[data_phe$survt_depr>=2
               &data_phe$F20_b==0&data_phe$F21_b==0
               &data_phe$F22_b==0&data_phe$F23_b==0
               &data_phe$F24_b==0&data_phe$F25_b==0
               &data_phe$F28_b==0&data_phe$F29_b==0
               &data_phe$F30_b==0&data_phe$F31_b==0
               &data_phe$F32_b==0&data_phe$F33_b==0
               &data_phe$F34_b==0&data_phe$F38_b==0
               &data_phe$F39_b==0&data_phe$F40_b==0
               &data_phe$F41_b==0&data_phe$F42_b==0
               &data_phe$F43_b==0&data_phe$F44_b==0
               &data_phe$F45_b==0&data_phe$F48_b==0
               &data_phe$F55_b==0,]
t1<-table(data1$PPI_S0,data1$depr_case)
t2<-aggregate(survt_depr~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)


#######Breast cancer
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0&data_phe$gender=="Female",]
t1<-table(data1$PPI_S0,data1$brea_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

######## Esophageal cancer
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0,]
t1<-table(data1$PPI_S0,data1$esop_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)


######## Liver cancer
data1=data_phe[data_phe$survtime_can>=2
               &data_phe$cancer_base==0,]
t1<-table(data1$PPI_S0,data1$live_can)
t2<-aggregate(survtime_can~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

####### Cardiomyopathy and myocarditis
data1=data_phe[data_phe$survt_cardio>=2
               & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
               & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
               & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
               & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
               & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
t1<-table(data1$PPI_S0,data1$cardio_case)
t2<-aggregate(survt_cardio~data1$PPI_S0,data1,sum)
years<- cbind(t1,t2)
year_ppi<-cbind(year_ppi,years)

write.table(year_ppi, file = "E:/PPI_lancet30/year_ppi.csv", sep = ",",  
            col.names = NA,qmethod = "double")
##person years-----------
years1<-read.csv("E:/PPI_lancet30/year_ppi.csv",header=TRUE, sep=",")
years2<-years1[-c(1:2),]
a<-colnames(years1)
b<-grep("Freq", a, value=TRUE)
c<-grep("surv", a, value=TRUE)
write.table(b, file = "E:/PPI_lancet30/b.csv", sep = ",",  
            col.names = NA,qmethod = "double")
write.table(c, file = "E:/PPI_lancet30/c.csv", sep = ",",  
            col.names = NA,qmethod = "double")

years2<-years2[c("Freq",	"survt_isd","Freq.1",	"survt_stroke","Freq.2",	"survt_copd","Freq.3",	"survt_alz",
                 "Freq.4",	"survt_diab","Freq.5",	"survt_lres","Freq.6",	"survtime_can","Freq.7",	"survt_fall",
                 "Freq.8",	"survt_ckd","Freq.9",	"survt_hearl","Freq.10",	"survt_hhd","Freq.11",	"survt_diarr",
                 "Freq.12",	"survt_lbpain","Freq.13",	"survtime_can.1","Freq.14",	"survt_visl","Freq.15",	"survt_af",
                 "Freq.16",	"survtime_can.2","Freq.17",	"survtime_can.3","Freq.18",	"survt_cirr","Freq.19",	"survt_parkd",
                 "Freq.20",	"survt_oste","Freq.21",	"survt_tube","Freq.22",	"survt_asth","Freq.23",	"survt_roadi",
                 "Freq.24",	"survtime_can.4","Freq.25",	"survt_depr","Freq.26",	"survtime_can.5","Freq.27",	"survtime_can.6",
                 "Freq.28",	"survtime_can.7","Freq.29",	"survt_cardio")]

write.table(years2, file = "E:/PPI_lancet30/year_ppi.csv", sep = ",",  
            col.names = NA,qmethod = "double")


#######calculate years for each ppi use--------------

year_eachppi<-as.data.frame(c(1:4),)

ppi_name<-c("ome0","lanso0","esome0","ppi_other")  
for (i in c(1:length(ppi_name))) {
  ppi_type <- ppi_name[i]
  var<-which(colnames(data_phe)==ppi_type)
  data_phe$ppi_type<-data_phe[,var]    
  ########CHD
  data1=data_phe[data_phe$survt_isd>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                 & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                 & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                 & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                 & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                 & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
  t1<-table(data1$ppi_type,data1$isd_case)
  t2<-aggregate(survt_isd~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########stroke
  data1=data_phe[data_phe$survt_stroke>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                 & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                 & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                 & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                 & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                 & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
  t1<-table(data1$ppi_type,data1$stroke_case)
  t2<-aggregate(survt_stroke~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########COPD
  data1=data_phe[data_phe$survt_copd>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$J40_b==0&data_phe$J41_b==0
                 &data_phe$J42_b==0&data_phe$J43_b==0
                 &data_phe$J44_b==0&data_phe$J45_b==0
                 &data_phe$J46_b==0&data_phe$J47_b==0,]
  t1<-table(data1$ppi_type,data1$copd_case)
  t2<-aggregate(survt_copd~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Alzheimer's disease and other dementias--
  data1=data_phe[data_phe$survt_alz>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$F00_b==0&data_phe$F01_b==0
                 &data_phe$F02_b==0&data_phe$F03_b==0
                 &data_phe$G30_b==0&data_phe$G31_b==0,]
  t1<-table(data1$ppi_type,data1$alz_case)
  t2<-aggregate(survt_alz~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Diabetes mellitus
  data1=data_phe[data_phe$survt_diab>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$E10_b==0&data_phe$E11_b==0
                 &data_phe$E12_b==0&data_phe$E13_b==0
                 &data_phe$E14_b==0,]
  t1<-table(data1$ppi_type,data1$diab_case)
  t2<-aggregate(survt_diab~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  ########Lower respiratory infections-
  data1=data_phe[data_phe$survt_lres>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$A48_b==0&data_phe$A70_b==0
                 &data_phe$B97_b==0&data_phe$J09_b==0
                 &data_phe$J10_b==0&data_phe$J11_b==0
                 &data_phe$J12_b==0&data_phe$J13_b==0
                 &data_phe$J14_b==0&data_phe$J15_b==0
                 &data_phe$J16_b==0&data_phe$J20_b==0
                 &data_phe$J21_b==0&data_phe$J91_b==0,]
  t1<-table(data1$ppi_type,data1$lres_case)
  t2<-aggregate(survt_lres~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########lung cancer
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0,]
  t1<-table(data1$ppi_type,data1$lung_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  #######falls
  data1=data_phe[data_phe$survt_fall>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes'),]
  t1<-table(data1$ppi_type,data1$fall_case)
  t2<-aggregate(survt_fall~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########CKD
  data1=data_phe[data_phe$survt_ckd>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$D63_b==0&data_phe$E10_b==0
                 &data_phe$E11_b==0&data_phe$I12_b==0
                 &data_phe$I13_b==0&data_phe$N02_b==0
                 &data_phe$N03_b==0&data_phe$N04_b==0
                 &data_phe$N05_b==0&data_phe$N06_b==0
                 &data_phe$N07_b==0&data_phe$N08_b==0
                 &data_phe$N15_b==0&data_phe$N18_b==0,]
  t1<-table(data1$ppi_type,data1$ckd_case)
  t2<-aggregate(survt_ckd~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Age-related hearing loss
  data1=data_phe[data_phe$survt_hearl>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$H91_b==0,]
  t1<-table(data1$ppi_type,data1$hearl_case)
  t2<-aggregate(survt_hearl~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Hypertensive heart disease
  data1=data_phe[data_phe$survt_hhd>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                 & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                 & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                 & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                 & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                 & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
  t1<-table(data1$ppi_type,data1$hhd_case)
  t2<-aggregate(survt_hhd~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Diarrheal diseases
  data1=data_phe[data_phe$survt_diarr>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes'),]
  t1<-table(data1$ppi_type,data1$diarr_case)
  t2<-aggregate(survt_diarr~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Low back pain
  data1=data_phe[data_phe$survt_lbpain>=2&data_phe$NASIDS1=="No"
                 &data_phe$ASP==0&data_phe$pain_3==0&data_phe$pain_bo==0
                 &data_phe$illness_L=="No"
                 &data_phe$M15_b==0&data_phe$M16_b==0
                 &data_phe$M17_b==0&data_phe$M18_b==0
                 &data_phe$M19_b==0&data_phe$M47_b==0
                 &data_phe$M54_b==0&data_phe$bca==0&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')&data_phe$M54_b==0,]
  t1<-table(data1$ppi_type,data1$lbpain_case)
  t2<-aggregate(survt_lbpain~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  ########CRC
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0,]
  t1<-table(data1$ppi_type,data1$crc_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  ########Blindness and vision loss
  data1=data_phe[data_phe$survt_visl>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$H53_b==0&data_phe$H54_b==0,]
  t1<-table(data1$ppi_type,data1$visl_case)
  t2<-aggregate(survt_visl~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  ########Atrial fibrillation and flutter
  data1=data_phe[data_phe$survt_af>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$I48_b==0 & 	data_phe$I20_b==0 & 	data_phe$I21_b==0 
                 & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                 & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                 & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                 & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                 & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
  t1<-table(data1$ppi_type,data1$af_case)
  t2<-aggregate(survt_af~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  
  ########stomach cancer
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0,]
  t1<-table(data1$ppi_type,data1$stom_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  ########Prostate cancer
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0&data_phe$gender=="Male",]
  t1<-table(data1$ppi_type,data1$pros_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  
  ########Cirrhosis and other chronic liver diseases
  data1=data_phe[data_phe$survt_cirr>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$B18_b==0 & 	data_phe$I85_b==0 & 	data_phe$I98_b==0 
                 & 	data_phe$K70_b==0 & 	data_phe$K71_b==0 & 	data_phe$K72_b==0 
                 & 	data_phe$K73_b==0 & 	data_phe$K74_b==0 & 	data_phe$K75_b==0 
                 & 	data_phe$K76_b==0 & 	data_phe$K77_b==0,]
  t1<-table(data1$ppi_type,data1$cirr_case)
  t2<-aggregate(survt_cirr~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Parkinson's disease
  data1=data_phe[data_phe$survt_parkd>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$F02_b==0&data_phe$G20_b==0,]
  t1<-table(data1$ppi_type,data1$parkd_case)
  t2<-aggregate(survt_parkd~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Osteoarthritis
  data1=data_phe[data_phe$survt_oste>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$M15_b==0&data_phe$M16_b==0
                 &data_phe$M17_b==0&data_phe$M18_b==0
                 &data_phe$M19_b==0&data_phe$M47_b==0,]
  t1<-table(data1$ppi_type,data1$oste_case)
  t2<-aggregate(survt_oste~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Tuberculosis-
  data1=data_phe[data_phe$survt_tube>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes'),]
  t1<-table(data1$ppi_type,data1$tube_case)
  t2<-aggregate(survt_tube~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########asthma
  data1=data_phe[data_phe$survt_asth>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$J40_b==0&data_phe$J41_b==0
                 &data_phe$J42_b==0&data_phe$J43_b==0
                 &data_phe$J44_b==0&data_phe$J45_b==0
                 &data_phe$J46_b==0&data_phe$J47_b==0,]
  t1<-table(data1$ppi_type,data1$asth_case)
  t2<-aggregate(survt_asth~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Road injuries
  data1=data_phe[data_phe$survt_roadi>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes'),]
  t1<-table(data1$ppi_type,data1$roadi_case)
  t2<-aggregate(survt_roadi~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  #######Pancreatic cancer
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0,]
  t1<-table(data1$ppi_type,data1$panc_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ########Depressive disorders
  data1=data_phe[data_phe$survt_depr>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$F20_b==0&data_phe$F21_b==0
                 &data_phe$F22_b==0&data_phe$F23_b==0
                 &data_phe$F24_b==0&data_phe$F25_b==0
                 &data_phe$F28_b==0&data_phe$F29_b==0
                 &data_phe$F30_b==0&data_phe$F31_b==0
                 &data_phe$F32_b==0&data_phe$F33_b==0
                 &data_phe$F34_b==0&data_phe$F38_b==0
                 &data_phe$F39_b==0&data_phe$F40_b==0
                 &data_phe$F41_b==0&data_phe$F42_b==0
                 &data_phe$F43_b==0&data_phe$F44_b==0
                 &data_phe$F45_b==0&data_phe$F48_b==0
                 &data_phe$F55_b==0,]
  t1<-table(data1$ppi_type,data1$depr_case)
  t2<-aggregate(survt_depr~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  #######Breast cancer
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0&data_phe$gender=="Female",]
  t1<-table(data1$ppi_type,data1$brea_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ######## Esophageal cancer
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0,]
  t1<-table(data1$ppi_type,data1$esop_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  
  ######## Liver cancer
  data1=data_phe[data_phe$survtime_can>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 &data_phe$cancer_base==0,]
  t1<-table(data1$ppi_type,data1$live_can)
  t2<-aggregate(survtime_can~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
  ####### Cardiomyopathy and myocarditis
  data1=data_phe[data_phe$survt_cardio>=2&(data_phe$non_ppi=='No'|data_phe$ppi_type=='Yes')
                 & 	data_phe$I22_b==0 & 	data_phe$I23_b==0 & 	data_phe$I24_b==0 
                 & 	data_phe$I25_b==0 & 	data_phe$G45_b==0 & 	data_phe$I60_b==0 
                 & 	data_phe$I61_b==0 & 	data_phe$I62_b==0 & 	data_phe$I63_b==0 
                 & 	data_phe$I64_b==0 & 	data_phe$I65_b==0 & 	data_phe$I66_b==0 
                 & 	data_phe$I67_b==0 & 	data_phe$I68_b==0 & 	data_phe$I69_b==0,]
  t1<-table(data1$ppi_type,data1$cardio_case)
  t2<-aggregate(survt_cardio~data1$ppi_type,data1,sum)
  years<- cbind(t1,t2)
  year_eachppi<-cbind(year_eachppi,years)
  
}
year_eachppi
write.table(year_eachppi, file = "E:/PPI_lancet30/year_eachppi.csv", sep = ",",  
            col.names = NA,qmethod = "double")

