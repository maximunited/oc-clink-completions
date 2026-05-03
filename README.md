# oc-clink-completions

[![Tests](https://github.com/maximunited/oc-clink-completions/actions/workflows/test.yml/badge.svg)](https://github.com/maximunited/oc-clink-completions/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue?logo=windows&logoColor=white)](https://chrisant996.github.io/clink/)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-maxim__united-orange?logo=buy-me-a-coffee&logoColor=white)](https://buymeacoffee.com/maxim_united)

[Clink](https://chrisant996.github.io/clink/) tab-completion script for the OpenShift CLI (`oc` / `oc.exe`).

## What it does

Three levels of tab-completion in any Clink-enhanced `cmd.exe` session:

| What you type | `<TAB>` completes |
|---|---|
| `oc <TAB>` | all subcommands |
| `oc get <TAB>` | resource types (`pods`, `svc`, `deploy`, `dc`, …) |
| `oc get pods <TAB>` | live pod names from the cluster |
| `oc logs <TAB>` | live pod names directly |
| `oc scale deployment <TAB>` | live deployment names |
| `oc rollout status <TAB>` | scalable resource types |
| `oc get pods -n <TAB>` | live project/namespace names |
| `oc get pods --namespace <TAB>` | live project/namespace names |

Resource names and namespace names are fetched live via `oc get <resource> -o name`. Completions return empty gracefully when the cluster is unreachable.

## Requirements

- [Clink](https://chrisant996.github.io/clink/) v1.x (tested on Windows 11)
- OpenShift CLI (`oc.exe`) on your `PATH`

## Installation

Clone the repo, then create a symbolic link so any `git pull` is immediately live in Clink with no extra steps.

Run the following in an **elevated cmd** (right-click → Run as administrator):

```cmd
git clone https://github.com/maximunited/oc-clink-completions
mklink "%LOCALAPPDATA%\clink\oc.lua" "%CD%\oc-clink-completions\oc.lua"
```

Restart your `cmd.exe` session (or run `clink reload`) to pick up the script.

## Covered subcommands

| Subcommand | Description |
|---|---|
| `adm` | Cluster administration commands |
| `annotate` | Update annotations on resources |
| `apply` | Apply configuration from a file |
| `autoscale` | Auto-scale a deployment |
| `cancel-build` | Cancel a build |
| `create` | Create a resource |
| `delete` | Delete resources |
| `describe` | Show details of a resource |
| `edit` | Edit a resource in an editor |
| `exec` | Execute a command in a container |
| `explain` | Show documentation for a resource |
| `expose` | Expose a service or route |
| `get` | List resources |
| `image` | Manage images |
| `import-image` | Import an image |
| `label` | Update labels on resources |
| `login` | Log in to a cluster |
| `logout` | Log out |
| `logs` | Print container logs |
| `new-app` | Create a new application |
| `new-build` | Create a new build |
| `new-project` | Create a new project |
| `policy` | Manage authorization policies |
| `project` | Switch/display project |
| `registry` | Manage the image registry |
| `rollback` | Revert a deployment |
| `rollout` | Manage a deployment rollout |
| `scale` | Scale a deployment |
| `secrets` | Manage secrets |
| `serviceaccounts` | Manage service accounts |
| `set` | Update object fields |
| `start-build` | Trigger a build |
| `status` | Show cluster status |
| `tag` | Tag an image |
| `whoami` | Show current user |

## License

MIT
