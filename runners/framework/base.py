# We assume that, as with Django, the actual method creation happens
# at intantiation time via the metaclass so it isn't relevant for
# pure load performance.
class DSL(object):
    def __init__(self, default):
        self.default = default
