<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  exclude-result-prefixes="#all">

    <xsl:template match="/">
        <accessibility>
            <xsl:apply-templates/>
        </accessibility>    
    </xsl:template>

    <xsl:template match="svrl:failed-assert[@role='info'] | svrl:successful-report[@role='info']" priority="1">
        <info><xsl:apply-templates/></info>
    </xsl:template>

    <xsl:template match="svrl:failed-assert[@role='warn'] | svrl:successful-report[@role='warn']" priority="1">
        <warn><xsl:apply-templates/></warn>
    </xsl:template>

    <xsl:template match="svrl:failed-assert | svrl:successful-report">
        <error><xsl:apply-templates/></error>
    </xsl:template>

    <xsl:template match="*"><xsl:apply-templates/></xsl:template>

    <xsl:template match="@*|node()|comment()|processing-instruction()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()|processing-instruction()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>