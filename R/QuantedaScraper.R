# load packages

packages <- c("tm", "readtext", "quanteda")

package.check <- lapply(packages, FUN = function(x) {

  if (!require(x, character.only = TRUE)) {

    #   install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")

    library(x, character.only = TRUE)

  }

})

doclocation <- file.path("D:/texts")

docs <- VCorpus(DirSource(doclocation), readerControl = list(reader=readPDF(engine = "pdftools")))

# import a tm VCorpus
if (requireNamespace("tm", quietly = TRUE)) {
  data(docs, package = "tm")    # load in a tm example VCorpus
  mytmCorpus <- corpus(docs)
  summary(mytmCorpus, showmeta=TRUE)

  data(acq, package = "tm")
  summary(corpus(acq), 5, showmeta=TRUE)

  tmCorp <- tm::VCorpus(tm::VectorSource(data_char_ukimmig2010))
  quantCorp <- corpus(tmCorp)
  summary(quantCorp)
}

taxatokens<-phrase(TaxonomicDictionary)

docs<-readtext(paste0(doclocation, "/*.pdf"),
              docvarsfrom = "filenames",
              dvsep = "_"
               )

docscorpus<-corpus(docs)

docsdfm<-dfm(docscorpus, tolower=FALSE, select=TaxonomicDictionary, valuetype = "fixed")

hits<-dfm_lookup(mydocs,levels=1:2,dictionary=TaxonomicDictionary, valuetype="fixed")
