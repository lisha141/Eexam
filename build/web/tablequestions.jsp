<%-- 
    Document   : tablequestions
    Created on : 29 Jul, 2020, 1:09:44 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"    
        session="true"
        import="java.util.*, com.tecdev.QuestionBean"
        errorPage="error.jsp"
        %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Exam Started</title>
    </head>
    <body>
        <%--Declare a Variable of type Question Bean--%>
        <%! ArrayList<QuestionBean> al; %>
        <table border="1">
            <%--Obtain value of this variable from session --%>
            <%
             al=(ArrayList<QuestionBean>)session.getAttribute("al");
             //Traverse it using for-each loop
             //error
             for(QuestionBean i: al){
            %>
            <tr>
                <td><%=i.getQid()%></td>
                <td><%=i.getQuestion()%></td>
                <td><%=i.getCategory()%></td>
                <td><%=i.getOption1()%></td>
                <td><%=i.getOption2()%></td>
                <td><%=i.getOption3()%></td>
                <td><%=i.getOption4()%></td>
                <td><%=i.getAnswer()%></td>                
            </tr>
            <%}%>
        </table>
    </body>
</html>

