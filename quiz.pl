#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';
use Term::ANSIColor;
use Data::Dumper;

my %vocabulary;

# TMTOWTDI
my @files = map { &{ sub { s/\n//; +$_; } } } `find . -type f -name *txt`;

foreach my $file (@files) {
    open F, "<", $file or die $!;
    while (<F>) {
        chomp;
        my ($word, $translation) = split ":", $_;
        $vocabulary{$word} = {
            translation     => $translation,
            file            => $file
        };
    }
    close F;
}

my @voc_s_arr = map { 
    [ $_, $vocabulary{$_} ]
} sort { $a cmp $b } keys %vocabulary;

# print Dumper \@voc_s_arr;

while (1) {
    my $r = int rand scalar @voc_s_arr-1;

    say "Q: German translation for " . $voc_s_arr[$r][0] . "?";
    print "A: ";
    chomp (my $answer = <STDIN>);
    
    if ($answer eq $voc_s_arr[$r][1]{translation}) {
        say "Correct!";
        select(undef, undef, undef, .5);
    }
    else {
        print color('bold red');
        say "A: ". $voc_s_arr[$r][1]{translation};
        print color('reset');
        select(undef, undef, undef, 2);
    }
    system("clear");
}

__END__

$VAR1 = [
          [
            'chime',
            {
              'file' => './en_de/comics/x-men/uncanny.x-men/137.txt',
              'translation' => 'Glocke'
            }
          ],
          [
            'consort',
            {
              'file' => './en_de/comics/hulk/2024/the.incredible.hulk/11.txt',
              'translation' => 'Gemahl;Gemahlin'
            }
          ],
          [
            'insurmountable',
            {
              'file' => './en_de/comics/x-men/uncanny.x-men/137.txt',
              'translation' => 'unüberwindlich'
            }
          ],
          [
            'sinew',
            {
              'translation' => 'Sehne',
              'file' => './en_de/comics/x-men/uncanny.x-men/137.txt'
            }
          ],
          [
            'to abhor sth.',
            {
              'file' => './en_de/comics/x-men/uncanny.x-men/137.txt',
              'translation' => 'hassen'
            }
          ],
          [
            'to elucidate',
            {
              'translation' => 'erläutern',
              'file' => './en_de/comics/x-men/uncanny.x-men/137.txt'
            }
          ],
          [
            'to mete out',
            {
              'translation' => 'verteilen',
              'file' => './en_de/comics/x-men/uncanny.x-men/137.txt'
            }
          ]
        ];
