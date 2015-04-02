#!/usr/bin/python

import os
import time
import sys
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer


class lastUseHandler(BaseHTTPRequestHandler):
    qubell_dir = sys.argv[1]

    def do_GET(self):
        if self.path == '/lastuse':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(self.get_last_use())
        return

    def get_qubell_latest_change(self):
        return sorted(
            (os.path.join(dirname, filename) for
                dirname, dirnames, filenames in os.walk(self.qubell_dir)
                for filename in filenames),
            key=lambda fn: os.stat(fn).st_mtime,
            reverse=True)[0]

    def get_last_use(self):
        try:
            return time.strftime(
                '%d%m%Y%H%M',
                time.gmtime(os.path.getmtime(self.get_qubell_latest_change()))
            )
        except IOError:
            return "None"

if __name__ == '__main__':
    server = HTTPServer(('', 30000), lastUseHandler)
    print 'Started httpserver on port ', 30000
    server.serve_forever()
