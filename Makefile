.PHONY: all setup sources load build docs dashboard serve clean

all: sources load build dashboard   ## run the whole pipeline end to end

setup:        ## install dependencies
	pip install -r requirements.txt

sources:      ## generate the synthetic vendor exports
	python ingest/generate_sources.py

load:         ## land raw exports in the warehouse
	python ingest/load_raw.py

build:        ## seed, run and test every dbt model
	dbt build

docs:         ## generate the dbt docs site with lineage graph
	dbt docs generate --static && echo "Open target/static_index.html"

dashboard:    ## export the reporting marts for the dashboard
	python dashboard/export_data.py

serve:        ## open the dashboard at http://localhost:8000
	cd dashboard && python -m http.server 8000

clean:
	rm -rf target warehouse/*.duckdb data/raw dashboard/data.json
