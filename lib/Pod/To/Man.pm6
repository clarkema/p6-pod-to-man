unit class Pod::To::Man;

sub escape($s) {
    $s.subst(:g, /\-/, Q'\-');
}

sub head2man($heading) {

    qq[.SH "{$heading.uc.&escape}"\n]
}

multi sub pod2man(Pod::Heading $pod) {
    "\\fB" ~ $pod.contents>>.&pod2man.join ~ "\\fR";
}
multi sub pod2man(Pod::Block::Named $pod) {
    given $pod.name {
        when 'pod' { pod2man($pod.contents) }
        when 'para' { $pod.contents>>.&pod2man.join(' ') }
        default { head2man($pod.name) ~ "\n\n" ~ pod2man($pod.contents); }
    }
}
multi sub pod2man(Pod::Block::Code $pod) {
    qq{\n.IP "" +4m\n} ~ 
    $pod.contents>>.&pod2man.join
}
multi sub pod2man(Pod::Block::Para $pod) {
    $pod.contents>>.&pod2man.join
}
multi sub pod2man(Pod::Defn $pod) {
    "\n.TP\n.B " ~ 
    pod2man($pod.term) ~ "\n" ~
    pod2man($pod.contents);
}
multi sub pod2man(Pod::Item $pod) {
    "\n.IP \\(bu 3m\n" ~ 
    $pod.contents>>.&pod2man.join("\n.IP\n");
}
multi sub pod2man(Pod::FormattingCode $pod) {
    return '' if $pod.type eq 'Z';
    my $text = $pod.contents>>.&pod2man.join;

    given $pod.type {
        when 'B' { "\\fB$text\\fR" }
        when 'I' { "\\fI$text\\fR" }
        when 'U' { "\\fI$text\\fR" }
        when 'F' { "\\fI$text\\fR" }
        when 'C' { $text }
        when 'L' { $text ~ ($pod.meta[0] ?? [' [', $pod.meta[0], ']'].join !! ''); }
        default { $text } 
    }

}
multi sub pod2man(Positional $pod) {
    $pod>>.&pod2man.join("\n\n");
}
multi sub pod2man($pod) {
    escape($pod);
}

method render($pod) {
    ".TH {$*PROGRAM.basename} 1 " ~ Date.today ~ "\n"
    ~
    pod2man($pod);
}
