<%-- 
    Document   : startexam
    Created on : 26 Jul, 2020, 2:00:59 AM
    Author     : ADMIN
--%>

<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"
        import="com.tecdev.QuestionBean, com.tecdev.SessionBean"
        session="true"
        errorPage="error.jsp"
        %>
<%--To work with JSTL Step I is to import them using taglib direction--%>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <!--get name of exam category-->
    <title>Exam Started</title>
    <meta charset="UTF-8">

    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" type="text/css" href="css folder/bootstrap.css" />
    <body>
        <%
            //Obtain value of qno from startExam fn of QuestionBean
            String q = request.getParameter("qno");
            //Obtaining existing session, don't create new session
            //Check if either session or qno does not exists
            if (session == null || q == null) {
                response.sendRedirect("bootstrap-login.html");
                return;
            }
            //Convert String to int
            int qno = Integer.parseInt(q);
        %>
        <%--Now obtain ArrayList of Questions from Session--%>
        <%! ArrayList<QuestionBean> ap = null;

        %>
        <%
            //initialize it only once when it is null
            if (ap == null) {
                //Typecast Session Object to ArrayList of Question
                ap = (ArrayList<QuestionBean>) session.getAttribute("al");
            }
            //Obtain Current Question qno into QuestionBean object
            QuestionBean qb = null;
            qb = ap.get(qno);  //Initially qno=0            
        %>
        <%--Step II: Connect with Database using JSTL--%>
        <div class="container">
            <%--Design Layout for Mobile and Other Devices--%>
            <div class="row">
                <div class="panel panel-primary">
                    
               
                <div class="col-xs-12 panel panel-heading">
                     Q<%=(qno + 1)%>.&nbsp;&nbsp;<%=qb.getQuestion()%>
                </div>
                    
                <div class="panel panel-body">
                <div class="col-xs-10">
                    &nbsp;
                </div>
            
            <div class="col-xs-10">
                <%=qb.getOption1()%>
            </div>
            <div class="col-xs-10">
                    &nbsp;
                </div>
            <div class="col-xs-10">
                <%=qb.getOption2()%>
            </div>
            <div class="col-xs-10">
                    &nbsp;
                </div>
            <div class="col-xs-10">
                <%=qb.getOption3()%>
            </div>
            <div class="col-xs-10">
                    &nbsp;
                </div>
            <div class="col-xs-10">
                <%=qb.getOption4()%>
            </div>
        
            
                </div> 
           
            </div>
            </div>
        </div>
            <%
            //If we are NOT at the first Question show [Previous] Button
            if (qno > 0) {
        %>
        <div class="col-xs-12 col-sm-6">
            <a class="btn btn-primary" href="startexam.jsp?qno=<%=qno - 1%>">Previous</a>                    
        </div>
        <%}
if (qno < ap.size() - 1) {
        %>
        <div class="col-xs-12 col-sm-6">
            <a class="btn btn-primary" href="startexam.jsp?qno=<%=qno + 1%>">Next</a>                    
        </div>
        <%}
            if (qno == ap.size() - 1) {
        %>
        <div class="col-xs-12 col-sm-6">
            <a class="btn btn-primary" href="ExamServlet?op=4">Finish</a>                    
        </div>
        <%}%>
            </div>
            <%--Decide What Button Appears based on qno
            qno>0  [Previous]
            qno<(size-1):  [Next]
            qno==(size-1) [Finish]          
            --%>
        <%--<sql:setDataSource dataSource="jdbc/myora" var="db" />
        <c:set var="sql" value="select * from question" scope="page"/>
        
        <sql:query  dataSource="${db}" var="rs"  >
            ${sql}
        </sql:query>
          <div class="container">
            <div class="row">
                
                  <c:forEach var="i" items="${rs.rows}">
                      <div class="col-xs-1">
                          <c:out value="${i.qid}"/>
                         
                      </div>
                      <div class="col-xs-1">
                          <c:out value="${i.question}"/>
                      </div>
                      <div class="col-xs-1">
                          <c:out value="${i.option1}"/>
                      </div>
                      <div class="col-xs-1">
                          <c:out value="${i.option2}"/>
                      </div>
                      <div class="col-xs-1">
                          <c:out value="${i.option3}"/>
                      </div>
                  </c:forEach>
            </div>
        </div>--%>
        <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.min.js"></script>
    </body>
</html>
