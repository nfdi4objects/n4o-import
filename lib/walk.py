import os
from zipfile import ZipFile, ZipExtFile


def isZip(file) -> bool:
    """Check whether given file looks like a ZIP archive."""
    return file.endswith(".zip") or file.endswith(".ZIP")


def zipwalk(file, path=None) -> list:
    """Recursively iterate ZIP archive contents."""
    name = file.name if isinstance(file, ZipExtFile) else file
    path = [name] if path is None else [*path, name]
    archive = ZipFile(file)
    infos = set(archive.infolist())
    dirs = {f.filename for f in infos if f.is_dir()}
    zips = {f.filename for f in infos} - dirs
    zips = {f for f in zips if isZip(f)}
    files = {f.filename for f in infos} - (zips | dirs)

    for name in files:
        yield name, path, archive

    for z in zips:
        with archive.open(z) as f:
            yield from zipwalk(f, path)


def walk(top) -> list:
    """Iterate over file or directory, including subdirectories and contents of ZIP archives."""
    if os.path.isdir(top):
        for path, dirs, files in os.walk(top):
            for name in files:
                yield name, [path]
                if isZip(name):
                    yield from zipwalk(os.path.join(path, name))
    elif os.path.isfile(top):
        if isZip(top):
            yield from zipwalk(top)
        else:
            path, name = os.path.split(top)
            path = [] if path == '' else [path]
            yield name, path
