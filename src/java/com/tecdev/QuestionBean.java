/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tecdev;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import javax.swing.JOptionPane;

public class QuestionBean {

    private int qid;
    private String question, category;
    private String option1, option2, option3, option4, answer;
    private String opted;
    private String questionType;
    private static int qno;

    public QuestionBean() {
        opted = "";
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public QuestionBean(int qid, String question, String category, String option1, String option2, String option3, String option4, String answer, String qt) {
        this.qid = qid;
        this.question = question;
        this.category = category;
        this.option1 = option1;
        this.option2 = option2;
        this.option3 = option3;
        this.option4 = option4;
        this.answer = answer;
        this.opted = "";
        this.questionType =qt;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getAnswer() {
        return answer;
    }

    public int getQid() {
        return qid;
    }

    public void setQid(int qid) {
        this.qid = qid;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getOption1() {
        return option1;
    }

    public void setOption1(String option1) {
        this.option1 = option1;
    }

    public String getOption2() {
        return option2;
    }

    public void setOption2(String option2) {
        this.option2 = option2;
    }

    public String getOption3() {
        return option3;
    }

    public void setOption3(String option3) {
        this.option3 = option3;
    }

    public String getOption4() {
        return option4;
    }

    public void setOption4(String option4) {
        this.option4 = option4;
    }

    public String getOpted() {
        return opted;
    }

    public void setOpted(String opted) {
        this.opted = opted;
    }
    public static void setQno(int qno){
        QuestionBean.qno=qno;
    }
    public static int getQno(){
        return QuestionBean.qno;
    }
    public static void increase(){  qno++; }
public static void decrease(){qno--; }

    public static ResultSet getQuestions(String category) {
        //Edited on 14-09-2020 
        String sql="Select * from Question ";
        //Check if some category provided to this fn then apply where clause
        if(category!=null)  //Concat with existing query
          sql+= String.format(" where category='%s'", category);
        ResultSet rs = null;   //Local Variable
        try {
            rs = DatabaseBean.executeQuery(sql);
            return rs;      //Return ResultSet
        } catch (Exception e) {
            System.out.println("get Questions " + e);
            e.printStackTrace();
            return null;  //OCJP - What we can return instead of an Object
        }
    }

    public static ArrayList<QuestionBean> getQuestionsList(String category,boolean shuffle) {
        ArrayList<QuestionBean> al = new ArrayList<>();
        try {
            //Code Reusability - Select Questions of given Category
            ResultSet rs = getQuestions(category); //Calling fn inside another fn
            //Local Variables to store value
            int qid;
            String question, op1, op2, op3, op4, ans, qt;
            //Fetch Rows from resultset and transfer to arraylist
            while (rs.next()) {      //Gives true till row found
                qid = rs.getInt("qid");     //rs.getInt("columnName")
                question = rs.getString("question");
                op1 = rs.getString("option1");  //"option1" - columnName
                op2 = rs.getString("option2");
                op3 = rs.getString("option3");
                op4 = rs.getString("option4");
                ans = rs.getString("answer");
                qt = rs.getString("questiontype"); 
                category=rs.getString("category");//27-Jul-2020
                //Adding Question into ArrayList using Anonymous Object
                al.add(new QuestionBean(qid, question, category, op1, op2, op3, op4, ans, qt));  //Calling PC with 9 Parameters
            }  //while
             //Step V: 14-Sep-2020 We have to decide shuffle or not
            if(shuffle){   //OR if(shuffle==true)
               Collections.shuffle(al);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "[getQL]" + e.toString());
            e.printStackTrace();
            return null;
        }
        return al;
    }
    public static ArrayList<QuestionBean> getQuestionsList(String category){// throws SQLException {
        //We are calling the new Overloaded fn with both category
        //and shuffle true
        //In startexam.jsp=> we require shuffle=>true
        //In question.jsp=>We require shuffle=>false
        return getQuestionsList(category,true);
    }
    public static int calculate(String userid,String category,ArrayList<QuestionBean> al){
        int maxQuestions=al.size();
        int correct=0,wrong=0,notanswered=0,score=0;
        QuestionBean q;
        for(int i=0;i<maxQuestions;i++){
            q=al.get(i);
            if(q.getOpted().length()==0)
                notanswered++;
            else if(q.getOpted().equals(q.getAnswer()))
                correct++;
            else
                wrong++;
        }
        score=correct*4-wrong;
        double percent=(score*100)/(4.0*maxQuestions);
        String sql=String.format("Insert into exam values('%s',sysdate,'%d','%d','%d','%d','%s',examid_seq.nextval,'%.2f')",userid,score,correct,wrong,notanswered,category,percent);
        System.out.println(sql);
        int examid=1;
        try{
            int result=DatabaseBean.executeUpdate(sql);
            if(result>0)
            {
                DatabaseBean.commit();
                sql=String.format("Select examid from exam where userid='%s' and to_char(dated,'dd-mon-yy')=to_char(sysdate,'dd-mon-yy') and category='%s' order by examid desc",userid,category);
                ResultSet rs=DatabaseBean.executeQuery(sql);
                if(rs.next())
                examid=rs.getInt(examid);
                //JOptionPane.showMessageDialog(null,userid+" your score saved Successfully");
                System.out.println(userid+" your score saved!");
                 if(percent<65)   //Step II: 21-Sep
                   return -1*examid;  //Convert to -ive value
               return examid;  
                
            }
        }
        catch(Exception e){
         //JOptionPane.showMessageDialog(null,"[calculate] "+e);
         System.out.println(e);
                return -1;   
        }
        return examid;
    }
  public int insert(){
        String sql=String.format("insert into question values(qid_seq.nextval,'%s', '%s' , '%s' , '%s', '%s' , '%s' , '%s' , '%s')",question,category,option1,option2,option3,option4,questionType,answer);
        System.out.println("SQL=" + sql);
        int result=0;
        try {
            result=DatabaseBean.executeUpdate(sql);
            if(result>0)
                DatabaseBean.commit();
        } catch (Exception e) {
            System.out.println("[QB-insert]" + e);
            e.printStackTrace();
            return 0;   //Failed to Save
        }
        return result;  //>0 when row inserted successfully
       
    }
  public int update(){
      String sql=String.format("update question set question='%s' , category='%s',option1='%s', option2='%s',option3='%s', option4='%s', answer='%s' , questiontype='%s' where qid='%d' " ,question, category, option1,option2,option3,option4, answer, questionType, qid);
        System.out.println("SQL=" + sql);
        int result=0;
        try {
            result=DatabaseBean.executeUpdate(sql);
            if(result>0)
                DatabaseBean.commit();
        } catch (Exception e) {
            System.out.println("[QB-Update]" + e);
            e.printStackTrace();
            return 0;   //Failed to Save
        }
        return result;  //>0   
  }
public QuestionBean select(String qid){
        this.qid=Integer.parseInt(qid);
        String sql=String.format("Select * from Question where qid='%d'", this.qid);
        ResultSet rs=null;
        try {
            rs=DatabaseBean.executeQuery(sql);
            if(rs.next()){
                this.question=rs.getString("question");
                this.category=rs.getString("category");
                this.option1=rs.getString("option1");
                this.option2=rs.getString("option2");
                this.option3=rs.getString("option3");
                this.option4=rs.getString("option4");
                this.answer=rs.getString("answer");
                this.questionType=rs.getString("questionType");
            }
        } catch (Exception e) {
            System.out.println("[QB Select ] " + e);
            e.printStackTrace();
            return null;
        }
        return this;  //Means Current Object of the Class
    }
@Override
    public String toString(){
        String data=String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s",qid,question,category,option1,option2,option3,option4,answer,questionType);
        System.out.println("JSon Array=" + data);
        return data;
    }
}
