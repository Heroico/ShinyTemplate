#! /usr/bin/env python

import sqlite3
import os

FOLDER = "results"
OUTPUT = "allresultsn.db"

class RTF(object):
    GENE=0
    GENE_NAME=1
    ZSCORE=2
    PVALUE=3
    PRED_PERF_R2=4
    VAR_G=5
    N=6
    COVARIANCE_N=7
    MODEL_N=8

contents = os.listdir(FOLDER)

if os.path.exists(OUTPUT): os.remove(OUTPUT)

connection = sqlite3.connect(OUTPUT)
cursor = connection.cursor()
query = 'CREATE TABLE results (' \
' "gene" TEXT,' \
' "gene_name" TEXT,' \
' "zscore" REAL,' \
' "n" INTEGER,' \
' "model_n" INTEGER,' \
' "pred_perf_R2" REAL,' \
' "pval" REAL,' \
' "tissue" TEXT' \
' );'
print query
results = cursor.execute(query)
connection.commit()

for content in contents:
    path = os.path.join(FOLDER, content)
    print "opening "+path
    with open(path) as file:
        for i, line in enumerate(file):
            if i==0: continue

            comps = line.strip().split(",")
            if comps[RTF.ZSCORE] == "NA": continue

            gene = comps[RTF.GENE]
            gene_name = comps[RTF.GENE_NAME]
            zscore = float(comps[RTF.ZSCORE])
            n = int(comps[RTF.N])
            model_n = int(comps[RTF.N])
            pred_perf_r2 = float(comps[RTF.PRED_PERF_R2])
            pval = float(comps[RTF.PVALUE])

            tissue = content
            if "COGS_" in tissue: tissue = tissue.split("COGS_")[1]
            if "_elasticNet" in tissue: tissue =tissue.split("_elasticNet")[0]
            if "-unscaled" in tissue: tissue = tissue.split("-unscaled")[0]
            if ".csv" in tissue: tissue = tissue.split(".csv")[0]
            cursor.execute(
                    "insert into results (gene, gene_name, zscore, n, model_n, pred_perf_R2, pval, tissue) values (?,?,?,?,?,?,?,?)",
                    (gene, gene_name, zscore, n, model_n, pred_perf_r2, pval, tissue,))
    connection.commit()

connection.close()