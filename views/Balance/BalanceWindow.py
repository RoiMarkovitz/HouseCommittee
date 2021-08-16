from tkinter import *

from connection import Connection
from views.BaseView import BaseView

from custom_widgets.TopicLabel import TopicLabel


class BalanceWindow(BaseView):

    def __init__(self, master):
        self.master = master

        try:
            obj_type = Connection.CONN.gettype("BALANCE_ARRAY")

            cur = Connection.CONN.cursor()
            return_val = cur.callfunc('calculate_balance', obj_type)
            self.balance = return_val.aslist()
        except Exception as err:
            print('Exception occurred while executing the func  ', err)
        else:
            print("calculate_balance function executed")

        finally:
            cur.close()

        self.init_widgets()


    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack()

        # frame that will consist the game options in the window
        mid_frame = Frame(self.master)
        mid_frame.configure(bg='lavender')
        mid_frame.place(relx=0.5, rely=0.5, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Balance", size=50).get_label()
        topic_label.pack()

        # create balance labels
        label_income_name = Label(mid_frame, text="Income:", fg="black", bg='lavender', font=('Ariel', 24))
        label_income_name.grid(row=0, column=0, padx=5, pady=15, sticky=W)

        label_income_value = Label(mid_frame, text=str(self.balance[0]), fg="black", bg='lavender', font=('Ariel', 24))
        label_income_value.grid(row=0, column=1, padx=5, pady=15, sticky=W)

        label_expenses_name = Label(mid_frame, text="Expenses:", fg="black", bg='lavender', font=('Ariel', 24))
        label_expenses_name.grid(row=1, column=0, padx=5, pady=15, sticky=W)

        label_expenses_value = Label(mid_frame, text=str(self.balance[1]), fg="black", bg='lavender',  font=('Ariel', 24))
        label_expenses_value.grid(row=1, column=1, padx=5, pady=15, sticky=W)

        label_balance_name = Label(mid_frame, text="Balance:", fg="black", bg='lavender', font=('Ariel', 24, 'bold'))
        label_balance_name.grid(row=2, column=0, padx=5, pady=15, sticky=W)

        label_balance_value = Label(mid_frame, text=str(self.balance[2]), fg="black", bg='lavender', font=('Ariel', 24, 'bold'))
        label_balance_value.grid(row=2, column=1, padx=5, pady=15, sticky=W)

        # create label widget to show error
        self.label_error = Label(mid_frame, text="", fg="red", bg='lavender', font=('Ariel', 18))
        self.label_error.grid(row=3, pady=15)
