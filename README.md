# Publication Process of Eurovoc

This is a description of the transformation processes for SRC-AP assets that are edited in VocBench and shall be published as SKOS-AP-EU in Cellar. The current implementation of the transformation pipelines uses Linked Pipes ETL (https://etl.linkedpipes.com/).

#### **Input:** 

* Full export from VocBench (4.0 +) in SRC-AP format.   
* Alignment files.
  
#### **Output goals:**
* Generated SKOS-core. 
* Generated SKOS-AP-EU public (for broad dissemination). 
* Generated SKOS-AP-EU backwards compatible (for activation in Cellar). 
* And to generate SKOS candidates (for GIL Eurovoc). 

### ETL pipelines description
* **Phase-0** : ingests the data exported from VocBench application (4.0+) into the graph SRC-AP and loads them into an ETL pipeline :
    * from VocBench (SRC-AP), the data are exported into the graph http://publications.europa.eu/resource/dataset/eurovoc/src-ap 
    * and candidates data into the graph http://publications.europa.eu/resource/dataset/eurovoc/src-ap-candidates.

* **Phase A.3.** : this is the first pre-process phase on the SRC-AP data (4.9 specific). It checks, cleans and controls the data, and moves them :
    * from http://publications.europa.eu/resource/dataset/eurovoc/src-ap 
    * to http://publications.europa.eu/resource/dataset/eurovoc/src-ap-49 
    * and into local files.  

* **Phase A.5.** : this second pre-process SRC-AP (generic) aims to create a SRC-AP that can be imported back into VocBench and is ready to be published as SKOS-AP.
This process transforms the data and moves them :
    * from http://publications.europa.eu/resource/dataset/eurovoc/src-ap-49 
    * to http://publications.europa.eu/resource/dataset/eurovoc/src-ap-generic  
    * and into local files.  

* **Phase A.7.** : alignments normalisation  
The goal of this exercise is to have no other triples in the file except following alignment statements :

                    skos:mappingRelation  
                    skos:closeMatch  
                    skos:exactMatch  
                    skos:broadMatch  
                    skos:narrowMatch  
                    skos:relatedMatch 

* **Phase B.0.** : publish SRC-AP as SKOS-AP-EU (2015) 
    * from http://publications.europa.eu/resource/dataset/eurovoc/src-ap-generic.
    * into http://publications.europa.eu/resource/dataset/eurovoc/skos-ap-2015.  
    * into local files.  

* **Phase B.1.** : publish SRC-AP-EU as SKOS-AP-EU (BWC) - backwards compatible 
    * from http://publications.europa.eu/resource/dataset/eurovoc/skos-ap-2015. 
    * into http://publications.europa.eu/resource/dataset/eurovoc/skos-ap-2015-bwc.  
    * into local files.
 
* **Phase B.3.** : publish SRC-AP as SKOS-core
   * from http://publications.europa.eu/resource/dataset/eurovoc/src-ap-generic  
   * into http://publications.europa.eu/resource/dataset/eurovoc/skos-core 
   * local file 

* **Phase B.5.** : publish SRC-AP candidates as SKOS-core candidates
   * from http://publications.europa.eu/resource/dataset/eurovoc/src-ap-candidates. 
   * into local files only .

![The process description](./ProcessDescription.png)

### A.3 Version 4.9 specific preprocessing (clean-up)

* A.3.1 : remove lexvo properties from prefLabel and altlabel.  
* A.3.2 : select all the labels in GA that have the same values as EN and remove the ones in GA (gaelic)
* A.3.3 : delete all the alignments from the dataset   
    * A.3.3.a : additionally delete the statements belonging to the foreign URIs (the ones that eurovoc concept is mapped to) 
    * A.3.3.b : before this operation, check/ask whether there is any eurovoc concept mapped to another eurovoc concept 
* A.3.4 : delete all the ?subjects that do not belong to the eurovoc namespace by handpicking specific namespaces (knowing their distinguished marker)

                   ?ms ?p ?o .
                    FILTER( contains( str(?ms), "stw") 
                    || contains( str(?ms), "agrovoc") 
                    || contains( str(?ms), "gemet") 
                    || contains( str(?ms), "gnd") 
                    || contains( str(?ms), "id.loc")
                    || contains( str(?ms), "bnf") 
                    || contains( str(?ms), "zbw") 
                    || contains( str(?ms), "uba") 
                    || contains( str(?ms), "lib-thesaurus")
                    || contains( str(?ms), "unesco")
                    || contains( str(?ms), "itm:"))
        
    * A.3.4.a : test that the remaining triples contain no NON-eurovoc subjects 
* A.3.5 : check for concepts that belong only to EuroVoc concept scheme (or none) and mark them as deprecated 
* A.3.6 : delete (the reified) skos:notations that have duplicate values (rdf:value and if available dct:type) 
    (TODO : to be checked if the context works for NALs (expected dct:type for the notation type) )
* A.3.7 : if there are non-reified skos:note, reify them with euvoc:XlNote objects (rdf:value value property) 
* A.3.8 : if there are non-reified skos:notation, reify them with euvoc:XlNotation objects (rdf:value value property) 
* A.3.9 : delete objects (except those from eurovoc namespace) of type alignment, ontology or dataset : <http://knowledgeweb.semanticweb.org/heterogeneity/alignment#Ontology>, <http://knowledgeweb.semanticweb.org/heterogeneity/alignment#Alignment>, owl:Ontology;  
* A.3.10 : if a concept belongs only to <http://eurovoc.europa.eu/100141> concept scheme, then mark it as owl:deprecated "true"^^xsd:boolean. 
* A.3.11 : delete the dct:title from reified notes and notations (all of them) 
* A.3.12 : fix the ontology statements  
    * A.3.12.(a) : delete ns0:Ontology statement (subject is http://eurovoc.europa.eu) 
    * A.3.12.(b) : change the owl:Ontology subject from http://eurovoc.europa.eu/ into http://eurovoc.europa.eu (remove the last slash) 

### A.5. Generic pre-processing/normalisation SRC-AP

* A.5.1 :  if a concept lack start date add euvoc:startDate, set it to [1952-06-16].  
* A.5.2 :  normalise the date format (remove the datetime instances) [dct:created, dct:modified, euvoc:startDate, euvoc:endDate]  
* A.5.3  : If a current label (pref or alt) lacks start date then add the start date of the concept.  
* A.5.4 :  set/increase owl:versionInfo to "4.9" to http://eurovoc.europa.eu/100141 
* A.5.5 :  check if something (concept or label) has no owl:VersionInfo, add the latest version (get the latest version from http://eurovoc.europa.eu/100141 )
   * A.5.5.1 : add owl:versionInfo to concepts 
   * A.5.5.2 : add owl:versionInfo to labels (from concepts) 
   * A.5.5.3 : add owl:versionInfo to notes and notatiosn (from concepts)  
   * A.5.5.3 : replace the owl:versionInfo in skos:conceptSchemes using the one from http://eurovoc.europa.eu/100141 
* A.5.6 : replace the euvoc:status DEPRECATED by corresponding owl:deprecated "true" property (if current then omit the statement rather than set owl:deprecated to false) 
* A.5.7 : delete the euvoc:status CURRENT  
* A.5.8 : check for resource that have an end date but do not have the status owl:deprecated true  
   * A.5.8.(a) : concepts  
   * A.5.8.(b) : labels  
   * A.5.8.(c) : notes  
   * A.5.8 (d) : notations 
* A.5.9 : check for resources that are owl:deprecated but do not have any end date and set it to the end date of the previous version (i.e 4.8 for instance) : 
   * A.5.9.(a) : concepts  
   * A.5.9.(b) : labels  
   * A.5.9.(c) : notes  
   * A.5.9.(d) : notations 
* A.5.10 : any label that has dct:type set as STANDARD and is linked to the concept by skosxl:altLabel, shall be set to have an end date (with the value of concept's modification date) and a deprecated status. 
* A.5.11 : check if any reified skos:note has no type specified, then add XlNote  
* A.5.12 : check if any reified skos:notation has no type specified, then add euvoc:XlNotation 
* A.5.13 : check for any label that has no type specified, then add skosxl:Label  
* A.5.14 : check if there are any mapping relations between two concepts with the same namespace. If so, transform it into the corresponding semantic relastion. 
* A.5.15 : check if a skosxl:prefLabel has no dct:type, then set it to <http://publications.europa.eu/resource/authority/label-type/STANDARDLABEL> 
* A.5.16 : check if a skosxl:altLabel has no dct:type, then set it to <http://publications.europa.eu/resource/authority/label-type/ALTERNATIVELABEL> 
* A.5.17 : check if there is anywhere a owl:deprecated "false"^^xsd:boolean statement and remove it.  
* A.5.18 : empty the :candidates concept scheme, but preserve the concept scheme. 
* A.5.19 : for each concept that has no skos:notation , usually the candidates, create one (a reified form) with the value equal to the last segment of the concept URI.  
* A.5.20 : if the concept has no dct:created date, then add it (set value to now() ) 
* A.5.21 : check if each concept has a skosxl:prefLabel in all 23 languages. 
* A.5.22 : check if there is no skos:prefLabel.   

### A.7. alignments normalisation  
* A.7.1 read alignments files from input folder, one by one  
* A.7.2 construct from each file "?c ?matchingRelation ?o" but only where  : 

       VALUES ?matchingRelation {skos:mappingRelation skos:closeMatch skos:exactMatch skos:broadMatch skos:narrowMatch skos:relatedMatch} 

* A.7.3 write the results into a file (with the same name as the input) but place it in the output folder.  

### B.0. publish SRC-AP as SKOS-AP
* B.0.1 : delete/ignore the :candidates concept scheme.
* B.0.3 : create de-reified skos:notation by copying the value, and attach the current object using the euvoc:xlNotation property.  
* B.0.4 : create de-reified notes by copying the value, attach the current object with a new target relation for each sourceRelation as shown below, 

       VALUES (?sourceRel ?targetRel) {
            (skos:changeNote euvoc:xlChangeNote)
            (skos:definition euvoc:xlDefinition )
            (skos:example euvoc:xlExample)
            (skos:historyNote euvoc:xlHistoryNote)
            (skos:scopeNote euvoc:xlScopeNote)
            (skos:editorialNote euvoc:xlEditorialNote)
            (skos:note euvoc:xlNote)
            #(skos:notation euvoc:xlNotation)}
            
* B.0.5 : create de-reified labels (ingest the whole SKOS-core graph). 
* B.0.8 : if a concept has no owl:deprecated property, insert euvoc:status CURRENT. 
* B.0.9 : if a concept has owl:deprecated property, insert euvoc:status DEPRECATED 
* B.0.10 : if a label, note, or notation has no owl:deprecated property, insert euvoc:status CURRENT 
* B.0.11 : if a label, note, or notation has owl:deprecated property, insert euvoc:status DEPRECATED 
* B.0.12 : delete all owl:deprecated statements . 
 
### B.1. publish EuroVoc SRC-AP as SKOS-AP Backwards Compatible
* B.1.1 : Construct the euvoc:xlCodification to euvoc:XlNotation with value same as rdf:value. 
* B.1.2 : Construct the euvoc:xlNote to euvoc:XlNote with value same as rdf:value.
* B.1.3 : construct old EuroVoc ontology domains. 
* B.1.4 : construct old EuroVoc ontology preferred and non preferred terms (2 SPARQL query). 
* B.1.5 : construct old EuroVoc ontology thesaurus concepts.
* B.1.6 : construct old EuroVoc ontology domain classification (not sure what it is). 
* B.1.7 : construct old EuroVoc ontology microthesaurus.
* B.1.8 : construct old EuroVoc ontology thesaurus.
* B.1.9 : construct dct:subject from euvoc:domain.
* B.1.10 : construct mirror for replaces/isReplacedBy. 
* B.1.11 : construct mirror for topConceptOf/hasTopconcept. 
* B.1.12 : create a dct:identifier and dc:identifier for every value of skos:notation (in Concept and in ConceptScheme) 
* B.1.13 : if a concept has no skos:broader then insert skos:topConceptOf for each ConceptSchem it belongs to  
* B.1.14 : provide mirror triples for reflexive properties (skos:related) 
* B.1.15 : Check if both evo:domain and euvoc:domain properties are on evo:MicroThesaurus 

### Additional information
Technical notes for the current (18 Dec 2018) implementation
Linked Pipes Workbench: http://server.costezki.ro:8181/# 
Virtuoso instance endpoint: http://server.costezki.ro:8890/sparql 
input data: /home/ubuntu/docker-etl/data/input 
output data: /home/ubuntu/docker-etl/data/output 
Vocbench : http://vocbench.uniroma2.it/
The source code of the ETL pipeline is available at : https://github.com/costezki/eurovoc-pipelines/tree/master/src  
