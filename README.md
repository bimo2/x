![x](.github/header.svg)

x is a macOS command line tool, like Shopify's internal `dev` command, for running local developer tasks. Create an `x.json5` file in your project to:

- `install` libraries and frameworks
- `start` servers and run `tests`
- `build` and `deploy` apps, or
- `zxcvbnm` ...

## Usage

> [!NOTE]
> OS support: macOS 14+

### Install

You can download all precompiled binaries from the [GitHub Releases](https://github.com/bimo2/x/releases) section or run the install script out of the box:

```sh
curl -sf https://raw.githubusercontent.com/bimo2/x/main/install | sh
```

### TLDR

```sh
x
```

## DEBUG

Build `x` using x:

```sh
# build the debug scheme
x build

# test the debug binary
./xcode/Build/Products/Debug/x

# test the install script
curl -sf file://$(pwd)/install | sh
```

> [!IMPORTANT]
> Release binaries are built with CI (Buildkite) and should downloaded and renamed to `x-macos-$(VERSION)` (ex. `x-macos-0.1`).

#

<sub><sup>**MIT.** Copyright &copy; 2024 Bimal Bhagrath</sup></sub>
