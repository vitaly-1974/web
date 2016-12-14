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

          <h3>History</h3>
    <table border="1" cellpadding="1" cellspacing="0">
        <tr bgcolor=LightGray>
           <th>N</th>
           <th colspan="1">Host</th>    
           <th>ping</th>    
           <th>ssh</th>
           <th>Status</th>    
           <th>Failed jobs</th>    
           <th>Date</th>    
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
String s = "";
s = "SELECT hosts.name,hosts.ping as ping1,hosts.ssh as ssh1,hosts.state as state1,hosts.failed_jobs as failed_jobs1,hosts.date as date1, changes.ping as ping2,changes.ssh as ssh2,changes.state as state2,changes.failed_jobs as failed_jobs2,changes.date as date2 FROM hosts RIGHT OUTER JOIN changes ON hosts.name = changes.name order by name,date2 desc";
// 1 - name, 2 - ping, 3 - ssh, 4 - state, 5 - failed, 6 - date
// 7 - ping, 8 - ssh, 9 - state, 10 - failed, 11 - date
ResultSet rs = statement.executeQuery(s);
int i = 0;
String bgcolor = "", sts = "";
boolean new_host = true;
String host = "",old_host = "";
while(rs.next()){
        host = rs.getString(1);
        if(host == null) continue;
        if (old_host.equals(host)) {
            new_host = false;
        }  else {
            new_host = true;
            i++;            
        }    
        if (new_host) {    
         out.println("<tr>");
         out.println("<td>");
         out.println(i);
         out.println("</td>");
         //host
         out.println("<td align=\"left\">"); 
         out.println("<a href=\"http://aurora.ru.oracle.com/faces/Host.xhtml?host="+rs.getString(1).trim()+"\">"+rs.getString(1).trim()+"</a></td>");
         //ping
         bgcolor=rs.getString(2).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
         out.println("<td align=\"left\" "+bgcolor+"></td>");
         //ssh
         bgcolor=rs.getString(3).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
         out.println("<td align=\"left\" "+bgcolor+"></td>");
         //status
         sts = rs.getString(4);
         if( (rs.getString(4).trim()).length() == 0) {
            bgcolor="style=\"background-color:yellow\"";
            sts = "ENABLED";
         } else 
         if( (rs.getString(4).trim()).equals("DISABLED")) {    
            bgcolor="style=\"background-color:gray\"";    
         } else 
            bgcolor="style=\"background-color:SeaGreen\"";    
            out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
            out.println("<td align=\"left\">"); out.println(rs.getInt(5)); out.println("</td>");
            out.println("<td align=\"left\">"); out.println(rs.getDate(6)); out.println("</td>");
            out.println("</td>");
            out.println("</tr>");
        } 
        out.println("<tr>");
        out.println("<td>"); 
        out.println("</td>");
        //host
        out.println("<td align=\"left\">"); 
        out.println("<a></a></td>");
        //ping
        bgcolor=rs.getString(7).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
        out.println("<td align=\"left\" "+bgcolor+"></td>");
        //ssh
        bgcolor=rs.getString(8).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
        out.println("<td align=\"left\" "+bgcolor+"></td>");
        //status
        sts = rs.getString(9);
        if( (rs.getString(9).trim()).length() == 0) {
            bgcolor="style=\"background-color:yellow\"";
            sts = "ENABLED";
        } else 
        if( (rs.getString(9).trim()).equals("DISABLED")) {    
            bgcolor="style=\"background-color:gray\"";    
        } else 
            bgcolor="style=\"background-color:SeaGreen\"";    
        out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getInt(10)); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getDate(11)); out.println("</td>");
        out.println("</td>");
        out.println("</tr>");
        
        old_host = host;        
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