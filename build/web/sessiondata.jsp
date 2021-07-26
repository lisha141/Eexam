
<%@page contentType="text/html" 
        import="com.tecdev.SessionBean"
        pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>example</title>
        <%! SessionBean sb=null; %>
    </head>
    <body>
        <%
            sb= (SessionBean) session.getAttribute("obj");
        %>
        <h1>Welcome</h1>
        <%--<h3>Userid: <jsp:getProperty name="sb" property="userid"/></h3> <br/> --%>
        <h3>Usertype: ${sb.usertype} <br/></h3>
    </body>
</html>
