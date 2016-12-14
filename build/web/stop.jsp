<jsp:useBean id="task" scope="session" class="com.progressbar.TaskBean"/>
<% task.setRunning(false); %>
<jsp:forward page="status_1.jsp"/>
