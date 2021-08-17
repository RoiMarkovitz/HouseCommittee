from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel

from views.ServiceProviders.ServiceProvidersPayments.ServiceProvidersPaymentsDetailsWindow import \
    ServiceProvidersPaymentsDetailsWindow
from views.ServiceProviders.ServiceProvidersPayments.ServiceProvidersPaymentsModificationWindow import \
    ServiceProvidersModificationWindow


class ServiceProvidersMainPaymentsWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_service_providers_payments_details_window(self):
        # start root for service providers payments details window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Service Providers Payments Details',
                                 Constants.ICON_PATH, True, 'lavender')
        service_providers_payments_details_window = ServiceProvidersPaymentsDetailsWindow(root)
        root.mainloop()

    def start_service_providers_modification_window(self):
        # start root for service providers payments modification window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Service Providers Payments Modification',
                                 Constants.ICON_PATH, True, 'lavender')
        service_providers_payments_modification_window = ServiceProvidersModificationWindow(root)
        root.mainloop()

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack(pady=20)

        # frame that will consist the buttons in the window
        buttons_frame = Frame(self.master)
        buttons_frame.configure(bg='lavender')
        buttons_frame.place(relx=0.5, rely=0.5, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="Service Providers Payments", size=40).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_service_provider_payments_details = PrimaryButton(buttons_frame, "Present Details", 'white', 25,
                                                                 self.start_service_providers_payments_details_window).get_button()
        button_service_provider_payments_details.grid(row=0, pady=10)

        button_service_providers_payments_modification = PrimaryButton(buttons_frame, "Modify", "white", 25,
                                                                       self.start_service_providers_modification_window).get_button()
        button_service_providers_payments_modification.grid(row=1, pady=10)

