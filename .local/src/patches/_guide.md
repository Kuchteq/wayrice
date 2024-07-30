To apply changes to individual packages you need to get their git version.

Running paru -S package-git downloads the PKGBUILD file and then the sources specified in it. Once it downloads you can freely modify the source code that will be placed in ~/.cache/paru/clone/package-git/src

Once you make desired modifications you can dump your changes using git diff -p > ~pat/package.patch for source code and git diff -p PKGBUILD > ~pat/package_pkgbuild.patch for the PKGBUILD which needs to include a line inside prepare or build statement specifying the application of the patch.

## Watch out, git diff -p dumps a patch whose patch path might look like this:
`--- Src/init.c
 +++ Src/init.c`
This has extra context i.e. Src and you need to tell patch to treat it literally using -p0 flag. If you won't, it thinks that you are already inside Src folder. See man patch for more info on this. An example patch directive inside a PKGBUILD would look like this:

+  patch -p0 < ~/.local/src/patches/zsh.patch # apply silent jobs patch

This step largely depends on the way the patch is structured and what is stated here is hugely oversimplified. A better explaination of this is the excerpt from the man page of patch:
`       
       -p**num**  or  --strip=**num**
          Strip  the  smallest  prefix containing num leading slashes from each file name found in the patch file.  A sequence of
          one or more adjacent slashes is counted as a single slash.  This controls how file names found in the  patch  file  are
          treated,  in  case  you  keep your files in a different directory than the person who sent out the patch.  For example,
          supposing the file name in the patch file was

          /u/howard/src/blurfl/blurfl.c

       setting -p0 gives the entire file name unmodified, -p1 gives

          u/howard/src/blurfl/blurfl.c

       without the leading slash, -p4 gives

          blurfl/blurfl.c

       and not specifying -p at all just gives you blurfl.c.  Whatever you end up with is looked for either in the current direc‐
       tory, or the directory specified by the -d option.
`

Finally, add package to buildadjuster script inside ~/.local/bin to make it apply the PKGBUILD patch which will insert the source code patches
