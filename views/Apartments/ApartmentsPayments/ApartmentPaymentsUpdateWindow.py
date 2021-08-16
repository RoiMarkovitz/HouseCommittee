from tkinter import *
from Utils.DateUtil import DateUtil
from connection import Connection
from views.BaseView import BaseView


from custom_widgets.TopicLabel import TopicLabel


class ApartmentPaymentsUpdateWindow(BaseView):

    def __init__(self, master):
        self.master = master
        self.payment_method = StringVar()
        self.init_widgets()

    def update_apartment_payment(self):
        try:
            cur = Connection.CONN.cursor()
            cur.callproc('update_apartment_payment',  [int(self.payment_number_stringVar.get()), DateUtil.date_converter(self.payment_due_date_stringVar.get()),
                                                  self.payment_reason_stringVar.get(), self.first_name_stringVar.get(), self.last_name_stringVar.get(),
                                                       int(self.amount_stringVar.get()), self.payment_method.get(), DateUtil.date_converter(self.paid_date_stringVar.get()),
                         int(self.apartment_number_stringVar.get())])


        except Exception as err:
            print('Exception occurred while executing the procedure  ', err)
            self.activate_label_error(err)
        else:
            print("update_apartment_payment procedure executed")
            Connection.CONN.commit()
        finally:
            cur.close()

    def clear_text(self, event):
        event.widget.delete(0, "end")

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=15)

        # frame that will consist of elections input
        input_frame = Frame(self.master)
        input_frame.configure(bg='lavender')
        input_frame.pack(pady=5)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Update Apartment Payment", size=40).get_label()
        topic_label.pack()

        # define stringVar for payment_number input
        self.payment_number_stringVar = StringVar(input_frame, value="Type payment Number")
        # create entry widget for payment_number, attach it to screen and bind mouse left click to it
        payment_number_entry = Entry(input_frame, textvariable=self.payment_number_stringVar,
                                       width=30, font=('Ariel', 16))
        payment_number_entry.bind("<Button-1>", self.clear_text)
        payment_number_entry.grid(row=0, column=0, pady=5, columnspan=2)

        # define stringVar for payment_due_date input
        self.payment_due_date_stringVar = StringVar(input_frame, value="Type payment due date DD-MM-YYYY")
        # create entry widget for payment_due_date, attach it to screen and bind mouse left click to it
        payment_due_date_entry = Entry(input_frame, textvariable=self.payment_due_date_stringVar,
                                width=30, font=('Ariel', 16))
        payment_due_date_entry.bind("<Button-1>", self.clear_text)
        payment_due_date_entry.grid(row=1, column=0, pady=5, columnspan=2)

        # define stringVar for payment_reason input
        self.payment_reason_stringVar = StringVar(input_frame, value="Type Payment Reason")
        # create entry widget for payment_reason, attach it to screen and bind mouse left click to it
        payment_reason_entry = Entry(input_frame, textvariable=self.payment_reason_stringVar,
                                       width=30, font=('Ariel', 16))
        payment_reason_entry.bind("<Button-1>", self.clear_text)
        payment_reason_entry.grid(row=2, column=0, pady=5, columnspan=2)

        # define stringVar for first_name input
        self.first_name_stringVar = StringVar(input_frame, value="Type First Name")
        # create entry widget for first_name, attach it to screen and bind mouse left click to it
        first_name_entry = Entry(input_frame, textvariable=self.first_name_stringVar,
                                     width=30, font=('Ariel', 16))
        first_name_entry.bind("<Button-1>", self.clear_text)
        first_name_entry.grid(row=3, column=0, pady=5, columnspan=2)

        # define stringVar for last_name input
        self.last_name_stringVar = StringVar(input_frame, value="Type Last Name")
        # create entry widget for last_name, attach it to screen and bind mouse left click to it
        last_name_entry = Entry(input_frame, textvariable=self.last_name_stringVar,
                                 width=30, font=('Ariel', 16))
        last_name_entry.bind("<Button-1>", self.clear_text)
        last_name_entry.grid(row=4, column=0, pady=5, columnspan=2)

        # define stringVar for amount input
        self.amount_stringVar = StringVar(input_frame, value="Type Payment Amount")
        # create entry widget for amount, attach it to screen and bind mouse left click to it
        amount_entry = Entry(input_frame, textvariable=self.amount_stringVar,
                                     width=30, font=('Ariel', 16))
        amount_entry.bind("<Button-1>", self.clear_text)
        amount_entry.grid(row=5, column=0, pady=5, columnspan=2)

        cash_method = Radiobutton(input_frame, text="cash", bg='lavender', font=('Ariel', 16),
                                  variable=self.payment_method, value='cash')
        cash_method.grid(row=6, column=0, pady=5, padx=10)
        cash_method.select()

        credit_method = Radiobutton(input_frame, text="credit", bg='lavender', font=('Ariel', 16),
                                    variable=self.payment_method, value='credit')
        credit_method.grid(row=6, column=1, pady=5, padx=10)

        # define stringVar for paid_date input
        self.paid_date_stringVar = StringVar(input_frame, value="Type paid date DD-MM-YYYY")
        # create entry widget for paid_date, attach it to screen and bind mouse left click to it
        paid_date_entry = Entry(input_frame, textvariable=self.paid_date_stringVar,
                                       width=30, font=('Ariel', 16))
        paid_date_entry.bind("<Button-1>", self.clear_text)
        paid_date_entry.grid(row=7, column=0, pady=5, columnspan=2)

        # define stringVar for apartment_number input
        self.apartment_number_stringVar = StringVar(input_frame, value="Type Apartment Number (9 digits)")
        # create entry widget for apartment_number, attach it to screen and bind mouse left click to it
        apartment_number_entry = Entry(input_frame, textvariable=self.apartment_number_stringVar,
                                width=30, font=('Ariel', 16))
        apartment_number_entry.bind("<Button-1>", self.clear_text)
        apartment_number_entry.grid(row=8, column=0, pady=5, columnspan=2)

        # create button to submit input
        button_submit = Button(input_frame, text="Submit", command=self.update_apartment_payment)
        button_submit.grid(row=9, column=0, pady=10, columnspan=2)

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()





