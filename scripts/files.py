import json
import sys
import os
import urllib

f = open(sys.argv[1], "r")
data = json.loads(f.read())
f.close()

if 'files' not in data:
    print "No files in validator encrypted config."
    exit()

files = data['files']

for file in files:
    filename = os.path.expanduser(file['name'])
    if not os.path.exists(os.path.dirname(filename)):
        os.makedirs(os.path.dirname(filename))
    if 'content' in file:
        f = open(filename, 'w')
        f.write(file['content'])
        f.close()
        print "Created file " + filename
    elif 'url' in file:
        print "Downloading file from " + file['url']
        urllib.urlretrieve(file['url'], filename)
        print "Created file " + filename
