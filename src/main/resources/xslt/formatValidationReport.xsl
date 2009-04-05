<!--
   Process the output from the W3C HTML validation report.
   
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#all">

    <xsl:template match="/">
        <validity><xsl:apply-templates/></validity>
    </xsl:template>

    <xsl:template match="*[@class='msg_err']">
        <error position="{em[1]}"><xsl:apply-templates/></error>
    </xsl:template>

    <xsl:template match="*[@class='msg_warn']">
        <warn position="{em[1]}"><xsl:apply-templates/></warn>
    </xsl:template>
    
    <xsl:template match="*[@class='msg_info']">
        <info position="{em[1]}"><xsl:apply-templates/></info>
    </xsl:template>

<!--
    <xsl:template match="code[@class='input']">
        <problem><xsl:value-of select="."/></problem>
    </xsl:template>
-->

    <xsl:template match="*[@class='msg']">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="*"><xsl:apply-templates/></xsl:template>

    <xsl:template match="text()"/>

</xsl:stylesheet>