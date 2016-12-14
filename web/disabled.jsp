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
          <h3>History for suspicious or auto disabled hosts</h3>
    <table border="1" cellpadding="1" cellspacing="0">
        <tr bgcolor=LightGray>
           <th>N</th>
           <th colspan="1">Host</th>    
           <th>Status</th>    
           <th>Failed jobs</th>    
           <th>Failure</th>
           <th>Job</th>
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
//String s = "SELECT * FROM disabled order by date desc";
String s = "select disabled.*,vmsqe_hosts.state from disabled join vmsqe_hosts on disabled.name=vmsqe_hosts.name UNION select disabled.*,hosts.state from disabled join hosts on disabled.name=hosts.name order by date desc,state;";
ResultSet rs = statement.executeQuery(s);
int i = 1;
String host = "";
while(rs.next()){
        host = rs.getString(1);
        if(host == null) continue;
        out.println("<tr>");
        out.println("<td>");
        out.println(i);
        out.println("</td>");
        //host
        out.println("<td align=\"left\">"); 
        out.println("<a href=\"http://aurora.ru.oracle.com/faces/Host.xhtml?host="+rs.getString(1).trim()+"\">"+rs.getString(1).trim()+"</a></td>");
        String sts = rs.getString(7);
        String bgcolor = "";
        if(sts.length() == 0 || sts.equals("YELLOW")) {
            bgcolor="style=\"background-color:yellow\"";
            sts = "ENABLED";
        } else 
        if(sts.equals("DISABLED")) {    
            bgcolor="style=\"background-color:gray\"";    
        } else 
        if(sts.equals("MISSED")) {    
            bgcolor="style=\"background-color:red\"";    
        } else    
            bgcolor="style=\"background-color:SeaGreen\"";    
        out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getInt(2)); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getString(5)); out.println("</td>");
        out.println("<td align=\"left\">"); 
        out.println("<a href=\""+rs.getString(6)+"\">job</a></td>");
        out.println("<td align=\"left\">"); out.println(rs.getDate(3)); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getTimestamp(4)); out.println("</td>");
        out.println("</tr>");
        i++;
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