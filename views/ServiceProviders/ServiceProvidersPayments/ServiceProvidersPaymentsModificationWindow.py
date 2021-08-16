from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.ServiceProviders.ServiceProvidersPayments.ServiceProvidersPaymentsAddWindow import \
    ServiceProvidersPaymentsAddWindow
from views.ServiceProviders.ServiceProvidersPayments.ServiceProvidersPaymentsUpdateWindow import \
    ServiceProvidersPaymentsUpdateWindow
from views.ServiceProviders.Works.WorksAddWindow import WorksAddWindow
from views.ServiceProviders.Works.WorksUpdateWindow import WorksUpdateWindow


class ServiceProvidersModificationWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()


    def start_add_payment_window(self):
        # start root for add to service providers payments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Add to service providers payments',
                                 Constants.ICON_PATH, True, 'lavender')
        payments_add_window = ServiceProvidersPaymentsAddWindow(root)
        root.mainloop()

    def start_update_payment_window(self):
        # start root for update service providers payments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Update service providers payments',
                                 Constants.ICON_PATH, True, 'lavender')
        payments_update_window = ServiceProvidersPaymentsUpdateWindow(root)
        root.mainloop()

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=20)

        # frame that will consist the game options in the window
        options_frame = Frame(self.master)
        options_frame.configure(bg='lavender')
        options_frame.place(relx=0.5, rely=0.5, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Service Providers Payments Modification", size=30).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_payments_add = PrimaryButton(options_frame, "Add", 'white', 20,
                                                 self.start_add_payment_window).get_button()
        button_payments_add.grid(row=0, pady=10)

        button_payments_update = PrimaryButton(options_frame, "Update", "white", 20,
                                                self.start_update_payment_window).get_button()
        button_payments_update.grid(row=1, pady=10)

        # create label widget to show error
        self.label_error = Label(options_frame, text="", fg="red", bg='lavender', font=('Ariel', 18))
        self.label_error.grid(row=3, pady=10)
