package EPUB::Extractor::File::OPF::Context::Spine;
use strict;
use warnings;
use Carp;
use base 'EPUB::Extractor::File::OPF::Context';
use EPUB::Extractor::Util::AttributePacker;

sub ordered_list {
    my $self = shift;
    my $node_list = $self->parser->find('pkg:itemref');
    EPUB::Extractor::Util::AttributePacker->ordered_list($node_list);
}


1;

