# vault.sh

## Description
This Bash script provides functionalities for encrypting and decrypting files using AES-256-CBC encryption algorithm. It allows users to specify input files, choose between encryption and decryption actions, and optionally remove input files after encryption. Additionally, users can specify a destination path for storing encrypted or decrypted files.

## Usage

```bash
./vault.sh -a [dec|enc|cat] -f INPUT_FILE [-r REMOVE_INPUT] [-d DESTINATION_PATH]
```


- `-a [dec|enc|cat]`: Specifies the action to perform. Use `dec` for decryption, `enc` for encryption, and `cat` for decrypting and displaying the content without saving it to a file.
- `-f INPUT_FILE`: Specifies the input file to be encrypted or decrypted.
- `-r REMOVE_INPUT`: Optional flag to specify whether to remove the input file after encryption (`true` or `false`). Default is `false`.
- `-d DESTINATION_PATH`: Optional flag to specify the destination path for storing encrypted or decrypted files. Default is the current directory.

## Example
### Decrypt a File and Display Content

```bash
./vault.sh -a cat -f encrypted_files/something.txt.encrypted
```

The script prompts for the decryption password, decrypts the specified file, displays the content without saving it to a file.

### Decrypt a File

```bash
./vault.sh -a dec -f encrypted_files/something.txt.encrypted -d /path/to/destination
```

The script prompts for the decryption password, decrypts the specified file. Decrypted file is stored in the specified destination path (`-d /path/to/destination`).

### Encrypt a File

```bash
./vault.sh -a enc -f plain_files/something.txt -r true -d /path/to/destination
```

The script prompts for the encryption password, encrypts the specified file, and removes the original input file (`-r true`). Encrypted file is stored in the specified destination path (`-d /path/to/destination`).

## Notes
- The script uses OpenSSL for encryption and decryption.
- Encrypted files are stored in the `encrypted_files` directory by default, and decrypted files are stored in the `decrypted_files` directory by default. These directories are created automatically if they don't exist.
- You can specify a custom destination path using the `-d` flag.

Feel free to adjust the script and its parameters according to your requirements.
