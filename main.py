import cx_Oracle

try:
   #create a connection
    conn = cx_Oracle.connect('c##homeuser/roi@//localhost:1521/xe')
except Exception as err:
    print('Exception occurred while creating a connection ', err)
else:
    try:
        cur = conn.cursor()
        data = [124123654, 'TopClean', '1297 Ben Gurion, Tel Aviv', '353.123.5555']
       # data = [13]
        cur.callproc('add_service_provider', data)
       # result = cur.callfunc('calculate_tariff', int, data)
    except Exception as err:
        print('Exception occurred while executing the procedure ', err)
      #  print('Exception occurred while executing the func  ', err)
    else:
        print("Procedure Executed")
      #  print("Result : ", result)
    finally:
        conn.commit()
        #conn.rollback()
        cur.close()
finally:
    conn.close()
