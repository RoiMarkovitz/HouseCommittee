from tkinter import *
import tkinter as tk

from views.Apartments.ApartmentsDetails.ApartmentsDetailsWindow import ApartmentsDetailsWindow
from views.Apartments.ApartmentsHistory.ApartmentsHistoryWindow import ApartmentsHistoryWindow
from views.Apartments.ApartmentsPayments.ApartmentsPaymentsMainWindow import ApartmentsPaymentsMainWindow
from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel


class ApartmentsMainWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()

    def start_apartments_details_window(self):
        # start root for apartments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Apartments Details',
                                 Constants.ICON_PATH, True, 'lavender')
        #    root.protocol("WM_DELETE_WINDOW", lambda: self.on_closing(root, 1))
        apartments_details_window = ApartmentsDetailsWindow(root)
        root.mainloop()

    def start_apartments_history_window(self):
        # start root for apartments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Apartments History',
                                 Constants.ICON_PATH, True, 'lavender')
        #    root.protocol("WM_DELETE_WINDOW", lambda: self.on_closing(root, 1))
        apartments_history_window = ApartmentsHistoryWindow(root)
        root.mainloop()

    def start_apartments_payments_main_window(self):
        # start root for apartments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Apartments Payments',
                                 Constants.ICON_PATH, True, 'lavender')
        #    root.protocol("WM_DELETE_WINDOW", lambda: self.on_closing(root, 1))
        apartments_payments_main_window = ApartmentsPaymentsMainWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Apartments", size=50).get_label()
        topic_label.pack()

        # create game-start buttons custom_widgets and attach them to screen
        button_apartments_details = PrimaryButton(options_frame, "Apartments Details", 'white', 20,
                                        self.start_apartments_details_window).get_button()
        button_apartments_details.grid(row=1, pady=10)
        button_apartments_history = PrimaryButton(options_frame, "Apartments History", "white", 20,
                                            self.start_apartments_history_window).get_button()
        button_apartments_history.grid(row=2, pady=10)
        button_apartments_payments = PrimaryButton(options_frame, "Apartments Payments", "white", 20,
                                      self.start_apartments_payments_main_window).get_button()
        button_apartments_payments.grid(row=3, pady=10)

        # create label widget to show error
        self.label_error = Label(options_frame, text="", fg="red", bg='lavender', font=('Ariel', 18))
        self.label_error.grid(row=4, pady=10)
