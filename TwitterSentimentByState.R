#Sentiment analysis by state for different terms on twitter (groups, individuals, etc.)

install.packages("twitteR")
install.packages("ROAuth")
install.packages("RCurl")
install.packages("stringr")
install.packages("tm")
install.packages("ggmap")
install.packages("dplyr")
install.packages("plyr")
install.packages("tm")
install.packages("wordcloud")
install.packages("httr")
install.packages("graph")
install.packages("Rgraphviz")

library(httr)
library(twitteR)
library(ROAuth)
require(RCurl)
library(stringr)
library(tm)
library(ggmap)
library(dplyr)
library(plyr)
library(tm)
library(wordcloud)
library(graph)
library(Rgraphviz)

# Set API Keys
consumer_key <- "GET THIS CODE FROM TWITTER"
consumer_secret <- "GET THIS CODE FROM TWITTER"
access_token <- "GET THIS CODE FROM TWITTER"
access_secret <- "GET THIS CODE FROM TWITTER"
setup_twitter_oauth(consumer_key, consumer_secret, access_token,access_secret)
#The website below has a lot of useful information about twitter analysis with R. 
#http://www.rdatamining.com/docs/twitter-analysis-with-r  
#For now focusing on basics

setwd("")

search.string <- "PUT NAME OF INDIVIDUAL/ORGANIZATION HERE THAT YOU WANT TO DO THE SENTIMENT ANALYSIS ON"
no.of.tweets <- 1000

# Extract tweets (can't do it from certain places as far as I can tell, naturally grabs from the places that do it the most
#just limit it to the lower 48 via geocode coordinates).
tweets <- searchTwitter(search.string, n=no.of.tweets, lang="en", geocode='39,-98,2000mi')

#Geocoding from the center of the lower 48 states :: since='2016-01-1',until ='2017-01-1'

#If you want to look for something specific you need to give them the coordinates first, it doesn't just grab the coordinates, or at least very few. 
#Consequently, will need to rely on their self-noted locations in terms of states. 

# convert tweets to a data frame
tweets.df <- twListToDF(tweets)

# Look up the users , get location 
users <- lookupUsers(tweets.df$screenName)


users_df <- twListToDF(users)

#https://www.r-bloggers.com/mapping-twitter-followers-in-r/
#How to go from self-identified state to geocoding

#Takes out blanks
users_df<-subset(users_df, location!="")

# Takes % out since it doesn't do well with the API
users_df$location<-gsub("%", " ",users_df$location)

#Install key package helpers: This will get the geocode results, but google limits it to a thousand or so per day. 
source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/geocode_helpers.R")
#Install modified version of the geocode function
#(that now includes the api_key parameter):
source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/modified_geocode.R")

geocode_apply<-function(x){
  geocode(x, source = "google", output = "all", api_key="")
}

geocode_results<-sapply(users_df$location, geocode_apply, simplify = F)

results_b<-lapply(geocode_results, as.data.frame)

litext=sapply(tweets, function(x) x$getText())
lilat=sapply(tweets, function(x) as.numeric(x$getLatitude()))
lilon=sapply(tweets, function(x) as.numeric(x$getLongitude()))
lidate=lapply(tweets, function(x) x$getCreated())
lidate =sapply(lidate, function(x) as.character(as.Date(x)))

tweets2=as.data.frame(cbind(tweet=litext,date=lidate,lat=lilat,lon=lilon))
