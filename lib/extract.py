from .walk import walk
import lightrdf

rdfparser = lightrdf.Parser()


def extractRDF(file):
    """Extract RDF triples from a file, directory and/or ZIP archive."""
    for name, path, archive in walk(file):
        format = None
        if name.endswith(".ttl") or name.endswith(".nt"):
            format = "turtle"

        # TODO: support more RDF serialization formats, in particular RDF/XML
        if format is None:
            continue

        base = f"file://{name}"
        file = archive.open(name)
        try:
            for triple in rdfparser.parse(file, base_iri=base, format=format):
                yield triple
        except Exception as e:
            path.reverse()
            raise Exception(f"{e} of {name} in " + " in ".join(path))
