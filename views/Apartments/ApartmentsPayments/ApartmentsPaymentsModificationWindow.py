from tkinter import *
import tkinter as tk

from views.Apartments.ApartmentsPayments.ApartmentPaymentsUpdateWindow import ApartmentPaymentsUpdateWindow
from views.Apartments.ApartmentsPayments.ApartmentsPaymentsGeneralWindow import ApartmentsPaymentsGeneralWindow
from views.Apartments.ApartmentsPayments.ApartmentsPaymentsMonthlyWindow import ApartmentsPaymentsMonthlyWindow
from views.BaseView import BaseView
from constants import Constants
from Utils.WindowUtil import WindowUtil
from custom_widgets.PrimaryButton import PrimaryButton
from custom_widgets.TopicLabel import TopicLabel
from views.Tenants.TenantsElections.TenantsElectionsAddWindow import TenantsElectionsAddWindow

from views.Tenants.TenantsElections.TenantsElectionsRemoveWindow import TenantsElectionsRemoveWindow
from views.Tenants.TenantsElections.TenantsElectionsUpdateWindow import TenantsElectionsUpdateWindow


class ApartmentsPaymentsModificationWindow(BaseView):

    def __init__(self, master):
        self.master = master

        self.init_widgets()


    def start_add_monthly_payment_window(self):
        # start root for add monthly payment window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Add Monthly Payment',
                                 Constants.ICON_PATH, True, 'lavender')
        monthly_payment_add_window = ApartmentsPaymentsMonthlyWindow(root)
        root.mainloop()

    def start_add_general_payment_window(self):
        # start root for add general payment window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Add General Payment',
                                 Constants.ICON_PATH, True, 'lavender')
        general_payment_add_window = ApartmentsPaymentsGeneralWindow(root)
        root.mainloop()

    def start_update_payment_window(self):
        # start root for update payment window
        root = tk.Toplevel()
        WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Update Payment',
                                 Constants.ICON_PATH, True, 'lavender')
        payment_update_window = ApartmentPaymentsUpdateWindow(root)
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
        topic_label = TopicLabel(topic_frame, text="Apartments Payments Modification", size=40).get_label()
        topic_label.pack()

        # create buttons custom_widgets and attach them to screen
        button_monthly_add = PrimaryButton(options_frame, "Add Monthly", 'white', 20,
                                                 self.start_add_monthly_payment_window).get_button()
        button_monthly_add.grid(row=0, pady=10)

        button_general_add = PrimaryButton(options_frame, "Add General", "white", 20,
                                                      self.start_add_general_payment_window).get_button()
        button_general_add.grid(row=1, pady=10)

        button_payment_update = PrimaryButton(options_frame, "Update", "white", 20,
                                                self.start_update_payment_window).get_button()
        button_payment_update.grid(row=2, pady=10)

        # create label widget to show error
        self.label_error = Label(options_frame, text="", fg="red", bg='lavender', font=('Ariel', 18))
        self.label_error.grid(row=3, pady=10)
