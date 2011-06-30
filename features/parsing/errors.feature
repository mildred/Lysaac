Feature: Parsing errors

  Scenario: nested comments
    Given a file "c/main.li" with
        """
        Section Header

          /* comment /* nested */ */
          
          + name := MAIN;
        
        """
     When I compile the cluster "c"
     Then I shouldn't have any errors

  # TODO: more parsing errors, look at code coverage

