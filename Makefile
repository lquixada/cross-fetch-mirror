include makefiles/*.mk

.PHONY: all
all: test lint typecheck

.PHONY: clean
clean:
	@rm -Rf node_modules dist

.PHONY: commit
commit:
	npx cz

.PHONY: publish
publish:
	@./bin/publish

.PHONY: version
version:
	npx standard-version

.PHONY: version-alpha
version-alpha:
	npx standard-version --prerelease alpha

.PHONY: server
server:
	@./bin/server --silent --exec "echo Fetch api test suites: http://127.0.0.1:8000/test/fetch-api/"

##
# Builds

node_modules: package.json
	npm install && /usr/bin/touch node_modules

dist: package.json rollup.config.js $(wildcard src/*.js) node_modules
	@echo ""
	@echo "=> make $@"
	@npx rollup -c --bundleConfigAsCjs && /usr/bin/touch dist

test/fetch-api/api.spec.js: test/fetch-api/api.spec.ts
	@echo ""
	@echo "=> make $@"
	@npx tsc
