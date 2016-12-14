<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Statement"%>
<%@page language="java" 
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
 Statement statement2 = con.createStatement();
 sdate = request.getParameter("date");
 if(sdate.length() < 2) day_status = new java.sql.Date( new java.util.Date().getTime() );
 else {
     java.util.Date date = new SimpleDateFormat("yyyy-MM-dd").parse(sdate);
     day_status = new java.sql.Date(date.getTime());
 }             
 
 ResultSet rs,rs1,rs2;
 String select1,select2,select3,state,name;
 String[] os_filter = new String[]{"os like '%Windows%'",
                                   "(os like '%Solaris%' or os like '%SunOS%' or os like '%Oracle.1%')",
                                   "(os like '%Linux%' or os like '%Ubuntu%' or os like '%openSUSE%')",
                                   "(os like '%OS X%' or os like '%Mac%')",
                                   "not (trim(os) like '%Linux%' or trim(os) like '%Windows%' or trim(os) like '%Solaris%' or trim(os) like '%SunOS%' or trim(os) like '%Ubuntu%' or trim(os) like '%OS X%' or trim(os) like '%SUSE%' or os like '%Mac%' or os like '%Oracle.1%')"};
 String[] os = new String[]{"Windows","Solaris","Linux","Mac","Undefined"};
 String[] os_cond = new String[] {"rs.getString(3).contains('Windows')",
                                   "rs.getString(3).contains('Solaris') or rs.getString(3).contains('SunOS') or rs.getString(3).contains('Oracle.1')",
                                   "rs.getString(3).contains('Linux') or rs.getString(3).contains('Ubuntu') or rs.getString(3).contains('openSUSE')",
                                   "rs.getString(3).contains('OS X') or rs.getString(3).contains('Mac')",
                                   "not (rs.getString(3).contains('Windows') or rs.getString(3).contains('Linux') or "
                                 + "rs.getString(3).contains('Solaris') or rs.getString(3).contains('SunOS') or"
                                 + "rs.getString(3).contains('Oracle.1') or rs.getString(3).contains('Ubuntu') or )" 
                                 + "rs.getString(3).contains('openSUSE') or rs.getString(3).contains('OS X') or )" 
                                 + "rs.getString(3).contains('Mac'))"};
 int output_count = 0;
 for(int i = 0; i < os_filter.length; i++) {
 int green = 0, yellow = 0, dis = 0, mis = 0;
 select1 = "select name,state,os from vmsqe_hosts";
 rs = statement.executeQuery(select1);
 out.println("<svg width=\"1200\" height=\"450\">");
 while(rs.next()){
        name=rs.getString(1);
        state=rs.getString(2);
        select2="select state from vmsqe_changes where name='"+name+"' and date='"+day_status+"' and "+os_filter[i];
        rs1 = statement1.executeQuery(select2);
        if(rs1.next()){
          state=rs1.getString(1);
          if(state.equals("ENABLED")) green = green + 1;
          else 
          if(state.equals("DISABLED")) dis = dis + 1;
          else
          if(state.equals("MISSED")) mis = mis + 1;    
          else yellow = yellow + 1;
        } else {
            select3="select state from vmsqe_hosts where name='"+name+"' and "+os_filter[i];
            rs2 = statement2.executeQuery(select3);
            if(rs2.next()){
              state=rs2.getString(1);    
              if(state.equals("ENABLED")) green = green + 1;
              else 
              if(state.equals("DISABLED")) dis = dis + 1;
              else
              if(state.equals("MISSED")) mis = mis + 1;    
              else yellow = yellow + 1; 
            }
        }
        rs1.close();
 }      
 out.println("<rect x=\""+(1+185*output_count)+"\" y=\"1\" width=\"183\" height=\"355\" style=\"fill:lightgray;stroke:black;stroke-width:1\" />");
 out.println("<rect x=\""+(5+185*output_count)+"\" y=\""+(350-green)+"\" width=\"40\" height=\""+green+"\" style=\"fill:green;stroke:black;stroke-width:1;opacity:0.5\" />");
 out.println("<rect x=\""+(50+185*output_count)+"\" y=\""+(350-yellow)+"\" width=\"40\" height=\""+yellow+"\" style=\"fill:yellow;stroke:black;stroke-width:1;opacity:0.5\" />");
 out.println("<rect x=\""+(95+185*output_count)+"\" y=\""+(350-dis)+"\" width=\"40\" height=\""+dis+"\" style=\"fill:gray;stroke:black;stroke-width:1;opacity:2.0\" />");
 out.println("<rect x=\""+(140+185*output_count)+"\" y=\""+(350-mis)+"\" width=\"40\" height=\""+mis+"\" style=\"fill:red;stroke:black;stroke-width:1;opacity:2.0\" />");
 out.println("<text x=\""+(7+185*output_count)+"\" y=\""+(345-green)+"\" fill=\"black\">"+green+"</text>");
 out.println("<text x=\""+(53+185*output_count)+"\" y=\""+(345-yellow)+"\" fill=\"black\">"+yellow+"</text>");
 out.println("<text x=\""+(98+185*output_count)+"\" y=\""+(345-dis)+"\" fill=\"black\">"+dis+"</text>");
 out.println("<text x=\""+(144+185*output_count)+"\" y=\""+(345-mis)+"\" fill=\"black\">"+mis+"</text>");
 out.println("<text x=\""+(5+185*output_count)+"\"  y=\"373\" fill=\"black\">"+os[i]+":"+(green+yellow+dis+mis)+"</text>");
 out.println("<svg width=\"850\" height=\"450\">");
 out.println("</svg>");
 output_count++;
 rs.close();
 }
 statement.close();
 statement1.close();
} catch(Exception e) {out.println(e);e.printStackTrace();}
if(con != null) con.close();
%>
</form>
</body>
</html>