<%@page import="hosting.Host.MyRunnable_vmsqe"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="org.openqa.selenium.htmlunit.HtmlUnitDriver"%>
<%@page import="java.util.concurrent.ExecutorService"%>
<%@page import="java.util.concurrent.Executors"%>
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
<%@page import="hosting.Host.MyRunnable_vmsqe"%>
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
  <head>
        <title>Hosts Monitoring</title>
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0">
    </head>
<% 
String checks[]= request.getParameterValues("check");
String pcomment;
Connection con = null;
String url = "jdbc:mysql://localhost:3306/mysql";
String uid = "root";
String psw = "atari";

    class Runnable_vmsqe implements Runnable {
      private final String host,pcomment;
      int disable = 0;
      private final HtmlUnitDriver driver;
      private final int i;
      
      Runnable_vmsqe(String host,HtmlUnitDriver driver,int i,String pcomment) {
	 this.host = host;
         this.driver = driver;
         this.i = i;
         this.pcomment = pcomment;
      }
      @Override
      public void run() {
       Connection con = null;
       selenium get_hosts = new selenium();
       String host_page = "";
       try {
         host_page =  get_hosts.GetHost_silent(host);
       } catch (Exception ex)  {}
       Host hosts = new Host();
       String pping = "";
       try {
         if(hosts.ping(host)) pping = "+";
         else pping = "-";
       } catch (Exception ex) {}  
   
       String pstate = "YELLOW";
       if(host_page.contains("class=\"enabled-free\"") || host_page.contains("class=\"enabled-working\"") || host_page.contains("class=\"enabled-free-reserved\"")) {
         pstate = "ENABLED";
       } else 
       if(host_page.contains("class=\"disabled-free\"")) { 
         pstate = "DISABLED";
       } else   
       if(host_page.contains("Cannot find VHost with name")) {
         pstate = "MISSED";
       }   
       try {
         out.println("> ping:"+pping+">"+pstate+">"+pcomment+"<br>");
       } catch (Exception ex) {}
       PreparedStatement pstm = null;
       con = null;
       String url = "jdbc:mysql://localhost:3306/mysql";
       String user = "root";
       String password = "atari";
       try {
       con = DriverManager.getConnection(url, user, password);
       pstm = con.prepareStatement("update vmsqe_hosts set ping=?,state=?,comment=? where name=?");
       pstm.setString(1,pping);
       pstm.setString(2,pstate);
       pstm.setString(3,pcomment);
       pstm.setString(4,host);
       pstm.executeUpdate();
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
    
//Connection con = null;
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection(url, uid, psw);
Statement statement = null;
String s = "";
ResultSet rs;
FileReader fin = new FileReader("/tmp/last_update");
int c;
out.print("<h6>update: ");
while ((c = fin.read()) != -1) out.print((char) c);
out.print("</h6>");
%>
<body>
<form name="form1" method="post">    
   
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
out.print("<a><input type=\"checkbox\" name=\"filter1\" value=\"ping='-'\""+ (filter1.contains("ping") ? " checked" : "") +"/>no ping</a>");
%>
</div>


<div class="div">
<a2 style="font-weight:bold">State in Aurora:</a2>
<%
filters = request.getParameterValues("filter2");
filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"state='ENABLED'\""+ (filter1.contains("ENABLED") ? " checked" : "") +"/>green</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"state='YELLOW'\""+ (filter1.contains("YELLOW") ? " checked" : "") +"/>yellow</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"state='DISABLED'\""+ (filter1.contains("DISABLED") ? " checked" : "") +"/>disabled</a>");
out.println("<a><input type=\"checkbox\" name=\"filter2\" value=\"state='MISSED'\""+ (filter1.contains("MISSED") ? " checked" : "") +"/>missed</a>");
%>
</div>

<div class="div">
<a2 style="font-weight:bold">OS:</a2>
<%
filters = request.getParameterValues("filter3");
filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"os like '%Windows%'\""+ (filter1.contains("os like '%Windows") ? " checked" : "") +"/>Windows</a>");
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"(os like '%Solaris%' or os like '%SunOS%' or os like '%Oracle.1%')\""+ (filter1.contains("os like '%Solaris") ? " checked" : "") +"/>Solaris</a>");
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"(os like '%Linux%' or os like '%Ubuntu%' or os like '%openSUSE%')\""+ (filter1.contains("os like '%Linux") ? " checked" : "") +"/>Linux</a>");
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"(os like '%OS X%' or os like '%Mac%')\""+ (filter1.contains("os like '%Mac") ? " checked" : "") +"/>Mac</a>");
out.println("<a><input type=\"checkbox\" name=\"filter3\" value=\"not (trim(os) like '%Linux%' or trim(os) like '%Windows%' or trim(os) like '%Solaris%' or trim(os) like '%SunOS%' or trim(os) like '%Ubuntu%' or trim(os) like '%OS X%' or trim(os) like '%SUSE%' or trim(os) like '%Mac%' or trim(os) like '%Oracle.1%')\""+ (filter1.contains("not") ? " checked" : "") +"/>Undefined</a>");
%>
</div>

<div class="div">
<a2 style="font-weight:bold">Group:</a2>
<%
filters = request.getParameterValues("filter4");
filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter4\" value=\"groups='GTEE'\""+ (filter1.contains("GTEE") && (!filter1.contains("unstable")) ? " checked" : "") +"/>GTEE</a>");
out.println("<a><input type=\"checkbox\" name=\"filter4\" value=\"groups='GTEE.unstable'\""+ (filter1.contains("GTEE.unstable") ? " checked" : "") +"/>GTEE.unstable</a>");
%>
</div>

<div class="div">
<a2 style="font-weight:bold">Order by:</a2>
<%
filters = request.getParameterValues("filter5");
filter1 = "";
if(filters != null){
  for(int i=0; i<filters.length; i++) {
     filter1=filter1 + filters[i];
  }
}
out.println("<a><input type=\"checkbox\" name=\"filter5\" value=\"state\""+ (filter1.contains("state") ? " checked" : "") +"/>Status</a>");
out.println("<a><input type=\"checkbox\" name=\"filter5\" value=\"cores\""+ (filter1.contains("cores") ? " checked" : "") +"/>Cores</a>");
out.println("<a><input type=\"checkbox\" name=\"filter5\" value=\"requested\""+ (filter1.contains("requested") ? " checked" : "") +"/>Requested</a>");
%>
</div>

<br><a1><input class="input" type="submit" value="Refresh"/></a1>
    <table border="1" cellpadding="1" cellspacing="0">
        <tr bgcolor=LightGray>
           <th>N</th>
           <th colspan="1">Host</th>    
           <th>ping</th> 
           <th>Status</th>    
           <th>RAM(G)</th> 
           <th>Cores</th>
           <th>OS</th> 
           <th>Requested</th> 
           <th>Group</th> 
           <th>Comment</th> 
           <th>Refresh</th> 
        </tr>
<% 
statement = con.createStatement();
String filter = "";
for(int i=1; i <= 4; i++){
 String get_filter[]= request.getParameterValues("filter"+i);
 if(get_filter != null) {
   for(int j=0; j < get_filter.length; j++){
    filter = filter + ((j == 0) ? " and (" : " or ") + get_filter[j] + ((j == get_filter.length-1) ? " )" : "");
   }
 }
}
String get_filter[]= request.getParameterValues("filter5");
String order = " order by ";
if(get_filter != null) {
   for(int j=0; j < get_filter.length; j++){
     order = order + get_filter[j] + ((j == get_filter.length-1) ? "" : ",");
   }
} else order = "";  
String filtr = filter;
filtr = filtr.replace ("and", "");
filtr = filtr.replace("and (true )","");
filtr = filtr.replace("true or","");
filtr = filtr.replace("(true ) ","");
filtr = filtr.replace("(true)","");
filtr = filtr.replace("(true )","");
filtr = filtr.replace(") (",") and (");
filtr = filtr.replace(")  (",") and (");
filtr = filtr.replace(")(",") and (");
filtr = filtr.replace("state='YELLOW'","state=yellow");
filtr = filtr.replace("state='ENABLED'","state=green");
filtr = filtr.replace("state='DISABLED'","state=disabled");
filtr = filtr.replace("state='MISSED'","state=missed");
filtr = filtr.replace("ping='-' ","(no ping) ");
if(filtr.length() == 0) filtr = "All";
out.println("<br>");

// Refresh selected hosts
//String checks[]= request.getParameterValues("check");
if(checks != null){
out.println("<br>Updated:<br>");    
String hostname;
int MAX_THREADS = 5;
HtmlUnitDriver driver[] = new HtmlUnitDriver[checks.length];
ExecutorService executor = Executors.newFixedThreadPool(MAX_THREADS);
for(int i = 0;i < checks.length;i++){
   hostname = checks[i].substring(checks[i].indexOf(".")+1); 
   pcomment = request.getParameter("comments"+checks[i].substring(0,checks[i].indexOf(".")));
   Runnable worker = new Runnable_vmsqe(hostname,driver[i],i,pcomment);
   executor.execute(worker);
}
   executor.shutdown();
   while (!executor.isTerminated()) {}

}
%>
<br>
<% 
//out.println("<a>"+order+"</a>");
s = "select name,ping,os,state,mem_total,cores,comment,requested,groups from vmsqe_hosts where true "+filter +" "+order;
rs = statement.executeQuery(s);
int i = 1;
String bgcolor = "", sts = "", mem = "", comm ="" , host_aurora;
  while(rs.next()){
        out.println("<tr>");
        out.println("<td>"); 
        out.println(i); 
        out.println("</td>");
        //host
        out.println("<td align=\"left\">"); 
        host_aurora = rs.getString(1).contains("spbeg01") ? "spbeg1.ru.oracle.com" : rs.getString(1).trim();
        out.println("<a href=\"http://aurora.ru.oracle.com/faces/Host.xhtml?host="+host_aurora+"\">"+rs.getString(1).trim()+"</a></td>"); 
        //ping
        bgcolor=rs.getString(2).trim().equals("-") ? "style=\"background-color:red\"" : "style=\"background-color:SeaGreen\"";
        out.println("<td align=\"left\" "+bgcolor+"></td>");
        //status
        sts = rs.getString(4);
        if( (rs.getString(4).trim()).length() == 0 || rs.getString(4).trim().equals("YELLOW")) {
            bgcolor="style=\"background-color:yellow\"";
            sts = "ENABLED";
        } else 
        if( (rs.getString(4).trim()).equals("DISABLED")) {    
            bgcolor="style=\"background-color:gray\"";    
        } else 
        if( (rs.getString(4).trim()).equals("MISSED")) {    
            bgcolor="style=\"background-color:red\"";    
        } else    
            bgcolor="style=\"background-color:SeaGreen\"";    
        out.println("<td align=\"left\""+bgcolor+">"); out.println(sts); out.println("</td>");
        
        //mem
        try {
            Double.parseDouble(rs.getString(5));
            out.println("<td align=\"left\">"+String.format("%8.0f", Double.parseDouble(rs.getString(5))/(1024*1024*1024) )+"</td>");
        } catch (NumberFormatException ex) {
            out.println("<td align=\"left\">"+ rs.getString(5).replace("GiB", "") +"</td>");  
        }    
        //Cores
        try {
            rs.getInt(6);
            out.println("<td align=\"left\">"+rs.getInt(6)+"</td>");
        } catch (NumberFormatException ex) {
            out.println("<td align=\"left\"></td>");  
        }    
          
        //OS
        out.println("<td align=\"left\">"+rs.getString(3)+"</td>");
        out.println("");
        // Requested
        out.println("<td align=\"left\">");
        out.println("<a href=\"http://devops.oraclecorp.com/host/"+rs.getString(1).trim().substring(0, rs.getString(1).indexOf('.'))+"/detail/\">"+rs.getString(8)+"</a>");
        out.println("</td>");
        // Group
        out.println("<td align=\"left\">"+rs.getString(9)+"</td>");
        //Comment
        comm = rs.getString(7);
        if(rs.getString(7)==null) comm = "";
        //out.println("<td>" + comm + "</td>");
        out.println("<td><input type=\"text\" name=\"comments"+i+"\" value='" + comm + "' style=\"width:120px;\"></td>");
        out.println("<td><a><input type=\"checkbox\" name=\"check\" value=" + Integer.toString(i)+"."+rs.getString(1)+"></a></td></tr>");
        //out.println("<td><a><input type=\"checkbox\" name=\"check\" value=" + Integer.toString(i)+"."+rs.getString(1)+"></a></td></tr>");
        i++;
  }
  
%>
</table>
</form>
</body>
</html>