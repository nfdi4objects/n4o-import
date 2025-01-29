#!./.venv/bin/python

"""Extract all RDF turtle files from an archive. Supports .nt and .ttl files."""
import sys
import os
from lib import extractRDF


def main(args):
    if len(args) != 1:
        print("Please provide a directory with zip file `files-archive.zip`")
        sys.exit(1)
    dir = args[0]
    if not os.path.isdir(dir):
        print(f"Directory does not exist: {dir}")
        sys.exit(1)

    triples = 0
    tmp = os.path.join(dir, "tmp.nt")
    with open(tmp, "w") as out:
        for triple in extractRDF(os.path.join(dir, "files-archive.zip")):
            print(" ".join(triple) + " .", file=out)
            triples += 1

    if triples:
        target = os.path.join(dir, "triples.nt")
        os.rename(tmp, target)
        print(f"extracted {triples} triples into {target}")
    else:
        print("No RDF found!")
        sys.exit(1)


if __name__ == '__main__':
    main(sys.argv[1:])
