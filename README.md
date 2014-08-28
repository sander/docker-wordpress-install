# WordPress installation on Docker

Sets up MySQL and WordPress from the official repos, with auto-generated
passwords. WordPress uses the `wordpress` user and table name and is
served on port 3000.

Usage: `make`. Uninstall with `make remove` (clears data as well).