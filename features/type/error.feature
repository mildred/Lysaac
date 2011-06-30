Feature: Show an error when a type is not found
    
  @wip
  Scenario: Unknown types should be ignored
    Given the following prototypes in "c":
        | Prototype |
        | CSTRING   |
        | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - toto :TOTO;
      
      """
     When I compile the cluster "c"
     Then I should have the errors
        | c/main.li | 7 | 11 | Could not find type TOTO |

