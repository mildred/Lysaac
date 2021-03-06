Feature: Grammar features

  Scenario: nested comments
    Given a file "c/main.li" with
        """
        Section Header

          /* comment /* nested */ */
          
          + name := MAIN;
        
        """
     When I compile the cluster "c"
     Then I shouldn't have any errors

  Scenario: negative integers
    Given the following prototypes in "c":
      | Prototype |
      | INT32     |
      And a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
        
        Section Public
        
          - int :INT32 := -3;
        
        """
     When I compile the cluster "c"
     Then I shouldn't have any errors

  Scenario: string escape sequences
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      And a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
        
        Section Public
        
          - str :CSTRING := "string with "" quote";
        
        """
     When I compile the cluster "c"
     Then I shouldn't have any errors

  Scenario: symbols
    Given the following prototypes in "c":
      | Prototype |
      And a file "c/main.li" with
        """
        Section Header
          
          + name := MAIN;
        
        Section Public
        
          - sym <- External `symbol `` with escape sequence`;
        
        """
     When I compile the cluster "c"
     Then I shouldn't have any errors


