from time import strftime
import pandas as pd
import streamlit as S
from database import read_data, view_pk, update_data_1, update_data_2

def update():
    pk = {"doctor":"Doctor ID", "patient_surgery": "Surgery ID", "patient_bed":"Patient ID", "patient_appointment":"Appointment ID"}
    pd.set_option('display.max_colwidth', None)
    selected_table = S.selectbox("Tables", ["doctor", "patient_appointment", "patient_surgery", "patient_bed"] )
    result = read_data(selected_table)
    df = pd.DataFrame(result)
    with S.expander("Current Data"):
        S.code(df)

    if selected_table == "doctor":
        selected_pk = S.selectbox("Update", [i[0] for i in view_pk(selected_table, pk[selected_table])])
        S.warning("Do you want to update {}?".format(selected_pk))

        fees = S.text_input("Consultation Fees:")
        if fees != "":
            fees = int(fees)
        if S.button("Update Table"):
            update_data_1(selected_table, pk[selected_table], selected_pk, "Consultation Fees", fees)
            S.success("Successfully updated:: {}".format(selected_table) )
            result = read_data(selected_table)
            df = pd.DataFrame(result)
            with S.expander("Updated Data"):
                S.code(df)

    elif selected_table == "patient_appointment":
        selected_pk = S.selectbox("Update", [i[0] for i in view_pk(selected_table, pk[selected_table])])
        S.warning("Do you want to update {}?".format(selected_pk))

        status = S.selectbox("Status", ["Booked", "Cancelled"])
        if status == "Cancelled":
            diagnosis = None
        else:
            diagnosis = S.text_input("Diagnosis:")
        if S.button("Update Table"):
            update_data_2(selected_table, pk[selected_table], selected_pk, "Status", status, "Diagnosis", diagnosis)
            S.success("Successfully updated:: {}".format(selected_table) )
            result = read_data(selected_table)
            df = pd.DataFrame(result)
            with S.expander("Updated Data"):
                S.code(df)

    elif selected_table == "patient_surgery":
        selected_pk = S.selectbox("Update", [i[0] for i in view_pk(selected_table, pk[selected_table])])
        S.warning("Do you want to update {}?".format(selected_pk))

        date = S.text_input("Date:")
        time = S.text_input("Time:")
        if S.button("Update Table"):
            update_data_2(selected_table, pk[selected_table], selected_pk, "Date", date, "Time", time)
            S.success("Successfully updated:: {}".format(selected_table) )
            result = read_data(selected_table)
            df = pd.DataFrame(result)
            with S.expander("Updated Data"):
                S.code(df)

    elif selected_table == "patient_bed":
        selected_pk = S.selectbox("Update", [i[0] for i in view_pk(selected_table, pk[selected_table])])
        S.warning("Do you want to update {}?".format(selected_pk))

        date = S.text_input("Date of discharge:")
        if S.button("Update Table"):
            update_data_1(selected_table, pk[selected_table], selected_pk, "Date of Discharge", date)
            S.success("Successfully updated:: {}".format(selected_table) )
            result = read_data(selected_table)
            df = pd.DataFrame(result)
            with S.expander("Updated Data"):
                S.code(df)