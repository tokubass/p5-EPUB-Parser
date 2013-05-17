package EPUB::Extractor::File::OPF::Context::Guide;
use strict;
use warnings;
use Carp;
use base 'EPUB::Extractor::File::OPF::Context';

sub list {
    my $self = shift;
    my @guide = $self->parser->in_guide->find('pkg:reference');
    return @guide;
}


1;
