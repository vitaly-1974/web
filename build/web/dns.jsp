<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@ page language="java" 
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" 
import="java.sql.DriverManager,
java.sql.Connection, 
java.sql.PreparedStatement, 
java.sql.ResultSet, 
java.sql.SQLException"
%>
    <html>
      <head><title>History</title>
       <style>
       </style>
      </head>
      <body>
          <h3>History for auto disabled hosts</h3>
    <table border="1" cellpadding="1" cellspacing="0">
        <tr bgcolor=LightGray>
           <th>N</th>
           <th colspan="1">Host</th>    
           <th>Failed jobs</th>    
           <th>Date</th>    
           <th>Time</th>    
        </tr>
<% 
String url = "jdbc:mysql://localhost:3306/mysql";
String uid = "root";
String psw = "atari";
Connection con = null;
try {
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection(url, uid, psw);
Statement statement = con.createStatement();
Long curTime = System.currentTimeMillis(); 
Date curDate = new Date(curTime);
Date date = new Date();
java.sql.Date sqlDate = new java.sql.Date(date.getTime());
String s = "SELECT name,location FROM hosts where (location like 'santa%' or location like 'burlin%') and ping='+' and ssh='+'";
ResultSet rs = statement.executeQuery(s);
int i = 1;
String host = "", cmd ="", loc="";
Boolean outp = false;
while(rs.next()){
        host = rs.getString(1);
        loc = rs.getString(2);
        if(host == null) continue;
        outp = false;
        cmd = "/export/dns.sh "+host;
        Process p = Runtime.getRuntime().exec(cmd);
        BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
        BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
        String ss,output = "";
         while ((ss = stdInput.readLine()) != null) {
            //System.out.println(s);
            output = output + ss;
         }
         while ((ss = stdError.readLine()) != null) {
            //System.out.println(s);
            output = output + ss;
         }
         if(loc.contains("santaclara")) {
           if(!output.contains("10.209.76.198") || !output.contains("10.209.76.197") || !output.contains("192.135.82.132")) {
              outp = true;
           }    
         } else               
           if(!output.contains("192.135.82.124") || !output.contains("144.20.190.70") || !output.contains("192.135.82.132")) {
              outp = true; 
           }    
        if(outp){ 
        out.println("<tr>");
        out.println("<td>");
        out.println(i);
        out.println("</td>");
        //host
        out.println("<td align=\"left\">"); 
        out.println("<a href=\"http://aurora.ru.oracle.com/faces/Host.xhtml?host="+rs.getString(1).trim()+"\">"+rs.getString(1).trim()+"</a></td>");
        out.println("<td align=\"left\">"); out.println(rs.getString(2)); out.println("</td>");
        out.println("</td>");
        out.println("</tr>");
        i++;
        }
  }
} catch(Exception e)
{ 
  out.println(e);
}

if(con != null) {
   con.close();
}
%>
</table>
</body>
</html>