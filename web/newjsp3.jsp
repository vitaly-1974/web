<%@page import="java.sql.PreparedStatement"%>
<%@page import="org.openqa.selenium.support.ui.WebDriverWait"%>
<%@page import="org.openqa.selenium.support.ui.ExpectedConditions"%>
<%@page import="org.openqa.selenium.WebElement"%>
<%@page import="org.openqa.selenium.By"%>
<%@page import="org.openqa.selenium.firefox.FirefoxDriver"%>
<%@page import="org.openqa.selenium.Proxy.ProxyType"%>
<%@page import="org.openqa.selenium.firefox.FirefoxProfile"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script type="text/javascript"><!--
function ReplaceContentInContainer(id,content) {
var container = document.getElementById(id);
container.innerHTML = content;
}
</script>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <p id="demo"></p>
  
        <div id="example1div" 
          style="border-style:solid; 
           padding:10px; 
           text-align:center;">
I will be replaced when you click.
</div>
<a href="javascript:ReplaceContentInContainer('example1div','Whew! You clicked!')">
Click me to replace the content in the container.
</a>


<%
    //<a name="projectname" id="mySelect" onchange="myFunction()">
response.setIntHeader("Refresh", 5);
Class.forName("com.mysql.jdbc.Driver");
//out.flush();
out.println("started<br>");
final String ldap_user = request.getParameter("user");
final String ldap_password = request.getParameter("pwd");
out.println(ldap_user);
Connection con,con1;
String url = "jdbc:mysql://localhost:3306/mysql", uid = "root", psw = "atari";
con = DriverManager.getConnection(url, uid, psw);
Statement stm  = null;
ResultSet rs = stm.executeQuery("select name from devops where reboot like '%Y%'");
while(rs.next()){
  out.println("<a>"+ rs.getString(1)+"</a>");
  Thread.sleep(100);
} 
rs.close();
stm.close();
con.close();

  
%>
    </body>
</html>
