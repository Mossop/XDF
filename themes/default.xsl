<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:param name="folder"/>

	<xsl:include href="template.xsl"/>
	
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
				<xsl:for-each select="LoginInfo">
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
				</xsl:for-each>
			</table>
		</td>
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
				<xsl:for-each select="People">
					<xsl:for-each select="Person">
						<tr>
							<td><xsl:value-of select="@fullname"/></td>
							<td>
								<a>
									<xsl:attribute name="href">mailto:<xsl:value-of select="@email"/></xsl:attribute>
									<xsl:value-of select="@email"/>
								</a>
							</td>
							<td><xsl:value-of select="@phone"/></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</td>
	</xsl:template>
	
	<xsl:template match="Display[@name='threadlist']">
		<xsl:apply-templates select="Folder" mode="threadlist"/>
	</xsl:template>
			
	<xsl:template match="Folder" mode="threadlist">
		<xsl:if test="$folder=@id">

			<td width="578" valign="top">
				<table border="0">
					<tr>
						<td valign="top">
							<h1><xsl:value-of select="@name"/> Messages</h1>
						</td>
						<td valign="top" align="right">
						</td>
					</tr>
					<tr>
						<td colspan="2" width="578">
							<table border="0" cellspacing="1">
								<tr>
									<td width="338"><b>Thread</b></td>
									<td width="100"><b>Author</b></td>
									<td width="120" align="right"><b>Started</b></td>
									<td width="20"></td>
								</tr>
								<xsl:for-each select="Thread">
									<tr>
										<td>
											<a>
												<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=thread&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=2&amp;name2=messagelist&amp;folder=<xsl:value-of select="$folder"/></xsl:attribute>
												<xsl:value-of select="@name"/>
											</a>
										</td>
										<td>
											<xsl:for-each select="Person">
												<xsl:value-of select="@nickname"/>
											</xsl:for-each>
										</td>
										<td align="right"><xsl:apply-templates select="Date"/></td>
										<td></td>
									</tr>
								</xsl:for-each>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<hr/>
							<h2>Post a new thread:</h2>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
						</td>
					</tr>
				</table>
			</td>
			
		</xsl:if>

		<xsl:if test="not($folder=@id)">
			<xsl:apply-templates select="Folder" mode="threadlist"/>
		</xsl:if>

	</xsl:template>
	
	<xsl:template match="Display[@name='messagelist']">
		<xsl:for-each select="//Thread">
			<td width="578" valign="top">
				<table>
					<tr>
						<td>
							<h1>Messages in the thread &quot;<xsl:value-of select="@name"/>&quot;</h1>
						</td>
					</tr>
					<tr width="578">
						<td align="center">
							<xsl:for-each select="Message">
								<table border="0" cellspacing="0" cellpadding="1">
									<tr>
										<td class="messageheader">
											<table>
												<tr>
													<xsl:for-each select="Person">
														<td align="left" class="messageheader">Posted by <xsl:value-of select="@nickname"/></td>
													</xsl:for-each>
													<td align="right" class="messageheader"><xsl:apply-templates select="Date"/></td>
												</tr>
												<tr>
													<td colspan="2" width="578" class="messageheader">
														<a>
															Attach File
														</a>
														<a>
															Edit
														</a>
														<a>
															Delete
														</a>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td width="578" class="messagebody">
											<xsl:call-template name="nl2br">
												<xsl:with-param name="contents" select="Text[@name='content']"/>
											</xsl:call-template>
										</td>
									</tr>
									<tr>
										<td class="messagebody">
											<hr/>
											Attachments:
											<table>
												<xsl:for-each select="File"/>
											</table>
										</td>
									</tr>
								</table>
								<br/>
							</xsl:for-each>
						</td>
					</tr>
					<tr>
						<td>
							<hr/>
						</td>
					</tr>
					<tr>
						<td>
							<h2>Add a new reply to this thread:</h2>
						</td>
					</tr>
					<tr>
						<td align="center">
						</td>
					</tr>
				</table>
			</td>
		</xsl:for-each>
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
