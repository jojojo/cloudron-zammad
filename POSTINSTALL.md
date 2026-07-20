On first visit, Zammad's setup wizard will ask you to create the initial admin account and configure basic settings.

Notes:
* Elasticsearch is not bundled with this package; full-text search is disabled by default (`ELASTICSEARCH_ENABLED=false`).
* Attachments are stored in the PostgreSQL database by default. You can switch to filesystem storage at any time from **Admin > System > Storage** without losing data; filesystem storage uses Cloudron's persistent app storage.
