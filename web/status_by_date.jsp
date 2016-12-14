<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Date"%>
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
<!DOCTYPE html>
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script> 
<script src="//cdn.jsdelivr.net/webshim/1.14.5/polyfiller.js"></script>
<script>
webshims.setOptions('forms-ext', {types: 'date'});
webshims.polyfill('forms forms-ext');
$.webshims.formcfg = {
en: {
    dFormat: '-',
    dateSigns: '-',
    patterns: {
        d: "yy-mm-dd"
    }
}
};
</script>

<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head>
<body>
<a>Status by Date:</a>
<%
String sdate = request.getParameter("date");
java.sql.Date day_status = new java.sql.Date( new java.util.Date().getTime() );
if(sdate.length() < 2) sdate=day_status.toString();
%>
<form name="form1" onsubmit="checkBoxValidation()">
<input type="date" name="date" id="theDate" value="<%=sdate%>">
<br><p><input type="submit" value="Show"/></p>
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
 sdate = request.getParameter("date");
 if(sdate.length() < 2) day_status = new java.sql.Date( new java.util.Date().getTime() );
 else {
     java.util.Date date = new SimpleDateFormat("yyyy-MM-dd").parse(sdate);
     day_status = new java.sql.Date(date.getTime());
 }             
 
 ResultSet rs,rs1;
 String select1,select2,state,name;
 int green = 0, yellow = 0, dis = 0;
 //day_status = new java.sql.Date(date.getTime() );
 select1 = "select name,state from hosts";
 rs = statement.executeQuery(select1);
 out.println("<svg width=\"1200\" height=\"450\">");
 green = 0;
 yellow = 0;
 dis = 0;
 while(rs.next()){
        name=rs.getString(1);
        state=rs.getString(2);
        select2="select state from changes where name='"+name+"' and date='"+day_status+"'";
        rs1 = statement1.executeQuery(select2);
        if(rs1.next()){state=rs.getString(1);}
        if(state.equals("ENABLED")) green = green + 1;
        else 
        if(state.equals("DISABLED")) dis = dis + 1;
        else yellow = yellow + 1;
        rs1.close();
 }      
 int output_count = 0;
 //out.println("<rect x=\""+(1+160*i)+"\" y=\"1\" width=\"143\" height=\"355\" style=\"fill:lightgray;stroke:black;stroke-width:1\" />");
 out.println("<rect x=\""+(5+160*output_count)+"\" y=\""+(350-green)+"\" width=\"40\" height=\""+green+"\" style=\"fill:green;stroke:black;stroke-width:1;opacity:0.5\" />");
 out.println("<rect x=\""+(50+160*output_count)+"\" y=\""+(350-yellow)+"\" width=\"40\" height=\""+yellow+"\" style=\"fill:yellow;stroke:black;stroke-width:1;opacity:0.5\" />");
 out.println("<rect x=\""+(95+160*output_count)+"\" y=\""+(350-dis)+"\" width=\"40\" height=\""+dis+"\" style=\"fill:gray;stroke:black;stroke-width:1;opacity:2.0\" />");
 out.println("<text x=\""+(7+160*output_count)+"\" y=\"340\" fill=\"black\">"+green+"</text>");
 out.println("<text x=\""+(53+160*output_count)+"\" y=\"340\" fill=\"black\">"+yellow+"</text>");
 out.println("<text x=\""+(98+160*output_count)+"\" y=\"340\" fill=\"black\">"+dis+"</text>");
 out.println("<text x=\""+(25+160*output_count)+"\"  y=\"373\" fill=\"black\">"+day_status+"</text>");
 out.println("<svg width=\"850\" height=\"450\">");
 out.println("</svg>");
 rs.close();
 statement.close();
 statement1.close();
} catch(Exception e) {out.println(e);e.printStackTrace();}
if(con != null) con.close();
%>
</form>
</body>
</html>