# simple script to merge data from grmpy & nodra
# MSK Oct2018

nodra<-read.csv(file="/data/jux/BBL/studies/reward/processedNeuroec/wtw/WTW_Compiled_20181017.csv",header=TRUE,sep=",")
grmpy<-read.csv(file="/data/jux/BBL/studies/grmpy/processedNeuroec/wtw/WTW_Compiled_20181017.csv",header=TRUE,sep=",")

# drop the subjects from grmpy because they completed WTW as part of nodra before
new_grmpy<-subset(grmpy, !id %in% c(82063, 83010, 139272, 90683, 118990, 120217, 121407, 122801))
merge<-rbind(nodra,new_grmpy)

# check for duplicates
#n_occur <- data.frame(table(merge$id))
#n_occur[n_occur$Freq > 1,]

filePath <- paste0('/data/jux/BBL/studies/grmpy/processedNeuroec/wtw/', "WTW_Merged_nodra_grmpy_", format(Sys.Date(), "%Y%m%d"), ".csv")
write.csv(merge, filePath, row.names = FALSE)