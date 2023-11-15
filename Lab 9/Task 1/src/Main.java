import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Main {

    public static List<Transaction> transactions = new ArrayList<>();
    public static List<Account> accounts = new ArrayList<>();

    static int cip= 0;
    static int vip=0;
    static int ordinary= 0;
    static int total= 0;

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
            Statement stmt = con.createStatement();

            String QUERY = "SELECT A_ID, Amount, Type FROM Transactions";
            ResultSet rs = stmt.executeQuery(QUERY);

            // Store Transactions Table data to the transactions array as well as print the data
            while (rs.next()) {

                int id= rs.getInt("A_ID");
                int amount=  rs.getInt("Amount");
                String type= rs.getString("Type");
                Transaction transaction= new Transaction(id,amount,type);
                transactions.add(transaction);

                System.out.print("Account ID: " + rs.getInt("A_ID"));
                System.out.print(", Amount: " + rs.getInt("Amount"));
                System.out.print(", Type: " + rs.getString("Type"));
                System.out.println("\n");
            }

            // Store Account Table data to the accounts array
            String QUERY0 = "SELECT * FROM ACCOUNT";
            ResultSet rs0 = stmt.executeQuery(QUERY0);
            while (rs0.next()) {
                Account account = new Account(rs0.getInt("A_ID"));
                accounts.add(account);
            }

            // Count total number of accounts
            String QUERY1 = "SELECT Count(*) FROM Account";
            ResultSet rs1 = stmt.executeQuery(QUERY1);
            while (rs1.next()) {
                total= rs1.getInt(1);
                System.out.println("Total Number of Accounts: " + rs1.getInt(1));
            }

            // For every account set the final Balance
            for (Transaction transaction : transactions) {
                for (Account account : accounts) {
                    if (transaction.getA_ID() == account.getA_ID()) {
                        if (transaction.getT_TYPE().equals("0")) {
                            account.setBalance(account.getBalance() + transaction.getT_AMOUNT());
                        } else {
                            account.setBalance(account.getBalance() - transaction.getT_AMOUNT());
                        }
                    }
                }
            }

            int totalTransaction= 0;
            // Get the count of CIP accounts
            for (Account account : accounts) {
                for (Transaction transaction : transactions) {
                    if (transaction.getA_ID() == account.getA_ID()) {
                        if (account.getBalance() > 1000000) {
                            totalTransaction += transaction.getT_AMOUNT();

                            if (totalTransaction > 5000000) {
                                cip++;
                            }
                        }
                    }
                }
            }

            totalTransaction= 0;
            // Get the count of VIP accounts
            for (Account account : accounts) {
                for (Transaction transaction : transactions) {
                    if (transaction.getA_ID() == account.getA_ID()) {
                        if (account.getBalance() > 500000 && account.getBalance() < 900000) {
                            totalTransaction += transaction.getT_AMOUNT();

                            if (totalTransaction > 2500000 && totalTransaction< 4500000) {
                                vip++;
                            }
                        }
                    }
                }
            }

            totalTransaction = 0;
            // Get the count of Ordinary accounts
            for (Account account : accounts) {
                for (Transaction transaction : transactions) {
                    if (transaction.getA_ID() == account.getA_ID()) {
                        if (account.getBalance() < 100000) {
                            totalTransaction += transaction.getT_AMOUNT();

                            if (totalTransaction < 1000000) {
                                ordinary++;
                            }
                        }
                    }
                }
            }

            System.out.println("CIP Accounts: " + cip);
            System.out.println("VIP Accounts: " + vip);
            System.out.println("Ordinary Accounts: " + ordinary);
            System.out.println("Uncategorized Accounts: " + (total- cip-vip-ordinary));  

            rs.close();
            rs0.close();
            rs1.close();
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