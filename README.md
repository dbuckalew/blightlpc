# LPC
Tools to aid wizards on LP Muds work transfer and work with files.

# Installation
In Blightmud run: `/add_plugin https://github.com/dbuckalew/???`

## Usage
The plugin defines a new command, `/lpc <subcommand>`, with the following subcommands:

- `cd <path>`
Changes the value of the current working directory on the local computer. *The full path should be given*

- `pwd`
Shows the current value of the current working directory on the local computer.

- `get <filename>`
Retrieves the file `<filename>` located in the current working directory on the _remote_
computer and saves it with the same file name in the current working directory on
the _local_ machine.

- `send <filename>`
Stores the file `<filename>` located in the current working directory on the _local_
computer in a file with the same name in the current working directory on the 
_remote_ machine.

## Functionality
This plugin adds commands that allow users to transfer files between their local
computers and the mud. 

## What doesn't work yet

- Transferring color codes correctly
- Synchronizing directories
- The use of relative paths
- Adding a remote directory path

