<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns="http://www.w3.org/1999/xhtml1/strict"
								version="1">

	<xsl:output method="html" omit-xml-declaration="yes" encoding="iso-8859-1" indent="yes"/>

	<xsl:include href="folderlist.xsl"/>

	<xsl:template name="checkaccess">
		<xsl:param name="class"/>
		<xsl:param name="type"/>
	
		<xsl:choose>
			<xsl:when test="count(/DisplaySet/Login/Group[@id='admin']) &gt; 0">
				1
			</xsl:when>
			<xsl:when test="count(/DisplaySet/Login/Group[@id=concat($class,'admin')]) &gt; 0">
				1
			</xsl:when>
			<xsl:when test="count(/DisplaySet/Login/Group[@id=concat($class,$type)]) &gt; 0">
				1
			</xsl:when>
			<xsl:otherwise>
				0
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:variable name="messageadd">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">message</xsl:with-param>
			<xsl:with-param name="type">add</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="contactadd">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">contact</xsl:with-param>
			<xsl:with-param name="type">add</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="loginadd">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">login</xsl:with-param>
			<xsl:with-param name="type">add</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="folderadd">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">folder</xsl:with-param>
			<xsl:with-param name="type">add</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="folderview">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">folder</xsl:with-param>
			<xsl:with-param name="type">view</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="personview">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">person</xsl:with-param>
			<xsl:with-param name="type">view</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="loginview">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">login</xsl:with-param>
			<xsl:with-param name="type">view</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="loginadmin">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">login</xsl:with-param>
			<xsl:with-param name="type">admin</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="folderadmin">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">folder</xsl:with-param>
			<xsl:with-param name="type">admin</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="personadmin">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">person</xsl:with-param>
			<xsl:with-param name="type">admin</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="messageadmin">
		<xsl:call-template name="checkaccess">
			<xsl:with-param name="class">message</xsl:with-param>
			<xsl:with-param name="type">admin</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:template match="Display[@name='folderlist']">
		<xsl:call-template name="folderlist"/>
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
									<xsl:if test="$folderview=1">
										<td>
											<a>
												<xsl:attribute name="href">xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=folder&amp;id2=<xsl:value-of select="Board/@rootfolder"/>&amp;depth2=1&amp;name2=threadlist&amp;folder=<xsl:value-of select="Board/@rootfolder"/></xsl:attribute>
												Announcements
											</a>
										</td>
									</xsl:if>
									<xsl:if test="$personview=1">
										<td>
											<a href="xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=people&amp;name2=peoplelist">
												Contacts
											</a>
										</td>
									</xsl:if>
									<xsl:if test="$loginview=1">
										<td>
											<a href="xdf.php?command1=view&amp;class1=board&amp;name1=folderlist&amp;command2=view&amp;class2=users&amp;name2=userlist">
												Users
											</a>
										</td>
									</xsl:if>
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
									<td width="200" valign="top">
										<xsl:apply-templates select="Display[@name='folderlist']"/>
										<hr/>
										Change Password<br/>
										Logout<br/>
									</td>
									<td width="578" valign="top">
										<xsl:apply-templates select="Display[@name!='folderlist']"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
