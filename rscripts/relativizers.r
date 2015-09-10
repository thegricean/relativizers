# created by jdegen on 09/09/2015
theme_set(theme_bw(18))
setwd("~/cogsci/projects/stanford/projects/relativizers/")
source("rscripts/helpers.r")

load("data/d.RData")

d_subj = read.table(file="data/rc_subject.results.txt",sep="\t", header=T, quote="")
nrow(d_subj)
d_subj$RCSubjType = "NA"
d_subj$RCSubj = "NA"
d_subj$RCType = "subject"
d_nonsubj = read.table(file="data/rc_nonsubject.results.txt",sep="\t", header=T, quote="")
d_nonsubj$RCType = "non-subject"
d_nonsubj$CorrectedRCLength =-555
d_nonsubj$Matrix.Clause.Type = d_nonsubj$Matrix.Clause.Structure
d_nonsubj$Matrix.Clause.Structure = NULL

nrow(d_nonsubj)

d = merge(d_subj,d_nonsubj,all=T)
nrow(d)

# columns of interest: 
# HeadSpecificity  Matrix.Clause.Type	Adjacency	Type.of.Antecedent	Relativizer	RClength	CorrectedRClength Speaker_ID  Speaker_sex Speaker_Age  Speaker_dialect	Speaker_education

d = d[,c("HeadSpecificity","Matrix.Clause.Type","Adjacency","Type.of.Antecedent","Relativizer","RClength","CorrectedRClength","Speaker_ID","Speaker_sex","Speaker_Age","Speaker_dialect","Speaker_education","RCType")]
head(d)
summary(d)
d$Speaker_sex=gsub("\"","",d$Speaker_sex)
d$Speaker_sex=as.factor(as.character(gsub(" ","",d$Speaker_sex)))
d$Speaker_dialect=gsub("\"","",d$Speaker_dialect)
d$Speaker_dialect=as.factor(as.character(gsub(" ","",d$Speaker_dialect)))
d$Matrix.Clause.Type=gsub("\"","",d$Matrix.Clause.Type)
d$Matrix.Clause.Type=as.factor(as.character(gsub(" ","",d$Matrix.Clause.Type)))
d$Adjacency=gsub("\"","",d$Adjacency)
d$Adjacency=as.character(gsub(" ","",d$Adjacency))
d[grep("adj",d$Adjacency),]$Adjacency = 0
d$Adjacency = as.numeric(as.character(d$Adjacency))
d$BinnedAdjacency = cut(d$Adjacency,breaks=c(-0.1,0,1,2,4,19))
d$BinnedRClength = cut(as.numeric(as.character(d$RClength)),breaks=c(-0.1,2,3,4,5,7,10,20,65))
d$BinnedAge = cut(d$Speaker_Age,breaks=5)
d[d$Type.of.Antecedent == "superlative",]$Type.of.Antecedent = "unique"
d[d$Type.of.Antecedent == "indefinte",]$Type.of.Antecedent = "indefinite"
d[d$Matrix.Clause.Type == "loneNP",]$Matrix.Clause.Type = "lonehead"
d$OriginalRelativizer = d$Relativizer
d$Relativizer = as.character(d$OriginalRelativizer)
d[d$Relativizer %in% c("who","which"),]$Relativizer = "wh"
d$Relativizer = as.factor(d$Relativizer)
d = droplevels(d)
summary(d)

save(d, file="data/d.RData")

######################################################
################### PLOTS ############################
######################################################

# PLOT OF RELATIVIZER DISTRIBUTION BY RC TYPE
t = as.data.frame(prop.table(table(d$Relativizer,d$RCType),mar=c(2)))
t
colnames(t)=c("Relativizer","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$RCType))
row.names(f) = paste(f$Var1,f$Var2)
t$Frequency = f[paste(t$Relativizer,t$RCType),]$Freq
head(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_wrap(~RCType) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype.pdf")
ggsave("graphs/relativizer_distribution_byrctype.jpg",width=5)

# PLOT BY SEX
# there seem to be no sex differences
t = as.data.frame(prop.table(table(d$Relativizer,d$Speaker_sex,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","Sex","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$Speaker_sex,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$Sex,t$RCType),]$Freq
head(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~Sex) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_bysex.pdf")
ggsave("graphs/relativizer_distribution_byrctype_bysex.jpg",width=5)

# PLOT BY DIALECT
# the only dialect that seems to go against the trend is New England
t = as.data.frame(prop.table(table(d$Relativizer,d$Speaker_dialect,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","Dialect","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$Speaker_dialect,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$Dialect,t$RCType),]$Freq
head(t)
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~Dialect) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_bydialect.pdf",width=19)
ggsave("graphs/relativizer_distribution_byrctype_bydialect.jpg",width=15)

# PLOT BY AGE
# there may be a higher incidence of "that"s  in the oldest age group for both sbj and non-sbj RCs -- will be interesting to see if this comes out in the analysis or is just an artefact of one or two idiosyncratic old speakers

t = as.data.frame(prop.table(table(d$Relativizer,d$BinnedAge,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","Age","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$BinnedAge,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$Age,t$RCType),]$Freq
head(t)
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~Age) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_byage.pdf",width=15)
ggsave("graphs/relativizer_distribution_byrctype_byage.jpg",width=12)

# PLOT BY EDUCATION
# for non-sbj RCs, there seem to be more nulls / fewer "that"s with increasing education level
# for sbj RCs, it's harder to see a clear pattern
t = as.data.frame(prop.table(table(d$Relativizer,d$Speaker_education,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","Education","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$Speaker_education,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$Education,t$RCType),]$Freq
head(t)
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~Education) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_byeducation.pdf",width=15)
ggsave("graphs/relativizer_distribution_byrctype_byeducation.jpg",width=12)

# PLOT BY ANTECEDENT TYPE
# antecedent seems to matter quite a bit for non-subject RCs, but not for subject RCs
t = as.data.frame(prop.table(table(d$Relativizer,d$Type.of.Antecedent,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","Type.of.Antecedent","RCType","Proportion")
t$Antecedent = factor(x=as.character(t$Type.of.Antecedent),levels=c("indefinite","definite","pronoun","unique"))
f = as.data.frame(table(d$Relativizer, d$Type.of.Antecedent,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$Type.of.Antecedent,t$RCType),]$Freq
head(t)
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~Antecedent) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_byantecedent.pdf",width=15)
ggsave("graphs/relativizer_distribution_byrctype_byantecedent.jpg",width=9)

# PLOT BY MATRIX CLAUSE TYPE
# matrix clause type seems to matter
t = as.data.frame(prop.table(table(d$Relativizer,d$Matrix.Clause.Type,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","Matrix.Clause.Type","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$Matrix.Clause.Type,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$Matrix.Clause.Type,t$RCType),]$Freq
head(t)
t$MatrixClause = factor(x=as.character(t$Matrix.Clause.Type),levels=c("cleft","possessive","existential","other","lonehead","copula"))
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~MatrixClause) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_bymatrixclause.pdf",width=15)
ggsave("graphs/relativizer_distribution_byrctype_bymatrixclause.jpg",width=12)

# PLOT BY HEAD SPECIFICITY
# head specificity seems to matter: for non-subject RCs, more null than "that"s for empty heads; reverse for nonempty heads.
# for subject RCs, there appears to be a greater incidence of "who"s with empty heads (maybe because there's a lot of empty animate heads like "guy"?)
t = as.data.frame(prop.table(table(d$Relativizer,d$HeadSpecificity,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","HeadSpecificity","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$HeadSpecificity,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$HeadSpecificity,t$RCType),]$Freq
head(t)
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~HeadSpecificity) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_byheadspecificity.pdf",width=7)
ggsave("graphs/relativizer_distribution_byrctype_byheadspecificity.jpg",width=7)

# PLOT BY ADJACENCY
# there appear to be more "that"s with increasing amount of intervening material, and fewer nulls (non-sbj) / fewer "who"s (sbj)
t = as.data.frame(prop.table(table(d$Relativizer,d$BinnedAdjacency,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","Adjacency","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$BinnedAdjacency,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$Adjacency,t$RCType),]$Freq
head(t)
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~Adjacency) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_byadjacency.pdf",width=12)
ggsave("graphs/relativizer_distribution_byrctype_byadjacency.jpg",width=12)

# PLOT BY RClength
# there appear to be more "that"s & fewer nulls with increasing RC length for sbj RCs, and the opposite for non-sbj RCs: fewer "that"s and more "who"s
t = as.data.frame(prop.table(table(d$Relativizer,d$BinnedRClength,d$RCType),mar=c(2,3)))
t
colnames(t)=c("Relativizer","RClength","RCType","Proportion")
f = as.data.frame(table(d$Relativizer, d$BinnedRClength,d$RCType))
row.names(f) = paste(f$Var1,f$Var2,f$Var3)
t$Frequency = f[paste(t$Relativizer,t$RClength,t$RCType),]$Freq
head(t)
t = na.omit(t)

ggplot(t,aes(x=Relativizer,y=Proportion)) +
  geom_bar(stat="identity") +
  facet_grid(RCType~RClength) +
  geom_text(aes(label=Frequency,y=Proportion+.1))
ggsave("graphs/relativizer_distribution_byrctype_byrclength.pdf",width=16)
ggsave("graphs/relativizer_distribution_byrctype_byrclength.jpg",width=13)





