from tkinter import *
from Utils.DateUtil import DateUtil
from connection import Connection
from views.BaseView import BaseView

from custom_widgets.TopicLabel import TopicLabel


class TenantsElectionsRemoveWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def remove_from_elections(self):
        try:
            cur = Connection.CONN.cursor()
            cur.callproc('remove_from_elections',
                         [DateUtil.date_converter(self.election_date_stringVar.get()),
                          int(self.tenant_id_stringVar.get())])

        except Exception as err:
            print('Exception occurred while executing the procedure  ', err)
            self.activate_label_error(err)
        else:
            print("remove_from_elections procedure executed")
            Connection.CONN.commit()
        finally:
            cur.close()

    def clear_text(self, event):
        event.widget.delete(0, "end")

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=5)

        # frame that will consist of input
        input_frame = Frame(self.master)
        input_frame.configure(bg='lavender')
        input_frame.pack(pady=5)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Remove From Elections", size=40).get_label()
        topic_label.pack()

        # define stringVar for election_date input
        self.election_date_stringVar = StringVar(input_frame, value="Type election date DD-MM-YYYY")
        # create entry widget for election_date, attach it to screen and bind mouse left click to it
        election_date_entry = Entry(input_frame, textvariable=self.election_date_stringVar,
                                    width=30, font=('Ariel', 16))
        election_date_entry.bind("<Button-1>", self.clear_text)
        election_date_entry.grid(row=0, column=0, pady=10)

        # define stringVar for tenant_id input
        self.tenant_id_stringVar = StringVar(input_frame, value="Type tenant id (9 digits)")
        # create entry widget for tenant_id, attach it to screen and bind mouse left click to it
        tenant_id_entry = Entry(input_frame, textvariable=self.tenant_id_stringVar,
                                width=30, font=('Ariel', 16))
        tenant_id_entry.bind("<Button-1>", self.clear_text)
        tenant_id_entry.grid(row=1, column=0, pady=10)

        # create button to submit input
        button_submit = Button(input_frame, text="Submit", command=self.remove_from_elections)
        button_submit.grid(row=2, column=0, pady=15)

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()
