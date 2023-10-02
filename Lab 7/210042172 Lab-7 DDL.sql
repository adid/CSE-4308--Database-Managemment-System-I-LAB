CREATE TABLE Branch (
    Branch_ID INT NOT NULL,
    Location VARCHAR2(50) NOT NULL,
    Year_of_Establishment INT NOT NULL,
    CONSTRAINT PK_Branch PRIMARY KEY(Branch_ID)
);

CREATE TABLE Employee (
    Employee_ID INT NOT NULL,
    National_ID VARCHAR2(20) UNIQUE,
    Name VARCHAR2(50) NOT NULL,
    Blood_Group VARCHAR2(2) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Employee_Type VARCHAR2(20) NOT NULL,
    Branch_ID INT NOT NULL,
    CONSTRAINT PK_Employee PRIMARY KEY(Employee_ID),
    CONSTRAINT FK_Branch FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)
);

CREATE TABLE Shift (
    Shift_ID INT NOT NULL,
    Start_Time TIME NOT NULL,
    Day_of_the_Week VARCHAR2(10) NOT NULL,
    Duration TIME NOT NULL,
    CONSTRAINT PK_Shift PRIMARY KEY(Shift_ID)
);

CREATE TABLE Book (
    ISBN VARCHAR(13) NOT NULL,
    Title VARCHAR2(50) NOT NULL,
    Author VARCHAR2(50) NOT NULL,
    Genre VARCHAR2(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Publisher_ID INT NOT NULL,
    CONSTRAINT PK_Book PRIMARY KEY(ISBN),
    CONSTRAINT FK_Publisher FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID)
);

CREATE TABLE Publisher (
    Publisher_ID INT NOT NULL,
    Name VARCHAR2(50) NOT NULL,
    City VARCHAR2(50) UNIQUE,
    Establishment_Year INT NOT NULL,
    CONSTRAINT PK_Publisher PRIMARY KEY(Publisher_ID),
);

CREATE TABLE User (
    Username VARCHAR(50) NOT NULL,
    Name VARCHAR2(50) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Hometown VARCHAR2(50) NOT NULL,
    Occupation VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_User PRIMARY KEY(Publisher_ID)
);

CREATE TABLE Issue (
    Issue_ID INT NOT NULL,
    Branch_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    Issue_Date DATE NOT NULL,
    Duration INT NOT NULL,
    CONSTRAINT PK_Issue PRIMARY KEY(Issue_ID)
    CONSTRAINT FK_Issue_Branch FOREIGN KEY (Branch_ID) REFERENCES Employee(Branch_ID),
    CONSTRAINT FK_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    CONSTRAINT FK_Book FOREIGN KEY (ISBN) REFERENCES Book(ISBN),
    CONSTRAINT FK_User FOREIGN KEY (Username) REFERENCES User(Username)
);

CREATE TABLE Accounts (
    Branch_ID INT NOT NULL,
    Username VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Branch_Account FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID),
    CONSTRAINT FK_User_Account FOREIGN KEY (Username) REFERENCES User(Username)
);

CREATE TABLE Booklist (
    Branch_ID INT NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    No_of_Books INT NOT NULL,
    CONSTRAINT FK_Branch_Booklist FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID),
    CONSTRAINT FK_Book_Booklist FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

CREATE TABLE Weekly_Shift_Schedule(
    Employee_ID INT NOT NULL,
    Shift_ID INT NOT NULL,
    CONSTRAINT FK_Employee_Shift FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    CONSTRAINT FK_Shift_Shift FOREIGN KEY (Shift_ID) REFERENCES Shift(Shift_ID)
);
