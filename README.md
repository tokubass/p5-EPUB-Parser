# NAME

    EPUB::Parser - EPUB Parser class

# SYNOPSIS

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
 



# DESCRIPTION

    EPUB::Parser parse EPUB3 and return Perl Data Structure.
    This module can only parse EPUB3.

# LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokubass <tokubass@cpan.org>
