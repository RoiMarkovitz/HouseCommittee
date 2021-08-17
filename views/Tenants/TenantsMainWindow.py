from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.Tenants.TenantsDetails.TenantsDetailsMainWindow import TenantsDetailsMainWindow
from views.Tenants.TenantsElections.TenantsElectionsMainWindow import TenantsElectionsMainWindow


class TenantsMainWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_tenants_details_window(self):
        # start root for tenants details window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Tenants Details',
                                 Constants.ICON_PATH, True, 'lavender')
        tenants_details_main_window = TenantsDetailsMainWindow(root)
        root.mainloop()

    def start_tenants_elections_window(self):
        # start root for elections window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Elections',
                                 Constants.ICON_PATH, True, 'lavender')
        elections_main_window = TenantsElectionsMainWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Tenants", size=50).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_tenants_details = PrimaryButton(buttons_frame, "Details", 'white', 20,
                                               self.start_tenants_details_window).get_button()
        button_tenants_details.grid(row=0, pady=10)
        button_elections = PrimaryButton(buttons_frame, "Elections", "white", 20,
                                         self.start_tenants_elections_window).get_button()
        button_elections.grid(row=1, pady=10)
