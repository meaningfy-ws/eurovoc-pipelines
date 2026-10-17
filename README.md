#  Content improvement implementation

> **Infrastructure change (2026-10-17).** The Meaningfy HashiCorp Vault (`vault.meaningfy.ws`) is being retired, and the services on its host (srv) have been stopped. Secret values now live in the company Vaultwarden; CI/CD reads them from GitHub Secrets and Variables (per GitHub Environment); hosted deployments live in `meaningfy-ws/infrastructure-stacks`. Do not add new Vault reads. What this repo has to change: https://github.com/meaningfy-ws/eurovoc-pipelines/issues/2

Following is a description of the transformation processes for SRC-AP assets that are edited in VocBench and shall be published as SKOS-AP-EU in Cellar. 
The current implementation of the transformation pipelines uses Linked Pipes ETL (https://etl.linkedpipes.com/).
The transformation processes aims to clean up the Authority Tables (AT) content using a well-established framework to resolve semantic dissonances, redundancies, overlaps, and other types of issues.

#### **Folders:** 

* SAI_W.P2.1_pipelines contains the pipelines with all executed transformations that aim to simplify the Authority Tables.
* Old_Pipeline contains all the developed process for previous publication process of Eurovoc.

#### **Input:** 

*  SRC-AP files  for Corporate Body, Corporate Body Classification, Country, Membership Classification, Site, Language and Place Authority Tables.

  
#### **Output goals:**
* To generate simplified and clean SREC-AP files. 

### ETL pipelines description
We developed a structured approach to implement the recommended actions based on the  findings and executed transformations on the ATs in their SRC-AP representation, as following. 
* Extract the data from a GraphDB RDF database (triplestore), where the SRC-AP files are uploaded.
* Apply transformations within the pipeline to convert the source data into the desired target representation.
* load the processed data back into the triplestore in a new target environment, ensuring that the refined data would be readily available for use.

   