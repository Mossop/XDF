<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="folder"/>

	<xsl:include href="template.xsl"/>
	
	<xsl:template match="Date">
		<xsl:value-of select="@hour"/>:<xsl:value-of select="@minute"/>, <xsl:value-of select="@day"/>/<xsl:value-of select="@month"/>/<xsl:value-of select="@year"/>
	</xsl:template>
	
	<xsl:template match="Display[@name='userlist']">
		<td width="578" valign="top">
			<table>
				<tr>
					<td valign="top" colspan="5" width="578">
						<h1>WSWYM Bulletin Board users</h1>
					</td>
				</tr>
				<tr>
					<td><b>Username</b></td>
					<td><b>Last on</b></td>
					<td><b>Full Name</b></td>
					<td></td>
					<td></td>
				</tr>
				<xsl:apply-templates mode="userlist"/>
			</table>
		</td>
	</xsl:template>

	<xsl:template match="LoginInfo" mode="userlist">
		<xsl:for-each select="Login">
			<xsl:sort select="@id"/>
			<tr>
				<td><xsl:value-of select="@id"/></td>
				<td><xsl:apply-templates select="Date"/></td>
				<xsl:for-each select="Person">
					<td><xsl:value-of select="@fullname"/></td>
				</xsl:for-each>
				<td></td>
				<td></td>
			</tr>
		</xsl:for-each>
	</xsl:template>
		
	<xsl:template match="Display[@name='peoplelist']">
		<td width="578" valign="top">
			<table border="0">
				<tr>
					<td valign="top" colspan="6" width="578">
						<h1>WSWYM Bulletin Board Contacts</h1>
					</td>
				</tr>
				<tr>
					<td><b>Name</b></td>
					<td><b>Email</b></td>
					<td><b>Phone</b></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<xsl:apply-templates mode="peoplelist"/>
			</table>
		</td>
	</xsl:template>
	
	<xsl:template match="People" mode="peoplelist">
		<xsl:for-each select="Person">
			<tr>
				<td><xsl:value-of select="@fullname"/></td>
				<td>
					<a>
						<xsl:attribute name="email">mailto:<xsl:value-of select="@email"/></xsl:attribute>
						<xsl:value-of select="@email"/>
					</a>
				</td>
				<td><xsl:value-of select="@phone"/></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="Display[@name='threadlist']">
		<td width="578" valign="top">
		</td>
	</xsl:template>
	
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
			<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=folder&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=1&amp;name2=threadlist&amp;folder=<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:value-of select="@name"/>
		</a>
	</xsl:template>
	
</xsl:stylesheet>
