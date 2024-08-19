update:
	if [ -d sources ]; then git -C sources pull ; else git clone https://github.com/nfdi4objects/n4o-databases.git sources; fi
