CREATE TABLE DOCTOR
(
    NAME VARCHAR2(20),
    SPECIALIZATION CHAR(2),
    FEE NUMBER NOT NULL,
    CONSTRAINT PK_DOCTOR PRIMARY KEY (NAME,SPECIALIZATION)
);

CREATE TABLE PATIENT
(
    PATIENT_NO CHAR(5),
    NAME VARCHAR2(20) NOT NULL,
    ADDRESS VARCHAR2(10) NOT NULL,
    CONSTRAINT PK_PATIENT PRIMARY KEY (PATIENT_NO)
);

CREATE TABLE APPOINTMENT
(
    PATIENT_NO CHAR(5),
    NAME VARCHAR2(20),
    SPECIALIZATION CHAR(2),
    CONSTRAINT PK_APPOINTMENT PRIMARY KEY (PATIENT_NO,NAME,SPECIALIZATION)
);