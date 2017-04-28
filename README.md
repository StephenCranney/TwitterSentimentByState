# TwitterSentimentByState
Sentiment analysis by state for different terms on twitter (groups, individuals, etc.)


This is a python program I wrote that attempts to conduct a state-level sentiment analysis for a keyword. For example, 
do tweets from one state have more negativity towards Muslims than tweets from another state? 

However, I wasn't able to find a package that converted self-identified locations to consistent state-level acronyms.
There is no easy way to get state-level data. Google IP can only do 2,500 a day, and even that doesn't have the specific state. 
The code below should get you to the point of having a dataset with tweets that you can run a sentiment analysis on using any of the 
well-honed sentiment analysis packages in R. It will also have the user-described state locations, but again it won't have a consistent
state label. If anybody knows of a code or package that can create consistent state-level acronyms from user locations ("Golden state"=CA, "Cali"=CA, etc.)
then I could wrap this up. 
