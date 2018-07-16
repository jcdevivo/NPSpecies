taxaKingdom<-function(x) {
  KingdomTaxa <- NPSpeciesJustSpecies[NPSpeciesJustSpecies$Kingdom==x,]
  KingdomTaxa <- as.data.frame(CategoryTaxa$SciName)
  return(KingdomTaxa)
}

listTaxaCategories<-function(y) {
  unique(NPSpeciesJustSpecies$CategoryName)
}

taxaCategories<-function(z) {
  CategoryTaxa <- NPSpeciesJustSpecies[NPSpeciesJustSpecies$CategoryName==z,]
  CategoryTaxa <- as.character(CategoryTaxa$SciName)
  return(CategoryTaxa)
}
