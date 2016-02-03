library(RPostgreSQL)

get_db <- function() {
    #Modify the following line to point to a different data set, if you want. Or just replace the db file with an appropriate one.
    drv <- dbDriver("PostgreSQL")
    db <- dbConnect(drv, host="127.0.0.1",dbname="kk2",user="kk", password="kk")
    return(db)
}

get_tissue_tag <- function(db) {
    tissue_tag <- dbGetQuery(db, "select distinct tag from tissue;")
    sgt <- c("All", tissue_tag$tag)
    return(sgt)
}

get_pheno_tag <- function(db) {
    pheno_tag <- dbGetQuery(db, "select distinct tag from pheno;")
    sgp <- c("All", pheno_tag$tag)
    return(sgp)
}

update_ui_cook <- function() {
    db <- get_db()
    sgt <- get_tissue_tag(db)
    write(sgt, file="data/sgt")
    sgp <- get_pheno_tag(db)
    write(sgp, file="data/sgp")
}