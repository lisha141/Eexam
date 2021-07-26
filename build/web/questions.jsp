<%@page contentType="text/html"
        import="java.sql.*, com.tecdev.*"
        pageEncoding="UTF-8"
        session="true"
        errorPage="error.jsp"  
        %>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>eExam App-Questions Page</title>
        <meta charset="UTF-8">
        <!--Backward compatible with Internet Explorer 8.0-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!--Responsive Apps, Size adjusted as per device size-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--Add Bootstrap CSS Before any other custom css -->
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
        <!-- Linking css File with html -->
        <link rel="stylesheet" type="text/css" href="css/style1.css"/>
    </head>
    <body>
        <div class="container">
            <c:set var="msg" scope="session" value="${sessionScope.msg}" />
            <div class="well well-sm text-center" id="msg">${empty msg?"QuestionsEntry Page":msg}</div>
            <c:if test="${not empty msg}">
                <c:remove var="msg" scope="session"/> <%--Semaphore--%>
            </c:if>          
            <div class="row">
                <div class="panel panel-primary">
                    <form id="form1" class="form" method="post" action="ExamServlet?op=5">
                        <div class="panel-heading text-center">
                            <h1>Questions Entry</h1>
                        </div>             
                        <div class="panel-body">
                            <div class="form-group">
                                <div class="col-xs-3 text-right"> <label for="category">Category</label></div>
                                <div class="col-xs-6"><select disabled name="category" class="form-control" id="category">
                                        <%
                                            ResultSet rs = DatabaseBean.executeQuery("select category from categories order by category");
                                            String value = "";
                                            String tag = "";
                                            while (rs.next()) {       //Gives true till row found
                                                value = rs.getString("category");
                                                tag = String.format("<option value='%s'>%s</option>", value, value);
                                                out.print(tag);
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="col-xs-3">
                                    <input class="form-control btn btn-primary" name="submit" id="add" type="button" value="Add" /></div>                                        
                            </div>
                            <div class="form-group">
                                <div class="col-xs-3 text-right"><label for="qid">Question Id [Read Only]</label></div>
                                <div class="col-xs-6"><input type="text" class="form-control" id="qid" name="qid" value="1" readonly/></div>
                                <div class="col-xs-3">
                                    <input class="form-control btn btn-primary" name="submit" id="edit" type="button" value="Edit" /></div>                                        
                            </div>
                            <div class="form-group">
                                <div class="col-xs-3 text-right"><label for="question">Question Text</label></div>
                                <div class="col-xs-6"><input disabled type="text" class="form-control" id="question" name="question" value="" required/></div>
                                <div class="col-xs-3">
                                    <input class="form-control btn btn-default" name="submit" id="save" type="submit" value="Save" disabled /></div>                                        
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-xs-3 text-right"><label for="option1">Option1</label></div>
                            <div class="col-xs-6"><input disabled type="text" class="form-control" id="option1" name="option1" required/></div>                          
                            <div class="col-xs-3"><input class="form-control btn btn-default" name="submit" id="cancel" type="button" value="Cancel" disabled /></div>                                        
                        </div>
                        <div class="form-group">
                            <label for="option2">Option2</label>
                            <input disabled type="text" class="form-control" id="option2" name="option2" required/>                           
                        </div>
                        <div class="form-group">
                            <label for="option3">Option3</label>
                            <input disabled type="text" class="form-control" id="option3" name="option3" required/>                           
                        </div>
                        <div class="form-group">
                            <label for="option4">Option4</label>
                            <input disabled type="text" class="form-control" id="option4" name="option4" required/>                           
                        </div>
                        <div class="form-group">
                            <label for="answer">Answer [Enter in form of correct option like 1234]</label>
                            <input disabled type="text" class="form-control" id="answer" name="answer" required/>                           
                        </div>
                        <div class="form-group">
                            <label for="questiontype">Select Type of Question it is</label>
                            <select disabled name="questiontype" id="questiontype" size="1" required>
                                <option value="T" selected>Text</option>
                                <option value="I">Image</option>
                                <option value="V">Video</option>
                                <option value="A">Audio</option>
                                <option value="O">Other</option>
                            </select>
                        </div>
                        <div class="panel-footer">
                            <div class="row">
                                <%--Step II 09-Sep-2020 Changed type=button--%>
                                <div class="col-xs-2 col-xs-offset-1">  <input class="form-control btn btn-primary" name="submit" id="first" type="button" value="First" /></div>
                                <div class="col-xs-2"> <input class="form-control btn btn-primary" name="submit" id="previous" type="button" value="Previous" /></div>
                                <div class="col-xs-2">  <input class="form-control btn btn-primary" name="submit" id="next" type="button" value="Next" /></div>
                                <div class="col-xs-2"> <input class="form-control btn btn-primary"  name="submit" id="last" type="button" value="Last" /></div>
                                <div class="col-xs-2">                                   
                                    <input class="form-control btn btn-primary" name="submit" id="find" type="button" value="Find" />
                                </div>
                            </div>
                            <input type="hidden" id="operation" name="operation" value="" />
                            <%--Step I: 09-Sep-2020--%>
                            <input type="hidden" id="qno" name="qno" value="${sessionScope.qno}" />
                        </div>   
                    </form>                   
                </div>
            </div>
        </div>
        <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.min.js"></script>
        <script>
            //Below Fn called only when DOM is Ready
            jQuery(document).ready(
                    function () {
                        //Register Click Event on [Add] 
                        $("#add").on('click', addClick);
                        $("#edit").on('click', editClick);
                        $("#cancel").on('click', cancelClick);
                        $("#find").on('click', findClick);
                        //Step III 09-Sep-2020 Event Registration
                        $("#first").on('click', function () {
                            navigationClick(1);
                        });
                        $("#previous").on('click', function () {
                            navigationClick(2);
                        });
                        $("#next").on('click', function () {
                            navigationClick(3);
                        });
                        $("#last").on('click', function () {
                            navigationClick(4);
                        });
                    }); //End of ready fn 

            //Step IV: 09-Sep-2020 Coding of navigationClick
            function navigationClick(n) {
                var myurl = "ExamServlet?op=8&choice=" + n;
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                        //Convert comma seperated data to array
                        var array = data.split(",");
                        //User-Defined Fn to Display data
                        arrayToText(array)
                        //alert("All is Well = " + data);
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + excepttion);
                    }
                });
            }
            //07-Sep-2020
            function findClick() {
                alert('Find Pressed');
                //Ask client to input/prompt qid at runtime 
                var qid = prompt("Enter Qid to Search");
                //Check if cancel pressed or nothing entered
                if (qid == null || qid.trim().length == 0) {
                    return false; //Terminate Fn
                }
                var myurl = "ExamServlet?op=6&qid1=" + qid;
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                        //Convert comma seperated data to array
                        var array = data.split(",");
                        //User-Defined Fn to Display data
                        arrayToText(array)
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + excepttion);
                    }
                });
            }
            //User-Defined Fn to Display Data inside UI
            function arrayToText(array) {
                $("#qid").val(array[0]);
                $("#question").val(array[1]);
                //$("#category").val(array[2]);
                var select = "#category option[value='" + array[2] + "']";
                $(select).attr("selected", "selected");
                $("#option1").val(array[3]);
                $("#option2").val(array[4]);
                $("#option3").val(array[5]);
                $("#option4").val(array[6]);
                $("#answer").val(array[7]);
                // $("#questiontype").val(array[8]);
                select = "#questiontype option[value='" + array[8] + "']";
                $(select).attr("selected", "selected");
            }
            function addClick() {
                makeEditable();
                makeEmpty();
                $("#operation").val("add");
                alert("Value of Hidden Field is " + $("#operation").val());
            }
            function editClick() {
                makeEditable();
                $("#operation").val("edit");
            }
            function makeEditable() {
                var $boxes = $(":text,select");
                $boxes.each(function () {
                    $(this).removeAttr('disabled');
                });
                //Activate save and cancel buttons
                $("#save").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#cancel").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                //Disable Add and Edit Buttons
                $("#add").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#edit").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
            }
            function makeEmpty() {
                $(":text, textarea").val("");
            }
            function cancelClick() {
                //Using JQuery Select find all text and select fields
                var $boxes = $(":text,select");
                //Now add attribue disabled
                $boxes.each(function () {
                    $(this).attr('disabled', 'disabled'); //key,value
                });
                //Activate Add and Edit buttons
                $("#add").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#edit").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                //De-Activate Save and Cancel Buttons
                $("#save").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#cancel").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
            }
        </script>
    </body>
</html>
