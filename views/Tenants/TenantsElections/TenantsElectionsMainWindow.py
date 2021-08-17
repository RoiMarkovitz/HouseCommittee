from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel

from views.Tenants.TenantsElections.TenantsElectionsDetailsWindow import TenantsElectionsDetailsWindow
from views.Tenants.TenantsElections.TenantsElectionsModificationWindow import TenantsElectionsModificationWindow


class TenantsElectionsMainWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_elections_details_window(self):
        # start root for election details window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Elections Details',
                                 Constants.ICON_PATH, True, 'lavender')
        election_details_window = TenantsElectionsDetailsWindow(root)
        root.mainloop()

    def start_elections_modification_window(self):
        # start root for elections modification window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Elections Modification',
                                 Constants.ICON_PATH, True, 'lavender')
        election_modification_window = TenantsElectionsModificationWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Elections", size=50).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_elections_details = PrimaryButton(buttons_frame, "Present Details", 'white', 20,
                                                 self.start_elections_details_window).get_button()
        button_elections_details.grid(row=0, pady=10)
        button_elections_modification = PrimaryButton(buttons_frame, "Modify", "white", 20,
                                                      self.start_elections_modification_window).get_button()
        button_elections_modification.grid(row=1, pady=10)

