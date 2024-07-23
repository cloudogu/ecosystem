# Release the ecosystem

- Create new version number based on used Ubuntu version
   - Have a look at the `iso_url` parameter in images/template.prod.json
   - e.g. if the image is based on Ubuntu 24.04.1, your version could be v24.04.1-3
- Run `git flow release start v24.04.1-3` from develop
- Adapt and commit changelog
- Run `git flow release finish -s v24.04.1-3`
- Push via `git push origin main` and `git push origin develop --tags`
