<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:include href="template.xsl"/>
	
	<xsl:template match="Display[@name='useredit']">
	</xsl:template>

	<xsl:template match="Display[@name='peopleedit']">
	</xsl:template>
	
	<xsl:template match="Display[@name='threadedit']">
	</xsl:template>
			
	<xsl:template match="Display[@name='messageedit']">
	</xsl:template>

	<xsl:template match="Display[@name='folderedit']">
		<xsl:variable name="folder" select="@id"/>
		<xsl:for-each select="descendant::Folder[@id=$folder]">
			<h1>Administration for the <xsl:value-of select="@name"/> folder</h1>
			<table>
				<tr>
					<form action="xdf.php" method="post">
						<input type="hidden" name="command1" value="update"/>
						<input type="hidden" name="class1" value="folder"/>
						<input type="hidden" name="id1">
							<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
						</input>
						<td>Name:</td>
						<td>
							<input type="text" name="name1">
								<xsl:attribute name="value"><xsl:value-of select="@name"/></xsl:attribute>
							</input>
						</td>
						<td><input type="submit" value="Update"/></td>
						<input type="hidden" name="command2" value="view"/>
						<input type="hidden" name="class2" value="board"/>
						<input type="hidden" name="name2" value="folderlist"/>
						<input type="hidden" name="command3" value="view"/>
						<input type="hidden" name="class3" value="folder"/>
						<input type="hidden" name="id3">
							<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
						</input>
						<input type="hidden" name="depth3" value="1"/>
						<input type="hidden" name="name3" value="threadlist"/>
						<input type="hidden" name="folder">
							<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
						</input>
					</form>
				</tr>
				<tr>
					<form action="xdf.php" method="post">
						<input type="hidden" name="command1" value="delete"/>
						<input type="hidden" name="class1" value="folder"/>
						<input type="hidden" name="id1">
							<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
						</input>

						<td>Delete this folder:</td>
						<td colspan="2"><input type="submit" value="Delete"/></td>

						<input type="hidden" name="command2" value="view"/>
						<input type="hidden" name="class2" value="board"/>
						<input type="hidden" name="name2" value="folderlist"/>
						<input type="hidden" name="command3" value="view"/>
						<input type="hidden" name="class3" value="folder"/>
						<input type="hidden" name="id3">
							<xsl:attribute name="value"><xsl:value-of select="../@id"/></xsl:attribute>
						</input>
						<input type="hidden" name="depth3" value="1"/>
						<input type="hidden" name="name3" value="threadlist"/>
						<input type="hidden" name="folder">
							<xsl:attribute name="value"><xsl:value-of select="../@id"/></xsl:attribute>
						</input>
					</form>
				</tr>
				<tr>
					<td colspan="3"><hr/></td>
				</tr>
				<tr>
					<form action="xdf.php" method="post">
						<input type="hidden" name="command1" value="add"/>
						<input type="hidden" name="class1" value="folder"/>
						<input type="hidden" name="parent1">
							<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
						</input>

						<td>Create a new subfolder:</td>
						<td><input type="text" name="name1" value=""/></td>
						<td><input type="submit" value="Create"/></td>

						<input type="hidden" name="command2" value="view"/>
						<input type="hidden" name="class2" value="board"/>
						<input type="hidden" name="name2" value="folderlist"/>
						<input type="hidden" name="command3" value="view"/>
						<input type="hidden" name="class3" value="folder"/>
						<input type="hidden" name="id3">
							<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
						</input>
						<input type="hidden" name="depth3" value="1"/>
						<input type="hidden" name="name3" value="threadlist"/>
						<input type="hidden" name="folder">
							<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
						</input>
					</form>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
			
</xsl:stylesheet>
