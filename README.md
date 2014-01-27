# NAME

App::ZofCMS::Plugin::FileTypeIcon - present users with pretty icons depending on file type

# SYNOPSIS

\# first of all, get icon images (they are also in the examples/ dir of this distro)

    wget http://zoffix.com/new/fileicons.tar.gz;tar -xvvf fileicons.tar.gz;rm fileicons.tar.gz;

In your ZofCMS Template or Main Config File:

    plug_file_type_icon => {
        files => [  # mandatory
            qw/ foo.png bar.doc beer.pdf /,
            sub {
                my ( $t, $q, $conf ) = @_;
                return 'meow.wmv';
            },
        ],
        # all the defaults for reference:
        resource    => 'pics/fileicons/',
        prefix      => 'fileicon_',
        as_arrayref => 0, # put all files into an arrayref at $t->{t}{ $prefix }
        only_path   => 0, # i.e. do not generate the <img> element
        icon_width  => 16,
        icon_height => 16,
        code_after  => sub {
            my ( $t, $q, $conf ) = @_;
            die "Weeee";
        },
        xhtml       => 0,
    },

In your [HTML::Template](https://metacpan.org/pod/HTML::Template) file:

    <tmpl_var name='fileicon_0'>
    <tmpl_var name='fileicon_1'>
    <tmpl_var name='fileicon_2'>
    <tmpl_var name='fileicon_3'>

# DESCRIPTION

The module is a plugin for [App::ZofCMS](https://metacpan.org/pod/App::ZofCMS) that provides a method to show pretty little icons
that vary depending on the extension of the file (which is just a string as far as the module
is concerned).

This documentation assumes you've read [App::ZofCMS](https://metacpan.org/pod/App::ZofCMS), [App::ZofCMS::Config](https://metacpan.org/pod/App::ZofCMS::Config) and
[App::ZofCMS::Template](https://metacpan.org/pod/App::ZofCMS::Template)

# SEE ALSO

Depending on your needs, you may find my
[DelironUI](https://github.com/zoffixznet/DelironUI) project useful,
as it uses the same icon set, except the icons are added with
JavaScript/CSS (see `.dui.file.list`).

# GETTING THE IMAGES FOR THE ICONS

There are many icons plus the "unknown file" icon in an archive that is in examples/ directory
of this distribution. You can also get it from my website:

    wget http://zoffix.com/new/fileicons.tar.gz;
    tar -xvvf fileicons.tar.gz;
    rm fileicons.tar.gz;

As well as the original website from where I got them:
[http://www.splitbrain.org/projects/file_icons](http://www.splitbrain.org/projects/file_icons)

Alternatively, you may want to draw your own icons; in that case, the filenames for the icons
are made out as `$lowercase_filetype_extension.png`.
If you draw some icons yourself and would like to share, feel free to email them to me
at `zoffix@cpan.org`.

These images would obviously need to be placed in web-accessible directory on your website.

# FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

## `plugins`

    plugins => [ qw/FileTypeIcon/ ],

You obviously need to include the plugin in the list of plugins to execute. You're likely
to use this plugin with some other plugins, so make sure to get priority right.

## `plug_file_type_icon`

    plug_file_type_icon => {
        files => [  # mandatory
            qw/ foo.png bar.doc beer.pdf /,
            sub {
                my ( $t, $q, $conf ) = @_;
                return 'meow.wmv';
            },
        ],
        # all the defaults for reference:
        resource    => 'pics/fileicons/',
        prefix      => 'fileicon_',
        as_arrayref => 0, # put all files into an arrayref at $t->{t}{ $prefix }
        only_path   => 0, # i.e. do not generate the <img> element
        icon_width  => 16,
        icon_height => 16,
        code_after  => sub {
            my ( $t, $q, $conf ) = @_;
            die "Weeee";
        },
        xhtml       => 0,
    },

    # or set config via a subref
    plug_file_type_icon => sub {
        my ( $t, $q, $config ) = @_;
        return {
            files => [
                qw/ foo.png bar.doc beer.pdf /,
            ],
        };
    },

Plugin won't run if `plug_file_type_icon` is not set or its `files` key does not contain
any files. The `plug_file_type_icon` first-level key takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to `plug_file_type_icon` as if it was already there. If sub returns
an `undef`, then plugin will stop further processing. The `@_` of the subref will
contain (in that order): ZofCMS Template hashref, query parameters hashref and
[App::ZofCMS::Config](https://metacpan.org/pod/App::ZofCMS::Config) object. The
keys of this hashref can be set in either ZofCMS Template or Main Config Files; keys that are
set in both files will take their values from ZofCMS Template file. The following keys/values
are valid in `plug_file_type_icon`:

### `files`

    files => [
        qw/ foo.png bar.doc beer.pdf /,
        { 'beer.doc' => 'doc_file' },
        sub {
            my ( $t, $q, $conf ) = @_;
            return 'meow.wmv';
        },
    ],

__Mandatory__. The `files` key takes either an arrayref, a subref or a hashref as a value.
If its value is __NOT__ an arrayref, then it will be converted to an arrayref with just one
element - the original value.

The elements of `files` arrayref can be strings, hashrefs or subrefs. If the value is a
subref, the sub will be executed and its return value will replace the subref. The
`@_` of the sub will contain `$t, $q, $conf` (in that order) where `$t` is ZofCMS Template
hashref, `$q` is a hashref of query parameters and `$conf` is [App::ZofCMS::Config](https://metacpan.org/pod/App::ZofCMS::Config) object.

If the element is a hashref, it must contain only one key/value pair and the key will be
treated as a filename to process and the value will become the name of the key in `t` ZofCMS
special key (see `prefix` key below). If the element is a regular string, then it will be
treated as a filename to process.

### `resource`

    resource => 'pics/fileicons/',

__Optional__. Specifies the path to directory with icon images. Must be relative to `index.pl`
file and web-accessible, as this path will be used in generating path/filenames to the icons.
__Defaults to:__ `pics/fileicons/`

### `prefix`

    prefix => 'fileicon_',

__Optional__. When the plugin generates path to the icon or the `<img>` element, it
will stick it into `t` ZofCMS special key. The `prefix` key takes a string as a value and
specifies the prefix to use for keys in `t` ZofCMS special key. If `as_arrayref` key
(see below) is set to a true value, then `prefix` will specify the name of the key, in
`t` ZofCMS special key where to store that arrayref. When the element of `files` arrayref
is a hashref, the value of the only key in that hashref will become the name of the
key in `t` special key __WITHOUT__ the `prefix`; otherwise, the name will be constructed
by using `prefix` and a counter; the elements of `files` arrayref that are hashrefs do
not increase that counter. __Defaults to:__ `fileicon_` (note that underscore at the end)

### `as_arrayref`

    as_arrayref => 0,

__Optional__. Takes either true or false values.
When set to a true value, the plugin will create an arrayref of generated
`<img>` elements (or just paths) and stick it in `t` special key under `prefix` (see above) key. __Defaults to:__ `0`

### `only_path`

    only_path   => 0,

__Optional__. Takes either true or false values. When set to a true value, the plugin will
not generate the code for `<img>` elements, but instead it will only provide paths
to appropriate icon image. __Defaults to:__ `0`

### `icon_width` and `icon_height`

    icon_width  => 16,
    icon_height => 16,

__Optional__. All the icon images to which I referred you above are sized 16px x 16px. If you
are creating your own icons, use `icon_width` and `icon_height` keys to set proper
dimensions. You cannot set different sizes for individual icons, but you can use
`Image::Size` in the `code_after` sub (see below). __Defaults to:__ `16` (for both)

### `code_after`

    code_after => sub {
        my ( $t, $q, $conf ) = @_;
        die "Weeee";
    },

__Optional__. Takes a subref as a value, this subref will be run after all filenames in
`files` arrayref have been processed. The `@_` will contain (in that order) `$t, $q, $conf`
where `$t` is ZofCMS Template hashref, `$q` is hashref of query parameters and
`$conf` is [App::ZofCMS::Config](https://metacpan.org/pod/App::ZofCMS::Config) object. __By defaults:__ is not specified.

### `xhtml`

    xhtml => 0,

__Optional__. If you wish to close `<img>` elements as to when you're writing XHTML, then
set `xhtml` argument to a true value. __Defaults to:__ `0`

# GENERATED HTML CODE

The plugin generates the following HTML code:

<img class="file\_type\_icon" src="pics/fileicons/png.png" width="16" height="16" alt="PNG file" title="PNG file">

# REPOSITORY

Fork this module on GitHub:
[https://github.com/zoffixznet/App-ZofCMS-Plugin-FileTypeIcon](https://github.com/zoffixznet/App-ZofCMS-Plugin-FileTypeIcon)

# BUGS

To report bugs or request features, please use
[https://github.com/zoffixznet/App-ZofCMS-Plugin-FileTypeIcon/issues](https://github.com/zoffixznet/App-ZofCMS-Plugin-FileTypeIcon/issues)

If you can't access GitHub, you can email your request
to `bug-App-ZofCMS-Plugin-FileTypeIcon at rt.cpan.org`

# AUTHOR

Zoffix Znet <zoffix at cpan.org>
([http://zoffix.com/](http://zoffix.com/), [http://haslayout.net/](http://haslayout.net/))

# LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the `LICENSE` file included in this distribution for complete
details.
