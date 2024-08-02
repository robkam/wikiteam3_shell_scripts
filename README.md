# wikiteam3_shell_scripts

Shell scripts for batch working with [WikiTeam3](https://github.com/saveweb/wikiteam3), tested with WSL.

## Prerequisites

Ensure the following dependencies are installed:
* Install the `internetarchive` package: `sudo pip install internetarchive`
* If not there already retrieve your [IA API keys](http://www.archive.org/account/s3.php) and save them one per line (in the order provided) in `~/.wikiteam3_ia_keys.txt` file.
* Install wikiteam3: `pip install wikiteam3 --upgrade`

## Installation

* Clone this repository with: `git clone https://github.com/saveweb/wikiteam3_utilities.git`

## Usage

All operations should be executed in the `~/wikiteam3_utilities` directory.

### Scripts and files

* **download_wikis.sh**: Downloads wikis using `wikiteam3dumpgenerator`. Takes a filename as a parameter e.g. `urls.txt`. Edit `DUMP_COMMAND_PLUS="--cookies cookies.txt --user USER --pass PASSWORD"` as required.

* **./dumps/urls.txt**: One wiki URL per line. Lines starting with # are treated as comments. Place in `./dumps` directory. For private wikis append `login_required`.

* **./dumps/cookies.txt**: For private wikis export from the browser, needs to be in Netscape format.

* **check_xml_integrity.sh**: Simple integrity check of the dumped XML files. The first three numbers should be the same, the last two numbers should be the same and the file should end in `</mediawiki>`

* **upload_wikis.sh**: Uploads all dumps in `./dumps` to Internet Archive. Creates `upload_wikis.txt` listing duration of each upload.

* **cleanup.sh**: Archives the dumps from WSL directory to Windows directory, then **deletes** every directory below ./dumps and every file in ./dumps except `*.txt`. Edit `TARGET_DIR="/mnt/c/Users/USER/PATH/"` to suit your config.

* **file-info.sh**: Prints file info useful for manually updating Wikiteam3dumpgenerator `images.txt` file. Remember to change "images": false to "images": true in config.json file when uploading images.

## License

This project is licensed under the [MIT License](LICENSE).

## Contributing

Contributions are welcome. These utilities were extracted from ChatGPT and could benefit from code review. Please fork the repository, make your changes, and submit a pull request.

## To do

* **download_manage_wikis.sh**: Uses DataDump API to dump Miraheze Manage Wiki settings.

* **fetch_ia_identifiers.sh**: Fetches IA identifiers.

* **fetch_ia_metadata.py**: Fetches metadata for given IA identifiers.

* **edit_ia_metadata.py**: Edits metadata for given IA identifiers.

* **delete_ia_items.py**: Deletes IA items, (might not be possible).
