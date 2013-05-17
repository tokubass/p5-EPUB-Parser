use Test::More;
use strict;
use warnings;
use EPUB::Extractor;
use Archive::Zip qw/ AZ_OK /;

my $zip = Archive::Zip->new();
is($zip->read( 't/var/denden_converter.epub' ) , AZ_OK, 'read zip file');

my $ee = EPUB::Extractor->new;
is( ref $ee, 'EPUB::Extractor', 'EPUB::Extractor->new');

done_testing;
