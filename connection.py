import cx_Oracle
import time


class Connection(object):

    @staticmethod
    def connect_to_database():
        try:
            # create a connection
            Connection.CONN = cx_Oracle.connect('c##homeuser/roi@//localhost:1521/xe')
        except Exception as err:
            print('Exception occurred while creating a connection ', err)
        else:
            print('Connected to database')

    @staticmethod
    def on_closing(root):
       # time.sleep(5)
        if Connection.CONN is not None:
          #  print('closing')
            Connection.CONN.close()
        root.destroy()
