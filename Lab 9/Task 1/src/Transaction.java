// Class to organize data of Transactions Table

import java.util.Date;

public class Transaction {
    private final int A_ID;
    private final int T_AMOUNT;
    private final String T_TYPE;


    public Transaction(int A_ID, int T_AMOUNT, String T_TYPE) {
        this.A_ID = A_ID;
        this.T_AMOUNT = T_AMOUNT;
        this.T_TYPE = T_TYPE;
    }

    public int getA_ID() {
        return A_ID;
    }

    public String getT_TYPE() {
        return T_TYPE;
    }

    public int getT_AMOUNT() {
        return T_AMOUNT;
    }


    public String toString() {
        return "Account ID: " + A_ID + "\n" +
                "Transaction Amount: " + T_AMOUNT + "\n" +
                "Transaction Type: " + T_TYPE + "\n";
    }

}

