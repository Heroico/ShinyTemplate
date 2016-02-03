source("helpers.R")

#reset Shiny Server when data gets updated
sgt <- scan("data/sgt", what=character())
sgp <- scan("data/sgp", what=character())


shinyUI(fluidPage(
  fluidPage(
    titlePanel("Metaxcan Association results"),

    p("'Tissue' stands for different transcriptome models used when generating the association."),
    p("Tissues built with GTEX data, covariances with 1000 Genomes."),
    # Create a new Row in the UI for selectInputs
    fluidRow(
      column(3,
          textInput("gene_name",
                      "Gene Name:",
                      "")
      ),
      column(1,
        checkboxInput("ordered", label = "Ordered", value = TRUE)
      ),
      column(2,
          selectInput("pheno",
                      "Phenotype:",
                      sgp)
      ),
      column(2,
          selectInput("tissue",
                      "Tissue:",
                      sgt)
      ),
      column(2,
          numericInput("threshold",
                      "Pvalue threshold:",
                      0.05)
      ),
      column(2,
          numericInput("limit",
                      "Record limit:",
                      100)
      )
    ),
    # Create a new row for the table.
    fluidRow(
      dataTableOutput(outputId="table")
    )
  )
))
