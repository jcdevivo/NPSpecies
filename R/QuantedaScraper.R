# load packages

packages <- c("readtext", "quanteda")

package.check <- lapply(packages, FUN = function(x) {

  if (!require(x, character.only = TRUE)) {

    #   install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")

    library(x, character.only = TRUE)

  }

})

start_time <- Sys.time()

# Load most recent version of NPSpecies Taxonomy table and create Species dictionary file, This step only needs to be done once per session.

load("data/NPSpeciesJustSpecies.rda")

taxaCategories<-function(z) {
  CategoryTaxa <- NPSpeciesJustSpecies[NPSpeciesJustSpecies$CategoryName==z,]
  CategoryTaxa <- as.character(CategoryTaxa$SciName)
  return(CategoryTaxa)
}

dicSpecies<-dictionary(list(birds=c(taxaCategories("Bird")),
                            fish=c(taxaCategories("Fish")),
                            insects=c(taxaCategories("Insect")),
                            chromista=c(taxaCategories("Chromista")),
                            bacteria=c(taxaCategories("Bacteria")),
                            othernonverts=c(taxaCategories("Other Non-vertebrates")),
                            NonvascularPlants=c(taxaCategories("Non-vascular Plant")),
                            fungi=c(taxaCategories("Fungi")),
                            protozoans=c(taxaCategories("Protozoa")),
                            VascularPlantslis=c(taxaCategories("Vascular Plant")),
                            slugsandsnails=c(taxaCategories("Slug/Snail")),
                            amphibians=c(taxaCategories("Amphibian")),
                            reptiles=c(taxaCategories("Reptile")),
                            mammals=c(taxaCategories("Mammal")),
                            CrabsLobsersShrimp=c(taxaCategories("Crab/Lobster/Shrimp")),
                            SpiderScorpion=c(taxaCategories("Spider/Scorpion")),
                            Archaea=c(taxaCategories("Archaea"))
), tolower=FALSE)


# Read in pdf files and check for species contained in the dictionary. Test files are in the data directory with the package.

# doclocation <- file.path("D:/texts") #work computer
doclocation <- file.path("H:/texts") #home computer
# doclocation <- file.path("data")

docs<-readtext(paste0(doclocation, "/*.pdf"),
              docvarsfrom = "filenames",
              dvsep = "_"
               )

docscorpus<-corpus(docs)
hits<-as.data.frame(kwic(docscorpus,phrase(dicSpecies),valuetype="fixed", include_docvars=TRUE))

# Write results to CSV files
results<-distinct(data.frame(IRMAReferenceNumber=gsub(".pdf","",hits$docname),SciName=hits$keyword))

refs<-unique(results$IRMAReferenceNumber)
for (i in 1:length(refs)){
  write.csv(subset(results, IRMAReferenceNumber==refs[i]), paste("results/",refs[i],"_NPSpeciesSpecies.csv", sep=""), row.names=F)
}
print(Sys.time()-start_time)

