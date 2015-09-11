# Preliminary results of Switchboard relativizer study

Plotted are the distributions of relativizers (in proportions) across different variables. Numbers above the bars indicate the number of contributing cases. This is to facilitate making sense of what look like differences from looking at the height of the bars: the greater the number of contributing cases, the more likely the difference is real. 

So far I have just created visualizations of the data and haven't conducted any sort of statistical analysis, so the language describing the patterns in the plots is deliberately hedging.

## OVERALL RELATIVIZER DISTRIBUTION BY RC TYPE

![](/graphs/relativizer_distribution_byrctype.jpg)

## Social variables


### RELATIVIZER DISTRIBUTION BY SEX

There seem to be no sex differences.

![](/graphs/relativizer_distribution_byrctype_bysex.jpg)

### RELATIVIZER DISTRIBUTION BY DIALECT
 
The only dialect that seems to go against the trend is New England.

![](/graphs/relativizer_distribution_byrctype_bydialect.jpg)

### RELATIVIZER DISTRIBUTION BY AGE

There may be a higher incidence of "that"s  in the oldest age group for both sbj and non-sbj RCs -- will be interesting to see if this comes out in the analysis or is just an artefact of one or two idiosyncratic old speakers.

![](/graphs/relativizer_distribution_byrctype_byage.jpg)

### RELATIVIZER DISTRIBUTION BY EDUCATION

For non-sbj RCs, there seem to be more nulls / fewer "that"s with increasing education level. For sbj RCs, it's harder to see a clear pattern.
![](/graphs/relativizer_distribution_byrctype_byeducation.jpg)

## Other variables

### RELATIVIZER DISTRIBUTION BY ANTECEDENT TYPE

The antecedent seems to matter quite a bit for non-subject RCs, but not for subject RCs.

![](/graphs/relativizer_distribution_byrctype_byantecedent.jpg)

### RELATIVIZER DISTRIBUTION BY MATRIX CLAUSE TYPE

Matrix clause type seems to matter.

![](/graphs/relativizer_distribution_byrctype_bymatrixclause.jpg)

### RELATIVIZER DISTRIBUTION BY HEAD SPECIFICITY

Head specificity seems to matter: for non-subject RCs, more nulls than "that"s for empty heads; reverse for nonempty heads. For subject RCs, there appears to be a greater incidence of "who"s with empty heads (maybe because there's a lot of empty animate heads like "guy"?)

![](/graphs/relativizer_distribution_byrctype_byheadspecificity.jpg)

### RELATIVIZER DISTRIBUTION BY ADJACENCY

There appear to be more "that"s with increasing amount of intervening material, and fewer nulls (non-sbj) / fewer "who"s (sbj).

![](/graphs/relativizer_distribution_byrctype_byadjacency.jpg)

### RELATIVIZER DISTRIBUTION BY RC LENGTH

There appear to be more "that"s & fewer nulls with increasing RC length for sbj RCs, and the opposite for non-sbj RCs: fewer "that"s and more "who"s.

![](/graphs/relativizer_distribution_byrctype_byrclength.jpg)

### RELATIVIZER DISTRIBUTION BY RC SUBJECT TYPE

RC subject type seems to matter, even within pronominal subjects

![](/graphs/relativizer_distribution_byrctype_byrcsubjtype.jpg)


## Next steps

- Run analyses:
	- separately for sbj and non-sbj
	- full dataset (leaving out RCSubjType, that's undefined for the sbj RCs)
	
- Things to ponder/try out in analysis:
	- collapse "lonehead" into "other" category (MatrixClauseType) / wait for Tom's "presentational" (discourse-new) category to throw the existential and some of the "other"s in
	- include dialect/region
	- throw out level of education 9 ("unknown")
	- try out multinomial regression --> are there enough "wh"s to even do this?
	- interactions between socio factors?
	- include random slopes for all fixed effects?
	

