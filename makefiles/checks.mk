
##
# Checks

.PHONY: commitlint
commitlint: node_modules
	npx commitlint --from origin/main --to HEAD --verbose

.PHONY: cov
cov:
	npx nyc report --reporter=text-lcov > .reports/coverage.lcov && npx codecov

.PHONY: lint
lint:
	@echo ""
	@echo "=> make $@"
	@npx standard

.PHONY: secure
secure:
	@echo ""
	@echo "=> make $@"
	@npx snyk test

.PHONY: typecheck
typecheck:
	@echo ""
	@echo "=> make $@"
	@npx tsc --lib ES6 --noEmit index.d.ts ./test/fetch-api/api.spec.ts

