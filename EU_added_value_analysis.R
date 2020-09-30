library (quanteda) #this script uses quanteda, but you can also try the package called "tm" for text mining
library (readtext)
library (dplyr) #for the piping ("tidy") operation at the end, for generating the occurrence list

#reading the text files and creating a corpus (change the path to the directory where you unzipped the files)
data_SR <- readtext('D://Working//working_docs//52_document_corpus//all_SRs//*.txt')
corpus_SR <-corpus(data_SR)

#tokenising the corpus and selecting "added value" with a search window of +/- 5 words/tokens
tokens_SR <- tokens(corpus_SR) #tokenising such a large corpus may take a bit of time
tokens_added_value <- tokens_select(tokens_SR, phrase("added value"), window = 5)

#creating a KWIC (keyword-in-context) search for EU +/- added value and European +/- 5 added value
EU_kwic <- kwic(tokens_added_value, c("EU","European"))

#look at the first 10 entries of the search results
head(EU_kwic, 10)

#creating a html-based view of the search than can be exported
View(EU_kwic)

#doclist = EU_kwic$docname

#creating some tables and dataframes to summarise the data
#extracting the data from the kwic-search object into a dataframe
addedvalue.data <- data.frame(EU_kwic$docname, EU_kwic$pre,  EU_kwic$keyword, EU_kwic$post)
occurrence_table <- table(addedvalue.data$EU_kwic.docname)
#create a simple table with document names and aggregated occurrence numbers
occurrence_list <- table(addedvalue.data$EU_kwic.docname) %>% 
  as.data.frame() %>% 
  arrange(desc(Freq))

#writing the result tables to csv so that you can use them in Excel
#write.csv2 defaults to semicolon separator, write.csv uses commas. switch if your local settings require
write.csv2(occurrence_list, 'occurrence_list_sorted_by_report.csv', )
write.csv2(addedvalue.data, 'occurrence_table.csv')

#TODO: 
#
# IN GENERAL: after each phase, show the results to Gaston/Daniel to verify if it makes sense, or if it has added value for the analysis
#             often times it takes a lot of trial and error to get on the right track
#
# 0: please double-check with Gaston and Daniel about the final list of files. the latest corpus (30 Sept) contains almost everything, but not quite yet
#    convert all files into plain text, either using AntFileConverter, or just save as plain text from Word or Acrobat Reader
#    if you need to add files, put them in the proper folders in plain text format, and re-run the whole analysis
#    if you re-run the kwic-search, run "View(EU_kwic)" and you can export the interactive table in html
#
# 1: try to analyse bi-grams and tri-grams around "EU added value" or "European added value". 
#    hint: you may want to replace all occurrences of "EU added value" and "European added value" with a common placeholder without spaces, such as "EU_added_value"
#
# 2: if you have the bi-grams or tri-grams, you can try to plot a network, see Chapter 4 of the book
#
# 3: you could try to create word clouds for the few reports with >10 occurrences
#
# 4: the quanteda package can do so-called "comparison cloud", you can compare max 6. documents on the same word cloud
#
# 5: it may be worth exploring the main differences between the vocabulary of the reports with >10 eu added value occurrences, and the rest. check out "textstat_keyness" in quanteda
#
# 6: you can also try to get the dates of the publications of the reports. some of them are already included in the "DOP_final_data_14Jan2019_sentiment_analysis.xlsx" file
#    when you have the dates, you can plot the distribution of reports with high occurrences of "eu added value" in time, using the date on the X-axis and the occurrence counts created by the script
#    but there are so few reports with more than one occurrences, that you might just do it manually
#
# 7: you can also try sentiment analysis on the reports about eu added value. check if it makes a difference if you analyse the whole report text, or just the executive summary
#    try the different sentiment analysis dictionaries mentioned in Chapter 2 of the book