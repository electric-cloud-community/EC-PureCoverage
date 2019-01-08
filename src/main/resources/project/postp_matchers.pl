use ElectricCommander;

push(@::gMatchers,

   #ERROR: ...
   #ERROR: JVMPI, an experimental interface, is no longer supported.
   
    {
   id =>        "errorDesc",
   pattern =>          q{E(RROR|rror): (.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occurred: $1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
  
    # Library error:
    # -Xrun library failed to init: PureJVMPI
    
  {
   id =>        "libraryError",
   pattern =>          q{library failed to init:\s(.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occurred: $1 library failed to init";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
  
    #Unable to ..
    #Unable to find file reportData.cfy.
    #Unable to access jarfile myJar.jar
    
  {
   id =>        "unableError",
   pattern =>          q{Unable to (.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occurred: Unable to $1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
     
    # notRecognized:
    # 'Coverage' is not recognized as an internal or external command, operable program or batch file.
  
  {
   id =>        "notRecognized",
   pattern =>          q{'Coverage' is not recognized (.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occurred: Coverage is not recognized $1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
);

