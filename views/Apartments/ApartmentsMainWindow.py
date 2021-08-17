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
        # start root for apartments details window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Apartments Details',
                                 Constants.ICON_PATH, True, 'lavender')
        apartments_details_window = ApartmentsDetailsWindow(root)
        root.mainloop()

    def start_apartments_history_window(self):
        # start root for apartments history window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Apartments History',
                                 Constants.ICON_PATH, True, 'lavender')
        apartments_history_window = ApartmentsHistoryWindow(root)
        root.mainloop()

    def start_apartments_payments_main_window(self):
        # start root for apartments payments window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Apartments Payments',
                                 Constants.ICON_PATH, True, 'lavender')
        apartments_payments_main_window = ApartmentsPaymentsMainWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Apartments", size=50).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_apartments_details = PrimaryButton(buttons_frame, "Details", 'white', 20,
                                                  self.start_apartments_details_window).get_button()
        button_apartments_details.grid(row=1, pady=10)
        button_apartments_history = PrimaryButton(buttons_frame, "History", "white", 20,
                                                  self.start_apartments_history_window).get_button()
        button_apartments_history.grid(row=2, pady=10)
        button_apartments_payments = PrimaryButton(buttons_frame, "Payments", "white", 20,
                                                   self.start_apartments_payments_main_window).get_button()
        button_apartments_payments.grid(row=3, pady=10)

