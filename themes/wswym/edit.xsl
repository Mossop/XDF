<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:include href="template.xsl"/>
	
	<xsl:template match="Display[@name='useredit']">
	</xsl:template>

	<xsl:template match="Display[@name='peopleedit']">
	</xsl:template>
	
	<xsl:template match="Display[@name='threadedit']//Thread">
		<h1>Administration for the &quot;<xsl:value-of select="@name"/>&quot; thread</h1>
		<table>
			<tr>
				<form action="xdf.php" method="post">
					<input type="hidden" name="command1" value="delete"/>
					<input type="hidden" name="class1" value="thread"/>
					<input type="hidden" name="id1">
						<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
					</input>

					<td>Delete this thread:</td>
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
				<td colspan="3">
					To move this thread, select where you want it to be below:
					<xsl:for-each select="//Display[@name='folderlist']">
						<xsl:call-template name="folderlist"/>
					</xsl:for-each>
				</td>
			</tr>
		</table>
	</xsl:template>
			
	<xsl:template match="Display[@name='fileupload']//Message">
		<h2>Select a file to attach to this message.</h2>
		<form action="xdf.php" method="post" enctype="multipart/form-data">
			<input type="hidden" name="command1" value="add"/>
			<input type="hidden" name="class1" value="file"/>
			<input type="hidden" name="message1">
				<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
			</input>
			<table>
				<tr>
					<td>Description:</td>
					<td><input name="description1" type="text"/></td>
				</tr>
				<tr>
					<td>Send this file:</td>
					<td><input name="file1" type="file"/></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><input type="submit" value="Send File"/></td>
				</tr>
			</table>
			<input type="hidden" name="command2" value="view"/>
			<input type="hidden" name="class2" value="board"/>
			<input type="hidden" name="name2" value="folderlist"/>
			<input type="hidden" name="command3" value="view"/>
			<input type="hidden" name="class3" value="thread"/>
			<input type="hidden" name="id3">
				<xsl:attribute name="value"><xsl:value-of select="../@id"/></xsl:attribute>
			</input>
			<input type="hidden" name="depth3" value="2"/>
			<input type="hidden" name="name3" value="messagelist"/>
			<input type="hidden" name="folder">
				<xsl:attribute name="value"><xsl:value-of select="../../@id"/></xsl:attribute>
			</input>
		</form>
	</xsl:template>
	
	<xsl:template match="Display[@name='messageedit']//Message">
		<h2>Edit message:</h2>
		<form action="xdf.php" method="post">
			<input type="hidden" name="command1" value="update"/>
			<input type="hidden" name="class1" value="message"/>
			<input type="hidden" name="id1">
				<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
			</input>
			<table>
				<tr>
					<td>
						<textarea name="content1" rows="15" cols="60"><xsl:value-of select="Text[@name='content']"/></textarea>
					</td>
				</tr>
				<tr>
					<td align="center">
						<input type="submit" value="Update"/>
					</td>
				</tr>
			</table>
			<input type="hidden" name="command2" value="view"/>
			<input type="hidden" name="class2" value="board"/>
			<input type="hidden" name="name2" value="folderlist"/>
			<input type="hidden" name="command3" value="view"/>
			<input type="hidden" name="class3" value="thread"/>
			<input type="hidden" name="id3">
				<xsl:attribute name="value"><xsl:value-of select="../@id"/></xsl:attribute>
			</input>
			<input type="hidden" name="depth3" value="2"/>
			<input type="hidden" name="name3" value="messagelist"/>
			<input type="hidden" name="folder">
				<xsl:attribute name="value"><xsl:value-of select="../../@id"/></xsl:attribute>
			</input>
		</form>
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
				<xsl:if test="count(ancestor::Folder) &gt; 0">
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
				</xsl:if>
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
				<xsl:if test="count(ancestor::Folder) &gt; 0">
					<tr>
						<td colspan="3"><hr/></td>
					</tr>
					<tr>
						<td colspan="3">
							To move this folder, select where you want it to be below:
							<xsl:for-each select="//Display[@name='folderlist']">
								<xsl:call-template name="folderlist">
									<xsl:with-param name="ignore" select="$folder"/>
								</xsl:call-template>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:if>
			</table>
		</xsl:for-each>
	</xsl:template>
			
</xsl:stylesheet>
