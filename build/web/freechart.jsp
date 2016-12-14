<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Date"%>
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
<head>
<%
int mgreen[] = new int[7];
int myellow[] = new int[7];
int mdis[] = new int[7];
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
 java.sql.Date day_now = new java.sql.Date( new java.util.Date().getTime() );
 select1 = "select name,state from hosts";
 rs = statement.executeQuery(select1);
 java.sql.Date day;
 for(int i=0;i < count;i++){
   day = new java.sql.Date( day_now.getTime() - (24*60*60*1000)*i);
   green = 0;
   yellow = 0;
   dis = 0;
   while(rs.next()){
        name=rs.getString(1);
        state=rs.getString(2);
        select2="select state from changes where name='"+name+"' and date='"+day+"'";
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
       mday[output_count]=day.toString();
    
    output_count++;
    old_green = green;
    old_yellow = yellow;
    old_dis = dis;
   } else count++;
 }
 rs.close();
 statement.close();
 statement1.close();
} catch(Exception e) {out.println("err:");out.println(e);e.printStackTrace();}
if(con != null) con.close();        
%>        

  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
  <script type="text/javascript">
    google.load('visualization', '1.1', {packages: ['line']});
    google.setOnLoadCallback(drawChart);

    function drawChart() {
        
      var data = new google.visualization.DataTable();
      data.addColumn('number', 'Day');
      data.addColumn('number', 'Enabled');
      data.addColumn('number', 'Yellow');
      data.addColumn('number', 'Disabled');
      data.addRows([
        [<%=1%>,<%= mgreen[6]%>,<%= myellow[6]%>,<%= mdis[6]%>],
        [<%=2%>,<%= mgreen[5]%>,<%= myellow[5]%>,<%= mdis[5]%>],
        [<%=3%>,<%= mgreen[4]%>,<%= myellow[4]%>,<%= mdis[4]%>],
        [<%=4%>,<%= mgreen[3]%>,<%= myellow[3]%>,<%= mdis[3]%>],
        [<%=5%>,<%= mgreen[2]%>,<%= myellow[2]%>,<%= mdis[2]%>],
        [<%=6%>,<%= mgreen[1]%>,<%= myellow[1]%>,<%= mdis[1]%>],
        [<%=7%>,<%= mgreen[0]%>,<%= myellow[0]%>,<%= mdis[0]%>]
      ]);

      var options = {
        chart: {
          title: 'Statistics for the last Week'
        },
        width: 900,
        height: 500,
        lineWidth: 4,
        colors: ['green', 'yellow', 'gray']
      };

      var chart = new google.charts.Line(document.getElementById('linechart_material'));
      chart.draw(data, options);
    }
  </script>
  
  <script type="text/javascript">
    function drawVisualization() 
    {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Date');
        data.addColumn('number', 'Temperature');
        data.addRow(["01/01/11", 70.2]);
        data.addRow(["01/02/11", 70.0]);
        data.addRow(["01/03/11", 69.8]);
        data.addRow(["01/04/11", 70.1]);
        // Create and draw the visualization.
        new google.visualization.LineChart(document.getElementById('lineChart')).
            draw(data, {backgroundColor: 'transparent',
                        width: 700, height: 400,
                        legend: 'none',
                        hAxis: {title: 'Dates', titleTextStyle: {color: 'black', fontSize: 12, fontName: 'Verdana, Arial'}},
                        vAxis: {title: 'Temperature', titleTextStyle: {color: 'black', fontSize: 12, fontName: 'Verdana, Arial'}},
                        chartArea: {left: 80, top: 20}
                    }
                );
    
    }
    google.setOnLoadCallback(drawVisualization);
</script>
</head>
<body>
  
  <div id="lineChart"></div>
</body>
</html>