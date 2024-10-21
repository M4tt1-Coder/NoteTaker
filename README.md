# NoteTaker

An user can create a list of todos or notes in the terminal.

## Purpose

This first little script is my start into scripting & automation. User can create a file storage the route directory of his machine and store a simple text-file with notes entries saved in it as strings. He / She can `save changes`, `delete` **/** `modify` **/** `create` notes.  

___

### Why a Shell Script? 

There are other scripting languages like JavaScript or Python but I thought that working with [`bash`](https://www.gnu.org/software/bash/manual/bash.html) or [`zsh`](https://zsh.sourceforge.io/Doc/) might serve as a good starting decision to learna about the concepts of scripting. 

___

### Challenges

As a beginner, the main challenge of course is to understand the different fundamentals. But besides that, a problem was / is the non-intuitive syntax of the scripting language. Like expressing different conditional statements. You can see examples in the source code.

Example: 

```bash
    if [ ${#ALL_NOTES[@]} -le 0 ]
    then
        # do some stuff
    fi
```

___

### Features

There still some open ideas for additions to the script project.

1. **_store_** the notes in the **_cloud_**
2. let the user choose where to **_place_** the **_storage folder_**

## Installation

On most operation systems, you won't need to install anything but the project itself if you already have the main setup of a developer installed.

If you can run shells in your OS, you are good to go.

___

### Get it from GitHub

You need to have [_`Git`_](https://git-scm.com/downloads) to pull the repository from GitHub to your local machine.

With this command entered in a terminal, you can check out if `Git` is installed:
```bash
    git version
```
Expected output:
> git version 2.46.2

#### Pull Repository to local machine

On your local machine, you should choose where to place your copy of the repository. If you finally selected where to store it, go to the repository on GitHub and copy the URL to the repository.

> https://github.com/M4tt1-Coder/NoteTaker.git

Now, you head to the folder you want to place the project in and write this command in an opened terminal in the folder:

```bash
    git clone <the Url to the repo>
```

Now, Git will pull the repo to your folder and you can open it in your IDE.

## Usage

To execute the script you will have to mark the script as an executable.

### Mark As Executable

You can run the following command to mark the script as an executable:

```bash
    chmod +x notes.sh
```

Then, run the script with:

```bash
    ./notes.sh
```

**Alternatively, you can run the script with an interpreter, like this:**

```bash
    bash ./notes.sh
```

... or like this: 

```bash
    sh ./notes.sh
```

#### Example

You should see something like this in your terminal:

> You can see all your created notes here.
>
> __________________ - Notes - __________________
> 
> -- no notes here --
> 
> ________________________________________________________________
> 
> You have three operation possibilities.
> Create -> 'c' || Modify -> 'm' || Delete -> 'd' || Save Changes -> 's'
> 
> -> 

### Quit Execution

You can quit the execution, when pressing: 

- `Ctr` + `C` on your computer.

___

Any other actions are explained in the script while running it. Just take a look! ;)

## Credits

Of course, as a beginner, you can't get everything right, so I had to look up plenty of things. You should be able to look up links at important parts of the script, where I searched for a solution in the web. 

A main source, as always, was [StackOverflow](https://stackoverflow.com/) for general questions and problems.

### Links

- [Bash](https://www.gnu.org/software/bash/manual/bash.html)
- [Zsh](https://wiki.archlinux.org/title/Zsh)
- [Portfolio Website](https://matthisgeissler.pages.dev) 

## License

> in the "LICENSE" file