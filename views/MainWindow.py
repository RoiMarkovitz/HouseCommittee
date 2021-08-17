from tkinter import *
import tkinter as tk

from views.Apartments.ApartmentsMainWindow import ApartmentsMainWindow
from views.Balance.BalanceWindow import BalanceWindow
from views.BaseView import BaseView

from Utils.WindowUtil import WindowUtil
from constants import Constants

from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.ServiceProviders.ServiceProvidersMainWindow import ServiceProvidersMainWindow
from views.Tenants.TenantsMainWindow import TenantsMainWindow


class MainWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_tenants_main_window(self):
        # start root for tenants window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Tenants',
                                 Constants.ICON_PATH, True, 'lavender')
        tenants_window = TenantsMainWindow(root)
        root.mainloop()

    def start_apartments_main_window(self):
        # start root for apartments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Apartments',
                                 Constants.ICON_PATH, True, 'lavender')
        apartments_window = ApartmentsMainWindow(root)
        root.mainloop()

    def start_serivce_providers_main_window(self):
        # start root for service providers window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Service Providers',
                                 Constants.ICON_PATH, True, 'lavender')
        service_providers_window = ServiceProvidersMainWindow(root)
        root.mainloop()

    def start_balance_window(self):
        # start root for balance window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Balance',
                                 Constants.ICON_PATH, True, 'lavender')
        balance_window = BalanceWindow(root)
        root.mainloop()

    def init_widgets(self):
        # frame that will consist the topic in the window
        topic_frame = Frame(self.master)
        topic_frame.configure(bg='lavender')
        topic_frame.pack()

        # frame that will consist the buttons in the window
        buttons_frame = Frame(self.master)
        buttons_frame.configure(bg='lavender')
        buttons_frame.place(relx=0.5, rely=0.5, anchor=CENTER)

        # create label widget for topic of the window
        topic_label = TopicLabel(topic_frame, text="House Committee", size=50).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_tenants = PrimaryButton(buttons_frame, "Tenants", 'white', 15,
                                       self.start_tenants_main_window).get_button()
        button_tenants.grid(row=0, padx=5, pady=10)
        button_apartments = PrimaryButton(buttons_frame, "Apartments", 'white', 15,
                                          self.start_apartments_main_window).get_button()
        button_apartments.grid(row=1, padx=5, pady=10)
        button_providers = PrimaryButton(buttons_frame, "Service Providers", 'white', 15,
                                         self.start_serivce_providers_main_window).get_button()
        button_providers.grid(row=2, padx=5, pady=10)
        button_balance = PrimaryButton(buttons_frame, "Balance", 'white', 15, self.start_balance_window).get_button()
        button_balance.grid(row=3, padx=5, pady=10)

