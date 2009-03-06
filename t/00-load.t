#!/usr/bin/env perl

use Test::More tests => 4;

BEGIN {
    use_ok('App::ZofCMS');
    use_ok('File::Spec');
    use_ok('App::ZofCMS::Plugin::Base');
	use_ok( 'App::ZofCMS::Plugin::FileTypeIcon' );
}

diag( "Testing App::ZofCMS::Plugin::FileTypeIcon $App::ZofCMS::Plugin::FileTypeIcon::VERSION, Perl $], $^X" );
