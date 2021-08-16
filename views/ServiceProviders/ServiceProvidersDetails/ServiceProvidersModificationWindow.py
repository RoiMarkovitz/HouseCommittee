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
from views.Tenants.TenantsElections.TenantsElectionsAddWindow import TenantsElectionsAddWindow

from views.Tenants.TenantsElections.TenantsElectionsRemoveWindow import TenantsElectionsRemoveWindow
from views.Tenants.TenantsElections.TenantsElectionsUpdateWindow import TenantsElectionsUpdateWindow


class ServiceProvidersModificationWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()


    def start_provider_add_window(self):
        # start root for add to election window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Add',
                                 Constants.ICON_PATH, True, 'lavender')
        election_add_window = ServiceProvidersAddWindow(root)
        root.mainloop()

    def start_provider_update_window(self):
        # start root for update electins window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Update',
                                 Constants.ICON_PATH, True, 'lavender')
        election_update_window = ServiceProvidersUpdateWindow(root)
        root.mainloop()

    def start_provider_remove_window(self):
        # start root for update electins window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Remove',
                                 Constants.ICON_PATH, True, 'lavender')
        election_remove_window = ServiceProvidersRemoveWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Service Providers Modification", size=40).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_provider_add = PrimaryButton(options_frame, "Add", 'white', 20,
                                                 self.start_provider_add_window).get_button()
        button_provider_add.grid(row=0, pady=10)

        button_provider_update = PrimaryButton(options_frame, "Update", "white", 20,
                                                      self.start_provider_update_window).get_button()
        button_provider_update.grid(row=1, pady=10)

        button_provider_remove = PrimaryButton(options_frame, "Remove", "white", 20,
                                                self.start_provider_remove_window).get_button()
        button_provider_remove.grid(row=2, pady=10)

        # create label widget to show error
        self.label_error = Label(options_frame, text="", fg="red", bg='lavender', font=('Ariel', 18))
        self.label_error.grid(row=4, pady=10)
