.PHONY: all
all: test lint typecheck

node_modules: package.json
	npm install && /usr/bin/touch node_modules

.PHONY: build
build: node_modules
	npx rollup -c

.PHONY: browser
browser:
	./bin/server --exec "npx open-cli http://localhost:8000/test/fetch-api/browser/"

.PHONY: commit
commit: node_modules
	npx cz

.PHONY: commitlint
commitlint: node_modules
	npx commitlint --from origin/main --to HEAD --verbose

.PHONY: compile
compile: node_modules test/fetch-api/api.spec.ts
	npx tsc

.PHONY: cov
cov: node_modules
	npx nyc report --reporter=text-lcov > .reports/coverage.lcov && npx codecov

.PHONY: lint
lint: node_modules
	npx standard

.PHONY: release
release: node_modules
	npx standard-version

.PHONY: release-alpha
release-alpha: node_modules
	npx standard-version --prerelease alpha

.PHONY: secure
secure: node_modules
	npx snyk test

.PHONY: test
test: compile test-fetch test-module

.PHONY: test-fetch
test-fetch: test-fetch-browser test-fetch-whatwg test-fetch-node

.PHONY: test-fetch-browser
test-fetch-browser: build
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/browser/run.sh

.PHONY: test-fetch-whatwg
test-fetch-whatwg: build
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/whatwg/run.sh

.PHONY: test-fetch-node
test-fetch-node: build
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/node/run.sh

.PHONY: test-module
test-module: test-module-web-cjs test-module-web-esm test-module-node-cjs test-module-node-esm test-module-react-native

.PHONY: test-module-web-cjs
test-module-web-cjs: build
	@echo ""
	@echo "=> make $@"
	@./test/module-system/web.cjs/run.sh

.PHONY: test-module-web-esm
test-module-web-esm: build
	@echo ""
	@echo "=> make $@"
	@./test/module-system/web.esm/run.sh

.PHONY: test-module-node-cjs
test-module-node-cjs: build
	@echo ""
	@echo "=> make $@"
	@./test/module-system/node.cjs/run.sh

.PHONY: test-module-node-esm
test-module-node-esm: build
	@echo ""
	@echo "=> make $@"
	@./test/module-system/node.esm/run.sh

.PHONY: test-module-react-native
test-module-react-native: build
	@echo ""
	@echo "=> make $@"
	@./test/module-system/react-native/run.sh

.PHONY: typecheck
typecheck:
	npx tsc --lib ES6 --noEmit index.d.ts ./test/fetch-api/api.spec.ts
