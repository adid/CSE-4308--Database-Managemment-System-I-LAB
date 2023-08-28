SELECT NAME FROM DOCTOR WHERE FEE<1500;
SELECT NAME FROM PATIENT WHERE ADDRESS='KHL';
SELECT * FROM PATIENT, APPOINTMENT_INFO WHERE PATIENT.PATIENT_NO = APPOINTMENT_INFO.P_NO;
SELECT * FROM PATIENT NATURAL JOIN APPOINTMENT_INFO WHERE PATIENT.PATIENT_NO = APPOINTMENT_INFO.P_NO;
SELECT NAME, ADDRESS FROM PATIENT, APPOINTMENT_INFO WHERE PATIENT.PATIENT_NO = APPOINTMENT_INFO.P_NO 
AND APPOINTMENT_INFO.APPOINTMENT_DATE= '26-AUG-2023';
SELECT DOCTOR.NAME,DOCTOR.SPECIALIZATION,DOCTOR.FEE FROM PATIENT, DOCTOR, APPOINTMENT_INFO WHERE PATIENT.PATIENT_NO = APPOINTMENT_INFO.P_NO AND 
APPOINTMENT_INFO.D_NAME = DOCTOR.NAME AND APPOINTMENT_INFO.SPECIALIZATION= DOCTOR.SPECIALIZATION AND PATIENT.ADDRESS='DHK';
SELECT PATIENT.NAME,PATIENT.PATIENT_NO,PATIENT.ADDRESS FROM PATIENT, DOCTOR, APPOINTMENT_INFO WHERE PATIENT.PATIENT_NO = APPOINTMENT_INFO.P_NO AND 
APPOINTMENT_INFO.D_NAME = DOCTOR.NAME AND APPOINTMENT_INFO.SPECIALIZATION= DOCTOR.SPECIALIZATION AND DOCTOR.SPECIALIZATION='GS'
AND DOCTOR.FEE>1500;