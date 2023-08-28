ALTER TABLE APPOINTMENT ADD APPOINTMENT_DATE DATE NOT NULL;
ALTER TABLE APPOINTMENT DROP CONSTRAINT PK_APPOINTMENT;
ALTER TABLE APPOINTMENT ADD CONSTRAINT PK_APPOINTMENT PRIMARY KEY (PATIENT_NO, NAME, SPECIALIZATION,APPOINTMENT_DATE);
ALTER TABLE APPOINTMENT RENAME COLUMN PATIENT_NO TO P_NO;
ALTER TABLE APPOINTMENT RENAME COLUMN NAME TO D_NAME;
ALTER TABLE APPOINTMENT RENAME TO APPOINTMENT_INFO;
ALTER TABLE APPOINTMENT_INFO ADD CONSTRAINT FK_APPOINTMENT_DOCTOR FOREIGN KEY (D_NAME, SPECIALIZATION) REFERENCES DOCTOR(NAME, SPECIALIZATION);
ALTER TABLE APPOINTMENT_INFO ADD CONSTRAINT FK_APPOINTMENT_PATIENT FOREIGN KEY (P_NO) REFERENCES PATIENT(PATIENT_NO);