package com.tecdev;

import java.sql.*;
import java.util.Properties;
import java.io.InputStream;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class DBConnection {

    private static Connection con;
    private static Statement st;

    static {
        try {
            Properties p = new Properties();
            InputStream in = DBConnection.class.getResourceAsStream("Settings.properties");
            if (in == null) {
                throw new Error("InputStream not found");
            }
            p.load(in);
            String username = p.getProperty("username");
            String password = p.getProperty("password");
            String url = p.getProperty("url");
            String drivername = p.getProperty("drivername");
            Class.forName(drivername).newInstance();
            con = DriverManager.getConnection(url, username, password);
            st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            con.setAutoCommit(false);

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Unable to connect" + e.toString());

        }
    }

    public static void close() {
        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Unable to close" + e.toString());
        }

    }

    public static ResultSet executeQuery(String sql) throws SQLException {
        ResultSet rs = st.executeQuery(sql);
        return rs;
    }

    public static int executeUpdate(String sql) throws SQLException {
        int result = st.executeUpdate(sql);
        return result;
    }

    public static DefaultTableModel prepareTable(ResultSet rs) throws SQLException {
        DefaultTableModel d;
        d = new DefaultTableModel();
        ResultSetMetaData metadata = rs.getMetaData();
        int colCount = metadata.getColumnCount();
        String[] colNames = new String[colCount];
        for (int i = 1; i <= colCount; i++) {
            colNames[i - 1] = metadata.getColumnName(i);
        }
        //colCount=metadata.getColumnCount();

        d.setColumnIdentifiers(colNames);
        while (rs.next()) {
            String[] rowData = new String[colCount];
            for (int i = 0; i < colCount; i++) {
                rowData[i] = rs.getString(i + 1);
            }
            d.addRow(rowData);

        }
        return d;
    }

    public static void commit() throws SQLException {
        con.commit();
    }

}
