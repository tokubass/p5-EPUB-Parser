use Test::More;
use strict;
use warnings;
use EPUB::Parser;
use Archive::Zip qw/ AZ_OK /;
use Data::Dumper;

my $ee = EPUB::Parser->new;
$ee->load_file({ file_path  => 't/var/denden_converter.epub' });

my $tree = $ee->pages_manager->get_page_from_each_chapter;

is_deeply($tree, {
    no_chapter_member => [
        'OEBPS/cover.xhtml',
        'OEBPS/nav.xhtml'
    ],
    chapter_group => [
        [
            'OEBPS/bodymatter_0_0.xhtml'
        ],
        [
            'OEBPS/bodymatter_0_1.xhtml'
        ],
        [
            'OEBPS/bodymatter_0_2.xhtml'
        ],
        [
            'OEBPS/bodymatter_0_3.xhtml'
        ],
        [
            'OEBPS/bodymatter_0_4.xhtml'
        ],
        [
            'OEBPS/bodymatter_0_5.xhtml'
        ],
        [
            'OEBPS/bodymatter_0_6.xhtml'
        ]
    ]
});

done_testing;
