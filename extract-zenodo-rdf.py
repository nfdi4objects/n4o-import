"""Extract all RDF turtle files from an archive downloaded from zenodo."""
import sys, os
from pathlib import Path
from zipfile import ZipFile, ZipExtFile
import lightrdf
import argparse

rdfparser = lightrdf.Parser()

def zipwalk(file, path=[]) -> list:
    path.append(file.name if isinstance(file, ZipExtFile) else file)
    archive = ZipFile(file)

    infos = set(archive.infolist())
    dirs = {i.filename for i in infos if i.is_dir()}
    zips = {i.filename for i in infos} - dirs
    zips = {i for i in zips if i.endswith(".zip") or i.endswith(".ZIP")}
    files = {i.filename for i in infos} - (zips | dirs)

    for f in files:
        yield f, archive, path

    for z in zips:
        with archive.open(z) as f:
            yield from zipwalk(f, path)


def extract(file, out):
    triples = 0
    walk = zipwalk(file)
    for name, archive, path in walk:
        format = None
        if name.endswith(".ttl"):
            format = "turtle"
        # TODO: more formats
        if format == None:
            continue

        print(name, path)
        file = archive.open(name)
        try:
            # TODO: base_iri seems to be ignored
            base=f"file://{file}"
            for triple in rdfparser.parse(file, base_iri=base, format=format):
                triples += 1
                print(" ".join(triple)+" .", file=out)
        except Exception as e:
            path.reverse()
            msg = f"{e} of {name} in " + " in ".join(path)
            raise Exception(msg)

    return triples

def main(args):
    if len(args) != 1:
        print("Please provide a directory with zip file `files-archive`")
        sys.exit(1)
    dir = args[0]
    if not os.path.isdir(dir):
        print(f"Directory does not exist: {dir}")
        sys.exit(1)

    triples = 0
    tmp = os.path.join(dir,"tmp.nt")
    with open(tmp,"w") as out:
        triples = extract(os.path.join(dir,"files-archive"), out)
    if triples:
        target = os.path.join(dir,"triples.nt")
        os.rename(tmp, target)
        print(f"extracted {triples} into {target}")
    else:
        print(f"No RDF found!")
        sys.exit(1)


if __name__ == '__main__':
    main(sys.argv[1:])
