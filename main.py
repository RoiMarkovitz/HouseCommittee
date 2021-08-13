import cx_Oracle

try:
   #create a connection
    conn = cx_Oracle.connect('c##homeuser/roi@//localhost:1521/xe')
except Exception as err:
    print('Exception occurred while creating a connection ', err)
else:
    try:
        cur = conn.cursor()
       # data = ['18-JUL-2010', 111234561]
        #data = ['04-MAY-2010', 333333333, 0, 0]
        data = ['18-JUL-2010', 111234561, 2,  0, ]
        cur.callproc('update_apartment_payment', data)
       # result = cur.callfunc('calculate_tariff', int, data)
    except Exception as err:
        print('Exception occurred while executing the procedure. ', err)
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
