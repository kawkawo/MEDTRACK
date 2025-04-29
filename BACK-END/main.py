from fastapi import FastAPI
import mysql.connector


app = FastAPI()

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="medical_db"
    )
@app.get("/atients")
def get_patients():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT patient_id, first_name FROM patients")
    rows = cursor.fetchall()
    col_names = [desc[0] for desc in cursor.description]
    conn.close()
    return [dict(zip(col_names, row)) for row in rows]

@app.get("/treatments")
def get_treatments():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM treatments")  # or specify fields
    rows = cursor.fetchall()
    col_names = [desc[0] for desc in cursor.description]
    conn.close()
    return [dict(zip(col_names, row)) for row in rows]

@app.get("/diagnoses")
def get_diagnoses():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM diagnoses")  # or specify fields
    rows = cursor.fetchall()
    col_names = [desc[0] for desc in cursor.description]
    conn.close()
    return [dict(zip(col_names, row)) for row in rows]