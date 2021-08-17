from tkinter import *
from Utils.DateUtil import DateUtil
from connection import Connection
from views.BaseView import BaseView

from custom_widgets.TopicLabel import TopicLabel


class ServiceProvidersPaymentsAddWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def add_provider_payment(self):
        try:
            cur = Connection.CONN.cursor()
            cur.callproc('add_service_payment', [DateUtil.date_converter(self.paid_date_stringVar.get()),
                                                 int(self.work_number_stringVar.get())])

        except Exception as err:
            print('Exception occurred while executing the procedure  ', err)
            self.activate_label_error(err)
        else:
            print("add_service_payment procedure executed")
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
        topic_label = TopicLabel(topic_frame, text="Add Service Provider Payment", size=40).get_label()
        topic_label.pack()

        # define stringVar for paid_date input
        self.paid_date_stringVar = StringVar(input_frame, value="Type paid date DD-MM-YYYY")
        # create entry widget for paid_date, attach it to screen and bind mouse left click to it
        paid_date_entry = Entry(input_frame, textvariable=self.paid_date_stringVar,
                                width=30, font=('Ariel', 16))
        paid_date_entry.bind("<Button-1>", self.clear_text)
        paid_date_entry.grid(row=0, column=0, pady=10, columnspan=2)

        # define stringVar for work_number input
        self.work_number_stringVar = StringVar(input_frame, value="Type Work Number")
        # create entry widget for work_number, attach it to screen and bind mouse left click to it
        work_number_entry = Entry(input_frame, textvariable=self.work_number_stringVar,
                                  width=30, font=('Ariel', 16))
        work_number_entry.bind("<Button-1>", self.clear_text)
        work_number_entry.grid(row=1, column=0, pady=10, columnspan=2)

        # create button to submit input
        button_submit = Button(input_frame, text="Submit", command=self.add_provider_payment)
        button_submit.grid(row=2, column=0, pady=15, columnspan=2)

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()
