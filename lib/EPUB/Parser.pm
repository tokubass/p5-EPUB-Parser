package EPUB::Parser;
use 5.008005;
use strict;
use warnings;
use Carp;
use EPUB::Parser::Util::EpubLoad;
use EPUB::Parser::Util::Archive;
use EPUB::Parser::File::OPF;
use EPUB::Parser::File::Navi;
use EPUB::Parser::Manager::Pages;

our $VERSION = "0.01";


sub new {
    my $class = shift;
    my $args  = shift || {};

    bless {
        zip => '',
        opf => '',
        epub_version => $args->{epub_version} || '3.0',
    } => $class;
}

sub opf {
    my $self = shift;

    $self->{opf} ||= EPUB::Parser::File::OPF->new({
        zip          => $self->{zip},
        epub_version => $self->{epub_version},
    });
}

sub navi {
    my $self = shift;

    $self->{navi} ||= EPUB::Parser::File::Navi->new({
        zip  => $self->{zip},
        path => $self->opf->nav_path,
    });
}

sub data_from_path {
    my $self = shift;
    my $path = shift;
    $self->{zip}->get_member_data({ file_path => $path });
}

sub pages_manager {
    my $self = shift;
    $self->{pages_manager} ||= EPUB::Parser::Manager::Pages->new({
        opf  => $self->opf,
        navi => $self->navi,
    });
}


sub _load_epub {
    my ($self,$args,$method) = @_;
    $self->{zip} ||= do {
        my $data = EPUB::Parser::Util::EpubLoad->$method($args);
        EPUB::Parser::Util::Archive->new({ data => $data });
    };
    return $self;
}

sub load_file   { _load_epub(@_, 'load_file'  ) };
sub load_binary { _load_epub(@_, 'load_binary') };

1;

__END__

=encoding utf-8

=head1 NAME

 EPUB::Parser - EPUB Parser class

=head1 SYNOPSIS

 use EPUB::Parser;
 my $ee = EPUB::Parser->newe({ epub_version => '3.0' }) #default 3.0 and current supoprt only 3.0

 # load epub 
 $ee->load_file({ file_path  => 'sample.epub' });
 # or 
 $ee->load_binary({ data  => $binary_data }) 

 # get opf version
 my $version = $extract->opf->guess_version; 

 # get css. Return value is 'EPUB::Parser::Util::Archive::Iterator' object.
 my $itr = $ee->opf->manifest->items_by_media_type({ regexp => qr{text/css}ix });
 while ( my $zip_member = $itr->next ) {
     $zip_member->data;
     $zip_member->path;
 }

 # shortcut method. iterator object contain image,audio,video item path.
 my $itr = $ee->opf->manifest->items_by_media;

 # get list under <nav id="toc" epub:type="toc"> 
 # todo: parse nested list
 for my $chapter ( @{$ee->navi->toc->list} ) {
     $chapter->{title};
     $chapter->{href};
 }

 # get cover image blob
 my $cover_img_path = $ee->opf->manifest->cover_image_path({ abs => 1 });
 $ee->data_from_path($cover_img_path);

 # get page list from each chapter.
 my $collect_pages = $ee->pages_manager->get_page_from_each_chapter;
 #   no_chapter_member => [
 #        'OEBPS/cover.xhtml',
 #        'OEBPS/nav.xhtml'
 #    ],
 #    chapter_group => [
 #        [
 #            'OEBPS/0_1.xhtml'
 #            'OEBPS/0_2.xhtml'
 #            'OEBPS/0_3.xhtml'
 #        ],
 #        [
 #            'OEBPS/1_1.xhtml'
 #            'OEBPS/1_2.xhtml'
 #            'OEBPS/1_3.xhtml'
 #        ],
 #        ....
 #    ]

}
 

=head1 DESCRIPTION

 EPUB::Parser parse EPUB3 and return Perl Data Structure.
 This module can only parse EPUB3.

=head1 LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokubass <tokubass@cpan.org>

=cut

