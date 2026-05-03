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

Clone the repo, then link `oc.lua` into your Clink scripts directory so changes pulled from git take effect immediately.

**Option A — hard link (no admin required, recommended):**

```powershell
git clone https://github.com/maximunited/oc-clink-completions
New-Item -ItemType HardLink `
  -Path "$env:LOCALAPPDATA\clink\oc.lua" `
  -Target "$PWD\oc-clink-completions\oc.lua"
```

> **Note:** Hard links share the same file data on disk, so in-place edits are reflected immediately. However, `git pull` replaces the file inode, which breaks the link — re-run the `New-Item` command after pulling to restore it.

**Option B — symbolic link (survives `git pull`, requires admin or Developer Mode):**

```powershell
# Run PowerShell as Administrator, or enable Settings → Developer Mode first
git clone https://github.com/maximunited/oc-clink-completions
New-Item -ItemType SymbolicLink `
  -Path "$env:LOCALAPPDATA\clink\oc.lua" `
  -Target "$PWD\oc-clink-completions\oc.lua"
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
