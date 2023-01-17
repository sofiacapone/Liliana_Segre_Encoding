<?xml version="1.0" encoding="utf-8"?> <!-- Prologo che definisce la versione XML e la codifica dei caratteri -->

    <xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xipr="http://dret.net/projects/xipr/"> <!-- Elemento radice che dichiara che il documento è un foglio di stile XSL con versione 2. Inoltre, sono stati dichiarati i vari namespace che permettono di accedere agli elementi, agli attributi e alle funzionalità di XSL, etc -->

    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/> <!-- Istruzioni di elaborazione e definizione del formato del documento di output -->
    
    <!-- GESTIONE DELLE PORZIONI DI CODICE PRECEDENTI A <text> -->
    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:standOff"/>  <!-- Lo <standOff> viene omesso semplicemente dichiarando una regola di template vuota -->

    <!-- GESTIONE DI <text> e dei suoi elementi -->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>
    
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

    
    <xsl:template match="xi:include"><!-- PRIMA MODIFICA: ho sostituito '/*' con 'xi:include' come valore di match. In questo modo la regola di template viene applicata solo al contenuto di <xi:include>, ossia al testo del file Segre_Codifica_2007 -->
		<xsl:apply-templates select="." mode="xipr"/>
	</xsl:template>
	<xsl:template match="@* | node()" mode="xipr">
		<xsl:apply-templates select="." mode="xipr-internal">
			<!-- Le sequenze dei valori URI/XPointer devono essere inizializzate assieme al documento (sono necessarie per rintracciare gli inclusion loops). -->
			<xsl:with-param name="uri-history" select="document-uri(/)" tunnel="yes"/>
			<xsl:with-param name="xpointer-history" select="''" tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
    <xsl:template match="xi:include" mode="xipr">
		<!-- I due parametri sono necessari per rintracciare gli inclusion loops. Essi contengono infatti la storia completa degli attributi @href e degli eventuali attributi @xpointer -->
		<xsl:param name="uri-history" tunnel="yes"/>
		<xsl:param name="xpointer-history" tunnel="yes"/>
		<!-- La presenza di più di un elemento <xi:fallback>, di un elemento <xi:include> o di qualsiasi altro elemento appartenente all'XInclude namespace all'interno dell'elemento <xi:include> è un errore e restituisce il seguente messaggio -->
		<xsl:if test="count(xi:fallback) &gt; 1 or exists(xi:include) or exists(xi:*[local-name() ne 'fallback'])">
			<xsl:sequence select="xipr:message('xi:include elements may only have no or one single xi:fallback element as their only xi:* child', 'fatal')"/>
		</xsl:if>
		<xsl:if test="not(matches(@accept, '^[ -~]*$'))">
			<!-- Se un valore contiene caratteri non standard, viene restituito un messaggio di errore -->
			<xsl:sequence select="xipr:message('accept contains illegal character(s)', 'fatal')"/>
		</xsl:if>
		<xsl:if test="not(matches(@accept-language, '^[ -~]*$'))">
			<!-- Se un valore contiene caratteri non standard e non accettati negli headers HTTP, viene restituito un messaggio di errore -->
			<xsl:sequence select="xipr:message('accept-language contains illegal character(s)', 'fatal')"/>
		</xsl:if>
		<xsl:if test="exists(@accept)">
			<!-- L'attributo @accept non è supportato, per questo se dovesse essere rintracciato verrebbe restituito un messaggio di errore -->
			<xsl:sequence select="xipr:message('XIPr does not support the accept attribute', 'info')"/>
		</xsl:if>
		<xsl:if test="exists(@accept-language)">
			<!-- L'attributo @accept-language non è supportato, per questo se dovesse essere rintracciato verrebbe restituito un messaggio di errore -->
			<xsl:sequence select="xipr:message('XIPr does not support the accept-language attribute', 'info')"/>
		</xsl:if>
		<xsl:variable name="include-uri" select="resolve-uri(@href, document-uri(/))"/> <!-- Viene creata la variabile $include-uri il cui valore è un URI. In particolare, attraverso la funzione resolve-uri(), l'URI relativo specificato dall'attributo @href viene risolto rispetto all'URI assoluto restituito dalla funzione document-uri(/) -->
		<xsl:choose>
			<xsl:when test="@parse eq 'xml' or empty(@parse)"><!-- Se l'attributo @parse non è stato inserito o se ha valore uguale a 'xml', viene eseguito il seguente codice -->
				<xsl:if test="empty(@href | @xpointer)">
					<!-- Se l'attributo @href non è presente quando l'attributo @parse ha valore uguale a "xml" e se non è presente nemmeno l'attributo @xpointer, viene restiuito un messaggio di errore -->
					<xsl:sequence select="xipr:message('For parse=&quot;xml&quot;, at least one the href or xpointer attributes must be present', 'fatal')"/>
				</xsl:if>
				<xsl:if test="( index-of($uri-history, $include-uri ) = index-of($xpointer-history, string(@xpointer)) )">
					<!-- Quando un elemento <xi:include> viene processato ricorsivamente, processare un altro elemento <xi:include> con un attributo @href e/o @xpointer avente un valore già processato è un errore -->
					<xsl:sequence select="xipr:message(concat('Recursive inclusion (same href/xpointer) of ', @href), 'fatal')"/>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="doc-available($include-uri)"><!-- Se nel documento è presente l'URI specificato dalla variabile $include-uri e se, dunque, la funzione doc-available() restituisce true viene seguito il seguente codice -->
						<xsl:variable name="include-doc" select="doc($include-uri)"/><!-- Viene creata una variabile $include-doc per accedere all'URI della variabile $include-uri -->
						<xsl:choose>
							<xsl:when test="empty(@xpointer)"><!-- Se non c'è un attributo @xpointer viene eseguito il seguente codice -->
								<xsl:for-each select="$include-doc/node()"><!-- Per ciascun nodo del documento rappresentato dalla variabile $include-doc viene eseguito il seguente codice -->
									<xsl:choose>
										<xsl:when test="self::*">
                                            <xsl:apply-templates select="."/> <!-- SECONDA MODIFICA: a tutti gli elementi, attraverso apply-templates, vengono applicate le modifiche specificate all'interno di questo stesso documento XSL, e non vengono dunque semplicemente copiati, come accadeva prima attraverso l'istruzione copy-of -->
										</xsl:when>
										<xsl:otherwise>
                                            <xsl:apply-templates select="."/> <!-- TERZA MODIFICA: anche a tutti gli altri nodi, attraverso apply-templates, vengono applicate le modifiche specificate all'interno di questo stesso documento, e non vengono semplicemente copiati, come accadeva prima attraverso l'istruzione copy -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise><!-- Se c'è un attributo @xpointer viene eseguito il seguente codice -->
								<xsl:variable name="xpointer-node"><!-- Viene creata una variabile xpointer-node -->
									<xsl:choose>
										<xsl:when test="matches(@xpointer, '^[\i-[:]][\c-[:]]*$')"> <!-- Se l'attributo @xpointer utilizza un pointer abbreviato (anche noto come barename) viene eseguito il seguente codice-->
											<xsl:copy-of select="xipr:include(id(@xpointer, $include-doc), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
										</xsl:when>
										<xsl:when test="matches(@xpointer, '^element\([\i-[:]][\c-[:]]*((/[1-9][0-9]*)+)?|(/[1-9][0-9]*)+\)$')"> <!-- Se l'attributo @xpointer utilizza lo schema element() viene eseguito il seguente codice (Le regex sono state ricavate dall'XPointer element() scheme spec: http://www.w3.org/TR/xptr-element/#NT-ElementSchemeData -->
											<xsl:variable name="element-pointer" select="replace(@xpointer, 'element\((.*)\)', '$1')"/> <!-- Viene creata la variabile $element-pointer -->
											<xsl:choose>
												<xsl:when test="not(contains($element-pointer, '/'))"><!-- Se il pointer è un semplice id, che può essere localizzato attraverso la funzione id() viene seguito il seguente codice-->
													<xsl:copy-of select="xipr:include(id($element-pointer, $include-doc), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:copy-of select="xipr:include(xipr:child-sequence( if ( starts-with($element-pointer, '/') ) then $include-doc else id(substring-before($element-pointer, '/'), $include-doc), substring-after($element-pointer, '/')), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise> <!-- Se @xpointer non usa alcuno schema specificato nelle righe di codice precedente, viene eseguito il seguente codice -->
											<xsl:sequence select="xipr:message('XIPr only supports the XPointer element() scheme (skipping...)', 'warning')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="exists($xpointer-node/node())"> <!-- Se la valutazione dell'@xpointer restituisce un nodo, questo viene copiato -->
										<xsl:copy-of select="$xpointer-node/node()"/>
									</xsl:when>
									<xsl:otherwise> <!-- Se l'@xpointer non restituisce alcun risultato, viene prodotto un messaggio e viene avviato il fallback processing -->
										<xsl:sequence select="xipr:message(concat('Evaluation of xpointer ', @xpointer, ' returned nothing'), 'resource')"/>
										<xsl:call-template name="fallback"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise> <!-- Se la funzione doc-available() restituisce false, viene prodotto un messaggio e viene avviato il fallback processing -->
						<xsl:sequence select="xipr:message(concat('Could not read document ', $include-uri), 'resource')"/>
						<xsl:call-template name="fallback"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@parse eq 'text'"> <!-- Se l'attributo @parse è di valore uguale a 'text'-->
				<xsl:if test="exists(@xpointer)"> <!-- Se è presente un attributo @xpointer viene restituito un messaggio di errore -->
					<xsl:sequence select="xipr:message('The xpointer attribute is not allowed for parse=&quot;text&quot;', 'warning')"/>			
				</xsl:if>
				<xsl:choose>
					<xsl:when test="unparsed-text-available($include-uri)"><!-- Dato un URI, la funzione unparsed-text-available restituisce true se quel documento è disponibile, false altrimenti. Se il documento è disponibile, viene successivamente aperto attraverso la funzione unparsed-text() -->
						<xsl:value-of select="if ( empty(@encoding) ) then unparsed-text($include-uri) else unparsed-text($include-uri, string(@encoding))"/>
					</xsl:when>
					<xsl:otherwise><!-- Se il risultato della funzione unparsed-text-available() è false, viene prodotto un messaggio e viene avviato il fallback processing -->
						<xsl:sequence select="xipr:message(concat('Could not read document ', $include-uri), 'resource')"/>
						<xsl:call-template name="fallback"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise> <!-- Se l'attributo @parse ha un valore diverso da 'text' o 'xml' viene resituito un messaggio di errore -->
				<xsl:sequence select="xipr:message(concat('Unknown xi:include attribute value parse=&quot;', @parse ,'&quot;'), 'fatal')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- La funzione xipr:include -->
	<xsl:function name="xipr:include">
		<xsl:param name="context"/>
		<xsl:param name="include-uri"/>
		<xsl:param name="xpointer"/>
		<xsl:param name="uri-history"/>
		<xsl:param name="xpointer-history"/>
		<xsl:for-each select="$context">
			<xsl:copy>
				<xsl:attribute name="xml:base" select="$include-uri"/>
				<!-- Se un attributo xml:base è già presente, viene sostituito dal nuovo attributo -->
				<xsl:apply-templates select="@*[name() ne 'xml:base'] | node()" mode="xipr-internal">
					<xsl:with-param name="uri-history" select="($uri-history, $include-uri)" tunnel="yes"/>
					<xsl:with-param name="xpointer-history" select="($xpointer-history, string($xpointer))" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:for-each>
	</xsl:function>

	<!-- La funzione xipr:child-sequence -->
	<xsl:function name="xipr:child-sequence">
		<xsl:param name="context"/>
		<xsl:param name="path"/>
		<xsl:choose>
			<xsl:when test="not(contains($path, '/'))"> <!-- Se questo è l'ultimo segmento, restituisce il nodo -->
				<xsl:sequence select="$context/*[number($path)]"/>
			</xsl:when>
			<xsl:otherwise> <!-- In alternativa, viene selezionato il nodo successivo -->
				<xsl:sequence select="xipr:child-sequence($context/*[number(substring-before($path, '/'))], substring-after($path, '/'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- Gestione del <fallback> -->
    <xsl:template name="fallback">
		<xsl:if test="exists(xi:fallback[empty(parent::xi:include)])"> <!-- Se un elemento <xi:fallback> appare in qualsiasi altro punto del documento che non sia all'interno di un elemento <xi:include>, viene restituito un messaggio di errore -->
			<xsl:sequence select="xipr:message('xi:fallback is only allowed as the direct child of xi:include', 'fatal')"/>
		</xsl:if>
		<xsl:if test="exists(xi:fallback[count(xi:include) ne count(xi:*)])"> <!-- Se un elemento <xi:fallback> contiene qualunque altro elemento che non sia un <xi:include> viene restituito un messaggio di errore -->
			<xsl:sequence select="xipr:message('xi:fallback may not contain other xi:* elements than xi:include', 'fatal')"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="count(xi:fallback) = 1"> <!-- Se è presente un solo elemento <xi:fallback> vengono applicate le regole di template specificate -->
				<xsl:apply-templates select="xi:fallback/*" mode="xipr-internal"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Se non ci fosse alcun elemento <xi:fallback> o se ce ne fosse più di uno verrebbe restituito un messaggio di errore -->
				<xsl:sequence select="xipr:message('No xi:fallback for resource error', 'fatal')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
	<!-- funzione xipr:message --> 
	<xsl:function name="xipr:message">
		<xsl:param name="message"/>
		<xsl:param name="level"/>
		<xsl:choose>
			<xsl:when test="$level eq 'info'"> <!-- Se il valore della variabile $level è uguale a 'info' viene restituito il messaggio preceduto da INFO: -->
				<xsl:message terminate="no">
					<xsl:value-of select="concat('INFO: ', $message)"/>
				</xsl:message>
			</xsl:when>
			<xsl:when test="$level eq 'warning'"> <!-- Se il valore della variabile $level è uguale a 'warning' viene restituito il messaggio preceduto da WARNING: -->
				<xsl:message terminate="no">
					<xsl:value-of select="concat('WARNING: ', $message)"/>
				</xsl:message>
			</xsl:when>
			<xsl:when test="$level eq 'resource'"> <!-- Se il valore della variabile $level è uguale a 'resource' viene restituito il messaggio preceduto da RESOURCE ERROR: -->
				<xsl:message terminate="no">
					<xsl:value-of select="concat('RESOURCE ERROR: ', $message)"/>
				</xsl:message>
			</xsl:when>
			<xsl:otherwise> <!-- In alternativa, viene restituito il messaggio preceduto da FATAL ERROR: -->
				<xsl:message terminate="yes">
					<xsl:value-of select="concat('FATAL ERROR: ', $message)"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>