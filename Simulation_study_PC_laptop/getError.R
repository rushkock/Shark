welchError <- permError <- typeI <- rep(NA,nrow(Design))

for (i in 1:10){
  resultsDesignRowI <- Design[i,]
  isEqualtoDesign <- rep(FALSE,nrow(ResultsSimAll))
  print(i)
  for (j in 1:nrow(ResultsSimAll)){
    isEqualtoDesign[j] <- all(ResultsSimAll[j,1:ncol(Design)]==resultsDesignRowI)
  }
  resultsForDesignI <- ResultsSimAll[isEqualtoDesign,]
  welchError[i] <- mean(resultsForDesignI$Method1)
  permError[i] <- mean(resultsForDesignI$Method2)
  typeI[i] <- resultsDesignRowI$es==0
}
results <- cbind(Design,welchError,permError,typeI)
