from tkinter import *

from connection import Connection
from views.BaseView import BaseView

from custom_widgets.TopicLabel import TopicLabel


class ServiceProvidersRemoveWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def remove_from_providers(self):
        try:
            cur = Connection.CONN.cursor()
            cur.callproc('remove_service_provider',
                         [int(self.business_id_stringVar.get())])

        except Exception as err:
            print('Exception occurred while executing the procedure  ', err)
            self.activate_label_error(err)
        else:
            print("remove_service_provider procedure executed")
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
        topic_label = TopicLabel(topic_frame, text="Remove Service Providers", size=40).get_label()
        topic_label.pack()

        # define stringVar for business_id input
        self.business_id_stringVar = StringVar(input_frame, value="Type business id (9 digits)")
        # create entry widget for business_id, attach it to screen and bind mouse left click to it
        business_id_entry = Entry(input_frame, textvariable=self.business_id_stringVar,
                                  width=30, font=('Ariel', 16))
        business_id_entry.bind("<Button-1>", self.clear_text)
        business_id_entry.grid(row=0, column=0, pady=10)

        # create button to submit input
        button_submit = Button(input_frame, text="Submit", command=self.remove_from_providers)
        button_submit.grid(row=1, column=0, pady=15)

        # create label widget to show error
        self.label_error = Label(errors_frame, text="", fg="red", bg='lavender', font=('Ariel', 14))
        self.label_error.pack()
