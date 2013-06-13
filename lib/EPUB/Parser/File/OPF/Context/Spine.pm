package EPUB::Parser::File::OPF::Context::Spine;
use strict;
use warnings;
use Carp;
use parent 'EPUB::Parser::File::OPF::Context';
use EPUB::Parser::Util::AttributePacker;

sub ordered_list {
    my $self = shift;
    my $node_list = $self->parser->find('pkg:itemref');
    EPUB::Parser::Util::AttributePacker->ordered_list($node_list) || [];
}

sub attrs {
    my $self = shift;

    my $items;
    my $attr_by_id = $self->opf->manifest->attr_by_id;

    for my $idref ( @{$self->ordered_list} ) {
        push @$items, $attr_by_id->{$idref->{idref}};
    }

    return $items || [];
}

sub items_path {
    my $self = shift;
    my $args = shift || {};
    my @href = map { $_->{href} } @{$self->attrs};

    $self->opf->manifest->_items_path({ %$args, href => \@href });
}

sub items {
    my $self = shift;
    $self->opf->manifest->_items( $self->items_path({ abs => 1 }) );
}



1;

