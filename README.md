# Sentiment-Analysis-Twitter
Sentiment Analysis on Twitter Data (Demonitization Sentiments in 2016)  Goal – Try to predict positive and negative sentiments and plot visualizations
•	Sentiment Analysis on Twitter Data (Demonitization Sentiments in 2016)
•	Goal – Try to predict positive and negative sentiments and plot visualizations.
•	Description  - 
1.	Project is developed in R and visualization is done using Tableau (Also used Histograms, scatter plots and box plots for analysis).
2.	twitterR library used to download twitter data for demonitization by setting twitter authentication.
3.	tm package from R used to basic cleaning of data like removing stop words, removing punctuation marks, removing numbers etc.
4.	SnowballC stemmer used to stem document.
5.	RWeka library used for Bigram Tokenization of Document Term Matrix.
6.	After finally constructing Document Corpus, Positive and negative scores calculated for all Documents by comparing them with positive_words data file and negative_words data file.
7.	WordCloud library used to show mostly used  positive words and negative words.
8.	I have also tried to show twitter data on geographical region using Tableau maps. To show geographic data I have used coordinate points which I got while downloading twitter data using twitter API. In short in tableau maps for specific region in India (say for Delhi) I have tried to predict positive and negative sentiments for that specific region on maps. Of course for this to achieve I downloaded lots of twitter data and applied lots of cleaning.



