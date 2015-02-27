<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.ServletRequest.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.UUID.*" %>
<%@ page import="com.amazonaws.*" %>
<%@ page import="com.amazonaws.auth.*" %>
<%@ page import="com.amazonaws.services.s3.*" %>
<%@ page import="com.amazonaws.services.s3.model.*" %>
<%@ page import="com.amazonaws.AmazonClientException" %>
<%@ page import="com.amazonaws.auth.AWSCredentials" %>
<%@ page import="com.amazonaws.auth.profile.ProfileCredentialsProvider" %>
<%@ page import="com.amazonaws.regions.Region" %>
<%@ page import="com.amazonaws.regions.Regions" %>
<%@ page import="com.amazonaws.services.s3.AmazonS3" %>
<%@ page import="com.amazonaws.services.s3.AmazonS3Client" %>
<%@ page import="com.amazonaws.event.ProgressEvent" %>
<%@ page import="com.amazonaws.event.ProgressListener" %>
<%@ page import="com.amazonaws.services.s3.model.PutObjectRequest" %>
<%@ page import="com.amazonaws.services.s3.transfer.TransferManager" %>
<%@ page import="com.amazonaws.services.s3.transfer.Upload" %>

<%!
    private AmazonS3 s3;
    static String uuid;
 %>
 
<%
        AWSCredentialsProvider credentialsProvider = new ClasspathPropertiesFileCredentialsProvider();
        s3 = new AmazonS3Client(credentialsProvider);
        Region usWest2 = Region.getRegion(Regions.US_WEST_2);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Projekt Kamil Bujakowski</title>
	<link rel="stylesheet" href="styles/styles.css" type="text/css" media="screen">
</head>
<body>
	<script type="text/javascript">
		function removeImage(id)
		{
			window.location.href = 'deleteImage.jsp?key=' + id;
			alert("Image removed");
		}
	</script>
	<div id="content" class="container">
		<h1>Image Browser</h1>
		<div class="section grid grid5 s3">
            <h2>Files in my bucket:</h2><br/>
            <%
            ObjectListing objects = s3.listObjects("kamil-projekt");
            do {
        		for (S3ObjectSummary objectSummary : objects.getObjectSummaries()) 
        		{ 
        	%>
                <img src="https://localhost.com/<%= objectSummary.getKey() %>" 
                alt="photo" class="photo" height="160px" width="160px" 
                id="<%=objectSummary.getKey()%>" onclick="removeImage(id);"> 
        	<%	}
       		objects = s3.listNextBatchOfObjects(objects);
			} while (objects.isTruncated());
			%>
        </div>
	</div>
	
	<div>
	<%
	uuid = UUID.randomUUID().toString();
	uuid = uuid.substring(0, 8);
	uuid += ".jpg";
	System.out.println(uuid);
	session.setAttribute("nameOfFile",uuid);
	%>

    <form action="https://localhost.com/" method="post" enctype="multipart/form-data">
   
   	  <input type="hidden" name="key" value=<%=uuid %> />
      <input type="hidden" name="AWSAccessKeyId" value="***"> 
      <input type="hidden" name="acl" value="public-read"> 
      <input type="hidden" name="policy" value="***">
      <input type="hidden" name="success_action_redirect" value="http://localhost.com:8080/Projekt/queue.jsp">
	  <input type="hidden" name="Content-Type" value="image/jpeg">
	  <input type="hidden" name="signature" value="***">
      <!-- Include any additional input fields here -->
       
      <input type="file" name="file" > 
      <br> 
      <input type="submit" value="Upload File to S3"> 
    </form>  
    
    <%
    System.out.println(session);
    %>
    </div>
</body>
</html>