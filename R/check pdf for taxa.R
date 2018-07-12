# load packages

packages <- c("tm", "SnowballC", "stringi", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc", "Rcampdf")

package.check <- lapply(packages, FUN = function(x) {

  if (!require(x, character.only = TRUE)) {

 #   install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")

    library(x, character.only = TRUE)

  }

})


# get taxon list from NPSpecies database

load("data/NPSpeciesJustSpecies.rda")
numberoftaxa<-nrow(NPSpeciesJustSpecies)

# testtaxa<-as.data.frame(c("Hyla squirella", "Rana sphenocephala", "Bufo fowleri", "Bufo terrestris", "Anolis carolinensis"))
# names(testtaxa)[1]<-paste("taxa")
taxa<-as.data.frame(NPSpeciesJustSpecies$SciName)



# extract text from pdf file and prepare for comparison. See:
# https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html

library(tm)

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

numberofdocs<-length(doccontent)
numberoftaxa<-nrow(NPSpeciesJustSpecies)

# do comparison
# results<-apply(taxa, 1, function(x) grepl(x,docs$content, fixed=TRUE))
# results3<-apply(testtaxa, 1, function(x) stri_detect_fixed(doccontent,x,negate=FALSE))

checkpdffortaxon<-function(doc,taxon) {
  stri_detect_fixed(doccontent[doc],taxa[taxon,1])
}



rm(results2)

# Start Document Loop

 y<-1
 repeat
 {


# Start Taxa Loop

  x<-1
  repeat
  {

  if (checkpdffortaxon(y,x)=="TRUE") {

    results<-data.frame(cbind(DocsCopy[[y]][[2]][5]),taxa[x,1])

    if (exists('results2')) {
      results2<-rbind(results2,results)
      } else {
      results2<-results
      }

    }

  # End Taxa Loop
    x = x+1
    if(x==numberoftaxa+1)
    {
      break
    }

  }

    # End Document Loop
  y = y+1
  if(y==numberofdocs+1)
  {
    break
  }


 }



























# generate metadata csv files
hits<-t(t(apply(results, 1, function(u) paste('"', names(which(u)), '"', sep="", collapse="," ))))
hits<-as.data.frame.vector(hits)

filenames<-lapply(unlist(DocsCopy, recursive = FALSE), `[`, 2)
filenames<-lapply(unlist(filenames, recursive = FALSE), `[[`, 5)
filenames<-do.call(rbind.data.frame, filenames)
names(filenames)[1]<-paste("filename")
filenames<-str_replace(filenames$filename,".pdf",".csv")
hitsbyref<-cbind(filenames,hits)





