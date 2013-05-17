use Test::More;
use strict;
use warnings;
use File::Slurp qw/read_file/;
use EPUB::Extractor;

subtest 'EPUB::Extractor::load_file' => sub {
    my $ee = EPUB::Extractor->new;
    eval { $ee->load_file({ file_path  => 't/var/denden_converter.epub' }) };
    is($@,'', 'load_file');
};

subtest 'EPUB::Extractor::load_binary' => sub {
    my $ee = EPUB::Extractor->new;
    my $bin_data = read_file( 't/var/denden_converter.epub', binmode => ':raw' );

    local $@;
    eval { $ee->load_binary({ data  => $bin_data }) };
    is($@,'', 'read_binary');
};


done_testing;
