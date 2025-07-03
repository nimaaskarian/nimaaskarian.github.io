why offline dictionaries? dictionaries are often small files (my whole setup of
dictionaries are 99M `du`). there's no need to waste your internet bandwidth
with them, searching through web dictionaries all the time.
also; local files often give you freedom and flexability in what system to use.

not to mention that when you live in some specific country the middle east, its
quite easy to get in a situation that the network is completely shutdown. well,
the need to educate oneself is higher in times of war or middle of a revolution.
# Offline dictionaries, in Arch linux
[dictd](https://archlinux.org/packages/?name=dictd) package in arch linux is the
gateway to having fully offline and amazing dictionaries. by default, it uses
[dict.org](https://dict.org).

in order to switch from dict.org to a local dictionary, you need to edit
`/etc/dict/dict.conf`:
```conf
# This is the configuration file for dict.
# Usually all you will ever need here is the server keywords.
# Refer to the dict manpage for other options.
# It will only check the second server if the first fails
server localhost
server dict.org
```

this will use `localhost` as the default host of dict. it will send the request
to `localhost` first, and then to `dict.org` on failure [^1].

[^1]: note that empty response is not considered failure.

then you need to enable and start `dictd` service in your init system (systemd).

```bash
sudo systemctl enable --now dictd
```

# installing dictionaries
in the last step, the application for you dictionaries has been setup; and you
need to install some dictionaries. there are multiple dictionaries that i found
useful, and i will explain what each of them do in their own section.

if you're not installing the dictionaries from the AUR, make sure to review
[post installation](#post-installation)

## dict-freedict-* variants
if you need a english-to-any-language (e.g. deutch) and vice versa
dictionary, this section if for you.

```bash
yay -S dict-freedict-deu-eng dict-freedict-eng-deu
```

the above will install deutsch to english, using `yay`[^2]. 

[^2]: you can use `paru` or `makepkg` accordingly

you can [search inside
AUR](https://aur.archlinux.org/packages?O=0&SeB=nd&K=dict-freedict&outdated=&SB=p&SO=d&PP=50&submit=Go)
for `dict-freedict` and see all the variants you can install

## dict-gcide
possibly trickiest to install currently; and probably the very reason i made
this blog post.

i fiddled with it for days, and neither the AUR package
`dict-gcide`, or compiling it from source (neither gnu's gcide or debian's
dict-gcide) were successful.

but there's an older version of the AUR package that works. look at the script
below on how to git clone, checkout to the working version and install it

```bash
# clone the AUR package
git clone https://github.com/S0AndS0/aur-dict-gcide
# checkout to the working version
git checkout 2b756d4577a637daf00fe2d9812d96cae4a31950
# build and install
makepkg -si
```

## dict-moby-thesaurus
the most complete offline thesaurus[^3]. according to
[wikipedia](https://en.wikipedia.org/wiki/Moby_Project#Thesaurus) it averages in
83.3 synonyms per root word.

you can install this using the following `yay` command:
```bash
yay -S dict-moby-thesaurus
```

[^3]: **thesaurus**: dicitonary of synonyms

# post installation
installing dictionaries from the AUR, has the upside of pacman hooks. they
usually add the dictionary to your `/etc/dict/dictd.conf` and restart your
`dictd` service using `systemctl restart dictd`. 

here's an example of `/etc/dict/dictd.conf` using the previously mentioned
dictionaries:
```conf
# dictd configuration file.
# whipped up by michael conrad tilstra <michael@gentoo.org>

# Informational message

global {
    site site.info
}

# who's allowed.  You might want to change this.
access {
  allow *
}

# Dictionaries are listed below.
# The initrc script scans /usr/lib/dict and adds all of the dictionaries
# it finds here.
#
# The initrc script will delete everything after the the last line and
# replace it with what it finds.  So add all of your things above.
#
# If this is a problem for people, contact me and
# we can work out a different method.
#
database eng-deu {
  index /usr/share/dictd/eng-deu.index
  data /usr/share/dictd/eng-deu.dict.dz
}

database deu-eng {
	data /usr/share/dictd/deu-eng.dict.dz
	index /usr/share/dictd/deu-eng.index
}
database moby-thesaurus {
	data /usr/share/dictd/moby-thesaurus.dict
	index /usr/share/dictd/moby-thesaurus.index
}
database gcide {
	data /usr/share/dictd/gcide.dict.dz
	index /usr/share/dictd/gcide.index
}
```
