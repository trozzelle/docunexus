from datetime import *

def print_with_time(msg):
    print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + ': ' + str(msg))

