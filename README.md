# microsaas-starter

`generate-monorepo.sh` scaffolds a monorepo containing the TradeQuote,
InkManager, and InvoiceFlow apps along with deployment scripts.

## Running the generator

```bash
./generate-monorepo.sh
```

This creates a `microsaas-starter/` directory and a `microsaas-starter.zip`
archive of it.

## Tests

The generator is covered by a [Bats](https://github.com/bats-core/bats-core)
suite and linted with [ShellCheck](https://www.shellcheck.net/). Both run in
CI (`.github/workflows/test.yml`).

```bash
# Lint
shellcheck generate-monorepo.sh

# Tests (requires bats, zip, unzip)
bats test/
```
