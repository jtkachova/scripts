#!/usr/bin/perl
'di ';
'ds 00 \"';
'ig 00 ';
;#
;# fromto: sendmail syslog viewer
;#
;# Copyright (c) 1995,1996 Kazumasa Utashiro <utashiro@iij.ad.jp>
;# Internet Initiative Japan Inc.
;# Sanbancho Annex Bldg. 1-4, Sanban-cho, Chiyoda-ku, Tokyo 102, Japan
;#
;# Copyright (c) 1989-1992 Kazumasa Utashiro
;# Software Research Associates, Inc., Japan
;#
;# fromto,v 0.1 89/11/15
;; $rcsid = q$Id: fromto,v 1.5 1997/01/22 07:02:29 utashiro Exp $;
;#
;# Redistribution for non-commercial purpose, with or without
;# modification, is granted as long as all copyright notices are
;# retained.  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND
;# ANY EXPRESS OR IMPLIED WARRANTIES ARE DISCLAIMED.
;#
sub usage {
    print "fromto [-from user] [-to user] [-sleep time]\n";
    print "       [-show items] [+show items] [-ignore items]\n";
    print "       [-#] [-f] [-q] [logfiles...]\n";
    print "display items: $show\n";
    print "\n($rcsid)\n" if $rcsid =~ /:/;
    exit;
}

$sleeptime = 5;
($logfile) = grep(-f $_,
        "/home/july/mail");
$delim = "\001";
$showdefault = 'SOUE';
$show = $ENV{'FROMTO'} || ($show = $showdefault);
$show =~ s/%/$showdefault/;
$days = 1;
$condition = 0;

while ($_ = shift (@ARGV)) {
    if (/-from/) {
        $FROM = shift(@ARGV) || do usage(); $condition++; next;
    }
    if (/-to/) {
        $TO = shift(@ARGV) || do usage(); $condition++; next;
    }
    if (/-sleep/) {
        $sleeptime = shift(@ARGV) || do usage(); next;
    }
    if (/-show/) {
        $show = shift(@ARGV) || do usage(); next;
    }
    if (/\+show/) {
        $show .= shift(@ARGV) || do usage(); next;
    }
    if (/-ignore/) {
        $ignore = shift(@ARGV) || do usage();
        eval "\$show =~ s/[$ignore]//g"; next;
    }
    if (/-([0-9]+)/) {
        $days = int($1); next;
    }
    if (/-f/) { $ignoreeof = 1; next; }
    if (/-l/) { $long = 1; next; }
    if (/-q/) { $quiet = 1; next; }
    if (/-a/) { $andop = 1; next; }
    if (/-r/) { $report = 1; next; }
    if (/-h/) { do usage(); next; }
    if (/-H/) { exec "nroff -man $0 |".($ENV{'PAGER'}||'more')." -s"; die; }
    push (logfiles, ($_));
}

$_ = $show;
/[IA]/ && $showid++;
/[SA]/ && $showsent++;
/[MA]/ && $showmsgid++;
/[EA]/ && $showerror++;
/[dA]/ && $showdelay++;
/[OA]/ && $showother++;
/[LA]/ && $showlocked++;
/[UA]/ && $showunknown++;
/[DA]/ && $showdeferred++;
/[sA]/ && $showsize++;

@logfiles = &syslogfile($days) unless (@logfiles);

$SIG{'QUIT'} = 'showdeferred';

while ($syslog = shift(@logfiles)) {

    if (fileno(SYSLOG) eq "") {
        ($syslog =~ /\.Z$/) && ($syslog = "uncompress < $syslog |");
        ($syslog =~ /\.gz$/) && ($syslog = "gunzip < $syslog |");
        open(SYSLOG, $syslog) || print("--- Can't open $syslog.\n") && next;
        if ($days <= 0) {
            seek(SYSLOG, 0, 2);
        }
    }

    $quiet && printf("--- reading $syslog\n");
    while (<SYSLOG>) {

        # get date and time
        if (/^(\w{3} [ \d]\d).* (\d\d:\d\d):\d\d\s*(.*)$/) {
            ($date, $time, $_) = ($1, $2, $3);
        } else {
            !$quiet && $showunknown && print "UNKNOWN: $_\n";
            next;
        }

        $daytime = "$date $time";

        # sendmail
        if (($seq) = /sendmail\S* (\w+):/) {

#           warn "sequence number has illegal format: $seq\n"
#               if $seq !~ /^[A-Z]{3}\d{4}$/;

            # error
            if (($errmsg) = /SYSERR: (.*)/) {
                $showerror && !$quiet && print "$daytime SYSERR: $errmsg\n";
                next;
            }

            # from
            if (($from) = /from=<?([^,<>]+)>?,/) {
                $from{$seq} = join($delim, $daytime, $from);
                if ($showsize && /size=(\d+)/) {
                    $size{$seq} = $1;
                }
                next;
            }

            # to (send or deferred)
            if (($to) = /to=<?([^=]+)>?, \w+=/) {
                ($delay, $stat, $msg) = 
                    /delay=([0-9:+]+), .*stat=(.*)$/;
                @tolist = split(/[,<>]+/, $to);
                if ($stat =~ /Sent/) {
                    for (@tolist) {
                        delete $deferred{"$seq$delim$_"};
                    }
                    $showsent && &display("->", $seq, $daytime, $msg, @tolist);
                    next;
                }
                if ($stat =~ /Deferred/ || $stat =~ /queued/i) {
                    if ($msg =~ /timed out during user open with (.*)/) {
                        $msg = "t/o $1";
                    }
                    for (@tolist) {
                        $deferred{"$seq$delim$_"} =
                            join($delim, $daytime, $msg, $_);
                    }
                    $showdeferred && &display("**",$seq,$daytime,"",@tolist);
                    next;
                }
                $otherstat{$seq} = "$stat";
                $showother && &display("??",$seq,$daytime,$stat,@tolist);
                next;
            }

            if (($msgid) = /message-id=\s*(\S+)/) {
                $showmsgid && ($msgid{$seq} = $msgid);
                next;
            }
            if (/locked/) {
                !$quiet && $showlocked && print "$daytime $_\n";
                next;
            }

            !$quiet && $showunknown && print "UNKNOWN: $_\n";
        }
    }

    if (@logfiles == 0 && $ignoreeof) {
        if ($quiet) {
            printf("--- done\n");
            $quiet = 0;
        }
        seek(SYSLOG, tell(SYSLOG), 0);          # for clearerr
        sleep($sleeptime);
        redo;
    }

    close(SYSLOG);
}

$report && &showdeferred;

sub display {
    $quiet && return;
    local($mark, $seq, $daytime, $msg, @toes) = @_;
    $show = $condition ? 0 : 1;
    local($orgtime, $from) = split($delim, $from{$seq});

    $FROM && ($from{$seq} =~ /$FROM/o) && $show++;
    !$show && $andop && return;
    foreach $to (@toes) {
        $TO && ($to =~ /$TO/o) && $show++;
        next unless $show;
        return if ($andop && $show != 2);
        $m = "";
        $m .= sprintf("%12.12s", $daytime);
        $m .= sprintf("[%4d]", $size{$seq}) if $showsize;
        $m .= " ";
        $m .= sprintf("%s ", $seq) if $showid;
        $m .= sprintf("%s ", $delay) if $showdelay;
        $m .= sprintf("\n%12.12s ", "") if length($m) > 25;
        $m .= sprintf("%-26.26s ", $from ? $from : "??");
        $m .= sprintf("%s ", $mark);
        $m .= sprintf("%s", $to);
        $m .= sprintf(" [%s]", $msg) if $msg;
        $m .= sprintf("\n");
        $m .= sprintf("%12.12s %s\n", "", $msgid{$seq})
            if $showmsgid && $msgid{$seq};
        print $m;
        $daytime = "";
    }
}

sub showdeferred {
    local($save) = $showdeferred;
    $showdeferred = 1;
    print "\n-----\n";
    if (@keys = keys %deferred) {
        foreach $d (@keys) {
            &display("**", (split($delim,$d))[0], split($delim,$deferred{$d}));
        }
    } else {
        printf("No deferred mail now.\n");
    }
    print "-----\n";
    $showdeferred = $save;
}

sub syslogfile {
    local($howmany) = shift(@_) || ($howmany = 1);
    local($tmp);
    while (--$howmany) {
        $tmp = sprintf("$logfile.%d", $howmany - 1);
        unless (-f $tmp) {
            $tmp = "$tmp.Z" if -f "$tmp.Z";
            $tmp = "$tmp.gz" if -f "$tmp.gz";
        }
        push(@l, $tmp);
    }
    (@l, $logfile);
}
######################################################################
.00 ;                   # finish .ig

'di                     \" finish diversion--previous line must be blank
.nr nl 0-1              \" fake up transition to first page again
.nr % 0                 \" start at page 1
'; __END__ ############# From here on it's a standard manual page ####
.de XX
.ds XX \\$4\ (v\\$3)
..
.XX $Id: fromto,v 1.5 1997/01/22 07:02:29 utashiro Exp $
.if \n@=0 \{\
.de JP
.ig EJ
..
.\}
.if \n@=1 \{\
.de EG
.ig JP
..
.\}
.if \n@=2 \{\
.de JP
.sp 0.3v
\(rh
..
.\}
.\"----------------------------------------------------------------------
.ds CN FROMTO
.ds Cn Fromto
.ds cn fromto
.TH \*(CN 1L \*(XX
.SH NAME
\*(cn \(em sendmail logfile viewer
.SH SYNOPSIS
.in +\w'\*(cn\ 'u
.ti -\w'\*(cn\ 'u
.ta \w'\*(cn\ 'u
\fB\*(cn\fR     \c
[\|\-\fBf\fP\|]
[\|\-\fBq\fP\|]
[\|\-#\|]
[\|\-\fBfrom\fP\ \fIstring\fP\|]
[\|\-\fBto\fP\ \fIstring\fP\|]
[\|\-\fBsleep\fP\ \fItime\fP\|]
[\|\-\fBshow\fP\ \fIitems\fP\|]
[\|+\fBshow\fP\ \fIitems\fP\|]
[\|\-\fBignore\fP\ \fIitems\fP\|]
[\|\fIlogfiles\fP...\|]
.SH DESCRIPTION
.PP
.I \*(Cn
prints the sendmail logfile information in human readable
format.  Logfiles are usually placed in the
``/\fIusr\fP/\fIspool\fP/\fImqueue\fP'' directory.
.PP
If files are specified in the command line, \fI\*(cn\fP
reads data from those files. Otherwise the default files are
used.
.PP
When SIGQUIT is sent, \fI\*(cn\fP prints a list of currently
deferred messages.  This is convenient when running with the
\-f option.
.PP
Default items to be displayed can be changed by setting the
environment variable `FROMTO'.
.PP
You need the \fIPerl\fP 3.0 programming language to run this
command.
.PP
Options:
.IP "\-\fBf\fP"
Works like ``\fItail \-f\fP\|''.  Continue to read data file
after encountering eof.
.IP "\-\fBq\fP"
Start up quietly.  \fI\*(Cn\fP displays no information when
reading existing files.  It begins to display after
encountering the first eof.  This option doesn't make sense
when used without \-f option.
.IP "\-#"
Any digit can be used here.  This number means how many
files are to be read. Usually the syslog file is renamed by
cron every night. If this number is 1 (default), it reads
only from the file named \fIsyslog\fP in the logging
directory.  If 2 is specified, it reads from \fIsyslog.0\fP
and \fIsyslog\fP.
.IP "\-\fBfrom\fP \fIstring\fP"
Display information only when \fIfrom\fP field matches the
string.  Conditional options, \-from and \-to are evaluated
in logical OR manner by default.
.IP "\-\fBto\fP \fIstring\fP"
Display information only when \fIto\fP field matches the
string.
.IP "\-\fBa\fP"
Apply logical AND operation for \-from and \-to options.
This option can be used anywhere but between \-from and \-to
is easy to read.  For example next command line will only
print messages from foo to bar.
.nf

        \*(cn \-from foo \-a \-to bar

.fi
.IP "\-\fBsleep\fP \fItime\fP"
Specify the interval in seconds between reads when running
with the \-f option.  Default is 5 seconds.
.IP "\-\fBshow\fP \fIitems\fP"
Specify what kind of information is to be displayed.
\fIItems\fP is a string which contains alphabetic characters
which represent a kind of data in the following manner. 
Default is ``SOUE''.
.de NS
.br
.ns
..
.RS
.IP \fBS\fP 3
Mail is sent.  From and to fields are connected by arrow
(\f(CW->\fP).
.NS
.IP \fBD\fP 3
Mail is deferred or queued.  From and to fields are connected by two
asterisks (\f(CW**\fP).
.NS
.IP \fBI\fP 3
ID number
.NS
.IP \fBM\fP 3
Message ID
.NS
.IP \fBE\fP 3
Error information
.NS
.IP \fBO\fP 3
Status other than Sent or Deferred.  Fields are separated by
two question characters (\f(CW??\fP) and followed by status
string.
.NS
.IP \fBL\fP 3
Sendmail locked
.NS
.IP \fBU\fP 3
Unrecognized message
.NS
.IP \fBd\fP 3
Delayed time
.NS
.IP \fBA\fP 3
Show all items
.RE
.IP "\fB+show\fP \fIitems\fP"
Add \fIitems\fP to items string.
.IP "\-\fBignore\fP \fIitems\fP"
Delete \fIitems\fP from items string.
.IP "\-\fBr\fP"
Report deferred mail list before exiting.
.SH "SEE ALSO"
sendmail(8), perl(1)
.SH AUTHOR
Kazumasa Utashiro <utashiro@iij.ad.jp>
.br
Internet Initiative Japan Inc.
.SH FILES
.ta \w'/usr/spool/mqueue/syslog*\ \ \ 'u
.nf
\&/usr/spool/mqueue/syslog*     default logfile
.fi
.SH BUGS
.PP
Because this program doesn't release memory, the process
size increases forever.  It is not recommended to run it for
many days.
.PP
The syslog file format can vary from machine to machine.  If
this program doesn't interpret your syslog file correctly,
please try to fix the program, or let me know.
.ex
