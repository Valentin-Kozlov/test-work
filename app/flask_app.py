from contextlib import closing
from flask import Flask, jsonify, request
import datetime
import os
import psycopg2


app = Flask(__name__)

# получение переменных окружения
dbCreds = {
    "user": os.getenv("postgres_user"),
    "password": os.getenv("postgres_password"),
    "host": os.getenv("postgres_host"),
    "database": os.getenv("postgres_database"),
}

# функция подключения к БД
def connectDB(command):
    with closing(
        psycopg2.connect(
            dbname=dbCreds["database"],
            user=dbCreds["user"],
            password=dbCreds["password"],
            host=dbCreds["host"],
        )
    ) as conn:
        with conn.cursor() as cursor:
            conn.autocommit = True
            cursor.execute(command)
            if "select" in command:
                res = cursor.fetchall()
                return res


@app.route("/api/v0.1/myIp", methods=["GET"])
def get_my_ip():
    startReq = datetime.datetime.now()
    ipRequest = request.remote_addr
    insertToDBCommand = f"INSERT INTO ip(date, ip) VALUES ('{startReq}', '{ipRequest}')"
    connectDB(insertToDBCommand)
    return jsonify({"yourIp": request.remote_addr}), 200


@app.route("/healthz")
def healthz():
    return "OK"

# проверка, существует ли таблица для записи и создание её
checkCommand = "select * from information_schema.tables where table_name='ip'"
checkTable = bool(connectDB(checkCommand))
while checkTable is False:
    checkCommand = "select * from information_schema.tables where table_name='ip'"
    checkTable = bool(connectDB(checkCommand))
    if checkTable is False:
        print(
            """Error: Missing table 'IP'
Trying to create a table...."""
        )
        createTableCommand = "create table ip (date timestamp, ip varchar(40))"
        createTable = connectDB(createTableCommand)
    else:
        print("The table 'IP' is ready")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
