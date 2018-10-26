# Finkel 20180507
# Revised by MSK Oct2018

# get output text files from wtw scripts, merge them, save as CSV with all variables
setwd('/data/jux/BBL/studies/reward/processedNeuroec/wtw/txt_output/qtask_nodra')
fileNames <- list.files()
fileNames <- fileNames[grepl(".txt", fileNames)]
wtw <- data.frame()
dates<-read.delim('/data/jux/BBL/studies/reward/processedNeuroec/wtw/datesmat.txt',header=FALSE,col.names=c("date"))

for (i in 1:length(fileNames)) {
  wtwTemp <- read.table(fileNames[i], sep="\t", header=FALSE, col.names=c("id", "study", substring(fileNames[i], 1, nchar(fileNames[i])-4)))
  drop<-c("study")
  wtwTemp<-wtwTemp[ , !(names(wtwTemp) %in% drop)]
  wtwTemp<-cbind(wtwTemp,dates)
  if (i == 1) {wtw <- wtwTemp}
  else if (i > 1) {wtw <- merge(wtw, wtwTemp,by=c("id","date"))}
}

# change subject ID's - 2 subjects have incorrect ID's in the matfile

# (18271 should have been 80225)
row_number<-which(wtw$id == 18271 & wtw$date == 20141114)
wtw[row_number, 1] = 80225

# (19999 should have been 16777)
row_number<-which(wtw$id == 19999 & wtw$date == 20150915)
wtw[row_number, 1] = 16777

filePath <- paste0('/data/jux/BBL/studies/reward/processedNeuroec/wtw/', "WTW_Compiled_", format(Sys.Date(), "%Y%m%d"), ".csv")

write.csv(wtw, filePath, row.names = FALSE)
