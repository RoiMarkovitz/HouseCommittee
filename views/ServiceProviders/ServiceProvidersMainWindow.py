from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.ServiceProviders.ServiceProvidersDetails.ServiceProvidersDetailsMainWindow import \
    ServiceProvidersDetailsMainWindow
from views.ServiceProviders.ServiceProvidersPayments.ServiceProvidersMainPaymentsWindow import \
    ServiceProvidersMainPaymentsWindow
from views.ServiceProviders.Works.WorksMainWindow import WorksMainWindow


class ServiceProvidersMainWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_service_providers_details_main_window(self):
        # start root for service providers details window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Service Providers Details',
                                 Constants.ICON_PATH, True, 'lavender')
        service_providers_details_main_window = ServiceProvidersDetailsMainWindow(root)
        root.mainloop()

    def start_works_main_window(self):
        # start root for works window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Works',
                                 Constants.ICON_PATH, True, 'lavender')
        works_main_window = WorksMainWindow(root)
        root.mainloop()

    def start_service_providers_main_payments_window(self):
        # start root for service providers payments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Service Providers Payments',
                                 Constants.ICON_PATH, True, 'lavender')
        service_providers_main_payments_window = ServiceProvidersMainPaymentsWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Service Providers", size=50).get_label()
        topic_label.pack()

        # create game-start buttons custom_widgets and attach them to screen
        button_service_provider_details = PrimaryButton(buttons_frame, "Details", 'white', 25,
                                                        self.start_service_providers_details_main_window).get_button()
        button_service_provider_details.grid(row=0, pady=10)
        button_works = PrimaryButton(buttons_frame, "Works", "white", 25,
                                     self.start_works_main_window).get_button()
        button_works.grid(row=1, pady=10)
        button_service_providers_main_payments = PrimaryButton(buttons_frame, "Payments", "white", 25,
                                                               self.start_service_providers_main_payments_window).get_button()
        button_service_providers_main_payments.grid(row=2, pady=10)

