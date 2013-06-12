use Test::More;
use strict;
use warnings;
use utf8;

use File::Slurp qw/read_file/;
use EPUB::Parser;

my $ee = EPUB::Parser->new;
$ee->load_file({ file_path  => 't/var/denden_converter.epub' });
my $guide = $ee->opf->guide;

is(ref $guide, 'EPUB::Parser::File::OPF::Context::Guide', 'guide class');

my @list = $guide->list;
is(scalar @list, 3, 'size');
is(ref $list[0], 'XML::LibXML::Element', 'list element class');

subtest 'guide list' => sub {
    is_deeply(\@list,  [
        '<reference type="cover" title="表紙" href="cover.xhtml"/>',
        '<reference type="text" title="スタートページ" href="bodymatter_0_0.xhtml"/>',
        '<reference type="toc" title="目次" href="nav.xhtml"/>'
    ], 'list string');
};

done_testing;
