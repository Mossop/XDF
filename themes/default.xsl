<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="folder"/>

	<xsl:template match="/">
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
									<td>Announcements</td>
									<td>Contacts</td>
									<td>Users</td>
								</tr>
							</table>
						</td>
						<td align="right">
							Currently logged in as Dave (Dave Townsend)
						</td>
					</tr>
					<tr>
						<td colspan="3" width="778">
							<hr/>
							<table border="0">
								<tr>
								
									<xsl:apply-templates/>
									
									<td width="578" rowspan="2" valign="top">
									</td>
								
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:variable name="depth">0</xsl:variable>
	
	<xsl:template match="Display[@name='folderlist']">
		<td width="200" valign="top">
			<table>
				<xsl:apply-templates select="Folder" mode="folderlist">
					<xsl:sort select="@name"/>
					<xsl:with-param name="indent">0</xsl:with-param>
				</xsl:apply-templates>
				<tr><td><hr/></td></tr>
				<tr><td>Change Password</td></tr>
				<tr><td>Logout</td></tr>
			</table>
		</td>
	</xsl:template>

	<xsl:template match="Folder" mode="depthcount">
		<xsl:variable name="depth"><xsl:value-of select="$depth"/></xsl:variable>
		<xsl:apply-templates select="Folder" mode="depthcount"/>
	</xsl:template>
	
	<xsl:template match="Folder" mode="folderlist">
		<xsl:param name="indent"/>
		<xsl:variable name="status"/>

		<tr>
			<td>
				<xsl:attribute name="style">padding-left: <xsl:value-of select="$indent*18"/>px</xsl:attribute>

				<xsl:if test="$folder=@id">
					<xsl:call-template name="folderlist">
						<xsl:with-param name="status">open</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="not($folder=@id)">
					<xsl:call-template name="folderlist">
						<xsl:with-param name="status">closed</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

			</td>
		</tr>

		<xsl:apply-templates select="Folder" mode="folderlist">
			<xsl:sort select="@name"/>
			<xsl:with-param name="indent">
				<xsl:value-of select="$indent+1"/>
			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>
	
	<xsl:template name="folderlist">
		<xsl:param name="status"/>

		<img align="top">
			<xsl:attribute name="src">images/<xsl:value-of select="$status"/>folder.gif</xsl:attribute>
		</img>

		<a>
			<xsl:attribute name="class"><xsl:value-of select="$status"/>folder</xsl:attribute>
			<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=folder&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=1&amp;folder=<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:value-of select="@name"/>
		</a>
	</xsl:template>
	
</xsl:stylesheet>
