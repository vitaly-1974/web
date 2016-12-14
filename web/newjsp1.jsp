<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@ page import="java.io.*,java.util.*" %>
<html>
<head>
<title>Auto Refresh Header Example</title>
</head>
<body>
<center>
<h2>Auto Refresh</h2>
</center>
<%
   // Set refresh, autoload time as 5 seconds
   response.setIntHeader("Refresh", 5);
   int i = 0;
   // Get current time
   Calendar calendar = new GregorianCalendar();
   String am_pm;
   int hour = calendar.get(Calendar.HOUR);
   int minute = calendar.get(Calendar.MINUTE);
   int second = calendar.get(Calendar.SECOND);
   if(calendar.get(Calendar.AM_PM) == 0)
      am_pm = "AM";
   else
      am_pm = "PM";
   //String CT = hour+":"+ minute +":"+ second +" "+ am_pm;
   //out.println("Current Time: " + CT + "\n");
   //i++;
   //File file = new File("/tmp/devops3").getAbsoluteFile();
   //String line;
   
   //BufferedReader br = new BufferedReader (new InputStreamReader(new FileInputStream( file ), "UTF-8")); 
   //while ((line = br.readLine()) != null) {
   //      out.println(line+"<br>");  
   //}
   //} catch (Exception e) {
   //}  
String url = "jdbc:mysql://localhost:3306/mysql", uid = "root", psw = "atari";
Class.forName("com.mysql.jdbc.Driver");
Statement stm;
ResultSet rs;
Connection con;
con = DriverManager.getConnection(url, uid, psw);
stm = con.createStatement();
rs = stm.executeQuery("select name from devops where reboot=\"Y\"");
while(rs.next()) {
    out.println(rs.getString(1)+"<br>");
}
rs.close();
stm.close();
con.close();
%>
</body>
</html>