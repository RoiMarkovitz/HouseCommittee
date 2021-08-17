from tkinter import *
import tkinter as tk

from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.ServiceProviders.Works.WorksDetailsWindow import WorksDetailsWindow
from views.ServiceProviders.Works.WorksModificationWindow import WorksModificationWindow


class WorksMainWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_works_details_window(self):
        # start root for works details window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Works Details',
                                 Constants.ICON_PATH, True, 'lavender')
        works_details_window = WorksDetailsWindow(root)
        root.mainloop()

    def start_works_modification_window(self):
        # start root for works modification window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Works Modification',
                                 Constants.ICON_PATH, True, 'lavender')
        works_modification_window = WorksModificationWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Works", size=50).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_works_details = PrimaryButton(buttons_frame, "Present Details", 'white', 20,
                                             self.start_works_details_window).get_button()
        button_works_details.grid(row=0, pady=10)
        button_modify_works = PrimaryButton(buttons_frame, "Modify", "white", 20,
                                            self.start_works_modification_window).get_button()
        button_modify_works.grid(row=1, pady=10)

