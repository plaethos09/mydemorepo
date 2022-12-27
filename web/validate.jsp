<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.util.Properties,javax.mail.*,java.sql.*,javax.servlet.http.*,javax.mail.internet.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Date,java.util.Properties,javax.mail.Authenticator,javax.mail.Message, javax.mail.MessagingException, javax.mail.PasswordAuthentication" %>
<%@ page import= "javax.mail.Session,javax.mail.Transport,javax.mail.internet.AddressException,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
String path=null;
String uname=request.getParameter("user");
String fname=request.getParameter("fname");
String cloud=request.getParameter("cloud");
String owner=request.getParameter("msg");

System.out.println("username@@@@"+uname);
System.out.println("filename@@@@"+fname);
System.out.println("cloud name@@@@"+cloud);

System.out.println("owner@@@@"+owner);
String status="download";
Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/privacy","root","");
String message="";
String subject=" Your Encrypted Key for your secure Data";
PreparedStatement ps1=con.prepareStatement("select EMAIL from userregistration where UNAME=?");
ps1.setString(1,uname);
ResultSet rs = ps1.executeQuery();
while(rs.next())
{ 
	String email = rs.getString("EMAIL");
	System.out.println("email@@@@"+email);
	
	PreparedStatement ps=con.prepareStatement("update request set status=? where username=? and filename=? and cloud=?");

	ps.setString(1,status);
	ps.setString(2,uname);
	ps.setString(3,fname);
	ps.setString(4,cloud);
	int i =ps.executeUpdate();
	try
	{
	if(i>0)
	{
		PreparedStatement ps2=con.prepareStatement("select * from transaction where FILEOWNERNAME=? and filename=?");
		ps2.setString(1,owner);
		ps2.setString(2,fname);
		ResultSet rs2 = ps2.executeQuery();
		if(rs2.next())
		{
			String key = rs2.getString("key");
			System.out.println("key@@@@"+key);
message="This is your Encrypted Key for Download File: " +key;
		// mail sending code
		  Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
 
        // creates a new session with an authenticator
        Authenticator auth = new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("studentcheckmail@gmail.com", "st@ff123");
            }
        };
 
        Session session1 = Session.getInstance(properties, auth);
 
        // creates a new e-mail message
        Message msg = new MimeMessage(session1);
 
        msg.setFrom(new InternetAddress("studentcheckmail@gmail.com"));
        InternetAddress[] toAddresses = { new InternetAddress(email) };
        msg.setRecipients(Message.RecipientType.TO, toAddresses);
        msg.setSubject(subject);
        msg.setSentDate(new Date());
        msg.setText(message);
 
        // sends the e-mail
        Transport.send(msg);
 
		
		//end of mail sending
		//to=rs2.getString(5);
	   // session.setAttribute("username",uname);
		response.sendRedirect("home.jsp");
	}
	}

	}
	catch(Exception e)
	{
	e.printStackTrace();	
	}
	
}


	%>


	</body>
	</html>