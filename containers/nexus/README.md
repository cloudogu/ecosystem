# Sonatype Nexus

Nexus Repository Manager - [https://www.sonatype.com/nexus-repository-oss](https://www.sonatype.com/nexus-repository-oss)

## Claim

The preconfigured nexus repositories can be changed by using [nexus-claim](https://github.com/cloudogu/nexus-claim).
First we have to create a model for our changes e.g.: [sample](https://github.com/cloudogu/nexus-claim/blob/develop/resources/nexus-initial-example.hcl). 
We could test our model by using the plan command against a running instance of nexus (note: do not forget to set credentials):

```bash
nexus-claim plan -i nexus-initial-example.hcl
```

If the output looks good, we could store our model in the registry. 
If we want to apply our model only once:

```bash
cat mymodel.hcl | etcdctl set /config/nexus/claim/once
```

Or we could apply our model on every start of nexus:

```bash
cat mymodel.hcl | etcdctl set /config/nexus/claim/always
```