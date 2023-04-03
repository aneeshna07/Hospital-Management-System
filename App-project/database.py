import mysql.connector
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="8453067238",
    database="hospital management system",
    port = 3307
)
c = mydb.cursor()

def add_data(table, L):
    c.execute('INSERT INTO {} VALUES {};'.format(table, L))
    mydb.commit()

def read_data(table):
    c.execute('SELECT * FROM `{}`;'.format(table))
    data = c.fetchall()
    return data

def view_pk(table, pk):
    c.execute('SELECT `{}` FROM {};'.format(pk, table) )
    data = c.fetchall()
    return data

def update_data_1(table, pk, pk_value, column, new_value):
    c.execute(f'''UPDATE {table} SET `{column}` = {new_value} WHERE `{pk}` = "{pk_value}"''')
    mydb.commit()
    data = c.fetchall()
    return data

def update_data_2(table, pk, pk_value, column_1, new_value_1, column_2, new_value_2):
    c.execute(f'''UPDATE {table} SET `{column_1}` = "{new_value_1}", `{column_2}`= "{new_value_2}" WHERE `{pk}` = "{pk_value}"''')
    mydb.commit()
    data = c.fetchall()
    return data

def delete_data(table, pk, pk_value):
    c.execute(f'''DELETE FROM {table} WHERE `{pk}` = "{pk_value}"''')
    mydb.commit()

def query_data(query):
    c.execute(query)
    data = c.fetchall()
    mydb.commit()
    return data