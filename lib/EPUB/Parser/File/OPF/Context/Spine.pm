package EPUB::Parser::File::OPF::Context::Spine;
use strict;
use warnings;
use Carp;
use base 'EPUB::Parser::File::OPF::Context';
use EPUB::Parser::Util::AttributePacker;

sub ordered_list {
    my $self = shift;
    my $node_list = $self->parser->find('pkg:itemref');
    EPUB::Parser::Util::AttributePacker->ordered_list($node_list);
}


1;

