<%@page import="com.progressbar.TaskBean"%>
<% session.removeAttribute("task"); %>

<jsp:useBean id="task" scope="session" class="com.progressbar.TaskBean"/>

<%
  task.setReport();
  task.setRunning(true);
  new Thread(task).start(); 
%>

<jsp:forward page="status_1.jsp"/> 

