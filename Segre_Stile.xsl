<?xml version="1.0" encoding="utf-8"?> <!-- Prologo che definisce la versione XML e la codifica dei caratteri -->

    <xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xipr="http://dret.net/projects/xipr/"> <!-- Elemento radice che dichiara che il documento è un foglio di stile XSL con versione 3. Inoltre, sono stati dichiarati i vari namespace che permettono di accedere agli elementi, agli attributi e alle funzionalità sia di XSL, che di SaxonJS, etc -->

    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/> <!-- Definizione del formato del documento di output -->
    
    
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

    
    <xsl:template match="xi:include">
		<!-- if there is no other template handling the document element, this template initiates XInclude processing at the document element of the input document. -->
		<xsl:apply-templates select="." mode="xipr"/>
	</xsl:template>
	<xsl:template match="@* | node()" mode="xipr">
		<xsl:apply-templates select="." mode="xipr-internal">
			<!-- the sequences of included URI/XPointer values need to be initialized with the starting document of the XInclude processing (required for detecting inclusion loops). -->
			<xsl:with-param name="uri-history" select="document-uri(/)" tunnel="yes"/>
			<xsl:with-param name="xpointer-history" select="''" tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
    <xsl:template match="xi:include" mode="xipr">
		<!-- the two parameters are required for detecting inclusion loops, they contain the complete history of href and xpointer attributes as sequences. -->
		<xsl:param name="uri-history" tunnel="yes"/>
		<xsl:param name="xpointer-history" tunnel="yes"/>
		<!-- REC: The children property of the xi:include element may include a single xi:fallback element; the appearance of more than one xi:fallback element, an xi:include element, or any other element from the XInclude namespace is a fatal error. -->
		<xsl:if test="count(xi:fallback) &gt; 1 or exists(xi:include) or exists(xi:*[local-name() ne 'fallback'])">
			<xsl:sequence select="xipr:message('xi:include elements may only have no or one single xi:fallback element as their only xi:* child', 'fatal')"/>
		</xsl:if>
		<xsl:if test="not(matches(@accept, '^[ -~]*$'))">
			<!-- SPEC: Values containing characters outside the range #x20 through #x7E must be flagged as fatal errors. -->
			<xsl:sequence select="xipr:message('accept contains illegal character(s)', 'fatal')"/>
		</xsl:if>
		<xsl:if test="not(matches(@accept-language, '^[ -~]*$'))">
			<!-- SPEC: Values containing characters outside the range #x20 through #x7E are disallowed in HTTP headers, and must be flagged as fatal errors. -->
			<xsl:sequence select="xipr:message('accept-language contains illegal character(s)', 'fatal')"/>
		</xsl:if>
		<xsl:if test="exists(@accept)">
			<xsl:sequence select="xipr:message('XIPr does not support the accept attribute', 'info')"/>
		</xsl:if>
		<xsl:if test="exists(@accept-language)">
			<xsl:sequence select="xipr:message('XIPr does not support the accept-language attribute', 'info')"/>
		</xsl:if>
		<xsl:variable name="include-uri" select="resolve-uri(@href, document-uri(/))"/>
		<xsl:choose>
			<xsl:when test="@parse eq 'xml' or empty(@parse)">
				<!-- SPEC: This attribute is optional. When omitted, the value of "xml" is implied (even in the absence of a default value declaration). -->
				<xsl:if test="empty(@href | @xpointer)">
					<!-- SPEC: If the href attribute is absent when parse="xml", the xpointer attribute must be present. -->
					<xsl:sequence select="xipr:message('For parse=&quot;xml&quot;, at least one the href or xpointer attributes must be present', 'fatal')"/>
				</xsl:if>
				<xsl:if test="( index-of($uri-history, $include-uri ) = index-of($xpointer-history, string(@xpointer)) )">
					<!-- SPEC: When recursively processing an xi:include element, it is a fatal error to process another xi:include element with an include location and xpointer attribute value that have already been processed in the inclusion chain. -->
					<xsl:sequence select="xipr:message(concat('Recursive inclusion (same href/xpointer) of ', @href), 'fatal')"/>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="doc-available($include-uri)">
						<xsl:variable name="include-doc" select="doc($include-uri)"/>
						<xsl:choose>
							<xsl:when test="empty(@xpointer)">
								<!-- SPEC: The inclusion target might be a document information item (for instance, no specified xpointer attribute, or an XPointer specifically locating the document root.) In this case, the set of top-level included items is the children of the acquired infoset's document information item, except for the document type declaration information item child, if one exists. -->
								<xsl:for-each select="$include-doc/node()">
									<xsl:choose>
										<xsl:when test="self::*">
											<!-- for elements, copy the element and perform base URI fixup. -->
                                            <xsl:apply-templates select="."/>
										</xsl:when>
										<xsl:otherwise>
											<!-- copy everything else (i.e., everything which is not an element). -->
                                            <xsl:apply-templates select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<!-- there is an xpointer attribute... -->
								<xsl:variable name="xpointer-node">
									<xsl:choose>
										<!-- xpointer uses a shorthand pointer (formerly known as barename), NCName regex copied from the schema for schemas. -->
										<xsl:when test="matches(@xpointer, '^[\i-[:]][\c-[:]]*$')">
											<xsl:copy-of select="xipr:include(id(@xpointer, $include-doc), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
										</xsl:when>
										<!-- xpointer uses the element() scheme; regex derived from XPointer element() scheme spec: http://www.w3.org/TR/xptr-element/#NT-ElementSchemeData (NCName regex copied from the schema for schemas). -->
										<xsl:when test="matches(@xpointer, '^element\([\i-[:]][\c-[:]]*((/[1-9][0-9]*)+)?|(/[1-9][0-9]*)+\)$')">
											<xsl:variable name="element-pointer" select="replace(@xpointer, 'element\((.*)\)', '$1')"/>
											<xsl:choose>
												<xsl:when test="not(contains($element-pointer, '/'))">
													<!-- the pointer is a simple id, which can be located using the id() function. -->
													<xsl:copy-of select="xipr:include(id($element-pointer, $include-doc), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
												</xsl:when>
												<xsl:otherwise>
													<!-- child sequence evaluation starts from the root or from an element identified by a NCName. -->
													<xsl:copy-of select="xipr:include(xipr:child-sequence( if ( starts-with($element-pointer, '/') ) then $include-doc else id(substring-before($element-pointer, '/'), $include-doc), substring-after($element-pointer, '/')), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<!-- xpointer uses none of the schemes covered in the preceding branches. -->
											<xsl:sequence select="xipr:message('XIPr only supports the XPointer element() scheme (skipping...)', 'warning')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="exists($xpointer-node/node())">
										<!-- xpointer evaluation returned a node. -->
										<xsl:copy-of select="$xpointer-node/node()"/>
									</xsl:when>
									<xsl:otherwise>
										<!-- the xpointer did not return a result, a message is produced and fallback processing is initiated. -->
										<xsl:sequence select="xipr:message(concat('Evaluation of xpointer ', @xpointer, ' returned nothing'), 'resource')"/>
										<xsl:call-template name="fallback"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- this branch is executed when the doc-available() function returned false(), a message is produced and fallback processing is initiated. -->
						<xsl:sequence select="xipr:message(concat('Could not read document ', $include-uri), 'resource')"/>
						<xsl:call-template name="fallback"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@parse eq 'text'">
				<xsl:if test="exists(@xpointer)">
					<!-- SPEC: The xpointer attribute must not be present when parse="text". -->
					<xsl:sequence select="xipr:message('The xpointer attribute is not allowed for parse=&quot;text&quot;', 'warning')"/>			
				</xsl:if>
				<xsl:choose>
					<xsl:when test="unparsed-text-available($include-uri)">
						<xsl:value-of select="if ( empty(@encoding) ) then unparsed-text($include-uri) else unparsed-text($include-uri, string(@encoding))"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- this branch is executed when the unparsed-text-available() function returned false(), a message is produced and fallback processing is initiated. -->
						<xsl:sequence select="xipr:message(concat('Could not read document ', $include-uri), 'resource')"/>
						<xsl:call-template name="fallback"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- SPEC: Values other than "xml" and "text" are a fatal error. -->
				<xsl:sequence select="xipr:message(concat('Unknown xi:include attribute value parse=&quot;', @parse ,'&quot;'), 'fatal')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="xipr:include">
		<xsl:param name="context"/>
		<xsl:param name="include-uri"/>
		<xsl:param name="xpointer"/>
		<xsl:param name="uri-history"/>
		<xsl:param name="xpointer-history"/>
		<xsl:for-each select="$context">
			<xsl:copy>
				<xsl:attribute name="xml:base" select="$include-uri"/>
				<!-- SPEC: If an xml:base attribute information item is already present, it is replaced by the new attribute. -->
				<xsl:apply-templates select="@*[name() ne 'xml:base'] | node()" mode="xipr-internal">
					<xsl:with-param name="uri-history" select="($uri-history, $include-uri)" tunnel="yes"/>
					<xsl:with-param name="xpointer-history" select="($xpointer-history, string($xpointer))" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:for-each>
	</xsl:function>

	<xsl:function name="xipr:child-sequence">
		<xsl:param name="context"/>
		<xsl:param name="path"/>
		<xsl:choose>
			<!-- if this is the last path segment, return the node. -->
			<xsl:when test="not(contains($path, '/'))">
				<xsl:sequence select="$context/*[number($path)]"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- go one step along the child sequence by selecting the next node and trimming the path. -->
				<xsl:sequence select="xipr:child-sequence($context/*[number(substring-before($path, '/'))], substring-after($path, '/'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

    <xsl:template name="fallback">
		<xsl:if test="exists(xi:fallback[empty(parent::xi:include)])">
			<!-- SPEC: It is a fatal error for an xi:fallback  element to appear in a document anywhere other than as the direct child of the xi:include (before inclusion processing on the contents of the element). -->
			<xsl:sequence select="xipr:message('xi:fallback is only allowed as the direct child of xi:include', 'fatal')"/>
		</xsl:if>
		<xsl:if test="exists(xi:fallback[count(xi:include) ne count(xi:*)])">
			<!-- SPEC: It is a fatal error  for the xi:fallback element to contain any elements from the XInclude namespace other than xi:include. -->
			<xsl:sequence select="xipr:message('xi:fallback may not contain other xi:* elements than xi:include', 'fatal')"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="count(xi:fallback) = 1">
				<xsl:apply-templates select="xi:fallback/*" mode="xipr-internal"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- SPEC: It is a fatal error if there is zero or more than one xi:fallback element. -->
				<xsl:sequence select="xipr:message('No xi:fallback for resource error', 'fatal')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
	<xsl:function name="xipr:message">
		<xsl:param name="message"/>
		<xsl:param name="level"/>
		<xsl:choose>
			<xsl:when test="$level eq 'info'">
				<xsl:message terminate="no">
					<xsl:value-of select="concat('INFO: ', $message)"/>
				</xsl:message>
			</xsl:when>
			<xsl:when test="$level eq 'warning'">
				<xsl:message terminate="no">
					<xsl:value-of select="concat('WARNING: ', $message)"/>
				</xsl:message>
			</xsl:when>
			<xsl:when test="$level eq 'resource'">
				<xsl:message terminate="no">
					<xsl:value-of select="concat('RESOURCE ERROR: ', $message)"/>
				</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:value-of select="concat('FATAL ERROR: ', $message)"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>