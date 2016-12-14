<html>
    <head>
        <Title>Just A Test</Title>
        <script type="text/javascript" src="jquery.js"></script>
        <script type="text/javascript">
        var auto_refresh = setInterval(
        function ()
        {
        $('#load_me').load('showdata.jsp').fadeIn("slow");
        }, 10000); // autorefresh the content of the div after
                   //every 10000 milliseconds(10sec)
        </script>
   </head>
    <body>
    <div id="load_me"> <%@ include file="newjsp1.jsp" %></div>
    </body>
</html>