#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';
use Term::ANSIColor;
use Data::Dumper;

my %vocabulary;


my $args = (join $", @ARGV) || ".";   # neither options nor directories passed.
my @fdirs = split $", $args;
my %opts = get_opts(\@fdirs);

my @files;

# TMTOWTDI
foreach my $fdir (@fdirs) {
    my @temp = map { 
        &{ sub { s/\n//; +$_; } } 
    } `find $fdir -type f -name *txt` or die $!;
    push @files, @temp;
}

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
} sort keys %vocabulary;

while (1) {
    my $r = ask();
    chomp (my $answer = <STDIN>);

    if (check_answer($answer, $voc_s_arr[$r])) {
        print color('bold white');
        say "Correct!";
    }
    else {
        print color('bold red');
        if ($opts{r}) {
            say "A: ". $voc_s_arr[$r][0];
        }
        else {
            say "A: " . $voc_s_arr[$r][1]{translation};
        }
        print color('bold magenta');
        say "F: " . $voc_s_arr[$r][1]{file};
    }

    print color('reset');
    <STDIN>;
    system("clear");
}

sub ask {
    my $r = int rand scalar @voc_s_arr;

    print "Q: Translation for ";
    print color('bold green');

    if ($opts{r}) {
        ask_reversed($r);
    }
    else {
        ask_normal($r);
    }

    print color('reset');
    say "?";
    print "A: ";

    $r;
}

sub ask_normal {
    my ($r) = @_;
    print $voc_s_arr[$r][0];
};

sub ask_reversed {
    my ($r) = @_;
    print $voc_s_arr[$r][1]{translation};
}

sub check_answer {
    my ($answer, $voc_object) = @_;
    my @possible_answers;

    if ($opts{r}) {
        @possible_answers = split ";" => $$voc_object[0];
    }
    else {
        @possible_answers = split ";" => $$voc_object[1]{translation};
    }

    grep { /^$answer$/i } @possible_answers;
}

# Get opts without value
# like -r
sub get_opts {
    my ($fdirs_arr_ref) = @_;
    my @copy = @$fdirs_arr_ref;
    my %opts = map {
        &{
            sub { s/-//; $_ => \1; }
        }
    } (grep { /^-.*$/ } @copy);

    @$fdirs_arr_ref = grep { ! /^-.*$/ } @$fdirs_arr_ref;
    @$fdirs_arr_ref = "." if scalar @$fdirs_arr_ref == 0;
    
    +%opts;
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
