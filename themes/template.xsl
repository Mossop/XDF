<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:output method="html" omit-xml-declaration="yes" encoding="iso-8859-1" indent="yes"/>

	<xsl:param name="loginid"/>
	
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

	<xsl:template match="/DisplaySet">
		<html>
			<head>
		    <title>IEE Wales South West Younger Members Bulletin Board</title>
		    <link rel="stylesheet" href="styles/branches.css" type="text/css"/>
		    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
			</head>

			<body bgcolor="#FFFFFF">
			  <table cellspacing="0" cellPadding="0" border="0" width="778">
			    <tr>
  			    <td width="100" align="center" valign="top" rowspan="2">
  			      <img src="images/logo.gif" alt="IEE Logo"/>
  			    </td>
  			    <td valign="top" align="left" class="fullwidth" colspan="2">
  			      <img src="images/banner.jpg" alt="Communities image"/>
  			    </td>
  			  </tr>
  			  <tr>
						<td>
							<table>
								<tr>
									<td>
										<a>
											<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=folder&amp;id2=<xsl:value-of select="Board/@rootfolder"/>&amp;depth2=1&amp;name2=threadlist&amp;folder=<xsl:value-of select="Board/@rootfolder"/></xsl:attribute>
											Announcements
										</a>
									</td>
									<td>
										<a href="xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=people&amp;name2=peoplelist">
											Contacts
										</a>
									</td>
									<td>
										<a href="xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=users&amp;name2=userlist">
											Users
										</a>
									</td>
								</tr>
							</table>
						</td>
						<td align="right">
							Currently logged in as
							<xsl:value-of select="Login/@id"/>
							(<xsl:value-of select="Login/Person/@fullname"/>)
						</td>
					</tr>
					<tr>
						<td colspan="3" width="778">
							<hr/>
							<table border="0">
								<tr>
								
									<xsl:apply-templates select="Display"/>
									
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
