<%-- 
    Document   : logout
    Created on : 19 Sep, 2020, 7:54:18 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logout | eExam</title>
        <link rel="stylesheet" href="css folder/bootstrap.css" type="text/css">
        <style>
            .background{
    background-image: linear-gradient(to bottom,#006666,whitesmoke  );
    height:1000px;
}
.container{
    border:1px solid white;
    background-color: white;
    width:40%;
    position: absolute;
    top:25%;
    left:30%;
   border-radius:20px 20px 20px 20px;
    box-shadow: 0 5px 9px 0 rgba(0, 0, 0, 0.4), 0 6px 20px 0 rgba(0, 0, 0, 0.23);
}
.btn{
    background-color: #009999;
}
#login_img{
    position: absolute;
    left:120%;
   top:20%;
    
}
h1{
    font-family:Times New Roman;
    font-size:40px;
    color:black;
    
}
        </style>
    </head>
    <body>
        <div class="background">
        <div class="container">
            <h1>eExam</h1>
            <h3 style="color:lightslategrey;">
                Thank you , for your support!
            </h3><br/>
            <span>&nbsp;</span>
             <span>&nbsp;</span>
              <span>&nbsp;</span>
               <span>&nbsp;</span>
               <div class="text-center">
            <a class="btn btn-primary" type="button" href="bootstrap-login.jsp">Login Again</a>
            
            <input class="btn btn-primary" value="Cancel" type="button"onclick="history.back();">
               </div>
        </div>
        </div>
        <script src="script/jquery-3.4.1.min.js"></script>
    <script src="script/bootstrap.min.js"></script> 
    </body>
</html>
