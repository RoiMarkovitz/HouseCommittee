from tkinter import *
from tkinter import messagebox, ttk
from connection import Connection
from views.BaseView import BaseView
from Utils.ObjectsHandler import ObjectsHandler
from custom_widgets.TopicLabel import TopicLabel
from Utils.DateUtil import DateUtil


class ApartmentsPaymentsDetailsWindow(BaseView):
    SHOW_ALL = 0
    SHOW_BY_DATE_RANGE = 1
    SHOW_BY_APARTMENT_NUMBER = 2

    def __init__(self, master):
        self.master = master

        self.init_widgets()

        self.get_apartments_payments_details(ApartmentsPaymentsDetailsWindow.SHOW_ALL)

    def clear_text(self, event):
        event.widget.delete(0, "end")

    def get_apartments_payments_details(self, show_by):
        try:
            obj_type = Connection.CONN.gettype("APART_PAYMENTS_TBL_TYPE")
            cur = Connection.CONN.cursor()
            if show_by == ApartmentsPaymentsDetailsWindow.SHOW_ALL:
                return_obj = cur.callfunc('get_all_apartment_payments', obj_type)
            elif show_by == ApartmentsPaymentsDetailsWindow.SHOW_BY_DATE_RANGE:
                return_obj = cur.callfunc('get_apartments_owes_by_date_range', obj_type,
                                          [DateUtil.date_converter(self.start_date_stringVar.get()),
                                           DateUtil.date_converter(self.end_date_stringVar.get())])
            elif show_by == ApartmentsPaymentsDetailsWindow.SHOW_BY_APARTMENT_NUMBER:
                return_obj = cur.callfunc('get_apartments_owes_by_apartment_range', obj_type,
                                          [int(self.min_apart_num_stringVar.get()),
                                           int(self.max_apart_num_stringVar.get())])

            self.dict_apartments_payments = ObjectsHandler.ObjectRepr(return_obj)

        except Exception as err:
            print('Exception occurred while executing the func  ', err)
            self.activate_label_error(err)
        else:
            if show_by == ApartmentsPaymentsDetailsWindow.SHOW_ALL:
                print("get_all_apartment_payments function executed")
            elif show_by == ApartmentsPaymentsDetailsWindow.SHOW_BY_DATE_RANGE:
                print("get_apartments_owes_by_date_range function executed")
            elif show_by == ApartmentsPaymentsDetailsWindow.SHOW_BY_APARTMENT_NUMBER:
                print("get_apartments_owes_by_apartment_range function executed")

            self.show_all_details()
        finally:
            cur.close()

    def show_all_details(self):
        self.remove_all_records()

        for index in range(len(self.dict_apartments_payments)):
            records = ['', '', '', '', '', '', '', '', '']
            for i, key in enumerate(self.dict_apartments_payments[index]):
                if key == 'PAYMENT_NUMBER':
                    records.insert(0, self.dict_apartments_payments[index][key])
                if key == 'PAYMENT_DUE_DATE':
                    records.insert(1, self.dict_apartments_payments[index][key].strftime('%x'))
                if key == 'REASON':
                    records.insert(2, self.dict_apartments_payments[index][key])
                if key == 'FIRST_NAME':
                    records.insert(3, self.dict_apartments_payments[index][key])
                if key == 'LAST_NAME':
                    records.insert(4, self.dict_apartments_payments[index][key])
                if key == 'AMOUNT':
                    records.insert(5, self.dict_apartments_payments[index][key])
                if key == 'PAYMENT_METHOD':
                    records.insert(6, self.dict_apartments_payments[index][key])
                if key == 'PAID_DATE':
                    records.insert(7, self.dict_apartments_payments[index][key].strftime('%x'))
                if key == 'APARTMENT_NUMBER':
                    records.insert(8, self.dict_apartments_payments[index][key])

            self.records_tree.insert(parent='', index='end', iid=index, text="",
                                     values=(records[0], records[1], records[2],
                                             records[3], records[4], records[5],
                                             records[6], records[7], records[8]))

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
        header = ['Payment #', 'Due Date', 'Reason', 'First Name',
                  'Last Name', 'Amount', 'Pay Method', 'Paid Date', 'Apartment #']
        header_style = ttk.Style()
        header_style.configure("Treeview.Heading", font=(None, 12, 'bold'))

        # define columns
        self.records_tree["columns"] = (header[0], header[1], header[2], header[3], header[4], header[5],
                                        header[6], header[7], header[8])
        # format columns
        self.records_tree.column("#0", width=0, stretch=NO)
        self.records_tree.column(header[0], anchor=CENTER, width=100)
        self.records_tree.column(header[1], anchor=CENTER, width=80)
        self.records_tree.column(header[2], anchor=CENTER, width=80)
        self.records_tree.column(header[3], anchor=CENTER, width=100)
        self.records_tree.column(header[4], anchor=CENTER, width=100)
        self.records_tree.column(header[5], anchor=CENTER, width=80)
        self.records_tree.column(header[6], anchor=CENTER, width=100)
        self.records_tree.column(header[7], anchor=CENTER, width=80)
        self.records_tree.column(header[8], anchor=CENTER, width=100)
        # create headings
        self.records_tree.heading("#0", text="", anchor=CENTER)
        self.records_tree.heading(header[0], text=header[0], anchor=CENTER)
        self.records_tree.heading(header[1], text=header[1], anchor=CENTER)
        self.records_tree.heading(header[2], text=header[2], anchor=CENTER)
        self.records_tree.heading(header[3], text=header[3], anchor=CENTER)
        self.records_tree.heading(header[4], text=header[4], anchor=CENTER)
        self.records_tree.heading(header[5], text=header[5], anchor=CENTER)
        self.records_tree.heading(header[6], text=header[6], anchor=CENTER)
        self.records_tree.heading(header[7], text=header[7], anchor=CENTER)
        self.records_tree.heading(header[8], text=header[8], anchor=CENTER)

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=10)

        # frame that will consist the search in the window
        search_frame = Frame(self.master)
        search_frame.configure(bg='lavender')
        search_frame.pack()

        # frame that will consist the table of the records
        tree_frame = Frame(self.master)
        tree_frame.configure(bg='lavender')
        tree_frame.pack(pady=10)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Apartments Payments Details", size=40).get_label()
        topic_label.pack()

        # create search button widget and attach it to screen
        button_all = Button(search_frame, text="Show All", fg="white", bg="navy", font=('Ariel', 16),
                            command=lambda: self.get_apartments_payments_details
                            (ApartmentsPaymentsDetailsWindow.SHOW_ALL))

        button_all.grid(row=0, column=0, pady=5, columnspan=3)

        button_date_range = Button(search_frame, text="Show Debts By Date Range", fg="white", bg="navy",
                                   font=('Ariel', 14),
                                   command=lambda: self.get_apartments_payments_details
                                   (ApartmentsPaymentsDetailsWindow.SHOW_BY_DATE_RANGE))
        button_date_range.grid(row=1, column=2, pady=5, padx=10, sticky=W)

        button_apart_num_range = Button(search_frame, text="Show Debts By Apartment # Range", fg="white", bg="navy",
                                        font=('Ariel', 14),
                                        command=lambda: self.get_apartments_payments_details
                                        (ApartmentsPaymentsDetailsWindow.SHOW_BY_APARTMENT_NUMBER))
        button_apart_num_range.grid(row=2, column=2, pady=5, padx=10, sticky=W)

        # define stringVar for start_date input
        self.start_date_stringVar = StringVar(search_frame, value="start date DD-MM-YYYY")
        # create entry widget for start_date, attach it to screen and bind mouse left click to it
        start_date_entry = Entry(search_frame, textvariable=self.start_date_stringVar, font=('Ariel', 14))
        start_date_entry.bind("<Button-1>", self.clear_text)
        start_date_entry.grid(row=1, column=0, padx=5, pady=5)

        # define stringVar for end_date input
        self.end_date_stringVar = StringVar(search_frame, value="end date DD-MM-YYYY")
        # create entry widget for end_date, attach it to screen and bind mouse left click to it
        end_date_entry = Entry(search_frame, textvariable=self.end_date_stringVar, font=('Ariel', 14))
        end_date_entry.bind("<Button-1>", self.clear_text)
        end_date_entry.grid(row=1, column=1, padx=5, pady=5)

        # define stringVar for min_apart_num input
        self.min_apart_num_stringVar = StringVar(search_frame, value="lower range number")
        # create entry widget for min_apart_num, attach it to screen and bind mouse left click to it
        min_apart_num_entry = Entry(search_frame, textvariable=self.min_apart_num_stringVar, font=('Ariel', 14))
        min_apart_num_entry.bind("<Button-1>", self.clear_text)
        min_apart_num_entry.grid(row=2, column=0, padx=5, pady=5)

        # define stringVar for max_apart_num input
        self.max_apart_num_stringVar = StringVar(search_frame, value="upper range number")
        # create entry widget for max_apart_num, attach it to screen and bind mouse left click to it
        max_apart_num_entry = Entry(search_frame, textvariable=self.max_apart_num_stringVar, font=('Ariel', 14))
        max_apart_num_entry.bind("<Button-1>", self.clear_text)
        max_apart_num_entry.grid(row=2, column=1, padx=5, pady=5)

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
