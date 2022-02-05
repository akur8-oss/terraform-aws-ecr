# Contributing

To contribute to this project you must respect certains rules.

## tree structure

A terraform module must respect the [Standard Module Structure](https://www.terraform.io/language/modules/develop/structure).

```text
terraform-module/
├── .github/
│   └── workflows/          # Contains github workflows (pre-commit, release)
├── .pre-commit-config.yaml # Configuration for pre-commit
├── .terraform-docs.yaml    # Configuration for terraform-docs
├── .tflint.hcl             # Configuration for tflint
├── main.tf                 # Ressource created
├── variables.tf            # Variables
├── outputs.tf              # Outputs
└── providers.tf            # Provider if some are necessary

```

## Install pre-commit (Optional but recommanded)

### Machine

Install:

```bash
brew install pre-commit
```

Add to repo on pre-commit. To do **once**:

```bash
pre-commit install
```

If you prefer running pre-commit checks before push:

```bash
pre-commit install -t pre-push
```

It will automatically run after each commits / push depending of your configuration or by running manually:

```bash
pre-commit run -a
```

### Docker

:warning: To use this build locally the image `pre-commit`, in a future version we will host our own version :warning:

```bash
git clone git@github.com:antonbabenko/pre-commit-terraform.git
cd pre-commit-terraform
# Install the latest versions of all the tools
docker build -t pre-commit --build-arg INSTALL_ALL=true .
```

Copy this script in: `.git/hooks/pre-commit` or `.git/hooks/pre-push`:

```bash
cd $(git rev-parse --show-toplevel)

NAME=$(basename `git rev-parse --show-toplevel`)_precommit
docker run --rm -t -v $(pwd):/lint -w /lint --name $NAME pre-commit
```

Run manually:

```bash
docker run -v $(pwd):/lint -w /lint pre-commit run -a
```

## Commits

We do not impose a convention on commit. Use your own workflow, just try to have clear commits.

## PR

When you create a PR the name of the PR must follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) conventions.

**Examples:**

- For a fix:
  `fix(scope): Prevent infinite loop from happening`
- For a feature:
  `feat(scope): Add possibility to pass own KMS key`
- For a Breaking change:
  `feat(scope): Add new mandatory variable 'name'`
  and in the Body:

```text
BREAKING CHANGE: Add mandatory variable 'name'
```

To find more informations read [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Important other keyword are explained (like chore:).

## Github Action

Pre-commit will be launch in a Github workflow to do differents checks (lint, docs, security...):
`.github/workflows/pre-commit.yaml`

You can deploy a new version by executing the Workflow release with `dry-run: false`:
`.github/workflows/release.yaml`
