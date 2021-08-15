import cx_Oracle


class ObjectsHandler(object):

    @staticmethod
    def ObjectRepr(obj):
        if obj.type.iscollection:
            returnValue = []
            for value in obj.aslist():
                if isinstance(value, cx_Oracle.Object):
                    value = ObjectsHandler.ObjectRepr(value)
                returnValue.append(value)
        else:
            returnValue = {}
            for attr in obj.type.attributes:
                value = getattr(obj, attr.name)
                if value is None:
                    continue
                elif isinstance(value, cx_Oracle.Object):
                    value = ObjectsHandler.ObjectRepr(value)
                returnValue[attr.name] = value
        return returnValue
