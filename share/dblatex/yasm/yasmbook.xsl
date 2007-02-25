<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:template match="book">
  <xsl:value-of select="$latex.book.preamblestart"/>
  <xsl:call-template name="user.params.set"/>

  <!-- Load babel before the style (bug #babel/3875) -->
  <xsl:call-template name="babel.setup"/>
  <xsl:text>\usepackage[hyperlink]{</xsl:text>
  <xsl:value-of select="$latex.style"/>
  <xsl:text>}&#10;</xsl:text>

  <xsl:call-template name="font.setup"/>
  <xsl:call-template name="citation.setup"/>
  <xsl:call-template name="lang.setup"/>
  <xsl:call-template name="biblio.setup"/>
  <xsl:call-template name="annotation.setup"/>
  <xsl:call-template name="user.params.set2"/>
  <xsl:apply-templates select="bookinfo|info" mode="docinfo"/>

  <!-- Override the infos if specified here -->
  <xsl:if test="subtitle">
    <xsl:text>\renewcommand{\DBKsubtitle}{</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="subtitle"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>

  <xsl:text>\title{</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string">
        <xsl:choose>
        <xsl:when test="title">
          <xsl:value-of select="title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="bookinfo/title"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  <xsl:text>}&#10;</xsl:text>

  <!-- Get the Author -->
  <xsl:variable name="author">
    <xsl:choose>
      <xsl:when test="bookinfo/authorgroup/author">
        <xsl:apply-templates select="bookinfo/authorgroup"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="bookinfo/author"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>\author{</xsl:text>
  <xsl:value-of select="$author"/>
  <xsl:text>}&#10;</xsl:text>

<!-- Set the indexation table -->
% ------------------
% Table d'Indexation
% ------------------
\renewcommand{\DBKindexation}{
\begin{DBKindtable}
\DBKinditem{\writtenby}{<xsl:value-of select="$author"/>}
<xsl:apply-templates select=".//othercredit"/>
\end{DBKindtable}
}

  <xsl:value-of select="$latex.book.afterauthor"/>
  <xsl:text>&#10;\setcounter{tocdepth}{</xsl:text>
  <xsl:value-of select="$toc.section.depth"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:text>&#10;\setcounter{secnumdepth}{</xsl:text>
  <xsl:value-of select="$doc.section.depth"/>
  <xsl:text>}&#10;</xsl:text>

  <!-- Apply the revision history here -->
  <xsl:apply-templates select="bookinfo/revhistory"/>

  <!-- Apply the legalnotices here -->
  <xsl:call-template name="print.legalnotice">
    <xsl:with-param name="nodes" select="bookinfo/legalnotice"/>
  </xsl:call-template>

  <xsl:value-of select="$latex.book.begindocument"/>
  <xsl:text>\frontmatter&#10;</xsl:text>
  <xsl:text>\long\def\hyper@section@backref#1#2#3{%&#10;</xsl:text>
  <xsl:text>\typeout{BACK REF #1 / #2 / #3}%&#10;</xsl:text>
  <xsl:text>\hyperlink{#3}{#2}}&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>\maketitle&#10;</xsl:text>

  <!-- Print the TOC/LOTs -->
  <xsl:apply-templates select="." mode="toc_lots"/>
  <xsl:call-template name="label.id"/>

  <xsl:text>\mainmatter&#10;</xsl:text>

  <!-- Apply templates -->
  <xsl:apply-templates/>
  <xsl:if test="*//indexterm|*//keyword">
   <xsl:text>\printindex&#10;</xsl:text>
  </xsl:if>
  <xsl:value-of select="$latex.book.end"/>
</xsl:template>

</xsl:stylesheet>
