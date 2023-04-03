import streamlit as S
from database import add_data, query_data
import pandas as pd

def create():
    C1, C2 = S.columns(2)
    selected_table = S.selectbox("Tables", ["patient", "doctor", "patient_appointment"])

    if selected_table == "patient":
        with C1:
            patient_id = S.text_input("Patient ID:")
            date_of_registration = S.text_input("Date of Registration:")
            patient_name = S.text_input("Patient Name:")
        with C2:
            patient_gender = S.text_input("Gender:")
            date_of_birth = S.text_input("Date of Birth:")
            patient_phone = S.text_input("Phone:")
            if patient_phone != "":
                patient_phone = int(patient_phone)
        L = (patient_id, date_of_registration, patient_name, patient_gender, date_of_birth, patient_phone)
    elif selected_table == "doctor":
        with C1:
            doctor_id = S.text_input("Doctor ID:")
            doctor_name = S.text_input("Name:")
        with C2:
            doctor_designation = S.text_input("Designation:")
            doctor_fees = S.text_input("Consultation Fees:")
            if doctor_fees != "":
                doctor_fees = int(doctor_fees)
        L = (doctor_id, doctor_name, doctor_designation, doctor_fees)

    elif selected_table == "patient_appointment":
        with C1:
            appointment_id = S.text_input("Appointment ID:")
            patient_id = S.text_input("Patient ID:")
            doctor_id = S.text_input("Doctor ID:")
            description = S.text_input("Description:")
        with C2:
            appointment_date = S.text_input("Appointment Date:")
            appointment_time = S.text_input("Appointment Time:")
            appointment_status = S.text_input("Appointment Status:")
            diagnosis = S.text_input("Diagnosis:")
        L = (appointment_id, patient_id, doctor_id, description, appointment_date, appointment_time, appointment_status, diagnosis)


    if S.button("Add Row"):
        add_data(selected_table, str(L))
        S.success("Successfully added : {}".format(str(L)))
        result = query_data("SELECT * FROM {}".format(selected_table))
        df = pd.DataFrame(result)
        with S.expander("Updated Table"):
            S.code(df)

def query():
    query = S.text_input("Query:")
    if S.button("Search Query"):
        result = query_data(query)
        df = pd.DataFrame(result)
        with S.expander("Query Results"):
            S.code(df)