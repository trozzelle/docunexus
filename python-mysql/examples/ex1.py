import mysql.connector
import json
import os
  

#pathname =         
#print('path =', pathname)
#print('full path =', os.path.abspath(pathname)) 

with open(os.path.dirname(__file__) + '/../../conf/config.json') as json_file:
    conf = json.load(json_file)
    db_user = "dcnxs_app"
    db_db = "dcnxs_ny"
    db_host = conf["db"]["host"]
    db_port = conf["db"]["port"]
    db_pass = conf["db"]["passwords"][db_user]

def elections_by_year(year):
    con = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_pass,
        database=db_db
        )    

    cur = con.cursor(dictionary=True)
    sql = """
        select * 
        from dcnxs_ny.elections
        where election_year = %(election_year)s
        """
    cur.execute(sql, {'election_year':year})

    rows = cur.fetchall()

    for row in rows:
        
        print(row["election_name"])