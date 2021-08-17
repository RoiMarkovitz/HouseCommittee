import cx_Oracle


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
        if Connection.CONN is not None:
            Connection.CONN.close()
        root.destroy()
