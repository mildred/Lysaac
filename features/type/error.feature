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
        | file      | l |  c | message                             |
        | c/main.li | 1 |    | Errors in c/main.li:                |
        | c/main.li | 7 |  3 | Errors in slot toto:                |
        | c/main.li | 7 | 11 | Could not find type TOTO            |
        | c/main.li | 7 |  3 | Dropping return type for slot toto  |
        | c/main.li | 9 |  3 | Errors in slot tata:                |
        | c/main.li | 9 | 14 | Could not find type TATA            |
        | c/main.li | 9 | 10 | Cannot resolve type for arg         |
        | c/main.li | 9 |  3 | Dropping argument arg for slot tata |
  
  Scenario: Missing roles
    Given a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
          
        Section Public
        
          - integer <- 1;
          
          - string  <- "toto";
          
          - block   <- {};
        
        """
     When I compile the cluster "c"
     Then I should have the errors
        | file      |  l |  c | message                                   |
        | c/main.li |  1 |    | Errors in c/main.li:                      |
        | c/main.li |  7 |  3 | Errors in slot integer:                   |
        | c         |    |    | Could not find prototype for role Integer |
        | c/main.li |  7 | 16 | Discarding integer                        |
        | c/main.li |  7 |  3 | Dropping return value #1 for slot integer |
        | c/main.li |  9 |  3 | Errors in slot string:                    |
        | c         |    |    | Could not find prototype for role String  |
        | c/main.li |  9 | 16 | Discarding string                         |
        | c/main.li |  9 |  3 | Dropping return value #1 for slot string  |
        | c/main.li | 11 |  3 | Errors in slot block:                     |
        | c         |    |    | Could not find prototype for role Block   |
        | c/main.li | 11 | 16 | Discarding block                          |
        | c/main.li | 11 |  3 | Dropping return value #1 for slot block   |

  Scenario: Duplicate slot
    Given the following prototypes in "c":
      | Prototype |
      | INT32     |
      And a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
          
        Section Public
        
          - integer :INT32 <- 1;
          - integer :INT32 <- 2;
        
        """
     When I compile the cluster "c"
     Then I should have the errors
        | file      | l |  c | message                                   |
        | c/main.li | 1 |    | Errors in c/main.li:                      |
        | c/main.li | 7 |  3 | Slot integer has a duplicate:             |
        | c/main.li | 8 |  3 | Discarding this slot                      |

