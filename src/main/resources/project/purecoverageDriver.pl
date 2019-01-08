# -------------------------------------------------------------------------
# Package
#    purecoverageDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Use PureCoverage tool features on Electric Commander
#
# Plugin Version
#    1.0.2
#
# Date
#    05/06/2011
#
# Engineer
#    Andres Arias
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use warnings;
use strict; 
$|=1;

use ElectricCommander;

# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant PLATFORM_JAVA => 'java';
use constant PLATFORM_DOT_NET => 'net';
use constant PLATFORM_OTHER => 'default';

use constant RESULT_TYPE_TEXT => 'text';
use constant RESULT_TYPE_DATAFILE => 'cfy';
use constant RESULT_TYPE_DEFAULT => 'default';

# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------
$::gPureCoveragePath = "$[purecovpath]";
$::gTarget = "$[target]";
$::gPlatform = "$[platform]";
$::gAutoMergeData = "$[automerge]";
$::gResultFile = "$[resultfile]";
$::gResultFileName = "$[resultname]";
$::gSourcePath = "$[sourcepath]";
$::gPlatformParams = q($[platformparams]);
$::gAdditionalCommands = q($[additionalcommands]);
$::gWorkingDir = "$[workingdir]";

# -------------------------------------------------------------------------
# Main functions
# -------------------------------------------------------------------------
########################################################################
# main - contains the whole process to be done by the plugin, it builds 
#        the command line, sets the properties and the working directory
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub main() {
    
    # create args array
    my @args = ();
    
    #properties' map
    my %props;
    
    #executable to use
    my $executable = 'Coverage';
    
    if($::gPureCoveragePath && $::gPureCoveragePath ne '') {
        $executable = $::gPureCoveragePath;
    }
    
    #insert program to invoke
    push(@args, $executable);
    
    if($::gAdditionalCommands  && $::gAdditionalCommands  ne '') {
        foreach my $command (split(' +', $::gAdditionalCommands)) {
	    	push(@args, $command);
		}
    }

    if($::gAutoMergeData && $::gAutoMergeData ne '') {
        push(@args, '/AutoMergeData=yes /SaveMergeData');
    }else{
        push(@args, '/AutoMergeData=no');
    }
    
    if($::gPlatform && $::gPlatform ne ''){
        
        #evaluates the selected platform
        if($::gPlatform eq PLATFORM_JAVA || 
               $::gPlatform eq PLATFORM_DOT_NET || 
               $::gPlatform eq PLATFORM_OTHER){
        
            #analyzes if platform parameters are not blank to
            #include them in the command line or not
            if($::gPlatformParams && 
                    $::gPlatformParams ne '' && 
                    $::gPlatform ne PLATFORM_OTHER){
                     
                push(@args, '/'. $::gPlatform . ' ' . $::gPlatformParams);
                
            }
            
        }
        
    }
    
    if($::gResultFile && $::gResultFile ne ''){
        
        #evaluates the selected platform
        if($::gResultFile eq RESULT_TYPE_TEXT){
        
            my $defaultTextFileName = $::gResultFileName;
            
            if($defaultTextFileName && $defaultTextFileName ne ''){
               
               push(@args, '/SaveTextData=' . $defaultTextFileName);
               
            }else{
             
               push(@args, '/SaveTextData');
             
            }

        
        }elsif($::gResultFile eq RESULT_TYPE_DATAFILE){
         
         my $defaultFileName = $::gResultFileName;
            
            if($defaultFileName && $defaultFileName ne ''){
               
               push(@args, '/SaveData=' . $defaultFileName);
               
            }else{
         
            push(@args, '/SaveData=reportData.cfy');
            
        }
        }
        
    }

    if($::gSourcePath && $::gSourcePath ne ''){
     
        push(@args, '/SourcePath="' . $::gSourcePath . '"');
     
    }
    
    if($::gTarget && $::gTarget ne '' && $::gPlatform eq PLATFORM_OTHER){
     
        push(@args, '"' . $::gTarget . '"')
     
    }

    #generate the command to execute in console
    $props{'commandLine'} = createCommandLine(\@args);
    $props{'workingdir'} = $::gWorkingDir;
    
    setProperties(\%props);
    
}

########################################################################
# createCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by 
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createCommandLine($) {

  	my ($arr) = @_;

    my $commandName = @$arr[0];

    my $command = $commandName;

    shift(@$arr);

	foreach my $elem (@$arr) {
        $command .= " $elem";
    }

    return $command;
    
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties($) {

    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}

main();

