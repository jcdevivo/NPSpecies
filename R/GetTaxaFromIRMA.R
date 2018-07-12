packages <- c("RODBC")

package.check <- lapply(packages, FUN = function(x) {

  if (!require(x, character.only = TRUE)) {

    install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")

    library(x, character.only = TRUE)

  }

})


# get taxon list from NPSpecies database

UpdateTaxa<-function() {

  ch<-odbcConnect("Taxonomy", uid = "Report_Data_Reader", pwd = "ReportDataUser")
NPSpeciesTaxa<- sqlFetch(ch,"TaxonGridFields", as.is=T)
NPSpeciesJustSpecies<-NPSpeciesTaxa[NPSpeciesTaxa[, "Rank"] == "Species",]
save(NPSpeciesJustSpecies,file="data/NPSpeciesJustSpecies.rda")

}

taxaKingdom<-function(x) {
    KingdomTaxa <- NPSpeciesJustSpecies[NPSpeciesJustSpecies$Kingdom==x,]
    return(KingdomTaxa)
}
