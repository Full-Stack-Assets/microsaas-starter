# microsaas-starter

A monorepo template for scaffolding three full-stack micro-SaaS apps —
TradeQuote (quotes), InkManager (inventory), and InvoiceFlow (billing) —
built on Next.js, React, Supabase, and Stripe.

`generate-monorepo.sh` scaffolds the monorepo containing those apps along
with deployment scripts.

## Prerequisites

- `bash` — to run `generate-monorepo.sh`
- `bats`, `zip`, `unzip` — to run the test suite (development only)

## Running the generator

```bash
./generate-monorepo.sh
```

This creates a `microsaas-starter/` directory and a `microsaas-starter.zip`
archive of it.

### Generated structure

```
microsaas-starter/
├── apps/             # Application code (tradequote, inkmanager, invoiceflow)
├── packages/         # Shared packages (database schemas per app)
├── scripts/          # Deployment scripts
└── .github/          # CI/CD workflows
```

### Next steps

```bash
cd microsaas-starter
# Install dependencies and configure environment for the app(s) you want,
# e.g. for TradeQuote:
cd apps/tradequote && npm install
```

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
