<%-- 
    Document   : certificate
    Created on : 19 Sep, 2020, 9:11:27 PM
    Author     : ADMIN
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib  prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Certificate | eExam</title>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css folder/bootstrap.css" type="text/css">
        <link href="https://fonts.googleapis.com/css2?family=Merienda:wght@700&display=swap" rel="stylesheet"> 
        <style>
            img{
              position:absolute;
              left:11%;
              
              top:2%;
                }
                h1{
                    font-family: 'Merienda', cursive;
                    font-style: oblique;
                    font-size: 50px;
                }     
                p{
                    font-family:fantasy;
                     font-size: 30px; 
                    /*color:#cccccc;*/
                }   
                h2{
                    font-family: 'Merienda', cursive;
                    text-transform: capitalize;
                    font-style: italic;
                }
                #badge{
                        position:absolute;
                   top:85%;
                    left:43%;
                }
                .row{
                   font-family:fantasy;
                    font-size: 30px; 
                }
                .btn{
                    background-color: #cccccc;
                }
        </style>
    </head>
    <body style="background-color: #999999;">
         
         <c:set var="userid" value="${param.userid}" scope="page" />
       <c:set var="examid" value="${param.examid}" scope="page" />
<%--Generate Equi-Join Query using candidate and exam table--%>
<c:set var="sql" value="Select name, dated, category from candidate, exam where candidate.userid=exam.userid and examid='${examid}' " scope="page"/>

      <%--Use Data Source name specified in Context.xml--%>
        <sql:setDataSource dataSource="jdbc/myora" var="db" />

        <%--SQL=${sql}--%>
   
 
<%--Execute the Query and Store ResultSet into variable rs--%>
        <sql:query  dataSource="${db}" var="rs"  >
            ${sql}
        </sql:query>
       <%--We've single row - So loop executes once--%>
        <c:forEach var="i" items="${rs.rows}">
            <%--Store row data into variables for future use--%>
            <c:set var="name" value="${i.name}" scope="page"/>
            <c:set var="dated" value="${i.dated}" scope="page"/>
            <c:set var="category" value="${i.category}" scope="page"/>
        </c:forEach>
        <div>
            <img src="Images/certificate.jpg" height="700px" width="1200px"/> 
        </div> 
        <jsp:include page="top.txt"/>
       <br/>
       <br/>
       <br/>
        <div class="col-xs-offset-4 col-xs-5">
            <h1>Technology Developers</h1><br/>
             <p class="text-center">_____________Making our way towards technology____________</p>
        
            <hr>
            
            <div>
               
                <img src='Images/logo.png' style='position:relative; top:15%; left:25%;' width="300px;" height="110px;"/>
            </div>
            
            
            <div id="div2">
                <p class="text-center" style="font-size:30px;">This  is  to  certify  that<br/></p> 
                
                <h2 class="text-center">${name}</h2><br/> 
                
                <p class="text-center" style="font-size:30px;">has  completed  his/her  certification  in  &nbsp;<u>${category}</u>.</p>
            </div>
           
            <br/>
           
            <div class="row">
                <div class="col-xs-offset-1 col-xs-3">
                    <u>Dated</u>
                </div> 
                <div class=" col-xs-3"> 
                <img src="Images/badge.png" width="100px" heigth="100px" id="badge"/>
            </div>
                <div class="col-xs-offset-2 col-xs-2 text-right">
                    <u>Examid</u>
                </div>
                
            </div>
                <div class="row">
                    <div class="col-xs-offset-1 col-xs-4">
                        <%--${dated}--%>
                        <fmt:formatDate type="date" value="${dated}"/>
                    </div>
                    <div class="col-xs-offset-5 col-xs-2">
                    ${examid}
                    </div>
                </div>
              
       </div>
                <br/>
                <br/>
                <span>&nbsp;</span>  
                
         <div class="col-xs-offset-11 col-xs-1">   
        <input class="form-control btn btn-default" name="print" id="print" type="button" value="Print" onclick="window.print();" />
        <input type="button" class="form-control btn btn-default" name="back" value="back" onclick="history.back();"/> 
        
        </div>
                <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.min.js"></script> 
    </body>
</html>
