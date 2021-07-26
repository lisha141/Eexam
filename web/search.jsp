<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.tecdev.DatabaseBean"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search | eExam</title>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css folder/bootstrap.css" type="text/css">
        <style>
            th,td{
            border:2px solid black;
            padding:15px;
            }
            .label{
                font-size: 20px;
                color:black;
            }
            .btn{
                background-color:  #009999;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <c:set var="msg" scope="session" value="${sessionScope.msg}" />
            <div class="well well-sm text-center" id="msg">
                ${empty msg?"Search Questions":msg}
                <jsp:include page="top.txt" />
            </div>
            <%--26-Aug-2020-- Removing msg variable if set--%>
            <c:if test="${not empty msg}">
                <c:remove var="msg" scope="session"/> <%--Semaphore--%>
            </c:if>
            <span>&nbsp;</span>
            <div class=' page-header row'>
                <form method="post">
            <div class='col-sm-2 text-right'>
              <span class="label">Search:</span>
            </div>
                <div class='col-sm-3 text-left'>
                   
                    <select class="form-control" name="criteria" id="criteria">
                        <option value='question'>Question</option>
                        <option value='category'>Category</option>
                        <option value='questionType'>QuestionType</option>
                        <option value='qid'>qid</option>
                    </select>
                   
                </div>
                <div class="col-sm-6">
                    <input type='text' id='search' name="search" class='form-control ' value='' placeholder="Search here"/>
                </div>
                <div class='col-sm-1 text-left'>
                    <a class='btn btn-primary' id="searchbtn"/><span class='glyphicon glyphicon-search'></span></a>
                </div>
                </form>
            </div>
             <span>&nbsp;</span>
             <div id="result" class='col-xs-offset-1 col-xs-10'> </div>
              <span>&nbsp;</span>
                 <div class='page-footer'> 
                      <span>&nbsp;</span>
                     <div class='col-xs-1 col-xs-offset-9'>
                         <input class="form-control btn btn-primary" name="print" id="print" type="button" value="Print" onclick="window.print();" />
                     </div>
                     </div> 
        </div>
        <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.min.js"></script> 
        <script>
           $(document).ready(function(){
               $("#searchbtn").on("click",search);
               
           });
            function search(){
               
                var c=$("#criteria").val();
               var v=$("#search").val();
                
                 var myurl="Examservlet?op=10&c=" + c +"&v="+ v;
                 //alert(myurl);
                 $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                  success: function (data) {
                       $("#result").html(data); 
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + excepttion);
                    }
                });
            }
           
             </script>
    </body>
</html>
