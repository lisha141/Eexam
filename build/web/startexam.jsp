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
    <!--<link rel="stylesheet" type="text/css" href="css folder/mystyle.css" />-->
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
            if (s == 30) {
                //alert("TIME OVER!!")
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
    }
    .panel-heading{
       background-color: #009999;
       border-color:#009999;
    }
    .btn{
        background-color: #006666;
    }
</style>
    <body>
        <div class="container">
            <c:set var="qno" scope="session" value="${sessionScope.qno}"/>
            <c:if test="${empty qno}">
                <jsp:forward page="bootstrap-login.jsp" />
            </c:if>
            <c:set var="submit" scope="page" value="${param.submit}" />

            <c:set var="temp" scope="page" value="${param.temp}" />
            <c:set var="q" scope="session" value="${sessionScope.q}" />
            <c:choose>
                <c:when test="${not empty temp}">
                    <c:set var="q1" scope="session" value="${sessionScope.q}" />
                    <c:set var="q1" value="${q1.opted=temp}" scope="session" />                           
                </c:when>
                <c:otherwise>
                    <c:set var="q1" scope="session" value="${sessionScope.q}" />
                    <c:set var="q1" value="${q1.opted=null}" scope="session" />                             
                </c:otherwise>
            </c:choose>
            <%--28-Aug-2020: Logic to show button for each question--%>
            <c:if test="${not empty submit}">
                <c:choose>
                    <c:when test='${submit eq "Next"}'>
                        <%--I. Increase value of qno by 1 and get question into q--%>
                        <c:set var="qno" scope="session" value="${qno+1}"/> 
                        <c:set var="q" scope="session" value="${sessionScope.al.get(qno)}" />
                    </c:when>
                    <%--J. Same logic is repeated for Previous Button --%>
                    <c:when test='${submit eq "Previous"}'>
                        <c:set var="qno" scope="session" value="${qno-1}"/> 
                        <c:set var="q" scope="session" value="${sessionScope.al.get(qno)}" />
                    </c:when>
                    <c:when test='${submit eq "Finish"}'>
                        <%--K.Finally, when Finish is pressed redirect to ExamServlet--%>
                        <jsp:forward page="Examservlet?op=4"/>
                    </c:when>
                    <%--Means We have pressed Numerical Button Question--%>
                    <c:otherwise>
                        <c:set var="qno" scope="session" value="${qno=(submit.substring(1)-1)}"/> 
                        <c:set var="q" scope="session" value="${sessionScope.al.get(qno)}" />
                    </c:otherwise>
                </c:choose> 
            </c:if>
            <div class="page-header">
                
                <div> 
                    <%--Correction on 28-Aug-2020 Time Bug--%>
                    <c:set var="ctime" scope="page" value="${param.time}" />
                    <c:set var="time" scope="session" value="${not empty ctime?ctime:sessionScope.time}"/>

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
                </div>
                 <h1 style="font-family:serif;">Welcome <c:out value="${sessionScope.sb.userid}"/> </h1>
                 <h4 style="font-family:serif;">CATEGORY: <c:out value="${q.category}"/></h4>
                </div>
                <%--M. get value of variable size and question q from session--%>
                <c:set var="size" scope="session" value="${sessionScope.size}" />

                <%--N. Present the Question to User --%>
                <form class="form" method="post" action="startexam.jsp?qno=${qno}">
                    <div class="panel panel-mycustom">
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
                            <%--<input type="hidden" id="oldqno" name="oldqno" value="${qno}" />--%>
                            <input type="submit" name="submit" value="Previous" style="visibility: ${qno>0 ? "visible": "hidden"};" class="btn btn-primary"/>                  
                            <input type="submit" name="submit" value="Next"  style="visibility: ${qno<size-1? "visible": "hidden"};" class="btn btn-primary"/>                  
                            <input type="submit" name="submit" value="Finish" id="finish" style="visibility: ${qno==size-1? "visible": "hidden"};"  class="btn btn-primary"/>                 
                            <%--28-Aug-2020 Displaying Buttons for Selection Specific Question--%>
                            
                        </div> <%--End of Panel-Footer--%>
                        <%--O. Hidden field to store which checkboxes are checked--%>
                        <%--28-Aug-2020 Time Related Bug Correction--%>
                        <input type="hidden" id="temp" name="temp" value="${q.opted}"/>
                        <input type="hidden" name="time" id="time" value="${time}"/>
                    </div>
                    <div class="page-footer">
                        <c:forEach var="i" begin="0" end="${size-1}" step="1">
                                <input type="submit" class="btn btn-primary" name="submit" id="submit" 
                                       value="Q${i+1}" ${i eq qno ?'disabled':' ' } 
                                       style="background-color:${sessionScope.al.get(i).opted.length()>0?'':'grey'}" />
                            </c:forEach>
                                <a href="startexam_alter.jsp" onclick="switchPage(this)" class="btn btn-primary">Show all together</a>
                       </div>
                </form>
            
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
            $("input[type='checkbox']").change(function () {
                var opted = "";
                var $boxes = $('input[name=option]:checked');
                $boxes.each(function () {
                    opted += $(this).val();
                });
                $("#temp").val(opted);
               // alert(opted);
            });
        });
        </script>
    </body>
</html>
