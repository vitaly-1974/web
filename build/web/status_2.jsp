<%@page import="com.progressbar.TaskBean"%>
<jsp:useBean id="task" scope="session" class="com.progressbar.TaskBean"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World1</h1>
        <% 
          String user = request.getParameter("user");
          String pass = request.getParameter("pwd");
          TaskBean.setLDAP(user,pass);
        %>
    </body>
</html>
<jsp:forward page="status_1.jsp"/>

