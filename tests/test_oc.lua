-- tests/test_oc.lua
-- Run from project root: lua tests/test_oc.lua

local pass, fail = 0, 0

local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        io.write("PASS  " .. name .. "\n")
        pass = pass + 1
    else
        io.write("FAIL  " .. name .. "\n      " .. tostring(err) .. "\n")
        fail = fail + 1
    end
end

local function assert_eq(a, b, msg)
    if a ~= b then
        error((msg or "") .. " expected=" .. tostring(b) .. " got=" .. tostring(a), 2)
    end
end

local function list_contains(t, val)
    for _, v in ipairs(t) do if v == val then return true end end
    return false
end

local function assert_has(t, val, ctx)
    if not list_contains(t, val) then
        error((ctx and (ctx .. ": ") or "") .. "missing \"" .. tostring(val) .. "\"", 2)
    end
end

-- ── Mock Clink API ────────────────────────────────────────────────────────────

local registered = {}

local Parser = {}
Parser.__index = Parser

local function new_parser(args)
    return setmetatable({ _args = args or {} }, Parser)
end

-- "cmd" .. parser  links a completion word to its sub-parser
Parser.__concat = function(a, b)
    return setmetatable({ _cmd = a, _parser = b }, Parser)
end

clink = {
    arg = {
        new_parser      = new_parser,
        register_parser = function(cmd, parser) registered[cmd] = parser end,
    }
}

-- ── Mock io.popen ─────────────────────────────────────────────────────────────

local popen_stubs = {}   -- { substring -> {line, line, ...} }

io.popen = function(cmd)
    local lines = {}
    for pattern, data in pairs(popen_stubs) do
        if cmd:find(pattern, 1, true) then lines = data; break end
    end
    local i = 0
    return {
        lines = function() return function() i = i + 1; return lines[i] end end,
        close = function() end,
    }
end

-- ── Load script ───────────────────────────────────────────────────────────────

dofile("oc.lua")

-- ── Parser tree helpers ───────────────────────────────────────────────────────

-- Collect the command-name strings from a parser's arg list
local function cmds(parser)
    local t = {}
    for _, entry in ipairs(parser._args or {}) do
        if type(entry) == "string" then
            t[#t + 1] = entry
        elseif type(entry) == "table" and type(entry._cmd) == "string" then
            t[#t + 1] = entry._cmd
        end
    end
    return t
end

-- Return the sub-parser linked to a command word
local function sub(parser, cmd)
    for _, entry in ipairs(parser._args or {}) do
        if type(entry) == "table" and entry._cmd == cmd then
            return entry._parser
        end
    end
end

-- ── Tests: registration ───────────────────────────────────────────────────────

test("oc registered", function()
    assert(registered["oc"] ~= nil)
end)

test("oc.exe registered", function()
    assert(registered["oc.exe"] ~= nil)
end)

test("oc and oc.exe share the same parser object", function()
    assert(registered["oc"] == registered["oc.exe"])
end)

-- ── Tests: top-level commands ─────────────────────────────────────────────────

local oc = registered["oc"]

local top_level = {
    "get", "describe", "delete", "edit", "apply", "create",
    "logs", "exec", "explain", "expose", "annotate", "label",
    "scale", "autoscale", "rollout", "rollback",
    "adm", "login", "logout", "whoami", "status",
    "new-project", "new-app", "new-build",
    "start-build", "cancel-build", "import-image",
    "tag", "set", "secrets", "serviceaccounts",
    "policy", "project", "registry", "image",
}

for _, cmd in ipairs(top_level) do
    test("top-level: " .. cmd, function()
        assert_has(cmds(oc), cmd)
    end)
end

-- ── Tests: sub-parser linkage ─────────────────────────────────────────────────

test("get  → all_resources parser", function() assert(sub(oc, "get")      ~= nil) end)
test("logs → pod_names parser",     function() assert(sub(oc, "logs")     ~= nil) end)
test("exec → pod_names parser",     function() assert(sub(oc, "exec")     ~= nil) end)
test("scale → scalable parser",     function() assert(sub(oc, "scale")    ~= nil) end)
test("autoscale → scalable parser", function() assert(sub(oc, "autoscale")~= nil) end)
test("rollout → rollout_parser",    function() assert(sub(oc, "rollout")  ~= nil) end)
test("rollback → scalable parser",  function() assert(sub(oc, "rollback") ~= nil) end)

-- ── Tests: rollout sub-commands ───────────────────────────────────────────────

local rollout = sub(oc, "rollout")

for _, rc in ipairs({"history", "pause", "restart", "resume", "status", "undo"}) do
    test("rollout: " .. rc, function()
        assert_has(cmds(rollout), rc)
    end)
end

-- ── Tests: adm sub-commands ───────────────────────────────────────────────────

local adm = sub(oc, "adm")

for _, ac in ipairs({"certificate", "cordon", "drain", "groups", "policy", "taint", "top", "uncordon"}) do
    test("adm: " .. ac, function()
        assert_has(cmds(adm), ac)
    end)
end

-- ── Tests: all_resources aliases ─────────────────────────────────────────────

local all_res = sub(oc, "get")

local aliases = {
    "pod", "pods", "po",
    "service", "services", "svc",
    "deployment", "deployments", "deploy",
    "deploymentconfig", "deploymentconfigs", "dc",
    "node", "nodes", "no",
    "namespace", "namespaces", "ns",
    "configmap", "configmaps", "cm",
    "secret", "secrets",
    "route", "routes",
    "persistentvolumeclaim", "persistentvolumeclaims", "pvc",
    "statefulset", "statefulsets", "sts",
    "replicaset", "replicasets", "rs",
    "daemonset", "daemonsets", "ds",
    "job", "jobs",
    "cronjob", "cronjobs", "cj",
    "ingress", "ingresses", "ing",
    "serviceaccount", "serviceaccounts", "sa",
    "build", "builds",
    "buildconfig", "buildconfigs", "bc",
    "imagestream", "imagestreams", "is",
    "role", "roles",
    "rolebinding", "rolebindings",
    "clusterrole", "clusterroles",
    "clusterrolebinding", "clusterrolebindings",
    "networkpolicy", "networkpolicies", "netpol",
}

for _, alias in ipairs(aliases) do
    test("all_resources alias: " .. alias, function()
        assert_has(cmds(all_res), alias)
    end)
end

-- ── Tests: scalable aliases ───────────────────────────────────────────────────

local scalable = sub(oc, "scale")

for _, alias in ipairs({"deployment", "deployments", "deploy", "dc", "sts", "rc", "rs"}) do
    test("scalable alias: " .. alias, function()
        assert_has(cmds(scalable), alias)
    end)
end

-- ── Tests: dynamic name completions ──────────────────────────────────────────

test("names_of: strips 'type/' prefix", function()
    popen_stubs["oc get pods"] = { "pod/alpha", "pod/beta" }
    local name_p = sub(all_res, "pods")
    local fn     = name_p._args[1]
    assert(type(fn) == "function", "expected closure, got " .. type(fn))
    local names  = fn()
    assert_has(names, "alpha")
    assert_has(names, "beta")
    popen_stubs = {}
end)

test("names_of: returns empty list when oc unavailable", function()
    popen_stubs = {}   -- no stubs → mock returns nothing
    local fn    = sub(all_res, "pods")._args[1]
    local names = fn()
    assert_eq(#names, 0)
end)

test("names_of: ignores stderr lines (empty after strip)", function()
    popen_stubs["oc get pods"] = { "Error from server", "", "pod/real-pod" }
    local fn    = sub(all_res, "pods")._args[1]
    local names = fn()
    -- Only "real-pod" survives; error lines have no '/' pattern match
    assert_eq(#names, 1)
    assert_has(names, "real-pod")
    popen_stubs = {}
end)

test("pod / pods / po all query API resource 'pods'", function()
    popen_stubs["oc get pods"] = { "pod/web", "pod/worker" }
    for _, alias in ipairs({"pod", "pods", "po"}) do
        local fn    = sub(all_res, alias)._args[1]
        local names = fn()
        assert(#names == 2, alias .. ": expected 2 names, got " .. #names)
        assert_has(names, "web",    alias)
        assert_has(names, "worker", alias)
    end
    popen_stubs = {}
end)

test("logs / exec use the pod_names parser (not all_resources)", function()
    -- logs and exec should NOT have resource-type options like "service"
    -- they resolve to a flat pod-name parser
    local logs_p = sub(oc, "logs")
    local exec_p = sub(oc, "exec")
    -- their _args should NOT contain "service" (would mean wrong parser attached)
    assert(not list_contains(cmds(logs_p), "service"), "logs should not list 'service'")
    assert(not list_contains(cmds(exec_p), "service"), "exec should not list 'service'")
end)

test("scalable: deployment alias queries 'deployments'", function()
    popen_stubs["oc get deployments"] = { "deployment/api", "deployment/worker" }
    local fn    = sub(scalable, "deployment")._args[1]
    local names = fn()
    assert_has(names, "api")
    assert_has(names, "worker")
    popen_stubs = {}
end)

-- ── Summary ───────────────────────────────────────────────────────────────────

io.write(string.format("\n%d passed  %d failed\n", pass, fail))
if fail > 0 then os.exit(1) end
