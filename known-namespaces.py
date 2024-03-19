#!/usr/bin/env python3
import sys

# filter list of URI namespaces with count to those listed in namespaces.csv
def main():
    ns = {}
    with open('namespaces.csv', 'r') as file:
        for line in file.readlines()[1:]:
            name, uri, prefix = line.strip().split(',')
            ns[uri] = name

    for line in map(str.strip, sys.stdin):
        count, uri = line.strip().split(' ')
        if uri in ns:
            print(f"{count:>8} {ns[uri]}")

if __name__ == "__main__":
    main()
