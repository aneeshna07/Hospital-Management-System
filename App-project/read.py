import pandas as pd
import streamlit as S
from database import read_data

def read():
    tables = ['bed', 'doctor', 'employee', 'patient', 'patient_appointment', 'patient_bed',
    'patient_pharmacy', 'patient_surgery', 'patient_test', 'pharmacy', 'room', 'schedule',
    'surgery', 'test', 'transaction_item']
    selected_table = S.selectbox("Select Table", tables)
    result = read_data(selected_table)
    df = pd.DataFrame(result)
    with S.expander(selected_table):
        S.code(df)
