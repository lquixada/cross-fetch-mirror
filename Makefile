.PHONY: all
all: test lint typecheck

.PHONY: browser
browser:
	./bin/server --exec "npx open-cli http://localhost:8000/test/fetch-api/browser/"

.PHONY: commit
commit: node_modules
	npx cz

.PHONY: release
release: node_modules
	npx standard-version

.PHONY: release-alpha
release-alpha: node_modules
	npx standard-version --prerelease alpha

##
# Builds

node_modules: package.json
	@echo ""
	@echo "=> installing dependencies..."
	@npm install && /usr/bin/touch node_modules

dist: package.json rollup.config.js $(wildcard src/*.js) node_modules
	@echo ""
	@echo "=> make $@"
	@npx rollup -c

test/fetch-api/api.spec.js: node_modules test/fetch-api/api.spec.ts
	@echo ""
	@echo "=> make $@"
	@npx tsc

##
# Checks

.PHONY: commitlint
commitlint: node_modules
	@echo ""
	@echo "=> linting commits..."
	@npx commitlint --from origin/main --to HEAD --verbose

.PHONY: cov
cov: node_modules
	@echo ""
	@echo "=> checking code coverage..."
	@npx nyc report --reporter=text-lcov > .reports/coverage.lcov && npx codecov

.PHONY: lint
lint: node_modules
	@echo ""
	@echo "=> make $@"
	@npx standard

.PHONY: secure
secure: node_modules
	@echo ""
	@echo "=> make $@"
	@npx snyk test

.PHONY: typecheck
typecheck: node_modules
	@echo ""
	@echo "=> make $@"
	@npx tsc --lib ES6 --noEmit index.d.ts ./test/fetch-api/api.spec.ts

##
# Test groups

.PHONY: test
test: test-fetch test-module

.PHONY: test-fetch
test-fetch: test-fetch-browser test-fetch-whatwg test-fetch-node

.PHONY: test-module
test-module: test-module-web-cjs test-module-web-esm test-module-node-cjs test-module-node-esm test-module-react-native

##
# Test units

.PHONY: test-fetch-browser
test-fetch-browser: | dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/browser/run.sh

.PHONY: test-fetch-whatwg
test-fetch-whatwg: | dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/whatwg/run.sh

.PHONY: test-fetch-node
test-fetch-node: | dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/node/run.sh

.PHONY: test-module-web-cjs
test-module-web-cjs: | dist
	@echo ""
	@echo "=> make $@"
	@./test/module-system/web.cjs/run.sh

.PHONY: test-module-web-esm
test-module-web-esm: | dist
	@echo ""
	@echo "=> make $@"
	@./test/module-system/web.esm/run.sh

.PHONY: test-module-node-cjs
test-module-node-cjs: | dist
	@echo ""
	@echo "=> make $@"
	@./test/module-system/node.cjs/run.sh

.PHONY: test-module-node-esm
test-module-node-esm: | dist
	@echo ""
	@echo "=> make $@"
	@./test/module-system/node.esm/run.sh

.PHONY: test-module-react-native
test-module-react-native: | dist
	@echo ""
	@echo "=> make $@"
	@./test/module-system/react-native/run.sh
