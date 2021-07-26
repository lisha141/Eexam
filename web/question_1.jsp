<%-- 
    Document   : question
    Created on : 31 Aug, 2020, 7:25:08 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html"
        import="com.tecdev.*,java.sql.*,java.util.*"
        pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Questions | eExam</title>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css folder/bootstrap.css" type="text/css">
    </head>
    <style>
        .btn{
            background-color:  #009999;
        }
    </style>
    <body>
        <div class="container">
            <c:set var="msg" scope="session" value="${sessionScope.msg}" />
            <div class="well well-sm text-center" id="msg">${empty msg?"Welcome in eExam":msg}</div>
            <%--26-Aug-2020-- Removing msg variable if set--%>
            <c:if test="${not empty msg}">
                <c:remove var="msg" scope="session"/> <%--Semaphore--%>
            </c:if>
            <span>&nbsp;</span> 
            <form class="form" method="post" action="Examservlet?op=5">
                <div class="panel panel-default">
                     
                    <div class="panel-heading text-center">
                        <h1><span class="label label-default">Questions</span></h1> 
                    </div>
                    <div class="panel panel-body">
                        <div class="row">
                            <div class="col-xs-3 col-sm-2 text-right">

                                <label>Category</label>
                            </div>
                            <div class="col-xs-9 col-sm-7">
                                <select  disabled name="category" class="form-control" id="category">
                                    <%
                                        ResultSet rs = DatabaseBean.executeQuery("select category from categories order by category");
                                        // rs.first();
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
                            <div class="col-xs-6 col-sm-2 pull-right">
                                <input type="button" id="add" class="form-control btn btn-primary" value="Add"/>
                            </div>
                        </div>
                        <span>&nbsp;</span>
                        <div class="row">
                            <div class="col-xs-3 col-sm-2 text-right">
                                <label>Question-Id</label>
                            </div>
                            <div class="col-xs-9 col-sm-7">
                                <input disabled id="qid" name="qid" class="form-control" readonly="true"/>
                            </div>
                            <div class="col-xs-6 col-sm-2 pull-right">
                                <input type="submit" disabled id="save" class="form-control btn btn-default" value="Save"/>
                            </div>
                        </div>
                        <span>&nbsp;</span>
                        <div class="row">
                            <div class="col-xs-3 col-sm-2 text-right">
                                <label>Question</label>
                            </div>
                            <div class="col-xs-9 col-sm-7">
                                <input required disabled id="question" name="question" class="form-control" required placeholder="Enter Question here" type="text"/>
                            </div>
                            <div class="col-xs-6 col-sm-2 pull-right">
                                <input type="button" id="edit" class="form-control btn btn-primary" value="Edit"/>
                            </div>
                        </div>
                        <span>&nbsp;</span>
                        <div class="row">
                            <div class="col-sm-6 col-md-3">
                                <label>Option 1</label>
                                <input disabled id="option1" name="option1" class="form-control" required placeholder="option 1" type="text"/>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <label>Option 2</label>
                                <input disabled id="option2" name="option2" class="form-control" required placeholder="option 2" type="text"/>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <label>Option 3</label>
                                <input disabled id="option3" name="option3" class="form-control" required placeholder="option 3" type="text"/>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <label>Option 4</label>
                                <input disabled id="option4" name="option4" class="form-control" required placeholder="option 4" type="text"/>
                            </div>
                        </div>
                        <span>&nbsp;</span>
                        <div class="row">
                            <div class="col-xs-12 col-md-6">
                                <label>Answer</label>
                                <input disabled id="answer" name="answer" class="form-control" required placeholder="Correct answer" type="text"/>
                            </div>
                            <div class="col-xs-12 col-md-6">
                                <label>Question Type</label>
                                <select disabled name="questiontype" class="form-control" id="questiontype">
                                    <%
                                        ResultSet rs1 = DatabaseBean.executeQuery("select distinct questiontype from question order by questiontype");
                                        // rs.first();
                                        String value1 = "";
                                        String tag1 = "";
                                        while (rs1.next()) {       //Gives true till row found
                                            value1 = rs1.getString("questiontype");
                                            tag1 = String.format("<option value='%s'>%s</option>", value1, value1);
                                            out.print(tag1);
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-footer">
                        <div class="col-xs-6 col-sm-2">
                            <input type="button" name="submit" class="form-control btn btn-primary" id="first" value="First"/>
                        </div>

                        <div class="col-xs-6 col-sm-2">
                            <input type="button" name="submit" class="form-control btn btn-primary" id="next" value="Next"/>
                        </div>
                        

                        <div class="col-xs-6 col-sm-2">
                            <input type="button" name="submit" class="form-control btn btn-primary" id="previous" value="Previous"/>
                        </div>
                        
                        <div class="col-xs-6 col-sm-2">
                            <input type="button" name="submit" class="form-control btn btn-primary" id="last" value="Last"/>
                        </div>
                        
                        <div class="col-xs-6 col-sm-2">
                <input type="button" id="cancel" disabled class="form-control btn btn-default" value="Cancel"/>
                        </div>
                         
                        <div class="col-xs-6 col-sm-2">
                <input class="form-control btn btn-primary" name="submit" id="find" type="button" value="Find"/>
                        </div>
                        <span>&nbsp;</span>
                    </div>
                </div>
               <input type="hidden" id="operation" name="operation" value=""/>
               <input type="hidden" id="qno" name="qno" value="${sessionScope.qno}" />
            </form>
        </div>
        <script src="script/jquery-3.4.1.min.js"></script>
        <script src="script/bootstrap.js"></script> 
        <script>
            jQuery(document).ready(
                    function () {
                        //Register Click Event on [Add]
                        $("#add").on('click', addClick);
                        $("#edit").on('click', editClick);
                        $("#cancel").on('click', cancelClick);
                         $("#find").on('click', findClick);
                         $("#first").on('click', function (){  
                             navigationClick(1); });
                        $("#previous").on('click', function (){  
                            navigationClick(2); });
                        $("#next").on('click', function (){  
                            navigationClick(3); });
                        $("#last").on('click', function (){  
                            navigationClick(4); });
                           navigationClick(4);
                    }); //End of ready fn
                      function navigationClick(n) {
                          
                 //Passing value n to the choice variable
               var myurl = "Examservlet?op=8&choice=" + n;
                $.ajax({             /*Java - Map: Key/Value Pair*/
                    url: myurl,     /*JSON - JavaScript Object Notation*/
                    async: false,
                    type: 'POST',         /*i.e method="post" */
                    success: function (data) {  //Get data from Servlet
                        //Convert comma seperated data to array
                     var array = data.split(",");
                        //User-Defined Fn to Display data
                      arrayToText(array)
                        alert("All is Well = " + data);
                    },
                  error: function (jqXHR, exception) {
                       console.log('arrayToText Exception ' + excepttion);
                    }
                });
            }        
                     function findClick() {
                //Ask client to input/prompt qid at runtime
                var qid = prompt("Enter Qid to Search");
                //Check if cancel pressed or nothing entered
                if (qid == null || qid.trim().length == 0) {
                    return false; //Terminate Fn
                }
                var myurl = "Examservlet?op=6&qid1=" + qid;
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
                //User-Defined Fn to Display Data inside UI-07-Sep-2020
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
                //alert("Value of Hidden Field is " + $("#operation").val());

            }
            function editClick() {
                makeEditable();
                $("#operation").val("edit");
                // alert("Value of Hidden Field is " + $("#operation").val());
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
                $("#first").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#next").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#previous").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#last").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
            }
            function makeEmpty() {
                //$("input[type=text], textarea"). val("");
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
                $("#first").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#next").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#previous").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#last").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
    }
        
        </script>

    </body>
</html>
