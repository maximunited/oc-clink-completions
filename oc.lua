-- oc.lua
-- Clink tab-completion for the OpenShift CLI (oc / oc.exe)

local p = clink.arg.new_parser

-- Shell out to the cluster and return a list of resource names.
-- oc -o name prints "type/name" per line; we strip the type prefix.
local function names_of(resource)
    return function()
        local names = {}
        local f = io.popen("oc get " .. resource .. " -o name 2>nul")
        if f then
            for line in f:lines() do
                local name = line:match("[^/]+/(.+)")
                if name and name ~= "" then
                    names[#names + 1] = name
                end
            end
            f:close()
        end
        return names
    end
end

-- Flatten multiple entry-lists into one table.
local function merge(...)
    local result = {}
    for _, t in ipairs({ ... }) do
        for _, v in ipairs(t) do
            result[#result + 1] = v
        end
    end
    return result
end

-- Both ns_names and out_fmts are referenced inside res(); declare before res()
-- is defined, assign before res() is ever called.
local ns_names
local out_fmts

-- Build "alias .. name-completing-parser" entries for one API resource type.
-- Each name parser inherits -n/--namespace and -o/--output flags.
local function res(api_name, ...)
    local name_p = p({ names_of(api_name) })
    name_p:set_flags(
        "-n" .. ns_names, "--namespace" .. ns_names,
        "-o" .. out_fmts,  "--output"    .. out_fmts
    )
    local t = {}
    for _, alias in ipairs({ ... }) do
        t[#t + 1] = alias .. name_p
    end
    return t
end

-- OCP uses 'projects' as the namespace equivalent.
ns_names = p({ names_of("projects") })

-- Output formats supported by oc get / describe / apply …
out_fmts = p({
    "json",
    "yaml",
    "wide",
    "name",
    "jsonpath=",
    "jsonpath-file=",
    "go-template=",
    "go-template-file=",
    "custom-columns=",
    "custom-columns-file=",
})

local all_resources = p(merge(
    res("builds",                  "build",                "builds"),
    res("buildconfigs",            "buildconfig",          "buildconfigs",          "bc"),
    res("clusterroles",            "clusterrole",          "clusterroles"),
    res("clusterrolebindings",     "clusterrolebinding",   "clusterrolebindings"),
    res("configmaps",              "configmap",            "configmaps",            "cm"),
    res("cronjobs",                "cronjob",              "cronjobs",              "cj"),
    res("daemonsets",              "daemonset",            "daemonsets",            "ds"),
    res("deployments",             "deployment",           "deployments",           "deploy"),
    res("deploymentconfigs",       "deploymentconfig",     "deploymentconfigs",     "dc"),
    res("endpoints",               "endpoint",             "endpoints",             "ep"),
    res("events",                  "event",                "events"),
    res("imagestreams",            "imagestream",          "imagestreams",          "is"),
    res("imagestreamtags",         "imagestreamtag",       "imagestreamtags",       "istag"),
    res("ingresses",               "ingress",              "ingresses",             "ing"),
    res("jobs",                    "job",                  "jobs"),
    res("namespaces",              "namespace",            "namespaces",            "ns"),
    res("networkpolicies",         "networkpolicy",        "networkpolicies",       "netpol"),
    res("nodes",                   "node",                 "nodes",                 "no"),
    res("persistentvolumes",       "persistentvolume",     "persistentvolumes",     "pv"),
    res("persistentvolumeclaims",  "persistentvolumeclaim","persistentvolumeclaims","pvc"),
    res("pods",                    "pod",                  "pods",                  "po"),
    res("replicasets",             "replicaset",           "replicasets",           "rs"),
    res("replicationcontrollers",  "replicationcontroller","replicationcontrollers","rc"),
    res("roles",                   "role",                 "roles"),
    res("rolebindings",            "rolebinding",          "rolebindings"),
    res("routes",                  "route",                "routes"),
    res("secrets",                 "secret",               "secrets"),
    res("serviceaccounts",         "serviceaccount",       "serviceaccounts",       "sa"),
    res("services",                "service",              "services",              "svc"),
    res("statefulsets",            "statefulset",          "statefulsets",          "sts")
))
-- Cover flags before resource type is chosen (e.g. "oc get -n <TAB>")
all_resources:set_flags(
    "-n" .. ns_names, "--namespace" .. ns_names,
    "-o" .. out_fmts,  "--output"    .. out_fmts
)

-- logs/exec take a pod name directly, no resource-type prefix
local pod_names = p({ names_of("pods") })
pod_names:set_flags(
    "-n" .. ns_names, "--namespace" .. ns_names,
    "-o" .. out_fmts,  "--output"    .. out_fmts
)

local scalable = p(merge(
    res("deployments",             "deployment",           "deployments",           "deploy"),
    res("deploymentconfigs",       "deploymentconfig",     "deploymentconfigs",     "dc"),
    res("replicasets",             "replicaset",           "replicasets",           "rs"),
    res("replicationcontrollers",  "replicationcontroller","replicationcontrollers","rc"),
    res("statefulsets",            "statefulset",          "statefulsets",          "sts")
))
scalable:set_flags(
    "-n" .. ns_names, "--namespace" .. ns_names,
    "-o" .. out_fmts,  "--output"    .. out_fmts
)

local rollout_parser = p({
    "history" .. scalable,
    "pause"   .. scalable,
    "restart" .. scalable,
    "resume"  .. scalable,
    "status"  .. scalable,
    "undo"    .. scalable,
})

local adm_parser = p({
    "certificate",
    "cordon",
    "drain",
    "groups",
    "policy",
    "taint",
    "top",
    "uncordon",
})

local oc_parser = p({
    "adm"          .. adm_parser,
    "annotate"     .. all_resources,
    "apply",
    "autoscale"    .. scalable,
    "cancel-build",
    "create",
    "delete"       .. all_resources,
    "describe"     .. all_resources,
    "edit"         .. all_resources,
    "exec"         .. pod_names,
    "explain"      .. all_resources,
    "expose"       .. all_resources,
    "get"          .. all_resources,
    "image",
    "import-image",
    "label"        .. all_resources,
    "login",
    "logout",
    "logs"         .. pod_names,
    "new-app",
    "new-build",
    "new-project",
    "policy",
    "project",
    "registry",
    "rollback"     .. scalable,
    "rollout"      .. rollout_parser,
    "scale"        .. scalable,
    "secrets",
    "serviceaccounts",
    "set",
    "start-build",
    "status",
    "tag",
    "whoami",
})

clink.arg.register_parser("oc", oc_parser)
clink.arg.register_parser("oc.exe", oc_parser)
