batterraw<-read.csv("batterdata.csv")
library(dplyr)
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
results<-data.frame(Name=character(), MostSimilar=character(),MostSimilarMatch=double(), LeastSimilar=character(),LeastSimilarMatch=double())
batter<-data.frame()
comp<-data.frame()
leastID1<-data.frame()
mostID1<-data.frame()
#for each batter in the frame, compare to each other batter using the simscore formula, find the most similar and least similar, and store the batter's name, the names and simscore values for the most similar and least similar batters 
for (i in 1:n){
   #drawing out batter data
  batter<-filter(batterrate,key==i)
  #setting up data frame for next for loop
    matches<-data.frame(name=character(),number=double())
  #storing the batter number we are on. This may not be necessary? 
  x<-i
  for (j in 1:n){
    # setting up the comparison player's data
    comp<-filter(batterrate,key==j)
    #simscore formula starts at 1 and deducts by percentage difference in rates of singles, doubles, triples, home runs, walks and strikeouts
    simscore<-1-abs(batter$X1Brate-comp$X1Brate)-abs(batter$X2Brate-comp$X2Brate)-abs(batter$X3Brate-comp$X3Brate)-abs(batter$HRrate-comp$HRrate)-abs(batter$BBrate-comp$BBrate)-abs(batter$SOrate-comp$SOrate)
    if (j==x) {
    #comparing batter to self will give na
      matches<-rbind(matches,data.frame("name"=comp$name,"number"=NA, stringsAsFactors=FALSE))
    } else {
      matches<-rbind(matches,data.frame("name"=comp$name,"number"=simscore,stringsAsFactors=FALSE))
    } 
   
  }
  #picking out the most similar and least similar batters and storing them
  matches$name<-as.character(matches$name)
  most<-max(matches$number, na.rm=TRUE)
  mostID1<-filter(matches,matches$number==most)
  mostID1$name<-as.character(mostID1$name)
  mostID<-mostID1$name
  least<-min(matches$number, na.rm=TRUE)
  leastID1<-filter(matches,matches$number==least) 
  leastID1$name<-as.character(leastID1$name)
  leastID<-leastID1$name
  results<-rbind(results,data.frame("Name"=batter$name, "MostSimilar"=mostID,"MostSimilarMatch"=most, "LeastSimilar"=leastID,"LeastSimilarMatch"=least))
    
}

  