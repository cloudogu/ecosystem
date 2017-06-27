# Warp Menu

## Custom Entries

Custom entries can be inserted by using the externals part of etcd.
The entries must be a json struct of the following form:

```json
{
    "DisplayName": "Cloudogu", 
    "Description": "Home of Cloudogu", 
    "Category": "External Links", 
    "URL": "https://cloudogu.com/"
}
```

The entries can be inserted with etcdctl e.g.:

```bash
etcdctl set externals/cloudogu '{"DisplayName": "Cloudogu","Description": "Home of Cloudogu", "Category": "External Links", "URL": "https://cloudogu.com/"}'
```