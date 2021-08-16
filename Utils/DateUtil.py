import calendar


class DateUtil(object):

    @staticmethod
    def date_converter(date):
        if date[3] == '0':
            month = calendar.month_name[int(date[4])].upper()
        else:
            month = calendar.month_name[int(date[3:4])].upper()
        day = date[:2]
        year = date[6:]
        new_date = (day, month, year)
        new_date = '-'.join(new_date)
        return new_date
