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
            System.out.println("Connected Successfully\n");

            Statement account = con.createStatement();
            Statement transaction = con.createStatement();

            String QUERY1 = "SELECT * FROM Account";
            String QUERY2 = "SELECT * FROM Transactions";

            // Execute queries
            ResultSet accountRS = account.executeQuery(QUERY1);
            ResultSet transactionRS = transaction.executeQuery(QUERY2);

            // Get resultSet metadata from Result set
            ResultSetMetaData accountRSMD = accountRS.getMetaData();
            ResultSetMetaData transactionRSMD = transactionRS.getMetaData();

            // Print the number of Columns
            System.out.println("Number of Columns for Account Table: " + accountRSMD.getColumnCount());

            // Print Column names
            for (int i = 1; i <= accountRSMD.getColumnCount(); i++) {
                System.out.print("Column Name: " + accountRSMD.getColumnName(i) + ", DataType: ");
                System.out.println(accountRSMD.getColumnTypeName(i));
            }
            System.out.print("\n");

            System.out.println("Number of Columns for Transaction Table: " + transactionRSMD.getColumnCount());
            for (int i = 1; i <= transactionRSMD.getColumnCount(); i++) {
                System.out.print("Column Name: " + transactionRSMD.getColumnName(i) + ", DataType: ");
                System.out.println(transactionRSMD.getColumnTypeName(i));
            }
            System.out.println("\n");

            // Close the connection
            account.close();
            transaction.close();
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