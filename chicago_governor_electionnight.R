library(tidyverse)
library(XML)
library(reshape2)



###Chicago CD-3####


download.file(url='https://chicagoelections.com/en/data-export.asp?election=0&race=17&ward=&precinct=',
              destfile='chicagodems.html', method='curl')
#this file above was corrupted when coming down as xls 
#so changing to html instead to work with that way

u <- 'chicagodems.html'
tables <- readHTMLTable(u)
# names(tables)

#pull out just the first table, with aggregate totals for each candidate
chicago_cd3 <- tables[[1]]
# chicago_cd3

colnames(chicago_cd3) <- c("total.votes", "lipinski.votes", "lipinski.pct", "newman.votes", "newman.pct")
chicago_cd3$county.name <- "chicago"
# chicago_cd3

#do lipinski separately to rejigger columns
temp_lip <- chicago_cd3
temp_lip$choice.name <- "Daniel William Lipinski"
# temp_lip

temp_lip2 <- select(temp_lip, county.name, choice.name, lipinski.votes, lipinski.pct, total.votes)
colnames(temp_lip2) <- c("county.name","choice.name","total.votes","percent.of.votes","ballots.cast")


#do newman separately to rejigger columns
temp_newm <- chicago_cd3
temp_newm$choice.name <- "Marie Newman"
# temp_newm

temp_newm2 <- select(temp_newm, county.name, choice.name, newman.votes, newman.pct, total.votes)
colnames(temp_newm2) <- c("county.name","choice.name","total.votes","percent.of.votes","ballots.cast")


#combine lip and newman back together
chicago_comb <- rbind(temp_lip2, temp_newm2)

# chicago_comb$total.votes <- as.integer(chicago_comb$total.votes)
# chicago_comb$percent.of.votes <- as.numeric(chicago_comb$percent.of.votes)
# chicago_comb$ballots.cast <- as.integer(chicago_comb$ballots.cast)

temppp <- chicago_comb
# temppp

temppp$percent.of.votes <- str_replace_all(temppp$percent.of.votes, "%", "")
temppp$percent.of.votes <- as.numeric(temppp$percent.of.votes)
temppp$total.votes <- as.numeric(temppp$total.votes)
temppp$ballots.cast <- as.numeric(temppp$ballots.cast)

chicago_comb_cd3 <- temppp




### Democrats for Governor ####

download.file(url='https://chicagoelections.com/en/data-export.asp?election=0&race=10&ward=&precinct=',
              destfile='chicagogov_d.html', method='curl')
#this file above was corrupted when coming down as xls 
#so changing to html instead to work with that way

u <- 'chicagogov_d.html'
tables <- readHTMLTable(u)
names(tables)

#pull out just the first table, with aggregate totals for each candidate
chicago_gov_d <- tables[[1]]
chicago_gov_d


colnames(chicago_gov_d) <- c("ballots.cast", 
                             "pritzker.votes", 
                             "pritzker.pct", 
                             "kennedy.votes", 
                             "kennedy.pct", 
                             "biss.votes", 
                             "biss.pct",
                             "daiber.votes",
                             "daiber.pct",
                             "hardiman.votes",
                             "hardiman.pct",
                             "marshall.votes",
                             "marchall.pct"
                             )



#### Republicans for Governor ####

download.file(url='https://chicagoelections.com/en/data-export.asp?election=1&race=139&ward=&precinct=',
              destfile='chicagogov_r.html', method='curl')

u <- 'chicagogov_r.html'
tables_r <- readHTMLTable(u)
names(tables_r)

#pull out just the first table, with aggregate totals for each candidate
chicago_gov_r <- tables_r[[1]]
chicago_gov_r

colnames(chicago_gov_r) <- c("ballots.cast", 
                             "rauner.votes", 
                             "rauner.pct", 
                             "ives.votes", 
                             "ives.pct")



## clean up objects ####
rm(temppp)
rm(temp_lip)
rm(temp_lip2)
rm(temp_newm)
rm(temp_newm2)