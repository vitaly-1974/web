<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.lang.String"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.awt.Color"%>

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
<head>
<%
double mgreen[] = new double[7];
double myellow[] = new double[7];
double mdis[] = new double[7];
double mred[] = new double[7];
String mday[] = new String[7];
String url = "jdbc:mysql://localhost:3306/mysql";
String uid = "root";
String psw = "atari";
Connection con = null;
try {
 Class.forName("com.mysql.jdbc.Driver");
 con = DriverManager.getConnection(url, uid, psw);
 Statement statement = con.createStatement();
 Statement statement1 = con.createStatement();
 String name= "";
 ResultSet rs,rs1;
 String select1,select2,state;
 int green = 0, yellow = 0, dis = 0, count = 7;
 int old_green = 0, old_yellow = 0, old_dis = 0, output_count = 0;
 
 Calendar currenttime = Calendar.getInstance();
 java.sql.Date date = new Date((currenttime.getTime()).getTime());
 Calendar calendar = Calendar.getInstance();

 java.sql.Date day_now = new java.sql.Date( new java.util.Date().getTime() );
 select1 = "select name,state from hosts";
 rs = statement.executeQuery(select1);
 //java.sql.Date day,old_day;
 for(int i=0;i < count;i++){
   java.util.Date today = new java.util.Date();
   Calendar cal = new GregorianCalendar();
   cal.setTime(today);
   cal.add(Calendar.DAY_OF_MONTH, -i);
   java.util.Date today1 = cal.getTime();
   //day = new java.sql.Date( day_now.getTime() - (86400000*i) );
   java.sql.Date sqlDate = new java.sql.Date(today1.getTime());
   green = 0;
   yellow = 0;
   dis = 0;
   while(rs.next()){
        name=rs.getString(1);
        state=rs.getString(2);
        select2="select state from changes where name='"+name+"' and date='"+sqlDate+"'";
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
    //green,yellow,dis,day;
       mgreen[output_count]=green;
       myellow[output_count]=yellow;
       mdis[output_count]=dis;
       mred[output_count]=(dis+yellow+green)/100*60;
       mday[output_count]=sqlDate.toString();
       
       //draw
       /*
       //out.println("<rect x=\""+(1+160*i)+"\" y=\"1\" width=\"143\" height=\"355\" style=\"fill:lightgray;stroke:black;stroke-width:1\" />");
       out.println("<rect x=\""+(5+160*output_count)+"\" y=\""+(350-green)+"\" width=\"40\" height=\""+green+"\" style=\"fill:green;stroke:black;stroke-width:1;opacity:0.5\" />");
       out.println("<rect x=\""+(50+160*output_count)+"\" y=\""+(350-yellow)+"\" width=\"40\" height=\""+yellow+"\" style=\"fill:yellow;stroke:black;stroke-width:1;opacity:0.5\" />");
       out.println("<rect x=\""+(95+160*output_count)+"\" y=\""+(350-dis)+"\" width=\"40\" height=\""+dis+"\" style=\"fill:gray;stroke:black;stroke-width:1;opacity:2.0\" />");
       out.println("<text x=\""+(7+160*output_count)+"\" y=\"340\" fill=\"black\">"+green+"</text>");
       out.println("<text x=\""+(53+160*output_count)+"\" y=\"340\" fill=\"black\">"+yellow+"</text>");
       out.println("<text x=\""+(98+160*output_count)+"\" y=\"340\" fill=\"black\">"+dis+"</text>");
       out.println("<text x=\""+(25+160*output_count)+"\"  y=\"373\" fill=\"black\">"+day+"</text>");
       */
       output_count++;
       old_green = green;
       old_yellow = yellow;
       old_dis = dis;
       //out.println("<text x=\""+50*i+"\"  y=\"60\" fill=\"black\">"+i+":"+count+"</text>");  
   } else count++;
 }
// out.println("<svg width=\"850\" height=\"450\">");
// out.println("</svg></html>");
 rs.close();
 statement.close();
 statement1.close();
} catch(Exception e) {out.println("err:");out.println(e);e.printStackTrace();}
if(con != null) con.close();        
%>        

<html>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
        ['date', 'Enabled', 'Yellow', 'Disabled','Red (60%)'],
         ['<%= mday[6].substring(mday[6].length()-5).replace('-','/')%>',  <%= mgreen[6]%>,     <%= myellow[6]%>,         <%= mdis[6]%>,<%= mred[6]%>],
         ['<%= mday[5].substring(mday[5].length()-5).replace('-','/')%>',  <%= mgreen[5]%>,     <%= myellow[5]%>,         <%= mdis[5]%>,<%= mred[5]%>],
         ['<%= mday[4].substring(mday[4].length()-5).replace('-','/')%>',  <%= mgreen[4]%>,     <%= myellow[4]%>,         <%= mdis[4]%>,<%= mred[4]%>],
         ['<%= mday[3].substring(mday[3].length()-5).replace('-','/')%>',  <%= mgreen[3]%>,     <%= myellow[3]%>,         <%= mdis[3]%>,<%= mred[3]%>],
         ['<%= mday[2].substring(mday[2].length()-5).replace('-','/')%>',  <%= mgreen[2]%>,     <%= myellow[2]%>,         <%= mdis[2]%>,<%= mred[2]%>],
         ['<%= mday[1].substring(mday[1].length()-5).replace('-','/')%>',  <%= mgreen[1]%>,     <%= myellow[1]%>,         <%= mdis[1]%>,<%= mred[1]%>],
         ['<%= mday[0].substring(mday[0].length()-5).replace('-','/')%>',  <%= mgreen[0]%>,     <%= myellow[0]%>,         <%= mdis[0]%>,<%= mred[0]%>]
        ]);
        var options = {
          title: 'Statistics',
          hAxis: {title: 'Day', showTextEvery: 1, gridlines: {color: 'gray',count: 7},},
          vAxes: {0: {title: 'Hosts',
                      viewWindowMode:'explicit',
                      viewWindow:{
                                  max:300,
                                  min:1
                                  },
                      gridlines: {color: 'gray',count:7},
                      },
                  1: {gridlines: {color: 'gray',count:7},
                      maxValue:500
                     },
                  },
          series: {0:{targetAxisIndex:0},
                   1:{targetAxisIndex:0},
                   2:{targetAxisIndex:1},
                   3:{targetAxisIndex:0},
                  },
          series: {
        0:{color: 'green', lineWidth: 4, pointSize: 10},
        1:{color: 'yellow', lineWidth: 4, pointSize: 10},
        2:{color: 'gray', lineWidth: 4, pointSize: 10},
        3:{color: 'red', lineWidth: 4, pointSize: 10}
      },
          
        };
        var chart = new google.visualization.LineChart(document.getElementById('chart_id2'));
        chart.draw(data, options);
      }
</script>
<div id="chart_id2" style="width: 800px; height: 300px;"></div>
</html>

<html>
<script type="text/javascript">
    google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawChart);
    function drawChart() {
      var data = google.visualization.arrayToDataTable([
        ['Data', 'Percentage (%)', { role: "style" } ],
        ['<%= mday[6]%>', <%= new BigDecimal(myellow[6]*100/(myellow[6]+mgreen[6]+mdis[6])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'yellow'],
        ['<%= mday[5]%>', <%= new BigDecimal(myellow[5]*100/(myellow[5]+mgreen[5]+mdis[5])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'yellow'],
        ['<%= mday[4]%>', <%= new BigDecimal(myellow[4]*100/(myellow[4]+mgreen[4]+mdis[4])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'yellow'],
        ['<%= mday[3]%>', <%= new BigDecimal(myellow[3]*100/(myellow[3]+mgreen[3]+mdis[3])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'yellow'],
        ['<%= mday[2]%>', <%= new BigDecimal(myellow[2]*100/(myellow[2]+mgreen[2]+mdis[2])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'yellow'],
        ['<%= mday[1]%>', <%= new BigDecimal(myellow[1]*100/(myellow[1]+mgreen[1]+mdis[1])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'yellow'],
        ['<%= mday[0]%>', <%= new BigDecimal(myellow[0]*100/(myellow[0]+mgreen[0]+mdis[0])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'yellow']
      ]);
      //var formatter = new google.visualization.NumberFormat({pattern: '0.00%'})formatter.format(data, 0);
      var view = new google.visualization.DataView(data);
      view.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" },
                       2]);

      var options = {
        title: "Overall Status for YELLOW hosts in Aurora",
        width: 600,
        height: 500,
        bar: {groupWidth: "95%"},
        legend: { position: "none" },
        hAxis: {title: 'Day', showTextEvery: 1,gridlines: {color: 'gray',count:7}},
        vAxis: {title: 'Percentage',gridlines: {color: 'gray',count:7}, showTextEvery: 1,viewWindowMode:'explicit',
              viewWindow:{max:100,min:1}}
      };
      var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values"));
      chart.draw(view, options);
  }
  </script>
<div id="columnchart_values" style="width: 900px; height: 450px;"></div>
</html>

<html>
<script type="text/javascript">
    google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawChart);
    function drawChart() {
      var data = google.visualization.arrayToDataTable([
        ['Data', 'Percentage (%)', { role: "style" } ],
        ['<%= mday[6]%>', <%= new BigDecimal(mgreen[6]*100/(myellow[6]+mgreen[6]+mdis[6])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'green'],
        ['<%= mday[5]%>', <%= new BigDecimal(mgreen[5]*100/(myellow[5]+mgreen[5]+mdis[5])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'green'],
        ['<%= mday[4]%>', <%= new BigDecimal(mgreen[4]*100/(myellow[4]+mgreen[4]+mdis[4])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'green'],
        ['<%= mday[3]%>', <%= new BigDecimal(mgreen[3]*100/(myellow[3]+mgreen[3]+mdis[3])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'green'],
        ['<%= mday[2]%>', <%= new BigDecimal(mgreen[2]*100/(myellow[2]+mgreen[2]+mdis[2])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'green'],
        ['<%= mday[1]%>', <%= new BigDecimal(mgreen[1]*100/(myellow[1]+mgreen[1]+mdis[1])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'green'],
        ['<%= mday[0]%>', <%= new BigDecimal(mgreen[0]*100/(myellow[0]+mgreen[0]+mdis[0])).setScale(2,BigDecimal.ROUND_HALF_UP)%>,'green']
      ]);
      //var formatter = new google.visualization.NumberFormat({pattern: '0.00%'})formatter.format(data, 0);
      var view = new google.visualization.DataView(data);
      view.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" },
                       2]);

      var options = {
        title: "Overall Status for GREEN hosts in Aurora",
        width: 600,
        height: 500,
        bar: {groupWidth: "95%"},
        legend: { position: "none" },
        hAxis: {title: 'Day', showTextEvery: 1,gridlines: {color: 'gray',count:7}},
        vAxis: {title: 'Percentage',gridlines: {color: 'gray',count:7}, showTextEvery: 1,viewWindowMode:'explicit',
              viewWindow:{max:100,min:1}}
      };
      var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values_green"));
      chart.draw(view, options);
  }
  </script>
<div id="columnchart_values_green" style="width: 900px; height: 450px;"></div>
</html>