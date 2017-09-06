from collections import deque

class VehicleQueue(object):
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

    queueCount = 0

    def __init__(self, qid=0, src_link=0, dst_link=0, objQueue=None)
        queueCount += 1
        self.qid = qid
        self.src_link = src_link
        self.dst_link = dst_link
        if objQueue is None:
            self.objQueue = deque()
        else:
            self.objQueue = objQueue

    def add_one_new_vehicle(self)
        self.objQueue.append(Vehicle())

    def pop_head_of_queue(self)
        self.objQueue.popleft()

    def get_head_of_queue_age(self)
        if len(self.objQueue) > 0:
            return self.objQueue[0].age
        else:
        	return - 1


