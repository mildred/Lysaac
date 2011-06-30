Feature: Parsing errors

  @wip
  Scenario: slot with no type
    Given a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
        
        Section Public
        
          - main : <- ();
        
        """
     When I compile the cluster "c"
     Then I should have the errors
        | c/main.li | 7 | 11 | Expected return type after ":" |

  @wip
  Scenario: slot argument with no type
    Given a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
        
        Section Public
        
          - main arg <- ();
        
        """
     When I compile the cluster "c"
     Then I should have the errors
        | c/main.li | 7 | 13 | Expected ":"                                      |
        | c/main.li | 7 | 10 | Expected type for argument arg, dropping argument |

  # TODO: more parsing errors, look at code coverage

