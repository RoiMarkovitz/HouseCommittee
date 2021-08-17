from tkinter import *
from tkinter import messagebox, ttk
from connection import Connection
from views.BaseView import BaseView
from Utils.ObjectsHandler import ObjectsHandler
from custom_widgets.TopicLabel import TopicLabel


class ApartmentsDetailsWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

        self.get_apartments_details()

    def get_apartments_details(self):
        try:
            obj_type = Connection.CONN.gettype("APARTMENTS_TBL_TYPE")
            cur = Connection.CONN.cursor()
            return_obj = cur.callfunc('get_all_apartment', obj_type)
            self.dict_apartments_details = ObjectsHandler.ObjectRepr(return_obj)
        except Exception as err:
            print('Exception occurred while executing the func  ', err)
            self.activate_label_error(err)
        else:
            print("get_all_apartment function executed")
            self.show_all_details()
        finally:
            cur.close()

    def show_all_details(self):
        for index in range(len(self.dict_apartments_details)):
            records = ['', '', '', '', '', '', '']
            for i, key in enumerate(self.dict_apartments_details[index]):
                if key == 'APARTMENT_NUMBER':
                    records.insert(0, self.dict_apartments_details[index][key])
                if key == 'FLOOR':
                    records.insert(1, self.dict_apartments_details[index][key])
                if key == 'ROOMS':
                    records.insert(2, self.dict_apartments_details[index][key])
                if key == 'APARTMENT_SIZE':
                    records.insert(3, self.dict_apartments_details[index][key])
                if key == 'WAREHOUSE_NUMBER':
                    records.insert(4, self.dict_apartments_details[index][key])
                if key == 'WAREHOUSE_SIZE':
                    records.insert(5, self.dict_apartments_details[index][key])
                if key == 'TARIFF':
                    records.insert(6, self.dict_apartments_details[index][key])

            self.records_tree.insert(parent='', index='end', iid=index, text="",
                                     values=(records[0], records[1], records[2],
                                             records[3], records[4], records[5],
                                             records[6]))

        self.records_tree.pack()

    def set_tree_headers(self):
        """
        Function defines the headers of the table
        """
        header = ['Apartment #', 'Floor #', 'Rooms', 'Apartment Size',
                  'Warehouse #', 'Warehouse Size', 'Tariff']
        header_style = ttk.Style()
        header_style.configure("Treeview.Heading", font=(None, 12, 'bold'))

        # define columns
        self.records_tree["columns"] = (header[0], header[1], header[2], header[3], header[4], header[5],
                                        header[6])
        # format columns
        self.records_tree.column("#0", width=0, stretch=NO)
        self.records_tree.column(header[0], anchor=CENTER, width=120)
        self.records_tree.column(header[1], anchor=CENTER, width=80)
        self.records_tree.column(header[2], anchor=CENTER, width=80)
        self.records_tree.column(header[3], anchor=CENTER, width=140)
        self.records_tree.column(header[4], anchor=CENTER, width=120)
        self.records_tree.column(header[5], anchor=CENTER, width=140)
        self.records_tree.column(header[6], anchor=CENTER, width=100)

        # create headings
        self.records_tree.heading("#0", text="", anchor=CENTER)
        self.records_tree.heading(header[0], text=header[0], anchor=CENTER)
        self.records_tree.heading(header[1], text=header[1], anchor=CENTER)
        self.records_tree.heading(header[2], text=header[2], anchor=CENTER)
        self.records_tree.heading(header[3], text=header[3], anchor=CENTER)
        self.records_tree.heading(header[4], text=header[4], anchor=CENTER)
        self.records_tree.heading(header[5], text=header[5], anchor=CENTER)
        self.records_tree.heading(header[6], text=header[6], anchor=CENTER)

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=20)

        # frame that will consist the table of the records
        tree_frame = Frame(self.master)
        tree_frame.configure(bg='lavender')
        tree_frame.pack(pady=40)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Apartments Details", size=40).get_label()
        topic_label.pack()

        # create scroll bar widget and attach it to the tree table frame
        scroll_tree = Scrollbar(tree_frame)
        scroll_tree.pack(side=RIGHT, fill=Y)
        # tree view widget and bind the scroll bar to it
        self.records_tree = ttk.Treeview(tree_frame, yscrollcommand=scroll_tree.set, selectmode="none")
        scroll_tree.config(command=self.records_tree.yview)

        self.set_tree_headers()

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()
