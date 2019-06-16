# Pod::To::Man

Render Perl 6 Pod as Roff for `man(1)`, so your scripts can have proper
manpages.

## Install

```
zef install Pod::To::Man
```

## Sysopsis

From the command line:

```
perl6 --doc=Man your_script > your_script.1
```

## Limitations

This is a very early work in progress, and the Roff is not ideal.  Certain
features such as nested lists haven't received much attention yet.  On the
other hand, it's already useful enough to produce much nicer documentation
for some of my scripts than the plain text formatter.

Issues / patches / pull requests / Roff formatting suggestions are
all extremely welcome.

## Resources

* http://www.openbsd.org/papers/eurobsdcon2014-mandoc-slides.pdf
* http://mandoc.bsd.lv/man/man.7.html
