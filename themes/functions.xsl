<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

  <xsl:template name="maxdepth">
    <xsl:for-each select="//Folder"> <!-- sorry everyone! -->
      <xsl:sort select="count(ancestor::Folder)" order="descending"/>
      <xsl:if test="position()=1">
        <xsl:value-of select="count(ancestor::Folder)"/>
      </xsl:if>
	  </xsl:for-each>
	</xsl:template>

	<xsl:template name="nl2br">
    <xsl:param name="contents"/>
    <xsl:choose>
      <xsl:when test="contains($contents, '&#10;')">
        <xsl:value-of select="substring-before($contents, '&#10;')"/>
        <br/>
        <xsl:call-template name="nl2br">
          <xsl:with-param name="contents" select="substring-after($contents, '&#10;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$contents"/>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>

</xsl:stylesheet>
