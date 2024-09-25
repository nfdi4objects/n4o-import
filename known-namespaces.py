#!/usr/bin/env python3
import sys


def read_namespaces():
    ns = {}
    with open('terminologies/namespaces.csv', 'r') as file:
        for line in file.readlines()[1:]:
            name, uri, prefix = line.strip().split(',')
            ns[uri] = name
    return ns

# filter list of URI namespaces with count to those listed in namespaces.csv


def main():
    ns = read_namespaces()

    for line in map(str.strip, sys.stdin):
        count, uri = line.strip().split(' ')
        if uri in ns:
            print(f"{count:>8} {ns[uri]}")


if __name__ == "__main__":
    main()
