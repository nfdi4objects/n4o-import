import unittest
from zipfile import ZipFile
from lib import walk

# SUITE_DIR = Path(__file__).parent.resolve() / "pg-test-suite"


class TestWalk(unittest.TestCase):

    def test_walk_file(self):
        files = list(walk("test/rdf.ttl"))
        self.assertEqual(files, [('rdf.ttl', ['test'])])

    def test_walk_zip(self):
        files = list(walk("test/dir/subdir/archive.zip"))

        name, path, archive = files[0]
        self.assertEqual(
            (name, path), ('file2', ['test/dir/subdir/archive.zip']))
        self.assertIsInstance(archive, ZipFile)

    def test_walk_dir(self):
        files = list(walk("test/dir"))
        self.assertEqual(
            files[0:2], [('file', ['test/dir']), ('archive.zip', ['test/dir/subdir'])])

        # recurse into ZIP archive
        name, path, archive = files[2]
        self.assertEqual(
            (name, path), ('file2', ['test/dir/subdir/archive.zip']))
        self.assertIsInstance(archive, ZipFile)
