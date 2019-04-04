#!/bin/bash
# MainSimulationScript.R
# args is a stringvector
args <- commandArgs(TRUE)
args <- as.numeric(args)
print(args)

#args <- c(4,args)
#print(args)
RowOfDesign <- args[1]
Replication <- args[2]
RowOfDesign <- 1
Replication <- 1

### Simulation design example
samp1 <- c(10, 60, 1000)
samp2 <- c(10, 8, 13, 5, 15, 3, 18,  60,  45, 75, 30, 90, 15, 105, 1000, 750, 1250, 500, 1500, 250, 1750)
sd <- c(1, 0.75, 1.25, 0.50, 1.50, 0.25, 1.75, 3)
es <- c(0.2, 0.5, 0.8)
# Design is a data.frame with all possible combinations of the factor levels
# Each row of the design matrix represents a cell of your simulation design

Design <- expand.grid(samp1 = samp1, samp2 = samp2, es = es, sd = sd)

# set a random number seed to be able to replicate the result exactly
set.seed((Replication + 1000)*RowOfDesign)

#Preparation:
# If you use R packages that are not standard:
# Install the relevant R packages, for example:

#install.packages("perm")

#Always use library() to activate the package
library(perm)
#By the way: this is just to illustrate, we do not use this package for our example

#Source the relevant R functions of our example


#An alternative to the previous lines is to create your own directory
#and upload the files to it. For example:
source("C:/Users/ruche/OneDrive/Documents/Shark/Scripts/MyDataGeneration.R")
source("C:/Users/ruche/OneDrive/Documents/Shark/Scripts/Method_new.R")
source("C:/Users/ruche/OneDrive/Documents/Shark/Scripts/Method_old.R")
source("C:/Users/ruche/OneDrive/Documents/Shark/Scripts/MyEvaluation.R")

######### simulation ###########
# Generate data
SimData <- do.call(MyDataGeneration, Design[RowOfDesign, ]  )

# Analyze data set with Method_new
tmp <- proc.time()
MyAnalysisResult1 <- Method_new(SimData)

#Analyze data set with Method_old
MyAnalysisResult2 <- Method_old(SimData)
time <- proc.time() - tmp #save the time to run the analyses of one cell of the design

#Combine relevant results of the analysis by the two methods in a vector (optional)

MyAnalysisResult <- c(MyAnalysisResult1$p.value, MyAnalysisResult2$p.value)

#Evaluate the analysis results of Method_new and Mehod_old
MyResult1 <- MyEvaluation(MyAnalysisResult1)
MyResult2 <- MyEvaluation(MyAnalysisResult2)

#combine the results in a vector:
MyResult <- c(MyResult1, MyResult2)
print(MyResult)


######## saving ###########
# save stuff on export
setwd("C:/Users/ruche/OneDrive/Documents/Shark/Scripts/exports")
#Alternatively, you can also create your folder in the export/fsw directory
#and set it as your working directory.


# Write output (also possible to first save everything in a list object)

#optional to save the data
#save(SimData, file = paste("Simdata","Row", RowOfDesign, "Rep" ,Replication ,".Rdata" , sep =""))
#optional to save the analysis result
#save(MyAnalysisResult, file = paste("Analysis","Row", RowOfDesign, "Rep", Replication ,".Rdata" , sep =""))

save(MyResult, file = paste("MyResult", "Row", RowOfDesign,"Rep",Replication ,".Rdata" , sep =""))

#optional to save timing of analyses
#save(time, file = paste("Time", "Row", RowOfDesign, "Rep", Replication ,".Rdata" , sep =""))
