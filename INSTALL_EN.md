# TAS Project - Installation

The project is hosted on a [private GitLab](https://stl.algo-prog.info) of the STL Master.
It is on this GitLab that you will find the sources of the parser skeleton, that you will create the git project containing your parser and that you will render.

## GitLab STL


### Access to GitLab STL

An account on the [STL private GitLab](https://stl.algo-prog.info) has been created for you by the teacher.
You should have received an *email* giving you your *login* information.
We initially use:
* like *username*: your student number;
* like *email*: your address `firstname.lastname@etu.upmc.fr` (can be changed later);
* as name: the `firstname.lastname` part of your *email* (can be changed later).

To start:
* Log in to the [STL private GitLab](https://stl.algo-prog.info) using the login information received by *email*. If you have not received an email, notify the teachers.
* When logging in for the first time, you must choose a password.
* Once connected, you can modify your name and *email* in the menu at the top right, with the *settings* option.

You are automatically a member of the `TAS-XXXX` group, where XXXX indicates the current semester (for example 2020oct or 2020oct-INSTA).
This group contains the read-only `TAS-project` project containing a parser skeleton.


### Creating a personal copy of the project on GitLab (`fork`)

Each student must fork this skeleton project to create a personal project.

* In the *Projects* > *Your projects* tab, select the project `TAS-XXXX/project-TAS` (normally only one project is visible to you). `TAS-XXXX` represents the group and `TAS-project` is the project name. This project is visible and common for all members of the group, that is to say the whole class. It is read only.
* Make a private copy by clicking the *Fork* button, and click on your name. This creates a personal project with the name `firstname.lastname/TAS-project`. You will now work in this project, and not in the `TAS-XXXX` group.
* In the *Projects* > *Your projects* tab, now select your personal project.
* Click on `Settings` in the left menu, then in the `Members` option, invite your TME manager, with the role `Master`.

**Attention**: your project under GitLab STL must remain _private_; only you and the teachers should be able to access it, not other students.



### Creating a copy on your computer (`clone`)

To develop on the project, you will work as usual with git on a local copy, and periodically pushing your changes to the repository on the GitLab STL server.
git allows you to synchronize between different computers, keep a development history, and share your code with teachers.

It's a good idea to drop an SSH key on the GitLab server for easier access to the repository.

Start by creating a local copy (`clone`) of the personal project on your computer with `git clone project-URL`.
The URL is given by the `Clone` button on the project's GitLab page.

Be careful to `clone` the personal project and not the `TAS-XXXX` group project, you will not be able to propagate your modifications (`git push`) to the latter!


## Installing dependencies

The following dependencies must be installed on your computer in order to compile the project:
* the language [OCaml:camel:](https://ocaml.org/index.fr.html) (tested with version 4.11.1);
* [Menhir](http://gallium.inria.fr/~fpottier/menhir): a parser generator for OCaml;
* [GMP](https://gmplib.org): a C library of multiprecision integers (necessary for Zarith and Apron);
* [MPFR](http://www.mpfr.org): a C library of multiprecision floats (necessary for Apron);
* [Zarith](http://github.com/ocaml/Zarith/): an OCaml multiprecision integer library;
* [CamlIDL](http://github.com/xavierleroy/camlidl/): an OCaml library for interfacing with C;
* [Apron](https://antoinemine.github.io/Apron/doc/): a C/OCaml library of numeric domains.


### Installation under Linux

Under Ubuntu, Debian and derived distributions, the installation of dependencies can be done with `apt-get` and [opam](https://opam.ocaml.org/):
```
sudo apt-get update
sudo apt-get install -y build-essential opam libgmp-dev libmpfr-dev git
opam init -y
eval $(opam env)
opam install -y menhir.20201216
opam install -y zarith mlgmpidl apron
```
If one of the `opam` commands fails, try deleting the `.opam` directory and starting again using `opam init -y --disable-sandboxing` instead of `opam init -y`.

The `apron` and `mlgmpidl` dependencies are only needed for some extensions, and you can ignore them for now if they are problematic.

### Installation under Windows 10

The project can also be developed under Windows using Windows Subsystem for Linux 2, provided you have a recent version of Windows 10.

The steps to follow are:
- Activate Windows Subsystem for Linux 2: <https://docs.microsoft.com/fr-fr/windows/wsl/install-win10>
- Install the latest version of Ubuntu from Microsoft Store (20.04 TLS at the time of writing).

You can then launch an Ubuntu shell and enter the commands shown in the previous section.


### Other systems

An alternative but more cumbersome solution than WSL is to install a Linux system in a virtual machine, e.g., [VirtualBox](https://www.virtualbox.org/).

It is also possible that the project will work natively under MacOS X.





## Compilation and first tests

After installing the dependencies, do `make` on your local copy to compile the project.

The generated executable is `analyzer.byte`.

If the compilation is successful, you can test the binary:
1. `./analyzer.byte tests/01_concrete/0111_rand.c` should display on the console the text of the program `tests/01_concrete/0111_rand.c` (in reality, the program was transformed into AST by the *parser* and converted back to text)
2. `./analyzer.byte tests/01_concrete/0111_rand.c -concrete` must display on the console the result of all possible executions of the test program, here, the fact that `x` is a value between 1 and 5


## The following

The [DOC.md](DOC.md) file documents important aspects of the project.

The [TRAVAIL.md](TRAVAIL.md) file details the work requested.
