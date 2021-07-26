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
    <!--<link rel="stylesheet" type="text/css" href="css/mystyle.css" />-->
    <script>
        //Global Declaration
        var timer = window.setInterval(updateTime, 1000); //fn ,millisec
        function updateTime() {
            var h = new Number(document.getElementById("hour").value);
            var m = new Number(document.getElementById("min").value);
            var s = new Number(document.getElementById("sec").value);
            s++;
            if (s == 60) {
                m++;
                s = 0;
            }  //If seconds reach to 60
            if (m == 60) {
                h++;
                m = 0;
            } 
            var h1, m1,s1;
            h1=(h<10)?("0"+h): h;       //Format hh:mm:ss
            m1=(m<10)?("0"+m): m;
            s1=(s<10)?("0"+s): s;
            //alert(h1 + ":" + m1 + ":" + s1);
            document.getElementById("hour").value = h1;
            document.getElementById("min").value = m1;
            document.getElementById("sec").value = s1;
            document.getElementById("time").value = h1 + ":" + m1 + ":" + s1;
            //alert("Hidden=" + document.getElementById("time").value);
            if (s == 15) {
                
                //document.forms["form1"].submit();
                var f=document.getElementById("finish");//.submit();
                //alert("Form f=" +f);
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
        </style>
    <body>
        <div class="container">
            <%--Obtain qno from request.getParameter using EL--%>
            <%-- param.qno is equal to request.getParameter(qno)--%>
            <%--A. Obtain Value of qno from session using EL --%>
            <c:set var="qno" scope="session" value="${sessionScope.qno}"/>
            <%--B. Check does qno is empty, if yes send back to login page --%>
            <c:if test="${empty qno}">
                <jsp:forward page="bootstrap-login.html" />
            </c:if>
            <%--This page appears in two ways:
             1st forwarded by ExamServlet for the first time
             next time onwards this page appears when someone press
        either Previous/Next Buttons having name=submit
            --%>
            <%--C. Obtain value of submit button i.e Previous, Next, Finish --%>    
            <c:set var="submit" scope="page" value="${param.submit}" />
            <%--D. Obtain value of hidden field with name  temp--%>
            <c:set var="temp" scope="page" value="${param.temp}" />

            <%--E. Now assign value of temp to opted field of current 
                question stored inside session --%>
            <c:set var="q" scope="session" value="${sessionScope.q}" />
            
            <c:if test="${not empty temp}">
                <%--F. Calling setOpted fn of Question using EL--%>
                <c:set var="q" value="${q.opted=temp}" scope="session" />
            </c:if>
            <%--G. If submit is not empty, means some button is pressed--%>
            <c:if test="${not empty submit}">
                <%--H. If value of submit button is [Next] =>qno+1 --%>
                <c:if test='${submit eq "Next"}'>
                    <%--I. Increase value of qno by 1 and get question into q--%>
                    <c:set var="qno" scope="session" value="${qno+1}"/> 
                    <c:set var="q" scope="session" value="${sessionScope.al.get(qno)}" />
                </c:if>
                <%--J. Same logic is repeated for Previous Button --%>
                <c:if test='${submit eq "Previous"}'>
                    <c:set var="qno" scope="session" value="${qno-1}"/> 
                    <c:set var="q" scope="session" value="${sessionScope.al.get(qno)}" />
                </c:if>
                <c:if test='${submit eq "Finish"}'>
                    <%--K.Finally, when Finish is pressed redirect to ExamServlet--%>
                    <jsp:forward page="Examservlet?op=4"/>
                </c:if>     
            </c:if>          
            <%--L. Displaying Current Userid 
              <%=((SessionBean)session.getAttribute(sb)).getUserid()%>
            --%> 
            <div class="page-header">
                
                <div> 
                    <%--19-Aug-2020 Additional Logic to display timer--%>
                    <%--Obtain value of hidden field time--%>
                    <c:set var="time" scope="page" value="${param.time}"/>
                    <c:if test="${empty time}">
                        <div id="clockdiv" class="pull-right">
                    <div>
                        <input id="hour" value="00" readonly/><br/>
                        <div class="smalltext label label-default">HOURS  </div>
                    </div>
                    <div>
                        <input id="min" value="00" readonly/><br/>
                        <div class="smalltext label label-default">MINUTES</div>
                    </div>
                    <div>
                        <input id="sec" value="00" readonly/><br/>
                        <div class="smalltext label label-default">SECONDS</div>
                    </div>
                </div>
                    </c:if>
                    <c:if test="${not empty time}">
                       <div id="clockdiv" class="pull-right">
                    <div>
                        <input id="hour" readonly value="${time.substring(0,2)}"/><br/>
                        <div class="smalltext label label-default">HOURS  </div>
                    </div>
                    <div>
                        <input id="min" readonly value="${time.substring(3,5)}"/><br/>
                        <div class="smalltext label label-default">MINUTES</div>
                    </div>
                    <div>
                        <input id="sec" readonly value="${time.substring(6,8)}"/><br/>
                        <div class="smalltext label label-default">SECONDS</div>
                    </div>
                </div>
                        
                    </c:if>
                    <h1>Welcome <c:out value="${sessionScope.sb.userid}"/> </h1>
                </div>
                <div> &nbsp;</div>
                <%--M. get value of variable size and question q from session--%>
                <c:set var="size" scope="session" value="${sessionScope.size}" />

                <%--N. Present the Question to User --%>
                <form class="form" method="post" action="startexam.jsp?qno=${qno}">
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
                            <input type="submit" name="submit" value="Previous" style="visibility: ${qno>0 ? "visible": "hidden"};" class="btn btn-primary"/>                  
                             <input type="submit" name="submit" value="Next"  style="visibility: ${qno<size-1? "visible": "hidden"};" class="btn btn-primary"/>                  
                             <input type="submit" name="submit" id="finish" style="visibility: ${qno==size-1? "visible": "hidden"};" value="Finish" class="btn btn-primary"/>                 
                             <%--old logic ----improved on 24 aug 2020----
                            <c:if test="${qno >0}">

                                <input type="submit" name="submit" value="Previous" class="btn btn-primary"/>                  
                            </c:if>
                            <%-- If not on Final Question, display [Next] 
                            <c:if test="${qno <size-1}">

                                <input type="submit" name="submit" value="Next" class="btn btn-primary"/>                  
                            </c:if>
                            <%--Display [Finish] if on last question
                            <c:if test="${qno==size-1}">
                                <%--  <c:set var="qno" value="${size}"/>
                                <input type="submit" name="submit" id="finish" value="Finish" class="btn btn-primary"/>                 
                            </c:if> --%>
                        </div> <%--End of Panel-Footer--%>
                        <%--O. Hidden field to store which checkboxes are checked--%>
                        <input type="hidden" id="temp" name="temp" />
                        <input type="hidden" name="time" id="time" />
                    </div>
                </form>
                 <%--A Dummy Form to Submitted using JS when 
                    time is over
                
                 <form name="form1" id="form1" method="post" action="ExamServlet?op=4"></form>
                  --%>
            </div>
            <script src="script/jquery-3.4.1.min.js"></script>
            <script src="script/bootstrap.min.js"></script>
            <script>
            $(document).ready(function () {
                $("input[type='checkbox']").change(function () {
                    var opted = "";
                    var $boxes = $('input[name=option]:checked');
                    $boxes.each(function () {
                        opted += $(this).val();
                    });
                    $("#temp").val(opted);
                });
            });
            </script>
    </body>
</html>
