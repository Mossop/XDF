<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:template name="window">
		<xsl:param name="border">2</xsl:param>
		<xsl:param name="header"/>
		<xsl:param name="body"/>
		<table width="578" border="0" cellspacing="0" cellpadding="0">
		  <tbody>
		    <tr>
		      <td rowspan="8" class="shadelight">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
		      </td>
		      <td colspan="5" class="shadelight">
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
		      </td>
		      <td class="lightdark">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
		      </td>
		    </tr>
		    <tr>
		      <td rowspan="7" class="shadenormal">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		      <td colspan="3" class="shadenormal">
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		      <td rowspan="7" class="shadenormal">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		      <td rowspan="8" class="shadedark">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		    </tr>
		    <tr>
		      <td rowspan="2" class="shadenormal">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		      <td class="windowheader">
		      	<xsl:copy-of select="$header"/>
		      </td>
		      <td class="shadenormal" rowspan="2">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		    </tr>
		    <tr>
		      <td class="shadenormal">
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		    </tr>
		    <tr>
		      <td rowspan="2" class="shadedark">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
		      </td>
		      <td class="shadedark">
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		      <td class="darklight">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		    </tr>
 		   	<tr>
 		     	<td class="windowbody">
 		     		<xsl:copy-of select="$body"/>
 		     	</td>
		      <td rowspan="2" class="shadelight"/>
		    </tr>
		    <tr>
		      <td class="darklight">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		      <td class="shadelight">
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
		      </td>
		    </tr>
		    <tr>
		      <td colspan="3" class="shadenormal">
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
		      </td>
		    </tr>
		    <tr>
		      <td class="lightdark">
		      	<xsl:attribute name="width"><xsl:value-of select="$border"/></xsl:attribute>
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		      <td colspan="5" class="shadedark">
		      	<xsl:attribute name="height"><xsl:value-of select="$border"/></xsl:attribute>
					</td>
		    </tr>
		  </tbody>
		</table>
	</xsl:template>
	
	<xsl:template name="nl2br">
    <xsl:param name="contents" select="."/>
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

	<xsl:template match="Date">
		<xsl:value-of select="format-number(@hour,'0')"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="format-number(@minute,'0')"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="@day"/><xsl:value-of select="@suffix"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@longmonth"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@year"/>
	</xsl:template>
	
</xsl:stylesheet>
