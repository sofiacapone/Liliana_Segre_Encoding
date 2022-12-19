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
    
    
    <!-- GESTIONE DEGLI SPAZI -->
    <xsl:strip-space elements="u"/> <!-- In questo modo, ogni utterance viene separata dall'altra da un 'a capo' per una lettura più agevole -->
    
    <!-- GESTIONE DELLE PORZIONI DI CODICE PRECEDENTI A <text> -->
    <xsl:template match="tei:teiHeader"/> <!-- Il <teiHeader> viene omesso semplicemente dichiarando una regola di template vuota -->
    <xsl:template match="tei:standOff"/>  <!-- Lo <standOff> viene omesso semplicemente dichiarando una regola di template vuota -->

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    <!-- GESTIONE DI <text> e dei suoi elementi -->
    <xsl:template match="//tei:u">
        <xsl:choose> 
            <!-- Gestione degli enunciati sovrapposti -->
            <xsl:when test="self::node()[not(@xml:id)] and self::node()[@who='#LS']">
                <p><b><xsl:text>Liliana Segre (sovrapposizione): </xsl:text></b><xsl:text>«</xsl:text><xsl:apply-templates /><xsl:text>»</xsl:text><xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text></p>
            </xsl:when>
            <xsl:when test="self::node()[not(@xml:id)] and self::node()[@who='#AS']">
                <p><b><xsl:text>Anna Segre (sovrapposizione): </xsl:text></b><xsl:text>«</xsl:text><xsl:apply-templates /><xsl:text>»</xsl:text><xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text></p>
            </xsl:when>
            <!-- Gestione degli enunciati non sovrapposti -->
            <xsl:when test="(./@who='#LS') and (./@xml:id) and (./@synch)">
                <p><b><xsl:text>Liliana Segre: </xsl:text></b><xsl:text>«</xsl:text><xsl:apply-templates /><xsl:text>»</xsl:text><xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text></p>
            </xsl:when>
            <xsl:when test="(./@who='#AS') and (./@xml:id) and (./@synch)">
                <p><b><xsl:text>Anna Segre: </xsl:text></b><xsl:text>«</xsl:text><xsl:apply-templates /><xsl:text>»</xsl:text><xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text></p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Gestione degli elementi <anchor/> -->
    <xsl:template match="//tei:anchor">
        <xsl:choose>
            <xsl:when test="starts-with(@synch, '#TI')">
                <xsl:text> </xsl:text><xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> (</xsl:text><xsl:value-of select="@synch"/><xsl:text>) </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Gestione delle porzioni scorrette e delle porzioni non standard -->
    <xsl:template match="tei:choice">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

     <!-- Gestione degli <orig> al di fuori di un <choice> -->
    <xsl:template match="//tei:orig">
        <xsl:choose>
            <xsl:when test="(./parent::tei:choice)">
                <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> **</xsl:text><xsl:apply-templates /><xsl:text>** </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//tei:corr">
        <xsl:text> (corr: </xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
	</xsl:template>

    <xsl:template match="//tei:reg">
        <xsl:text> (reg: </xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
	</xsl:template>

    <!-- Gestione delle parole enfatizzate -->
    <xsl:template match="//tei:emph">
        <xsl:text> </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text>
	</xsl:template>

    <!-- Gestione delle pause -->
    <xsl:template match="tei:pause">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione degli shift -->
    <xsl:template match="tei:shift">        
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione degli incident -->
    <xsl:template match="tei:incident">
        <xsl:choose>
            <xsl:when test="(./ancestor::tei:u) or (.[@start])"> <!-- Ogni <incident> figlio di <u> viene sostiuito da uno spazio vuoto -->
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>*</xsl:text><xsl:apply-templates/><xsl:text>*</xsl:text><xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text> <!-- Gli <incident> esterni agli elementi <u> vengono lasciati perché non intralciano la lettura del discorso -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

     <!-- Gestione degli vocal -->
    <xsl:template match="tei:vocal[not(@who)]">
        <xsl:choose>
            <xsl:when test="(.='inspira') or (.='sospira') or (.='schiocco con la bocca') or (.='lieve schiocco con la bocca') or (.='deglutisce') or (.='inspira profondamente') or (.='inspira e sospira') or (.='schiocco con la bocca suoni non lessicali')  or (.='suoni vocalici non lessicali') or (.='suoni non lessicali') or (.='pausa sonora') or (.='si schiarisce la voce')">    
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="./preceding-sibling::tei:u">
                    <xsl:text> *</xsl:text><xsl:apply-templates/><xsl:text>* </xsl:text><xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
                </xsl:if>
                <xsl:if test="./ancestor::tei:u">
                    <xsl:text> *</xsl:text><xsl:apply-templates/><xsl:text>* </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:vocal[@who]"> <!-- Gli elementi vocalici in mezzo alle varie utterances, dotati dell'attributo @who, vengono posti tra virgolette -->
        <xsl:choose>
            <xsl:when test="(.[@who='#LS']) and (.!='sospira')">
                <xsl:text> *Liliana Segre: </xsl:text><xsl:apply-templates /><xsl:text>* </xsl:text>
            </xsl:when>
            <xsl:when test="(.[@who='#AS']) and (.!='sospira')">
                <xsl:text> *Anna Segre: </xsl:text><xsl:apply-templates /><xsl:text>* </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Gestione delle porzioni di testo ripetute e quindi eliminate -->
    <xsl:template match="tei:del">
        <xsl:choose>
            <xsl:when test="(./preceding-sibling::tei:anchor) and (./following-sibling::tei:anchor[1]/@n mod 2 = 0)"> <!-- In questo modo vengono lasciate nel testo solamente le porzioni di testo eliminate - perché ripetute o troncate - che si trovano tra due elementi <anchor/>, così da far vedere quali parole si sono sovrapposte -->
                <xsl:text>/</xsl:text><xsl:apply-templates /><xsl:text>/</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Gestione delle lacune -->
    <xsl:template match="//tei:gap" >
        <xsl:text> *lacuna* </xsl:text>
    </xsl:template>

    <!-- Gestione delle porzioni di testo di difficile comprensione -->
    <xsl:template match="//tei:unclear">
        <xsl:text> ~</xsl:text><xsl:apply-templates /><xsl:text>~ </xsl:text>
    </xsl:template>

    <!-- Gestione dei <persName> -->
    <xsl:template match="//tei:persName">
        <xsl:text> </xsl:text><xsl:value-of select="." /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <placeName> -->
    <xsl:template match="//tei:placeName">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione degli <rs> -->
    <xsl:template match="//tei:rs">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <quote> -->
    <xsl:template match="//tei:quote">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <said> -->
    <xsl:template match="//tei:said">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <foreign> -->
    <xsl:template match="//tei:foreign">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <distinct> -->
    <xsl:template match="//tei:distinct">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <distinct> -->
    <xsl:template match="//tei:soCalled">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <orgName> -->
    <xsl:template match="//tei:orgName">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <measure> -->
    <xsl:template match="//tei:measure">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <measure> -->
    <xsl:template match="//tei:num">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <date> -->
    <xsl:template match="//tei:date">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <title> -->
    <xsl:template match="//tei:title">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <writing> -->
    <xsl:template match="//tei:writing">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

    <!-- Gestione dei <term> -->
    <xsl:template match="//tei:term">
        <xsl:text> </xsl:text><xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>

</xsl:stylesheet>