#!/usr/bin/env python3
import sys
import json
import csv

def read_namespaces():
    ns = {}
    with open('namespaces.csv', 'r') as file:
        for line in file.readlines()[1:]:
            name, uri, prefix = line.strip().split(',')
            ns[uri] = name
    return ns

def main():
    # ns = read_namespaces()
    # for uri, name in ns.items(): 
    #    print(f'{uri} name:"{name}"')

    with open('n4o-collections.csv', newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        collections = [row for row in reader]

    for col in collections:
        col["name"] = col['name'].split('|')
        names = ",".join([f'"{n}"' for n in col['name']])
        print(f'n4oc:{col["id"]} :Collection name:{names} url:"{col["url"]}"')
        if col['db']:
            print(f'n4oc:{col["id"]} -> {col["db"]} :partOf')
        else:
            del(col['db'])

if __name__ == "__main__":
    main()
