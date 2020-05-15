#!/usr/bin/env python
# -*- coding: utf-8 -*-

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#See the GNU General Public License for more details.

print('####///////////////////////////////////####\nDeveloped by Hankun Li\nUniversity of Kansas')
print('DSLR fastHDR control on Raspberry pi 3\nVersion: 1.1\nLatest update: SEP 24, 2019\n')
print('DSLR control developed on gphoto2 module\n\n\n\n')
from time import sleep, time
from sh import gphoto2 as gp
import signal, os, subprocess
import sys

class FastHDR(object):

    #Enviroment code: 0(default:ISO 100) 1: stage_1, 2: stage_2
    #Machine Value, do not change!
    #APERTURE: set to F4.5
    #WhiteBalance: set to Auto
    ENV = {0:[(1, '30'),(1, '15'),(1, '8'),(1, '4'),(1, '2'),(1, '1'),(1, '0.5'),
              (1, '1/4'),(1, '1/8'),(1, '1/15'),(1, '1/30'),(1, '1/60'),(1, '1/125'),(1, '1/250'),(1, '1/500'),
              (1, '1/1000'),(1, '1/2000'),(1, '1/4000')],
           1:[(7, '0.5'),(6, '0.5'),(5, '0.5'),(4, '0.5'),(3, '0.5'),(2, '0.5'),(1, '0.5'),
              (1, '1/4'),(1, '1/8'),(1, '1/15'),(1, '1/30'),(1, '1/60'),(1, '1/125'),(1, '1/250'),(1, '1/500'),
              (1, '1/1000'),(1, '1/2000'),(1, '1/4000')],
           2:[(7, '0.5'),(7, '1/4'),(7, '1/8'),(7, '1/15'),(7, '1/30'),(7, '1/60'),(7, '1/125'),
              (7, '1/250'),(1, '1/8'),(1, '1/15'),(1, '1/30'),(1, '1/60'),(1, '1/125'),(1, '1/250'),(1, '1/500'),
              (1, '1/1000'),(1, '1/2000'),(1, '1/4000')]}
    trigger_command = 'gphoto2 --trigger-capture'
    download_command = 'gphoto2 --get-all-files'
    #Machine Value End here!
    
    def __init__(self, enviromentcode:int, working_dir:str):
        self.code = enviromentcode
        self.path = working_dir
        #self.N = total_shoot
        
    def goto_sdcard(self):
        try:
            os.system('gphoto2 --set-config capturetarget=1')
            sleep(0.5)
        except Exception as err:
            print(err, 'SD error!')
    
    def killgphoto2process(self):
        p = subprocess.Popen(['ps', '-A'], stdout = subprocess.PIPE)
        out, err = p.communicate()
        pid = int(0)
        for line in out.splitlines():
            if b'gvfsd-gphoto2' in line:
                pid = int(line.split(None,1)[0])
                os.kill(pid, signal.SIGKILL)
        if pid != 0:
            print('gphoto2 reseted!')
        else:
            print('not found gphoto2')

    def create_savepath(self):
        try:
            os.makedirs(self.path)
        except:
            print('Directory already exist!')
            
    def run_capture(self):
        self.killgphoto2process()
        self.goto_sdcard()
        self.create_savepath()
        os.chdir(self.path)
        config = self.ENV[self.code]
        iso = int(111)
        ev = str('na')
        for i in range (0, len(config)):
            if config[i][0] != iso:
                iso = int(config[i][0])
                os.system('gphoto2 --set-config iso=%d'%iso)
                sleep(0.3)
            if config[i][1] != ev:
                ev = config[i][1]
                os.system('gphoto2 --set-config shutterspeed=%s'%ev)
                sleep(0.3)
            #debug here
            print(iso, ev)
            try:
                ts = float(config[i][1]) + 0.4
            except:
                if config[i][1] in ('1/4','1/8','1/15'):
                    ts = 0.6
                else:
                    ts = 0.5
            os.system(self.trigger_command)
            print (ts)
            sleep(ts)

f_path = '/home/pi/test_1214_2'
hdr = FastHDR(2, f_path)
t1 = time()
hdr.run_capture()
t2 = time()
os.system(hdr.download_command)
t3 = t2 - t1
print ('downloaded!')
sleep(5)
os.system("gphoto2 --folder='/store_00020001/DCIM/100CANON' -R --delete-all-files")
print('deleted!')
print('finished!', t3)
            
