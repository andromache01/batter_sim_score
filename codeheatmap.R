batterraw<-read.csv("batterdata.csv")
library(dplyr)
library(ggplot2)
library(reshape2)
library(viridis)
names(batterraw)[1]<-"name"
batterraw$name<-as.character(batterraw$name)
#picking out the parameters I'm interested in
batterraw<- batterraw %>% select(name,PA,X1B,X2B,X3B,HR,BB,SO)
# for the loops, later
n=length(batterraw$name)

# translating to overall rates
batterraw$X1Brate<-batterraw$X1B/batterraw$PA
batterraw$X2Brate<-batterraw$X2B/batterraw$PA
batterraw$X3Brate<-batterraw$X3B/batterraw$PA
batterraw$HRrate<-batterraw$HR/batterraw$PA
batterraw$BBrate<-batterraw$BB/batterraw$PA
batterraw$SOrate<-batterraw$SO/batterraw$PA
batterrate<-batterraw %>% select(name,X1Brate,X2Brate,X3Brate,HRrate,BBrate,SOrate)

# for the loops, later
batterrate$key<-c(1:n)

#setting up data frames for loops
results<-cbind.data.frame(batterrate$name)
batter<-data.frame()
comp<-data.frame()
#for each batter in the frame, compare to each other batter using the simscore formula, find the most similar and least similar, and store the batter's name, the names and simscore values for the most similar and least similar batters 
for (i in 1:n){
  #drawing out batter data
  batter<-filter(batterrate,key==i)
  #setting up data frame for next for loop
  matches<-data.frame(number=double())
  #storing the batter number we are on. This may not be necessary? 
  x<-i
  for (j in 1:n){
    # setting up the comparison player's data
    comp<-filter(batterrate,key==j)
    #simscore formula starts at 1 and deducts by percentage difference in rates of singles, doubles, triples, home runs, walks and strikeouts
    simscore<-1-abs(batter$X1Brate-comp$X1Brate)-abs(batter$X2Brate-comp$X2Brate)-abs(batter$X3Brate-comp$X3Brate)-abs(batter$HRrate-comp$HRrate)-abs(batter$BBrate-comp$BBrate)-abs(batter$SOrate-comp$SOrate)
    if (j==x) {
      #comparing batter to self will give na
      matches<-rbind(matches,data.frame("number"=NA, stringsAsFactors=FALSE))
    } else {
      matches<-rbind(matches,data.frame("number"=simscore,stringsAsFactors=FALSE))
    } 
  }
 
  results<-cbind(results,matches)
}

names(results)<-c("name",batterraw$name)

heatmapresults<-melt(results)
heatmapresults$name <- as.character(heatmapresults$name)
heatmapresults$name <- factor(heatmapresults$name, levels=unique(heatmapresults$name))
jpeg(filename="heatmap.jpg", width=1800, height=1800)
ggplot(heatmapresults, aes(variable,name)) + geom_tile(aes(fill = value), colour = "white") + scale_fill_viridis() + theme(text = element_text(size=10), axis.text.x = element_text(angle=90, hjust=0), legend.key.size = unit(1.0, "cm"), legend.text = element_text(size = 20)) +  scale_x_discrete(position = "top") +  scale_y_discrete(name="", limits = rev(levels(heatmapresults$name)))
dev.off()
  