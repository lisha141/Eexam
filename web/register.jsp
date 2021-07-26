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
        <title>Registration | eExam</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css folder/bootstrap.css" />
        <style>
            
        </style>
    </head>
    <body> 
        <div class="container">
            <c:set var="option" value="${param.option}" scope="page" />
            <c:set var="t" scope="page" value="${option eq 'forget'?'Reset Password':'Register'}"/>
            <div class='row page-header'>
             
                 <div class='col-xs-5 col-md-3 col-md-offset-1'>
                     <img src="Images/eExam.png" alt="okay" class="pull-right" style="width:80px;height:80px;">
                 </div>
                 <div class='col-xs-7 col-md-4'>
                     <h1>eExam ${t}</h1>
                 </div>
                 
                
            </div>
            <div>&nbsp;</div>
            <div>&nbsp;</div>
            <div class="row">
               
            <div class="col-xs-12 col-sm-8 col-md-6 col-md-offset-3">
                 
            <form class="form" method="post" action="Examservlet?op=${option eq 'forget'?1:2}">
                <div class="form-group">
                    <label for="userid">Enter Userid</label>
                    <input type="text" class="form-control" id="userid" name="userid" required placeholder="Userid Here"/>                          
                </div>
                <div class="form-group">
                    <label for="password">Enter Password</label>
                    <input type="password" class="form-control" id="password" name="password" required placeholder="Password Here"/>                          
                </div>
                <div class="form-group">
                    <label for="confirmpassword">Confirm Password</label>
                    <input type="password" class="form-control" required id="confirmpassword" name="confirmpassword" placeholder="Confirm Password"/>                          
                </div>
               <div class="form-group">
                    <label for="question">Select Security Question</label>
                    <select name="question" class="form-control" id="question">
                        <option value="favourite dish" selected>favourite dish</option>
                        <option value="favourite actor">favourite actor</option>
                        <option value="favourite city">favourite city</option>
                        <option value="first school">first school</option>
                    </select>
                </div>
                 <div class="form-group">
                    <label for="answer">Enter Security Answer</label>
                    <input type="text" class="form-control" id="answer" name="answer" required placeholder="Security answer Here"/>                          
                </div>
                <div class="form-group" style="text-align:center;">
                    <input type="submit" name="submit" id="submit" style="background-color: #006666" value="Submit Now" class="btn btn-primary"/>
                    <a href="bootstrap-login.jsp" class="btn btn-primary" style="background-color: #006666;">Cancel Registration</a>
                </div>                        
            </form>    
            </div> 
            </div>
        </div>
         <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.js"></script>
        <script>
            $(document).ready(function f(){
                 $("#submit").on('click', function(){
                var p=$("#password").val();
                var c=$("#confirmpassword").val();
                if(p!==c){
                    alert("Both passwords dont match!");
                    $("#confirmpassword").val("");
                    $("#confirmpassword").css("borderColor","tomato");
                }
                });
                    
            });
            </script>
    </body>
</html>
