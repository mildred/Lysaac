Feature: Integers constants can be of any integer type, not just i32
  
  Question: what exactly represents an integer literal in code. Currently,
  it is just an object of the type that has the Integer role. What can we do
  to enable other integer types to get a constant value?
  
  One solution would be to keep the integer value as is and convert it the
  first time it is used. If a message is sent to it, then convert it to the
  Integer role, if it is for an assignment to an integer type, then convert
  it to this type.
  
  We probably want the same behaviour for other litterals, one solution
  would be to change EXPR. It can have a type, but not necessarily. If we
  want to access its type, it means we want to use it. Construct the type
  at this stage.

  Scenario:
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      | BIT       |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - zero :BIT   := 0;
        - one  :INT32 := 1;
      
        - printf (format:CSTRING, arg:BIT, arg:INT32) <- External `printf`;
      
        - main <- Export
        (
          printf("Hello World to %d and %d", zero, one);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World to 0 and 1
      """
