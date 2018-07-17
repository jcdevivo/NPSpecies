# load packages

packages <- c("tm", "readtext", "quanteda")

package.check <- lapply(packages, FUN = function(x) {

  if (!require(x, character.only = TRUE)) {

    #   install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")

    library(x, character.only = TRUE)

  }

})

load("data/NPSpeciesJustSpecies.rda")

doclocation <- file.path("D:/texts")

taxatokens<-phrase(dicSpecies)

docs<-readtext(paste0(doclocation, "/*.pdf"),
              docvarsfrom = "filenames",
              dvsep = "_"
               )

docscorpus<-corpus(docs)

docsdfm<-dfm(docscorpus, tolower=FALSE, select=dicSpecies, valuetype = "fixed")

hits<-dfm_lookup(mydocs,levels=1:2,dictionary=TaxonomicDictionary, valuetype="fixed")
