from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.ServiceProviders.ServiceProvidersDetails.ServiceProvidersAddWindow import ServiceProvidersAddWindow
from views.ServiceProviders.ServiceProvidersDetails.ServiceProvidersRemoveWindow import ServiceProvidersRemoveWindow
from views.ServiceProviders.ServiceProvidersDetails.ServiceProvidersUpdateWindow import ServiceProvidersUpdateWindow


class ServiceProvidersModificationWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_provider_add_window(self):
        # start root for add service provider window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Add',
                                 Constants.ICON_PATH, True, 'lavender')
        service_provider_add_window = ServiceProvidersAddWindow(root)
        root.mainloop()

    def start_provider_update_window(self):
        # start root for update service provider window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Update',
                                 Constants.ICON_PATH, True, 'lavender')
        service_provider_update_window = ServiceProvidersUpdateWindow(root)
        root.mainloop()

    def start_provider_remove_window(self):
        # start root for remove service provider window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Remove',
                                 Constants.ICON_PATH, True, 'lavender')
        service_provider_remove_window = ServiceProvidersRemoveWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Service Providers Modification", size=40).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_provider_add = PrimaryButton(buttons_frame, "Add", 'white', 20,
                                            self.start_provider_add_window).get_button()
        button_provider_add.grid(row=0, pady=10)

        button_provider_update = PrimaryButton(buttons_frame, "Update", "white", 20,
                                               self.start_provider_update_window).get_button()
        button_provider_update.grid(row=1, pady=10)

        button_provider_remove = PrimaryButton(buttons_frame, "Remove", "white", 20,
                                               self.start_provider_remove_window).get_button()
        button_provider_remove.grid(row=2, pady=10)

