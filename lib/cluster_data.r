library('mclust')

args <- commandArgs(trailingOnly = TRUE)

inputFile <- args[1]
outputFile <- args[2]
outputGraph <- args[3]

# trailingOnly=TRUE means that only arguments after --args are returned
# if trailingOnly=FALSE then you got:
# [1] "--no-restore" "--no-save" "--args" "2010-01-28" "example" "100"

inputData <- read.csv(inputFile)
mclustData <- Mclust(inputData)
write.csv(mclustData$classification, outputFile)

if(outputGraph != "NA"){
	png(filename=outputGraph)
	plot(mclustData, "classification")
	dev.off()
}
