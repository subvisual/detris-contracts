
# Contracts template • [![tests](https://github.com/finiam/contracts-template/actions/workflows/tests.yml/badge.svg)](https://github.com/finiam/contracts-template/actions/workflows/tests.yml) [![lints](https://github.com/finiam/contracts-template/actions/workflows/lints.yml/badge.svg)](https://github.com/finiam/contracts-template/actions/workflows/lints.yml) ![GitHub](https://img.shields.io/github/license/finiam/contracts-template)  ![GitHub package.json version](https://img.shields.io/github/package-json/v/finiam/contracts-template)


Foundry contracts templates

## Getting Started

Click `use this template` on [Github](https://github.com/finiam/contracts-template) to create a new repository with this repo as the initial state.

Or, if your repo already exists, run:
```sh
forge init --template https://github.com/finiam/contracts-template
git submodule update --init --recursive
forge install
```
## Install

You have **2** options , `Nix` or system dependencies with `asdf`.

We recomend you have `direnv` installed for both of them

### Nix

We have a flake file.

Add `experimental-features = nix-command flakes` to your `~/.config/nix/nix.conf`

And uncomment the `use flake` line on your `.envrc`

All the dependencies should be installed for you by nix

### Sytem dependencies

If you need to install and read about forgery please [go to](https://onbjerg.github.io/foundry-book/)

You need `node 16` and `yarn`

You can use [asdf](https://github.com/asdf-vm/asdf) and run `asdf install`

**Deployment & Verification**

Inside the [`bin/`](./bin/) directory there are a few scripts that can be used to deploy and verify contracts.These are simple wrappers for `forge`.

**Interacting with contracts**

Inside the [`bin/`](./bin/) directory there are a few scripts that can be used to send transactions and read contract state. These are simple wrappers for `cast`.

### Writing Tests with Foundry

To learn about testing in Foundry see [solmate](https://github.com/Rari-Capital/solmate/tree/main/src/test)

### Configure Foundry

See the Foundry [configuration documentation](https://github.com/gakonst/foundry/blob/master/config/README.md#all-options).
