<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:include href="template.xsl"/>
	<xsl:include href="functions.xsl"/>	
	
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
				<xsl:for-each select="LoginInfo/Login">
					<xsl:sort select="@id"/>
					<tr>
						<td><xsl:value-of select="@id"/></td>
						<td><xsl:apply-templates select="Date"/></td>
						<td><xsl:value-of select="Person/@fullname"/></td>
						<td></td>
						<td></td>
					</tr>
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
				<xsl:for-each select="People/Person">
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
			</table>
		</td>
	</xsl:template>
	
	<xsl:template match="Display[@name='threadlist']">
		<xsl:apply-templates select="Folder" mode="threadlist"/>
	</xsl:template>
			
	<xsl:template match="Folder" mode="threadlist">
		<xsl:if test="/DisplaySet/@folder=@id">

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
												<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=thread&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=2&amp;name2=messagelist&amp;folder=<xsl:value-of select="/DisplaySet/@folder"/></xsl:attribute>
												<xsl:value-of select="@name"/>
											</a>
										</td>
										<td>
											<xsl:value-of select="Person/@nickname"/>
										</td>
										<td align="right"><xsl:apply-templates select="Date"/></td>
										<td></td>
									</tr>
								</xsl:for-each>
							</table>
						</td>
					</tr>
					<xsl:if test="$messageadd=1">
						<tr>
							<td colspan="2">
								<hr/>
								<h2>Post a new thread:</h2>
								<form action="xdf.php" method="post">
									<input type="hidden" name="command1" value="add"/>
									<input type="hidden" name="class1" value="thread"/>
									<input type="hidden" name="folder1">
										<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
									</input>
									<input type="hidden" name="command2" value="add"/>
									<input type="hidden" name="class2" value="message"/>
									<input type="hidden" name="thread2" value="lastid"/>
									<table>
										<tr>
											<td>Subject:</td>
											<td><input type="text" name="name1" size="70"/></td>
										</tr>
										<tr>
											<td colspan="2">
												<textarea name="content2" rows="15" cols="60"></textarea>
											</td>
										</tr>
										<tr>
											<td colspan="2" align="center">
												<input type="submit" value="Add"/>
											</td>
										</tr>
									</table>
									<input type="hidden" name="command3" value="view"/>
									<input type="hidden" name="class3" value="board"/>
									<input type="hidden" name="name3" value="folderlist"/>
									<input type="hidden" name="command4" value="view"/>
									<input type="hidden" name="class4" value="folder"/>
									<input type="hidden" name="id4">
										<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
									</input>
									<input type="hidden" name="depth4" value="1"/>
									<input type="hidden" name="name4" value="threadlist"/>
									<input type="hidden" name="folder">
										<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
									</input>
								</form>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td align="center" colspan="2">
						</td>
					</tr>
				</table>
			</td>
			
		</xsl:if>

		<xsl:if test="not(/DisplaySet/@folder=@id)">
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
													<td align="left" class="messageheader">Posted by <xsl:value-of select="Person/@nickname"/></td>
													<td align="right" class="messageheader"><xsl:apply-templates select="Date"/></td>
												</tr>
												<xsl:if test="($messageadmin=1) or (Person/@id=/DisplaySet/Login/Person/@id)">
													<tr>
														<td colspan="2" width="578" class="messageheader">
															<a>
																Attach File
															</a>
															<xsl:text> </xsl:text>
															<a>
																Edit
															</a>
															<xsl:text> </xsl:text>
															<a>
																Delete
															</a>
														</td>
													</tr>
												</xsl:if>
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
									<xsl:if test="count(File) &gt; 0">
										<tr>
											<td class="messagebody">
												<hr/>
												Attachments:
												<table>
													<xsl:for-each select="File">
														<tr>
															<td width="20">
																<xsl:value-of select="position()"/>:
															</td>
															<td width="400">
																<xsl:value-of select="@description"/>
															</td>
															<td align="right" width="158">
																<a>
																	<xsl:attribute name="href">xdf.php?command=downloadfile&amp;file=<xsl:value-of select="@id"/></xsl:attribute>
																	<xsl:value-of select="@filename"/>
																</a>
															</td>
														</tr>
													</xsl:for-each>
												</table>
											</td>
										</tr>
									</xsl:if>
								</table>
								<br/>
							</xsl:for-each>
						</td>
					</tr>
					<xsl:if test="$messageadd=1">
						<tr>
							<td>
								<hr/>
							</td>
						</tr>
						<tr>
							<td>
								<h2>Add a new reply to this thread:</h2>
								<form action="xdf.php" method="post">
									<input type="hidden" name="command1" value="add"/>
									<input type="hidden" name="class1" value="message"/>
									<input type="hidden" name="thread1">
										<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
									</input>
									<table>
										<tr>
											<td>
												<textarea name="content1" rows="15" cols="60"></textarea>
											</td>
										</tr>
										<tr>
											<td align="center">
												<input type="submit" value="Add"/>
											</td>
										</tr>
									</table>
									<input type="hidden" name="command2" value="view"/>
									<input type="hidden" name="class2" value="board"/>
									<input type="hidden" name="name2" value="folderlist"/>
									<input type="hidden" name="command3" value="view"/>
									<input type="hidden" name="class3" value="thread"/>
									<input type="hidden" name="id3">
										<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
									</input>
									<input type="hidden" name="depth3" value="2"/>
									<input type="hidden" name="name3" value="messagelist"/>
									<input type="hidden" name="folder">
										<xsl:attribute name="value"><xsl:value-of select="/DisplaySet/@folder"/></xsl:attribute>
									</input>
								</form>
							</td>
						</tr>
					</xsl:if>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="Display[@name='folderlist']">
		<xsl:variable name="maxdepth"><xsl:call-template name="maxdepth"/></xsl:variable>
		<td width="200" valign="top">
			<table border="0" cellspacing="3" cellpadding="0">
				<xsl:apply-templates select="Folder" mode="folderlist">
					<xsl:sort select="@name"/>
					<xsl:with-param name="indent">0</xsl:with-param>
					<xsl:with-param name="span" select="$maxdepth + 1"/>
				</xsl:apply-templates>
				<tr><td><xsl:attribute name="colspan"><xsl:value-of select="$maxdepth+2"/></xsl:attribute><hr/></td></tr>
				<tr><td><xsl:attribute name="colspan"><xsl:value-of select="$maxdepth+2"/></xsl:attribute>Change Password</td></tr>
				<tr><td><xsl:attribute name="colspan"><xsl:value-of select="$maxdepth+2"/></xsl:attribute>Logout</td></tr>
			</table>
		</td>
	</xsl:template>

	<xsl:template match="Folder" mode="folderlist">
		<xsl:param name="indent"/>
		<xsl:param name="span"/>

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
					<xsl:value-of select="@name"/>
				</a>
			</td>
		</tr>

		<xsl:apply-templates select="Folder" mode="folderlist">
			<xsl:sort select="@name"/>
			<xsl:with-param name="indent" select="$indent + 1"/>
			<xsl:with-param name="span" select="$span - 1"/>
		</xsl:apply-templates>

	</xsl:template>
	
	<xsl:template name="getstatus">
		<xsl:choose>
			<xsl:when test="/DisplaySet/@folder=@id">open</xsl:when>
			<xsl:otherwise>closed</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
</xsl:stylesheet>
