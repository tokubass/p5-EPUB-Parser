# NAME

    EPUB::Parser - EPUB Parser class

# SYNOPSIS

    use EPUB::Parser;
    my $ep = EPUB::Parser->newe({ epub_version => '3.0' }) #default 3.0 and current supoprt only 3.0

    # load epub 
    $ep->load_file({ file_path  => 'sample.epub' });
    # or 
    $ep->load_binary({ data  => $binary_data }) 

    # get opf version
    my $version = $extract->opf->guess_version; 

    # get css. Return value is 'EPUB::Parser::Util::Archive::Iterator' object.
    my $itr = $ep->opf->manifest->items_by_media_type({ regexp => qr{text/css}ix });
    while ( my $zip_member = $itr->next ) {
        $zip_member->data;
        $zip_member->path;
    }

    # shortcut method. iterator object contain image,audio,video item path.
    my $itr = $ep->opf->manifest->items_by_media;

    # get list under <nav id="toc" epub:type="toc"> 
    # todo: parse nested list
    for my $chapter ( @{$ep->navi->toc->list} ) {
        $chapter->{title};
        $chapter->{href};
    }

    # get cover image blob
    my $cover_img_path = $ep->opf->manifest->cover_image_path({ abs => 1 });
    $ep->data_from_path($cover_img_path);

    # get page list from each chapter.
    my $collect_pages = $ep->pages_manager->get_page_from_each_chapter;
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
    



# DESCRIPTION

    EPUB::Parser parse EPUB3 and return Perl Data Structure.
    This module can only parse EPUB3.

# METHODS

## new(\\%opts)

    Creates a new EPUB::Parser instance. Valid options are:

- epub\_version

        EPUB::Parser->new({ epub_version => '3.0' });
        epub_version is default 3.0 and current supoprt only 3.0.

## opf

    Returns instance of L<EPUB::Parser::File::OPF>.

## navi

    Returns instance of L<EPUB::Parser::File::Navi>.

## data\_from\_path($path)

    get blob from loaded EPUB with path indicated in $path.

## pages\_manager

    Returns instance of L<EPUB::Parser::Manager::Pages>.

## load\_file

    load from EPUB file.
    $ep->load_file({ file_path  => 'sample.epub' });



## load\_binary

    load from EPUB blob.
    $ep->load_binary({ data  => $binary_data })



# LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokubass <tokubass@cpan.org>
