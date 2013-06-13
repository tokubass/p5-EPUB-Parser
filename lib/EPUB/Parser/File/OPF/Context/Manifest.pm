package EPUB::Parser::File::OPF::Context::Manifest;
use strict;
use warnings;
use Carp;
use Smart::Args;
use parent 'EPUB::Parser::File::OPF::Context';
use EPUB::Parser::Util::AttributePacker;

sub nav_path {
    my $self = shift;
    my $nav_path = $self->parser->single('pkg:item[@properties="nav"]/@href')->string_value;

    croak '<item properties="nav" /> is required for epub3' unless $nav_path;

    return $nav_path;
}

sub cover_image_path {
    args(
        my $self,
        my $abs => { optional => 1 },
    );
    my $cover_img_path =  $self->parser->single('pkg:item[@properties="cover-image"]/@href');

    return unless $cover_img_path;

    if ($abs) {
        return $self->{opf}->dir . '/' . $cover_img_path->string_value;
    }else{
        return $cover_img_path->string_value;
    }
}

sub attr_by_media_type {
    my $self = shift;
    my $nodes = $self->parser->find('pkg:item');
    EPUB::Parser::Util::AttributePacker->grouped_list($nodes, { group => 'media-type'});
}

sub attr_by_id {
    my $self = shift;
    my $nodes = $self->parser->find('pkg:item');
    EPUB::Parser::Util::AttributePacker->by_uniq_key($nodes, { key => 'id'});
}


sub _items_path {
    args(
        my $self,
        my $href => 'ArrayRef',
        my $abs  => { optional => 1 },
    );

    my $base_dir = '';
    if ($abs) {
        $base_dir = $self->{opf}->dir . '/';
    }

    [map { $base_dir . $_ } @$href];
}

sub items_path {
    my $self = shift;
    my $args = shift || {};

    my @href = map { $_->{href} } values %{ $self->attr_by_id || {} };

    $self->_items_path({ %$args, href => \@href });
}

sub items_path_by_media_type {
    args(
        my $self,
        my $abs => { optional => 1 },
        my $regexp,
    );

    my $attr =  $self->attr_by_media_type || {};
    my @href;
    for my $media_type ( keys %$attr ) {
        next unless $media_type =~ $regexp;
        push @href, map { $_->{href} } @{$attr->{$media_type}};
    }

    $self->_items_path({ abs => $abs, href => \@href });
}


sub _items {
    my $self  = shift;
    my $paths = shift;
    my $it = $self->{opf}->{zip}->get_members({
        files_path => $paths,
    });
    return wantarray ? $it->all : $it;
}

sub items {
    my $self = shift;
    $self->_items( $self->items_path({ abs => 1 }) );
}


sub items_by_media {
    my $self = shift;
    $self->_items( $self->items_path_by_media_type({ abs => 1, regexp => qr{image/ | video/ | audio/}ix }) );
}

sub items_by_media_type {
    args(
        my $self,
        my $regexp,
    );
    $self->_items( $self->items_path_by_media_type({ abs => 1, regexp => $regexp }) );
}


1;
