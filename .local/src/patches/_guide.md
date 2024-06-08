To apply changes to individual packages you need to get their git version.

Running paru -S package-git downloads the PKGBUILD file and then the sources specified in it. Once it downloads you can freely modify the source code that will be placed in ~/.cache/paru/clone/package-git/src

Once you make desired modifications you can dump your changes using git diff -p > ~pat/package.patch for source code and git diff -p PKGBUILD > ~pat/package_pkgbuild.patch for the PKGBUILD which needs to include a line inside prepare or build statement specifying the application of the patch.

## Watch out, git diff -p dumps a patch whose patch path might look like this:
`--- Src/init.c
 +++ Src/init.c`
This has extra context i.e. Src and you need to tell patch to treat it literally using -p0 flag. If you won't, it think that you are already inside Src folder. See man patch for more info on this. An example patch directive inside a PKGBUILD would look like this:

+  patch -p0 < ~/.local/src/patches/zsh.patch # apply silent jobs patch

Finally, add package to buildadjuster script inside ~/.local/bin to make it apply the PKGBUILD patch which will insert the source code patches
