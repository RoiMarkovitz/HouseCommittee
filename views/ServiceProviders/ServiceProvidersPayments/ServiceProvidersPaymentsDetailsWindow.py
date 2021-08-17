from tkinter import *
from tkinter import messagebox, ttk
import tkinter as tk
from connection import Connection
from views.BaseView import BaseView
from Utils.ObjectsHandler import ObjectsHandler
from custom_widgets.TopicLabel import TopicLabel


class ServiceProvidersPaymentsDetailsWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

        self.get_service_providers_payments_details(True)

    def get_service_providers_payments_details(self, ascending):
        try:
            obj_type = Connection.CONN.gettype("SERVICE_PAYMENTS_TBL_TYPE")
            cur = Connection.CONN.cursor()
            if ascending:
                return_obj = cur.callfunc('get_all_service_payments_ascend', obj_type)
            else:
                return_obj = cur.callfunc('get_all_service_payments_desc', obj_type)
            self.dict_providers_payments_details = ObjectsHandler.ObjectRepr(return_obj)

        except Exception as err:
            print('Exception occurred while executing the func  ', err)
            self.activate_label_error(err)
        else:
            if ascending:
                print("get_all_service_payments_ascend function executed")
            else:
                print("get_all_service_payments_desc function executed")
            self.show_all_details()
        finally:
            cur.close()

    def show_all_details(self):
        self.remove_all_records()

        for index in range(len(self.dict_providers_payments_details)):
            records = ['', '', '', '', '']
            for i, key in enumerate(self.dict_providers_payments_details[index]):
                if key == 'PAYMENT_NUMBER':
                    records.insert(0, self.dict_providers_payments_details[index][key])
                if key == 'PAID_DATE':
                    records.insert(1, self.dict_providers_payments_details[index][key].strftime('%x'))
                if key == 'AMOUNT':
                    records.insert(2, self.dict_providers_payments_details[index][key])
                if key == 'BUSINESS_NUMBER':
                    records.insert(3, self.dict_providers_payments_details[index][key])
                if key == 'WORK_NUMBER':
                    records.insert(4, self.dict_providers_payments_details[index][key])

            self.records_tree.insert(parent='', index='end', iid=index, text="",
                                     values=(records[0], records[1], records[2],
                                             records[3], records[4]))

        self.records_tree.pack()

    def remove_all_records(self):
        """
        Function removes the records from the table
        """
        for record in self.records_tree.get_children():
            self.records_tree.delete(record)

    def set_tree_headers(self):
        """
        Function defines the headers of the table
        """
        header = ['Payment #', 'Paid Date', 'Amount', 'Business #', 'Work #']
        header_style = ttk.Style()
        header_style.configure("Treeview.Heading", font=(None, 12, 'bold'))

        # define columns
        self.records_tree["columns"] = (header[0], header[1], header[2], header[3], header[4])
        # format columns
        self.records_tree.column("#0", width=0, stretch=NO)
        self.records_tree.column(header[0], anchor=CENTER, width=120)
        self.records_tree.column(header[1], anchor=CENTER, width=120)
        self.records_tree.column(header[2], anchor=CENTER, width=120)
        self.records_tree.column(header[3], anchor=CENTER, width=120)
        self.records_tree.column(header[4], anchor=CENTER, width=120)

        # create headings
        self.records_tree.heading("#0", text="", anchor=CENTER)
        self.records_tree.heading(header[0], text=header[0], anchor=CENTER)
        self.records_tree.heading(header[1], text=header[1], anchor=CENTER)
        self.records_tree.heading(header[2], text=header[2], anchor=CENTER)
        self.records_tree.heading(header[3], text=header[3], anchor=CENTER)
        self.records_tree.heading(header[4], text=header[4], anchor=CENTER)

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=30)

        # frame that will consist the search in the window
        search_frame = Frame(self.master)
        search_frame.configure(bg='lavender')
        search_frame.pack()

        # frame that will consist the table of the records
        tree_frame = Frame(self.master)
        tree_frame.configure(bg='lavender')
        tree_frame.pack(pady=20)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Service Providers Payments Details", size=40).get_label()
        topic_label.pack()

        # create search button widget and attach it to screen
        button_ascend = Button(search_frame, text="Show all payments ascending", fg="white", bg="navy",
                               font=('Ariel', 16), command=lambda: self.get_service_providers_payments_details(True))

        button_ascend.grid(row=0, column=0, pady=10, padx=10)

        button_ascend = Button(search_frame, text="Show all payments descending", fg="white", bg="navy",
                               font=('Ariel', 16), command=lambda: self.get_service_providers_payments_details(False))
        button_ascend.grid(row=0, column=1, pady=10, padx=10)

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
