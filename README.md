# batter_sim_score

I worked on this project as a personal instruction for myself in R, and have shared it, principally targeted at people who have little to no experience in R.

I had previously generated the methodology (comparing single season rates for singles, doubles, triples, home runs, strikeouts and walks among hitters) in Excel. That was time consuming to replicate, while this was not.

Works with single-season hitter data from fan graphs. Specifically, I used 2016 qualified batters, sorted by highest batting average:  http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=0&season=2016&month=0&season1=2016&ind=0&team=0&rost=0&age=0&filter=&players=0
I have included the data I used in the repository. 
It is easy to rerun with different data for different years, and likely even from different sources, as long as the column names are the same. On fangraphs, you can change the inputs and click "export data" 
Rename your data "batterdata.csv" or change the first line of the code, and add it to your working directory in R.

Right now the order for the names is based on the input data, as fangraphs auto-sorts "best at the top" more or less. It would be easy to sort by another included statistic, less easy to order by some other statistic.  (An easy way would be to create a custom fangraphs table). 

code.R generates a data frame with the most similar batter/score and least similar batter/score for each player
codeheatmap.R generates a heatmap of all similarity scores between players. It is not useful but it is kind of fun and pretty, and I wanted to learn more about ggplot2. 

