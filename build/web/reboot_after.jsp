<%@page import="hosting.Hosting"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.File"%>
<%@page import="org.openqa.selenium.support.ui.WebDriverWait"%>
<%@page import="org.openqa.selenium.support.ui.ExpectedConditions"%>
<%@page import="org.openqa.selenium.WebElement"%>
<%@page import="org.openqa.selenium.By"%>
<%@page import="org.openqa.selenium.firefox.FirefoxDriver"%>
<%@page import="org.openqa.selenium.Proxy.ProxyType"%>
<%@page import="org.openqa.selenium.firefox.FirefoxProfile"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" 
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" 
import="java.sql.DriverManager,java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.sql.SQLException"
%>

<%
File file = new File("/tmp/devops4").getAbsoluteFile(); 
final PrintWriter outf = new PrintWriter(file);
final String ldap_user = request.getParameter("user");
final String ldap_password = request.getParameter("pwd");
final java.io.Writer outd = null;
final PrintWriter out1 = response.getWriter();
Class.forName("com.mysql.jdbc.Driver");
Connection con,con1;
String url = "jdbc:mysql://localhost:3306/mysql", uid = "root", psw = "atari";
con = DriverManager.getConnection(url, uid, psw);
Statement stm;
stm = con.createStatement();
int i = 0;
String h = "";
ResultSet rs;    

System.setProperty("webdriver.firefox.marionette","/export/geckodriver");
FirefoxProfile ff = new FirefoxProfile();
ff.setPreference("network.proxy.type", ProxyType.AUTODETECT.ordinal());
ff.setPreference("browser.startup.homepage", "about:blank");
ff.setPreference("startup.homepage_welcome_url", "about:blank");
ff.setPreference("startup.homepage_welcome_url.additional", "about:blank");
FirefoxDriver driver = new FirefoxDriver(ff);
driver.get("http://devops.oraclecorp.com/host/vmsqe/detail/");
WebElement myDynamicElement = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.id("sso_username")));
WebElement element;
element = driver.findElement(By.id("sso_username"));
element.sendKeys(ldap_user);
element = driver.findElement(By.id("ssopassword"));
element.sendKeys(ldap_password);
element = driver.findElement(By.className("submit_btn"));
element.submit();
//outf.println("Reboot next hosts:<br>");
String sele = "SELECT * FROM vmsqe_hosts where state=\"YELLOW\" and requested like '%" + ldap_user.substring(0,ldap_user.indexOf("@")) + "%'";
rs = stm.executeQuery(sele);
PreparedStatement pstm = null;
//String redirectURL = "http://localhost:8080/web1/faces/reboot_after.jsp";
//response.sendRedirect(redirectURL);
//response.setIntHeader("Refresh", 5);
while(rs.next()){
          i++;
          if(i > 3) break;
          h = rs.getString(1).substring(0, rs.getString(1).indexOf("."));
          out.print(i+"."+h+"<br>");
          driver.get("http://devops.oraclecorp.com/host/"+h+"/detail/");
          element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//a[contains(@href,'/host/"+h+"/actions/')]")));
          element.findElement(By.xpath("//a[contains(@href,'/host/"+h+"/actions/')]"));
          element.click();
          try {
          element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//a[contains(@href,'/host/"+h+"/reboot/modal/')]")));
          element.findElement(By.xpath("//a[contains(@href,'/host/"+h+"/reboot/modal/')]"));
          element.click();
          } catch (Exception e) {}
          element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//a[contains(text(),'Close')]")));
          element.findElement(By.xpath("//a[contains(text(),'Close')]"));
          element.click();
          //outf.print(" -> rebooted<br>");
          //con1 = DriverManager.getConnection(url, uid, psw);
               pstm = con.prepareStatement("update devops set reboot=? where name=?");
               pstm.setString(1,"Y");
               pstm.setString(2,h);
               pstm.executeUpdate();
               pstm.close();
               out.print(h+"<br>");
               try {
                 //outd.flush();
                 outf.write(h+"\n");
                 out.write(h+"\n");
               } catch (Exception e) {
                   
               } 
          //con1.close();
          //rs = stm.executeQuery("select name from devops where reboot like '%Y%'");
          rs.last();
          out.println(rs.getString(1));
       }
       //outf.close();
       rs.close();
       stm.close();
       //con.close();
       //driver.close();

    //Statement stm;
    //Connection con;
    con = DriverManager.getConnection(url, uid, psw);
    stm = con.createStatement();
    rs = null;
    String old = "";
    rs = stm.executeQuery("select name from devops where reboot like '%Y%'");
    rs.last();
    //if(!old.contains(rs.getString(1))) {
        out.println(rs.getString(1));
    //    old = rs.getString(1);
    //} 
    rs.close();
    stm.close();
    con.close();
%>
</body>
</html>