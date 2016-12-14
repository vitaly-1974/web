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
      <head><title>Last day changes</title>
       <style>
       </style>
      </head>
      <body>
          <h3>Last day changes</h3>
    <table border="1" cellpadding="1" cellspacing="0">
        <tr bgcolor=LightGray>
           <th>N</th>
           <th colspan="1">Host</th>    
           <th>ping_before</th>
           <th>ping</th>
           <th>Status_before</th>  
           <th>Status</th>  
           <th>OS_before</th>    
           <th>OS</th>    
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

java.sql.Date day_now = new java.sql.Date( new java.util.Date().getTime() );
java.sql.Date day;
day = new java.sql.Date( day_now.getTime() - (24*60*60*1000)*5);
String s = "" , smax= "";
smax = "SELECT max(date_add) FROM vmsqe_changes";
ResultSet rs_max = statement.executeQuery(smax);
while(rs_max.next()){
    day = rs_max.getDate(1);
}
rs_max.close();

s = "select * from "
    + "(SELECT vmsqe_hosts.name,"
    + "vmsqe_hosts.ping as ping1,"
    + "vmsqe_hosts.state as state1,"
    + "vmsqe_hosts.os as os1,"
    + "vmsqe_hosts.date as date1, "
    + "vmsqe_changes.ping as ping2,"
    + "vmsqe_changes.os as os2,"
    + "vmsqe_changes.state as state2,"
    + "vmsqe_changes.date as date2 "
    + "FROM vmsqe_hosts RIGHT OUTER JOIN vmsqe_changes ON vmsqe_hosts.name = vmsqe_changes.name "
    + "where vmsqe_changes.date_add='"+day+"' order by state1) as s "
    + "where s.ping1 != s.ping2 or s.state1 != s.state2 or s.os1 != s.os2";    
// 1 - name, 2 - ping, 3 - state, 4 - os, 5 - date
// 6 - ping,  7 - os, 8 - state, 9 - failed, 10 - date
ResultSet rs = statement.executeQuery(s);
int i = 0;
String bgcolor = "", sts = "";
String host = "";
while(rs.next()){
    host = rs.getString(1);
    if(host == null) continue;
    i++;
    out.println("<tr>");
    out.println("<td>");
    out.println(i);
    out.println("</td>");
    //host
    out.println("<td align=\"left\">"); 
    out.println("<a href=\"http://aurora.ru.oracle.com/faces/Host.xhtml?host="+rs.getString(1).trim()+"\">"+rs.getString(1).trim()+"</a></td>");
    if(rs.getString(6).equals(rs.getString(2))){
       out.println("<td align=\"left\"></td>");
       out.println("<td align=\"left\"></td>");
    } else {
    //ping_before
    bgcolor=rs.getString(6).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
    out.println("<td align=\"left\" "+bgcolor+"></td>");
    //ping
    bgcolor=rs.getString(2).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
    out.println("<td align=\"left\" "+bgcolor+"></td>");
    }
    if(rs.getString(3).equals(rs.getString(8))){
       out.println("<td align=\"left\"></td>");
       out.println("<td align=\"left\"></td>");
    } else {
    //status_before
    sts = rs.getString(8);
    if( (rs.getString(8).trim()).length() == 0 || rs.getString(8).contains("YELLOW")) {
         bgcolor="style=\"background-color:yellow\"";
         sts = "ENABLED";
    } else 
    if( (rs.getString(8).trim()).equals("DISABLED")) {    
         bgcolor="style=\"background-color:gray\"";    
    } else 
    if( (rs.getString(8).trim()).equals("MISSED")) {    
         bgcolor="style=\"background-color:red\"";    
    }  else   
         bgcolor="style=\"background-color:SeaGreen\"";    
    out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
    //status
    sts = rs.getString(3);
    if( (rs.getString(3).trim()).length() == 0 || rs.getString(3).contains("YELLOW")) {
         bgcolor="style=\"background-color:yellow\"";
         sts = "ENABLED";
    } else 
    if( (rs.getString(3).trim()).equals("DISABLED")) {    
         bgcolor="style=\"background-color:gray\"";    
    } else 
    if( (rs.getString(3).trim()).equals("MISSED")) {    
         bgcolor="style=\"background-color:red\"";    
    }  else   
         bgcolor="style=\"background-color:SeaGreen\"";    
    out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
    }
    //OS_before
    if(rs.getString(4).contains(rs.getString(7)) || rs.getString(7).contains(rs.getString(4))){
    out.println("<td align=\"left\">");out.println("</td>");
    //OS
    out.println("<td align=\"left\">");out.println("</td>");    
    } else {    
    out.println("<td align=\"left\">"); out.println(rs.getString(7)); out.println("</td>");
    //OS
    out.println("<td align=\"left\">"); out.println(rs.getString(4)); out.println("</td>");
    }
    out.println("</tr>");
}
out.println("Last day:"+day);
/*     
        if(host == null) continue;
        i++;            
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
         //status
         sts = rs.getString(3);
         if( (rs.getString(3).trim()).length() == 0 || rs.getString(3).contains("YELLOW")) {
            bgcolor="style=\"background-color:yellow\"";
            sts = "ENABLED";
         } else 
         if( (rs.getString(3).trim()).equals("DISABLED")) {    
            bgcolor="style=\"background-color:gray\"";    
         } else 
         if( (rs.getString(3).trim()).equals("MISSED")) {    
            bgcolor="style=\"background-color:red\"";    
         }  else   
            bgcolor="style=\"background-color:SeaGreen\"";    
            out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
            out.println("<td align=\"left\">"); out.println(rs.getInt(4)); out.println("</td>");
            out.println("<td align=\"left\">"); out.println(rs.getString(5)); out.println("</td>");
            out.println("<td align=\"left\">"); out.println(rs.getDate(6)); out.println("</td>");
            out.println("</td>");
            out.println("</tr>");
        out.println("<tr>");
        out.println("<td>"); 
        out.println("</td>");
        //host
        out.println("<td align=\"left\">"); 
        out.println("<a></a></td>");
        //ping
        bgcolor=rs.getString(7).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
        out.println("<td align=\"left\" "+bgcolor+"></td>");
        //status
        sts = rs.getString(9);
        if( (rs.getString(9).trim()).length() == 0 || rs.getString(9).contains("YELLOW")) {
            bgcolor="style=\"background-color:yellow\"";
            sts = "ENABLED";
        } else 
        if( (rs.getString(9).trim()).equals("DISABLED")) {    
            bgcolor="style=\"background-color:gray\"";    
        } else 
        if( (rs.getString(9).trim()).equals("MISSED")) {    
            bgcolor="style=\"background-color:red\"";    
        } else    
            bgcolor="style=\"background-color:SeaGreen\"";    
        out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getInt(10)); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getString(8)); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getDate(11)); out.println("</td>");
        out.println("</td>");
        out.println("</tr>");
  }
        */
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