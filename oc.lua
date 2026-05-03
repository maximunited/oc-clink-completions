-- oc.lua
-- Clink tab-completion for the OpenShift CLI (oc / oc.exe)

local p = clink.arg.new_parser

-- General resource types (singular, plural, short alias)
local all_resources = p({
    "build", "builds",
    "buildconfig", "buildconfigs", "bc",
    "clusterrole", "clusterroles",
    "clusterrolebinding", "clusterrolebindings",
    "configmap", "configmaps", "cm",
    "cronjob", "cronjobs", "cj",
    "daemonset", "daemonsets", "ds",
    "deployment", "deployments", "deploy",
    "deploymentconfig", "deploymentconfigs", "dc",
    "endpoint", "endpoints", "ep",
    "event", "events",
    "imagestream", "imagestreams", "is",
    "imagestreamtag", "imagestreamtags", "istag",
    "ingress", "ingresses", "ing",
    "job", "jobs",
    "namespace", "namespaces", "ns",
    "networkpolicy", "networkpolicies", "netpol",
    "node", "nodes", "no",
    "persistentvolume", "persistentvolumes", "pv",
    "persistentvolumeclaim", "persistentvolumeclaims", "pvc",
    "pod", "pods", "po",
    "replicaset", "replicasets", "rs",
    "replicationcontroller", "replicationcontrollers", "rc",
    "role", "roles",
    "rolebinding", "rolebindings",
    "route", "routes",
    "secret", "secrets",
    "service", "services", "svc",
    "serviceaccount", "serviceaccounts", "sa",
    "statefulset", "statefulsets", "sts",
})

local pod_resources = p({"pod", "pods", "po"})

local scalable = p({
    "deployment", "deployments", "deploy",
    "deploymentconfig", "deploymentconfigs", "dc",
    "replicaset", "replicasets", "rs",
    "replicationcontroller", "replicationcontrollers", "rc",
    "statefulset", "statefulsets", "sts",
})

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
    "exec"         .. pod_resources,
    "explain"      .. all_resources,
    "expose"       .. all_resources,
    "get"          .. all_resources,
    "image",
    "import-image",
    "label"        .. all_resources,
    "login",
    "logout",
    "logs"         .. pod_resources,
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
