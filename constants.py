import os


class Constants(object):

    WINDOW_WIDTH = 800
    WINDOW_HEIGHT = 600
    WINDOW_SIZE = str(WINDOW_WIDTH) + "x" + str(WINDOW_HEIGHT)

    ROOT_IMAGE_PATH, tail = os.path.split(os.path.abspath(__file__).replace("\\", "/"))

    ICON_PATH = ROOT_IMAGE_PATH + "/icons/ic_building2.png"
