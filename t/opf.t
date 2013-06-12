use Test::More;
use strict;
use warnings;
use utf8;

use File::Slurp qw/read_file/;
use EPUB::Parser;

my $ee = EPUB::Parser->new;
$ee->load_file({ file_path  => 't/var/denden_converter.epub' });
my $opf = $ee->opf;

is( ref $opf->parser, 'EPUB::Parser::File::Parser::OPF', 'opf_parser' );
is($opf->path, 'OEBPS/content.opf', 'opf_path');
is($opf->dir, 'OEBPS', 'opf_dir');
ok(length $opf->data, 'opf_data');
is($opf->nav_path, 'OEBPS/nav.xhtml', 'nav_path');
is($opf->cover_image_path, 'OEBPS/cover.png', 'cover_image_path');
is($ee->opf->guess_version, '3.0', 'guess_version');


done_testing;
