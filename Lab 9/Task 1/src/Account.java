// Class to organize data of Account Table

public class Account {
    private final int A_ID;
    private double balance;

    public Account(int A_ID) {
        this.A_ID = A_ID;
    }

    public int getA_ID() {
        return A_ID;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }
}

