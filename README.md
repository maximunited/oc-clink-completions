# oc-clink-completions

[Clink](https://chrisant996.github.io/clink/) tab-completion script for the OpenShift CLI (`oc` / `oc.exe`).

## What it does

Provides tab-completion for top-level `oc` subcommands in any Clink-enhanced `cmd.exe` session:

```
oc <TAB>
adm          annotate     apply        autoscale    cancel-build
create       delete       describe     edit         exec
explain      expose       get          image        import-image
label        login        logout       logs         new-app
new-build    new-project  policy       project      registry
rollback     rollout      scale        secrets      serviceaccounts
set          start-build  status       tag          whoami
```

## Requirements

- [Clink](https://chrisant996.github.io/clink/) v1.x (tested on Windows 11)
- OpenShift CLI (`oc.exe`) on your `PATH`

## Installation

Copy `oc.lua` to your Clink scripts directory:

```cmd
copy oc.lua %LocalAppData%\clink\
```

Restart your `cmd.exe` session (or run `clink reload` if your version supports it).

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
