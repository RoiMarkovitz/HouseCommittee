from tkinter import *

from connection import Connection
from constants import Constants
from views.MainWindow import MainWindow
from Utils.WindowUtil import WindowUtil

# Created by Roi Markovitz

"""
Program Entry Point
Opens Main Window of the program
"""

root = Tk()  # creating a blank window
WindowUtil.config_window(root, Constants.WINDOW_SIZE, False, 'Main Menu', Constants.ICON_PATH, True, 'lavender')
Connection.connect_to_database()
root.protocol("WM_DELETE_WINDOW", lambda: Connection.on_closing(root))
main_window = MainWindow(root)
root.mainloop()  # infinite loop to display custom_widgets



