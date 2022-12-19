<?xml version="1.0" encoding="utf-8"?> <!-- Prologo che definisce la versione XML e la codifica dei caratteri -->
<xsl:stylesheet version="3.0"           
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
 	xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:js="http://saxonica.com/ns/globalJS"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"> <!-- Elemento radice che dichiara che il documento è un foglio di stile XSL con versione 3. Inoltre, sono stati dichiarati i vari namespace che permettono di accedere agli elementi, agli attributi e alle funzionalità sia di XSL, che di SaxonJS, etc -->

    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="yes" /> <!-- Definizione del formato del documento di output -->

    <xsl:preserve-space elements="p"/>

    <!-- GESTIONE DELLE PORZIONI DI CODICE PRECEDENTI A <text> -->
    <xsl:template match="tei:teiHeader"/> <!-- Il <teiHeader> viene omesso semplicemente dichiarando una regola di template vuota -->

    <!-- GESTIONE DI <text> E DEI SUOI ELEMENTI FIGLI-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    <!-- Gestione del <front> -->
    <xsl:template match="tei:front">
        <xsl:apply-templates/><xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:template>

    <!-- Gestione dei <p> -->
    <xsl:template match="tei:p[not(parent::tei:front)]">
        <xsl:apply-templates/><xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <xsl:text> [</xsl:text><xsl:apply-templates/><xsl:text>] </xsl:text>
    </xsl:template>

    <xsl:template match="tei:add">
        <xsl:text>\</xsl:text><xsl:apply-templates/><xsl:text>\ </xsl:text>
    </xsl:template>

    <!-- Gestione delle porzioni censurate -->
    <xsl:template match="//tei:gap" >
        <xsl:text> *censura* </xsl:text>
    </xsl:template>

    <!-- Gestione dei <foreame> -->
    <xsl:template match="tei:forename">
        <xsl:text> </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <surname> -->
    <xsl:template match="tei:surname">
        <xsl:text></xsl:text><xsl:apply-templates/><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <placeName> -->
    <xsl:template match="tei:placeName">
        <xsl:text> </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <date> -->
    <xsl:template match="//tei:date">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <measure> -->
    <xsl:template match="//tei:measure">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="//tei:num">
        <xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione degli <address> -->
    <xsl:template match="//tei:address">
        <xsl:text> </xsl:text><xsl:apply-templates />
    </xsl:template>

    <!-- Gestione degli <orgName> -->
    <xsl:template match="//tei:orgName">
        <xsl:text> </xsl:text><xsl:apply-templates />
    </xsl:template>

    <!-- Gestione degli <foreign> -->
    <xsl:template match="//tei:foreign">
        <xsl:text> </xsl:text><xsl:apply-templates />
    </xsl:template>

    <!-- Gestione degli <term> -->
    <xsl:template match="//tei:term">
        <xsl:text> </xsl:text><xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>