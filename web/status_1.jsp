<%@page import="com.progressbar.TaskBean"%>
<jsp:useBean id="task" scope="session" class="com.progressbar.TaskBean"/>
<% 
String user = request.getParameter("user");
String pass = request.getParameter("pwd");
TaskBean.setLDAP(user,pass);
%>
<HTML>
<HEAD>
    <TITLE>Reboot hosts</TITLE>
    <% if (task.isRunning()) {
    %>
        <SCRIPT LANGUAGE="JavaScript">
            setTimeout("location='status_1.jsp'", 2000);
        </SCRIPT>
    <% } %>
</HEAD>
    <H4 ALIGN="CENTER">Reboot hosts for user:<%= TaskBean.getUser()%></H4>
        Hosts to reboot: <%= task.getResult() %><BR>
        <% 
          int percent = task.getPercent(); 
          String hostname = (String) task.getHostname();
          String report = task.getReport();
          //user = TaskBean.getUser();
          //pass = TaskBean.getPass();
        %>

    <TABLE WIDTH="60%" ALIGN="CENTER" BORDER=1 CELLPADDING=0 CELLSPACING=0>
        <TR>
            <% for (int i = 5; i <= percent; i += 5) { %>
                <TD WIDTH="5%" BGCOLOR="#000080">&nbsp;</TD>
            <% } %>
            <% for (int i = 100; i > percent; i -= 5) { %>
                <TD WIDTH="5%">&nbsp;</TD>
            <% } %>
        </TR>
    </TABLE>

    <TABLE WIDTH="100%" BORDER=0 CELLPADDING=0 CELLSPACING=0>
        <TR>
            <TD ALIGN="CENTER">
                <% if (task.isRunning()) { %>
                    Running
                <% } else { %>
                    <% if (task.isCompleted()) { %>
                        Completed
                    <% } else if (!task.isStarted()) { %>
                        Not Started
                    <% } else { %>
                        Stopped
                    <% } %>
                <% } %>
            </TD>
        </TR>

        <TR>
            <TD ALIGN="CENTER">
                <BR>
                <% if (task.isRunning()) { %>
                    <FORM METHOD="GET" ACTION="stop.jsp">
                        <INPUT TYPE="SUBMIT" VALUE="Stop">
                    </FORM>
                <% } else { %>
                    <FORM METHOD="GET" ACTION="start.jsp">
                        <INPUT TYPE="SUBMIT" VALUE="Start">
                    </FORM>
                <% } %>
            </TD>
        </TR>
    </TABLE>
            <%= report %>
</HTML>