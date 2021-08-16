from tkinter import *
from Utils.DateUtil import DateUtil
from connection import Connection
from views.BaseView import BaseView


from custom_widgets.TopicLabel import TopicLabel


class WorksUpdateWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def add_to_tenants(self):
        try:
            cur = Connection.CONN.cursor()
            cur.callproc('add_work',  [self.work_type_stringVar.get(), int(self.price_stringVar.get()),
                                         int(self.business_number_stringVar.get()),
                                                   int(self.tenant_id_stringVar.get())])

        except Exception as err:
            print('Exception occurred while executing the procedure  ', err)
            self.activate_label_error(err)
        else:
            print("add_work procedure executed")
            Connection.CONN.commit()
        finally:
            cur.close()

    def clear_text(self, event):
        event.widget.delete(0, "end")

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=20)

        # frame that will consist of elections input
        input_frame = Frame(self.master)
        input_frame.configure(bg='lavender')
        input_frame.pack(pady=10)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Add To Works", size=40).get_label()
        topic_label.pack()

        # define stringVar for work_type input
        self.work_type_stringVar = StringVar(input_frame, value="Work Type")
        # create entry widget for work_type, attach it to screen and bind mouse left click to it
        work_type_entry = Entry(input_frame, textvariable=self.work_type_stringVar,
                                width=30, font=('Ariel', 16))
        work_type_entry.bind("<Button-1>", self.clear_text)
        work_type_entry.grid(row=0, column=0, pady=10, columnspan=2)

        # define stringVar for price input
        self.price_stringVar = StringVar(input_frame, value="Type Price")
        # create entry widget for price, attach it to screen and bind mouse left click to it
        price_entry = Entry(input_frame, textvariable=self.price_stringVar,
                                width=30, font=('Ariel', 16))
        price_entry.bind("<Button-1>", self.clear_text)
        price_entry.grid(row=1, column=0, pady=10, columnspan=2)

        # define stringVar for business_number input
        self.business_number_stringVar = StringVar(input_frame, value="Type Business Number (9 digits)")
        # create entry widget for business_number, attach it to screen and bind mouse left click to it
        business_number_entry = Entry(input_frame, textvariable=self.business_number_stringVar,
                                        width=30, font=('Ariel', 16))
        business_number_entry.bind("<Button-1>", self.clear_text)
        business_number_entry.grid(row=2, column=0, pady=10, columnspan=2)

        # define stringVar for tenant_id input
        self.tenant_id_stringVar = StringVar(input_frame, value="Type Tenant ID (9 digits)")
        # create entry widget for tenant_id, attach it to screen and bind mouse left click to it
        tenant_id_entry = Entry(input_frame, textvariable=self.tenant_id_stringVar,
                                           width=20, font=('Ariel', 16))
        tenant_id_entry.bind("<Button-1>", self.clear_text)
        tenant_id_entry.grid(row=3, column=0, pady=10, columnspan=2, sticky=W)

        # create button to submit input
        button_submit = Button(input_frame, text="Submit", command=self.add_to_tenants)
        button_submit.grid(row=4, column=0, pady=15, columnspan=2)

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()





