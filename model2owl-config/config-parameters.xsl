<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd xsl dc fn"
    xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vann="http://purl.org/vocab/vann/"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> OCT 18, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines project level variables and parameters</xd:p>
        </xd:desc>
    </xd:doc>



    <!-- a set of prefix-baseURI definitions -->
    <xsl:variable name="namespacePrefixes" select="fn:doc('namespaces.xml')"/>

    <!-- a mapping between UML atomic types to XSD datatypes  -->
    <xsl:variable name="umlDataTypesMapping" select="fn:doc('umlToXsdDataTypes.xml')"/>

    <!-- XSD datatypes that conform to OWL2 requirements   -->
    <xsl:variable name="xsdAndRdfDataTypes" select="fn:doc('xsdAndRdfDataTypes.xml')"/>
    <!--    set default namespace interpretation for lexical Qnames that are not prefix:localSegment or :localSegment. If this 
    is set to true localSegment will transform to :localSegment-->
    <xsl:variable name="defaultNamespaceInterpretation" select="fn:true()"/>

    <!-- Ontology base URI, configure as necessary. Do not use a trailing local delimiter 
        like in the namespace definition-->
    <!--<xsl:variable name="base-uri" select="'http://publications.europa.eu/ontology/ePO'"/>-->
    <xsl:variable name="base-ontology-uri" select="'http://data.europa.eu/src-ap/ontology/'"/>
    <xsl:variable name="base-shape-uri" select="'http://data.europa.eu/src-ap/data-shape'"/>
    <xsl:variable name="base-restriction-uri" select="$base-ontology-uri"/>
    <!--    Shapes Module URI-->
    <xsl:variable name="shapeArtefactURI"
        select="fn:concat($base-shape-uri, $defaultDelimiter, $moduleReference, '-shape')"/>
    <!--    Restrictions Module URI-->
    <xsl:variable name="restrictionsArtefactURI"
        select="fn:concat($base-restriction-uri, $defaultDelimiter, $moduleReference, '-restriction')"/>
    <!--    Core Module URI-->
    <xsl:variable name="coreArtefactURI"
        select="fn:concat($base-ontology-uri, $defaultDelimiter, $moduleReference)"/>

    <!-- when a delimiter is missing in the base URI of a namespace, use this default value-->
    <xsl:variable name="defaultDelimiter" select="'#'"/>

    <!-- types of elements and names for attribute types that are acceptable to produce object properties -->
    <xsl:variable name="acceptableTypesForObjectProperties"
        select="('epo:Identifier', 'rdfs:Literal')"/>
    <!--    the type of attributes which takes values from a controlled list-->
    <xsl:variable name="controlledListType" select="'epo:Code'"/>
    <!-- Acceptable stereotypes -->
    <xsl:variable name="stereotypeValidOnAttributes" select="()"/>
    <xsl:variable name="stereotypeValidOnObjects" select="()"/>
    <xsl:variable name="stereotypeValidOnGeneralisations"
        select="('Disjoint', 'Equivalent', 'Complete')"/>
    <xsl:variable name="stereotypeValidOnAssociations" select="()"/>
    <xsl:variable name="stereotypeValidOnDependencies" select="('Disjoint', 'disjoint', 'join')"/>
    <xsl:variable name="stereotypeValidOnClasses" select="('Abstract')"/>
    <xsl:variable name="stereotypeValidOnDatatypes" select="()"/>
    <xsl:variable name="stereotypeValidOnEnumerations" select="()"/>
    <xsl:variable name="stereotypeValidOnPackages" select="()"/>

    <xsl:variable name="abstractClassesStereotypes" select="('Abstract', 'abstract class', 'abstract')"/>

    <!--    This variable controls whether the enumeration items are transformed into skos concepts or ignored-->
    <xsl:variable name="enableGenerationOfSkosConcept" select="fn:false()"/>

    <!--    This variable controls whether the enumerations are transformed into skos schemes or ignored-->
    <xsl:variable name="enableGenerationOfConceptSchemes" select="fn:true()"/>

    <!--Allowed characters for a normalized string-->
    <xsl:variable name="allowedStrings" select="'^[\w\d-_:]+$'"/>

    <!--    Generate reused classes, attributes and connectors-->
    <xsl:variable name="generateReusedConcepts" select="fn:true()"/>


    <xsl:variable name="reference-to-external-classes-in-glossary" select="fn:true()"/>

    <xsl:variable name="generateObjectsAndRealisations" select="fn:false()"/>

    <xsl:variable name="conventionReportCopyrightText" select="'Publications Office of the European Union, 2023'"/>
    <xsl:variable name="conventionReportAuthor" select="'Publications Office of the European Union'"/>
    <xsl:variable name="conventionReportAuthorLocation" select="'Luxembourg'"/>
    <xsl:variable name="conventionReportAuthorWebsite" select="'https://op.europa.eu'"/>
    <xsl:variable name="conventionReportUMLModelName" select="'eProcurement'"/>

    <!-- _______________________________________________________________________   -->
    <!--                            METADATA SECTION                               -->
    <!-- _______________________________________________________________________   -->
    <!--    This section contains the variables used to build the ontology metadata-->
    <xsl:variable name="moduleReference" select="'src-ap'"/>
    <!--    dct:title -->
    <xsl:variable name="ontologyTitleCore" select="'src-ap core'"/>
    <xsl:variable name="ontologyTitleRestrictions" select="'src-ap restrictions'"/>
    <xsl:variable name="ontologyTitleShapes" select="'src-ap shapes'"/>
    <!--    dct:description-->
    <xsl:variable name="ontologyDescriptionCore"
        select="
            'This artefact provides the definitions for the src-ap module.
            This artefact excludes the restrictions.
            '"/>
    <xsl:variable name="ontologyDescriptionRestrictions"
        select="
            'This artefact provides the restrictions and inference-related specifications for the src-ap module.
            This artefact excludes the definitions of concepts.
   '"/>
    <xsl:variable name="ontologyDescriptionShapes"
        select="
            'This artefact provides the generic datashape specifications for the src-ap module.
           '"/>
    <!--    rdfs:seeAlso -->
<!--    <xsl:variable name="seeAlsoResources"-->
<!--        select="-->
<!--            ('https://github.com/OP-TED/ePO/releases',-->
<!--            'https://joinup.ec.europa.eu/collection/eprocurement/solution/eprocurement-ontology/about',-->
<!--            'https://op.europa.eu/en/web/eu-vocabularies/e-procurement',-->
<!--            'https://docs.ted.europa.eu/home/index.html')"/>-->
    <!--    dct:issued-->
    <xsl:variable name="issuedDate" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    <!--    owl:incompatibleWith -->
<!--    <xsl:variable name="incompatibleWith" select="'3.1.0'"/>-->
<!--    &lt;!&ndash;    owl:versionInfo &ndash;&gt;-->
<!--    <xsl:variable name="versionInfo" select="'4.0.0'"/>-->
<!--    &lt;!&ndash;    bibo:status&ndash;&gt;-->
    <xsl:variable name="ontologyStatus" select="'Semantic Specification Release'"/>
    <!--    owl:priorVersion -->
<!--    <xsl:variable name="priorVersion" select="'3.1.0'"/>-->
<!--    &lt;!&ndash;    vann:preferredNamespaceUri &ndash;&gt;-->
<!--    <xsl:variable name="preferredNamespaceUri" select="'http://data.europa.eu/a4g/ontology#'"/>-->
<!--    &lt;!&ndash;    vann:preferredNamespacePrefix &ndash;&gt;-->
<!--    <xsl:variable name="preferredNamespacePrefix" select="'epo'"/>-->
<!--    &lt;!&ndash;    dct:rights&ndash;&gt;-->
<!--    <xsl:variable name="rightsLiteral" select="'© European Union, 2014-->
<!--            Unless otherwise noted, the reuse of the Ontology is authorised under the Licence ISA Open Metadata Licence v1.111.'"/>-->
<!--    &lt;!&ndash;    dct:license&ndash;&gt;-->
<!--    <xsl:variable name="licenseURI" select="'ISA Open Metadata Licence v1.1 | Joinup (europa.eu)'"/>-->
<!--    &lt;!&ndash;    cc:attributionName&ndash;&gt;-->
<!--    <xsl:variable name="attributionNameLiteral" select="'European Union'"/>-->
<!--    &lt;!&ndash;    cc:attributionURL&ndash;&gt;-->
<!--    <xsl:variable name="attributionURL" select="'http://publications.europa.eu/resource/authority/corporate-body/EURUN'"/>-->
<!--    &lt;!&ndash;    dct:publisher&ndash;&gt;-->
<!--    <xsl:variable name="publisher" select="'http://publications.europa.eu/resource/authority/corporate-body/PUBL'"/>-->
</xsl:stylesheet>