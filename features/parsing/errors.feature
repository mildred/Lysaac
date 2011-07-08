Feature: Parsing errors

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
        | file      | l | c  | message                        |
        | c         |   |    | Errors in c:                   |
        | c/main.li |   |    | Errors in c/main.li:           |
        | c/main.li | 7 | 12 | Expected return type after ":" |

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
        | file      | l | c  | message                                           |
        | c         |   |    | Errors in c:                                      |
        | c/main.li |   |    | Errors in c/main.li:                              |
        | c/main.li | 7 | 14 | Expected ":"                                      |
        | c/main.li | 7 | 14 | Expected type for argument arg, dropping argument |

  Scenario: Unexpected symbol
    Given a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
        
        Section Public
        
          - main <- `test`;
        
        """
     When I compile the cluster "c"
     Then I should have the errors
        | file      | l | c  | message              |
        | c         |   |    | Errors in c:         |
        | c/main.li |   |    | Errors in c/main.li: |
        | c/main.li | 7 | 3  | Errors in slot main: |
        | c/main.li | 7 | 13 | Unexpected symbol    |


  # TODO: more parsing errors, look at code coverage

