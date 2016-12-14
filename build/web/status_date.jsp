<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Statement"%>
<!DOCTYPE html>
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
<head><title>Hosting</title></head>
<body>
<h3>
<% out.println("Overall status history for: "+request.getParameter("name")); %>
</h3>
<% 
String url = "jdbc:mysql://localhost:3306/mysql";
String uid = "root";
String psw = "atari";
Connection con = null;
try {
 Class.forName("com.mysql.jdbc.Driver");
 con = DriverManager.getConnection(url, uid, psw);
 Statement statement = con.createStatement();
 Statement statement1 = con.createStatement();
 String name= request.getParameter("name");
 if(name.equals("all")) name ="";
 ResultSet rs,rs1;
 String select1,select2,state;
 int green = 0, yellow = 0, dis = 0, count = 7;
 int old_green = 0, old_yellow = 0, old_dis = 0, output_count = 0;
 java.sql.Date day_now = new java.sql.Date( new java.util.Date().getTime() );
 select1 = "select name,state from hosts";
 rs = statement.executeQuery(select1);
 out.println("<svg width=\"1200\" height=\"450\">");
 java.sql.Date day;
 
 for(int i=0;i < count;i++){
   //day = new java.sql.Date( day_now.getTime() - (24*60*60*1000)*(-i+count-1));
   day = new java.sql.Date( day_now.getTime() - (24*60*60*1000)*i);
   green = 0;
   yellow = 0;
   dis = 0;
   while(rs.next()){
        name=rs.getString(1);
        state=rs.getString(2);
        select2="select state from changes where name='"+name+"' and date='"+day+"'";
        rs1 = statement1.executeQuery(select2);
        if(rs1.next()){state=rs.getString(1);}
        if(state.equals("ENABLED")) green = green + 1;
        else 
        if(state.equals("DISABLED")) dis = dis + 1;
        else yellow = yellow + 1;
        rs1.close();
   }      
   rs.beforeFirst();
   if(i==0 || (old_yellow != yellow)){
   //out.println("<rect x=\""+(1+160*i)+"\" y=\"1\" width=\"143\" height=\"355\" style=\"fill:lightgray;stroke:black;stroke-width:1\" />");
    out.println("<rect x=\""+(5+160*output_count)+"\" y=\""+(350-green)+"\" width=\"40\" height=\""+green+"\" style=\"fill:green;stroke:black;stroke-width:1;opacity:0.5\" />");
    out.println("<rect x=\""+(50+160*output_count)+"\" y=\""+(350-yellow)+"\" width=\"40\" height=\""+yellow+"\" style=\"fill:yellow;stroke:black;stroke-width:1;opacity:0.5\" />");
    out.println("<rect x=\""+(95+160*output_count)+"\" y=\""+(350-dis)+"\" width=\"40\" height=\""+dis+"\" style=\"fill:gray;stroke:black;stroke-width:1;opacity:2.0\" />");
    out.println("<text x=\""+(7+160*output_count)+"\" y=\"340\" fill=\"black\">"+green+"</text>");
    out.println("<text x=\""+(53+160*output_count)+"\" y=\"340\" fill=\"black\">"+yellow+"</text>");
    out.println("<text x=\""+(98+160*output_count)+"\" y=\"340\" fill=\"black\">"+dis+"</text>");
    out.println("<text x=\""+(25+160*output_count)+"\"  y=\"373\" fill=\"black\">"+day+"</text>");
    output_count++;
    old_green = green;
    old_yellow = yellow;
    old_dis = dis;
    out.println("<text x=\""+50*i+"\"  y=\"60\" fill=\"black\">"+i+":"+count+"</text>");  
   } else {
    count++;
    //out.println("<text x=\""+50*i+"\"  y=\"120\" fill=\"black\">"+i+":"+count+"</text>");  
   }
 }
 out.println("<svg width=\"850\" height=\"450\">");
 out.println("</svg>");
 rs.close();
 statement.close();
 statement1.close();
} catch(Exception e) {out.println(e);e.printStackTrace();}
if(con != null) con.close();
%>
</body>
</html>