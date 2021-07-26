<%-- 
    Document   : startexam
    Created on : 12 aug, 2020, 2:00:59 AM
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
    <title>Exam Started | eExam</title>
    <meta charset="UTF-8">

    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" type="text/css" href="css folder/bootstrap.css" />
    <body>
        <div class="container">
            <%--Obtain qno from request.getParameter using EL--%>
            <%-- param.qno is equal to request.getParameter(qno)--%>
            <c:set var="qno" scope="page" value="${param.qno}"/>
            <%--Check it is null or not using EL (empty is for null)--%>
            <c:if test="${(empty qno)}">
                <%-- equivalent to forward fn of Servlet--%>
                <jsp:forward page="bootstrap-login.html"/>
            </c:if>
            <%--Also check if session of that user exists
                using sessionScope implicit object of EL 
                 session.getAttribute("sb") --%>
            <c:if test="${(empty sessionScope.sb)}">
                <jsp:forward page="bootstrap-login.html"/>
            </c:if>
            <%--Displaying Current Userid 
              <%=((SessionBean)session.getAttribute(sb)).getUserid()%>
            --%> 
            <div class="page-header">
                <h1>Welcome <c:out value="${sessionScope.sb.userid}"/> </h1>
            </div>
            <%--Now obtain ArrayList from session, using Scriplet--%>
            <%
                //Obtain ArrayList from Session with name al
                ArrayList<QuestionBean> al = (ArrayList) session.getAttribute("al");
                //Obtain Current Question number 
                int index = Integer.parseInt(request.getParameter("qno"));
                //Check if arraylist not found
                if (al == null) {
                    response.sendRedirect("bootstrap-login.html");
                    return;  //terminate fn
                }
                //Obtain current Question inside variable with given index
                QuestionBean q1 = al.get(index);
            %>
            <%--Assign q1 to variable q of JSTL Core Library --%>
            <c:set var="size" scope="session" value="${sessionScope.size}" />
            
            <form method="post" action="startexam.jsp?qno=${qno}">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    Q${qno+1}
                </div>
                <div class="panel-body">

                    <p>${q.question} </p> <%--Automatically calls getQuestion()--%>
                    <%--Display options in the form of Checkboxes--%>  
                    <p><input type="checkbox" name="option" value="1" ${(q.getOpted().indexOf("1")>=0) ? "checked":" "}/> ${q.option1}</p>
                    <p><input type="checkbox" name="option" value="2" ${(q.getOpted().indexOf("2")>=0) ? "checked":" "}/> ${q.option2}</p>
                    <p><input type="checkbox" name="option" value="3" ${(q.getOpted().indexOf("3")>=0) ? "checked":" "}/> ${q.option3}</p>
                    <p><input type="checkbox" name="option" value="4" ${(q.getOpted().indexOf("4")>=0) ? "checked":" "}/> ${q.option4}</p>
                </div>
                <div class="panel-footer">
                    <input type="hidden" id="oldqno" name="oldqno" value="${qno}" />
                    <%--If not on 1st question display [Previous]--%>
                    <c:if test="${qno >0}">
                         <input type="submit" name="submit" value="Previous" class="btn btn-primary"/>                 
                    </c:if>
                    <%-- If not on Final Question, display [Next] --%>
                    <c:if test="${qno <size-1}">
                        <input type="submit" name="submit" value="Next" class="btn btn-primary"/>                     
                    </c:if>
                    <%--Display [Finish] if on last question--%>
                    <c:if test="${qno==size-1}">
                        <input type="submit" name="submit" value="Finish" class="btn btn-primary"/>                    
                    </c:if>
                </div>
                <input type="hidden" id="temp" name="temp" />
            </div>
            </form>
        </div>

                <script src="script/jquery-3.4.1.min.js"></script>
                <script src="script/bootstrap.min.js"></script>
                <script>
                    $(document).ready(function(){
                        $("input[type='checkbox']").change(function(){
                           var opted="";
                      var $boxes= $('input[name=option]:checked');
                      $boxes.each(function(){
                          opted+=$(this).val();
                      });
                      $("#temp").val(opted);
                        });
                    
                    });
                    </script>
                </body>
                </html>
