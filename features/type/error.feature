Feature: Show an error when a type is not found
  
  Scenario: Unknown types should be ignored
    Given a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
          
        Section Public
        
          - toto :TOTO;
          
          - tata arg:TATA;
        
        """
     When I compile the cluster "c"
     Then I should have the errors
        | c/main.li | 7 | 11 | Could not find type TOTO            |
        | c/main.li | 7 |  3 | Dropping return type for slot toto  |
        | c/main.li | 9 | 14 | Could not find type TATA            |
        | c/main.li | 9 | 10 | Cannot resolve type for arg         |
        | c/main.li | 9 |  3 | Dropping argument arg for slot tata |
  
  @wip
  Scenario: Missing roles
    Given a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
          
        Section Public
        
          - integer <- 1;
          
          - string  <- "toto";
        
        """
     When I compile the cluster "c"
     Then I should have the errors
        | c/main.li | 7 | 16 | Could not find role for Integer               |
        | c/main.li | 7 | 16 | Dropping return value #1 for instruction list |
        | c/main.li | 9 | 16 | Could not find role for String                |
        | c/main.li | 9 | 16 | Dropping return value #1 for instruction list |

