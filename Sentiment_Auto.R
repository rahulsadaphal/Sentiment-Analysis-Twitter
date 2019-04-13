library(tm)

library(twitteR)

consumer_key = 'y3KloNO6PwGRmG5TaZBIc2oME'
consumer_secret = 'YnCMo9T7eJHGSguMad6h55elQTjshm065i7eKrmoVxiItjPf43'

setup_twitter_oauth(consumer_key,
                    consumer_secret, 
                    access_token='1327212402-whXpMV5PM1nDE82n6AsOLnRV23UOSCXldEulaSq', 
                    access_secret='DTX3VVnNJMkVlgftVFl30NlUX8p9iDXS5BxEj5nTH1ZrE')
#Authenticate

# Download feeds
# Convert to dateframe and write to CSV

some_tweets = searchTwitter("delta", n=500, lang="en")
indata <- do.call("rbind", lapply(some_tweets, as.data.frame))
# Save file if required
write.csv(indata, "iphone7.csv")

pos.dict <- readLines("positive-words.txt")
neg.dict <- readLines("negative-words.txt")

## Create corpus that allows us to leverage TM package
corpus = Corpus(VectorSource(indata$text))
Sys.setlocale("LC_ALL", "C")

# Clean up non displayable characters
for(j in seq(corpus))   
{   
  corpus[[j]] <- gsub("[^[:alnum:]///' ]", "", corpus[[j]])   
}  

corpus = tm_map(corpus, tolower)
indata$text[1]
corpus[[1]]

corpus = tm_map(corpus, removePunctuation)   #  <------ 
indata$text[2]
corpus[[2]]
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removeWords, 
                c('airlines','iphone','apple','flight',
                  'next','else','unitedairline','unitedairlines',
                  stopwords("english")))
stopwords("english")
corpus = tm_map(corpus, PlainTextDocument)
library(SnowballC)   
### Remove plurals and variations to words
stopwords("english")
corpus <- tm_map(corpus, stemDocument)  
corpus <- tm_map(corpus, stripWhitespace)   
corpus <- tm_map(corpus, PlainTextDocument)   

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
library(RWeka)
########################################################
dtm1 = DocumentTermMatrix(corpus,control = list(tokenize = BigramTokenizer))
dtm1
inspect(dtm1[1,])

########################################################
### Calculate Positive and Negative Scores
### colnames(dtm1)[1:15]
df_dtm = as.data.frame(as.matrix(dtm1))
### write.csv(df_dtm,'dtm_before_change.csv')
for(j in 1:NROW(colnames(df_dtm)))   
{   
  #print(j)
  pos.matches <- match(colnames(df_dtm)[j], pos.dict)
  if (!is.na(pos.matches)) {
    df_dtm[,j] = +1 * df_dtm[,j]
  } 
  else {
    neg.matches <- match(colnames(df_dtm)[j], neg.dict)
    if (!is.na(neg.matches)) {
      df_dtm[,j] = -1 * df_dtm[,j]
    } 
    else {
      df_dtm[,j] = 0 
    }
  }
  
}
sentiment_score = rowSums(df_dtm)
class(sentiment_score)
df_dtm$Score = sentiment_score
df_dtm$Sentiment = 'Neutral'
df_dtm$Sentiment[sentiment_score > 0] = 'Positive'
df_dtm$Sentiment[sentiment_score < 0] = 'Negative'
str(df_dtm,list.len=3000)

table(df_dtm$Sentiment)
# If you want to store the results in a file
## write.csv(df_dtm,'dtm1_after_change_with_sentiment.csv')

## All done. Lets inspect the first few records
head(df_dtm$Sentiment)

######################################################
## Lets remove sparse terms and create wordclouds
nonsparse = removeSparseTerms(dtm1, .995)
nonsparse
nonsparse_df = as.data.frame(as.matrix(nonsparse))

# negative_sentiments = nonsparse_df[df_dtm$Sentiment =='Negative',!(names(df_dtm) %in% "Sentiment")]
# positive_sentiments = nonsparse_df[df_dtm$Sentiment =='Positive',!(names(df_dtm) %in% "Sentiment")]

 negative_sentiments = nonsparse_df[df_dtm$Sentiment =='Negative',]
 positive_sentiments = nonsparse_df[df_dtm$Sentiment =='Positive',]

library(wordcloud)
wordcloud(colnames(negative_sentiments),
          colSums(negative_sentiments),
          scale=c(3,1),
          random.color=TRUE,
          colors=brewer.pal(8,"Dark2"),
          random.order=FALSE,rot.per=.25)

wordcloud(colnames(positive_sentiments),
          colSums(positive_sentiments),
          scale=c(3,1),
          random.color=TRUE,
          colors=brewer.pal(8,"Dark2"),
          random.order=FALSE,rot.per=.25)
