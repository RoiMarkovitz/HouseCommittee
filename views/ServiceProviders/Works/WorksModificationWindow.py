from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.ServiceProviders.Works.WorksAddWindow import WorksAddWindow
from views.ServiceProviders.Works.WorksUpdateWindow import WorksUpdateWindow


class WorksModificationWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_works_add_window(self):
        # start root for add to works window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Add Works',
                                 Constants.ICON_PATH, True, 'lavender')
        works_add_window = WorksAddWindow(root)
        root.mainloop()

    def start_works_update_window(self):
        # start root for update works window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Update Works',
                                 Constants.ICON_PATH, True, 'lavender')
        works_update_window = WorksUpdateWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Works Modification", size=50).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_works_add = PrimaryButton(buttons_frame, "Add", 'white', 20,
                                         self.start_works_add_window).get_button()
        button_works_add.grid(row=0, pady=10)

        button_works_update = PrimaryButton(buttons_frame, "Update", "white", 20,
                                            self.start_works_update_window).get_button()
        button_works_update.grid(row=1, pady=10)

