from tkinter import *
from connection import Connection
from views.BaseView import BaseView

from custom_widgets.TopicLabel import TopicLabel


class TenantsUpdateWindow(BaseView):

    def __init__(self, master):
        self.master = master
        self.committee_member = IntVar()
        self.init_widgets()

    def add_to_tenants(self):
        try:
            cur = Connection.CONN.cursor()
            cur.callproc('update_tenant', [int(self.tenant_id_stringVar.get()), self.tenant_first_name_stringVar.get(),
                                           self.tenant_last_name_stringVar.get(),
                                           self.tenant_phone_number_stringVar.get(),
                                           int(self.committee_member.get())])
        except Exception as err:
            print('Exception occurred while executing the procedure  ', err)
            self.activate_label_error(err)
        else:
            print("update_tenant procedure executed")
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

        # frame that will consist of input
        input_frame = Frame(self.master)
        input_frame.configure(bg='lavender')
        input_frame.pack(pady=10)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Update Tenants", size=40).get_label()
        topic_label.pack()

        # define stringVar for tenant_id input
        self.tenant_id_stringVar = StringVar(input_frame, value="Type tenant id (9 digits)")
        # create entry widget for tenant_id, attach it to screen and bind mouse left click to it
        tenant_id_entry = Entry(input_frame, textvariable=self.tenant_id_stringVar,
                                width=30, font=('Ariel', 16))
        tenant_id_entry.bind("<Button-1>", self.clear_text)
        tenant_id_entry.grid(row=0, column=0, pady=10, columnspan=2)

        # define stringVar for tenant_first_name input
        self.tenant_first_name_stringVar = StringVar(input_frame, value="Type First Name")
        # create entry widget for tenant_first_name, attach it to screen and bind mouse left click to it
        tenant_first_name_entry = Entry(input_frame, textvariable=self.tenant_first_name_stringVar,
                                        width=30, font=('Ariel', 16))
        tenant_first_name_entry.bind("<Button-1>", self.clear_text)
        tenant_first_name_entry.grid(row=1, column=0, pady=10, columnspan=2)

        # define stringVar for tenant_last_name input
        self.tenant_last_name_stringVar = StringVar(input_frame, value="Type Last Name")
        # create entry widget for tenant_last_name, attach it to screen and bind mouse left click to it
        tenant_last_name_entry = Entry(input_frame, textvariable=self.tenant_last_name_stringVar,
                                       width=30, font=('Ariel', 16))
        tenant_last_name_entry.bind("<Button-1>", self.clear_text)
        tenant_last_name_entry.grid(row=2, column=0, pady=10, columnspan=2)

        # define stringVar for tenant_phone_number input
        self.tenant_phone_number_stringVar = StringVar(input_frame, value="Type Phone Number")
        # create entry widget for tenant_phone_number, attach it to screen and bind mouse left click to it
        tenant_phone_number_entry = Entry(input_frame, textvariable=self.tenant_phone_number_stringVar,
                                          width=30, font=('Ariel', 16))
        tenant_phone_number_entry.bind("<Button-1>", self.clear_text)
        tenant_phone_number_entry.grid(row=3, column=0, pady=10, columnspan=2)

        tenant_not_chosen = Radiobutton(input_frame, text="Not Committee Member", bg='lavender', font=('Ariel', 14),
                                        variable=self.committee_member,
                                        value=0)
        tenant_not_chosen.grid(row=4, column=0, pady=10, padx=10)

        tenant_chosen = Radiobutton(input_frame, text="Committee Member", bg='lavender', font=('Ariel', 14),
                                    variable=self.committee_member, value=1)
        tenant_chosen.grid(row=4, column=1, pady=10, padx=10)

        # create button to submit input
        button_submit = Button(input_frame, text="Submit", command=self.add_to_tenants)
        button_submit.grid(row=5, column=0, pady=15, columnspan=2)

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()
