use Test::More;
use strict;
use warnings;
use EPUB::Extractor;
use Archive::Zip qw/ AZ_OK /;
use Data::Dumper;

my $ee = EPUB::Extractor->new;
$ee->load_file({ file_path  => 't/var/denden_converter.epub' });

my $tree = $ee->pages_manager->tree;

is_deeply($tree, {
    'no_chapter_member' => [
        'OEBPS/cover.xhtml',
        'OEBPS/nav.xhtml'
    ],
    'tree' => [
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
