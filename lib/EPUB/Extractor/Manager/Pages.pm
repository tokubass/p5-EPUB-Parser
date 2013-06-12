package EPUB::Extractor::Manager::Pages;
use strict;
use warnings;
use Smart::Args;

sub new {
    args(
        my $class => 'ClassName',
        my $opf,
        my $navi,
    );

    my $self = bless {
        opf  => $opf,
        navi => $navi,
    } => $class;

    return $self;
}

# sub chapter {
#     args(
#         my $self,
#         my $page_href,
#     );
#     my $abs_page_href = $page_href;

#     my $ordered_paths = $self->{opf}->manifest->items_path_by_spine({ abs => 1 });
#     for my $i (0..@$ordered_paths) {
# #        if($abs_page_href eq $path)
#     }
    
# }

sub tree {
    args(
        my $self,
    );

    my $tree = {
        tree => [],
        no_chapter_member => [],
    };

    my $chapter_paths = $self->{navi}->chapter_list({ abs => 1 });
    my $spine_paths = $self->{opf}->manifest->items_path_by_spine({ abs => 1 });
    my %spine_paths;
    @spine_paths{@$spine_paths} = (0 .. @$spine_paths-1);


    my @chapter_index_on_spine;
    for my $chapter_path (@$chapter_paths) {
        next if !defined $spine_paths{$chapter_path};
        push @chapter_index_on_spine, $spine_paths{$chapter_path};
    }

    if ( $chapter_index_on_spine[0] > 0 ) {
        for my $i ( 0 .. $chapter_index_on_spine[0] -1 ) {
            push @{$tree->{no_chapter_member}}, $spine_paths->[$i];
        }
    }

    for my $i ( reverse @chapter_index_on_spine ) {
            unshift @{$tree->{tree}}, [splice(@$spine_paths,$i)];
    }

    return $tree;
}


1;

