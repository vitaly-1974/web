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
           <th bgcolor=Gainsboro>arch</th>
           <th bgcolor=SeaGreen>ENABLED (%)</th>    
           <th bgcolor=yellow>ENABLED (%)</th>    
           <th bgcolor=gray>DISABLED (%)</th>
           <th bgcolor=Gainsboro>Total</th>    
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
 String name= request.getParameter("name");
 if(name.equals("all")) name ="";
 ResultSet rs;
 String[] select = new String[]{
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%86%') GROUP BY state;",
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%armv7%') and (cpu_feature like '%hf%') GROUP BY state;",
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%armv7%') and (cpu_feature like '%vfp%') GROUP BY state;",
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%armv5%') GROUP BY state;",
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%armv6%') GROUP BY state;",
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%aarch64%') GROUP BY state;",
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%ppc%') and (cpu_feature like '%vfp%') GROUP BY state;",
      "select cpu_feature,cpu_name,state,COUNT(*) from hosts where location like '%"+name+"%' and (cpu_name like '%ppc%') and (cpu_feature like '%v2%') GROUP BY state;"};
 String[] arch = new String[]{"linux-i586","armhf","armvfp","armsflt","armv6","aarch64","ppc","ppcv2"};
 int count;
 int arch_green = 0, arch_yellow = 0, arch_disabled = 0;
 int arch_green_total = 0, arch_yellow_total = 0, arch_disabled_total = 0, total = 0;
 String state,feature,bg;
 
 for(int i = 0; i < 8; i++) {
   count = 0; 
   arch_green = 0;
   arch_yellow = 0;
   arch_disabled = 0;
   if(i % 2 == 0) bg = "white"; else bg = "LightYellow";

   statement = con.createStatement();
   rs = statement.executeQuery(select[i]);
   while(rs.next()){
        state=rs.getString(3);
        feature=rs.getString(1);
        count=rs.getInt(4);
        if(state.equals("ENABLED")){
            arch_green = count;
        } else 
        if(state.equals("DISABLED")){    
            arch_disabled = count;
        } else
            arch_yellow = count;
   }    
   statement.close();
   out.println("<tr>");
   out.println("<td bgcolor="+bg+">"+arch[i]+"</td>");
   if(arch_disabled+arch_yellow+arch_green > 0){
    out.println("<td bgcolor="+bg+">"+arch_green+" ("+String.format("%8.1f", (double) arch_green*100/(arch_disabled+arch_yellow+arch_green)).trim()+"%)</td>");
     out.println("<td bgcolor="+bg+">"+arch_yellow+" ("+String.format("%8.1f", (double) arch_yellow*100/(arch_disabled+arch_yellow+arch_green)).trim()+"%)</td>");
     out.println("<td bgcolor="+bg+">"+arch_disabled+" ("+String.format("%8.1f", (double) arch_disabled*100/(arch_disabled+arch_yellow+arch_green)).trim()+"%)</td>");
   } else {
    out.println("<td bgcolor="+bg+">"+arch_green+"</td>");
    out.println("<td bgcolor="+bg+">"+arch_yellow+"</td>");
    out.println("<td bgcolor="+bg+">"+arch_disabled+"</td>");
   }
   out.println("<td align='right' bgcolor="+bg+">"+(arch_disabled+arch_yellow+arch_green)+"</td></tr>");
   arch_green_total = arch_green_total + arch_green;
   arch_yellow_total = arch_yellow_total + arch_yellow;
   arch_disabled_total = arch_disabled_total + arch_disabled;
}
 total = arch_green_total + arch_yellow_total + arch_disabled_total;
 out.println("<tr>");
 out.println("<td bgcolor=Gainsboro>Total</td>");
 if(total > 0){
 out.println("<td bgcolor=SeaGreen>"+arch_green_total+" ("+String.format("%8.1f", (double) arch_green_total*100/total).trim()+"%)</td>");
 out.println("<td bgcolor=yellow>"+arch_yellow_total+" ("+String.format("%8.1f", (double) arch_yellow_total*100/total).trim()+"%)</td>");
 out.println("<td bgcolor=gray>"+arch_disabled_total+" ("+String.format("%8.1f", (double) arch_disabled_total*100/total).trim()+"%)</td>");
 } else {
 out.println("<td bgcolor=yellow>"+arch_green_total+"</td>");     
 out.println("<td bgcolor=yellow>"+arch_yellow_total+"</td>");
 out.println("<td bgcolor=gray>"+arch_disabled_total+"</td>");
 }
 out.println("<td align='right' bgcolor=Gainsboro>"+total+"</td></tr>");
} catch(Exception e) {out.println(e);}
if(con != null) con.close();
%>
</table>
</body>
</html>