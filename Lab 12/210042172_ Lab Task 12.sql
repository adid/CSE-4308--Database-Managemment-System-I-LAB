DROP TABLE Transaction CASCADE CONSTRAINTS;
DROP TABLE AccountProperty CASCADE CONSTRAINTS;
DROP TABLE Balance CASCADE CONSTRAINTS;
DROP TABLE Account CASCADE CONSTRAINTS;

CREATE TABLE AccountProperty (
    ID INT,
    Name VARCHAR2(100),
    ProfitRate NUMBER,
    GracePeriod INT,
    CONSTRAINT PK_AccountProperty PRIMARY KEY(ID)
);

CREATE TABLE Account (
    ID INT,
    Name VARCHAR2(100),
    AccCode INT,
    OpeningDate TIMESTAMP,
    LastDateInterest TIMESTAMP,
    CONSTRAINT PK_Account PRIMARY KEY(ID),
    CONSTRAINT FK_Account_AccountProperty FOREIGN KEY(AccCode) REFERENCES AccountProperty(ID)
);

CREATE TABLE Transaction (
    TID INT,
    AccNo INT,
    Amount NUMBER,
    TransactionDate TIMESTAMP,
    CONSTRAINT PK_Transaction PRIMARY KEY(TID),
    CONSTRAINT FK_Transaction_Account FOREIGN KEY(AccNo) REFERENCES Account(ID)
);

CREATE TABLE Balance (
    AccNo INT,
    PrincipalAmount NUMBER,
    ProfitAmount NUMBER,
    CONSTRAINT PK_Balance PRIMARY KEY(AccNo),
    CONSTRAINT FK_Balance_Account FOREIGN KEY(AccNo) REFERENCES Account(ID)
);

INSERT INTO AccountProperty (ID, Name, ProfitRate, GracePeriod) VALUES (2002, 'monthly', 2.8, 1);
INSERT INTO AccountProperty (ID, Name, ProfitRate, GracePeriod) VALUES (3003, 'quarterly', 4.2, 4);
INSERT INTO AccountProperty (ID, Name, ProfitRate, GracePeriod) VALUES (4004, 'biyearly', 6.8, 6);
INSERT INTO AccountProperty (ID, Name, ProfitRate, GracePeriod) VALUES (5005, 'yearly', 8, 12);

INSERT INTO Account (ID, Name, AccCode, OpeningDate, LastDateInterest) VALUES (1, 'Adid', 5005, TIMESTAMP '2023-08-10 10:30:00', TIMESTAMP '2024-08-10 10:30:00');
INSERT INTO Account (ID, Name, AccCode, OpeningDate, LastDateInterest) VALUES (2, 'Sany', 2002, TIMESTAMP '2023-08-12 11:30:00', TIMESTAMP '2023-09-12 11:30:00');
INSERT INTO Account (ID, Name, AccCode, OpeningDate, LastDateInterest) VALUES (3, 'Rifat', 3003, TIMESTAMP '2023-08-14 14:30:00', TIMESTAMP '2023-11-14 14:30:00');
INSERT INTO Account (ID, Name, AccCode, OpeningDate, LastDateInterest) VALUES (4, 'Tasin', 4004, TIMESTAMP '2023-08-16 18:30:00', TIMESTAMP '2024-02-15 18:30:00');

INSERT INTO Transaction (TID, AccNo, Amount, TransactionDate) VALUES (1, 1, 5000, TIMESTAMP '2023-09-10 10:30:00');
INSERT INTO Transaction (TID, AccNo, Amount, TransactionDate) VALUES (2, 2, 10000, TIMESTAMP '2023-09-12 11:30:00');
INSERT INTO Transaction (TID, AccNo, Amount, TransactionDate) VALUES (3, 3, 7000, TIMESTAMP '2023-09-14 14:30:00');
INSERT INTO Transaction (TID, AccNo, Amount, TransactionDate) VALUES (4, 4, 8000, TIMESTAMP '2023-09-16 14:30:00');

INSERT INTO Balance (AccNo, PrincipalAmount, ProfitAmount) VALUES (1, 50000, 7500);
INSERT INTO Balance (AccNo, PrincipalAmount, ProfitAmount) VALUES (2, 100000, 20000);
INSERT INTO Balance (AccNo, PrincipalAmount, ProfitAmount) VALUES (3, 70000, 21000);
INSERT INTO Balance (AccNo, PrincipalAmount, ProfitAmount) VALUES (4, 80000, 18000);

-- Task 1 --

CREATE SEQUENCE Account_Sequence
MINVALUE 1
MAXVALUE 999999
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE FUNCTION 
Generate_Account_Id(name VARCHAR2, acc_code VARCHAR2, opening_date DATE) 
RETURN VARCHAR2 
IS
    Serial_No NUMBER;
BEGIN
    SELECT Account_Sequence.NEXTVAL INTO Serial_No FROM DUAL;
    RETURN acc_code || TO_CHAR(opening_date, 'YYYYMMDD') || UPPER(SUBSTR(name, 1, 3)) || Serial_No;
END;
/

-- Task 2 --

ALTER TABLE Account ADD Account_id VARCHAR2(30);
UPDATE Account SET Account_id = Generate_Account_id(Name, AccCode, OpeningDate);

ALTER TABLE Balance ADD Account_No VARCHAR2(30);
UPDATE Balance SET Account_No = (SELECT Account_id FROM Account WHERE Account.ID = Balance.AccNo);

ALTER TABLE Transaction ADD Account_No VARCHAR2(30);
UPDATE Transaction SET Account_No = (SELECT Account_id FROM Account WHERE Account.ID = Transaction.AccNo);

ALTER TABLE Balance DROP CONSTRAINT FK_Balance_Account;
ALTER TABLE Balance DROP CONSTRAINT PK_Balance;
ALTER TABLE Balance DROP COLUMN AccNo;
ALTER TABLE Balance ADD CONSTRAINT PK_Balance PRIMARY KEY(Account_No);

ALTER TABLE Transaction DROP CONSTRAINT FK_Transaction_Account;
ALTER TABLE Transaction DROP COLUMN AccNo;

ALTER TABLE Account DROP CONSTRAINT PK_Account;
ALTER TABLE Account ADD CONSTRAINT PK_Account PRIMARY KEY(Account_id);
ALTER TABLE Account DROP COLUMN ID;
ALTER TABLE Balance ADD CONSTRAINT FK_Balance_Account FOREIGN KEY (Account_No) REFERENCES Account(Account_id);
ALTER TABLE Transaction ADD CONSTRAINT FK_Transaction_Account FOREIGN KEY (Account_No) REFERENCES Account(Account_id);


-- Task 3 --
CREATE OR REPLACE TRIGGER Trigger_Generate_Account_Id
BEFORE INSERT ON Account
    FOR EACH ROW
    BEGIN
        :NEW.Account_id := Generate_Account_id(:NEW.Name, :NEW.AccCode, :NEW.OpeningDate);
    END;
/

-- Task 4 --
CREATE OR REPLACE TRIGGER Trigger_Insert_Into_Balance
AFTER INSERT ON Account
    FOR EACH ROW
    BEGIN
        INSERT INTO Balance (Account_No, PrincipalAmount, ProfitAmount) VALUES (:NEW.Account_id, 5000, 0);
    END;
/

-- Task 5 --
CREATE OR REPLACE TRIGGER Update_Balance
AFTER INSERT ON Transaction
    FOR EACH ROW
    BEGIN
        UPDATE Balance
        SET PrincipalAmount = PrincipalAmount + :NEW.Amount
        WHERE Account_No = :NEW.Account_No;
    END;
/

