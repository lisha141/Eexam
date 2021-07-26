<%@page contentType="text/html" pageEncoding="UTF-8"
        import="com.tecdev.QuestionBean, com.tecdev.SessionBean, java.util.*"
        session="true"
        errorPage="error.jsp"
        %>
<%--To work with JSTL Step I is to import them using taglib direction--%>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html>
    <title>Exam Started | eExam</title>
    <meta charset="UTF-8">
    <!--Backward compatible with Internet Explorer 8.0-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--Responsive Apps, Size adjusted as per device size-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--Add Bootstrap CSS Before any other custom css -->
    <link rel="stylesheet" type="text/css" href="css folder/bootstrap.css" />
   
    <script>
        //Global Declaration
        var timer = window.setInterval(updateTime, 1000); //fn ,millisec
        function updateTime() {
            var h = new Number(document.getElementById("hour").value);
            var m = new Number(document.getElementById("min").value);
            var s = new Number(document.getElementById("sec").value);
            s++;    //Increase Second by 1
            if (s == 60) {  //If reach to 60 increase minute by 1
                m++;
                s = 0;
            }  //If minutes reach to 60 then increase hour by 1
            if (m == 60) {
                h++;
                m = 0;
            }
            var h1, m1, s1;
            h1 = (h < 10) ? ("0" + h) : h;       //Format hh:mm:ss
            m1 = (m < 10) ? ("0" + m) : m;
            s1 = (s < 10) ? ("0" + s) : s;
            document.getElementById("hour").value = h1;
            document.getElementById("min").value = m1;
            document.getElementById("sec").value = s1;
            document.getElementById("time").value = h1 + ":" + m1 + ":" + s1;
            if (s == 60) {
                var f = document.getElementById("finish");//.submit();
                window.clearInterval(timer);
                f.click();
                return;
            }
        }
    </script>
    <style>
    #clockdiv > div{
        padding: 5px;
        border-radius: 5px;
        background: #cccccc;
        display: inline-block;
    }
    #clockdiv div > input{
        padding: 5px;
        border-radius: 5px;
        background: #ffffff;
        width: 60px;
        display: inline-block;
        font-family: sans-serif;
    }

    .smalltext{
        font-family:sans-serif;
        padding-top: 1px;
        font-size: 12px;

    }
    .label{
        width:100%;
    }
    .panel-mycustom{
        background-color:white;
        border:1px solid #009999;
        font-size: 20px;
    }
    .panel-heading{
       background-color: #009999;
       border-color:#009999;
    }
    .btn{
        background-color: #009999;
    }
    .badge{
        background-color:white;
        color:black;
    }
    .badge-success{
        background-color:#009999;
        color:white;
    }
    .badge-danger{
        background-color:tomato;
        color:white;
    }
</style>
    <body>
        <div class="container">
            <div class="page-header">
                <%--Display Userid--%>
                <div class="row">
                    <div class="text-left col-xs-5 col-xs-offset-1">
                        <h1 style="font-family: serif;">Welcome <span style="  text-transform: capitalize;">${sessionScope.sb.userid}</span></h1>
                    <h4><span class="label label-default">Category:${sessionScope.category}</span></h4>
                    </div>
                
                <%--Displaying Timer--%>
                <h3 class="text-right col-xs-6"> 
                    <%--Correction on 28-Aug-2020 Time Bug--%>
                    <c:set var="ctime" scope="page" value="${param.time}" />
                    <c:set var="time" scope="session" value="${sessionScope.time}"/>
                    <%--<c:if test="${empty time}">
                        <input type="text" readonly id="hour" value="0" size="2" />:
                        <input type="text" readonly id="min" value="0" size="2"/>:
                        <input type="text" readonly id="sec" value="0" size="2" />
                    <%--</c:if>--%>
                    <c:if test="${not empty ctime}">
                        <c:set var="time" scope="session" value="${ctime}"/>
                    </c:if>
                   <div id="clockdiv" class="pull-right">
                        <div>
                            <input  readonly="true" id="hour" value="${time.substring(0,2)}"/><br/>
                            <div class="smalltext label label-default">HOURS  </div>
                        </div>
                        <div>
                            <input  readonly="true" id="min" value="${time.substring(3,5)}"/><br/>
                            <div class="smalltext label label-default">MINUTES</div>
                        </div>
                        <div>
                            <input  readonly="true" id="sec" value="${time.substring(6,8)}"/><br/>
                            <div class="smalltext label label-default">SECONDS</div>
                        </div>
                    </div>

                   
                </h3>
            </div>
               
            </div>  
               
           
            <form method="post" onsubmit="return confirmed();" action="Examservlet?op=4">
                
                    <%--Traversing ArrayList<QuestionBean> using forEach--%>
                    <c:forEach var="q2" items="${sessionScope.al}" varStatus="i" >
                        <div class="panel panel-mycustom">
                            
                    <div class="panel-heading">
                    <div class="badge">    
                        <h5><span id="lbl${i.index}">Q.${i.index +1}</span></h5>
                    </div>
                   
                    </div>
                <div class="panel-body">
                     ${q2.question}
                     <br/>
                                <input type="checkbox" name="${i.index}"  value="1" ${(q2.opted.indexOf("1")>=0) ? "checked":" "}/> ${q2.option1}
                                <br/>
                                <input type="checkbox" name="${i.index}" value="2" ${(q2.opted.indexOf("2")>=0) ? "checked":" "}/> ${q2.option2}
                                <br/>
                                <input type="checkbox" name="${i.index}"  value="3" ${(q2.opted.indexOf("3")>=0) ? "checked":" "}/> ${q2.option3}
                                 <br/>
                                <input type="checkbox" name="${i.index}"  value="4" ${(q2.opted.indexOf("4")>=0) ? "checked":" "}/> ${q2.option4}
                            
                         </div>
                                <div class="panel-footer">
                                </div>
                        </div>
                                <br/>
                    </c:forEach>
                    <div class="col-xs-3 col-xs-offset-1">
                        <a href="startexam.jsp" class="btn btn-primary" onclick="switchPage(this);">Show one by one</a>
                    </div>
                    <div class="col-xs-3 col-xs-offset-4">
                        <input class="btn btn-primary" type="submit" value="Finish" />
                    </div>
            </form>
            <input type="hidden" id="temp" name="temp" value="${q.opted}" />
            <input type="hidden" name="time" id="time" value="${time}" />
        </div>
        <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.js"></script>
        <script>
            function switchPage(link){
            var timer=$("#time").val();    
            var href=$(link).attr("href");
            href+="?time="+timer;
            $(link).attr("href",href);
            return true;
            }
                        $(document).ready(function () {
                            //Register change event on all checkboxes
                            $(":checkbox").change(checkSelected);
                        });
                        //Fn to handle when some checkbox state changed
                        function checkSelected() {
                         
                            //Get name of currently checked checkbox
                            var currentCheckbox = $(this).attr("name");
                            //Get only those currentCheckbox which are checked [out of 4 checkboxes]
                            var checkedCheckbox = "input[name=" + currentCheckbox + "]:checked";
                            //assign checkedCheckbox to local variable
                            var $checkedbox = $(checkedCheckbox);
                            //Initialize opted with empty String
                            var opted = "";
                            //For each checked box (this) concat its value to opted
                            $checkedbox.each(function () {
                                opted += $(this).val(); 
                            });
                           
                            var lbl="#lbl" + currentCheckbox;
                            //If opted make it green else red
                            var color=(opted.length>0)?'success':'danger';
                              
                            $(lbl).attr('class','badge-'+color);
                            
                            var myurl = "Examservlet?op=13&index=" + currentCheckbox + "&opted=" + opted;
                           
                            $.ajax({
                                url: myurl,
                                async: false,
                                type: 'POST',
                                success: function (data) {  //Get data from Servlet
                                    //$("#result").html(data); //Means show Table inside Div
                                    //alert("State Saved");
                                },
                                error: function (jqXHR, exception) {
                                    console.log('arrayToText Exception ' + exception);
                                }
                            });

                        }
                        function confirmed(){
                            var choice=confirm("Are You sure to Finish");
                            //Possible value of confirm box are true and false
                            return choice;  //Ok=>true, cancel=>false
                            
                        }

        </script>
    </body>
</html>
