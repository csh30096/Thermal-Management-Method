import numpy as np
import time
import sys

pct_dict = {40: 100, 39:92, 38:90, 37:88, 36:85, 35:82, 34:80, 33:77, 32:75, 31:72, 30:70, 29:67, 28:65}
predict_freq = int(sys.argv[1])

with open('/home/seunghun/Desktop/predict_freq', 'w') as output:
	output.write(str(pct_dict[predict_freq]))


