class Vehicle(object):
    """ 
    This is an example of Google style.

    Args:
        age: age of the vehicle in a queue
        vtype: either connected (1) or not connected (0)

    Returns:
        This is a description of what is returned.

    Raises:
        KeyError: Raises an exception.
    """

    vehCount = 0

    def __init__(self, arrT, src, dst, location, age, vtype)
        self.arrTimestamp = arrT
        self.source = src
        self.destination = dst
        self.currentLocation = location
        self.age = age
        self.vtype = vtype
        ConnectedVehicle.vehCount += 1
        
    def displayCount(self)
        print "Total Connected Vehicles = %d" % ConnectedVehicle.vehCount

