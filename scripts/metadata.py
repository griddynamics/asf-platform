#!/usr/bin/python

import os
import sys
import cmd
import json
import time
import urllib2


class InteractiveOrCommandLine(cmd.Cmd):
    def do_init(self, _args):
        with open('/tmp/metadata.json', 'w') as metadata:
            json.dump({}, metadata)

    def get_metadata(self):
        with open("/tmp/metadata.json") as json_file:
            return json.load(json_file)

    def update_metadata(self, data):
        with open('/tmp/metadata.json', 'w') as metadata:
            json.dump(data, metadata)

    def do_allocate(self, _args):
        metadata = self.get_metadata()
        vms = [ip for ip in metadata.keys() if metadata[ip]['free'] == 'true']
        if len(vms) != 0:
            ip = vms[0]
            metadata[ip]['free'] = 'false'
            metadata[ip]['last_used'] = time.strftime('%d%m%Y%H%M')
            self.update_metadata(metadata)
            print ip
        else:
            print 'No availbale vms'

    def do_release(self, ip):
        metadata = self.get_metadata()
        metadata[ip]['free'] = 'true'
        metadata[ip]['last_used'] = time.strftime('%d%m%Y%H%M')
        self.update_metadata(metadata)

    def do_remove(self, ip):
        metadata = self.get_metadata()
        metadata.pop(ip, None)
        self.update_metadata(metadata)

    def do_register(self, args):
        ip, role = args.split(' ')
        metadata = self.get_metadata()
        if ip in metadata.keys():
            raise AttributeError('IP already exists')
        metadata[ip] = {
            'role': role,
            'free': 'true',
            'last_used': time.strftime('%d%m%Y%H%M'),
        }
        self.update_metadata(metadata)

    def do_uid(self, _args):
        print time.strftime('%d%m%Y%H%M%S%s')

    def do_get_role(self, ip):
        metadata = self.get_metadata()
        if not ip or ip not in metadata.keys():
            print "None"
        else:
            print metadata[ip]['role']

    def get_last_use(self, ip):
        try:
            return int(urllib2.urlopen('http://%s:30000/lastuse' % ip).read())
        except IOError:
            return int(ip['last_used'])

    def do_utilize(self, time):
        for ip in self.get_metadata().keys():
            print int(time.strftime('%d%m%Y%H%M')) - self.get_last_use(ip)
            if int(time.strftime('%d%m%Y%H%M')) - self.get_last_use(ip) > time:
                print ip
                break

    def do_vm_list(self, _args):
        ips = self.get_metadata().keys()
        if not ips:
            print "No VMs provision yet"
        else:
            print "\n".join(ips)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        InteractiveOrCommandLine().onecmd(' '.join(sys.argv[1:]))
    else:
        print "Need some args"
