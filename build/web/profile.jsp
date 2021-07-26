<%-- 
    Document   : profile
    Created on : 19 Sep, 2020, 9:34:02 PM
    Author     : ADMIN
--%>

<%@page import="com.tecdev.DatabaseBean"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"
        import="com.tecdev.QuestionBean, com.tecdev.SessionBean, java.util.*"
        session="true"
        errorPage="error.jsp"
        %>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <link rel="stylesheet" type="text/css" href="css folder/bootstrap.css" />
        <title>Profile | eExam</title>
        <style>
.background{
    background-image: linear-gradient(to bottom,#006666,whitesmoke  );
    height:1000px;
}
.container{
    border:1px solid white;
    background-color: white;
    width:94%;
    position: absolute;
    top:40%;
    left:3%;
    background-color: #000;
   border-radius:30px 30px 30px 30px;
    box-shadow: 0 5px 9px 0 rgba(0, 0, 0, 0.4), 0 6px 20px 0 rgba(0, 0, 0, 0.23);
}
.btn{
    background-color: #009999;
}
#login_img{
    position: absolute;
    left:42.5%;
   top:10%;
    
}
p{
   font-family: sans-serif;
   font-size: 30px;
    color:whitesmoke;
    
}
label{
    color:#999999;
}
            </style>
    </head>
   
    <body>
        <div class="background">
            <img alt="profile" id="login_img" src="Images/icon-profile2.png"/><br/>
            
            <div class="container">
                <span>&nbsp;</span>
                <p class="text-center">
                      <c:set var="userid" value="${sessionScope.sb.userid}" scope="page" />
                <%--Use Data Source name specified in Context.xml--%>
                <sql:setDataSource dataSource="jdbc/myora" var="db" />
                <c:set var="sql" value="Select name, mobile from candidate where userid='${userid}'" scope="page"/>
                <%-- SQL=${sql}--%>
                <%--Execute the Query and Store ResultSet into variable rs--%>
                <sql:query  dataSource="${db}" var="rs"  >
                    ${sql}    
                </sql:query>  
                <%--We've single row - So loop executes once --%>
                <c:forEach var="i" items="${rs.rows}">
                    <%--Store row data into variables for future use--%>
                    <c:set var="name" value="${i.name}" scope="page"/>
                    <c:set var="mobile" value="${i.mobile}" scope="page"/>
                </c:forEach>
                <input type="hidden" id="operation" value="${empty name?'add':'edit'}"/>      
                    Welcome <c:out value="${userid}"/> <span class="badge">Candidate</span><br/>
                    </p>
                    <span>&nbsp;</span>
                    <div class="row">
                    <label for="userid" class="col-xs-4">Userid</label>
                    <label for="name" class="col-xs-4">Name</label>
                    <label for="phoneno" class="col-xs-4">Phone No.</label>
                    </div>
                <div class="row">
                    <div class="form-group">
                        <div class="col-xs-4">
                    <input type="text" class="form-control" id="userid" value="${userid}"/>
                        </div>
                         <div class="col-xs-4"> 
                    <input type="text" class="form-control" id="name" value="${name}"/>
                         </div>
                          <div class="col-xs-4">
                    <input type="text" class="form-control " id="mobile" value="${mobile}"/>
                          </div>
                    </div>
                </div><br/>
                    <a class="btn btn-default" href="mainpage.jsp"><span class="glyphicon glyphicon-home"></span> Home</a>
                     <span>&nbsp;</span>
                     
                    <a class="btn btn-default" href="register.jsp?option=forget"><span class="glyphicon glyphicon-lock"></span> Change Password</a>
                     <span>&nbsp;</span>
                    <a class="btn btn-default" href="Examservlet?op=11"><span class="glyphicon glyphicon-log-out"></span> Logout</a>
                    <span>&nbsp;</span>
                    <a class="btn btn-default" id="save"><span class="glyphicon glyphicon-save"></span>Save</a>
                   <br/>
                   <br/>
            </div>
                          <div id="msg" class="text-center" style="font-size:25px;"></div>
        </div>
        <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.min.js"></script>
        <script>
            //Below Fn called only when DOM is Ready
            jQuery(document).ready(
                    function () {
                        //Register Click Event on [Add]
                        $("#save").on('click', saveClick);
                    }); //End of ready fn
            function saveClick(n) {
                //Collect data from GUI
                var op=$("#operation").val();
                //alert("op=" +op);
                var u = $("#userid").val();
                var n = $("#name").val();
                var m = $("#mobile").val();
                //Syntax of QueryString ?var1=val1&var2=val2&varN=valN
                var queryString = "operation=" + op +"&userid=" + u + "&name=" + n + "&mobile=" + m;
                //alert(query);
                var myurl = "Examservlet?op=12&" + queryString;
               //  alert(myurl);
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                        //$("#result").html(data); //Means show Table inside Div
                        $("#msg").html(data);
                       
                    },
                    error: function (jqXHR, exception) {
                        console.log('Exception ' + excepttion);
                    }
                });
            }

        </script>
    </body>
</html>
