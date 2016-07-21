# redirect to configured default dogu
location = / {
  return 301 https://\$host/${DEFAULT_DOGU};
}
