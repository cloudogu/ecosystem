# Maintenance mode

To put the CES into maintenance mode, the following String has to be written to `/config/_global/maintenance`:

```json
{
"title": "This is the title",
"text": "The is the text"
}
``` 
Every request to the CES then will be replied to with HTTP Code 503 (Service Unavailable), until the key in etcd is 
either deleted, or changed to the empty string. Changes to the JSON in etcd will be reflected immediately.

## Caution
Since the maintenance page is served by nginx, it is not possible to display the maintenance mode page while upgrading
nginx