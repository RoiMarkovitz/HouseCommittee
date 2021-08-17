from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.Tenants.TenantsElections.TenantsElectionsAddWindow import TenantsElectionsAddWindow

from views.Tenants.TenantsElections.TenantsElectionsRemoveWindow import TenantsElectionsRemoveWindow
from views.Tenants.TenantsElections.TenantsElectionsUpdateWindow import TenantsElectionsUpdateWindow


class TenantsElectionsModificationWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_elections_add_window(self):
        # start root for add to election add window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Add To Elections',
                                 Constants.ICON_PATH, True, 'lavender')
        election_add_window = TenantsElectionsAddWindow(root)
        root.mainloop()

    def start_elections_update_window(self):
        # start root for update elections window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Update Elections',
                                 Constants.ICON_PATH, True, 'lavender')
        election_update_window = TenantsElectionsUpdateWindow(root)
        root.mainloop()

    def start_elections_remove_window(self):
        # start root for remove election window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Remove From Elections',
                                 Constants.ICON_PATH, True, 'lavender')
        election_remove_window = TenantsElectionsRemoveWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Elections Modification", size=50).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_elections_add = PrimaryButton(buttons_frame, "Add", 'white', 20,
                                             self.start_elections_add_window).get_button()
        button_elections_add.grid(row=0, pady=10)

        button_elections_update = PrimaryButton(buttons_frame, "Update", "white", 20,
                                                self.start_elections_update_window).get_button()
        button_elections_update.grid(row=1, pady=10)

        button_elections_remove = PrimaryButton(buttons_frame, "Remove", "white", 20,
                                                self.start_elections_remove_window).get_button()
        button_elections_remove.grid(row=2, pady=10)
