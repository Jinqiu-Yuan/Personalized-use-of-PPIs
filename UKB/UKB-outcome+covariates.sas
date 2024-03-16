/*首先修改建立自己的逻辑库，把数据、format都放到逻辑库里面*/
libname ukb 'E:\biobank';
libname usedata 'E:\biobank\usedata';
option fmtsearch =(ukb);
proc format library=ukb;
  value mzjsf -1="Do not know" -2="Unable to walk" -3="Prefer not to answer";
  value mjjsf -1="Do not know" -3="Prefer not to answer";
  value mfksf 1="Slow pace" 2="Steady average pace" 3="Brisk pace" -7="None of the above"
	-3="Prefer not to answer";
  value mgksf 0="None" 1="1-5 times a day" 2="6-10 times a day" 3="11-15 times a day"
	4="16-20 times a day" 5="More than 20 times a day" -1="Do not know" -3="Prefer not to answer";
  value mjksf 1="Once in the last 4 weeks" 2="2-3 times in the last 4 weeks" 3="Once a week"
	4="2-3 times a week" 5="4-5 times a week" 6="Every day" -1="Do not know" -3="Prefer not to answer";
  value mkksf 1="Less than 15 minutes" 2="Between 15 and 30 minutes" 3="Between 30 minutes and 1 hour"
	4="Between 1 and 1.5 hours" 5="Between 1.5 and 2 hours" 6="Between 2 and 3 hours"
	7="Over 3 hours" -1="Do not know" -3="Prefer not to answer";
  value mvksf -10="Less than an hour a day" -1="Do not know" -3="Prefer not to answer";
  value malsf 1="Never/rarely" 2="Sometimes" 3="Often" 4="Most of the time" 5="Do not drive on the motorway"
	-1="Do not know" -3="Prefer not to answer";
  value mplsf 1="Yes" 0="No" -1="Do not know" -3="Prefer not to answer";
  value muqsf 1="Not at all" 2="Several days" 3="More than half the days" 4="Nearly every day"
	-1="Do not know" -3="Prefer not to answer";
  value mlwsf 1="Yes" 0="No" 99="I am completely deaf" -1="Do not know" -3="Prefer not to answer";
  value mcusf 1="Younger than average" 2="About average age" 3="Older than average"
	-1="Do not know" -3="Prefer not to answer";
  value meusf 1="Pattern 1" 2="Pattern 2" 3="Pattern 3" 4="Pattern 4" -1="Do not know"
	-3="Prefer not to answer";
  value mslsf 1="Yes" 0="No" -3="Prefer not to answer";
  value mxvsf 1="Yes" 0="No" -2="Not applicable" -1="Do not know" -3="Prefer not to answer";
  value mpwsf 11="Yes, now most or all of the time" 12="Yes, now a lot of the time"
	13="Yes, now some of the time" 14="Yes, but not now, but have in the past" 0="No, never"
	-1="Do not know" -3="Prefer not to answer";
  value mqwsf 11="Severely" 12="Moderately" 13="Slightly" 4="Not at all" -1="Do not know"
	-3="Prefer not to answer";
  value mrwsf 11="Yes, for more than 5 years" 12="Yes, for around 1-5 years" 13="Yes, for less than a year"
	0="No" -1="Do not know" -3="Prefer not to answer";
  value mjrsf 11="At least two days, but less than a week" 12="Less than a week"
	13="A week or more" -1="Do not know" -3="Prefer not to answer";
  value mkrsf 11="No problems" 12="Needed treatment or caused problems with work, relationships, finances, the law or other aspects of life"
	-1="Do not know" -3="Prefer not to answer";
  value mlisf 1="Yes" 2="Unsure" 0="No";
  value maisf 1="Bicycle" 2="Resting only" 6="Not performed - equipment failure"
	7="Not performed - other reason";
  value mbisf 1="Fully completed" 31="Participant wanted to stop early" 32="Participant reported chest-pain and/or other discomfort"
	33="Heart rate reached safety level" 34="Incomplete - other reason";
  value mmaa 1="True" 0="False";
  value mmrsf 1="Serious illness, injury or assault to yourself" 2="Serious illness, injury or assault of a close relative"
	3="Death of a close relative" 4="Death of a spouse or partner" 5="Marital separation/divorce"
	6="Financial difficulties" -7="None of the above" -3="Prefer not to answer";
  value mcwsf 1="Ankle" 2="Leg" 3="Hip" 4="Spine" 5="Wrist" 6="Arm" 7="Other bones"
	-1="Do not know" -3="Prefer not to answer";
  value mirsf 11="I was more active than usual" 12="I was more talkative than usual"
	13="I needed less sleep than usual" 14="I was more creative or had more ideas than usual"
	15="All of the above" -7="None of the above";
  value mrjsf 1="Car/motor vehicle" 2="Walk" 3="Public transport" 4="Cycle" -7="None of the above"
	-3="Prefer not to answer";
  value miksf 1="Walking for pleasure (not as a means of transport)" 2="Other exercises (eg: swimming, cycling, keep fit, bowling)"
	3="Strenuous sports" 4="Light DIY (eg: pruning, watering the lawn)" 5="Heavy DIY (eg: weeding, lawn mowing, carpentry, digging)"
	-7="None of the above" -3="Prefer not to answer";
  value mlysf 1="Serious illness, injury or assault to yourself" 2="Serious illness, injury or assault of a close relative"
	3="Death of a close relative" 4="Death of a spouse or partner" 5="Marital separation/divorce"
	6="Financial difficulties" -7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value mnxsf 1="Less than 30 mins" 2="30 mins to 1 hour" 3="1 to 2 hours" 4="2 to 4 hours"
	5="More than 4 hours" -1="Do not know" -3="Prefer not to answer";
  value mkya 0="No" 1="Yes" 9="Maybe";
  value mcsa 0="Direct entry" 6="Not performed - equipment failure" 7="Not performed - other reason";
  value mvaa -1="unknown" 0="no" 1="yes";
  value mhaa 1="Yes" 0="No";
  value mbzsf 1="Disk access problem" 99="Miscellaneous";
  value mhca 602="Unable to maintain recommended speed" 601="Feeling unwell/pain"
	600="Abandoned" 412="Unable to understand instructions" 100="Declined" 300="Reason not known"
	103="Feeling unwell" 405="Other health reason" 102="Lack of time" 400="Unable"
	430="Unsuitable clothing" 427="Chest pain" 101="Against participant wishes"
	201="Malfunction" 429="High heart rate" 200="Equipment failure" 428="High BP";
  value mica 431="Heart rate > safety level" 430="Unsuitable clothing" 400="Unable"
	100="Declined" 200="Equipment failure" 428="High BP" 102="Lack of time" 405="Other health reason"
	300="Reason not known" 101="Against participant wishes" 201="Malfunction";
  value mvca 1="Monday" 2="Tuesday" 3="Wednesday" 4="Thursday" 5="Friday" 6="Saturday"
	7="Sunday";
  value mnda 18="Scotland - Very Remote Rural" 17="Scotland - Remote Rural" 16="Scotland - Accessible Rural"
	11="Scotland - Large Urban Area" 1="England/Wales - Urban - sparse" 7="England/Wales - Village - less sparse"
	4="England/Wales - Hamlet and Isolated dwelling - sparse" 9="Postcode not linkable"
	3="England/Wales - Village - sparse" 8="England/Wales - Hamlet and Isolated Dwelling - less sparse"
	15="Scotland - Very Remote Small Town" 12="Scotland - Other Urban Area" 2="England/Wales - Town and Fringe - sparse"
	6="England/Wales - Town and Fringe - less sparse" 14="Scotland - Remote Small Town"
	5="England/Wales - Urban - less sparse" 13="Scotland - Accessible Small Town";
  value mwysf 1="Bipolar Type I (Mania)" 2="Bipolar Type II (Hypomania)";
  value mxysf 0="No Bipolar or Depression" 1="Bipolar I Disorder" 2="Bipolar II Disorder"
	3="Probable Recurrent major depression (severe)" 4="Probable Recurrent major depression (moderate)"
	5="Single Probable major depression episode";
  value mrsa -1="Invalid timing recorded";
  value mjkh 1="13" 2="14" 3="15" 4="16" 5="17";
  value mkkh 1="642" 2="308" 3="987" 4="714" 5="253";
  value mlkh 1="grow" 2="develop" 3="improve" 4="adult" 5="old";
  value mmkh 1="5" 2="6" 3="7" 4="8" 5="9";
  value mnkh 1="aunt" 2="sister" 3="niece" 4="cousin" 5="no relation";
  value mokh 1="68" 2="69" 3="70" 4="71" 5="72";
  value mpkh 1="pause" 2="close" 3="cease" 4="break" 5="rest";
  value mqkh 1="25" 2="26" 3="27" 4="28" 5="29";
  value mrkh 1="long" 2="deep" 3="top" 4="metres" 5="tall";
  value mskh 1="96" 2="95" 3="94" 4="93" 5="92";
  value mtkh 1="calm" 2="anxious" 3="cool" 4="worried" 5="tense";
  value mukh 1="50" 2="49" 3="47" 4="46" 5="45";
  value mvkh 1="False" 2="True" 3="Neither true nor false" 4="Not sure" 5="Impossible to tell without knowing more";
  value mwkh 1="49" 2="50" 3="51" 4="52" 5="53";
  value meta 0="Completed" 1="Abandoned" 2="Completed with pause";
  value mlsa 0="Completed" 1="Abandoned" 2="Completed with pause" 3="Timed-out due to inactivity";
  value mita 1="Yes" 0="No" -818="Prefer not to answer" -121="Do not know";
  value mcua 5="10 or more" 3="5 or 6" -818="Prefer not to answer" 2="3 or 4" 4="7, 8 or 9"
	1="1 or 2";
  value meua 0="No" -818="Prefer not to answer" 1="Yes, but not in the last year"
	2="Yes, during the last year";
  value mdua 5="Daily or almost daily" 3="Monthly" -818="Prefer not to answer"
	2="Less than monthly" 4="Weekly" 1="Never";
  value mfua -121="Do not know" -818="Prefer not to answer";
  value mbua 4="4 or more times a week" 2="2 to 4 times a month" -818="Prefer not to answer"
	1="Monthly or less" 3="2 to 3 times a week" 0="Never";
  value mjta 1="Yes" -818="Prefer not to answer" 0="No";
  value maua 1="Yes" -121="Do not know" 0="No";
  value mqta 3="A lot" 2="Somewhat" -818="Prefer not to answer" 1="A little" 0="Not at all";
  value mxta -999="All my life / as long as I can remember";
  value mtta -121="Do not know" -818="Prefer not to answer";
  value mlta 4="All day long" 2="About half of the day" -818="Prefer not to answer"
	1="Less than half of the day" 3="Most of the day" -121="Do not know";
  value mpta 6="Over two years" 3="Over three months, but less than six months"
	-818="Prefer not to answer" 2="Between one and three months" 5="One to two years"
	1="Less than a month" 4="Over six months, but less than 12 months";
  value mmta 3="Every day" 2="Almost every day" -818="Prefer not to answer" 1="Less often"
	-121="Do not know";
  value mrta -818="Prefer not to answer" -999="Too many to count / One episode ran into the next";
  value muta 1="Yes" 0="No" -818="Prefer not to answer" -121="Do not know" -313="Not applicable";
  value mgua 4="Yes, more than 100 times" 2="Yes, 3-10 times" -818="Prefer not to answer"
	1="Yes, 1-2 times" 3="Yes, 11-100 times" 0="No";
  value mhua 4="Every day" 2="Once a month or more, but not every week" -818="Prefer not to answer"
	1="Less than once a month" 3="Once a week or more, but not every day" -121="Do not know";
  value mrua 6="Extremely unhappy" 5="Very unhappy" 2="Very happy" -818="Prefer not to answer"
	1="Extremely happy" 4="Moderately unhappy" -121="Do not know" 3="Moderately happy";
  value msua 5="An extreme amount" 2="A little" -818="Prefer not to answer" 1="Not at all"
	4="Very much" -121="Do not know" 3="A moderate amount";
  value miua -121="Do not know" -818="Prefer not to answer" -999="Too many to count";
  value mjua 4="Nearly every day or daily" 2="Less than once a month" -818="Prefer not to answer"
	1="Once or twice" 3="More than once a month" 0="Not at all";
  value mpua 2="Yes, more than once" 1="Yes, once" -818="Prefer not to answer"
	0="No";
  value mqua 3="3 or more" 2="2" -818="Prefer not to answer" 1="1";
  value mmua 4="Very often true" 2="Sometimes true" -818="Prefer not to answer"
	1="Rarely true" 3="Often" 0="Never true";
  value mvta 3="A week or more" 2="At least a day, but less than a week" -818="Prefer not to answer"
	1="Less than 24 hours" -121="Do not know";
  value mwta 1="Needed treatment or caused problems with work, relationships, finances, the law or other aspects of life."
	0="No problems" -818="Prefer not to answer" -121="Do not know";
  value moua 4="Extremely" 2="Moderately" -818="Prefer not to answer" 1="A little bit"
	3="Quite a bit" 0="Not at all";
  value mkta 4="Nearly every day" 3="More than half the days" -818="Prefer not to answer"
	2="Several days" 1="Not at all";
  value mnua 2="Yes, within the last 12 months" 1="Yes, but not in the last 12 months"
	-818="Prefer not to answer" 0="Never";
  value mota 1="Yes" 0="No";
  value mnta 3="Both gained and lost some weight during the episode" 1="Gained weight"
	-818="Prefer not to answer" 0="Stayed about the same or was on a diet" 2="Lost weight"
	-121="Do not know";
  value mzta 3="Often" 1="Rarely" -818="Prefer not to answer" 0="Never" 2="Sometimes"
	-121="Do not know";
  value myta 2="More than one thing" 1="One thing" -818="Prefer not to answer"
	-121="Do not know";
  value mxbc 1="Social anxiety or social phobia" 2="Schizophrenia" 3="Any other type of psychosis or psychotic illness"
	4="A personality disorder" 5="Any other phobia (eg disabling fear of heights or spiders)"
	6="Panic attacks" 7="Obsessive compulsive disorder (OCD)" 10="Mania, hypomania, bipolar or manic-depression"
	11="Depression" 12="Bulimia nervosa" 13="Psychological over-eating or binge-eating"
	14="Autism, Aspergers or autistic spectrum disorder" 15="Anxiety, nerves or generalized anxiety disorder"
	16="Anorexia nervosa" 17="Agoraphobia" 18="Attention deficit or attention deficit and hyperactivity disorder (ADD/ADHD)"
	-818="Prefer not to answer (group A)" -819="Prefer not to answer (group B)";
  value mbcc 1="Unprescribed medication (more than once)" 3="Medication prescribed to you (for at least two weeks)"
	4="Drugs or alcohol (more than once)" -818="Prefer not to answer";
  value mccc 1="Talking therapies, such as psychotherapy, counselling, group therapy or CBT"
	3="Other therapeutic activities such as mindfulness, yoga or art classes" -818="Prefer not to answer";
  value mdcc 1="I was more talkative than usual" 2="I was more restless than usual"
	3="My thoughts were racing" 5="I needed less sleep than usual" 6="I was more creative or had more ideas than usual"
	7="I was easily distracted" 8="I was more confident than usual" 9="I was more active than usual"
	-818="Prefer not to answer";
  value mkcc 1="A sedative, benzodiazepine or sleeping tablet" 2="A painkiller"
	3="Something else" 4="Do not know" -818="Prefer not to answer";
  value mscc 1="Something not listed" 2="Swallowing dangerous objects or products"
	3="Stopping prescribed medication" 4="Ingesting a medication in excess of the normal dose"
	5="Self-injury such as self-cutting, scratching or hitting, etc." 6="Ingesting alcohol or a recreational or illicit drug"
	-818="Prefer not to answer";
  value mtcc 1="See anyone from psychiatric or mental health services, including liaison services"
	3="Need hospital treatment (eg AE)" 4="Use a helpline / voluntary organization"
	5="See own GP" 6="Receive help from friends / family / neighbours" -818="Prefer not to answer";
  value mnpa 1="Missing slab torso" 2="Other Error Torso";
  value mlpa 0="Other error" 1="Invalid landmark position - thigh completely or partly outside the FOV, in particular the femoral epicondyles are not visible"
	2="One or more slab(s) missing in the thigh region" 3="Subject tilted in scanner - part of the thigh outside the FOV or severe outer FOV inhomogeneities affect thigh muscle(s)";
  value mkpa 1="Severe Motion Artefact" 2="Tall Subject" 3="Broken Coil Element"
	4="Complicated Swap" 5="Complicated Swap in ASAT" 6="Corrupt Data" 7="Extreme Dogbites"
	8="Metal" 9="Minor Metal Artefact in ASAT";
  value mmsa 1="Deskop computer" 2="Laptop computer" 3="Tablet computer" 4="Smartphone"
	5="Other touchscreen device" 6="Other non-touchscreen device" -818="Prefer not to answer";
  value myjsf -2="Never went to school" -1="Do not know" -3="Prefer not to answer";
  value mcta 111="Smokes on most or all days" 112="Occasionally" 113="Ex-smoker"
	114="Never smoked" -818="Prefer not to answer";
  value mkkb 0="No cigarettes, only smoke cigars or pipes" -1001="Less than one cigarette per day"
	-818="Prefer not to answer";
  value mazsf -313="Ongoing when data entered";
  value mata -1520="15 to less-than-20 hours" -2030="20 to less-than-30 hours"
	-3040="30 to 40 hours" 4000="Over 40 hours";
  value mzsa -141="Often" -131="Sometimes" 0="Rarely/never" -121="Do not know";
  value mvsa 0="Shift pattern was worked for some (but not all) of job" 1="Shift pattern was worked for whole of job"
	9="This type of shift pattern was not worked during job";
  value musa -1001.000="Less than one year";
  value mtsa -1="More than a month";
  value mssa 101="Paid work for less than 15 hours per week on average or lasting less than 6 months"
	102="Unpaid or voluntary work" 103="Full-time or part-time education" 105="Looking after the home and/or family"
	106="Unable to work due to sickness or disability" 107="Unemployed" 108="Retired"
	-121="Unknown, cannot remember" -717="Other" -818="Prefer not to answer";
  value mryb -999999.000="Measure not cleanly recoverable from data";
  value mydb 1="Phase 1" 2="Phase 2" 3="Phase 3" 4="Phase 4" 5="Phase 5";
  value mtia 99="Not known" 1="Yes" 2="No";
  value muia 9="Not known" 4="Psychopathic disorder" 1="Mental illness" 3="Severe mental impairment"
	8="Not applicable" 2="Mental impairment" 5="Other";
  value mvia 9="Not known" 8="Not applicable" 0="No known previous psychiatric episodes"
	2="One or more previous psychiatric episodes with another Health Care Provider"
	1="One or more previous psychiatric episodes with this Health Care Provider";
  value meia 9="Not known" 8="Not applicable" 7="Other" 1="General anaesthetic"
	4="General anaesthetic and epidural or caudal anaesthetic" 3="Spinal anaesthetic"
	6="Epidural or caudal, and spinal anaesthetic" 2="Epidural or caudal anaesthetic"
	5="General and spinal anaesthetic";
  value mmia 9="Not known" 4="Medical induction" 1="Spontaneous" 3="Surgical induction by amniotomy"
	8="Not applicable" 2="Caesarean section" 5="Combination of surgical and medical induction";
  value mjia 9="Not known" 8="Other" 6="Other hospital or institution" 0="NHS hospital: midwife ward"
	3="NHS hospital: GP ward" 7="NHS hospital: ward or unit without delivery facilities"
	2="NHS hospital: consultant ward" 5="Private hospital" 1="At a domestic address"
	4="NHS hospital: consultant and GP ward";
  value mpia 9="Not known" 8="Stillborn and no method of resuscitation attempted"
	4="Positive pressure by mask, drugs administered" 1="Positive pressure nil, drugs nil"
	3="Positive pressure by mask, drugs nil" 6="Positive pressure by endotracheal tube, drugs administered"
	2="Positive pressure nil, drugs administered" 5="Positive pressure by endotracheal tube, drugs nil";
  value mqia 9="Not specified" 3="Indeterminate" 0="Not known" 2="Female" 1="Male";
  value mlia 9="Not known" 4="Stillbirth: indeterminate" 1="Live" 3="Stillbirth: intra-partum"
	2="Stillbirth: ante-partum";
  value mria 9="Not known" 8="Other than above" 1="Hospital doctor" 3="Midwife"
	2="General practitioner";
  value meja 6="Other birth event" 4="Mental health/ psychiatric episode" 1="General episode"
	3="Birth episode" 5="Other delivery event" 2="Delivery episode";
  value mtha 31="Amenity patient: formally detained under Part II, Mental Health Act 1983"
	32="Amenity patient: formally detained under Part III, Mental Health Act 1983"
	33="Amenity patient: formally detained under part X, Mental Health Act 1983"
	30="Amenity patient: not formally detained" 11="NHS patient: formally detained under Part II, Mental Health Act 1983"
	12="NHS patient: formally detained under Part III, Mental Health Act 1983, or under other Acts"
	13="NHS patient: formally detained under part X, Mental Health Act 1983" 10="NHS patient: not formally detained"
	21="Private patient: formally detained under Part II, Mental Health Act 1983"
	22="Private patient: formally detained under Part III, Mental Health Act 1983"
	23="Private patient: formally detained under part X, Mental Health Act 1983"
	20="Private patient: not formally detained" 98="Not applicable" 99="Not known: a validation error";
  value mlka 900="Not known" 400="Planned series of admissions with no overnight stay"
	100="One or more nights hospital stay" 300="Planned series of admissions with at least one overnight stay"
	800="Not applicable" 200="No overnight hospital stay" 500="Planned series of night admissions of 24h period at home";
  value mgka 6000="Not applicable" 3000="Regular day attender" 2003="Day case: In day bed unit, moved to inpatient ward and retained overnight"
	1000="Inpatient" 2000="Day case" 2005="Day case: In inpatient ward and retained overnight"
	1002="Inpatient: In five day ward" 2004="Day case: In inpatient ward" 5000="Expectant mothers using delivery facilities"
	4000="Regular night attender" 1001="Inpatient: In day bed unit, not retained overnight"
	2002="Day case: In day bed unit" 2001="Day case: moved to inpatient ward and retained overnight";
  value mika 5000="Not known" 4000="Not applicable" 3004="Patient death: Stillbirth"
	2002="Discharged without clinical advice/consent: Self discharge" 1000="Discharged on clinical advice/consent"
	1006="Discharged on clinical advice/consent: Under community care order" 3003="Patient death: Whilst on pass"
	1003="Discharged on clinical advice/consent: Transfer to another provider"
	3002="Patient death: Post-mortem not performed" 2001="Discharged without clinical advice/consent: Self, relative or advocate"
	1002="Discharged on clinical advice/consent: Transfer within provider" 2000="Discharged without clinical advice/consent"
	3001="Patient death: Post-mortem performed" 2003="Discharged without clinical advice/consent: Discharged by relative"
	1001="Discharged on clinical advice/consent: From inpatient/daycase care" 1005="Discharged on clinical advice/consent: By mental health review"
	3000="Patient death" 1004="Discharged on clinical advice/consent: Leave of absence granted"
	2004="Discharged without clinical advice/consent: Absconded from detention";
  value mdka 6="English HES Data" 21="PEDW HES 2015" 12="PEDW In-Patient Data"
	10="UKB SMR 01A (HES)" 9="UKB SMR 01B (HES)" 15="SMR01B-V2" 18="UK HES In Patient (2015 format)"
	28="SMR01B-V3" 70="UK HES Inpatients (2017 format)" 60="UKB HES Critical Care"
	68="UKB Scottish inpatient (SMR01) v4" 71="UKB HES inpatient (2018 onwards)";
  value mola 0="Self-reported only" 1="Hospital admission" 2="Death only";
  value mkyrf 600="6+" 5="5" 4="4" 3="3" 2="2" 1="1" 555="half";
  value moyrf 1="Yes" 0="No";
  value mnyrf 111="varied" 1="Yes";
  value mgyrf 111="varied" 300="3+" 2="2" 1="1" 555="half";
  value mlyrf 600="6+" 4="4" 1="1" 3="3" 5="5" 2="2";
  value mvyrf 300="3+" 2="2" 1="1" 555="half" 444="quarter";
  value mryrf 1="Yes, ticked" 0="No, not ticked";
  value miyrf 400="4+" 3="3" 2="2" 1="1" 555="half";
  value mpyrf 3060="30-60 minutes" 1030="10-30 minutes" 24="2-4 hours" 0="None"
	12="1-2 hours" 600="6+ hours" 10="Under 10 minutes" 46="4-6 hours";
  value mqyrf 1200="12+ hours" 912="9-12 hours" 35="3-5 hours" 0="None" 13="1-3 hours"
	79="7-9 hours" 1="Under 1 hour" 57="5-7 hours";
  value mnfd 20="Death register only" 21="Death register and other source(s)"
	30="Primary care only" 31="Primary care and other source(s)" 40="Hospital admissions data only"
	41="Hospital admissions data and other source(s)" 50="Self-report only" 51="Self-report and other source(s)";
	value mfisf 1="Direct entry" 2="Manual entry of full results" 3="Manual measurement of weight only"
	4="Not performed" -1="Question not asked due to previous answers";
  value mjaa 1="Male" 0="Female";
  value mhaa 1="Yes" 0="No";
  value miaa 12="December" 10="October" 7="July" 1="January" 4="April" 9="September"
	3="March" 8="August" 11="November" 6="June" 2="February" 5="May";
  value mlba -1="Time uncertain/unknown" -3="Preferred not to answer";
  value mcisf 1="Yes - pounds and ounces" 2="Yes - Kilograms" 9="No";
  value moga -1="Location could not be mapped";
  value mpxc 1="Death reported to UK Biobank by a relative" 2="NHS records indicate they are lost to follow-up"
	3="NHS records indicate they have left the UK" 4="UK Biobank sources report they have left the UK"
	5="Participant has withdrawn consent for future linkage";
  value mejsf 1="A house or bungalow" 2="A flat, maisonette or apartment" 3="Mobile or temporary structure (i.e. caravan)"
	4="Sheltered accommodation" 5="Care home" -7="None of the above" -3="Prefer not to answer";
  value mfjsf 1="Own outright (by you or someone in your household)" 2="Own with a mortgage"
	3="Rent - from local authority, local council, housing association" 4="Rent - from private landlord or letting agency"
	5="Pay part rent and part mortgage (shared ownership)" 6="Live in accommodation rent free"
	-7="None of the above" -3="Prefer not to answer";
  value mijsf -10="Less than a year" -1="Do not know" -3="Prefer not to answer";
  value mjjsf -1="Do not know" -3="Prefer not to answer";
  value mljsf 1="None" 2="One" 3="Two" 4="Three" 5="Four or more" -1="Do not know"
	-3="Prefer not to answer";
  value mmjsf 1="Less than 18,000" 2="18,000 to 30,999" 3="31,000 to 51,999" 4="52,000 to 100,000"
	5="Greater than 100,000" -1="Do not know" -3="Prefer not to answer";
  value mqjsf -10="Less than once a week" -1="Do not know" -3="Prefer not to answer";
  value msjsf -10="Less than one mile" -1="Do not know" -3="Prefer not to answer";
  value mtjsf 1="Never/rarely" 2="Sometimes" 3="Usually" 4="Always" -1="Do not know"
	-3="Prefer not to answer";
  value myjsf -2="Never went to school" -1="Do not know" -3="Prefer not to answer";
  value mtksf 1="Almost daily" 2="2-4 times a week" 3="About once a week" 4="About once a month"
	5="Once every few months" 6="Never or almost never" 7="No friends/family outside household"
	-1="Do not know" -3="Prefer not to answer";
  value mvksf -10="Less than an hour a day" -1="Do not know" -3="Prefer not to answer";
  value mblsf 0="Never used mobile phone at least once per week" 1="One year or less"
	2="Two to four years" 3="Five to eight years" 4="More than eight years" -1="Do not know"
	-3="Prefer not to answer";
  value mclsf 0="Less than 5mins" 1="5-29 mins" 2="30-59 mins" 3="1-3 hours" 4="4-6 hours"
	5="More than 6 hours" -1="Do not know" -3="Prefer not to answer";
  value mdlsf 0="Never or almost never" 1="Less than half the time" 2="About half the time"
	3="More than half the time" 4="Always or almost always" -1="Do not know" -3="Prefer not to answer";
  value melsf 0="No" 1="Yes, use is now less frequent" 2="Yes, use is now more frequent"
	3="I didnt use a mobile phone two years ago" -1="Do not know" -3="Prefer not to answer";
  value mflsf 1="Left" 2="Right" 3="Equally left and right" -1="Do not know" -3="Prefer not to answer";
  value mhlsf 1="Not at all easy" 2="Not very easy" 3="Fairly easy" 4="Very easy"
	-1="Do not know" -3="Prefer not to answer";
  value milsf 1="Definitely a morning person" 2="More a morning than evening person"
	3="More an evening than a morning person" 4="Definitely an evening person" -1="Do not know"
	-3="Prefer not to answer";
  value mjlsf 1="Never/rarely" 2="Sometimes" 3="Usually" -3="Prefer not to answer";
  value mllsf 1="Yes" 2="No" -1="Do not know" -3="Prefer not to answer";
  value mmlsf 0="Never/rarely" 1="Sometimes" 2="Often" -1="Do not know" -3="Prefer not to answer"
	3="All of the time";
  value mnlsf 1="Yes, on most or all days" 2="Only occasionally" 0="No" -3="Prefer not to answer";
  value molsf 1="Smoked on most or all days" 2="Smoked occasionally" 3="Just tried once or twice"
	4="I have never smoked" -3="Prefer not to answer";
  value mkmsf 1="Yes, one household member smokes" 2="Yes, more than one household member smokes"
	0="No" -3="Prefer not to answer";
  value mnmsf -10="Less than one" -1="Do not know" -3="Prefer not to answer";
  value mrmsf 0="Never" 1="Less than once a week" 2="Once a week" 3="2-4 times a week"
	4="5-6 times a week" 5="Once or more daily" -1="Do not know" -3="Prefer not to answer";
  value mbnsf 1="Full cream" 2="Semi-skimmed" 3="Skimmed" 4="Soya" 5="Other type of milk"
	6="Never/rarely have milk" -1="Do not know" -3="Prefer not to answer";
  value mcnsf 1="Butter/spreadable butter" 3="Other type of spread/margarine" 0="Never/rarely use spread"
	-1="Do not know" -3="Prefer not to answer" 2="Flora Pro-Active/Benecol";
  value mfnsf 1="White" 2="Brown" 3="Wholemeal or wholegrain" 4="Other type of bread"
	-1="Do not know" -3="Prefer not to answer";
  value mhnsf 1="Bran cereal (e.g. All Bran, Branflakes)" 2="Biscuit cereal (e.g. Weetabix)"
	3="Oat cereal (e.g. Ready Brek, porridge)" 4="Muesli" 5="Other (e.g. Cornflakes, Frosties)"
	-1="Do not know" -3="Prefer not to answer";
  value minsf 1="Never/rarely" 2="Sometimes" 3="Usually" 4="Always" -3="Prefer not to answer";
  value mlnsf 1="Decaffeinated coffee (any type)" 2="Instant coffee" 3="Ground coffee (include espresso, filter etc)"
	4="Other type of coffee" -1="Do not know" -3="Prefer not to answer";
  value mmnsf 1="Very hot" 2="Hot" 3="Warm" -2="Do not drink hot drinks" -3="Prefer not to answer";
  value monsf 0="No" 1="Yes, because of illness" 2="Yes, because of other reasons"
	-3="Prefer not to answer";
  value mpnsf 1="Never/rarely" 2="Sometimes" 3="Often" -1="Do not know" -3="Prefer not to answer";
  value mqnsf 1="Daily or almost daily" 2="Three or four times a week" 3="Once or twice a week"
	4="One to three times a month" 5="Special occasions only" 6="Never" -3="Prefer not to answer";
  value meosf 1="Yes" 0="No" -6="It varies" -1="Do not know" -3="Prefer not to answer";
  value mfosf 1="More nowadays" 2="About the same" 3="Less nowadays" -1="Do not know"
	-3="Prefer not to answer";
  value miosf 1="England" 2="Wales" 3="Scotland" 4="Northern Ireland" 5="Republic of Ireland"
	6="Elsewhere" -1="Do not know" -3="Prefer not to answer";
  value mplsf 1="Yes" 0="No" -1="Do not know" -3="Prefer not to answer";
  value mqosf 1="Thinner" 2="Plumper" 3="About average" -1="Do not know" -3="Prefer not to answer";
  value mrosf 1="Shorter" 2="Taller" 3="About average" -1="Do not know" -3="Prefer not to answer";
  value msosf 1="Right-handed" 2="Left-handed" 3="Use both right and left hands equally"
	-3="Prefer not to answer";
  value mtosf 1="Very fair" 2="Fair" 3="Light olive" 4="Dark olive" 5="Brown" 6="Black"
	-1="Do not know" -3="Prefer not to answer";
  value muosf 1="Get very tanned" 2="Get moderately tanned" 3="Get mildly or occasionally tanned"
	4="Never tan, only burn" -1="Do not know" -3="Prefer not to answer";
  value mwosf 1="Blonde" 2="Red" 3="Light brown" 4="Dark brown" 5="Black" 6="Other"
	-1="Do not know" -3="Prefer not to answer";
  value mxosf 1="Younger than you are" 2="Older than you are" 3="About your age"
	-1="Do not know" -3="Prefer not to answer";
  value mlrsf 5="Almost daily" 4="2-4 times a week" 3="About once a week" 2="About once a month"
	1="Once every few months" 0="Never or almost never" -1="Do not know" -3="Prefer not to answer";
  value mnrsf 1="Continue" 2="Skip this section";
  value morsf -2="Never had sex" -3="Prefer not to answer" -1="Do not know";
  value mslsf 1="Yes" 0="No" -3="Prefer not to answer";
  value msrsf 1="Excellent" 2="Good" 3="Fair" 4="Poor" -1="Do not know" -3="Prefer not to answer";
  value mtwsf 0="Never/rarely" 1="Sometimes" 2="Often" -3="Prefer not to answer";
  value mussf 1="Never/rarely" 2="Sometimes" 3="Most of the time" 4="Always" 5="Do not go out in sunshine"
	-1="Do not know" -3="Prefer not to answer";
  value mvssf -10="Less than once a year" -1="Do not know" -3="Prefer not to answer";
  value mxssf 1="No falls" 2="Only one fall" 3="More than one fall" -3="Prefer not to answer";
  value myssf 0="No - weigh about the same" 2="Yes - gained weight" 3="Yes - lost weight"
	-1="Do not know" -3="Prefer not to answer";
  value mztsf -10="Less than 1 year ago" -1="Do not know" -3="Prefer not to answer";
  value mjvsf 1="Yes - you will be asked about this later by an interviewer" 0="No"
	-1="Do not know" -3="Prefer not to answer";
  value mdnsf 4="Soft (tub) margarine" 5="Hard (block) margarine" 6="Olive oil based spread (eg: Bertolli)"
	7="Polyunsaturated/sunflower oil based spread (eg: Flora)" 2="Flora Pro-Active or Benecol"
	8="Other low or reduced fat spread" 9="Other type of spread/margarine" -1="Do not know"
	-3="Prefer not to answer";
  value mgosf 1="Illness or ill health" 2="Doctors advice" 3="Health precaution"
	4="Financial reasons" 5="Other reason" -1="Do not know" -3="Prefer not to answer";
  value mbusf -10="Less than a year ago" -1="Do not know" -3="Prefer not to answer";
  value mlusf 1="Yes" 0="No" 2="Not sure - had a hysterectomy" 3="Not sure - other reason"
	-3="Prefer not to answer";
  value mqusf -3="Prefer not to answer";
  value mrusf -1="Do not know" -2="Only had twins" -3="Prefer not to answer";
  value msusf -4="Do not remember" -3="Prefer not to answer";
  value mbvsf -1="Do not know" -3="Prefer not to answer" -11="Still taking the pill";
  value mfvsf 1="Yes" 0="No" -5="Not sure" -3="Prefer not to answer";
  value mrlsf 1="Manufactured cigarettes" 2="Hand-rolled cigarettes" 3="Cigars or pipes"
	-7="None of the above" -3="Prefer not to answer";
  value mtlsf -10="Less than one a day" -1="Do not know";
  value mjmsf 1="Yes, definitely" 2="Yes, probably" 3="No, probably not" 4="No, definitely not"
	-1="Do not know" -3="Prefer not to answer";
  value mgisf 30="30cm" 40="40cm" 50="50cm";
  value mlisf 1="Yes" 2="Unsure" 0="No";
  value mvlsf -10="Less than one a day" -1="Do not know" -3="Prefer not to answer";
  value mwlsf 1="Less than 5 minutes" 2="Between 5-15 minutes" 3="Between 30 minutes - 1 hour"
	4="Between 1 and 2 hours" 5="Longer than 2 hours" -1="Do not know" -3="Prefer not to answer";
  value mxlsf 1="Very easy" 2="Fairly easy" 3="Fairly difficult" 4="Very difficult"
	-3="Prefer not to answer";
  value mylsf 1="Yes, tried but was not able to stop or stopped for less than 6 months"
	2="Yes, tried and stopped for at least 6 months" 0="No" -3="Prefer not to answer";
  value mzlsf 1="Yes, definitely" 2="Yes, probably" 3="No, probably not" 4="No, definitely not"
	-3="Prefer not to answer";
  value mamsf 1="More nowadays?" 2="About the same?" 3="Less nowadays?" -3="Prefer not to answer";
  value mevsf -1="Do not know" -11="Still taking HRT" -3="Prefer not to answer";
  value mvtsf 1="Yes" 0="No" -1="Unable to walk on the level" -3="Prefer not to answer";
  value mousf -6="Irregular cycle" -1="Do not know" -3="Prefer not to answer";
  value mwtsf 1="Yes" 0="No" -1="Unable to walk up hills or to hurry" -3="Prefer not to answer";
  value mdisf 1="Direct entry" 2="Manual entry of electronic results" 3="Manual sphygmometer"
	4="Not performed" -1="Question not asked due to previous answers";
  value mhisf 1="Direct entry" 2="Manual entry" 6="Not performed - equipment failure"
	7="Not performed - other reason";
  value mmaa 1="True" 0="False";
  value mvrsf 1="Yes, all of the time" 2="Yes, most of the time" 3="Yes, sometimes"
	4="No, never" -1="Do not know" -3="Prefer not to answer";
  value mhtsf 1="Stop" 2="Slow down" 3="Continue at same pace" -1="Do not know"
	-3="Prefer not to answer";
  value mitsf 1="Pain usually continues for more than 10 minutes" 2="Pain usually disappears in less than 10 minutes"
	-1="Do not know" -3="Prefer not to answer";
  value mktsf 0="No" 1="Yes, toes" 2="Yes, leg below the knee" 3="Yes, leg above the knee"
	-1="Do not know" -3="Prefer not to answer";
  value mxjsf 1="College or University degree" 2="A levels/AS levels or equivalent"
	3="O levels/GCSEs or equivalent" 4="CSEs or equivalent" 5="NVQ or HND or HNC or equivalent"
	6="Other professional qualifications eg: nursing, teaching" -7="None of the above"
	-3="Prefer not to answer";
  value mgjsf 1="A gas hob or gas cooker" 2="A gas fire that you use regularly in winter time"
	3="An open solid fuel fire that you use regularly in winter time" -7="None of the above"
	-1="Do not know" -3="Prefer not to answer";
  value mhjsf 1="Gas central heating" 2="Electric storage heaters" 3="Oil (kerosene) central heating"
	4="Portable gas or paraffin heaters" 5="Solid fuel central heating" 6="Open fire without central heating"
	-7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value mkjsf 1="Husband, wife or partner" 2="Son and/or daughter (include step-children)"
	3="Brother and/or sister" 4="Mother and/or father" 5="Grandparent" 6="Grandchild"
	7="Other related" 8="Other unrelated" -3="Prefer not to answer";
  value mnjsf 1="In paid employment or self-employed" 2="Retired" 3="Looking after home and/or family"
	4="Unable to work because of sickness or disability" 5="Unemployed" 6="Doing unpaid or voluntary work"
	7="Full or part-time student" -7="None of the above" -3="Prefer not to answer";
  value mrjsf 1="Car/motor vehicle" 2="Walk" 3="Public transport" 4="Cycle" -7="None of the above"
	-3="Prefer not to answer";
  value mzmsf 1="Eggs or foods containing eggs" 2="Dairy products" 3="Wheat products"
	4="Sugar or foods/drinks containing sugar" 5="I eat all of the above" -3="Prefer not to answer";
  value mursf 1="Attendance allowance" 2="Disability living allowance" 3="Blue badge"
	-7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value mlvsf 1="Heart attack" 2="Angina" 3="Stroke" 4="High blood pressure" -7="None of the above"
	-3="Prefer not to answer";
  value mqvsf 5="Blood clot in the leg (DVT)" 7="Blood clot in the lung" 6="Emphysema/chronic bronchitis"
	8="Asthma" 9="Hayfever, allergic rhinitis or eczema" -7="None of the above" -3="Prefer not to answer";
  value mgwsf 1="Cholesterol lowering medication" 2="Blood pressure medication"
	3="Insulin" 4="Hormone replacement therapy" 5="Oral contraceptive pill or minipill"
	-7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value miwsf 1="Aspirin" 2="Ibuprofen (e.g. Nurofen)" 3="Paracetamol" 4="Ranitidine (e.g. Zantac)"
	5="Omeprazole (e.g. Zanprol)" 6="Laxatives (e.g. Dulcolax, Senokot)" -7="None of the above"
	-1="Do not know" -3="Prefer not to answer";
  value mjwsf 1="Vitamin A" 2="Vitamin B" 3="Vitamin C" 4="Vitamin D" 5="Vitamin E"
	6="Folic acid or Folate (Vit B9)" 7="Multivitamins +/- minerals" -7="None of the above"
	-3="Prefer not to answer";
  value mbmsf 1="Illness or ill health" 2="Doctors advice" 3="Health precaution"
	4="Financial reasons" -7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value mltsf 1="Headache" 2="Facial pain" 3="Neck or shoulder pain" 4="Back pain"
	5="Stomach or abdominal pain" 6="Hip pain" 7="Knee pain" 8="Pain all over the body"
	-7="None of the above" -3="Prefer not to answer";
  value muksf 1="Sports club or gym" 2="Pub or social club" 3="Religious group"
	4="Adult education class" 5="Other group activity" -7="None of the above" -3="Prefer not to answer";
  value mfwsf 1="Cholesterol lowering medication" 2="Blood pressure medication"
	3="Insulin" -7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value mkwsf 1="Fish oil (including cod liver oil)" 2="Glucosamine" 3="Calcium"
	4="Zinc" 5="Iron" 6="Selenium" -7="None of the above" -3="Prefer not to answer";
  value mqysf 1="Aspirin" 2="Ibuprofen (e.g. Nurofen)" 3="Paracetamol" 4="Codeine"
	5="Ranitidine (e.g. Zantac)" -7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value mrysf 1="Omeprazole (e.g. Zanprol)" 2="Laxatives (e.g. Dulcolax, Senokot)"
	3="Nicotine patches/sprays/tablets/gum etc" 4="Antihistamines (e.g. Loratidine, Cetirizine)"
	-7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value muysf 1="Evening primrose oil" 2="Fish oil (including cod liver oil" 3="Garlic"
	4="Ginkgo" 5="Glucosamine" 6="Other supplements, vitamins or minerals" -7="None of the above"
	-3="Prefer not to answer";
  value mxxsf 1="Illness" 2="Financial reasons" 3="Other reason" -1="Do not know"
	-3="Prefer not to answer";
  value moysf 1="Microval" 2="Micronor" 3="Noriday" 4="Norgeston" 5="Femulen" 6="Cerazette"
	-1="None of the above" -3="Prefer not to answer";
  value mmxsf 1="College or University degree" 2="A levels/AS levels or equivalent"
	3="O levels/GCSEs or equivalent" 4="CSEs or equivalent" 5="NVQ or HND or HNC or equivalent"
	-7="None of the above" -3="Prefer not to answer";
  value mtysf 1="Vitamin A" 2="Vitamin B" 3="Vitamin C" 4="Vitamin D" 5="Vitamin E"
	6="Folic acid or Folate (Vit B9)" -7="None of the above" -3="Prefer not to answer";
  value mqxsf 1="Almost daily" 2="2-4 times a week" 3="About once a week" 4="About once a month"
	5="Once every few months" 6="Never or almost never" 7="No friends/family outside household"
	-3="Prefer not to answer";
  value mrxsf 1="Less than 10 mins" 2="10-19 mins" 3="20-29 mins" 4="30 mins or more"
	-1="Do not know" -3="Prefer not to answer";
  value mbysf 1="Butter/spreadable butter" 2="Margarine" 3="Olive oil based spread"
	4="Low or reduced fat spread" 5="Other type of spread" 6="Never/rarely use spread"
	-1="Do not know" -3="Prefer not to answer";
  value mcysf 1="White" 2="Brown" 3="Wholemeal or wholegrain" 4="Other type of bread"
	5="Never/rarely eat bread" -1="Do not know" -3="Prefer not to answer";
  value mwxsf 1="Yes" 0="No" -1="Do not know";
  value msysf 1="Iron" 2="Zinc" 3="Calcium" 4="Selenium" 5="Multivitamins" 6="Multivitamins with minerals"
	-7="None of the above" -3="Prefer not to answer";
  value maysf 1="Eggs" 2="Dairy products" 3="Wheat products" 4="Sugar" 5="I eat all of the above"
	-3="Prefer not to answer";
  value mkxsf 1="A gas hob" 2="A gas cooker" 3="An open solid fuel fire that you use regularly in winter time"
	-7="None of the above" -1="Do not know" -3="Prefer not to answer";
  value mlxsf 1="Less than 18,000" 2="18,000 to 31,000" 3="31,000 to 52,000" 4="52,000 to 100,000"
	5="Greater than 100,000" -1="Do not know" -3="Prefer not to answer";
  value msxsf 0="No" 1="Yes, use is now less frequent" 2="Yes, use is now more frequent"
	3="I didnt use a mobile phone one year ago" -1="Do not know" -3="Prefer not to answer";
  value mcsa 0="Direct entry" 6="Not performed - equipment failure" 7="Not performed - other reason";
  value mtmb 1="Current, email address assumed working" 2="Unusable, email address failed or withdrawn";
  value mnaa -1.000="Date uncertain or unknown" -3.000="Preferred not to answer";
  value moaa -1="Time uncertain/unknown" -3="Preferred not to answer" -5="Year of event"
	-4="Age at event";
  value mxba 601="Feeling unwell/pain" 407="Reason not stated" 300="Reason not known"
	100="Declined" 200="Equipment failure" 405="Other health reason" 102="Lack of time"
	400="Unable" 600="Abandoned" 432="Moved arm" 101="Against participant wishes"
	202="Not available" 434="Recently donated blood" 201="Malfunction" 433="Poor venous access/flow";
  value myba 601="Feeling unwell/pain" 434="Recently donated blood" 405="Other health reason"
	100="Declined" 200="Equipment failure" 433="Poor venous access/flow" 102="Lack of time"
	407="Reason not stated" 600="Abandoned" 500="Nurse Advised not to perform" 101="Against participant wishes"
	400="Unable" 506="Reason not known" 201="Malfunction";
  value mzba 423="Insuffient pulse/signal" 422="False Nails/varnish" 202="Not available"
	100="Declined" 103="Feeling unwell" 405="Other health reason" 102="Lack of time"
	400="Unable" 201="Malfunction" 101="Against participant wishes" 200="Equipment failure";
  value mtca 700="Sample already provided" 405="Other health reason" 202="Not available"
	100="Declined" 103="Feeling unwell" 400="Unable" 102="Lack of time" 300="Reason not known"
	201="Malfunction" 101="Against participant wishes" 200="Equipment failure";
  value mwca 468="Multivitamin" 469="Multivitamin with iron" 470="Multivitamin with calcium"
	471="Multivitamin with multimineral" 472="Fish oil" 473="Glucosamine/chondroitin"
	474="Evening primrose" 475="Vitamin A" 476="Vitamin B6" 477="Vitamin B12" 478="Vitamin C"
	479="Vitamin D" 480="Vitamin E" 481="Folic acid" 482="Chromium" 483="Magnesium"
	484="Selenium" 485="Calcium" 486="Iron" 487="Zinc" 488="Other vitamin";
  value mxca 3="Ill" 4="Fasting" 5="Away" 6="Other reason untypical diet";
  value myca 8="Gluten-free" 9="Lactose-free" 10="Low calorie" 11="Vegetarian"
	12="Vegan" 13="Other";
  value mada 332="Jam/honey" 333="Cream" 334="Peanut butter" 335="Yeast extract"
	336="Hummus" 337="Guacamole" 338="Chutney/pickle" 339="Tomato ketchup" 340="Brown sauce"
	341="Low fat mayonnaise" 342="Mayonnaise" 343="Salad dressing" 344="Oil for drizzling"
	345="Pesto" 346="Tomato-based sauce" 347="Cheese sauce" 348="White/cream sauce"
	349="Gravy" 350="Other sauce";
  value mbda 461="Takeaway meals" 462="Restaurant meals" 463="Bought sandwiches"
	464="Ready meals" 465="Home cooked meals";
  value mdda 1="white" 2="mixed" 3="wholemeal" 4="seeded" 5="other";
  value meda 1="small (125ml)" 2="medium (175ml)" 3="large (250ml)";
  value mfda 1="thin" 2="medium" 3="thick";
  value mgda 78="Porridge with water" 79="Porridge with milk";
  value mhda 210="Low fat yogurt consumers" 211="Full fat yogurt consumers";
  value mwmb 13="Prostate cancer" 12="Severe depression" 11="Parkinsons disease"
	10="Alzheimers disease/dementia" 9="Diabetes" 8="High blood pressure" 6="Chronic bronchitis/emphysema"
	5="Breast cancer" 4="Bowel cancer" 3="Lung cancer" 2="Stroke" 1="Heart disease"
	-11="Do not know (group 1)" -13="Prefer not to answer (group 1)" -17="None of the above (group 1)"
	-21="Do not know (group 2)" -23="Prefer not to answer (group 2)" -27="None of the above (group 2)";
  value mida 1="Fish" 2="Meat" 3="Pasta" 4="Pulses" 5="Vegetables" 6="Other ingredients";
  value mmda 2="Current" 1="Previous" -3="Prefer not to answer" 0="Never";
  value mnmb 4001="Caribbean" 3001="Indian" 1="White" 2001="White and Black Caribbean"
	1001="British" 3002="Pakistani" 2="Mixed" 4002="African" 1002="Irish" 2002="White and Black African"
	3003="Bangladeshi" 3="Asian or Asian British" 4003="Any other Black background"
	1003="Any other white background" 2003="White and Asian" 3004="Any other Asian background"
	4="Black or Black British" 2004="Any other mixed background" 5="Chinese" 6="Other ethnic group"
	-1="Do not know" -3="Prefer not to answer";
  value mita 1="Yes" 0="No" -818="Prefer not to answer" -121="Do not know";
  value mnhb 0="Never" 1="Less than one day a month" 2="One day a month" 3="Two to three days a month"
	4="One day a week" 5="More than one day a week" 6="Every day" -818="Prefer not to answer";
  value minb 1="Yes" 0="No" -818="Prefer not to answer" -313="Not applicable";
  value mjta 1="Yes" -818="Prefer not to answer" 0="No";
  value mokb -500="Never" -501="Sometimes" -502="Often" -503="Most of the time"
	-504="Always" -818="Prefer not to answer";
  value mspa 0="0 - No pain" 1="1" 2="2" 3="3" 4="4" 5="5" 6="6" 7="7" 8="8" 9="9"
	10="10 - Very severe pain" -818="Prefer not to answer";
  value mdjb 0="No days with pain" 1="1 day with pain" 2="2 days with pain" 3="3 days with pain"
	4="4 days with pain" 5="5 days with pain" 6="6 days with pain" 7="7 days with pain"
	8="8 days with pain" 9="9 days with pain" 10="10 days with pain" -818="Prefer not to answer";
  value mwxa 0="0 - No distension" 1="1" 2="2" 3="3" 4="4" 5="5" 6="6" 7="7" 8="8"
	9="9" 10="10 - Very severe distension" -818="Prefer not to answer";
  value msxa 0="0 - Very happy" 1="1" 2="2" 3="3" 4="4" 5="5" 6="6" 7="7" 8="8"
	9="9" 10="10 - Very unhappy" -818="Prefer not to answer";
  value mcva 0="0 - Not at all" 1="1" 2="2" 3="3" 4="4" 5="5" 6="6" 7="7" 8="8"
	9="9" 10="10 - Completely" -818="Prefer not to answer";
  value mmwa -818="Prefer not to answer";
  value mvkb -777="Given up work because of IBS" -313="Do not work" -818="Prefer not to answer";
  value mqba -313="Not applicable" -818="Prefer not to answer";
  value mbna -600="Not bothered at all" -601="Bothered a little" -602="Bothered a lot"
	-818="Prefer not to answer";
  value menb -600="Not bothered at all" -601="Bothered a little" -602="Bothered a lot"
	-818="Prefer not to answer" -313="Not applicable";
  value mqtc -701="Self-diagnosis from symptoms" -702="Doctor diagnosis from symptoms"
	-703="By means of a blood test only" -704="By means of endoscopy only" -705="By means of a blood test and endoscopy"
	-818="Prefer not to answer";
  value mabe -801="Started suddenly" -802="Came on gradually" -803="Cannot remember"
	-818="Prefer not to answer";
  value mevk -901="Salmonella" -902="Shigella" -903="Campylobacter" -904="Virus"
	-905="Other" -906="Do not know" -818="Prefer not to answer";
  value mhnb 1="Yes" 0="No" -818="Prefer not to answer";
  value momb 1="Caucasian";
  value mbaa 1="Yes";
  value mgab -1="Participant excluded from kinship inference process" 0="No kinship found"
	1="At least one relative identified" 10="Ten or more third-degree relatives identified";
  value miisf 1="Yes" 0="No";
  value mczsf 0="low" 1="moderate" 2="high";
  value mzib 0.000="Measure invalid";
  value mdca 1="Pass" 2="Fail";
  value mahl 1="Potential spillover" 2="One additional freeze and thaw cycle";
  value mnba 5="Malignant, microinvasive" 9="Malignant, uncertain whether primary or metastatic site"
	-1="Malignant" 0="Benign" 2="Carcinoma in situ" 6="Malignant, metastatic site"
	1="Uncertain whether benign or malignant" 3="Malignant, primary site";
  value mbka 2="IC Death Format (2012 onwards)" 1="IC Death Format (2011 and earlier)"
	7="Scottish Morbidity Record (SMR)" 19="Scottish Morbidity Record (SMR) 99B - 2015"
	55="IC Scottish deaths (2017 onwards)";
  value mcka 3="NHS Information Centre Cancer Registry 2012 onwards" 4="Scottish Cancer Registry (fixed width format) 2012 onwards"
	13="National Cancer Intelligence Network (NCIN) Cancer Data" 22="Scottish Cancer Registry (fixed width format) 2012 onwards"
	23="NHS Information Centre Cancer Registry 2016 onwards";
  value msyrf 15="Larger" 5="Smaller" 10="Average";
  value moyrf 1="Yes" 0="No";
  value mkyrf 600="6+" 5="5" 4="4" 3="3" 2="2" 1="1" 555="half";
  value mfyrf 200="2+" 1="1" 555="half";
  value mnyrf 111="varied" 1="Yes";
  value mgyrf 111="varied" 300="3+" 2="2" 1="1" 555="half";
  value mtyrf 2199="other type of milk" 2109="powdered milk" 2106="soya without calcium"
	0="did not have milk" 2103="skimmed" 2108="rice/oat/vegetable milk" 2102="semiskimmed"
	2107="goat/sheep milk" 2110="cholesterol lowering milk" 2105="soya with calcium"
	222="dont know type of milk" 2104="wholemilk";
  value miyrf 400="4+" 3="3" 2="2" 1="1" 555="half";
  value mhyrf 300="3+" 2="2" 1="1" 555="half";
  value mjyrf 500="5+" 4="4" 3="3" 2="2" 1="1" 555="half" 444="quarter";
  value muyrf 500="5+" 4="4" 3="3" 2="2" 1="1" 555="half";
  value mmyrf 313="N/A" 222="Do not know" 0="No" 111="varied" 1="Yes";
run;

data outcome; 
set ukb.ukb2022 (keep=n_eid s_53_0_0 n_54_0_0 s_40021_0_0 s_40000_0_0  s_40020_0_0 s_40001_0_0 s_40001_1_0
     s_40005_0_0  s_40005_1_0 s_40005_2_0  s_40005_3_0  s_40005_4_0 
	s_40005_5_0 s_40005_6_0  s_40005_7_0  s_40005_8_0  s_40005_9_0 s_40005_10_0  s_40005_11_0  s_40005_12_0  s_40005_13_0 s_40005_14_0  s_40005_15_0  
	s_40005_16_0 s_40006_0_0 s_40006_1_0  s_40006_2_0  s_40006_3_0 s_40006_4_0  s_40006_5_0 s_40006_6_0  s_40006_7_0  s_40006_8_0  s_40006_9_0  
	s_40006_10_0 s_40006_11_0 s_40006_13_0  s_40006_15_0 s_40006_16_0 s_40013_0_0 s_40013_1_0  s_40013_2_0  s_40013_3_0  s_40013_4_0  s_40013_5_0 
	s_40013_6_0  s_40013_7_0  s_40013_8_0  s_40013_10_0 	s_40013_11_0 	s_40013_12_0  s_40013_14_0
    n_40011_0_0);

if n_54_0_0 in ("10003","11001","11002","11006","11007","11008","11009","11010","11011","11012","11013","11014"
				"11016","11017","11018","11020","11021") then orgin=1;
if n_54_0_0 in ("11004","11005") then orgin=2;
if n_54_0_0 in ("11003","11022","11023") then orgin=3 ;
RUN;
*endpoint:first diagnosis of  cancer;
data outcome1; 
set outcome;
array ICD{15} s_40006_0_0 s_40006_1_0  s_40006_2_0  s_40006_3_0  s_40006_4_0  s_40006_5_0 	s_40006_6_0  s_40006_7_0  s_40006_8_0  s_40006_9_0 
	s_40006_10_0 s_40006_11_0  s_40006_13_0  s_40006_15_0  s_40006_16_0 ;
array timed{15}  s_40005_0_0  s_40005_1_0 s_40005_2_0  s_40005_3_0  s_40005_4_0  s_40005_5_0 s_40005_6_0  s_40005_7_0  s_40005_8_0  s_40005_9_0 
	s_40005_10_0  s_40005_11_0 s_40005_13_0 s_40005_15_0 s_40005_16_0;
array Surv{15};
*diagnosis of  cancer;
do i=1 to 15;
	if  (substr(trim(ICD[i]),1,1)="C" or substr(trim(ICD[i]),1,2)="D1"  or substr(trim(ICD[i]),1,2)="D2" 
		or substr(trim(ICD[i]),1,2)="D3"  or substr(trim(ICD[i]),1,2)="D4" )
		and  substr(trim(ICD[i]),1,3)~="C44"  /*Non-malignant neoplasms,良性肿瘤（D00-D48/230-239没有被认为是cancer）*/
    then  Surv[i]=yrdif( s_53_0_0,timed[i],"actual");
end;
survtime_c=min (of Surv1-Surv15);
do j=1 to 15;
*First diagnosis of cancer;
	if Surv[j]= survtime_c and ^missing(ICD[j]) then do;

		if  substr(trim(ICD[j]),1,3) in ("C33","C34") or substr(trim(ICD[j]),1,4) in ("D021","D022","D023","D142","D143","D381") 
		then   surv_lung_c=Surv[j];/* Tracheal, bronchus, and lung cancer*/

if  substr(trim(ICD[j]),1,3)in ("C18","C19","C20","C21","D12") or substr(trim(ICD[j]),1,4) in ("D010","D011","D012","D013","D373","D374","D375") 
		then   surv_crc=Surv[j];/* Colon and rectum cancer*/

if  substr(trim(ICD[j]),1,3)="C16" or substr(trim(ICD[j]),1,4) in ("D002","D131","D371") 
		then    surv_stom_c=Surv[j];/* stomach cancer */

if  substr(trim(ICD[j]),1,3)="C61" or substr(trim(ICD[j]),1,4) in ("D075","D291","D400") 
		then      surv_pros_c=Surv[j];/*Prostate cancer*/

if  substr(trim(ICD[j]),1,3)="C25" or substr(trim(ICD[j]),1,4) in ("D136","D137") 
		then   surv_panc_c=Surv[j];/*Pancreatic cancer*/

if  substr(trim(ICD[j]),1,3)in ("C50","D05","D24")  or substr(trim(ICD[j]),1,4) in ("D486","D493") 
		then    surv_brea_c=Surv[j];/*Breast cancer*/

if  substr(trim(ICD[j]),1,3)="C15" or substr(trim(ICD[j]),1,4) in ("D001","D130") 
		then       surv_esop_c=Surv[j];/* Esophageal cancer*/

if (substr(trim(ICD[j]),1,3)="C22" or substr(trim(ICD[j]),1,4)="D134" ) and substr(trim(ICD[j]),1,4)~="C229" 
		then      surv_live_c=Surv[j];/* Liver cancer*/

if  substr(trim(ICD[j]),1,3)="C67" or substr(trim(ICD[j]),1,4) in ("D090","D303","D414","D415","D416","D417","D418","D494") 
		then      surv_blad_c=Surv[j];/* Bladder cancer*/

if  (substr(trim(ICD[j]),1,3) in ("C17","C30","C31","C37","C38","C48","C51","C52","C57",
										"C57","C60","C63","C66","C68","C75",    
										"D15","D16","D31","D36","D44")  
		or substr(trim(ICD[j]),1,4) in ("C4A","D074", "D092","D132","D133","D140","D280",
										"D281","D287","D290","D302","D304","D305","D306","D307","D308",
										"D350","D351","D352","D355","D356","D357","D358","D359",
										"D372","D382","D383","D384","D385","D392","D398","D412","D413",
										"D480","D481","D482","D483","D484") )
		and (substr(trim(ICD[j]),1,4)~="C389" and substr(trim(ICD[j]),1,4)~="C579" 
		and substr(trim(ICD[j]),1,4)~="C639" and substr(trim(ICD[j]),1,4)~="C689"  
		and substr(trim(ICD[j]),1,4)~="C759" and substr(trim(ICD[j]),1,4)~="D368" 
		and substr(trim(ICD[j]),1,4)~="D369" and substr(trim(ICD[j]),1,4)~="D449" ) then  surv_oth_c=Surv[j];/*Other malignant neoplasms*/


if  substr(trim(ICD[j]),1,3) in ("C91","C92", "C93","C95") or substr(trim(ICD[j]),1,4) in ("C940","C942") 
		then  surv_leuk=Surv[j];/* Leukemia*/

if  substr(trim(ICD[j]),1,3) in ("C82","C83", "C84","C85","C96")  or substr(trim(ICD[j]),1,4) in ("C860","C861","C862","C863","C864","C865","C866") 
		then   surv_nhod_c=Surv[j];/*Non-Hodgkin lymphoma*/

if  substr(trim(ICD[j]),1,3) in ("C23","C24") or substr(trim(ICD[j]),1,4) = "D135"
		then   surv_gall_c=Surv[j];/* Gallbladder and biliary tract cancer*/

if  substr(trim(ICD[j]),1,3) in ("C53","D06") or substr(trim(ICD[j]),1,4) ="D260"
		then   surv_cerv_c=Surv[j];/* Cervical cancer*/

if  substr(trim(ICD[j]),1,3) in ("C70","C71","C72") then   surv_brain_c=Surv[j];/*Brain and central nervous system cancer*/

    end;
   end;
drop i j Surv1-Surv15;
run;


/*endpoint:death;*/
data outcome1; 
set outcome1;
if ^missing(s_40000_0_0) then Survtime_d1=yrdif( s_53_0_0,s_40000_0_0,"actual"); /*all death.*/
/*difine Cancer reported by primary cause of death*/

if  substr(trim(s_40001_0_0),1,1)="C" or substr(trim(s_40001_0_0),1,2)="D1"  or substr(trim(s_40001_0_0),1,2)="D2" 
		or substr(trim(s_40001_0_0),1,2)="D3"  or substr(trim(s_40001_0_0),1,2)="D4" then Survtime_c2=Survtime_d1;  /*Non-malignant neoplasms,良性肿瘤（D00-D48/230-239没有被认为是cancer）*/
if  (substr(trim(s_40001_0_0),1,1)="C" or substr(trim(s_40001_0_0),1,2)="D1"  or substr(trim(s_40001_0_0),1,2)="D2" 
		or substr(trim(s_40001_0_0),1,2)="D3"  or substr(trim(s_40001_0_0),1,2)="D4" )
		and  (substr(trim(s_40001_0_0),1,3) ~="C44")  then survtime_ca2=Survtime_d1;  /*Non-malignant neoplasms,良性肿瘤（D00-D48/230-239没有被认为是cancer）*/


if  substr(trim(s_40001_0_0),1,3) in ("C33","C34") or substr(trim(s_40001_0_0),1,4) in ("D021","D022","D023","D142","D143","D381") 
		then   surv_lung_c2=Survtime_d1;/* Tracheal, bronchus, and lung cancer*/

if  substr(trim(s_40001_0_0),1,3)in ("C18","C19","C20","C21","D12") or substr(trim(s_40001_0_0),1,4) in ("D010","D011","D012","D013","D373","D374","D375") 
		then   surv_crc2=Survtime_d1;/* Colon and rectum cancer*/

if  substr(trim(s_40001_0_0),1,3)="C16" or substr(trim(s_40001_0_0),1,4) in ("D002","D131","D371") 
		then    surv_stom_c2=Survtime_d1;/* stomach cancer */

if  substr(trim(s_40001_0_0),1,3)="C61" or substr(trim(s_40001_0_0),1,4) in ("D075","D291","D400") 
		then      surv_pros_c2=Survtime_d1;/*Prostate cancer*/

if  substr(trim(s_40001_0_0),1,3)="C25" or substr(trim(s_40001_0_0),1,4) in ("D136","D137") 
		then   surv_panc_c2=Survtime_d1;/*Pancreatic cancer*/

if  substr(trim(s_40001_0_0),1,3)in ("C50","D05","D24")  or substr(trim(s_40001_0_0),1,4) in ("D486","D493") 
		then    surv_brea_c2=Survtime_d1;/*Breast cancer*/

if  substr(trim(s_40001_0_0),1,3)="C15" or substr(trim(s_40001_0_0),1,4) in ("D001","D130") 
		then       surv_esop_c2=Survtime_d1;/* Esophageal cancer*/

if (substr(trim(s_40001_0_0),1,3)="C22" or substr(trim(s_40001_0_0),1,4)="D134" ) and substr(trim(s_40001_0_0),1,4)~="C229" 
		then      surv_live_c2=Survtime_d1;/* Liver cancer*/

if  substr(trim(s_40001_0_0),1,3)="C67" or substr(trim(s_40001_0_0),1,4) in ("D090","D303","D414","D415","D416","D417","D418","D494") 
		then      surv_blad_c2=Survtime_d1;/* Bladder cancer*/

if  (substr(trim(s_40001_0_0),1,3) in ("C17","C30","C31","C37","C38","C48","C51","C52","C57",
										"C57","C60","C63","C66","C68","C75",    
										"D15","D16","D31","D36","D44")  
		or substr(trim(s_40001_0_0),1,4) in ("C4A","D074", "D092","D132","D133","D140","D280",
										"D281","D287","D290","D302","D304","D305","D306","D307","D308",
										"D350","D351","D352","D355","D356","D357","D358","D359",
										"D372","D382","D383","D384","D385","D392","D398","D412","D413",
										"D480","D481","D482","D483","D484") )
		and (substr(trim(s_40001_0_0),1,4)~="C389" and substr(trim(s_40001_0_0),1,4)~="C579" 
		and substr(trim(s_40001_0_0),1,4)~="C639" and substr(trim(s_40001_0_0),1,4)~="C689"  
		and substr(trim(s_40001_0_0),1,4)~="C759" and substr(trim(s_40001_0_0),1,4)~="D368" 
		and substr(trim(s_40001_0_0),1,4)~="D369" and substr(trim(s_40001_0_0),1,4)~="D449" ) then  surv_oth_c2=Survtime_d1;/*Other malignant neoplasms*/

if  substr(trim(s_40001_0_0),1,3) in ("C91","C92", "C93","C95") or substr(trim(s_40001_0_0),1,4) in ("C940","C942") 
		then  surv_leuk2=Survtime_d1;/* Leukemia*/

if  substr(trim(s_40001_0_0),1,3) in ("C82","C83", "C84","C85","C96")  or substr(trim(s_40001_0_0),1,4) in ("C860","C861","C862","C863","C864","C865","C866") 
		then   surv_nhod_c2=Survtime_d1;/*Non-Hodgkin lymphoma*/

if  substr(trim(s_40001_0_0),1,3) in ("C23","C24") or substr(trim(s_40001_0_0),1,4) = "D135"
		then   surv_gall_c2=Survtime_d1;/* Gallbladder and biliary tract cancer*/

if  substr(trim(s_40001_0_0),1,3) in ("C53","D06") or substr(trim(s_40001_0_0),1,4) ="D260"
		then   surv_cerv_c2=Survtime_d1;/* Cervical cancer*/

if  substr(trim(s_40001_0_0),1,3) in ("C70","C71","C72") then   surv_brain_c2=Survtime_d1;/*Brain and central nervous system cancer*/

run;
/*endpoints:censor*/

data outcome1; /* for cancer*/
set outcome1;
Survtime_e=yrdif( s_53_0_0,"31OCT2021"d,"actual");
RUN;
*outcome endpoint:stomach cancer and survive time;
data outcome2;
set outcome1;
survtime=min(of survtime_c survtime_d1 survtime_e );

 array surv{*} survtime_c surv_lung_c	surv_crc	surv_stom_c	surv_pros_c	
surv_panc_c	surv_brea_c	surv_esop_c	surv_live_c	surv_blad_c	surv_oth_c	surv_leuk	
surv_nhod_c	surv_gall_c	surv_cerv_c	surv_brain_c;
array survd{*} survtime_ca2 surv_lung_c2	surv_crc2	surv_stom_c2	surv_pros_c2	
surv_panc_c2	surv_brea_c2	surv_esop_c2	surv_live_c2	surv_blad_c2	
surv_oth_c2	surv_leuk2	surv_nhod_c2	surv_gall_c2	surv_cerv_c2	surv_brain_c2;
array ca{*} cancer lung_c	crc	stom_c	pros_c	panc_c	brea_c	esop_c	live_c	
blad_c	oth_c	leuk	nhod_c	gall_c	cerv_c	brain_c; 
do i=1 to DIM(surv); /*frist case of cancer（ICD10 OR death）*/
	if surv[i]=survtime | survd[i]=survtime then ca[i]=1;
end;

do j=1 to DIM(surv); 
	if ca[j]~=1 then ca[j]=0;
end;
run;

*Exclusion: Participants with any cancer diagnosis prior to baseline;
* according to ICD9, the cancer cases is defined;
data outcome3; /*根据ICD-9确定cancer case;*/
set outcome2;
array ICD{13} s_40013_0_0 s_40013_1_0  s_40013_2_0  s_40013_3_0  s_40013_4_0  s_40013_5_0 s_40013_6_0  s_40013_7_0  s_40013_8_0  s_40013_10_0
s_40013_11_0 	s_40013_12_0  s_40013_14_0 ;
array timed{13} s_40005_0_0  s_40005_1_0 s_40005_2_0  s_40005_3_0  s_40005_4_0  s_40005_5_0  s_40005_6_0  s_40005_7_0  s_40005_8_0  s_40005_10_0 
s_40005_11_0  s_40005_13_0 s_40005_14_0 ;
array Surv{13};
do i=1 to 13;
		if (substr(trim(ICD[i]),1,1)="1" or substr(trim(ICD[i]),1,2)="20") and substr(trim(ICD[i]),1,3)~="173" then
            ca=1;
end;
keep n_eid cancer ca survtime lung_c	crc	stom_c	pros_c	panc_c	brea_c	esop_c	live_c	
blad_c	oth_c	leuk	nhod_c	gall_c	cerv_c	brain_c;
run;

data outcome4; /*根据ICD-9确定cancer case;*/
set outcome3;
rename lung_c = lung_can;
rename crc = crc_can;
rename stom_c = stom_can;
rename pros_c = pros_can;
rename panc_c = panc_can;
rename brea_c = brea_can;
rename esop_c = esop_can;
rename live_c = live_can;
rename blad_c = blad_can;
rename oth_c = oth_can;
rename leuk = leuk_can;
rename nhod_c = nhod_can;
rename gall_c = gall_can;
rename cerv_c = cerv_can;
rename brain_c = brain_can;
rename cancer = cancer_lan;
rename survtime = survtime_can;
run;


proc freq data=outcome4;
table cancer_lan ca lung_can	crc_can	stom_can	pros_can	panc_can	brea_can	
esop_can	live_can	blad_can	oth_can	leuk_can	nhod_can	gall_can	cerv_can	brain_can;
run;

proc means data=outcome4;
var survtime_can;
run;

data cancer_phe;
set outcome4;
cancer_base=0; if ca=1 or survtime_can le 0 then cancer_base=1;
keep n_eid cancer_lan ca cancer_base survtime_can lung_can	crc_can	stom_can	pros_can	panc_can	brea_can	
esop_can	live_can	blad_can	oth_can	leuk_can	nhod_can	gall_can	cerv_can	brain_can
;
run;

proc freq data=cancer_phe;
table cancer_base cancer_lan ca lung_can	crc_can	stom_can	pros_can	panc_can	brea_can	
esop_can	live_can	blad_can	oth_can	leuk_can	nhod_can	gall_can	cerv_can	brain_can;
run;





/*endpoint:inhospital/death*/
data DID; /*endpoint:inhospital/death*/
set ukb.ukb2022 (keep=n_eid s_53_0_0 n_54_0_0    s_40020_0_0 s_40000_0_0 s_40001_0_0 s_40001_1_0 s_40002_0_1
    s_41280_0_0  s_41280_0_1  s_41280_0_2  s_41280_0_3  s_41280_0_4  s_41280_0_5 s_41280_0_6  s_41280_0_7  s_41280_0_8  s_41280_0_9 
    s_41280_0_10  s_41280_0_11  s_41280_0_12   s_41280_0_13  s_41280_0_14 s_41280_0_15  s_41280_0_16  s_41280_0_17  s_41280_0_18  s_41280_0_19  s_41280_0_20  s_41280_0_21 
	s_41280_0_22  s_41280_0_23  s_41280_0_24  s_41280_0_25 	s_41280_0_26  s_41280_0_27  s_41280_0_28  s_41280_0_29 	s_41280_0_30  s_41280_0_31  s_41280_0_32  s_41280_0_33 
	s_41280_0_34  s_41280_0_35  s_41280_0_36  s_41280_0_37 	s_41280_0_38  s_41280_0_39  s_41280_0_40  s_41280_0_41 	s_41280_0_42  s_41280_0_43  s_41280_0_44  s_41280_0_45 
	s_41280_0_46  s_41280_0_47  s_41280_0_48  s_41280_0_49 	s_41280_0_50  s_41280_0_51  s_41280_0_52  s_41280_0_53 	s_41280_0_54  s_41280_0_55  s_41280_0_56  s_41280_0_57 
	s_41280_0_58  s_41280_0_59  s_41280_0_60  s_41280_0_61	s_41280_0_62  s_41280_0_63  s_41280_0_64  s_41280_0_65 	s_41280_0_66  s_41280_0_67  s_41280_0_68  s_41280_0_69 
	s_41280_0_70  s_41280_0_71  s_41280_0_72  s_41280_0_73 	s_41280_0_74  s_41280_0_75  s_41280_0_76  s_41280_0_77 	s_41280_0_78  s_41280_0_79  s_41280_0_80  s_41280_0_81 
	s_41280_0_82  s_41280_0_83  s_41280_0_84  s_41280_0_85	s_41280_0_86  s_41280_0_87  s_41280_0_88  s_41280_0_89 	s_41280_0_90  s_41280_0_91  s_41280_0_92  s_41280_0_93 
	s_41280_0_94  s_41280_0_95  s_41280_0_96  s_41280_0_97 	s_41280_0_98  s_41280_0_99  s_41280_0_100  s_41280_0_101 	s_41280_0_102  s_41280_0_103  s_41280_0_104 
	s_41280_0_105  s_41280_0_106  s_41280_0_107 	s_41280_0_108  s_41280_0_109  s_41280_0_110 	s_41280_0_111  s_41280_0_112  s_41280_0_113 
	s_41280_0_114  s_41280_0_115  s_41280_0_116 	s_41280_0_117  s_41280_0_118  s_41280_0_119 	s_41280_0_120  s_41280_0_121  s_41280_0_122 
	s_41280_0_123  s_41280_0_124  s_41280_0_125 	s_41280_0_126  s_41280_0_127  s_41280_0_128 	s_41280_0_129  s_41280_0_130  s_41280_0_131 
	s_41280_0_132  s_41280_0_133  s_41280_0_134 	s_41280_0_135  s_41280_0_136  s_41280_0_137 	s_41280_0_138  s_41280_0_139  s_41280_0_140 
	s_41280_0_141  s_41280_0_142  s_41280_0_143 	s_41280_0_144  s_41280_0_145  s_41280_0_146 	s_41280_0_147  s_41280_0_148  s_41280_0_149 
	s_41280_0_150  s_41280_0_151  s_41280_0_152 	s_41280_0_153  s_41280_0_154  s_41280_0_155 	s_41280_0_156  s_41280_0_157  s_41280_0_158 
	s_41280_0_159  s_41280_0_160  s_41280_0_161 	s_41280_0_162  s_41280_0_163  s_41280_0_164 	s_41280_0_165  s_41280_0_166  s_41280_0_167 
	s_41280_0_168  s_41280_0_169  s_41280_0_170 	s_41280_0_171  s_41280_0_172  s_41280_0_173 	s_41280_0_174  s_41280_0_175  s_41280_0_176 
	s_41280_0_177  s_41280_0_178  s_41280_0_179 	s_41280_0_180  s_41280_0_181  s_41280_0_182 	s_41280_0_183  s_41280_0_184  s_41280_0_185 
	s_41280_0_186  s_41280_0_187  s_41280_0_188 	s_41280_0_189  s_41280_0_190  s_41280_0_191 	s_41280_0_192  s_41280_0_193  s_41280_0_194 
	s_41280_0_195  s_41280_0_196  s_41280_0_197 	s_41280_0_198  s_41280_0_199  s_41280_0_200 	s_41280_0_201  s_41280_0_202  s_41280_0_203 
	s_41280_0_204  s_41280_0_205  s_41280_0_206 	s_41280_0_207  s_41280_0_208  s_41280_0_209  s_41280_0_210  s_41280_0_211  s_41280_0_212
  	s_41270_0_0  s_41270_0_1 s_41270_0_2  s_41270_0_3  s_41270_0_4  s_41270_0_5  s_41270_0_6 	s_41270_0_7  s_41270_0_8  s_41270_0_9  s_41270_0_10  s_41270_0_11 
	s_41270_0_12  s_41270_0_13  s_41270_0_14  s_41270_0_15 	s_41270_0_16  s_41270_0_17  s_41270_0_18  s_41270_0_19 	s_41270_0_20  s_41270_0_21  s_41270_0_22  s_41270_0_23 
	s_41270_0_24  s_41270_0_25  s_41270_0_26  s_41270_0_27 	s_41270_0_28  s_41270_0_29  s_41270_0_30  s_41270_0_31 	s_41270_0_32  s_41270_0_33  s_41270_0_34  s_41270_0_35 
	s_41270_0_36  s_41270_0_37  s_41270_0_38  s_41270_0_39 	s_41270_0_40  s_41270_0_41  s_41270_0_42  s_41270_0_43 	s_41270_0_44  s_41270_0_45  s_41270_0_46  s_41270_0_47 
	s_41270_0_48  s_41270_0_49  s_41270_0_50  s_41270_0_51 	s_41270_0_52  s_41270_0_53  s_41270_0_54  s_41270_0_55 	s_41270_0_56  s_41270_0_57  s_41270_0_58  s_41270_0_59 
	s_41270_0_60  s_41270_0_61  s_41270_0_62  s_41270_0_63 	s_41270_0_64  s_41270_0_65  s_41270_0_66  s_41270_0_67 	s_41270_0_68  s_41270_0_69  s_41270_0_70  s_41270_0_71 
	s_41270_0_72  s_41270_0_73  s_41270_0_74  s_41270_0_75 	s_41270_0_76  s_41270_0_77  s_41270_0_78  s_41270_0_79 	s_41270_0_80  s_41270_0_81  s_41270_0_82  s_41270_0_83 
	s_41270_0_84  s_41270_0_85  s_41270_0_86  s_41270_0_87 	s_41270_0_88  s_41270_0_89  s_41270_0_90  s_41270_0_91 	s_41270_0_92  s_41270_0_93  s_41270_0_94  s_41270_0_95 
	s_41270_0_96  s_41270_0_97  s_41270_0_98  s_41270_0_99 	s_41270_0_100 s_41270_0_101  s_41270_0_102  s_41270_0_103 	s_41270_0_104  s_41270_0_105  s_41270_0_106  s_41270_0_107 	s_41270_0_108  s_41270_0_109  s_41270_0_110  s_41270_0_111 	s_41270_0_112  s_41270_0_113  s_41270_0_114  s_41270_0_115 	s_41270_0_116  s_41270_0_117  s_41270_0_118  s_41270_0_119 	s_41270_0_120  s_41270_0_121  s_41270_0_122  s_41270_0_123 	s_41270_0_124  s_41270_0_125  s_41270_0_126  s_41270_0_127 	s_41270_0_128  s_41270_0_129  s_41270_0_130  s_41270_0_131 
	s_41270_0_132  s_41270_0_133  s_41270_0_134  s_41270_0_135 	s_41270_0_136  s_41270_0_137  s_41270_0_138  s_41270_0_139 	s_41270_0_140  s_41270_0_141  s_41270_0_142  s_41270_0_143 	s_41270_0_144  s_41270_0_145  s_41270_0_146  s_41270_0_147 	s_41270_0_148  s_41270_0_149  s_41270_0_150  s_41270_0_151 
	s_41270_0_152  s_41270_0_153  s_41270_0_154  s_41270_0_155	s_41270_0_156  s_41270_0_157  s_41270_0_158  s_41270_0_159 	s_41270_0_160  s_41270_0_161  s_41270_0_162  s_41270_0_163 	s_41270_0_164  s_41270_0_165  s_41270_0_166  s_41270_0_167 	s_41270_0_168  s_41270_0_169  s_41270_0_170  s_41270_0_171 
	s_41270_0_172  s_41270_0_173  s_41270_0_174  s_41270_0_175 	s_41270_0_176  s_41270_0_177  s_41270_0_178  s_41270_0_179 	s_41270_0_180  s_41270_0_181  s_41270_0_182  s_41270_0_183 	s_41270_0_184  s_41270_0_185  s_41270_0_186  s_41270_0_187 	s_41270_0_188  s_41270_0_189  s_41270_0_190  s_41270_0_191 
	s_41270_0_192  s_41270_0_193  s_41270_0_194  s_41270_0_195 	s_41270_0_196  s_41270_0_197  s_41270_0_198  s_41270_0_199 	s_41270_0_200  s_41270_0_201  s_41270_0_202  s_41270_0_203 	s_41270_0_204  s_41270_0_205  s_41270_0_206  s_41270_0_207 	s_41270_0_208  s_41270_0_209  s_41270_0_210  s_41270_0_211 
	s_41270_0_212);
if ^missing(s_40000_0_0) then Survtime_d1=yrdif( s_53_0_0,s_40000_0_0,"actual"); /*all death.*/
if n_54_0_0 in ("10003","11001","11002","11006","11007","11008","11009","11010","11011","11012","11013","11014"
				"11016","11017","11018","11020","11021") then orgin=1;
if n_54_0_0 in ("11004","11005") then orgin=2;
if n_54_0_0 in ("11003","11022","11023") then orgin=3 ;
RUN;



data death_a; /*all cause-mortality and cause-specific mortality*/
set DID(keep=n_eid s_53_0_0  s_40001_0_0  orgin Survtime_d1);
/*the last time of follow up*/
Survtime_e=yrdif(s_53_0_0,"31Dec2021"d,"actual");
 Survtime_d=min(of Survtime_e  Survtime_d1);
/*array det{2}s_40001_0_0 s_40002_0_0;*/
IF Survtime_d1 le Survtime_e and ^missing(s_40001_0_0)  then do;
	    if ^missing(s_40001_0_0)                       then death=1;
		if  substr(trim(s_40001_0_0),1,1) in ("A","B") then Infect_d=1;  /*Certain infectious and parasitic diseasesA00-B99*/
		if  substr(trim(s_40001_0_0),1,1) ="C" then Cancer_d=1;  /*cancer*/
		if  substr(trim(s_40001_0_0),1,2) in ("D1","D2","D3","D4" ) then Neop_d1=1;  /*D10-D36 Benign neoplasms   D37-D48 Neoplasms of uncertain or unknown behaviour*/
	    if  substr(trim(s_40001_0_0),1,2) in ("D5", "D6", "D7", "D8" ) then Blood_d=1;  /*blood and blood-forming organs/the immune mechanism*/
	 	if  substr(trim(s_40001_0_0),1,1) ="E" then MNM_d=1;  /*Endocrine, nutritional and metabolic diseases E00-E89*/
		if  substr(trim(s_40001_0_0),1,1) ="F" then Mental_d=1;  /*Mental and behavioural disorder*/
		if  substr(trim(s_40001_0_0),1,1) ="G" then Nervous_d=1;  /* Diseases of the nervous system*/
		if  substr(trim(s_40001_0_0),1,1) ="I" then Circul_d=1;  /* Diseases of the circulatory system*/
		if  substr(trim(s_40001_0_0),1,1) ="J" then Resp_d=1;  /*  Diseases of the respiratory system*/
		if  substr(trim(s_40001_0_0),1,1) ="K" then Digest_d=1;  /*  Diseases of the digestive system*/
		if  substr(trim(s_40001_0_0),1,1) ="M" then Muscul_d=1;  /*   Diseases of the musculoskeletal system and connective tissue*/
		if  substr(trim(s_40001_0_0),1,1) ="N" then Genit_d=1;  /*   Diseases of the genitourinary system*/
		if  substr(trim(s_40001_0_0),1,1) ="V" then trans_d=1;  /* External causes of  transport accident*/
		if  substr(trim(s_40001_0_0),1,2) in ("W1","W2") then fall_d=1;  /* External causes of  fall*/
        if  substr(trim(s_40001_0_0),1,1) in ("V", "W" ,"X" ,"Y") then Exter_d=1;  /* External causes of morbidity and mortality*/
	    if  substr(trim(s_40001_0_0),1,1) in ("H", "L", "O", "Q" ,"R", "U") then Other_d=1; /*other causes of death*/
	  	if  substr(trim(s_40001_0_0),1,3) in ("I21", "I22", "I23") OR substr(trim(s_40001_0_0),1,4) in ("I241" ,"I252") then MI_d=1; 
		/*myocardial infarction codes I21, I22, I23, I24.1, or I25.2*/
		if  substr(trim(s_40001_0_0),1,3) in ("I60" ,"I61" ,"I63", "I64")  then stroke_d=1; 
		/*stroke: I60,I61, I63 and I64 */
end;

if Cancer_d=1 or Neop_d1=1 then Neop_d=1;
array dea{*} death Infect_d Cancer_d Neop_d1 Neop_d Blood_d MNM_d Mental_d Nervous_d Circul_d Resp_d Digest_d Muscul_d Genit_d trans_d fall_d Exter_d Other_d MI_d stroke_d;
do i= 1 to dim(dea);
	if dea[i]^=1 then dea[i]=0;
end;
keep n_eid Survtime_d death Infect_d Cancer_d Neop_d1 Neop_d Blood_d MNM_d Mental_d Nervous_d Circul_d Resp_d Digest_d Muscul_d Genit_d trans_d fall_d Exter_d Other_d MI_d stroke_d s_40001_0_0;
run;


data death_c; /*cancer-specific death*/
set DID(keep=n_eid s_53_0_0  s_40001_0_0  orgin Survtime_d1);
Survtime_e=yrdif( s_53_0_0,"31Dec2021"d,"actual");
 Survtime_d=min(of Survtime_e  Survtime_d1);
IF Survtime_d1 le Survtime_e and ^missing(s_40001_0_0)  then do;
	if  substr(trim(s_40001_0_0),1,1)="C"   then Cancer_d=1;  /*Non-malignant neoplasms,良性肿瘤（D00-D48/230-239没有被认为是cancer）*/
    if  substr(trim(s_40001_0_0),1,3) in ("C15""C16" "C17" "C18" "C19" "C20" "C21" "C22" "C23" "C24" "C25" "C26") then digestc_d=1;/* Malignant neoplasms of digestive organs C15-C26*/
	if  substr(trim(s_40001_0_0),1,3)="C15" then oes_d=1;/* oesophagus cancer C15*/
	if  substr(trim(s_40001_0_0),1,3)="C16" then gast_d=1 ;/* stomach cancer C16*/
	if  substr(trim(s_40001_0_0),1,3) in ("C18","C19","C20","C21") then   CRC_d=1;/*colon cancer C18*/
	if  substr(trim(s_40001_0_0),1,3)="C22" then  liver_d=1;/* liver cancer C22*/
	if  substr(trim(s_40001_0_0),1,3)="C25" then  pancre_d=1;/*pancreas cancer 25*/
	if  substr(trim(s_40001_0_0),1,3)="C34" then  lung_d=1;/*lung cancer c34*/
	if  substr(trim(s_40001_0_0),1,3)="C43" then  MM_d=1;/*Malignant melanoma cancer*/
	if  substr(trim(s_40001_0_0),1,3)="C50" then  breast_d=1;/*breast cancer C50*/
	if  substr(trim(s_40001_0_0),1,3)in ("C54","C55") then  uter_d=1;/*Uterus cancer C54--c55*/
	if  substr(trim(s_40001_0_0),1,3)="C56" then   ovar_d=1;/*ovary cancer C56*/
	if  substr(trim(s_40001_0_0),1,3)="C61" then   pros_d=1;/*prostate cancer C20*/
	if  substr(trim(s_40001_0_0),1,3)="C64" then   kidney_d=1;/*kidney, except renal pelvis cancer C64*/
	if  substr(trim(s_40001_0_0),1,3)="C67" then   bladder_d=1;/*bladder cancer C67*/
	if  substr(trim(s_40001_0_0),1,3)="C71" then   brain_d=1;/* brain cancer C71*/
	if  substr(trim(s_40001_0_0),1,3)="C73" then   thyriod_d=1;/*thyroid gland cancer C73*/
	if  substr(trim(s_40001_0_0),1,3) in ("C81","C82","C83","C84","C85","C86","C87","C88","C89","90","C91","C92","C93","C94","C95") then   LH_d=1;/*Lymphoid and haematopoietic cancer*/
   end;
array cacer{17} Cancer_d digestc_d oes_d  gast_d CRC_d liver_d pancre_d lung_d MM_d breast_d uter_d pros_d
     kidney_d bladder_d brain_d thyriod_d  LH_d;
do i =1 to 17;
	if cacer[i]^=1 then cacer[i]=0;
end;
keep n_eid Survtime_d Cancer_d digestc_d oes_d  gast_d CRC_d liver_d pancre_d lung_d MM_d breast_d uter_d pros_d
     kidney_d bladder_d brain_d thyriod_d  LH_d;
run;




data Disease1;/*Define disease:according icd10;outcome and confounder;*/
set DID ;
array hosp {213}  s_41270_0_0  s_41270_0_1 s_41270_0_2  s_41270_0_3  s_41270_0_4  s_41270_0_5  s_41270_0_6 	s_41270_0_7  s_41270_0_8  s_41270_0_9  s_41270_0_10  s_41270_0_11 
	s_41270_0_12  s_41270_0_13  s_41270_0_14  s_41270_0_15 	s_41270_0_16  s_41270_0_17  s_41270_0_18  s_41270_0_19 	s_41270_0_20  s_41270_0_21  s_41270_0_22  s_41270_0_23 
	s_41270_0_24  s_41270_0_25  s_41270_0_26  s_41270_0_27 	s_41270_0_28  s_41270_0_29  s_41270_0_30  s_41270_0_31 	s_41270_0_32  s_41270_0_33  s_41270_0_34  s_41270_0_35 
	s_41270_0_36  s_41270_0_37  s_41270_0_38  s_41270_0_39 	s_41270_0_40  s_41270_0_41  s_41270_0_42  s_41270_0_43 	s_41270_0_44  s_41270_0_45  s_41270_0_46  s_41270_0_47 
	s_41270_0_48  s_41270_0_49  s_41270_0_50  s_41270_0_51 	s_41270_0_52  s_41270_0_53  s_41270_0_54  s_41270_0_55 	s_41270_0_56  s_41270_0_57  s_41270_0_58  s_41270_0_59 
	s_41270_0_60  s_41270_0_61  s_41270_0_62  s_41270_0_63 	s_41270_0_64  s_41270_0_65  s_41270_0_66  s_41270_0_67 	s_41270_0_68  s_41270_0_69  s_41270_0_70  s_41270_0_71 
	s_41270_0_72  s_41270_0_73  s_41270_0_74  s_41270_0_75 	s_41270_0_76  s_41270_0_77  s_41270_0_78  s_41270_0_79 	s_41270_0_80  s_41270_0_81  s_41270_0_82  s_41270_0_83 
	s_41270_0_84  s_41270_0_85  s_41270_0_86  s_41270_0_87 	s_41270_0_88  s_41270_0_89  s_41270_0_90  s_41270_0_91 	s_41270_0_92  s_41270_0_93  s_41270_0_94  s_41270_0_95 
	s_41270_0_96  s_41270_0_97  s_41270_0_98  s_41270_0_99 	s_41270_0_100 s_41270_0_101  s_41270_0_102  s_41270_0_103 	s_41270_0_104  s_41270_0_105  s_41270_0_106  s_41270_0_107 	s_41270_0_108  s_41270_0_109  s_41270_0_110  s_41270_0_111 	s_41270_0_112  s_41270_0_113  s_41270_0_114  s_41270_0_115 	s_41270_0_116  s_41270_0_117  s_41270_0_118  s_41270_0_119 	s_41270_0_120  s_41270_0_121  s_41270_0_122  s_41270_0_123 	s_41270_0_124  s_41270_0_125  s_41270_0_126  s_41270_0_127 	s_41270_0_128  s_41270_0_129  s_41270_0_130  s_41270_0_131 
	s_41270_0_132  s_41270_0_133  s_41270_0_134  s_41270_0_135 	s_41270_0_136  s_41270_0_137  s_41270_0_138  s_41270_0_139 	s_41270_0_140  s_41270_0_141  s_41270_0_142  s_41270_0_143 	s_41270_0_144  s_41270_0_145  s_41270_0_146  s_41270_0_147 	s_41270_0_148  s_41270_0_149  s_41270_0_150  s_41270_0_151 
	s_41270_0_152  s_41270_0_153  s_41270_0_154  s_41270_0_155	s_41270_0_156  s_41270_0_157  s_41270_0_158  s_41270_0_159 	s_41270_0_160  s_41270_0_161  s_41270_0_162  s_41270_0_163 	s_41270_0_164  s_41270_0_165  s_41270_0_166  s_41270_0_167 	s_41270_0_168  s_41270_0_169  s_41270_0_170  s_41270_0_171 
	s_41270_0_172  s_41270_0_173  s_41270_0_174  s_41270_0_175 	s_41270_0_176  s_41270_0_177  s_41270_0_178  s_41270_0_179 	s_41270_0_180  s_41270_0_181  s_41270_0_182  s_41270_0_183 	s_41270_0_184  s_41270_0_185  s_41270_0_186  s_41270_0_187 	s_41270_0_188  s_41270_0_189  s_41270_0_190  s_41270_0_191 
	s_41270_0_192  s_41270_0_193  s_41270_0_194  s_41270_0_195 	s_41270_0_196  s_41270_0_197  s_41270_0_198  s_41270_0_199 	s_41270_0_200  s_41270_0_201  s_41270_0_202  s_41270_0_203 	s_41270_0_204  s_41270_0_205  s_41270_0_206  s_41270_0_207 	s_41270_0_208  s_41270_0_209  s_41270_0_210  s_41270_0_211 
	s_41270_0_212;
array hospt{213}  s_41280_0_0  s_41280_0_1  s_41280_0_2  s_41280_0_3  s_41280_0_4  s_41280_0_5 s_41280_0_6  s_41280_0_7  s_41280_0_8  s_41280_0_9 
    s_41280_0_10  s_41280_0_11  s_41280_0_12   s_41280_0_13  s_41280_0_14 s_41280_0_15  s_41280_0_16  s_41280_0_17  s_41280_0_18  s_41280_0_19  s_41280_0_20  s_41280_0_21 
	s_41280_0_22  s_41280_0_23  s_41280_0_24  s_41280_0_25 	s_41280_0_26  s_41280_0_27  s_41280_0_28  s_41280_0_29 	s_41280_0_30  s_41280_0_31  s_41280_0_32  s_41280_0_33 
	s_41280_0_34  s_41280_0_35  s_41280_0_36  s_41280_0_37 	s_41280_0_38  s_41280_0_39  s_41280_0_40  s_41280_0_41 	s_41280_0_42  s_41280_0_43  s_41280_0_44  s_41280_0_45 
	s_41280_0_46  s_41280_0_47  s_41280_0_48  s_41280_0_49 	s_41280_0_50  s_41280_0_51  s_41280_0_52  s_41280_0_53 	s_41280_0_54  s_41280_0_55  s_41280_0_56  s_41280_0_57 
	s_41280_0_58  s_41280_0_59  s_41280_0_60  s_41280_0_61	s_41280_0_62  s_41280_0_63  s_41280_0_64  s_41280_0_65 	s_41280_0_66  s_41280_0_67  s_41280_0_68  s_41280_0_69 
	s_41280_0_70  s_41280_0_71  s_41280_0_72  s_41280_0_73 	s_41280_0_74  s_41280_0_75  s_41280_0_76  s_41280_0_77 	s_41280_0_78  s_41280_0_79  s_41280_0_80  s_41280_0_81 
	s_41280_0_82  s_41280_0_83  s_41280_0_84  s_41280_0_85	s_41280_0_86  s_41280_0_87  s_41280_0_88  s_41280_0_89 	s_41280_0_90  s_41280_0_91  s_41280_0_92  s_41280_0_93 
	s_41280_0_94  s_41280_0_95  s_41280_0_96  s_41280_0_97 	s_41280_0_98  s_41280_0_99  s_41280_0_100  s_41280_0_101 	s_41280_0_102  s_41280_0_103  s_41280_0_104 
	s_41280_0_105  s_41280_0_106  s_41280_0_107 	s_41280_0_108  s_41280_0_109  s_41280_0_110 	s_41280_0_111  s_41280_0_112  s_41280_0_113 
	s_41280_0_114  s_41280_0_115  s_41280_0_116 	s_41280_0_117  s_41280_0_118  s_41280_0_119 	s_41280_0_120  s_41280_0_121  s_41280_0_122 
	s_41280_0_123  s_41280_0_124  s_41280_0_125 	s_41280_0_126  s_41280_0_127  s_41280_0_128 	s_41280_0_129  s_41280_0_130  s_41280_0_131 
	s_41280_0_132  s_41280_0_133  s_41280_0_134 	s_41280_0_135  s_41280_0_136  s_41280_0_137 	s_41280_0_138  s_41280_0_139  s_41280_0_140 
	s_41280_0_141  s_41280_0_142  s_41280_0_143 	s_41280_0_144  s_41280_0_145  s_41280_0_146 	s_41280_0_147  s_41280_0_148  s_41280_0_149 
	s_41280_0_150  s_41280_0_151  s_41280_0_152 	s_41280_0_153  s_41280_0_154  s_41280_0_155 	s_41280_0_156  s_41280_0_157  s_41280_0_158 
	s_41280_0_159  s_41280_0_160  s_41280_0_161 	s_41280_0_162  s_41280_0_163  s_41280_0_164 	s_41280_0_165  s_41280_0_166  s_41280_0_167 
	s_41280_0_168  s_41280_0_169  s_41280_0_170 	s_41280_0_171  s_41280_0_172  s_41280_0_173 	s_41280_0_174  s_41280_0_175  s_41280_0_176 
	s_41280_0_177  s_41280_0_178  s_41280_0_179 	s_41280_0_180  s_41280_0_181  s_41280_0_182 	s_41280_0_183  s_41280_0_184  s_41280_0_185 
	s_41280_0_186  s_41280_0_187  s_41280_0_188 	s_41280_0_189  s_41280_0_190  s_41280_0_191 	s_41280_0_192  s_41280_0_193  s_41280_0_194 
	s_41280_0_195  s_41280_0_196  s_41280_0_197 	s_41280_0_198  s_41280_0_199  s_41280_0_200 	s_41280_0_201  s_41280_0_202  s_41280_0_203 
	s_41280_0_204  s_41280_0_205  s_41280_0_206 	s_41280_0_207  s_41280_0_208  s_41280_0_209  s_41280_0_210  s_41280_0_211  s_41280_0_212;
array Surv{213};
/*end of follow-up*/
Survtime_e=yrdif(s_53_0_0,"31Dec2021"d,"actual" );

do i=1 to dim(hosp);
	/*Ischemic heart disease*/
 		 if  substr(trim(hosp[i]),1,3) in ("I20" , "I21" , "I22", "I23", "I24", "I25" )  then do ;
          isd=1;
 		 surv_isd=yrdif( s_53_0_0,hospt[i],"actual" );
	 end;


/* Stroke */ 
if  substr(trim(hosp[i]),1,3) in ( "G45","G46", "I60","I61","I62","I63","I65","I66") or 
substr(trim(hosp[i]),1,4) in ( "I670","I671","I672","I673","I675","I676","I681","I682","I690","I691","I692","I693") 
then do ; stroke =1;
surv_stroke=yrdif(s_53_0_0,hospt[i],"actual"); end;

/* Chronic obstructive pulmonary disease */ 
if  substr(trim(hosp[i]),1,3) in ( "J41","J42","J43","J44")  then do ; 
copd =1;surv_copd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Alzheimer's disease and other dementias */
if  substr(trim(hosp[i]),1,3) in (  "F00", "F01", "F03", "G30")  
or substr(trim(hosp[i]),1,4) in ( "F020","F028","F029","G310","G311","G318","G319") 
then do ; alz =1;surv_alz=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Diabetes mellitus */ 
if  (substr(trim(hosp[i]),1,3) in ( "E10","E11") or substr(trim(hosp[i]),1,4) = "P720") 
and substr(trim(hosp[i]),1,4) ~= "E102" and substr(trim(hosp[i]),1,4) ~= "E112"
then do ; diab =1;surv_diab=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Lower respiratory infections */ 
if ( substr(trim(hosp[i]),1,3) in ( "A70", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J20", "J21", "U04" ) 
or substr(trim(hosp[i]),1,4) in ( "A481","J910","P230","P231","P232","P233","P234") )
and substr(trim(hosp[i]),1,4) ~= "J159"
then do ; lres =1;surv_lres=yrdif( s_53_0_0,hospt[i],"actual"); end;


/* Falls */ if  substr(trim(hosp[i]),1,3) in ( "W00","W01","W02","W03","W04","W05","W06","W07","W08","W09","W10",
				"W11","W12","W13","W14","W15","W16","W17","W18","W19")  then do ; fall =1;surv_fall=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Chronic kidney disease */
if  (substr(trim(hosp[i]),1,3) in ( "I12","I13","N02","N03","N04","N05","N06","N07","N08","N18", "Q61","Q62")  
or substr(trim(hosp[i]),1,4) in ( "D631","E102","E112","N150"))
and substr(trim(hosp[i]),1,4) ~= "N089" and substr(trim(hosp[i]),1,4) ~= "Q629"
then do ; ckd =1;surv_ckd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Age-related hearing loss */ 
if  substr(trim(hosp[i]),1,4) = "H911"  then do ; hearl =1;surv_hearl=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Hypertensive heart disease */ 
if  substr(trim(hosp[i]),1,3) = "I11"  then do ; hhd =1;surv_hhd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Diarrheal diseases */ 
if  substr(trim(hosp[i]),1,3) in ( "A00","A01","A02","A03","A04","A05","A06","A08","A09")
or substr(trim(hosp[i]),1,4) in ( "A020","A028","A029","A029","A072","A073","A074","K521","R197")then do ;
diarr =1;surv_diarr=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Low back pain */ 
if  substr(trim(hosp[i]),1,4) ="M545"  then do ; lbpain =1;surv_lbpain=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Blindness and vision loss */ 
if  substr(trim(hosp[i]),1,3) = "H54"  then do ; visl =1;surv_visl=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Atrial fibrillation and flutter */ 
if  substr(trim(hosp[i]),1,3) ="I48"  then do ; af =1;surv_af=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Cirrhosis and other chronic liver diseases */ 
if ( substr(trim(hosp[i]),1,3) in ( "B18", "I85", "K73", "K74", "K76")
or substr(trim(hosp[i]),1,4) in ( "I982","K700","K701","K702","K703","K717","K752","K754","K755","K756","K757","K758","K759","K778") )
and substr(trim(hosp[i]),1,4) ~= "K763" then do ; 
cirr =1;surv_cirr=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Parkinson's disease */ 
if  substr(trim(hosp[i]),1,3) = "G20" or substr(trim(hosp[i]),1,4)="F023"  then do ; parkd =1;surv_parkd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Osteoarthritis */ 
if  substr(trim(hosp[i]),1,3) in ( "M15","M16","M17","M18") or substr(trim(hosp[i]),1,4) in ( "M190","M191","M192","M198","M199") then do ; 
oste =1;surv_oste=yrdif( s_53_0_0,hospt[i],"actual"); end;


/* Oral disorders */ 
if  substr(trim(hosp[i]),1,3) in ( "K12","K13" ) and substr(trim(hosp[i]),1,4) ~= "K138" and substr(trim(hosp[i]),1,4) ~= "K139" then do ; 
orald =1;surv_orald=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Tuberculosis */ 
if  substr(trim(hosp[i]),1,3) in ("A10","A11","A12","A13","A14","A15","A16","A17","A18","A19","B90") 
or substr(trim(hosp[i]),1,4) in ( "K673","K930","M490","N741","P370","U843") then do ; 
tube =1;surv_tube=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Asthma */ 
if  substr(trim(hosp[i]),1,3) in ( "J45","J46")  then do ; asth =1;surv_asth=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Road injuries */ 
if  substr(trim(hosp[i]),1,3) in ( "V01","V02","V03","V04","V06","V07","V08","V09","V80","V82")
or substr(trim(hosp[i]),1,2) in ( "V1","V2","V3","V4","V5","V6","V7")
or substr(trim(hosp[i]),1,4) in ( "V872","V873") then do ; 
roadi =1;surv_roadi=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Depressive disorders */ 
if  substr(trim(hosp[i]),1,3) in ( "F32", "F33")  then do ; depr =1;surv_depr=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Urinary diseases and male infertility */ 
if  substr(trim(hosp[i]),1,3) in ( "N10", "N11", "N12", "N15", "N16","N20","N21","N22","N25","N26","N27","N29","N31","N36","N41","N45","N49")  
or substr(trim(hosp[i]),1,4) in ( "N136","N230","N280","N281","N300","N301","N302","N303","N308","N309","N320","N323","N324","N340","N341","N342","N343","N390","N391","N392","N440")
and substr(trim(hosp[i]),1,4) ~= "N150" and substr(trim(hosp[i]),1,4) ~= "N169" then do ; 
urin =1;surv_urin=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Other musculoskeletal disorders */ 
if ( substr(trim(hosp[i]),1,3) in ( "M00","M01","M02","M07","M08","M09","M30","M31","M32","M34","M35","M36",
									"M40","M41","M42","M80","M81","M82","M88")  
or substr(trim(hosp[i]),1,4) in ( "I271","I677","L930","L931","L932","M030","M032","M033","M034","M035","M036","M430","M431",
									"M650","M710","M711","M863","M864","M870","M890","M895","M897","M898","M899") )
and (substr(trim(hosp[i]),1,4) ~= "M091" and substr(trim(hosp[i]),1,4) ~= "M099" 
and substr(trim(hosp[i]),1,4) ~= "M369" and substr(trim(hosp[i]),1,4) ~= "M829" ) then do ; 
othmus =1;surv_othmus=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Upper digestive system diseases */ 
if  substr(trim(hosp[i]),1,3) in ( "K25","K26","K27","K28","K29")  then do ; 
upped =1;surv_upped=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Endocrine, metabolic, blood, and immune disorders */ 
if ( substr(trim(hosp[i]),1,3) in ( "D66","D67","D68","D69","D70","D71","D72","D73","D74","D75","D76","D77","D78",
"E03","E04","E05","E06","E09","E16","E20","E21","E22","E23","E28","E29","E30","E31","E32","E33","E34","E36",
"E65","E66","E67","E68","E70","E71","E72","E73","E74","E75","E76","E77","E78","E79","E80","E81","E82","E83","E84",
"E88","E89","G97","I97","J95","K43","K91","K94","K95","N99")  
or substr(trim(hosp[i]),1,4) in ( "D521","D590","D592","D596","D868","D890","D891","D892","E071","E150","E240","E241","E242","E243",
"E248","E249","E850","E851","E852","G210","G211","G240","G251","G254","G256","G257","G720","G937",
"I952","I953","I989","J700","J701","J702","J703","J704","J705","K520","K627","M871","N140","N141","N142","N143","N144","N650",
"N651","P962","P965","R502") )
and (substr(trim(hosp[i]),1,4) ~= "D699" and substr(trim(hosp[i]),1,4) ~= "D703" 
and substr(trim(hosp[i]),1,4) ~= "D759" and substr(trim(hosp[i]),1,4) ~= "D789" 
and substr(trim(hosp[i]),1,4) ~= "E282" and substr(trim(hosp[i]),1,4) ~= "E340"
and substr(trim(hosp[i]),1,4) ~= "E349" and substr(trim(hosp[i]),1,4) ~= "E369"
and substr(trim(hosp[i]),1,4) ~= "K959" ) then do ; ; endo =1;surv_endo=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Cardiomyopathy and myocarditis */
if  substr(trim(hosp[i]),1,3) in ("I40","I41","I43")  
or substr(trim(hosp[i]),1,4) in ( "B332","I421","I422","I423","I424","I425","I426","I427","I428","I514")  then do ; 
cardio =1;surv_cardio=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Other cardiovascular and circulatory diseases */
if ( substr(trim(hosp[i]),1,3) in ( "I28","I30","I32","I47","I72","I77","I78","I79","I80","I81","I82","I83","I86","I87","I88","I98")  
or substr(trim(hosp[i]),1,4) in ( "I310","I311","I318","I319","I510","I511","I512","I513","I680","I890","I899","K751") )
and substr(trim(hosp[i]),1,4) ~= "I329" then do  ; othcvd =1;surv_othcvd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Neck pain */ 
if  substr(trim(hosp[i]),1,4) = "M542"  then do ; neckp =1;surv_neckp=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Non-rheumatic valvular heart disease */ 
if  substr(trim(hosp[i]),1,3) in ("I34","I35","I36","I37") and substr(trim(hosp[i]),1,4) ~= "I379" then do ; 
nrvhd =1;surv_nrvhd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Rheumatic heart disease */
if  substr(trim(hosp[i]),1,3) in ("I01", "I05","I06","I07","I08","I09") or substr(trim(hosp[i]),1,4) ="I020" then do ;
rhd =1;surv_rhd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Gallbladder and biliary diseases */ 
if  substr(trim(hosp[i]),1,3) in ("K80", "K81","K82","K83")  then do ; galld =1;surv_galld=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Paralytic ileus and intestinal obstruction */ 
if  substr(trim(hosp[i]),1,3) ="K56" then do ; parao =1;surv_parao=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Interstitial lung disease and pulmonary sarcoidosis */
if  substr(trim(hosp[i]),1,3) ="J84" or substr(trim(hosp[i]),1,4) in ( "D860","D861","D862","D869") then do ; 
intps =1;surv_intps=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Anxiety disorders */ 
if  substr(trim(hosp[i]),1,3) in ( "F40", "F41" )  then do ; anxiety =1;surv_anxiety=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Self-harm */ 
if  substr(trim(hosp[i]),1,3) in ( "X60","X61","X62","X63","X64","X66","X67","X68","X69","X70","X71","X72","X73","X74","X75",
									"X76","X77","X78","X79","X80","X81","X82","X83") or substr(trim(hosp[i]),1,4) = "Y870" then do ; 
selfh =1;surv_selfh=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Aortic aneurysm */
if  substr(trim(hosp[i]),1,3) = "I71"  then do ; aorta =1;surv_aorta=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Headache disorders */ 
if  substr(trim(hosp[i]),1,3) in ( "G43","G45")  or substr(trim(hosp[i]),1,4) in ( "G440","G441","G443","G444","G448") then do ; 
headd =1;surv_headd=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* HIV/AIDS */ 
if  substr(trim(hosp[i]),1,3) in ( "B20","B21","B22","B23","B24")  or substr(trim(hosp[i]),1,4) = "F024"
then do ; hiv =1;surv_hiv=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Alcohol use disorders */ 
if  substr(trim(hosp[i]),1,3) in ( "F10","X45","X65","Y15") 
or substr(trim(hosp[i]),1,4) in ( "E244","G312","G621","G721","P044","Q860","R780") then do ; alcod =1;surv_alcod=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Schizophrenia */ 
if  substr(trim(hosp[i]),1,3) = "F20"  then do ; schi =1;surv_schi=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Malaria */ if  substr(trim(hosp[i]),1,3) in ("B50","B51","B52","B53") or substr(trim(hosp[i]),1,4) = "B540" then do ;
malaria =1;surv_malaria=yrdif( s_53_0_0,hospt[i],"actual"); end;

/* Interpersonal violence */ 
if  substr(trim(hosp[i]),1,3) in ("X85", "X86","X87","X88","X89","X90","X91","X92","X93","X94","X95",
"X96","X97","X98","X99","Y00","Y01","Y02","Y03","Y04","Y05","Y06","Y07","Y08")  or substr(trim(hosp[i]),1,4) = "Y871" then do ; 
interv =1;surv_interv=yrdif( s_53_0_0,hospt[i],"actual"); end;
	  end;
run;


proc freq  data=Disease1;
table isd	stroke	copd	alz	diab	lres	fall	ckd	hearl	hhd	diarr	lbpain	visl	af	cirr	
parkd	oste	orald	tube	asth	roadi	depr	urin	othmus	upped	endo	cardio	othcvd	
neckp	nrvhd	rhd	galld	parao	intps	anxiety	selfh	aorta	headd	hiv	alcod			schi	malaria	interv
;
run; 

data Disease2;
set Disease1;

/*death register*/
array det{2}s_40001_0_0 s_40002_0_1;
do i=1 to 2;
	/*Ischemic heart disease*/
 		 if  substr(trim(det[i]),1,3) in ("I20" , "I21" , "I22", "I23", "I24", "I25" )  then  isd2=1;

/* Stroke */ 
if  substr(trim(det[i]),1,3) in ( "G45","G46", "I60","I61","I62","I63","I65","I66") or 
substr(trim(det[i]),1,4) in ( "I670","I671","I672","I673","I675","I676","I681","I682","I690","I691","I692","I693") then  stroke2 =1;

/* Chronic obstructive pulmonary disease */ 
if  substr(trim(det[i]),1,3) in ( "J41","J42","J43","J44")  then copd2 =1;

/* Alzheimer's disease and other dementias */
if  substr(trim(det[i]),1,3) in (  "F00", "F01", "F03", "G30")  
or substr(trim(det[i]),1,4) in ( "F020","F028","F029","G310","G311","G318","G319") then alz2 =1;
/* Diabetes mellitus */ 
if  (substr(trim(det[i]),1,3) in ( "E10","E11") or substr(trim(det[i]),1,4) = "P720") 
and substr(trim(det[i]),1,4) ~= "E102" and substr(trim(det[i]),1,4) ~= "E112" then diab2 =1;

/* Lower respiratory infections */ 
if ( substr(trim(det[i]),1,3) in ( "A70", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J20", "J21", "U04" ) 
or substr(trim(det[i]),1,4) in ( "A481","J910","P230","P231","P232","P233","P234") )
and substr(trim(det[i]),1,4) ~= "J159" then lres2 =1;


/* Falls */ if  substr(trim(det[i]),1,3) in ( "W00","W01","W02","W03","W04","W05","W06","W07","W08","W09","W10",
				"W11","W12","W13","W14","W15","W16","W17","W18","W19")  then fall2 =1;

/* Chronic kidney disease */
if  (substr(trim(det[i]),1,3) in ( "I12","I13","N02","N03","N04","N05","N06","N07","N08","N18", "Q61","Q62")  
or substr(trim(det[i]),1,4) in ( "D631","E102","E112","N150"))
and substr(trim(det[i]),1,4) ~= "N089" and substr(trim(det[i]),1,4) ~= "Q629" then ckd2 =1;

/* Age-related hearing loss */ 
if  substr(trim(det[i]),1,4) = "H911"  then hearl2 =1;

/* Hypertensive heart disease */ 
if  substr(trim(det[i]),1,3) = "I11"  then hhd2 =1;

/* Diarrheal diseases */ 
if  substr(trim(det[i]),1,3) in ( "A00","A01","A02","A03","A04","A05","A06","A08","A09")
or substr(trim(det[i]),1,4) in ( "A020","A028","A029","A029","A072","A073","A074","K521","R197")then diarr2 =1;

/* Low back pain */ 
if  substr(trim(det[i]),1,4) ="M545"  then  lbpain2 =1;

/* Blindness and vision loss */ 
if  substr(trim(det[i]),1,3) = "H54"  then  visl2 =1;

/* Atrial fibrillation and flutter */ 
if  substr(trim(det[i]),1,3) ="I48"  then af2 =1;

/* Cirrhosis and other chronic liver diseases */ 
if ( substr(trim(det[i]),1,3) in ( "B18", "I85", "K73", "K74", "K76")
or substr(trim(det[i]),1,4) in ( "I982","K700","K701","K702","K703","K717","K752","K754","K755","K756","K757","K758","K759","K778") )
and substr(trim(det[i]),1,4) ~= "K763" then cirr2 =1;

/* Parkinson's disease */ 
if  substr(trim(det[i]),1,3) = "G20" or substr(trim(det[i]),1,4)="F023"  then parkd2 =1;

/* Osteoarthritis */ 
if  substr(trim(det[i]),1,3) in ( "M15","M16","M17","M18") or substr(trim(det[i]),1,4) in ( "M190","M191","M192","M198","M199") then oste2 =1;

/* Oral disorders */ 
if  substr(trim(det[i]),1,3) in ( "K12","K13" ) and substr(trim(det[i]),1,4) ~= "K138" and substr(trim(det[i]),1,4) ~= "K139" then orald2 =1;

/* Tuberculosis */ 
if  substr(trim(det[i]),1,3) in ("A10","A11","A12","A13","A14","A15","A16","A17","A18","A19","B90") 
or substr(trim(det[i]),1,4) in ( "K673","K930","M490","N741","P370","U843") then tube2 =1;

/* Asthma */ 
if  substr(trim(det[i]),1,3) in ( "J45","J46")  then  asth2 =1;

/* Road injuries */ 
if  substr(trim(det[i]),1,3) in ( "V01","V02","V03","V04","V06","V07","V08","V09","V80","V82")
or substr(trim(det[i]),1,2) in ( "V1","V2","V3","V4","V5","V6","V7")
or substr(trim(det[i]),1,4) in ( "V872","V873") then roadi2 =1;

/* Depressive disorders */ 
if  substr(trim(det[i]),1,3) in ( "F32", "F33")  then  depr2 =1;

/* Urinary diseases and male infertility */ 
if  substr(trim(det[i]),1,3) in ( "N10", "N11", "N12", "N15", "N16","N20","N21","N22","N25","N26","N27","N29","N31","N36","N41","N45","N49")  
or substr(trim(det[i]),1,4) in ( "N136","N230","N280","N281","N300","N301","N302","N303","N308","N309","N320","N323","N324","N340","N341","N342","N343","N390","N391","N392","N440")
and substr(trim(det[i]),1,4) ~= "N150" and substr(trim(det[i]),1,4) ~= "N169" then urin2 =1;

/* Other musculoskeletal disorders */ 
if ( substr(trim(det[i]),1,3) in ( "M00","M01","M02","M07","M08","M09","M30","M31","M32","M34","M35","M36",
									"M40","M41","M42","M80","M81","M82","M88")  
or substr(trim(det[i]),1,4) in ( "I271","I677","L930","L931","L932","M030","M032","M033","M034","M035","M036","M430","M431",
									"M650","M710","M711","M863","M864","M870","M890","M895","M897","M898","M899") )
and (substr(trim(det[i]),1,4) ~= "M091" and substr(trim(det[i]),1,4) ~= "M099" 
and substr(trim(det[i]),1,4) ~= "M369" and substr(trim(det[i]),1,4) ~= "M829" ) then othmus2 =1;

/* Upper digestive system diseases */ 
if  substr(trim(det[i]),1,3) in ( "K25","K26","K27","K28","K29")  then upped2 =1;

/* Endocrine, metabolic, blood, and immune disorders */ 
if ( substr(trim(det[i]),1,3) in ( "D66","D67","D68","D69","D70","D71","D72","D73","D74","D75","D76","D77","D78",
"E03","E04","E05","E06","E09","E16","E20","E21","E22","E23","E28","E29","E30","E31","E32","E33","E34","E36",
"E65","E66","E67","E68","E70","E71","E72","E73","E74","E75","E76","E77","E78","E79","E80","E81","E82","E83","E84",
"E88","E89","G97","I97","J95","K43","K91","K94","K95","N99")  
or substr(trim(det[i]),1,4) in ( "D521","D590","D592","D596","D868","D890","D891","D892","E071","E150","E240","E241","E242","E243",
"E248","E249","E850","E851","E852","G210","G211","G240","G251","G254","G256","G257","G720","G937",
"I952","I953","I989","J700","J701","J702","J703","J704","J705","K520","K627","M871","N140","N141","N142","N143","N144","N650",
"N651","P962","P965","R502") )
and (substr(trim(det[i]),1,4) ~= "D699" and substr(trim(det[i]),1,4) ~= "D703" 
and substr(trim(det[i]),1,4) ~= "D759" and substr(trim(det[i]),1,4) ~= "D789" 
and substr(trim(det[i]),1,4) ~= "E282" and substr(trim(det[i]),1,4) ~= "E340"
and substr(trim(det[i]),1,4) ~= "E349" and substr(trim(det[i]),1,4) ~= "E369"
and substr(trim(det[i]),1,4) ~= "K959" ) then  endo2 =1;

/* Cardiomyopathy and myocarditis */
if  substr(trim(det[i]),1,3) in ("I40","I41","I43")  
or substr(trim(det[i]),1,4) in ( "B332","I421","I422","I423","I424","I425","I426","I427","I428","I514")  then cardio2 =1;

/* Other cardiovascular and circulatory diseases */
if ( substr(trim(det[i]),1,3) in ( "I28","I30","I32","I47","I72","I77","I78","I79","I80","I81","I82","I83","I86","I87","I88","I98")  
or substr(trim(det[i]),1,4) in ( "I310","I311","I318","I319","I510","I511","I512","I513","I680","I890","I899","K751") )
and substr(trim(det[i]),1,4) ~= "I329" then othcvd2 =1;

/* Neck pain */ 
if  substr(trim(det[i]),1,4) = "M542"  then neckp2 =1;

/* Non-rheumatic valvular heart disease */ 
if  substr(trim(det[i]),1,3) in ("I34","I35","I36","I37") and substr(trim(det[i]),1,4) ~= "I379" then nrvhd2 =1;

/* Rheumatic heart disease */
if  substr(trim(det[i]),1,3) in ("I01", "I05","I06","I07","I08","I09") or substr(trim(det[i]),1,4) ="I020" then rhd2 =1;

/* Gallbladder and biliary diseases */ 
if  substr(trim(det[i]),1,3) in ("K80", "K81","K82","K83")  then  galld2 =1;

/* Paralytic ileus and intestinal obstruction */ 
if  substr(trim(det[i]),1,3) ="K56" then  parao2 =1;

/* Interstitial lung disease and pulmonary sarcoidosis */
if  substr(trim(det[i]),1,3) ="J84" or substr(trim(det[i]),1,4) in ( "D860","D861","D862","D869") then intps2 =1;

/* Anxiety disorders */ 
if  substr(trim(det[i]),1,3) in ( "F40", "F41" )  then  anxiety2 =1;

/* Self-harm */ 
if  substr(trim(det[i]),1,3) in ( "X60","X61","X62","X63","X64","X66","X67","X68","X69","X70","X71","X72","X73","X74","X75",
									"X76","X77","X78","X79","X80","X81","X82","X83") or substr(trim(det[i]),1,4) = "Y870" then selfh2 =1;

/* Aortic aneurysm */
if  substr(trim(det[i]),1,3) = "I71"  then  aorta2 =1;

/* Headache disorders */ 
if  substr(trim(det[i]),1,3) in ( "G43","G45")  or substr(trim(det[i]),1,4) in ( "G440","G441","G443","G444","G448") then headd2 =1; 

/* HIV/AIDS */ 
if  substr(trim(det[i]),1,3) in ( "B20","B21","B22","B23","B24")  or substr(trim(det[i]),1,4) = "F024" then  hiv2 =1;

/* Alcohol use disorders */ 
if  substr(trim(det[i]),1,3) in ( "F10","X45","X65","Y15") 
or substr(trim(det[i]),1,4) in ( "E244","G312","G621","G721","P044","Q860","R780") then alcod2 =1;

/* Schizophrenia */ 
if  substr(trim(det[i]),1,3) = "F20"  then schi2 =1;

/* Malaria */ if  substr(trim(det[i]),1,3) in ("B50","B51","B52","B53") or substr(trim(det[i]),1,4) = "B540" then 
malaria2 =1;

/* Interpersonal violence */ 
if  substr(trim(det[i]),1,3) in ("X85", "X86","X87","X88","X89","X90","X91","X92","X93","X94","X95",
"X96","X97","X98","X99","Y00","Y01","Y02","Y03","Y04","Y05","Y06","Y07","Y08")  or substr(trim(det[i]),1,4) = "Y871" then interv2 =1;

end;
run;

data Disease3;
set Disease2;
/*Follow-up time*/
survt_isd = min ( of surv_isd Survtime_d1 Survtime_e);
survt_stroke = min ( of surv_stroke Survtime_d1 Survtime_e);
survt_copd = min ( of surv_copd Survtime_d1 Survtime_e);
survt_alz = min ( of surv_alz Survtime_d1 Survtime_e);
survt_diab = min ( of surv_diab Survtime_d1 Survtime_e);
survt_lres = min ( of surv_lres Survtime_d1 Survtime_e);
survt_fall = min ( of surv_fall Survtime_d1 Survtime_e);
survt_ckd = min ( of surv_ckd Survtime_d1 Survtime_e);
survt_hearl = min ( of surv_hearl Survtime_d1 Survtime_e);
survt_hhd = min ( of surv_hhd Survtime_d1 Survtime_e);
survt_diarr = min ( of surv_diarr Survtime_d1 Survtime_e);
survt_lbpain = min ( of surv_lbpain Survtime_d1 Survtime_e);
survt_visl = min ( of surv_visl Survtime_d1 Survtime_e);
survt_af = min ( of surv_af Survtime_d1 Survtime_e);
survt_cirr = min ( of surv_cirr Survtime_d1 Survtime_e);
survt_parkd = min ( of surv_parkd Survtime_d1 Survtime_e);
survt_oste = min ( of surv_oste Survtime_d1 Survtime_e);
survt_orald = min ( of surv_orald Survtime_d1 Survtime_e);
survt_tube = min ( of surv_tube Survtime_d1 Survtime_e);
survt_asth = min ( of surv_asth Survtime_d1 Survtime_e);
survt_roadi = min ( of surv_roadi Survtime_d1 Survtime_e);
survt_depr = min ( of surv_depr Survtime_d1 Survtime_e);
survt_urin = min ( of surv_urin Survtime_d1 Survtime_e);
survt_othmus = min ( of surv_othmus Survtime_d1 Survtime_e);
survt_upped = min ( of surv_upped Survtime_d1 Survtime_e);
survt_endo = min ( of surv_endo Survtime_d1 Survtime_e);
survt_cardio = min ( of surv_cardio Survtime_d1 Survtime_e);
survt_othcvd = min ( of surv_othcvd Survtime_d1 Survtime_e);
survt_neckp = min ( of surv_neckp Survtime_d1 Survtime_e);
survt_nrvhd = min ( of surv_nrvhd Survtime_d1 Survtime_e);
survt_rhd = min ( of surv_rhd Survtime_d1 Survtime_e);
survt_galld = min ( of surv_galld Survtime_d1 Survtime_e);
survt_parao = min ( of surv_parao Survtime_d1 Survtime_e);
survt_intps = min ( of surv_intps Survtime_d1 Survtime_e);
survt_anxiety = min ( of surv_anxiety Survtime_d1 Survtime_e);
survt_selfh = min ( of surv_selfh Survtime_d1 Survtime_e);
survt_aorta = min ( of surv_aorta Survtime_d1 Survtime_e);
survt_headd = min ( of surv_headd Survtime_d1 Survtime_e);
survt_hiv = min ( of surv_hiv Survtime_d1 Survtime_e);
survt_alcod = min ( of surv_alcod Survtime_d1 Survtime_e);


survt_schi = min ( of surv_schi Survtime_d1 Survtime_e);
survt_malaria = min ( of surv_malaria Survtime_d1 Survtime_e);
survt_interv = min ( of surv_interv Survtime_d1 Survtime_e);

	
/*case define*/
if  (isd =1 and surv_isd le survt_isd ) or ( isd2 =1 and  Survtime_d1 le survt_isd ) then isd_case =1;
if  (stroke =1 and surv_stroke le survt_stroke ) or ( stroke2 =1 and  Survtime_d1 le survt_stroke ) then stroke_case =1;
if  (copd =1 and surv_copd le survt_copd ) or ( copd2 =1 and  Survtime_d1 le survt_copd ) then copd_case =1;
if  (alz =1 and surv_alz le survt_alz ) or ( alz2 =1 and  Survtime_d1 le survt_alz ) then alz_case =1;
if  (diab =1 and surv_diab le survt_diab ) or ( diab2 =1 and  Survtime_d1 le survt_diab ) then diab_case =1;
if  (lres =1 and surv_lres le survt_lres ) or ( lres2 =1 and  Survtime_d1 le survt_lres ) then lres_case =1;
if  (fall =1 and surv_fall le survt_fall ) or ( fall2 =1 and  Survtime_d1 le survt_fall ) then fall_case =1;
if  (ckd =1 and surv_ckd le survt_ckd ) or ( ckd2 =1 and  Survtime_d1 le survt_ckd ) then ckd_case =1;
if  (hearl =1 and surv_hearl le survt_hearl ) or ( hearl2 =1 and  Survtime_d1 le survt_hearl ) then hearl_case =1;
if  (hhd =1 and surv_hhd le survt_hhd ) or ( hhd2 =1 and  Survtime_d1 le survt_hhd ) then hhd_case =1;
if  (diarr =1 and surv_diarr le survt_diarr ) or ( diarr2 =1 and  Survtime_d1 le survt_diarr ) then diarr_case =1;
if  (lbpain =1 and surv_lbpain le survt_lbpain ) or ( lbpain2 =1 and  Survtime_d1 le survt_lbpain ) then lbpain_case =1;
if  (visl =1 and surv_visl le survt_visl ) or ( visl2 =1 and  Survtime_d1 le survt_visl ) then visl_case =1;
if  (af =1 and surv_af le survt_af ) or ( af2 =1 and  Survtime_d1 le survt_af ) then af_case =1;
if  (cirr =1 and surv_cirr le survt_cirr ) or ( cirr2 =1 and  Survtime_d1 le survt_cirr ) then cirr_case =1;
if  (parkd =1 and surv_parkd le survt_parkd ) or ( parkd2 =1 and  Survtime_d1 le survt_parkd ) then parkd_case =1;
if  (oste =1 and surv_oste le survt_oste ) or ( oste2 =1 and  Survtime_d1 le survt_oste ) then oste_case =1;
if  (orald =1 and surv_orald le survt_orald ) or ( orald2 =1 and  Survtime_d1 le survt_orald ) then orald_case =1;
if  (tube =1 and surv_tube le survt_tube ) or ( tube2 =1 and  Survtime_d1 le survt_tube ) then tube_case =1;
if  (asth =1 and surv_asth le survt_asth ) or ( asth2 =1 and  Survtime_d1 le survt_asth ) then asth_case =1;
if  (roadi =1 and surv_roadi le survt_roadi ) or ( roadi2 =1 and  Survtime_d1 le survt_roadi ) then roadi_case =1;
if  (depr =1 and surv_depr le survt_depr ) or ( depr2 =1 and  Survtime_d1 le survt_depr ) then depr_case =1;
if  (urin =1 and surv_urin le survt_urin ) or ( urin2 =1 and  Survtime_d1 le survt_urin ) then urin_case =1;
if  (othmus =1 and surv_othmus le survt_othmus ) or ( othmus2 =1 and  Survtime_d1 le survt_othmus ) then othmus_case =1;
if  (upped =1 and surv_upped le survt_upped ) or ( upped2 =1 and  Survtime_d1 le survt_upped ) then upped_case =1;
if  (endo =1 and surv_endo le survt_endo ) or ( endo2 =1 and  Survtime_d1 le survt_endo ) then endo_case =1;
if  (cardio =1 and surv_cardio le survt_cardio ) or ( cardio2 =1 and  Survtime_d1 le survt_cardio ) then cardio_case =1;
if  (othcvd =1 and surv_othcvd le survt_othcvd ) or ( othcvd2 =1 and  Survtime_d1 le survt_othcvd ) then othcvd_case =1;
if  (neckp =1 and surv_neckp le survt_neckp ) or ( neckp2 =1 and  Survtime_d1 le survt_neckp ) then neckp_case =1;
if  (nrvhd =1 and surv_nrvhd le survt_nrvhd ) or ( nrvhd2 =1 and  Survtime_d1 le survt_nrvhd ) then nrvhd_case =1;
if  (rhd =1 and surv_rhd le survt_rhd ) or ( rhd2 =1 and  Survtime_d1 le survt_rhd ) then rhd_case =1;
if  (galld =1 and surv_galld le survt_galld ) or ( galld2 =1 and  Survtime_d1 le survt_galld ) then galld_case =1;
if  (parao =1 and surv_parao le survt_parao ) or ( parao2 =1 and  Survtime_d1 le survt_parao ) then parao_case =1;
if  (intps =1 and surv_intps le survt_intps ) or ( intps2 =1 and  Survtime_d1 le survt_intps ) then intps_case =1;
if  (anxiety =1 and surv_anxiety le survt_anxiety ) or ( anxiety2 =1 and  Survtime_d1 le survt_anxiety ) then anxiety_case =1;
if  (selfh =1 and surv_selfh le survt_selfh ) or ( selfh2 =1 and  Survtime_d1 le survt_selfh ) then selfh_case =1;
if  (aorta =1 and surv_aorta le survt_aorta ) or ( aorta2 =1 and  Survtime_d1 le survt_aorta ) then aorta_case =1;
if  (headd =1 and surv_headd le survt_headd ) or ( headd2 =1 and  Survtime_d1 le survt_headd ) then headd_case =1;
if  (hiv =1 and surv_hiv le survt_hiv ) or ( hiv2 =1 and  Survtime_d1 le survt_hiv ) then hiv_case =1;
if  (alcod =1 and surv_alcod le survt_alcod ) or ( alcod2 =1 and  Survtime_d1 le survt_alcod ) then alcod_case =1;


if  (schi =1 and surv_schi le survt_schi ) or ( schi2 =1 and  Survtime_d1 le survt_schi ) then schi_case =1;
if  (malaria =1 and surv_malaria le survt_malaria ) or ( malaria2 =1 and  Survtime_d1 le survt_malaria ) then malaria_case =1;
if  (interv =1 and surv_interv le survt_interv ) or ( interv2 =1 and  Survtime_d1 le survt_interv ) then interv_case =1;
run;

proc freq  data=Disease3;
table isd_case	stroke_case	copd_case	alz_case	diab_case	lres_case	fall_case	ckd_case	
hearl_case	hhd_case	diarr_case	lbpain_case	visl_case	af_case	cirr_case	parkd_case	oste_case	
orald_case	tube_case	asth_case	roadi_case	depr_case	urin_case	othmus_case	upped_case	endo_case	
cardio_case	othcvd_case	neckp_case	nrvhd_case	rhd_case	galld_case	parao_case	intps_case	anxiety_case	
selfh_case	aorta_case	headd_case	hiv_case	alcod_case			schi_case	malaria_case	interv_case
;
run;

data lancet_dis;
set Disease3;
ARRAY dis{*}  isd_case	stroke_case	copd_case	alz_case	diab_case	lres_case	fall_case	ckd_case	
hearl_case	hhd_case	diarr_case	lbpain_case	visl_case	af_case	cirr_case	parkd_case	oste_case	
orald_case	tube_case	asth_case	roadi_case	depr_case	urin_case	othmus_case	upped_case	endo_case	
cardio_case	othcvd_case	neckp_case	nrvhd_case	rhd_case	galld_case	parao_case	intps_case	anxiety_case	
selfh_case	aorta_case	headd_case	hiv_case	alcod_case			schi_case	malaria_case	interv_case;
do x=1 to dim(dis);
 if dis[x]~=1 then dis[x]=0;
end;

keep n_eid  isd_case	stroke_case	copd_case	alz_case	diab_case	lres_case	fall_case	ckd_case	
hearl_case	hhd_case	diarr_case	lbpain_case	visl_case	af_case	cirr_case	parkd_case	oste_case	
orald_case	tube_case	asth_case	roadi_case	depr_case	urin_case	othmus_case	upped_case	endo_case	
cardio_case	othcvd_case	neckp_case	nrvhd_case	rhd_case	galld_case	parao_case	intps_case	anxiety_case	
selfh_case	aorta_case	headd_case	hiv_case	alcod_case			schi_case	malaria_case	interv_case

survt_isd	survt_stroke	survt_copd	survt_alz	survt_diab	survt_lres	survt_fall	survt_ckd	survt_hearl	
survt_hhd	survt_diarr	survt_lbpain	survt_visl	survt_af	survt_cirr	survt_parkd	survt_oste	survt_orald	
survt_tube	survt_asth	survt_roadi	survt_depr	survt_urin	survt_othmus	survt_upped	survt_endo	survt_cardio	
survt_othcvd	survt_neckp	survt_nrvhd	survt_rhd	survt_galld	survt_parao	survt_intps	survt_anxiety	survt_selfh	
survt_aorta	survt_headd	survt_hiv	survt_alcod			survt_schi	survt_malaria	survt_interv
;
RUN;

proc freq data=lancet_dis;
TABLE isd_case	stroke_case	copd_case	alz_case	diab_case	lres_case	fall_case	ckd_case	
hearl_case	hhd_case	diarr_case	lbpain_case	visl_case	af_case	cirr_case	parkd_case	oste_case	
orald_case	tube_case	asth_case	roadi_case	depr_case	urin_case	othmus_case	upped_case	endo_case	
cardio_case	othcvd_case	neckp_case	nrvhd_case	rhd_case	galld_case	parao_case	intps_case	anxiety_case	
selfh_case	aorta_case	headd_case	hiv_case	alcod_case			schi_case	malaria_case	interv_case;
RUN;

proc sort data=lancet_dis	;
by  n_eid;
run;

proc sort data=cancer;
by n_eid;
run;

data lancet_dis60; *60 major diseases from Global Burden of Disease Study 2019; 
merge cancer_phe lancet_dis;
BY n_eid;
run;

proc export  /*data20201230*/
	data=lancet_dis60
	outfile='E:\biobank\usedata\lancet_dis60.csv'
	dbms=csv replace;
run;


data demo; /*demographic  variables*/
set ukb.ukb2022 (keep=n_eid n_31_0_0 n_54_0_0 n_21003_0_0 n_6138_0_0 n_21000_0_0 n_26410_0_0 n_26426_0_0 n_26427_0_0 n_738_0_0);
if  n_6138_0_0 lt 0 then n_6138_0_0 =99; 
if substr(left(n_21000_0_0),1,1)="1" then eth=1;
	else if substr(left(n_21000_0_0),1,1)="2" then eth=2;
	else if substr(left(n_21000_0_0),1,1)="3" then eth=3;
	else if substr(left(n_21000_0_0),1,1)="4" then eth=4;
	else if n_21000_0_0=5 then eth=5;
	else if n_21000_0_0=6 then eth=6;
	else eth=99;
rename n_31_0_0=gender n_21003_0_0=age n_6138_0_0=edu n_738_0_0=income n_54_0_0=centre;
IDM=n_26410_0_0; if  missing(IDM) then  IDM=n_26426_0_0;if  missing(IDM) then  IDM=n_26427_0_0;  
if n_738_0_0 <0 then n_738_0_0=99;
if n_54_0_0 in ("10003","11001","11002","11006","11007","11008","11009","11010","11011","11012","11013","11014"
				"11016","11017","11018","11020","11021") then orgin=1;
if n_54_0_0 in ("11004","11005") then orgin=2;
if n_54_0_0 in ("11003","11022","11023") then orgin=3 ;
/*eth9*/
eth9=1;
if n_21000_0_0="3001" then eth9=2;/*indian*/
if n_21000_0_0="3002" then eth9=3;/*Pakistani*/
if n_21000_0_0="3003" then eth9=4;/*Bangladeshi*/
if n_21000_0_0 in ("3","3004") then eth9=5;/*indian*/
if n_21000_0_0="4001" then eth9=6;/*Caribbean*/
if n_21000_0_0="4002" then eth9=7;/*indian*/
if n_21000_0_0=5 then eth9=8;/*Chinese*/
if n_21000_0_0 in ("2","2003","2002","2004","2002","4","4003","6") then eth9=9;/*other*/

drop n_26410_0_0 n_26426_0_0 n_26427_0_0 n_21000_0_0;
run;

data lifestyle; /* diet, physical activity, salt ,smoking, drinking*/
set ukb.ukb2022 (keep=n_eid n_22040_0_0 n_22032_0_0 n_22040_0_0 n_1289_0_0 n_1299_0_0  n_1309_0_0 n_1319_0_0  
                          n_1329_0_0  n_1339_0_0  n_1349_0_0  n_1359_0_0  n_1369_0_0  n_1379_0_0  n_1389_0_0
                          n_1408_0_0  n_1418_0_0  n_1428_0_0  n_1438_0_0  n_1448_0_0  n_1458_0_0    n_1468_0_0 
						  n_1478_0_0  n_1488_0_0  n_1498_0_0  n_1508_0_0  n_1518_0_0  n_1528_0_0    n_1538_0_0 n_1548_0_0 n_1558_0_0
                          n_20116_0_0 n_3456_0_0  n_2897_0_0
                          n_3680_0_0  n_6144_0_0 n_10855_0_0  n_2654_0_0  n_10767_0_0 n_10776_0_0    n_10776_0_0
                          n_20117_0_0	n_1558_0_0	n_3731_0_0	n_4407_0_0	n_4418_0_0	n_4429_0_0	n_4440_0_0	n_4451_0_0	n_4462_0_0	
                          n_1568_0_0	n_1578_0_0	n_1588_0_0	n_1598_0_0	n_1608_0_0	n_5364_0_0	n_1618_0_0	n_1628_0_0
      					  n_22038_0_0   n_22039_0_0  n_22040_0_0);
array fru{4} n_1309_0_0 n_1319_0_0 n_1299_0_0 n_1289_0_0;
/*crate a new variable:fruit_g. it combine fresh/dried fruit, salad and cooked/rawvegetables,and  
means the fruit and vegetable intake per day;
Notice：a portion is a piece of freash fruit or a pieces of  dried fruit
or three  heaped tablespoons of salad  or cooked/raw vegetables;
Each piece of fruit counted as one portion;
a portion of vegetables is three heaped tablespoons vegetables;
According to UK guideline, this variable was categorised into two groups:<5 portion or >=5;*/
do i =1 to 4;
	if fru[i]=-10 then fru[i]=0;
	if fru[i] in (-3,-1) then fru[i]=.; 
end;
/*do j =1 to 4;
	if index=1 and fru[j] lt 0 then fru[j]=0;
end;*/
F_V_t=fru[1]+fru[2] + (fru[3] + fru[4])/3;
fruit=fru[1]+fru[2] ;
fruit_S=fru[1]+(fru[2])/5;
vageta=(fru[3] + fru[4])/3;
F_V_S=fru[1]+(fru[2])/5 + (fru[3] + fru[4])/3;
/*(Amount per serving: fresh fruit – 1 piece; dried fruit – 5 pieces; cooked/raw vegetables- 3 heaped tablespoons)*/
IF n_1309_0_0 GE 0 THEN fruit_fs=n_1309_0_0;   if n_1309_0_0 lt 0 THEN fruit_fs=.;
IF n_1319_0_0 GE 0 THEN fruit_ds=n_1319_0_0/5; if n_1319_0_0 lt 0 THEN fruit_ds=.;

if F_V_t GE 5 then fruit_g=1;
if F_V_t lt 5 and ~missing(F_V_t)then fruit_g=0;
if missing(F_V_t) then fruit_g=99;
*IPAQ activity group:MET group,salt_add, smoking status, drinking consumption ;
if missing(n_22032_0_0) then n_22032_0_0=99;

if missing(n_22038_0_0) then n_22038_0_0=0;
if missing(n_22039_0_0) then n_22039_0_0=0;
phy_cat=0; 
if n_22038_0_0>=150 or n_22039_0_0>=150 or (n_22038_0_0+n_22039_0_0)>=150 then phy_cat=1;

/*Whole grains intake*/
if n_1438_0_0 GE 0 then Bread_I=n_1438_0_0; ELSE IF n_1438_0_0 =-10 then Bread_I=0; ELSE IF n_1438_0_0 in (-3,-1) then Bread_I=.;
if Bread_I GE 0 then wholegrain_b=0; if n_1448_0_0=3  then wholegrain_b=Bread_I/7;

/*Bran/oat/muesli cereal– 1 bowl/day*/
if n_1458_0_0 GE 0 then Cereal_I=n_1458_0_0; ELSE IF n_1458_0_0 =-10 then Cereal_I=0; ELSE IF n_1458_0_0 in (-3,-1) then Cereal_I=.;
if Cereal_I GE 0 then Bran_b=0; if n_1468_0_0 in (1,3,4) then Bran_b=Cereal_I/7;

grain_W=wholegrain_b+Bran_b;

/*red meat and process meat*/
proc_m=n_1349_0_0;
bf=n_1369_0_0;  
lb=n_1379_0_0;
pk=n_1389_0_0;
array lidd{*} bf lb pk  proc_m n_1329_0_0  n_1339_0_0;
do i= 1 to dim(lidd);
	if lidd[i]<0 then lidd[i]=0;
	if lidd[i]=0 then lidd[i]=0;
	if lidd[i]=1 then lidd[i]=0.5;
	if lidd[i]=2 then lidd[i]=1;
	if lidd[i]=3 then lidd[i]=3;
	if lidd[i]=4 then lidd[i]=5.5;
	if lidd[i]=5 then lidd[i]=7;
end;
/*fish*/
fish=n_1329_0_0+n_1339_0_0;

/*red meat*/   
meat_rd=bf+ lb+ pk;
meat_rdc=0;
if meat_rd ge 3 then meat_rdc =4;
if meat_rd lt 3 then meat_rdc =3;
if meat_rd lt 2 then meat_rdc =2;
if meat_rd lt 1 then meat_rdc =1;

/*red meat and process meat*/
meat_rdP=bf+ lb+ pk+proc_m;

meat_rdPc=99;
if meat_rdP ge 4 then meat_rdPc =4;
if meat_rdP lt 4 then meat_rdPc =3;
if meat_rdP lt 3 then meat_rdPc =2;
if meat_rdP lt 2 then meat_rdPc =1;


IF missing(bf) and missing(lb) and missing(pk) then do ;meat_rdc=99; meat_rd=.;end;
array liff{*} n_1478_0_0 n_20116_0_0 n_1558_0_0 ;
do i= 1 to dim(liff);
	if liff[i]<0 or missing(liff[i]) then liff[i]=99;
end;

/*Processed meat intake*/
meat_PC=n_1349_0_0;
if n_1349_0_0 in (0,1) then meat_PC=1; IF n_1349_0_0 in (4,5) then meat_PC=4; IF n_1349_0_0 in (-1,-3) THEN meat_PC=.;


/*Alcohol intake (g/day)*/

array aclm {6} n_4407_0_0	n_4418_0_0	n_4429_0_0	n_4440_0_0	n_4451_0_0	n_4462_0_0;	
array aclw {6} n_1568_0_0	n_1578_0_0	n_1588_0_0	n_1598_0_0	n_1608_0_0  n_5364_0_0;

do i =1 to 5;
	if aclm[i] in (-3,-1) then aclm[i]=.; 
	if aclw[i] in (-3,-1) then aclw[i]=.; 
end;
if aclm[6] in (-3,-1) OR missing(aclm[6]) then aclm[6]=0;
if aclw[6] in (-3,-1) OR missing(aclw[6]) then aclw[6]=0;
acl=((aclw[1]+aclw[2]+aclw[4]+aclw[5]+aclw[6])*10+aclw[3]*20)/7;
if missing(acl) then acl=((aclm[1]+aclm[2]+aclm[4]+aclm[5]+aclm[6])*10+aclm[3]*20)/30.4375;



/*dairy milk*/
array mlk {3} n_1458_0_0  n_1488_0_0  n_1498_0_0;
do i =1 to 3;
	if mlk[i] in (-3,-1) then mlk[i]=.; 
	if mlk[i] =-10 then mlk[i]=0; 
end;
if  n_1418_0_0 in (1,2,3) then milk=mlk[1]*100+mlk[2]*35+mlk[3]*25;

if  milk ge 300 then milkC=3;
if  milk lt 300 and milk ge 150 then milkC=2;
if  milk lt 150 and milk gt 0 then milkC=1;
if  n_1418_0_0=6 then milkC=0;

/*Cheese*/
CheeseC=n_1408_0_0;
if n_1408_0_0 in (0,1) then CheeseC=1; IF n_1408_0_0 in (4,5) then CheeseC=4; IF n_1408_0_0 in (-1,-3) THEN CheeseC=.;

/*tea*/
tea=n_1488_0_0;
if n_1488_0_0=-10 then tea=0;
if n_1488_0_0 in (-1,-3) then tea=.;

/*coffee*/
coffee=n_1498_0_0;
if n_1498_0_0=-10 then coffee=0;
if n_1498_0_0 in (-1,-3) then coffee=.;

/*water intake*/
water=n_1528_0_0;
if n_1528_0_0=-10 then water=0;
if n_1528_0_0 in (-1,-3) then water=.;


/*smoking status:five category*/
if n_20116_0_0=0    then smk5=1;
if n_20116_0_0=1    then smk5=2;
if n_20116_0_0=2    then smk5=3;
if n_3456_0_0 le 9 and  n_3456_0_0 gt 0  then smk5=3;
if n_3456_0_0 gt 9  then smk5=4;
if n_3456_0_0 gt 19  then smk5=5;

rename  n_22040_0_0=MET   n_22032_0_0 =MET_g  n_1478_0_0=salt    n_20116_0_0=smoking n_1558_0_0=drinking
        n_1329_0_0=Fish_O n_1339_0_0=Fish_NO  n_1349_0_0=meat_P  n_1359_0_0=Poultry
        n_1369_0_0=beef   n_1379_0_0=Lamb     n_1389_0_0=Pork	 n_1408_0_0=Cheese
        n_1418_0_0=Milk_T n_1428_0_0=spread_T     ;
keep n_eid fruit vageta F_V_t  fruit_S  F_V_S  fruit_g fish grain_W Cereal_I Bread_I acl   
     n_22032_0_0 n_22040_0_0    n_1478_0_0 n_20116_0_0 n_1558_0_0 
     n_1329_0_0  n_1339_0_0  n_1349_0_0  n_1359_0_0  n_1369_0_0  n_1379_0_0  n_1389_0_0
     n_1408_0_0  n_1418_0_0  n_1428_0_0  n_1438_0_0  n_1448_0_0  n_1458_0_0    n_1468_0_0 
	 n_1478_0_0  n_1488_0_0  n_1498_0_0  n_1508_0_0  n_1518_0_0  n_1528_0_0    n_1538_0_0 n_1548_0_0
     n_2654_0_0  n_2897_0_0  phy_cat  n_22038_0_0  n_22039_0_0  n_22040_0_0  proc_m
     meat_rd meat_rdP meat_rdc meat_rdPc  smk5 meat_PC CheeseC tea coffee water n_1309_0_0 n_1319_0_0 n_1299_0_0 n_1289_0_0;
run;

proc freq data=lifestyle;
table smoking drinking meat_rdc meat_rdPc smk5 Cheese  spread_T  acl F_V_S grain_W fish meat_P meat_PC CheeseC Cheese n_2897_0_0
n_1309_0_0 n_1319_0_0 n_1299_0_0 n_1289_0_0   Cereal_I Bread_I F_V_S;
run;
proc sort data=lifestyle;
by n_eid;
run;


proc export  
	data=lifestyle
	outfile='E:\biobank\usedata\lifestyle.csv'
	dbms=csv;
run;
