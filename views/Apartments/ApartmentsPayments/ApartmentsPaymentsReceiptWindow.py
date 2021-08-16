from tkinter import *

from connection import Connection
from views.BaseView import BaseView
from Utils.ObjectsHandler import ObjectsHandler

from custom_widgets.TopicLabel import TopicLabel


class ApartmentsPaymentsReceiptWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def clear_text(self, event):
        event.widget.delete(0, "end")

    def show_receipt_details(self):
        try:
            obj_type = Connection.CONN.gettype("APART_PAYMENTS_TBL_TYPE")

            cur = Connection.CONN.cursor()
            inp = [self.payment_number_stringVar.get()]
            return_obj = cur.callfunc('get_receipt_details', obj_type, inp)
            lst = ObjectsHandler.ObjectRepr(return_obj)
            self.dict_receipt = lst[0]
            print(self.dict_receipt)

        except Exception as err:
            print('Exception occurred while executing the func  ', err)
            self.activate_label_error(err)
        else:
            print("get_receipt_details function executed")
            self.label_payment_number_value['text'] = str(self.dict_receipt.get('PAYMENT_NUMBER'))
            self.label_payment_due_date_value['text'] = self.dict_receipt.get('PAYMENT_DUE_DATE').strftime('%x')
            self.label_payment_reason_value['text'] = self.dict_receipt.get('REASON')
            self.label_payment_payer_value['text'] = self.dict_receipt.get('FIRST_NAME') + " " + self.dict_receipt.get('LAST_NAME')
            self.label_payment_amount_value['text'] = self.dict_receipt.get('AMOUNT')
            self.label_payment_method_value['text'] = self.dict_receipt.get('PAYMENT_METHOD')
            self.label_payment_date_value['text'] = self.dict_receipt.get('PAID_DATE').strftime('%x')
            self.label_payment_apr_num_value['text'] = self.dict_receipt.get('APARTMENT_NUMBER')
        finally:
            #conn.commit()
            cur.close()

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=5)

        # frame that will consist of payment number user input
        input_frame = Frame(self.master)
        input_frame.configure(bg='lavender')
        input_frame.pack(pady=5)

        # frame that will consist of receipt details in the window
        details_frame = Frame(self.master)
        details_frame.configure(bg='lavender')
        details_frame.place(relx=0.5, rely=0.55, anchor=CENTER)

        # frame that will consist of errors in the window
        errors_frame = Frame(self.master)
        errors_frame.configure(bg='lavender')
        errors_frame.place(relx=0.5, rely=0.9, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Apartments Payments Receipt", size=40).get_label()
        topic_label.pack()

        # define stringVar for nickname input
        self.payment_number_stringVar = StringVar(input_frame, value="Type payment number")
        # create entry widget for payment number, attach it to screen and bind mouse left click to it
        payment_number_entry = Entry(input_frame, textvariable=self.payment_number_stringVar,
                               width=30, font=('Ariel', 18))
        payment_number_entry.bind("<Button-1>", self.clear_text)
        payment_number_entry.grid(row=0, column=0, pady=25, padx=10)

        # create button to submit nickname input
        button_submit = Button(input_frame, text="Submit", command=self.show_receipt_details)
        button_submit.grid(row=0, column=1, pady=25)

        # create receipt labels
        label_payment_number_name = Label(details_frame, text="Payment Number:", fg="black", bg='lavender', font=('Ariel', 14))
        label_payment_number_name.grid(row=0, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_number_value = Label(details_frame, text='',
                                           fg="black", bg='lavender', font=('Ariel', 14))
        self.label_payment_number_value.grid(row=0, column=1, padx=5, pady=5, sticky=W)

        label_payment_due_date_name = Label(details_frame, text="Payment Due Date:", fg="black", bg='lavender', font=('Ariel', 14))
        label_payment_due_date_name.grid(row=1, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_due_date_value = Label(details_frame, text='', fg="black",
                                           bg='lavender', font=('Ariel', 14))
        self.label_payment_due_date_value.grid(row=1, column=1, padx=5, pady=5, sticky=W)

        label_payment_reason_name = Label(details_frame, text="Reason:", fg="black", bg='lavender',
                                            font=('Ariel', 14))
        label_payment_reason_name.grid(row=2, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_reason_value = Label(details_frame, text='', fg="black",
                                             bg='lavender', font=('Ariel', 14))
        self.label_payment_reason_value.grid(row=2, column=1, padx=5, pady=5, sticky=W)

        label_payment_payer_name = Label(details_frame, text="Name:", fg="black", bg='lavender',
                                          font=('Ariel', 14))
        label_payment_payer_name.grid(row=3, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_payer_value = Label(details_frame, text='', fg="black",
                                           bg='lavender', font=('Ariel', 14))
        self.label_payment_payer_value.grid(row=3, column=1, padx=5, pady=5, sticky=W)

        label_payment_amount_name = Label(details_frame, text="Amount:", fg="black", bg='lavender',
                                         font=('Ariel', 14))
        label_payment_amount_name.grid(row=4, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_amount_value = Label(details_frame, text='', fg="black",
                                          bg='lavender', font=('Ariel', 14))
        self.label_payment_amount_value.grid(row=4, column=1, padx=5, pady=5, sticky=W)

        label_payment_method_name = Label(details_frame, text="Payment Method:", fg="black", bg='lavender',
                                          font=('Ariel', 14))
        label_payment_method_name.grid(row=5, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_method_value = Label(details_frame, text='', fg="black",
                                           bg='lavender', font=('Ariel', 14))
        self.label_payment_method_value.grid(row=5, column=1, padx=5, pady=5, sticky=W)

        label_payment_date_name = Label(details_frame, text="Paid Date:", fg="black", bg='lavender',
                                          font=('Ariel', 14))
        label_payment_date_name.grid(row=6, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_date_value = Label(details_frame, text='', fg="black",
                                           bg='lavender', font=('Ariel', 14))
        self.label_payment_date_value.grid(row=6, column=1, padx=5, pady=5, sticky=W)

        label_payment_apr_num_name = Label(details_frame, text="Apartment Number:", fg="black", bg='lavender',
                                        font=('Ariel', 14))
        label_payment_apr_num_name.grid(row=7, column=0, padx=5, pady=5, sticky=W)
        self.label_payment_apr_num_value = Label(details_frame, text='', fg="black",
                                         bg='lavender', font=('Ariel', 14))
        self.label_payment_apr_num_value.grid(row=7, column=1, padx=5, pady=5, sticky=W)

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()





