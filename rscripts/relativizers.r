theme_set(theme_bw(18))
setwd("~/cogsci/projects/stanford/projects/relativizers/")
source("rscripts/helpers.r")

load("data/r.RData")

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

summary(d)

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

# PLOT BY SEX
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

# PLOT BY DIALECT
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

# PLOT BY AGE
d$BinnedAge = cut(d$Speaker_Age,breaks=5)
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

# PLOT BY EDUCATION
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



