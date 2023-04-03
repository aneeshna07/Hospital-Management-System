import pandas as pd
import streamlit as S
from database import delete_data, read_data, view_pk
def delete():
    pk = {"doctor":"Doctor ID", "patient_surgery": "Surgery ID", "patient_bed":"Patient ID", "test":"Name", "surgery":"Name"}
    selected_table = S.selectbox("Tables", ["doctor", "patient_surgery", "patient_bed", "test", "surgery"])
    result = read_data(selected_table)
    df = pd.DataFrame(result)
    with S.expander("Current data"):
        S.code(df)
    
    selected_pk = S.selectbox("Delete", [i[0] for i in view_pk(selected_table, pk[selected_table])])
    S.warning("Do you want to delete {}?".format(selected_pk))
    if S.button("Delete the Row"):
        delete_data(selected_table, pk[selected_table], selected_pk)
        S.success("Deleted successfully")
    result = read_data(selected_table)
    df = pd.DataFrame(result)
    with S.expander("Current data"):
        S.code(df)