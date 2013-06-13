use Test::More;
use strict;
use warnings;
use utf8;

use File::Slurp qw/read_file/;
use EPUB::Parser;

my $ee = EPUB::Parser->new;
$ee->load_file({ file_path  => 't/var/denden_converter.epub' });
my $opf = $ee->opf;

subtest 'EPUB::Parser::File::OPF::Context::Spine::ordered_list' => sub {
    is_deeply($opf->spine->ordered_list,  [
        { idref => "_cover.xhtml",  linear => "no"},
        { idref => '_nav.xhtml' },
        { idref => "_bodymatter_0_0.xhtml" },
        { idref => "_bodymatter_0_1.xhtml" },
        { idref => "_bodymatter_0_2.xhtml" },
        { idref => "_bodymatter_0_3.xhtml" },
        { idref => "_bodymatter_0_4.xhtml" },
        { idref => "_bodymatter_0_5.xhtml" },
        { idref => "_bodymatter_0_6.xhtml" },
    ], 'spine->orderd_list');
};


subtest 'EPUB::Parser::File::OPF::Context::Spine::attrs' => sub {
    my $attrs = $ee->opf->spine->items_path;

    is_deeply($attrs, [
        'cover.xhtml',
        'nav.xhtml',
        'bodymatter_0_0.xhtml',
        'bodymatter_0_1.xhtml',
        'bodymatter_0_2.xhtml',
        'bodymatter_0_3.xhtml',
        'bodymatter_0_4.xhtml',
        'bodymatter_0_5.xhtml',
        'bodymatter_0_6.xhtml'
    ], 'attrs_by_spine');
};


subtest 'EPUB::Parser::File::OPF::Context::Spine::items_path' => sub {
    my $href = $ee->opf->spine->items_path;

    my $expected = [qw( cover.xhtml nav.xhtml bodymatter_0_0.xhtml bodymatter_0_1.xhtml bodymatter_0_2.xhtml bodymatter_0_3.xhtml
                   bodymatter_0_4.xhtml bodymatter_0_5.xhtml bodymatter_0_6.xhtml )];

    is_deeply($href, $expected, 'spine_items_path');
};


subtest 'EPUB::Parser::File::OPF::Context::Spine::items' => sub {
    my $it = $ee->opf->spine->items;

    is($it->size, 9, 'items_by_spine size');

    while ( my $member = $it->next ) {
        ok(length $member->data, 'items_by_spine data');
    }
};


done_testing;
