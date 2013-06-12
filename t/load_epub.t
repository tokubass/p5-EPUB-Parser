use Test::More;
use strict;
use warnings;
use File::Slurp qw/read_file/;
use EPUB::Parser;

subtest 'EPUB::Parser::load_file' => sub {
    my $ee = EPUB::Parser->new;
    eval { $ee->load_file({ file_path  => 't/var/denden_converter.epub' }) };
    is($@,'', 'load_file');
};

subtest 'EPUB::Parser::load_binary' => sub {
    my $ee = EPUB::Parser->new;
    my $bin_data = read_file( 't/var/denden_converter.epub', binmode => ':raw' );

    local $@;
    eval { $ee->load_binary({ data  => $bin_data }) };
    is($@,'', 'read_binary');
};

subtest 'EPUB::Parser::data_from_path' => sub {
    my $ee = EPUB::Parser->new;
    $ee->load_file({ file_path  => 't/var/denden_converter.epub' });
    ok( length $ee->data_from_path('OEBPS/nav.xhtml'), 'data_from_path' );
};

done_testing;
