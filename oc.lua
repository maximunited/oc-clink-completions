-- oc.lua
-- 1. Define the command set as a simple table
local oc_cmds = {
    "get", "describe", "logs", "exec", "project", "new-project", 
    "status", "explain", "apply", "create", "delete", "edit",
    "adm", "image", "registry", "policy", "rollout", "rollback",
    "new-app", "new-build", "start-build", "cancel-build", "import-image",
    "tag", "label", "annotate", "expose", "set", "scale", "autoscale",
    "secrets", "serviceaccounts", "login", "logout", "whoami"
}

-- 2. Create the parser by passing the table directly
-- This avoids calling 'add_commands', which no longer exists
local oc_parser = clink.arg.new_parser(oc_cmds)

-- 3. Register the parser
-- Using the stable register_parser which maps to the new engine internally
clink.arg.register_parser("oc", oc_parser)
clink.arg.register_parser("oc.exe", oc_parser)