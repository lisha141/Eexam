/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tecdev;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.naming.Context;      //JNDI Package
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 *
 * @author ADMIN
 */
public class DatabaseBean {

    private static Connection con;
    private static Statement st;
    private static ResultSet rs;

    static {    //CQ Static Anonymous Block
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            DataSource ds = (DataSource) envContext.lookup("jdbc/myora");
            con = ds.getConnection();
            con.setAutoCommit(false);//Obtain Database Connection
            st=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            //st = con.createStatement();  //Create instance of Statement class
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static ResultSet executeQuery(String sql) {
        try {
            ResultSet rs = st.executeQuery(sql);
            return rs;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static int executeUpdate(String sql) {
        try {
            int result = st.executeUpdate(sql);
            return result;
        } catch (Exception e) {
            System.out.println("execUpdate" + e.toString());
            return 0;
        }

    }

    public static void commit() throws SQLException {
        if (con != null) {
            con.commit();
        }
    }

}
