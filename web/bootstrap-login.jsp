<%@page contentType="text/html" pageEncoding="UTF-8"
        import="com.tecdev.QuestionBean, com.tecdev.SessionBean, java.util.*"
        session="true"
        errorPage="error.jsp"
        %>
<%--To work with JSTL Step I is to import them using taglib direction--%>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>eExam</title>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css folder/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="css folder/logincss.css" type="text/css">
        <script src="script/scriptjs1.js" type="text/javascript"></script>
    </head>
    <body class="background">
        
        <!--Changes made on 25-08-2020 for displaying congrats message-->
        <%--<c:set var="option" value="${param.option}" scope="page" />--%>
        <c:set var="msg" scope="session" value="${sessionScope.msg}" />
        <div id="msg" class="well well-sm text-center" >
            ${empty msg?"Welcome in eExam":msg}
        <c:if test="${not empty msg}">
           <c:remove var="msg" scope="session"/>
       </c:if>
        </div>
       <div class="visible-xs-inline-block col-xs-offset-2">
         <form class="form" action="Examservlet" method="get" >
                       
             <div class="form-group">
                
                            <h1>e-Exam</h1><br>
                            <label for="t1">USERNAME</label>
                            <input id=username style="width:80%" type="text" class="form-control" placeholder="Enter Username" name="userid"/>                          
                        </div>
                        <div class="form-group">
                            <label for="t2">PASSWORD</label>
                            <input id="password" style="width:80%" type="password" class="form-control" placeholder="Enter Password" name="password"/>                          
                        </div>
                        <div class="form-group">
                            <input type="checkbox" value="Remember Me"/><label>Remember Me</label><br/>
                            <a href="register.jsp?option=forget"> Forgot Password</a>
                        </div>
                        <div class="form-group">
                            <input type="submit" id="btn" value="Login" class="btn btn-primary"/><br/>
                            <a href="register.jsp">New User Registration</a>                        
                            <img src="Images/eExam.png" alt="loginimg" id="login_img" class="visible-md visible-lg">       
                        </div>                        
                    </form>   
        </div>
        <div class="container visible-lg visible-md visible-sm">
            
            <div class="row">
                <div class="col-sm-12  col-md-6 ">
                    <form class="form" action="Examservlet" method="get" >
                       
                        <div class="form-group"> 
                            <h1>e-Exam</h1><br>
                            <label for="t1">USERNAME</label>
                            <input id=username type="text" class="form-control" placeholder="Enter Username" name="userid"/>                          
                        </div>
                        <div class="form-group">
                            <label for="t2">PASSWORD</label>
                            <input id="password" type="password" class="form-control" placeholder="Enter Password" name="password"/>                          
                        </div>
                        <div class="form-group">
                            <input type="checkbox" value="Remember Me"/><label>Remember Me</label>
                            <a href="register.jsp?option=forget">    &nbsp;&nbsp;Forgot Password</a>
                        </div>
                        <div class="form-group">
                            <input type="submit" id="btn" value="Login" class="btn btn-primary"/>
                            <a href="register.jsp">  &nbsp;&nbsp;New&nbsp;User&nbsp;Registration</a>                        
                         <img src="Images/eExam.png" alt="loginimg" id="login_img" class="visible-md visible-lg">       
                        </div>                        
                    </form>
                </div>
            </div>
        </div>
        <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.js"></script> 
    </body>
</html>
