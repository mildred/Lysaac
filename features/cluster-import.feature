Feature: Cluster import

  Scenario: Cluster includes library
    Given a file "c/main.li"
      And a file "c/toto.cli" with
      """
      Section Header
      
        + name := Cluster TOTO;
        - path := "./deps/toto";
      
      """
      And a file "c/deps/toto/toto.li"
     When I show the cluster "c"
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◇ MAIN (c/main.li)
      ╰─◆ TOTO (c/toto.cli)
        │ Cluster in: c/deps/toto
        ╰─◇ TOTO (c/deps/toto/toto.li)
      
      """

  Scenario: Cluster includes a library in standard path
    Given a file "c/main.li"
      And a file "c/toto.cli" with
      """
      Section Header
      
        + name := Cluster TOTO;
        - path := "toto";
      
      """
      And a file "toto/toto.li"
     When I set LYSAAC_PATH="$CWD"
      And I show the cluster "c"
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◇ MAIN (c/main.li)
      ╰─◆ TOTO (c/toto.cli)
        │ Cluster in: $CWD/toto
        ╰─◇ TOTO ($CWD/toto/toto.li)
      
      """

  Scenario: Cluster includes unknown library in standard path
    Given a file "c/main.li"
      And a file "c/toto.cli" with
      """
      Section Header
      
        + name := Cluster TOTO;
        - path := "toto";
      
      """
     When I show the cluster "c"
     Then I should see
      """
      ◆ Root Cluster
      │ Cluster in: c
      ├─◇ MAIN (c/main.li)
      ╰─◆ TOTO (c/toto.cli)
          Could not find cluster
      
      """
