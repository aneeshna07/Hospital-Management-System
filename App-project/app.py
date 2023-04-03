import pickle
from pathlib import Path

import streamlit as S  # pip install streamlit
import streamlit_authenticator as stauth  # pip install streamlit-authenticator

from create import create, query
from read import read
from delete import delete
from update import update

# emojis: https://www.webfx.com/tools/emoji-cheat-sheet/
S.set_page_config(page_title="HMS", page_icon=":hospital:", layout="wide")


# USER AUTHENTICATION
names = ["ABC", "XYZ"]
usernames = ["ADM001", "ADM002"]

# load hashed passwords
file_path = Path(__file__).parent / "hashed_pw.pkl"
with file_path.open("rb") as file:
    hashed_passwords = pickle.load(file)

credentials = {"usernames":{}}
for i, j, k in zip(usernames, names, hashed_passwords):
    D = {"name":j, "password":k}
    credentials["usernames"].update({i:D})
authenticator = stauth.Authenticate(credentials, "hms_dashboard", "auth")
name, authentication_status, username = authenticator.login("Login", "main")

if authentication_status == False:
    S.error("Username/password is incorrect")

if authentication_status == None:
    S.warning("Please enter your username and password")

if authentication_status:

    menu = ["Create", "Read", "Update", "Delete", "Query"]
    choice = S.sidebar.selectbox("Menu", menu)
    authenticator.logout('Logout', 'main')
    if choice == "Create":
        S.subheader("Enter the Details:")
        create()
    elif choice == "Read":
        S.subheader("View the Table")
        read()
    elif choice == "Update":
        S.subheader("Update the Table")
        update()
    elif choice == "Delete":
        S.subheader("Delete the Table")
        delete()
    else:
        S.subheader("Query")
        query()
