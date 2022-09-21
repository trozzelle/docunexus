import dcnxs_scourgify
import dcnxs_fuzzy
import mysql.connector
import json
from datetime import date

alphabet = {
    "A": 0,
    "B": 1,
    "C": 2,
    "D": 3,
    "E": 4,
    "F": 5,
    "G": 6,
    "H": 7,
    "I": 8,
    "J": 9,
    "K": 10,
    "L": 11,
    "M": 12,
    "N": 13,
    "O": 14,
    "P": 15,
    "Q": 16,
    "R": 17,
    "S": 18,
    "T": 19,
    "U": 20,
    "V": 21,
    "W": 22,
    "X": 23,
    "Y": 24,
    "Z": 25,
    "AA": 26,
    "AB": 27,
    "AC": 28,
    "AD": 29,
    "AE": 30,
    "AF": 31,
    "AG": 32,
    "AH": 33,
    "AI": 34,
    "AJ": 35,
    "AK": 36,
    "AL": 37,
    "AM": 38,
    "AN": 39,
    "AO": 40,
    "AP": 41,
    "AQ": 42,
    "AR": 43,
    "AS": 44,
    "AT": 45,
    "AU": 46,
    "AV": 47,
    "AW": 48,
    "AX": 49,
    "AY": 50,
    "AZ": 51
}

counties = {
    '01':'Albany',
    '02':'Allegany',
    '03':'Bronx',
    '04':'Broome',
    '05':'Cattaraugus',
    '06':'Cayuga',
    '07':'Chautauqua',
    '08':'Chemung',
    '09':'Chenango',
    '10':'Clinton',
    '11':'Columbia',
    '12':'Cortland',
    '13':'Delaware',
    '14':'Dutchess',
    '15':'Erie',
    '16':'Essex',
    '17':'Franklin',
    '18':'Fulton',
    '19':'Genesee',
    '20':'Greene',
    '21':'Hamilton',
    '22':'Herkimer',
    '23':'Jefferson',
    '24':'Kings',
    '25':'Lewis',
    '26':'Livingston',
    '27':'Madison',
    '28':'Monroe',
    '29':'Montgomery',
    '30':'Nassau',
    '31':'New York',
    '32':'Niagara',
    '33':'Oneida',
    '34':'Onondaga',
    '35':'Ontario',
    '36':'Orange',
    '37':'Orleans',
    '38':'Oswego',
    '39':'Otsego',
    '40':'Putnam',
    '41':'Queens',
    '42':'Rensselaer',
    '43':'Richmond',
    '44':'Rockland',
    '45':'Saratoga',
    '46':'Schenectady',
    '47':'Schoharie',
    '48':'Schuyler',
    '49':'Seneca',
    '50':'St. Lawrence',
    '51':'Steuben',
    '52':'Suffolk',
    '53':'Sullivan',
    '54':'Tioga',
    '55':'Tompkins',
    '56':'Ulster',
    '57':'Warren',
    '58':'Washington',
    '59':'Wayne',
    '60':'Westchester',
    '61':'Wyoming',
    '62':'Yates'
}

county_keys = list(counties.keys())
county_vals = list(counties.values())

with open('../conf/config.json') as json_file:
    conf = json.load(json_file)
    db_user = "dcnxs_app"
    db_db = "dcnxs_ny"
    db_host = conf["db"]["host"]
    db_port = conf["db"]["port"]
    db_pass = conf["db"]["passwords"][db_user]

def do_fuzzy():

    """
    sample usage: python -c"import match_process; match_process.do_fuzzy();"
    """

    con = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_pass,
        database=db_db
        )

    cur = con.cursor(dictionary=True)

    j = ","

    #Get new matches
    sql = """
        SELECT matchid FROM matches WHERE status = 'PASS1'
        """
    cur.execute(sql)
    loaded = cur.fetchall()
    for l in loaded:        
        matchid = l['matchid']

        sql = """
        SELECT 
        REGEXP_REPLACE(CONCAT_WS('', md.clean_full_name, md.clean_residence_address), '\\\\\\s+', '') as n1,
        REGEXP_REPLACE(CONCAT_WS('', vfn.full_name, vra.residence_address), '\\\\\\s+', '') as n2,
        mp.nys_voter_id,
        mp.userid,
        mp.matchid, 
        mp.queueid,
        vd.voter_status
        from dcnxs_ny.match_data md 
        JOIN (
        SELECT mp.queueid, mp.matchid, mp.userid, sum(mp.score) as score, mp.nys_voter_id from dcnxs_ny.match_potentials mp 
        group by mp.nys_voter_id, mp.queueid, mp.matchid, mp.userid having sum(mp.score) < 100 ) mp
        on (md.queueid = mp.queueid and md.matchid = mp.matchid and md.userid = mp.userid)
        join dcnxs_ny.matches m
        on (m.matchid = md.matchid and m.userid = md.userid and m.status = 'PASS1')
        join dcnxs_ny.voter_full_name vfn
        on (vfn.nys_voter_id = mp.nys_voter_id)
        join dcnxs_ny.voter_residence_address vra
        on (vra.nys_voter_id = mp.nys_voter_id)
        join dcnxs_ny.voter_data vd 
        on (vd.nys_voter_id = mp.nys_voter_id)
        where md.matchid = %(matchid)s
        """
        cur.execute(sql, {'matchid': matchid})
        arr1 = cur.fetchall()

        a1score = 79
        a1cutoff = 85
        a1key = "FUZZYFULLNAMEADDRESSEXISTS"
        ins1 = "INSERT INTO dcnxs_ny.match_potentials (userid, matchid, queueid, score, matchkey, nys_voter_id) VALUES "
        ins1vals = ''
        for a in arr1:
            r = json.loads(dcnxs_fuzzy.get_fuzzy(
                {'string1': a['n1'], 'string2': a['n2']}))
            if r['ratio'] > a1score or r['partial_ratio'] > a1score or r['token_sort_ratio'] > a1score or r['token_set_ratio'] > a1score:
                scores = [r['ratio'], r['partial_ratio'],
                            r['token_sort_ratio'], r['token_set_ratio']]
                score = max(scores)
                tmp1 = [str(a['userid']), str(a['matchid']), str(a['queueid']), str(
                    score - a1score), "'" + a1key + "'", "'" + a['nys_voter_id'] + "'"]
                ins1vals += '(' + j.join(tmp1) + '),'

        ins = ins1+ins1vals[:-1]  # remove last character
        cur.execute(ins)

        sql = """
        SELECT 
        REGEXP_REPLACE(CONCAT_WS('', md.clean_first_name, md.clean_last_name, md.clean_residence_city, md.clean_zip5), '\\\\\\s+', '') as n1,
        REGEXP_REPLACE(CONCAT_WS('', vf.first_name, vl.last_name, vc.residence_city, z5.zip5), '\\\\\\s+', '') as n2,
        mp.nys_voter_id,
        mp.userid,
        mp.matchid, 
        mp.queueid,
        vd.voter_status
        from dcnxs_ny.match_data md 
        JOIN (
        SELECT mp.queueid, mp.matchid, mp.userid, sum(mp.score) as score, mp.nys_voter_id from dcnxs_ny.match_potentials mp 
        group by mp.nys_voter_id, mp.queueid, mp.matchid, mp.userid having sum(mp.score) < 100 ) mp
        on (md.queueid = mp.queueid and md.matchid = mp.matchid and md.userid = mp.userid)
        join dcnxs_ny.matches m
        on (m.matchid = md.matchid and m.userid = md.userid and m.status = 'PASS1')
        join dcnxs_ny.voter_first_name vf
        on (vf.nys_voter_id = mp.nys_voter_id)
        join dcnxs_ny.voter_last_name vl
        on (vl.nys_voter_id = mp.nys_voter_id)
        join dcnxs_ny.voter_city vc
        on (vc.nys_voter_id = mp.nys_voter_id)
        join dcnxs_ny.voter_zip5 z5
        on (z5.nys_voter_id = mp.nys_voter_id)
        join dcnxs_ny.voter_data vd 
        on (vd.nys_voter_id = mp.nys_voter_id)
        where md.matchid = %(matchid)s
        """
        cur.execute(sql, {'matchid': matchid})
        arr2 = cur.fetchall()

        a2score = 89
        a2cutoff = 95
        a2key = "FUZZYFNAMELNAMECITYEXISTS"
        ins2 = "INSERT INTO dcnxs_ny.match_potentials (userid, matchid, queueid, score, matchkey, nys_voter_id) VALUES "
        ins2vals = ''
        for a in arr2:
            r = json.loads(dcnxs_fuzzy.get_fuzzy(
                {'string1': a['n1'], 'string2': a['n2']}))
            if r['ratio'] > a2score or r['partial_ratio'] > a2score or r['token_sort_ratio'] > a2score or r['token_set_ratio'] > a2score:
                scores = [r['ratio'], r['partial_ratio'],
                            r['token_sort_ratio'], r['token_set_ratio']]
                score = max(scores)
                #Add 20 to the score if its a good match to ensure it gets picked up as a guarantee
                if score >= a2cutoff:
                    score += 20
                tmp2 = [str(a['userid']), str(a['matchid']), str(a['queueid']), str(
                    score - a2score), "'" + a2key + "'", "'" + a['nys_voter_id'] + "'"]
                ins2vals += '(' + j.join(tmp1) + '),'

        ins = ins2+ins2vals[:-1]  # remove last character
        cur.execute(ins)   
        con.commit() 

        sql = """
        UPDATE dcnxs_ny.match_data md
        JOIN (
        SELECT mp.queueid, mp.matchid, mp.userid, sum(mp.score) as score, mp.nys_voter_id from dcnxs_ny.match_potentials mp
        JOIN matches m
        ON (m.matchid = mp.matchid and m.userid = mp.userid and m.status = 'PASS1')
        WHERE mp.matchid = %(matchid)s
        group by mp.nys_voter_id, mp.queueid, mp.matchid, mp.userid
        HAVING max(score)) x
        ON (x.matchid = md.matchid and x.queueid = md.queueid and x.userid = md.userid)
        SET md.matched_voter_id = x.nys_voter_id
        WHERE x.score >= '100'
        """

        cur.execute(sql, {'matchid': matchid})
        con.commit() 

        sql = """
        UPDATE dcnxs_ny.matches m   
        SET m.status = 'COMPLETE' 
        WHERE m.status = 'PASS1'
        AND m.matchid = %(matchid)s
        """    

        cur.execute(sql, {'matchid': matchid})
        con.commit() 
    cur.close()
    con.close()


def do_match():
    """
    sample usage: python -c"import match_process; match_process.do_match();"
    """

    con = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_pass,
        database=db_db
        )

    cur = con.cursor(dictionary=True)

    #SQL mode off
    sql = """
        SET sql_mode= ''
        """
    cur.execute(sql)

    #Get new matches
    sql = """
        SELECT matchid, userid, status, matchfile_name, matchmap, matchtable FROM matches WHERE status = 'LOADED'
        """
    cur.execute(sql)
    loaded = cur.fetchall()
    year = date.today().year

    for l in loaded:        
        matchid = l['matchid']
        userid = l['userid']
        schema,table = l['matchtable'].split('.')  
        matchmap = json.loads(l['matchmap'])
        cols = [] 
        addrMap = []
        arrAddr = []
        mapping = {}
        #Initialize match
        sql = """
        UPDATE dcnxs_ny.matches 
        SET status = 'INITIALIZED' 
        WHERE matchid = %(matchid)s
        """
        cur.execute(sql, {'matchid': matchid})

        #Get columns from user-provided data
        sql = """
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA=%(schema)s 
        AND TABLE_NAME=%(table)s 
        ORDER BY ordinal_position
        """
        cur.execute(sql, {'schema': schema, 'table': table})
        columns = cur.fetchall()
        for c in columns:
            if c['COLUMN_NAME'] != 'queueid' and c['COLUMN_NAME'] != 'nys_voter_id':
                cols.append("`" + c['COLUMN_NAME'] + "`")

        sqlData = "SELECT " + ','.join(cols) + " FROM " + l['matchtable']
        cur.execute(sqlData)
        arrData = cur.fetchall()        

        for m in matchmap:            
            if matchmap[m].get('id', '') > '':
                if matchmap[m]['id'] != 'residence_state':
                    mapping[m] = {
                    'value': matchmap[m]['id'], 
                    'size': matchmap[m]['size'],
                    'dateFmt': matchmap[m].get('dateFmt', ''),
                    'lookup': matchmap[m].get('lookup', '')
                    }

        sqlBegin = "REPLACE INTO dcnxs_ny.match_data (matchid, userid, queueid, "
        sqlVals = "('" + str(matchid) + "', " + str(userid) + ", "

        for m in mapping:
            if (mapping[m]['value'] == 'street_address_1'):
                sqlBegin += """
                residence_num, residence_halfnum, residence_street_name, 
                residence_pre_street_dir, residence_post_street_dir, residence_aptnum,
                """
            else:
                sqlBegin += mapping[m]['value'] + ", "

        sqlBegin = sqlBegin.rstrip(", ") + ") VALUES "

        clob = sqlBegin    
        rowid = 0

        for a in arrData:        
            sql = sqlVals
            sql += str(rowid+1) + ", "         

            for m in mapping:                         
                val = list(a.items())[alphabet[m]][-1]           
                if mapping[m]['value'] == 'street_address_1':
                    address = list(a.items())[alphabet[m]][-1]
                    clean_address = dcnxs_scourgify.scourgify_address({'address':address})
                    clean_address = json.loads(clean_address)
                    arrAddr.append(clean_address)                
                    sql += "'" + sql_sanitize(clean_address['parsed_address']['residence_num']) + "', "
                    sql += "'" + sql_sanitize(clean_address['parsed_address']['residence_halfnum']) + "', " 
                    sql += "'" + sql_sanitize(clean_address['parsed_address']['residence_street_name']) + "', "
                    sql += "'" + sql_sanitize(clean_address['parsed_address']['residence_pre_street_dir']) + "', "
                    sql += "'" + sql_sanitize(clean_address['parsed_address']['residence_post_street_dir']) + "', "
                    sql += "'" + sql_sanitize(clean_address['parsed_address']['residence_aptnum']) + "', "               
                elif mapping[m]['value'] == 'residence_city':
                    if val == '':
                        data = sql_sanitize(arrAddr[rowid]['parsed_address']['city'])
                    else:
                        data = val
                    sql += "'" + data + "', "
                elif mapping[m]['value'] == 'residence_zip':
                    if val == '':
                        data = arrAddr[rowid]['parsed_address']['zip']
                    else:
                        data = val
                    sql += "'" + data + "', "
                elif mapping[m]['value'] == 'birth_year':                
                    data = birth_year(year, val)
                    sql += "'" + data + "', "
                else: 
                    rawdata = val 
                    #If the field has a lookup parameter, check its value against pre-fetched values
                    if matchmap[m].get('lookup', '') > '':
                        if matchmap[m]['lookup'] == 'county':                          
                            if (val in county_vals):
                                rawdata = county_vals.index(val)                                                        

                    #Get the spreadsheet data
                    #By default, trim the field to the proper size, escape any bad characters, 
                    #and transpose the alpha key to a numeric one
                    #Cast to upper, remove special characters
                    #Trim data if it exceeds field size
                    data = sql_sanitize(str(rawdata).upper())
                    if matchmap[m].get('size', '') > '':                            
                        data = data[:int(matchmap[m]['size'])]
                    #If there's a date format, make a date from the field and format it according to the date format of the field
                    if matchmap[m].get('dateFmt', '') > '':
                        data = rawdata.strptime(rawdata, matchmap[m]['dateFmt']);                    
                    #Append the SQL to the insert statement
                    sql += "'" + data + "', "            

            sql = sql.rstrip(", ") + "), "    
            clob += sql
            rowid = rowid + 1
        
        clob = clob[:-2] #remove last character    
        cur.execute(clob)

        sql = "CALL dcnxs_ny.clean_match_data(%(matchid)s)"
        cur.execute(sql, {'matchid': matchid})

        sql = "UPDATE dcnxs_ny.matches SET status = 'QUEUED' WHERE matchid = %(matchid)s"
        cur.execute(sql, {'matchid': matchid})

        sql = "CALL dcnxs_ny.do_match(%(userid)s, %(matchid)s)"
        cur.execute(sql, {'userid': userid, 'matchid': matchid})

    cur.close()
    con.close()

def sql_sanitize(str):
    tmp = str
    tmp = tmp.replace("'", "''")
    tmp = tmp.replace('"', '')
    tmp = tmp.replace('&quot;', '')
    tmp = tmp.replace("&", "and");   
    tmp = tmp.replace("\n", " ")
    tmp = tmp.replace("\r", " ")
    tmp = tmp.replace("\r\n", " ")
    tmp = tmp.replace("\n\r", " ")
    tmp = tmp.strip()
    return tmp

def birth_year(year, val):
    val = val.strip()
    out = ''
    if val:
        out = str(year - int(val))    
    return out

