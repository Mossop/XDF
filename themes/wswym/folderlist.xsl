<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:output method="html" omit-xml-declaration="yes" encoding="iso-8859-1" indent="yes"/>

  <xsl:template name="maxdepth">
    <xsl:for-each select="//Folder">
      <xsl:sort select="count(ancestor::Folder)" order="descending"/>
      <xsl:if test="position()=1">
        <xsl:value-of select="count(ancestor::Folder)"/>
      </xsl:if>
	  </xsl:for-each>
	</xsl:template>

	<xsl:template name="folderlist">
		<xsl:param name="ignore">-1</xsl:param>

		<xsl:variable name="maxdepth">
			<xsl:call-template name="maxdepth"/>
		</xsl:variable>
		<table border="0" cellspacing="3" cellpadding="0">
			<xsl:apply-templates select="Folder" mode="folderlist">
				<xsl:sort select="@name"/>
				<xsl:with-param name="span" select="$maxdepth + 1"/>
				<xsl:with-param name="ignore" select="$ignore"/>
			</xsl:apply-templates>
		</table>
	</xsl:template>

	<xsl:template match="Folder" mode="folderlist">
		<xsl:param name="indent">0</xsl:param>
		<xsl:param name="span"/>
		<xsl:param name="ignore">-1</xsl:param>

		<xsl:if test="@id != $ignore">

			<xsl:variable name="status"><xsl:call-template name="getstatus"/></xsl:variable>
		
			<tr>
				<xsl:if test="$indent > 0">
					<td>
						<xsl:attribute name="colspan"><xsl:value-of select="$indent"/></xsl:attribute>
					</td>
				</xsl:if>
				<td colspan="1">
					<a>
						<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=folder&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=1&amp;name2=threadlist&amp;folder=<xsl:value-of select="@id"/></xsl:attribute>
						<img align="top">
							<xsl:attribute name="src">images/<xsl:value-of select="$status"/>folder.gif</xsl:attribute>
						</img>
					</a>
				</td>
				<td>
					<xsl:attribute name="colspan"><xsl:value-of select="$span"/></xsl:attribute>
					<a>
						<xsl:attribute name="class"><xsl:value-of select="$status"/>folder</xsl:attribute>
						<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=folder&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=1&amp;name2=threadlist&amp;folder=<xsl:value-of select="@id"/></xsl:attribute>
						<xsl:choose>
							<xsl:when test="@unread &gt; 0">
								<em><xsl:value-of select="@name"/></em> (<xsl:value-of select="@unread"/>)
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@name"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</td>
			</tr>
	
			<xsl:apply-templates select="Folder" mode="folderlist">
				<xsl:sort select="@name"/>
				<xsl:with-param name="indent" select="$indent + 1"/>
				<xsl:with-param name="span" select="$span - 1"/>
				<xsl:with-param name="ignore" select="$ignore"/>
			</xsl:apply-templates>
		
		</xsl:if>
	
	</xsl:template>
		
	<xsl:template name="getstatus">
		<xsl:choose>
			<xsl:when test="/DisplaySet/@folder=@id">open</xsl:when>
			<xsl:otherwise>closed</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
