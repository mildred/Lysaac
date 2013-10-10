Feature: Types must be able to contain values

  Types can be of two types: base types and structured types.
  
  Base types are integers for example and are defined using the type slot in the
  Section Header
  
  Structured types are every other type. Structured types are defined by the +
  slot they contain. A + slot generates a field in the structured type that have
  the same type as the type of the slot.
  
  This workd well for data slots. When the slot can be a code slot, the data
  field is still generated but the compiler might generate any number of
  additional slots that it requires to dispatch between data slots and code
  slots. This isn't yet implemented and as a consequence not well defined.


  Scenario: Assignment should be possible
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - one :INT32 := 1;
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
      
        - main <- Export
        (
          printf("Hello World to %dntegers", one);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World to 1ntegers
      """

  Scenario: values can change over time
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        + one :INT32 := 1;
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
      
        - main <- Export
        (
          printf("Hello World to %dntegers", one);
          one := 2;
          printf(" and %dntegers", one);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello World to 1ntegers and 2ntegers
      """

  Scenario: values are different on different objects
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        + one :INT32 := 1;
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
        - puts   (string:CSTRING)            <- External `puts`;
        - malloc (size:INT32) :MAIN          <- External `malloc`;
        - object_size :INT32                 <- Internal `object_size`;
      
        - hello <-
        (
          printf("Hello: %d", one);
          puts("");
        );
      
        - set i:INT32 <-
        (
          one := i;
        );
      
        - main <- Export
        ( + other :MAIN;
          hello;
          other := malloc(object_size);
          other.set 1;
          other.hello;
          other.set 2;
          other.hello;
          hello;
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello: 1
      Hello: 1
      Hello: 2
      Hello: 1
      
      """

  Scenario: shared values are the same on different objects
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - one :INT32 := 1;
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
        - puts   (string:CSTRING)            <- External `puts`;
        - malloc (size:INT32) :MAIN          <- External `malloc`;
        - object_size :INT32                 <- Internal `object_size`;
      
        - hello <-
        (
          printf("Hello: %d", one);
          puts("");
        );
      
        - set i:INT32 <-
        (
          one := i;
        );
        
        - clone :MAIN <-
        (
          malloc(object_size)
        );
      
        - main <- Export
        ( + other :MAIN;
          hello;
          other := clone;
          other.hello;
          other.set 2;
          other.hello;
          hello;
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Hello: 1
      Hello: 1
      Hello: 2
      Hello: 2
      
      """
