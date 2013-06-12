use Test::More;
use strict;
use warnings;
use utf8;

use File::Slurp qw/read_file/;
use EPUB::Parser;

my $ee = EPUB::Parser->new;
$ee->load_file({ file_path  => 't/var/denden_converter.epub' });
my $opf = $ee->opf;

subtest 'spine->ordered_list' => sub {
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

done_testing;
