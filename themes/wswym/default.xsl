<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:include href="template.xsl"/>
	<xsl:include href="formatting.xsl"/>	
	
	<xsl:template match="Display[@name='userlist']">
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
	</xsl:template>

	<xsl:template match="Display[@name='peoplelist']">
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
	</xsl:template>
	
	<xsl:template match="Display[@name='threadlist']">
		<xsl:variable name="folder" select="@id"/>
		<xsl:apply-templates select="descendant::Folder[@id=$folder]" mode="threadlist"/>
	</xsl:template>
			
	<xsl:template match="Folder" mode="threadlist">

				<table border="0">
					<tr>
						<td valign="top">
							<h1><xsl:value-of select="@name"/> Messages</h1>
						</td>
						<td valign="top" align="right">
							<xsl:if test="$folderadmin=1">
								<a>
									<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=folder&amp;id2=<xsl:value-of select="@id"/>&amp;name2=folderedit&amp;folder=<xsl:value-of select="@id"/>&amp;stylesheet=edit</xsl:attribute>
									Administration
								</a>
							</xsl:if>
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

	</xsl:template>
	
	<xsl:template match="Display[@name='messagelist']">
		<xsl:for-each select="//Thread">
				<table>
					<tr>
						<td valign="top">
							<h1>Messages in the thread &quot;<xsl:value-of select="@name"/>&quot;</h1>
						</td>
						<td valign="top" align="right">
							<xsl:if test="$messageadmin=1">
								Administration
							</xsl:if>
						</td>
					</tr>
					<tr width="578">
						<td align="center" colspan="2">
							<xsl:for-each select="Message">
								<xsl:call-template name="window">
									<xsl:with-param name="header">
										<table width="100%">
											<tr>
												<td align="left">Posted by <xsl:value-of select="Person/@nickname"/></td>
												<td align="right"><xsl:apply-templates select="Date"/></td>
											</tr>
											<xsl:if test="($messageadmin=1) or (Person/@id=/DisplaySet/Login/Person/@id)">
												<tr>
													<td colspan="2">
														<table>
															<tr>
																<td valign="middle">
																	<a>
																		<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=message&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=0&amp;name2=fileupload&amp;folder=<xsl:value-of select="../../@folder"/>&amp;stylesheet=edit</xsl:attribute>
																		<img align="middle" src="images/paperclip.gif"/>
																		Attach File
																	</a>
																</td>
																<td>|</td>
																<td valign="middle">
																	<a>
																		<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=message&amp;id2=<xsl:value-of select="@id"/>&amp;depth2=0&amp;name2=messageedit&amp;folder=<xsl:value-of select="../../@folder"/>&amp;stylesheet=edit</xsl:attribute>
																		<img align="middle" src="images/edit.gif"/>
																		Edit
																	</a>
																</td>
																<td>|</td>
																<td valign="middle">
																	<a>
																		<xsl:attribute name="href">xdf.php?command1=delete&amp;class1=message&amp;id1=<xsl:value-of select="@id"/>&amp;command2=view&amp;class2=board&amp;name2=folderlist&amp;command3=view&amp;class3=thread&amp;id3=<xsl:value-of select="../@id"/>&amp;depth3=2&amp;name3=messagelist&amp;folder=<xsl:value-of select="../../@folder"/></xsl:attribute>
																		<img align="middle" src="images/delete.gif"/>
																		Delete
																	</a>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="count(File) &gt; 0">
												<tr>
													<td colspan="2">
														<hr/>
														<table>
															<xsl:for-each select="File">
																<tr>
																	<td width="10">
																		<img src="images/paperclip.gif"/>
																	</td>
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
																	<xsl:if test="($messageadmin=1) or (Person/@id=/DisplaySet/Login/Person/@id)">
																		<td>
																			<a>
																				<xsl:attribute name="href">xdf.php?command1=delete&amp;class1=file&amp;id1=<xsl:value-of select="@id"/>&amp;command2=view&amp;class2=board&amp;name2=folderlist&amp;command3=view&amp;class3=thread&amp;id3=<xsl:value-of select="../../@id"/>&amp;depth3=2&amp;name3=messagelist&amp;folder=<xsl:value-of select="../../../@folder"/></xsl:attribute>
																				<img src="images/delete.gif" alt="delete" align="middle"/>
																			</a>
																		</td>
																	</xsl:if>
																</tr>
															</xsl:for-each>
														</table>
													</td>
												</tr>
											</xsl:if>
										</table>
									</xsl:with-param>
									<xsl:with-param name="body">
										<xsl:call-template name="nl2br">
											<xsl:with-param name="contents" select="Text[@name='content']"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
								<br/>
							</xsl:for-each>
						</td>
					</tr>
					<xsl:if test="$messageadd=1">
						<tr>
							<td colspan="2">
								<hr/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
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
		</xsl:for-each>
	</xsl:template>
		
</xsl:stylesheet>
