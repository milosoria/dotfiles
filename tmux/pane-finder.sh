#!/bin/bash
# Buscador de panes (prefix + f): lista los panes de todas las ventanas y salta al elegido.
#
# Se lee como la barra: primero repos/servers con su nombre de ventana, después Claude con su
# punto de estado y el título completo de la sesión (la barra lo corta). Los colores salen del
# tema (@accent, @accent2, pane-border-style), así que siguen al comando `theme`.

accent=$(tmux show -gv @accent)
accent2=$(tmux show -gv @accent2)
border=$(tmux show -gv pane-border-style | sed -n 's/.*fg=\([^,]*\).*/\1/p')
[ -n "$border" ] || border=240

claude='#{||:#{m:claude,#{pane_current_command}},#{m:[0-9]*.[0-9]*.[0-9]*,#{pane_current_command}}}'
t=$'\t'
fmt="#{pane_id}${t}#{?${claude},c,s}${t}#{?@claude-state,#{@claude-state},#{@claude-alert}}${t}#{E:@row-idx}#{?#{!=:#{window_panes},1},.#{pane_index},}${t}#{?${claude},#{s|^✳ ||:pane_title},#{?automatic-rename,#W #{b:pane_current_path},  #W}}${t}#{s|^/Users/[^/]*|~|:pane_current_path}${t}#{&&:#{window_active},#{pane_active}}${t}#{window_id}"

# una línea por pane: "<pane_id>\t<lo que se ve>", con columnas alineadas por caracteres (no bytes)
rows() {
  tmux list-panes -a -F "$fmt" | ACCENT=$accent ACCENT2=$accent2 perl -CSD -Mutf8 -e '
    sub ansi {
      my $c = shift;
      return sprintf "\e[38;2;%d;%d;%dm", map hex, $c =~ /^#(..)(..)(..)$/ if $c =~ /^#/;
      return "\e[38;5;$1m" if $c =~ /^colou?r(\d+)$/;
      my %n = (black => 30, red => 31, green => 32, yellow => 33, blue => 34, magenta => 35, cyan => 36, white => 37);
      return exists $n{$c} ? "\e[$n{$c}m" : "";
    }
    my ($acc, $acc2, $dim, $off) = (ansi($ENV{ACCENT}), ansi($ENV{ACCENT2}), "\e[90m", "\e[0m");
    my %dot = (wait => "\e[31m●", busy => "\e[32m●", idle => "\e[33m●");

    # de claude va una sola entrada por ventana: la sesión principal (pane de menor índice),
    # como en la barra. Los subagentes que corren en los otros panes no aparecen
    my (@rows, %seen);
    while (<STDIN>) {
      chomp;
      my @f = split /\t/, $_, -1;
      if ($f[1] eq "c") {
        ($f[3]) = split /\./, $f[3];
        next if $seen{$f[7]}++;
        $f[4] = "\x{F06A9} $f[4]";
      }
      push @rows, \@f;
    }
    my ($wi, $wn) = (0, 0);
    for (@rows) {
      $wi = length $_->[3] if length $_->[3] > $wi;
      $wn = length $_->[4] if length $_->[4] > $wn;
    }
    $wn = 50 if $wn > 50;

    for my $kind ("s", "c") {
      for (grep { $_->[1] eq $kind } @rows) {
        my ($id, $k, $st, $idx, $name, $path, $cur) = @$_;
        $name = substr($name, 0, $wn - 1) . "…" if length $name > $wn;
        my $pad = " " x ($wn - length $name);
        $name = "$acc2$1$off$2" if $k eq "c" && $name =~ /^(\S+)( .*)$/;
        $name = "$acc\e[1m$name$off" if $cur;
        my $mark = $k eq "c" ? ($dot{$st} // "\e[33m●") . $off : " ";
        printf "%s\t %s %s%*s%s  %s%s  %s%s%s\n", $id, $mark, $dim, $wi, $idx, $off, $name, $pad, $dim, $path, $off;
      }
    }
  '
}

fzcolor() { printf '%s' "$1" | sed 's/^colou\{0,1\}r//'; }
a=$(fzcolor "$accent") a2=$(fzcolor "$accent2") b=$(fzcolor "$border")

pane=$(rows | fzf --ansi --delimiter="$t" --with-nth=2 --tiebreak=index --cycle \
  --layout=reverse --border=rounded --border-label=' panes ' --border-label-pos=3 \
  --prompt='❯ ' --pointer='▌' --info=inline-right --no-scrollbar --highlight-line --gutter=' ' \
  --color="fg:-1,bg:-1,hl:$a,fg+:-1:bold,bg+:$b,hl+:$a,gutter:-1,pointer:$a,prompt:$a2,info:$b,border:$b,label:$a:bold" \
  --bind='tab:up,shift-tab:down' | cut -f1)

[ -n "$pane" ] && tmux switch-client -t "$pane"
