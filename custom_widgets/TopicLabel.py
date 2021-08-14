from tkinter import *


class TopicLabel(object):
    """
    A helper class used to create custom label widgets with pre-made characteristics.
    """

    def __init__(self, root, text, size):
        self.topic_label = Label(root, text=text, fg='blue', bg='lavender',
                                 font=('Comic Sans MS', size, 'bold'))

    def get_label(self):
        return self.topic_label
