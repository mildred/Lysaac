Feature: Complex integers
  
  Scenario Outline: passing integers
    Given the following prototypes in "c":
      | Prototype |
      | CSTRING   |
      | INT32     |
      And a file "c/main.li" with
      """
      Section Header
        
        + name := MAIN;
        
      Section Public
      
        - printf (format:CSTRING, arg:INT32) <- External `printf`;
        
        - num :INT32 := <integer>;
      
        - main <- Export
        (
          printf("Integer: %d", num);
        );
      
      """
     When I execute the cluster "c"
     Then I should see
      """
      Integer: <result>
      """
     
    Examples:
      | integer |  result |
      |       1 |       1 |
      |      -1 |      -1 |
      |      -0 |       0 |
      |  10_000 |   10000 |
      |      1k |    1000 |
      |     1Ki |    1024 |
      |      1M | 1000000 |
      |     1Mi | 1048576 |
      |     2e0 |       2 |
      |     1e2 |     100 |
      |     3e4 |   30000 |
      |     3E4 |   30000 |
      |    0625 |     625 |
      |    0b10 |       2 |
      |    0o10 |       8 |
      |    0d10 |      10 |
      |    0x10 |      16 |
      |   02:10 |       2 |
      |   03:10 |       3 |
      |   08:11 |       9 |
      |  016:11 |      17 |
      |  0f::11 |      17 |
      |  0z::10 |      36 |
      |   0f::f |      15 |
      |   0f::F |      15 |
      |   0F::F |      15 |

