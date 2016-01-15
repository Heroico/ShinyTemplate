#! /usr/bin/env python
import sqlite3

DB_PATH = "allresults.db"
CSV_PATH = "allresults.csv"

class DBTF(object):
    GENE=0
    GENE_NAME=1
    ZSCORE=2
    VAR_G=3
    N=4
    COVARIANCE_N=5
    MODEL_N=6
    PRED_PERF_R2=7
    PVAL=8
    TISSUE=9

    column_names = ["gene", "gene_name", "zscore", "VAR_g", "n", "covariance_n", "model_n", "pred_perf_R2", "pval", "tissue"]
    header = ",".join(column_names)

print "opening db"
connection = sqlite3.connect(DB_PATH)
cursor = connection.cursor()
query = "select %s from results;" % DBTF.header
results = cursor.execute(query)

print "writing results"

with open(CSV_PATH, "w") as file:
     file.write(DBTF.header+"\n")
     for result in results:
         result = [str(x) for x in result if result[DBTF.ZSCORE] != None]
         line=",".join(result)+"\n"
         file.write(line)

