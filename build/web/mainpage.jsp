<%-- 
    Document   : mainpage
    Created on : 3 Jul, 2020, 7:54:32 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"
        session="true"
        import="com.tecdev.SessionBean,com.tecdev.DatabaseBean,java.sql.ResultSet"
        errorPage="error.jsp"  
        %>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard | eExam</title>
        <link rel="stylesheet" href="css folder/bootstrap.css" type="text/css">

    </head>
    <body>
 <sql:setDataSource dataSource="jdbc/myora" var="db"/>        
        <style>
            *{
                font-size: 102%;
            }
            img{
                height:70px;
                width:70px;
            }
            h1{
                color:#ffffff;
                font-family: times new roman;
                font-size:150%;
            }
            .btn{
                background-color: #009999;
            }
        </style>
        <div class="navbar navbar-inverse">
            <div class="container-fluid">
                <div class="navbar-header">
                    
                    <img src="Images/eExam2.png" class="pull-left">
                    <div class="navbar-brand">
                        <h1>eExam<small class="visible-md-inline visible-lg-inline">  Online Exam Portal</small></h1>  
                    </div>
                    <button type="button" class="navbar-toggle"
                            data-toggle="collapse"
                            data-target="#mynavdiv">
                        <!--Step V: Create Hidden Icons inside Button-->
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>  
                <div class="collapse navbar-collapse" id="mynavdiv">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="mainpage.jsp"><span class="glyphicon glyphicon-home"></span> Home</a></li>
                             <%--  (*1) --%>

                        <c:set var="userid" value="${sessionScope.sb.userid}" />
                             
                        <jsp:useBean id="sb" scope="session" class="com.tecdev.SessionBean"/>
                            <c:if test="${sb.usertype ne 'A'}">
                            <li><a href="profile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
                            <li class="dropdown">      
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Select Exam<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                   <c:set var="sql" value="select category from categories order by category" scope="page"/>
                                    <sql:query  dataSource="${db}" var="rs"  >
                                        ${sql}    
                                    </sql:query>  
                                    <c:forEach var="i" items="${rs.rows}">
                                        <li><a href='Examservlet?op=3&category=${i.category}'><span class="glyphicon glyphicon-certificate"></span>${i.category}</a></li>
                                        </c:forEach>
                                </ul>
                            </li>  
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-certificate"></span> My Certificates<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <c:set var="sql" value="select to_char(dated,'dd-Mon-yy') as dated,examid from exam where userid='${userid}' and percent>65 order by dated,examid" scope="page"/>
                                   
                                    <sql:query  dataSource="${db}" var="rs1"  >
                                        ${sql}    
                                    </sql:query>  
                                    <c:forEach var="i" items="${rs1.rows}">
                                        <li><a href='certificate.jsp?userid=${userid}&examid=${i.examid}'>${i.dated}--${i.examid}</a></li>
                                        </c:forEach>
                                </ul>
                            </li>
                            </c:if>
                            <c:if test="${sb.usertype eq 'A'}">
                            <li><a href="Examservlet?op=7"><span class="glyphicon glyphicon-question-sign"></span>Manage Questions</a></li>
                            <li><a id="ncategory"><span class="glyphicon glyphicon-tag"></span>Add Categories</a></li>
                            <li><a href="search.jsp"><span class="glyphicon glyphicon-search"></span>Search Questions</a></li>
                            <li><a class="btn btn-default" href="Examservlet?op=11"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
                        </c:if>

                    </ul>                        
                </div>
            </div>
        </div>
                            <c:set var="msg" scope="session" value="${sessionScope.msg}" />
                            <div id="msg" class="well well-sm text-center" >
            ${empty msg?" ":msg}
        <c:if test="${not empty msg}">
           <c:remove var="msg" scope="session"/>
       </c:if>
        </div>
        <div class="container-fluid">
            <div class="row">

                <form class="form" method="post" action="Examservlet?op=3">

                    <div class="col-xs-12 col-sm-4 text-left" >

                        <label   for="category">Select Category to take Exam</label><br/>
                      

                        
                    </div>
                    <div class="col-xs-12 col-sm-4 col-lg-pull-2">
                        <select name="category" class="form-control" id="category">
                           <c:forEach var="i" items="${rs.rows}">
                        <option value="${i.category}">${i.category}</option>
                     </c:forEach>

                        </select>
                        <span>&nbsp;</span>

                    </div>
                    <div class="col-xs-12 col-sm-4 col-lg-pull-2">
                        <div class="form-group">
                            <input type="submit" value="Start" class="btn btn-primary"/>
                        </div>  



                    </div> 

                </form>
                
            </div> 
      

        <div>&nbsp;</div>
        <div>&nbsp;</div>
        <div class="col-xs-12 panel panel-success">
            <div class="panel panel-heading">Rules for Eexam</div>
            <div class="panel panel-body">
                1.Dont open another window or try to refresh your page in the middle of exam.<br><br>
                2.Dont cheat.<br><br>
                3.There is no negative marking.<br><br>
                4.Attempt all questions.<br><br>

            </div>
            <div class="panel panel-footer"><h6>All The Best!</h6></div>
        </div>
         
        
    </div>
    <script src="script/jquery-3.4.1.min.js"></script>
    <script src="script/bootstrap.min.js"></script> 
    <script>
        $(document).ready(function(){
            $("#ncategory").on("click",findCategory);
        });
         function findCategory() {
               
                var ncategory = prompt("Enter Category to add :");
                //Check if cancel pressed or nothing entered
                if ( ncategory == null || ncategory.trim().length == 0) {
                    return false; //Terminate Fn
                }
                var myurl = "Examservlet?op=9&ncategory=" + ncategory;
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                        //Convert comma seperated data to array
                       alert(data);
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + excepttion);
                    }
                });
            }
            
        </script>
</body>
</html>
