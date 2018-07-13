# load packages

packages <- c("tm", "dplyr", "stringr", "SnowballC", "pdftools", "stringi", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")

package.check <- lapply(packages, FUN = function(x) {

  if (!require(x, character.only = TRUE)) {

 #   install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")

    library(x, character.only = TRUE)

  }

})


# get taxon list from NPSpecies database

load("data/NPSpeciesJustSpecies.rda")
testtaxa<-as.data.frame(c("Zenaida macroura", "Sitta pusilla", "Vireo flavifrons", "Corvus ossifragus", "Corvus brachyrhynchos", "Spinus tristis", "Hyla squirella", "Rana sphenocephala", "Bufo fowleri", "Bufo terrestris", "Anolis carolinensis"))
taxa<-as.data.frame(NPSpeciesJustSpecies$SciName)



# extract text from pdf file and prepare for comparison. See:
# https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html

doclocation <- file.path("D:/texts")

docs <- VCorpus(DirSource(doclocation), readerControl = list(reader=readPDF(engine = "pdftools")))
DocsCopy <- docs
summary(docs)

#Preprocessing text for comparisons
docs <- tm_map(docs,removePunctuation)

for (j in seq(docs)) {
  docs[[j]] <- gsub("/", " ", docs[[j]])
  docs[[j]] <- gsub("@", " ", docs[[j]])
  docs[[j]] <- gsub("\\|", " ", docs[[j]])
  docs[[j]] <- gsub("\u2028", " ", docs[[j]])  # This is an ascii character that did not translate, so it had to be removed.
}

docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, PlainTextDocument)

doccontent<-lapply(docs$content, '[[', 1)


# function to allow user to check pdf documents for species within any taxonomy list desired.

scrapepdf<-function(taxalist) {
  start_time <- Sys.time()
  results<-data.frame(IRMAReferenceNumber=character(),SciName=character())

# Start Document Loop

for (doccount in 1:length(doccontent)) {


# Start Taxa Loop

  for (taxacount in 1:nrow(taxalist)) {

    if (stri_detect_fixed(doccontent[doccount],taxalist[taxacount,1])=="TRUE") {

    results<-rbind(results,data.frame(cbind(DocsCopy[[doccount]][[2]][5]),taxalist[taxacount,1]))

    }
  }

}

 names(results)<-c("IRMAReferenceNumber","SciName")
 results$IRMAReferenceNumber<-gsub(".pdf","",results$IRMAReferenceNumber)
 distinct(results)
 refs<-unique(results$IRMAReferenceNumber)
 for (i in 1:length(refs)){
   write.csv(subset(results, IRMAReferenceNumber==refs[i]), paste('d:/SpeciesScraperCSVfiles/', refs[i],'_', deparse(substitute(taxalist)), ".csv", sep=""), row.names=F)
 }
 totaltime<-Sys.time()-start_time
 return(totaltime)
 return(results)

}





