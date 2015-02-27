<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.amazonaws.*" %>
<%@ page import="com.amazonaws.auth.*" %>
<%@ page import="com.amazonaws.AmazonClientException" %>
<%@ page import="com.amazonaws.auth.AWSCredentials" %>
<%@ page import="com.amazonaws.auth.profile.ProfileCredentialsProvider" %>
<%@ page import="com.amazonaws.regions.Region" %>
<%@ page import="com.amazonaws.regions.Regions" %>
<%@ page import="com.amazonaws.services.sqs.AmazonSQS" %>
<%@ page import="com.amazonaws.services.sqs.AmazonSQSClient" %>
<%@ page import="com.amazonaws.services.sqs.model.*" %>


<%
	AmazonSQS sqs;
   
   	AWSCredentialsProvider credentialsProvider = new ClasspathPropertiesFileCredentialsProvider();
   	sqs = new AmazonSQSClient(credentialsProvider);
   
   	Region usWest2 = Region.getRegion(Regions.US_WEST_2);
  	sqs.setRegion(usWest2);
   
   	String filee = String.valueOf(session.getAttribute("nameOfFile"));
   	System.out.println("FilePath: " + filee);
   
   	CreateQueueRequest createQueueRequest = new CreateQueueRequest("SQS");
	String myQueueUrl = sqs.createQueue(createQueueRequest).getQueueUrl();
	sqs.sendMessage(new SendMessageRequest(myQueueUrl, filee));

	System.out.println(myQueueUrl + " " + sqs);
%>

<script>
window.location.href = "index.jsp";
</script>
