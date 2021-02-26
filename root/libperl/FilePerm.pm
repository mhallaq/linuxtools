package FilePerm;

use lib '/root/libperl';
use asicommon;


################################################################################
### new()
### Object Constructor.
################################################################################
sub new {
    local $self                 = {};
    $self->{FILE}            = undef;
    $self->{PERMS}            = undef;

    bless($self);
    return $self;
}
################################################################################

################################################################################
### file()
### 
################################################################################
sub file {
    local $self = shift;
    local $file = shift;
    if ($file) { $self->{FILE} = $file }
    else       { return $self->{FILE}  }
} 
################################################################################

################################################################################
### mode()
### 
################################################################################
sub mode {
    local $self = shift;
    local $mode = shift;
    if ($mode) { $self->{MODE} = $mode }
    else       { return $self->{MODE}  }
} 
################################################################################

################################################################################
### getperms()
###
################################################################################
sub getperms {
    local $self = shift;
    local $file = shift;
    $file = file($self,$file);

    local $mode  = (stat($file))[2];
    local $perms = sprintf '%o', $mode & 07777;
    if ( $perms =~ /^\d$/   ) { $perms = "00${perms}" }
    if ( $perms =~ /^\d\d$/ ) { $perms = "0${perms}"  }

    return "$perms";
}
################################################################################

################################################################################
### getuser()
###
################################################################################
sub getuser {
    local $self = shift;
    local $file = shift;
    $file = file($self,$file);

    local $uid = (stat($file))[4];
    local $user = (split(":",`/usr/bin/getent passwd $uid`))[0];

    return "$user";
}
################################################################################

################################################################################
### getgroup()
###
################################################################################
sub getgroup {
    local $self = shift;
    local $file = shift;
    $file = file($self,$file);

    local $gid = (stat($file))[5];
    local $group = (split(":",`/usr/bin/getent group $gid`))[0];

    return "$group";
}
################################################################################

################################################################################
### setperms()
###
################################################################################
sub setperms {
    local $self  = shift;
    local $perms = shift;
    local $file  = $self->{FILE};

    asicommon::run("/usr/bin/chmod $perms $file");
}
################################################################################

################################################################################
### setuser()
###
################################################################################
sub setuser {
    local $self  = shift;
    local $user  = shift;
    local $file  = $self->{FILE};

#    run("/usr/bin/chown $user $file");
}
################################################################################

################################################################################
### setgroup()
###
################################################################################
sub setgroup {
    local $self  = shift;
    local $group = shift;
    local $file  = $self->{FILE};

    print("/usr/bin/chown $group $file");
}
################################################################################

################################################################################
### setattr()
###
################################################################################
sub setattr {
    local $self  = shift;
    local $user  = shift;
    local $group = shift;
    local $perms = shift;

    setperms($self,$perms);
    setuser($self,$user);
    setgroup($self,$group);
}


1;
