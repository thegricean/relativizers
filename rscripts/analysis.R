# created by jdegen on 09/11/2015
theme_set(theme_bw(18))
setwd("~/cogsci/projects/stanford/projects/relativizers/")
source("rscripts/helpers.r")

load("data/d.RData")

# from john's notes:
# Variant ~ Head Specificity + Matrix Clause + Adjacency + Antecedent +  
# RC Subject + RC Length + Gender + Age + Speaker Gender + Speaker Age +
#  Speaker ID as a random effect

d$reducedRelativizer = as.factor(ifelse(d$Relativizer == "0","absent","present"))
d$RClength = as.numeric(as.character(d$RClength))
d$reducedRCSubj = as.factor(ifelse(d$RCSubj == "other","other","pronoun"))
d$Speaker_Age = as.numeric(as.character(d$Speaker_Age))
d$Speaker_education = as.numeric(as.character(d$Speaker_education))
d$logRClength = log(d$RClength)
d = subset(d, Speaker_education != 9) # exclude 25 cases where speaker education was unknown
d = subset(d, Speaker_dialect != "UNK" & Speaker_dialect != "MIXED") # exclude 224 cases where speaker dialect was either unknown or mixed
d$reducedMatrixClauseType = d$Matrix.Clause.Type
d[d$reducedMatrixClauseType =="lonehead",]$reducedMatrixClauseType = "other"
d[d$reducedMatrixClauseType == "cleft",]$reducedMatrixClauseType = "existential"
d = droplevels(d) 
nrow(d) # 2841 cases left

# if you want to do the analysis without wh:
#d_nowh = droplevels(subset(d, Relativizer != "wh"))
#nrow(d_nowh) # 2521 cases left

length(unique(d$Speaker_ID))

d_subj = subset(d, RCType == "subject")
d_nsubj = subset(d, RCType == "non-subject")

length(unique(d_subj$Speaker_ID))
length(unique(d_nsubj$Speaker_ID))

centered = cbind(d_nsubj, myCenter(d_nsubj[,c("HeadSpecificity","Adjacency","RClength","Speaker_sex","Speaker_Age","Speaker_education","reducedRCSubj")]))
summary(centered)

pairscor.fnc(centered[,c("HeadSpecificity","Adjacency","RClength","Speaker_sex","Speaker_Age","Speaker_education","reducedRCSubj","Matrix.Clause.Type","Type.of.Antecedent")])

# uncentered, only non-subj
m = glmer(reducedRelativizer ~ HeadSpecificity  + reducedMatrixClauseType +  Adjacency + reducedRCSubj +Type.of.Antecedent  +  logRClength + Speaker_sex + Speaker_Age  + Speaker_education  + (1|Speaker_ID),data=centered,family="binomial")
summary(m)

# socio variable interactions do nothing
m = glmer(reducedRelativizer ~ HeadSpecificity +  Adjacency + Type.of.Antecedent + reducedRCSubj + RClength + Speaker_sex*Speaker_Age*Speaker_education + (1|Speaker_ID),data=centered,family="binomial")
summary(m)


# WHOLE DATASET
centered = cbind(d, myCenter(d[,c("HeadSpecificity","Adjacency","logRClength","Speaker_sex","Speaker_Age","Speaker_education","reducedRCSubj")]))
summary(centered)
m = glmer(reducedRelativizer ~ RCType + HeadSpecificity +  Adjacency + Type.of.Antecedent  + logRClength + Speaker_sex + Speaker_Age + Speaker_education + Speaker_dialect + (1|Speaker_ID),data=centered,family="binomial")
summary(m)

m = glmer(reducedRelativizer ~ RCType*(cHeadSpecificity +  cAdjacency  + clogRClength + cSpeaker_sex + cSpeaker_Age + as.factor(Speaker_education)) + (1|Speaker_ID),data=centered,family="binomial")
summary(m)


