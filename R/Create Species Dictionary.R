# load packages

packages <- c("quanteda")

package.check <- lapply(packages, FUN = function(x) {

  if (!require(x, character.only = TRUE)) {

    #   install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")

    library(x, character.only = TRUE)

  }

})

# Create mini dictionaries

listSpecies<-(list(birds=c(taxaCategories("Bird")),
                   fish=c(taxaCategories("Fish")),
                   insects=c(taxaCategories("Insect")),
                   chromista=c(taxaCategories("Chromista")),
                   bacteria=c(taxaCategories("Bacteria")),
                   othernonverts=c(taxaCategories("Other Non-vertebrates")),
                   NonvascularPlants=c(taxaCategories("Non-vascular Plant")),
                   fungi=c(taxaCategories("Fungi")),
                   protozoans=c(taxaCategories("Protozoa")),
                   VascularPlants=c(taxaCategories("Vascular Plant")),
                   slugsandsnails=c(taxaCategories("Slug/Snail")),
                   amphibians=c(taxaCategories("Amphibian")),
                   reptiles=c(taxaCategories("Reptile")),
                   mammals=c(taxaCategories("Mammal")),
                   CrabsLobsersShrimp=c(taxaCategories("Crab/Lobster/Shrimp")),
                   SpiderScorpion=c(taxaCategories("Spider/Scorpion")),
                   Archaea=c(taxaCategories("Archaea"))
              ))

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
))

dicSpecies<-dictionary(listSpecies,separator = " ", tolower=FALSE)

SciNames<-data.frame(NPSpeciesJustSpecies$SciName,NPSpeciesJustSpecies$CategoryName)
names(SciNames)[1]<-paste("word")
names(SciNames)[2]<-paste("sentiment")

temp<-as.list(SciNames$word)

TaxonomicDictionary<-dictionary(temp, tolower=FALSE)

write.csv(SciNames,file="data/SciNames.cat")



TaxonomicTokens<-phrase(temp$word)

ScientificName
