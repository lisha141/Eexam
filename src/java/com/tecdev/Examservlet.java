package com.tecdev;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
public class Examservlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String op = request.getParameter("op");
        if (op != null) {
            performOperation(op, request, response);
            return;
        }
        String userid = request.getParameter("userid"); //name in html
        String password = request.getParameter("password");
        
        String sql = String.format("Select * from users where userid='%s' and password='%s' ", userid, password);
        // out.print("sql="+sql);
        try {
            ResultSet rs = DatabaseBean.executeQuery(sql);
            if (rs.next()) { //Gives true if user found

                String ut = rs.getString("usertype");
                SessionBean sb = new SessionBean(userid, password, ut);
                Cookie c1 = new Cookie("sb", sb.toString()); //PC: key,value
                c1.setMaxAge(24 * 60 * 60);
                HttpSession session = request.getSession(true);
                session.setAttribute("sb", sb); //key,value

                //Forwarding to mainpage.jsp
                getServletContext().getRequestDispatcher(
                        "/mainpage.jsp").forward(request, response);
            } //move to next page
            else {
                response.sendRedirect("bootstrap-login.jsp");

            }
        } catch (Exception se) {
            PrintWriter out = response.getWriter();
            out.print("process Request " + se.toString());
            se.printStackTrace();
        }
    }

    private void performOperation(String op, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (op) {
            case "1":
                registerUser(op, request, response);
                break;
            case "2":
                registerUser(op, request, response);
                break;
            case "3":
                startExam(request, response);
                break;
            case "4":
                computeResult(request, response);
                break;
            case "5":
                updateQuestion(request, response);
                break;
            case "6":   //07-Sep-2020
                findQuestion(request, response);
                break;
            case "7":
                manageQuestions(request, response);
                break;
            case "8": //09-Sep-2020 Step V
                navigation(request, response);
                break;
            case "9":
                addCategory(request, response);
                break;
            case "10":
                search(request, response);
                break;
            case "11": //18-Sep-2020
                logout(request,response);
                break;
            case "12":
                updateprofile(request,response);
                break;
            case "13":
                  preserveSelected(request,response); //Save State of
                break;  
        }

    }
    private void preserveSelected(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {  
      //Obtain existing session of user to avoid by-passing
      HttpSession session=request.getSession(false);
      //If session not found redirect to login.jsp
      if(session==null){
          response.sendRedirect("bootstrap-login.jsp");
          return;
      }
     //For other cases obtain index and opted sent by JQuery/Ajax
      String index=request.getParameter("index");
      String opted=request.getParameter("opted");
    //Fetch ArrayList 'al' of QuestionBean from session
      ArrayList<QuestionBean>al=(ArrayList)session.getAttribute("al");
      //Convert String index to int index
      int i=Integer.parseInt(index);
     //Set opted value of index i to whatever value of opted sent by JQuery/Ajax
      al.get(i).setOpted(opted);
      //For Debugging Display it in Output Window
      System.out.println("Index=" + index + " Opted=" + opted + " Current Question=" +al.get(i).getOpted());
  }

    private void updateprofile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Collect Request Data
        String operation=request.getParameter("operation");
        String name=request.getParameter("name");
        String mobile=request.getParameter("mobile");
        String userid=request.getParameter("userid");
        //Optionally you can apply validation logic as we applied earlier
        String sql="";  //Local variable - initialized to empty string
        if(operation.equals("add"))
            sql=String.format("insert into candidate values('%s','%s','%s')",userid,name,mobile);
        else
            sql=String.format("update candidate set name='%s', mobile='%s' where userid='%s'",name,mobile,userid);
        int result=0;
        response.setContentType("text/plain");
        PrintWriter out=response.getWriter();
        try {
            result=DatabaseBean.executeUpdate(sql);//Insert/Update/Delete
            if(result>0){
                DatabaseBean.commit();
                out.print("<b>Congrates!! Profile Saved</b><br/>");
              
                out.flush();
            }
        } catch (Exception e) {
            out.print("Exception Occured " + e.getMessage());
            out.flush();
            e.printStackTrace(); //Apache Log Window
        }
    }
    private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      //Obtain existing session of the user
      HttpSession session=request.getSession(false);
      session.removeAttribute("sb"); //sb contains userid,password, usertype
      session.invalidate();  //Make this session invalid
      response.sendRedirect("logout.jsp");
  } 

    private void search(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        PrintWriter out = response.getWriter();
        String value = request.getParameter("v");
        String criteria = request.getParameter("c");
        String sql = String.format("Select * from question where %s='%s' order by qid", criteria, value);
        
         ResultSet rs=null;
     try {
         rs=DatabaseBean.executeQuery(sql);
        
        if(rs.next()){ //Means Data Found
            rs.previous(); //Move Back to First Row
             String table=rsToTable(rs);  //UDF to convert ResultSet to <table>
             out.print(table);   //Send this table back to JQuery =>success fn
             out.flush();
         }
         else{
            out.print("<h3 class='text-center'>Sorry!! No Row Found</h3>");
             out.flush();
         }
     } catch (Exception e) {
         out.print("[searchQuestion] " + e.toString() );
         e.printStackTrace();
     }
    }
    private String rsToTable(ResultSet rs) throws SQLException{
     StringBuilder sb=new StringBuilder(2*1024); //approx 2KB
     //Dynamically create a table
     sb.append("<h3>Results</h3>");
    sb.append("<table border='1' width='100%'>");
     //1st row is heading row
     sb.append("<thead>");
     sb.append("<td>Qid</td>");
     sb.append("<td>Question</td>");
     sb.append("<td>Category</td>");
     sb.append("<td>Option1</td>");
     sb.append("<td>Option2</td>");
     sb.append("<td>Option3</td>");
     sb.append("<td>Option4</td>");
     sb.append("<td>Answer</td>");
     sb.append("<td>QuestionType</td>");    
     sb.append("</thead>");
     //For Subquent rows - Perform a Loop till rows exists in ResultSet
     while(rs.next()){
     sb.append("<tr>");
      //Now create Columns
      sb.append(String.format("<td>%d</td>",rs.getInt("qid")));
      sb.append(String.format("<td>%s</td>",rs.getString("question")));
      sb.append(String.format("<td>%s</td>",rs.getString("category")));
      sb.append(String.format("<td>%s</td>",rs.getString("option1")));
      sb.append(String.format("<td>%s</td>",rs.getString("option2")));
      sb.append(String.format("<td>%s</td>",rs.getString("option3")));
      sb.append(String.format("<td>%s</td>",rs.getString("option4")));
      sb.append(String.format("<td>%s</td>",rs.getString("answer")));
      sb.append(String.format("<td>%s</td>",rs.getString("questiontype")));
     sb.append("</tr>");
     }
     sb.append("</table>");
     return sb.toString(); //Return back table as a String
 }


    private void addCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("bootstrap-login.jsp");
            return;  //Terminate
        }
        String category = request.getParameter("ncategory");
        String sql=String.format("insert into categories values('%s')",category);
        
        int result=0;
        response.setContentType("text/plain");
        PrintWriter out=response.getWriter();
       try {
            result=DatabaseBean.executeUpdate(sql);//Insert/Update/Delete
           if(result>0){
              DatabaseBean.commit();
                out.print("Congrates!!Category Saved.");
              
            }
        } catch (Exception e) {
           out.print("Exception Occured " + e.getMessage());
           out.flush();
            e.printStackTrace(); //Apache Log Window
        }
        
       
    }

    private void manageQuestions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("bootstrap-login.jsp");
            return;  //Terminate
        }
        //Otherwise - User Session Found
        String category = request.getParameter("category");
        // Create an ArrayList of QuestionBean to store group of Question
        ArrayList<QuestionBean> al = new ArrayList<>();
        //get Questions of selected Category using Question Bean class
        al = QuestionBean.getQuestionsList(category, false);
        //Check ArrayList is null, if yes then display message
        if (al == null) {
            PrintWriter out = response.getWriter();
            out.println("Sorry. Questions of " + category + " Not Found");
            return;
        }
        //Otherswise, Store ArrayList of Questions into session
        session.setAttribute("al", al);
        session.setAttribute("size", al.size());
        session.setAttribute("q", al.get(0));  //First Question
        session.setAttribute("qno", 0);    //index of 1st question
        session.setAttribute("category", category);
        //       session.setAttribute("time","00:00:00");
        //Forward User to startexam.jsp page
        this.getServletContext().getRequestDispatcher("/question.jsp").forward(request, response);
    }

    private void navigation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Obtain Existing Session object
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("bootstrap-login.jsp");
            return;
        }
        PrintWriter out = response.getWriter();
        //Imp: You should have to specify content type sending to client
        //Since, default is text/html
        response.setContentType("text/plain");
        //Get current qno, size and arraylist from session object
        int qno = Integer.parseInt(session.getAttribute("qno").toString());
        int size = Integer.parseInt(session.getAttribute("size").toString());
        ArrayList<QuestionBean> al = (ArrayList) session.getAttribute("al");
        // Get choice from request object
        String choice = request.getParameter("choice");
        //Perform operation based on choice
        switch (choice) {
            case "1":
                qno = 0;
                break;//First
            case "2":
                if (qno > 0) {
                    qno--;
                }
                break; //Previous
            case "3":
                if (qno < size - 1) {
                    qno++;
                }
                break;  //next
            case "4":
                qno = size - 1;
                break; //last
        }
        //Obtain Question with index qno from arraylist
        QuestionBean q = al.get(qno);
        //Update Session object with new question and qno index
        session.setAttribute("q", q);  //First Question
        session.setAttribute("qno", qno);    //index of 1st question
        //Send this data in form of String (text/plain) to JQuery/Ajax
        out.println(q.toString());  //Override toString in QuestionBean

        out.flush();
    }

    private void findQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Collect qid1 from request object
        String qid = request.getParameter("qid1");
        PrintWriter out = response.getWriter();
        response.setContentType("text/plain");
        QuestionBean qb = new QuestionBean();
        if (qb.select(qid) == null) {
            out.println("Sorry!!! No Qid Found");
            out.flush();
            return;
        }
        out.println(qb.toString());
        out.flush();         //Flush/Transfer data to client without closing stream    
    }

    private void updateQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String operation = request.getParameter("operation");
        if (operation == null || operation.trim().length() == 0) //Avoid By-Passing
        {
            response.sendRedirect("bootstrap-login.jsp");
            return;
        }
        PrintWriter out = response.getWriter();

        String qid1 = request.getParameter("qid");
        String question = request.getParameter("question");
        String option1 = request.getParameter("option1");
        String option2 = request.getParameter("option2");
        String option3 = request.getParameter("option3");
        String option4 = request.getParameter("option4");
        String category = request.getParameter("category");
        String answer = request.getParameter("answer");
        String questiontype = request.getParameter("questiontype");
        int qid = 0;  //Initializing local variable
        if (qid1 != null && qid1.trim().length() > 0) //To avoid NullPointerException
        {
            qid = Integer.parseInt(qid1);
        }
        //Create local objec to Question Bean to execute Query
        QuestionBean qb = new QuestionBean(qid, question, category, option1, option2, option3, option4, answer, questiontype);
        int result = 0;
        if (operation.equals("add")) {
            result = qb.insert();
        } else {
            result = qb.update();
        }
        //Use of M: Model
        HttpSession session = request.getSession(false);

        if (result > 0) {
            session.setAttribute("msg", "Question Saved Successfully");
        } else {
            session.setAttribute("msg", "Sorry! Failed to Save. Try Again");
        }

        request.getRequestDispatcher("/question.jsp").forward(request, response);

    }

    private void registerUser(String op, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Fetch data submit by the client using request
        String userid = request.getParameter("userid");
        String password = request.getParameter("password");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");
        //Generate Embeded insert query
        String sql = "";    //Local Variable
        if (op.equals("2")) //Register
        {
            sql = String.format("insert into users values('%s', '%s', 'C','%s','%s')", userid, password, question, answer);  //24-Aug-2020
        } else //Forgotten Password -26-Aug-2020
        {
            sql = String.format("update users set password='%s' where userid='%s' and question='%s' and answer='%s'", password, userid, question, answer);
        }

        //String sql=String.format("insert into users values('%s', '%s', 'C','%s','%s')",userid,password,question,answer);
        //PrintWriter out=response.getWriter();
        //out.println(op+" "+sql);
        try {
            int result = DatabaseBean.executeUpdate(sql);
            if (result > 0) //Means Row inserted
            {
                DatabaseBean.commit(); //Save Permanently
                //Addition logic added on 24-Aug-2020 for dynamic message
                //Create session object
                HttpSession session = request.getSession(true);
                //Pass congrats message with key: msg
                if (op.equals("2")) //Register
                {
                    session.setAttribute("msg", "Congrates. Your Account Registered Successfully. <br/> Now login to give exam");
                } else {
                    session.setAttribute("msg", "Congrates. Your Password Updated Successfully. <br/> Now login to give exam");
                }

                response.sendRedirect("bootstrap-login.jsp");
            } else {
                response.sendRedirect("failure.html");
            }
        } catch (Exception e) {
            System.out.println("[registerUser" + e);
            e.printStackTrace();
        }
    }

    private void computeResult(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("bootstrap-login.jsp");
            return;
        }
        SessionBean sb = (SessionBean) session.getAttribute("sb");
        String userid = sb.getUserid();
        String category = (String) session.getAttribute("category");
        ArrayList<QuestionBean> al = (ArrayList<QuestionBean>) session.getAttribute("al");
        int examid = QuestionBean.calculate(userid, category, al);
        PrintWriter out = response.getWriter();
        //out.println("Your examid is: " + category);
         if (examid == -1) {
            out.println("Some, error occured at Database End. Contact With DB Administrator");
        }
       else if (examid < -1) { //Means failed
            out.println("Sorry!! You are failed in Exam");
            out.println("<br/>You Exam Id is<b> " + Math.abs(examid) + "</b>");
            out.println("<br/>Better Luck Next Time");
            out.println("<a href='bootstrap-login.jsp'>Login Again and Retry</a>");
        } else {    //Means Passed the exam
            String msg = String.format("Congrates!! You've passed the Exam. Your Exam Id is %d ", examid);
            out.println(msg);
            msg = String.format("<a href='certificate.jsp?userid=%s&examid=%d' class='btn btn-primary'>Generate Certificate</a>", userid, examid);
            out.println(msg);
            out.flush();
        }
        //this.getServletContext().getRequestDispatcher("/certificate.jsp").forward(request, response);
    }

    private void startExam(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Step IV: Obtain SessionBean object to verify user have
        //Logged in Successfully or not
        //false: Session must exist, do not create new session
        HttpSession session = request.getSession(false);
        if (session == null) {  //Somebody try to bypass login (session not found)
            response.sendRedirect("bootstrap-login.jsp");
            return;  //Terminate
        }

        String category = request.getParameter("category");

        ArrayList<QuestionBean> al = new ArrayList<>(); //OCJP: Diamond Operator - Java 7

        al = QuestionBean.getQuestionsList(category);
           if (al == null) {    //Old Logic as it is [When table not created]
            PrintWriter out = response.getWriter();
            out.println("Sorry!!! question table may not exists in Oracle");
            return;
        }
        //24-Sep-2020 - Extra logic when arraylist isEmpty() [or size()==0]
        if(al.isEmpty()){  
            //   if(al.size()==0){
            session.setAttribute("msg","Sorry. No Question Found for this category");
            request.getRequestDispatcher("/mainpage.jsp?msg=Sorry. No Question Found for "+ category).forward(request, response);
        }
        session.setAttribute("al", al);  //Stateful: key,value
        //response.sendRedirect("/tablequestions.jsp");
        session.setAttribute("size", al.size()); //Size of ArrayList
        session.setAttribute("qno", 0); //Set Current qno index to 0 (1st question)
        session.setAttribute("q", al.get(0));  //Assign 1st question to variable q
       session.setAttribute("category",category);
        session.setAttribute("time", "00:00:00");
        
        this.getServletContext().getRequestDispatcher("/startexam_alter.jsp").forward(request, response);

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
