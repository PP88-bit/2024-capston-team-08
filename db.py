import pymysql
db = pymysql.connect(host="localhost", user="root", password="0000", charset="utf8")
cursor = db.cursor()