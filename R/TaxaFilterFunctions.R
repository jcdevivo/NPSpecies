taxaKingdom<-function(x) {
  KingdomTaxa <- NPSpeciesJustSpecies[NPSpeciesJustSpecies$Kingdom==x,]
  return(KingdomTaxa)
}

listTaxaCategories<-function(y) {
  unique(NPSpeciesJustSpecies$CategoryName)
}

taxaCategories<-function(z) {
  CategoryTaxa <- NPSpeciesJustSpecies[NPSpeciesJustSpecies$CategoryName==z,]
  return(CategoryTaxa)
}
