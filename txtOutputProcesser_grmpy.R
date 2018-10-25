# Finkel 20180507
# Revised by MSK Oct2018

# get output text files from wtw scripts, merge them, save as CSV with all variables
setwd('/data/jux/BBL/studies/grmpy/processedNeuroec/wtw/txt_output/qtask_grmpy')
fileNames <- list.files()
fileNames <- fileNames[grepl(".txt", fileNames)]
wtw <- data.frame()
dates<-read.delim('/data/jux/BBL/studies/grmpy/processedNeuroec/wtw/datesmat.txt',header=FALSE,col.names=c("date"))

for (i in 1:length(fileNames)) {
  wtwTemp <- read.table(fileNames[i], sep="\t", header=FALSE, col.names=c("id", "study", substring(fileNames[i], 1, nchar(fileNames[i])-4)))
  drop<-c("study")
  wtwTemp<-wtwTemp[ , !(names(wtwTemp) %in% drop)]
  wtwTemp<-cbind(wtwTemp,dates)
  if (i == 1) {wtw <- wtwTemp}
  else if (i > 1) {wtw <- merge(wtw, wtwTemp, by=c("id","date"))}
}

# change subject ID's

# 1 subject has a typo (13186 should have been 131867)
row_number<-which(wtw$id == 13186 & wtw$date == 20171220)
wtw[row_number, 1] = 131867

# 1 subject has someone else's ID (there are 2 experiments with ID 99352, one dated 05/04/2016 should have been 92554)
row_number<-which(wtw$id == 99352 & wtw$date == 20160504)
wtw[row_number, 1] = 92554

filePath <- paste0('/data/jux/BBL/studies/grmpy/processedNeuroec/wtw/', "WTW_Compiled_", format(Sys.Date(), "%Y%m%d"), ".csv")

write.csv(wtw, filePath, row.names = FALSE)
