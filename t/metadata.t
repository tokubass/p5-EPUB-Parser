use Test::More;
use strict;
use warnings;
use utf8;

use File::Slurp qw/read_file/;
use EPUB::Parser;

my $ee = EPUB::Parser->new;
$ee->load_file({ file_path  => 't/var/denden_converter.epub' });
my $opf = $ee->opf;

subtest 'metadata_title' => sub {
    is($opf->metadata->title, 'テスト', 'metadata_title');
};

subtest 'metadata_creator' => sub {
    is($opf->metadata->creator, 'おーさー', 'metadata_creator');
};

subtest 'metadata_language' => sub {
    is($opf->metadata->language, 'ja', 'metadata_language');
};

subtest 'metadata_identifier' => sub {
    is($opf->metadata->identifier, 'urn:uuid:9d53b96a-0027-47f5-9e32-9901db1f1233', 'metadata_identifier');
};


done_testing;
