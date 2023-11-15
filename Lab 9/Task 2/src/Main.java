import java.sql.*;

public class Main {


    public static void main(String[] args) {

        try
        {
            // Establish Connection to the database

            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url= "jdbc:oracle:thin:@localhost:1521:xe";
            String username= "c_210042172";
            String password= "cse4308";
            Connection con = DriverManager.getConnection(url, username, password);
            System.out.println("Connected Successfully");

            // Create the statement object as prepared
            PreparedStatement ps1= con.prepareStatement ("INSERT INTO TRANSACTIONS VALUES (? ,? ,? ,?, ?)") ;

            // Updating object data
            ps1.setInt (1 , 10001); ;
            ps1.setDate (2 , new Date(2022, 2, 12)); ;
            ps1.setInt (3 , 2); ;
            ps1.setInt (4 , 5000); ;
            ps1.setString (5 , "1") ;
            ps1.executeUpdate () ;

            PreparedStatement ps2 = con.prepareStatement ("INSERT INTO TRANSACTIONS VALUES (? ,? ,? ,?, ?)") ;
            ps2.setInt (1 , 10005); ;
            ps2.setDate (2 , new Date(2022, 10, 15)); ;
            ps2.setInt (3 , 4); ;
            ps2.setInt (4 , 10000); ;
            ps2.setString (5 , "0") ;
            ps2.executeUpdate () ;

            System.out.println("Data inserted successfully!");

            // Close the connection
            ps1.close();
            ps2.close();
            con.close();
        }
        catch (SQLException e)
        {
            System.out.println("Connection failed Exception: " + e);
        }
        catch (ClassNotFoundException e)
        {
            System.out.println("JDBC driver not found Exception: " + e);
        }
    }
}