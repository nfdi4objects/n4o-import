#!/usr/bin/env python3
import sys

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

    with open('n4o-collections.csv', 'r') as file:
        for line in file.readlines()[1:]:
            id, name, url, db = line.strip().split(',')
            names = ",".join([f'"{n}"' for n in name.split('|')])
            print(f'n4oc:{id} :Collection name:{names} url:"{url}"')
            if db:
                print(f'n4oc:{id} -> {db} :partOf')

if __name__ == "__main__":
    main()
