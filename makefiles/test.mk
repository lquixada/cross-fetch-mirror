
##
# Test groups

.PHONY: test
test: | test-browser test-node

.PHONY: test-browser
test-browser: |\
	test-fetch-browser-native \
	test-fetch-browser-whatwg \
  test-fetch-browser-service-worker \
	test-module-web-cjs \
	test-module-web-esm \
	test-module-react-native

.PHONY: test-node
test-node: |\
	test-fetch-node-native \
	test-fetch-node-fetch \
	test-module-node-cjs \
	test-module-node-esm


##
# Test units

.PHONY: test-fetch-browser-native
test-fetch-browser-native: | dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/browser/run.sh

.PHONY: test-fetch-browser-whatwg
test-fetch-browser-whatwg: | dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/whatwg/run.sh

.PHONY: test-fetch-browser-service-worker
test-fetch-browser-service-worker: dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/service-worker/run.sh

.PHONY: test-fetch-node-native
test-fetch-node-native: | dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/node/run.sh

.PHONY: test-fetch-node-fetch
test-fetch-node-fetch: | dist test/fetch-api/api.spec.js
	@echo ""
	@echo "=> make $@"
	@./test/fetch-api/node-fetch/run.sh

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
