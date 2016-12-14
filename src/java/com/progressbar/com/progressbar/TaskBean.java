package com.progressbar;

import com.progressbar.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.io.Writer;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.Proxy.ProxyType;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxProfile;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class TaskBean implements Runnable, Serializable {
    private int counter, sum , rebooted = 0, not_rebooted = 0;
    private boolean started, running;
    private String hostname; 
    static String report = "", detailed_report = "";
    static String ldap_user = "";
    static String ldap_password = "";
    static int tb_count = 0;
    
    PreparedStatement pstm = null;
    Statement stm  = null;
    ResultSet rs = null;
    //final static String host = "sette0.ru.oracle.com";
    final static String host = "localhost";
    final static String url = "jdbc:mysql://"+host+":3306/mysql";
    final static String user = "root";
    final static String password = "atari";
    static Connection con;
    
    public TaskBean() {
        hostname = "";
        counter = 0;
        sum = 0;
        rebooted = 0;
        not_rebooted = 0;
        started = false;
        running = false;
    }

    protected void work() throws InterruptedException {
        System.setProperty("webdriver.firefox.marionette", "/export/geckodriver");
        FirefoxProfile ff = new FirefoxProfile();
        FirefoxDriver driver = new FirefoxDriver(ff);
        WebElement element;
        try {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(TaskBean.class.getName()).log(Level.SEVERE, null, ex);
            }
            con = DriverManager.getConnection(url, user, password);
            stm = con.createStatement();
            ResultSet rs = null;
            //String sele = "SELECT * FROM vmsqe_hosts where state like '%YELLOW%' and requested like '%" + ldap_user.substring(0,ldap_user.indexOf("@")) + "%'";
            String sele = "SELECT name FROM vmsqe_hosts where state like '%YELLOW%' and requested like '%vitaly%'";
            rs = stm.executeQuery(sele);
            rs.last();
            sum = rs.getRow();
            rs.beforeFirst();

            if(counter == 0) {
              System.setProperty("webdriver.firefox.marionette","/export/geckodriver");
              ff.setPreference("network.proxy.type", ProxyType.AUTODETECT.ordinal());
              ff.setPreference("browser.startup.homepage", "about:blank");
              ff.setPreference("startup.homepage_welcome_url", "about:blank");
              ff.setPreference("startup.homepage_welcome_url.additional", "about:blank");
              driver.get("http://devops.oraclecorp.com/host/vmsqe/detail/");
              WebElement myDynamicElement = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.id("sso_username")));
              element = driver.findElement(By.id("sso_username"));
              element.sendKeys(ldap_user);
              element = driver.findElement(By.id("ssopassword"));
              element.sendKeys(ldap_password);
              element = driver.findElement(By.className("submit_btn"));
              element.submit();
            }
            String name = "";
            while(rs.next() && isRunning() && !isCompleted()){
               name = rs.getString(1).substring(0, rs.getString(1).indexOf("."));
               counter++;
               try {
                 driver.get("http://devops.oraclecorp.com/host/" + name + "/detail/");
                 element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//a[contains(@href,'/host/"+name+"/actions/')]")));
                 element.findElement(By.xpath("//a[contains(@href,'/host/" + name + "/actions/')]"));
                 element.click();
                 element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//a[contains(@href,'/host/"+name+"/reboot/modal/')]")));
                 element.findElement(By.xpath("//a[contains(@href,'/host/" + name + "/reboot/modal/')]"));
                 element.click();
                 element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//a[contains(text(),'Reboot')]")));
                 element.findElement(By.xpath("//a[contains(text(),'Reboot')]"));
                 element.click();
                 hostname = counter + "." + name + " -> rebooted";
                 rebooted++;
               } catch (Exception e) {
                 hostname = counter + "." + name + " -> not rebooted";
                 not_rebooted++;
               }
               report = report + hostname + "<BR>";
            }
            //setRunning(false);
           } catch (SQLException ex) {
            hostname = hostname + "> error";
            Logger.getLogger(TaskBean.class.getName()).log(Level.SEVERE, null, ex);
           } finally {
            if(driver != null) driver.close();
           }
    }
    
    protected void work_uno() throws InterruptedException {
        System.setProperty("webdriver.firefox.marionette", "/export/geckodriver");
        FirefoxProfile ff = new FirefoxProfile();
        /*
        ff.setPreference("network.proxy.type", ProxyType.AUTODETECT.ordinal());
        ff.setPreference("browser.startup.homepage", "about:blank");
        ff.setPreference("startup.homepage_welcome_url", "about:blank");
        ff.setPreference("startup.homepage_welcome_url.additional", "about:blank");
        */
        FirefoxDriver driver = new FirefoxDriver(ff);
        WebElement element;
        try {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(TaskBean.class.getName()).log(Level.SEVERE, null, ex);
            }
            con = DriverManager.getConnection(url, user, password);
            stm = con.createStatement();
            ResultSet rs = null;
            //String sele = "SELECT * FROM vmsqe_hosts where state like '%YELLOW%' and requested like '%" + getUser().substring(0,getUser().indexOf("@")) + "%'";
            String sele = "SELECT name FROM vmsqe_hosts where state like '%YELLOW%' and requested like '%vitaly%'";
            rs = stm.executeQuery(sele);
            rs.last();
            sum = rs.getRow();
            rs.beforeFirst();

            if(counter == 0) {
               System.setProperty("webdriver.firefox.marionette", "/export/geckodriver");
               driver.get("https://uno.oraclecorp.com/uno/hostdevices");
               WebElement myDynamicElement = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.id("sso_username")));
               element = driver.findElement(By.id("sso_username"));
               element.sendKeys(getUser());
               element = driver.findElement(By.id("ssopassword"));
               element.sendKeys(getPass());
               element = driver.findElement(By.className("submit_btn"));
               element.submit();
               myDynamicElement = (new WebDriverWait(driver, 50)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//button[contains(text(),'Actions')]")));
            }
            String name = "", host = "";
            while(rs.next() && isRunning() && !isCompleted()){
               host = rs.getString(1);
               name = rs.getString(1).substring(0, rs.getString(1).indexOf("."));
               counter++;
               element = (new WebDriverWait(driver, 30)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//*[contains(@id, 'hostQuickSearchId')]")));
               element = driver.findElement(By.xpath("//*[contains(@id, 'hostQuickSearchId')]"));
               element.sendKeys(host.substring(0, host.indexOf(".")));
               element.sendKeys(Keys.TAB);
               element.sendKeys(Keys.ENTER);
               try {
                element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//a[text()='" + host.substring(0, host.indexOf(".")) + "']")));
                element = driver.findElement(By.xpath("//a[text()='" + host.substring(0, host.indexOf(".")) + "']"));
                //p(i + "." + element.getText());
                element = (new WebDriverWait(driver, 20)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//button[text()='Actions']")));
                element = driver.findElement(By.xpath("//button[text()='Actions']"));
                element.click();
                element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//*[contains(@data-bind, 'actionsReboot')]")));
                element = driver.findElement(By.xpath("//*[contains(@data-bind, 'actionsReboot')]"));
                //p("pressing " + element.getText());
                element.click();
                Thread.sleep(1000);
                element = (new WebDriverWait(driver, 10)).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//*[contains(@data-bind, 'click:confirm_close')]")));
                element = driver.findElement(By.xpath("//*[contains(@data-bind, 'click:confirm_close')]"));
                //p("pressing " + element.getText());
                element.click();
                Thread.sleep(1000);
                hostname = counter + "." + name + " -> rebooted";
                rebooted++;
               } catch (Exception e) {
                hostname = counter + "." + name + " -> not rebooted";
                not_rebooted++;
               }
               detailed_report = detailed_report + hostname + "<BR>";
               report = "Report><BR>" + "Rebooted:" + rebooted + "<BR>Not rebooted:" + not_rebooted + "<BR>Detailed:<BR>" + detailed_report;
               driver.get("https://uno.oraclecorp.com/uno/hostdevices");
            }
            //setRunning(false);
           } catch (SQLException ex) {
            hostname = hostname + "> error";
            Logger.getLogger(TaskBean.class.getName()).log(Level.SEVERE, null, ex);
           } finally {
            if(driver != null) driver.close();
           }
    }

    public synchronized int getPercent() {
        if(sum == 0) return 0;
        else
        return counter*100/sum;
    }
    
    public synchronized boolean isStarted() {
        return started;
    }

    public synchronized boolean isCompleted() {
        return counter != 0 && counter == sum;
    }

    public synchronized boolean isRunning() {
        return running;
    }

    public synchronized void setRunning(boolean running) {
        this.running = running;
        if (running)
            started = true;
    }
    
    public synchronized void setReport() {
        report = "";
    }

    public static synchronized void setLDAP(String user, String password) {
        if(tb_count == 0) {
          ldap_user = user;
          ldap_password = password;
          tb_count++;
          report = "";
        }
    }    

    public static synchronized String getUser() {
       return ldap_user;
    }
    
    public synchronized String getReport() {
       return report;
    }
    
    public static synchronized String getPass() {
       return ldap_password;
    }
    
    public synchronized Object getResult() {
        if (isCompleted())
            return new Integer(sum);
        else
            return sum;
    }
    
    public synchronized Object getHostname() {
            return hostname;
    }

    public void run() {
        setRunning(true);
        while (isRunning() && !isCompleted())
         try {
            work_uno();
         } catch (InterruptedException ex) {
            Logger.getLogger(TaskBean.class.getName()).log(Level.SEVERE, null, ex);
         }
        setRunning(false);
        //report = "Report><BR>" + "Rebooted:" + rebooted + "<BR>Not rebooted:" + not_rebooted + "<BR>Detailed:<BR>" + report;
    }

}