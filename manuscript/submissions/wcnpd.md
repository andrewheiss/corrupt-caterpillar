---
title: "Abstract for Causal Inference in Nonprofit Studies"
author:
- name: Andrew Heiss
  affiliation: Georgia State University
  email: aheiss@gsu.edu
  url: https://www.andrewheiss.com/
- name: Meng Ye
  affiliation: Georgia State University
  email: mye2@gsu.edu
date: "February 14, 2022"
bibliography: "../bibliography.bib"
csl: "../pandoc/csl/apa.csl"
---

# Getting Causation Right: A Guide to Observational Causal Inference in Nonprofit Studies

## Shrunken down abstract for WCNPD

Discovering causal relationships and testing theoretical mechanisms is a core endeavor of social science. Randomized experiments have long served as a gold standard for making valid causal inferences, but most of the data social scientists work with is observational and non-experimental. However, with newer methodological developments in economics, political science, epidemiology, and other disciplines, an increasing number of studies in social science make causal claims with observational data. As a newer interdisciplinary field, however, nonprofit studies has lagged behind other disciplines in its use of observational causal inference. In this paper, we present a hands-on introduction and guide to design-based observational causal inference methods. We first review and categorize all studies making causal claims in top nonprofit studies journals over the past decade to illustrate the field’s current of experimental and observational approaches to causal inference. We then introduce a framework for modeling and identifying causal processes using directed acyclic graphs (DAGs) and provide a walk-through of the assumptions and procedures for making inferences with a range of different methods, including matching, inverse probability weighting, difference-in-differences, regression discontinuity designs, and instrumental variables. We illustrate each approach with synthetic and empirical examples and provide sample R and Stata code for implementing these methods. We conclude by encouraging scholars and practitioners to make more careful and explicit causal claims in their observational empirical research, collectively developing and improving quantitative work in the broader field of nonprofit studies.



## Abstract

Causal inference is the core endeavor of scientific inquiry in both natural and social science[@RN2256], because causal relationships are the neurons of the inherent mechanisms of theories that make scientific explanation and prediction possible[@jaccard2019theory, p.154]. With the methodological development in such disciplines as economics and political science, an increasing number of studies have been making causal inference not only using experimental data, but also observational data thanks to such techniques as difference-in-difference, instrumental variables, regression discontinuity. **(T)** However, as an interdisciplinary and newer field, empirical nonprofit studies seem to lag behind related disciplines in the employment of causal inference and this “refraining from mentioning the C-word (“causal”)” is still prevalent[@Hernan:2018]. Casual inference is critical for nonprofit theory building in multifold. At the macro level, the legitimacy of the nonprofit sector and justification of such treatment as tax benefits is hinged on causally proving the positive social impact of nonprofits [@RN2253]. At the meso level, casually examining the effects of certain program interventions and nonprofit management methods would inform us how to achieve our social missions more effectively. At the individual level, causally understanding donor behaviors would guide our strategy in response to the ever-changing donation scenarios (e.g., tik-tok, Ice Bucket Challenge). **(Q)** To understand and advance current scholarly understanding of causal inquiry and start the conversation on causal inference in nonprofit studies, in this paper, we introduce and provide a hands-on guide of design-based causal inference methods with directed acyclic graphs (“DAGs”) for observational data attuned to nonprofit studies. **(RD)** Specifically, we first review extant studies making causal claims on nonprofit topics, using bibliometric statistics from publications in 3 top nonprofit journals and 4 top public administration journals in the timeframe from 2010 to 2020. Based on the critique of the methodological rigor and validity of causal claims in extant nonprofit studies, we propose and explain how quasi-experimental designs used with DAGs can be utilized to make more valid causal inferences. We then further support our arguments with the exemplification of both a synthetic study and a replicated empirical nonprofit study. **(D&M)** We expect to find in our results that by using more rigorous design-based methods with DAGs, the estimated statistics we got from these methods are closer to the true parameters, even with observational data. **(R)** As such, we hope to encourage more scholars to make causal inquiry in their empirical research, and collectively developing nonprofit studies as a field.  **(I)**


## Internal notes - delete later


### 1. structure marker 
Everyone agrees that this issue is really important -> topic **(T)**

But we do not know much about this specific question, although it matters a great deal, for these reasons-> questions **(Q)**

We approach the problem from this perspective -> research design **(RD)**

Our research design focuses on these cases and relies on these data, which we analyze using this method -> data **(D)** and method **(M)**

Results show what we have learned about the question -> results **(R)**

They have these broader implications -> implication **(I)**

### 2. submission requirements 

"Please copy/paste the abstract for your presentation here in **under 350 words**""

### 3. issues in urrent draft

- currently wordy: The header and background part is really long. Some may be more suitable to put in the main text. I just write out all relevant discussion that I thought of and put it here for you to truncate. 
Current word count is about **405* 

- methods part is drafted based on the outline and should need refinement

- reference for causal inference I currently insert is just what I encountered in other classes that touch on causation, please update with better-fit literature, or I can work on familiarizing myself with more Pearl and others work later 



## References



