package EPUB::Parser::File::OPF::Context::Guide;
use strict;
use warnings;
use Carp;
use parent 'EPUB::Parser::File::OPF::Context';

sub list {
    my $self = shift;
    my @guide = $self->parser->in_guide->find('pkg:reference');
    return @guide;
}


1;
