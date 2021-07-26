
package com.tecdev;
public class SessionBean {
  private String userid, password, usertype,category, dated;
    private int score, correct, wrong, notanswered, examid;
    //Rule III: Should have public default constructor
    public SessionBean(){
        //Initialize for those, who do not know above OCJP concept
        userid=password=category=dated=null;
        score=correct=wrong=notanswered=examid=0;
    }
     public SessionBean(String userid, String password, String usertype)
    {
      //OCJP Calling DC of this first
      this();  //Initialize to default values
      //Assign parameters to following properties
      this.userid=userid;
      this.password=password;
      this.usertype=usertype;
    }

    public String getUserid() {
        return userid;
    }

    public String getUsertype() {
        return usertype;
    }

    public String getCategory() {
        return category;
    }

    public String getDated() {
        return dated;
    }

    public int getScore() {
        return score;
    }

    public int getCorrect() {
        return correct;
    }

    public int getWrong() {
        return wrong;
    }

    public int getNotanswered() {
        return notanswered;
    }

    public int getExamid() {
        return examid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setUsertype(String usertype) {
        this.usertype = usertype;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setDated(String dated) {
        this.dated = dated;
    }
}
