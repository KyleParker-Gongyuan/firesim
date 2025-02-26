
import matplotlib
# don't use xwindow
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import re
import sys
import os

basedir = sys.argv[1] + "/"

files = list(map(lambda x: basedir + x, os.listdir(basedir)))

def process_uartlog(uartlogpath):
    """ process the log and then report the mean RTT for this link latency """
    def mean(numbers):
	return float(sum(numbers)) / max(len(numbers), 1)

    with open(uartlogpath, 'r') as f:
            readlines = f.readlines()
    rtts = []
    for line in readlines:
        if "64 bytes from 100.0.0.3:" in line:
            thisrtt = line.split()[-2].split("=")[-1]
            rtts.append(float(thisrtt))
    return mean(rtts)

def extract_stats_from_uartlog(uartlogpath):
    """ read a uartlog and get sim perf results """
    elapsed_time = -1
    sim_speed = -1
    cycles = -1
    with open(uartlogpath, 'r') as f:
        readlines = f.readlines()
    for line in readlines:
        if "time elapsed:" in line and "simulation speed" in line:
            elapsed_time = float(line.split()[2])
            sim_speed = float(line.split()[7])
            if line.split()[8] != "MHz":
                if line.split()[8] == "KHz":
                    sim_speed /= 1000.0
                else:
                    # i forget if this will print 0.xxx MHz or switch to KHz or something else
                    # so just to be safe...
                    print("ERR: unknown sim rate units")
                    exit(1)
        if "*** PASSED ***" in line:
            cycles = float(line.split()[4])
    return [elapsed_time, sim_speed, cycles]

def get_simperf_from_file(basedirname):
    uartlogpath = basedirname + "/simperf-test-latency0/uartlog"
    latency = float(basedirname.split("/")[-1])


    latency_in_ms = (latency / 3.2) / 1000000.0

    simperf_mhz = extract_stats_from_uartlog(uartlogpath)
    link_latency_us = latency_in_ms * 1000.0

    return [link_latency_us, simperf_mhz]

resultarray = list(map(get_simperf_from_file, files))

link_latency = list(map(lambda x: x[0], resultarray))
simperf_mhz = list(map(lambda x: x[1][1], resultarray))

resultarray = zip(link_latency, simperf_mhz)

print(resultarray)

import json
f = open(basedir + 'perfresults.txt', 'w')
json.dump(resultarray, f)
f.close()

#series = []
#fig, ax = plt.subplots()
#ser, = plt.plot(link_latency, measured_rtt, linestyle='--', marker='^', c='0.5')
#series.append(ser)
#
#ser, = plt.plot(link_latency, ideal_rtt, linestyle='-', marker='o', c='0.1')
#series.append(ser)
#
#
##matplotlib.rcParams.update({'font.size': 16})
#matplotlib.rcParams.update(matplotlib.rcParamsDefault)
#ax.legend(series, ['Measured Ping RTT', 'Ideal RTT'],prop={'size': 12})
#ax.set_xlabel(r'Link Latency ($\mu$s)', size='16')
#ax.set_ylabel(r'Round Trip Time ($\mu$s)', size='16')
#ax.grid(linestyle='-', linewidth=0.3)
#fig = plt.gcf()
#plt.show()
#fig.savefig(basedir + 'ping-rtt.pdf', format='pdf')
