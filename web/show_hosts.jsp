<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>
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
<%@page import="hosting.Host"%>
<%@page import="hosting.selenium"%>
<style>
.div {
    width: 700px;
    padding: 1;
    margin: 1;
    border: thin solid black;
    background :#F5F5F5;
}
a:hover {
    background: #786b59; 
    color: #ffe;
}
input:hover {
    background-color: gray;
    font-color: #ffe; 
    color: #ffe; 
} 
</style>
<html>
<head><title>Hosting</title></head>
<% 
String url = "jdbc:mysql://localhost:3306/mysql";
String uid = "root";
String psw = "atari";
Connection con = null;
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection(url, uid, psw);
 
Statement statement = null;
statement = con.createStatement();
String s = "select max(date) from hosts";
ResultSet rs;
rs= statement.executeQuery(s);
if(rs.next()){
  out.print("<h6> Last update: "+rs.getDate(1).toString());
} 
//statement.close();
//rs.close();
out.println(" ("+request.getRequestURL()+"?"+request.getQueryString()+")</h6>");
%>
<body>
<form name="form1" onsubmit="checkBoxValidation()">
<div class="div">
<a2 style="font-weight:bold">Issue:</a2>
<%
String filters[]= request.getParameterValues("filter1");
String filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter1\" value=\"ping='-'\""+ (filter1.contains("ping") ? " checked" : "") +"/>no ping</a>");
out.println("<a><input type=\"checkbox\" name=\"filter1\" value=\"ssh='-'\""+ (filter1.contains("ssh") ? " checked" : "") +"/>no ssh</a>");
out.println("<a><input type=\"checkbox\" name=\"filter1\" value=\"swap='0'\""+ (filter1.contains("swap") ? " checked" : "") +"/>no swap</a>");
out.println("<a><input type=\"checkbox\" name=\"filter1\" value=\"failed_jobs>0\""+ (filter1.contains("jobs") ? " checked" : "") +"/>failed jobs</a>");
java.util.Date date = new java.util.Date();
java.sql.Date sqlDate = new java.sql.Date(date.getTime());
%>
<a><input type="checkbox" name="filter1" value="date='<%=sqlDate%>'"
<%
out.println((filter1.contains("date") ? " checked" : "") +"/>Last updated</a>");
%>
</div>
<div class="div">
<a2 style="font-weight:bold">Arch:</a2>
<%
filters = request.getParameterValues("filter2");
filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%86%')\""+ (filter1.contains("86") ? " checked" : "") +"/>i586</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%armv7%') and (cpu_feature like '%hf%')\""+ (filter1.contains("hf") ? " checked" : "") +"/>armhf</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%armv7%') and (cpu_feature like '%vfp%')\""+ (filter1.contains("armv7")&&filter1.contains("vfp") ? " checked" : "") +"/>armvfp</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%armv5%')\""+ (filter1.contains("armv5") ? " checked" : "") +"/>armsflt</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%armv6%')\""+ (filter1.contains("armv6") ? " checked" : "") +"/>armv6</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%aarch64%')\""+ (filter1.contains("aarch64") ? " checked" : "") +"/>aarch64</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%ppc%') and (cpu_feature like '%vfp%')\""+ (filter1.contains("ppc")&&filter1.contains("vfp") ? " checked" : "") +"/>ppc</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"(cpu_name like '%ppc%') and (cpu_feature like '%v2%')\""+ (filter1.contains("ppc")&&filter1.contains("v2") ? " checked" : "") +"/>ppcv2</a>");
%>
</div>
<div class="div">
<a2 style="font-weight:bold">Location:</a2>
<%
filters = request.getParameterValues("filter3");
filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"location='santaclara'\""+ (filter1.contains("santaclara") ? " checked" : "") +"/>santaclara</a>");
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"location='burlington'\""+ (filter1.contains("burlington") ? " checked" : "") +"/>burlington</a>");
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"location='stpetersburg'\""+ (filter1.contains("stpetersburg") ? " checked" : "") +"/>stpetersburg</a>");
%>
</div>
<div class="div">
<a2 style="font-weight:bold">State in Aurora:</a2>
<%
filters = request.getParameterValues("filter4");
filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter4\" value=\"state='ENABLED'\""+ (filter1.contains("ENABLED") ? " checked" : "") +"/>green</a>");
out.println("<a><input type=\"checkbox\" name=\"filter4\" value=\"state=''\""+ (filter1.contains("''") ? " checked" : "") +"/>yellow</a>");
out.println("<a><input type=\"checkbox\" name=\"filter4\" value=\"state='DISABLED'\""+ (filter1.contains("DISABLED") ? " checked" : "") +"/>disabled</a>");
%>
</div>
<br><a1><input class="input" type="submit" value="Filter"/></a1>
    <table border="1" cellpadding="1" cellspacing="0">
        <tr bgcolor=LightGray>
           <th>N</th>
           <th colspan="1">Host</th>    
           <th>ping</th>    
           <th>ssh</th>
           <th>Status</th>    
           <th>swap (G)</th>  
           <th>mem (G)</th>  
           <th>cpu</th>    
           <th>arch</th>    
           <th>Failed jobs</th>    
           <th>Updated</th>
           <th>Check</th>
        </tr>
<% 
/*
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection(url, uid, psw);
*/
statement = con.createStatement();
Long curTime = System.currentTimeMillis(); 
Date curDate = new Date(curTime);
String name = request.getParameter("name");
String filter = "";
for(int i=1; i<=4; i++){
 String get_filter[]= request.getParameterValues("filter"+i);
 if(get_filter != null) {
 for(int j=0; j < get_filter.length; j++){
    filter = filter + ((j == 0) ? " and (" : " or ") + get_filter[j] + ((j == get_filter.length-1) ? " )" : "");
 }
}
}
String filtr = filter;
filtr = filtr.replace ("and", "");
filtr = filtr.replace("(cpu_name like '%86%')","linux-i586");
filtr = filtr.replace("(cpu_name like '%armv7%')","arm");
filtr = filtr.replace("  (cpu_feature like '%hf%')","-hf");
filtr = filtr.replace("(cpu_name like '%armv5%')","arm-sflt");
filtr = filtr.replace("(cpu_name like '%armv6%')","arm-v6");
filtr = filtr.replace("(cpu_name like '%aarch64%')","aarch64");
filtr = filtr.replace("(cpu_name like '%ppc%')  (cpu_feature like '%v2%')","ppcv2");
filtr = filtr.replace("(cpu_name like '%ppc%')  (cpu_feature like '%vfp%')","ppc");
filtr = filtr.replace("  (cpu_feature like '%vfp%')","-vfp");
filtr = filtr.replace("and (true )","");
filtr = filtr.replace("true or","");
filtr = filtr.replace("(true ) ","");
filtr = filtr.replace("(true)","");
filtr = filtr.replace("(true )","");
filtr = filtr.replace(") (",") and (");
filtr = filtr.replace(")  (",") and (");
filtr = filtr.replace(")(",") and (");
filtr = filtr.replace("state=''","state=yellow");
filtr = filtr.replace("state='ENABLED'","state=green");
filtr = filtr.replace("state='DISABLED'","state=disabled");
filtr = filtr.replace("ping='-' ","(no ping) ");
filtr = filtr.replace("ssh='-' ","(no ssh) ");
if(filtr.length() == 0) filtr = "All";
out.println("Filter:"+filtr+"<br>");

// Refresh selected hosts
String checks[]= request.getParameterValues("check");
if(checks != null){
out.println("<br>Updated:<br>");    
for(int i=0; i < checks.length; i++){
   out.println( (i+1)+". "+checks[i]);
   Host host = new Host();
   String pping,pssh,pstate,pswap="-",pname;
   pname = checks[i];
   if(host.ping(pname)) pping = "+";
   else pping = "-";
   if(pping.equals("+") && host.ssh_connect(pname)) pssh = "+";
   else pssh = "-";
   
   selenium get_hosts = new selenium();
   String host_page;
   host_page =  get_hosts.GetHost_silent(pname);
   String look;
   pswap = host.get_attribute("swap.total:",host_page);
   if(host_page.contains("class=\"enabled-free\"") || host_page.contains("class=\"enabled-working\"")) pstate = "ENABLED";
   else if(host_page.contains("class=\"disabled-free\"")) pstate = "DISABLED";
   else pstate = "";

   curTime = System.currentTimeMillis(); 
   java.sql.Date pcurDate = new java.sql.Date(curTime);
   java.util.Date time = java.util.Calendar.getInstance ().getTime();
   Timestamp timestamp = new Timestamp(curDate.getTime());
   if(pswap.equals('-')){
     out.println("> Couldn't calculate swap, check aurora status");
     break;
   } 
   out.println("> ping:"+pping+" ssh:"+pssh+">"+pstate+"> Swap:"+
   String.format("%8.1f", Double.parseDouble(pswap)/(1024*1024*1024) ) + "> Date:"+pcurDate.toString()+"<br>");
   PreparedStatement pstm = null;
   con = null;
   url = "jdbc:mysql://localhost:3306/mysql";
   String user = "root";
   String password = "atari";
   try {
       con = DriverManager.getConnection(url, user, password);
       pstm = con.prepareStatement("update hosts set ping=?,date=?,time=?,ssh=?,state=?,swap=? where name=?");
       if(!pswap.equals('-')){
        pstm.setString(1,pping);
        pstm.setDate(2,pcurDate);
        pstm.setTimestamp(3, timestamp);
        pstm.setString(4,pssh);
        pstm.setString(5,pstate);
        pstm.setString(6,pswap);
        pstm.setString(7,pname);
        pstm.executeUpdate();
       }
   } catch (SQLException ex) {
         ex.printStackTrace();      
   } 
   finally{
               try {
                    if(con != null) con.close();
                    if(pstm != null) pstm.close();
               } catch (SQLException e) {
                    System.out.println("On close: " + e.toString());
               }
    }
}
}
%>
<br><p><input type="submit" value="Refresh selected hosts"/></p>
<% 
s = "select name,ping,ssh,state,swap,mem_total,cpu_name,cpu_feature,failed_jobs,date,changed from hosts where true "+filter+" order by state,ping,ssh";
rs = statement.executeQuery(s);
int i = 1;
String bgcolor = "", sts = "", swap = "" , mem = "";
  while(rs.next()){
        out.println("<tr>");
        out.println("<td>"); out.println(i); out.println("</td>");
        //host
        out.println("<td align=\"left\">"); out.println("<a href=\"http://aurora.ru.oracle.com/faces/Host.xhtml?host="+rs.getString(1).trim()+"\">"+rs.getString(1).trim()+"</a></td>");
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
        swap = rs.getString(5);
        try { Double.parseDouble(swap);} 
        catch (NumberFormatException e) {swap = "0";}
        mem = rs.getString(6);
        try { Double.parseDouble(mem);} 
        catch (NumberFormatException e) {mem = "0";}
        bgcolor="style=\"background-color:white\"";    
        if(Double.parseDouble(swap)/(1024*1024*1024) < Double.parseDouble(mem)/(1024*1024*1024)) {
            bgcolor="style=\"background-color:red\"";    
        }
        out.println("<td align=\"left\""+bgcolor+">"); out.println(String.format("%8.1f", Double.parseDouble(swap)/(1024*1024*1024) )); out.println("</td>");
        out.println("<td align=\"left\""+bgcolor+">"); out.println(String.format("%8.1f", Double.parseDouble(mem)/(1024*1024*1024) )); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getString(7).trim()); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getString(8).trim()); out.println("</td>");
        out.println("<td align=\"left\">"); out.println(rs.getString(9).trim()); out.println("</td>");
        out.println("<td align=\"left\">"); out.print(rs.getDate(10)); 
        if(filter.contains("date") && (rs.getString(11) != null) && (rs.getString(11).length()>0)){
           out.println(rs.getString(11).trim());           
        } else out.println("");
        out.println("</td><td><a><input type=\"checkbox\" name=\"check\" value="+ rs.getString(1) +"></a></td></tr>");
        i++;
  }
%>
</table>
</form>
</body>
</html>