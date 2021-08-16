from tkinter import *
import tkinter as tk


from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.Tenants.TenantsDetails.TenantsDetailsWindow import TenantsDetailsWindow
from views.Tenants.TenantsDetails.TenantsModificationWindow import TenantsModificationWindow


class TenantsDetailsMainWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_tenants_details_window(self):
        # start root for apartments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Tenants Details',
                                 Constants.ICON_PATH, True, 'lavender')
        #    root.protocol("WM_DELETE_WINDOW", lambda: self.on_closing(root, 1))
        tenants_details_window = TenantsDetailsWindow(root)
        root.mainloop()

    def start_tenants_modification_window(self):
        # start root for apartments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Tenants Modification',
                                 Constants.ICON_PATH, True, 'lavender')
        #    root.protocol("WM_DELETE_WINDOW", lambda: self.on_closing(root, 1))
        tenants_modification_window = TenantsModificationWindow(root)
        root.mainloop()

    def clear_text(self, event):
        event.widget.delete(0, "end")

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
        topic_label = TopicLabel(topic_frame, text="Tenants Details", size=50).get_label()
        topic_label.pack()

        # create game-start buttons custom_widgets and attach them to screen
        button_tenants_details = PrimaryButton(options_frame, "Present Details", 'white', 20,
                                        self.start_tenants_details_window).get_button()
        button_tenants_details.grid(row=1, pady=10)
        button_tennats_modification = PrimaryButton(options_frame, "Modify", "white", 20,
                                            self.start_tenants_modification_window).get_button()
        button_tennats_modification.grid(row=2, pady=10)


        # create label widget to show error
        self.label_error = Label(options_frame, text="", fg="red", bg='lavender', font=('Ariel', 18))
        self.label_error.grid(row=3, pady=10)