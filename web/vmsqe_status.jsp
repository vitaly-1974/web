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
          <h3><% out.println("Overall status for: "+request.getParameter("name")); %></h3>
    <table border="1" cellpadding="1" cellspacing="0">
        <tr>
           <th bgcolor=Gainsboro>OS</th>
           <th bgcolor=SeaGreen>ENABLED (%)</th>    
           <th bgcolor=yellow>ENABLED (%)</th>    
           <th bgcolor=gray>DISABLED (%)</th>
           <th bgcolor=red>MISSED (%)</th>
           <th bgcolor=Gainsboro>Total</th>    
        </tr>
<% 
String host = "sette0.ru.oracle.com";
String url = "jdbc:mysql://"+host+"localhost:3306/mysql";
String uid = "root";
String psw = "atari";
Connection con = null;
try {
 Class.forName("com.mysql.jdbc.Driver");
 con = DriverManager.getConnection(url, uid, psw);
 Statement statement = con.createStatement();
 String name= request.getParameter("name");
 if(name.equals("all")) name ="";
 ResultSet rs;
 String[] select = new String[]{
      "select name,os,state,COUNT(*) from vmsqe_hosts where name like '%"+name+"%' and os like '%Windows%' group by state;",
      "select name,os,state,COUNT(*) from vmsqe_hosts where name like '%"+name+"%' and (os like '%Solaris%' or os like '%SunOS%' or os like '%Oracle.1%') GROUP BY state",
      "select name,os,state,COUNT(*) from vmsqe_hosts where name like '%"+name+"%' and (os like '%Linux%' or os like '%Ubuntu%' or os like '%openSUSE%')  GROUP BY state",
      "select name,os,state,COUNT(*) from vmsqe_hosts where name like '%"+name+"%' and (os like '%OS X%' or os like '%Mac%') GROUP BY state;",
      "select name,os,state,COUNT(*) from vmsqe_hosts where name like '%"+name+"%' and not (trim(os) like '%Linux%' or trim(os) like '%Windows%' or trim(os) like '%Solaris%' or trim(os) like '%SunOS%' or trim(os) like '%Ubuntu%' or trim(os) like '%OS X%' or trim(os) like '%SUSE%' or os like '%Mac%' or os like '%Oracle.1%') GROUP BY state;"};
 String[] arch = new String[]{"Windows*","Solaris*","Linux*","MAC*","Undefined"};
 int count;
 int arch_green = 0, arch_yellow = 0, arch_disabled = 0, arch_missed = 0;
 int arch_green_total = 0, arch_yellow_total = 0, arch_disabled_total = 0, arch_missed_total = 0, total = 0;
 String state,bg;
 
 for(int i = 0; i < 5; i++) {
     
   count = 0; 
   arch_green = 0;
   arch_yellow = 0;
   arch_disabled = 0;
   arch_missed = 0;
   if(i % 2 == 0) bg = "white"; else bg = "LightYellow";
   //out.println(select[i]);
   statement = con.createStatement();
   rs = statement.executeQuery(select[i]);
   while(rs.next()){
        state=rs.getString(3);
        count=rs.getInt(4);
        if(state.equals("ENABLED")){
            arch_green = count;
        } else 
        if(state.equals("DISABLED")){    
            arch_disabled = count;
        } else
        if(state.equals("MISSED")){    
            arch_missed = count;
        } else   
            arch_yellow = count;
   }    
   statement.close();
   out.println("<tr>");
   out.println("<td bgcolor="+bg+">"+arch[i]+"</td>");
   if(arch_disabled+arch_yellow+arch_green > 0){
      out.println("<td bgcolor="+bg+">"+arch_green+" ("+String.format("%8.1f", (double) arch_green*100/(arch_disabled+arch_yellow+arch_green+arch_missed)).trim()+"%)</td>");
      out.println("<td bgcolor="+bg+">"+arch_yellow+" ("+String.format("%8.1f", (double) arch_yellow*100/(arch_disabled+arch_yellow+arch_green+arch_missed)).trim()+"%)</td>");
      out.println("<td bgcolor="+bg+">"+arch_disabled+" ("+String.format("%8.1f", (double) arch_disabled*100/(arch_disabled+arch_yellow+arch_green+arch_missed)).trim()+"%)</td>");
      out.println("<td bgcolor="+bg+">"+arch_missed+" ("+String.format("%8.1f", (double) arch_missed*100/(arch_disabled+arch_missed+arch_yellow+arch_green)).trim()+"%)</td>");
   } else {
    out.println("<td bgcolor="+bg+">"+arch_green+"</td>");
    out.println("<td bgcolor="+bg+">"+arch_yellow+"</td>");
    out.println("<td bgcolor="+bg+">"+arch_disabled+"</td>");
    out.println("<td bgcolor="+bg+">"+arch_missed+"</td>");
   }
   out.println("<td align='right' bgcolor="+bg+">"+(arch_disabled+arch_yellow+arch_green+arch_missed)+"</td></tr>");
   arch_green_total = arch_green_total + arch_green;
   arch_yellow_total = arch_yellow_total + arch_yellow;
   arch_disabled_total = arch_disabled_total + arch_disabled;
   arch_missed_total = arch_missed_total + arch_missed;
}
 total = arch_green_total + arch_yellow_total + arch_disabled_total + arch_missed_total;
 out.println("<tr>");
 out.println("<td bgcolor=Gainsboro>Total</td>");
 if(total > 0){
 out.println("<td bgcolor=SeaGreen>"+arch_green_total+" ("+String.format("%8.1f", (double) arch_green_total*100/total).trim()+"%)</td>");
 out.println("<td bgcolor=yellow>"+arch_yellow_total+" ("+String.format("%8.1f", (double) arch_yellow_total*100/total).trim()+"%)</td>");
 out.println("<td bgcolor=gray>"+arch_disabled_total+" ("+String.format("%8.1f", (double) arch_disabled_total*100/total).trim()+"%)</td>");
 out.println("<td bgcolor=red>"+arch_missed_total+" ("+String.format("%8.1f", (double) arch_missed_total*100/total).trim()+"%)</td>");
 } else {
 out.println("<td bgcolor=yellow>"+arch_green_total+"</td>");     
 out.println("<td bgcolor=yellow>"+arch_yellow_total+"</td>");
 out.println("<td bgcolor=gray>"+arch_disabled_total+"</td>");
 out.println("<td bgcolor=red>"+arch_missed_total+"</td>");
 }
 out.println("<td align='right' bgcolor=Gainsboro>"+total+"</td></tr>");
} catch(Exception e) {out.println(e);}
if(con != null) con.close();
%>
</table>
</body>
</html>