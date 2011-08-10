Feature: Virtual Tables
  
  Inheritance is implemented using a virtual table.
  
  As said in [dispatch/bool.feature], all objects subject to polymorphism have
  a special Dispatcher slot. The dispatching is different according to this
  slot:
  
   -  For integer types, dispatching is done according to the type_id constant
      using a switch instruction in LLVM. This constant must be known at compile
      time, before linkage. This excludes using symbols as constants.
  
   -  If a special virtual table type is used, the dispatching uses the
      following principles:
  
  First, the syntax is as follows:
  
      + virtual_table :POINTER <- VirtualTable;
  
  The type `POINTER` is of little interrest and could be omitted. If present, it
  must be a Reference type. It can be used to access the virtual table contents.
  
  This reference points to the following structure (the width is the pointer
  size):
  
          ┏━━━━━━━━━━━━━━━━━┓<──┐                   Root vtable:
          ┃ vtable for SELF ╂───┤                       ┏━━━━━━━━━━━━━━━━━┓<──┐
          ┣━━━━━━━━━━━━━━━━━┫   │                       ┃ vtable for SELF ╂───┘
          ┃ root's slots    ┃   │                       ┣━━━━━━━━━━━━━━━━━┫
          ┃ ...             ┃   │                       ┃ root's slots    ┃
          ┣━━━━━━━━━━━━━━━━━┫   │    We could also      ┃ ...             ┃
                                │     describe it       ┗━━━━━━━━━━━━━━━━━┛
      For each parent's parent, │     as follows:   
      we have:                  │                   Child vtable:
          ┣━━━━━━━━━━━━━━━━━┫   │                       ┏━━━━━━━━━━━━━━━━━┓
          ┃ vtable for SELF ╂───┘                       ┣ parent vtables  ┫
          ┣━━━━━━━━━━━━━━━━━┫                           ┣ ...             ┫
          ┃ parent's slots  ┃                           ┣━━━━━━━━━━━━━━━━━┫
          ┃ ...             ┃                           ┃ SELF slots      ┃
          ┣━━━━━━━━━━━━━━━━━┫                           ┃ ...             ┃
                                                        ┗━━━━━━━━━━━━━━━━━┛
      Then we have:                                 
          ┣━━━━━━━━━━━━━━━━━┫
          ┃ SELF slots      ┃
          ┃ ...             ┃
          ┗━━━━━━━━━━━━━━━━━┛

  Given the following code:
  
      Section Header        Section Header        Section Header
        + name := A;          + name := B;          + name := C;
      Section Public        Section Public        Section Inherit
        + vtable              + vtable              + parent_a :Expanded A;
          <- VitrualTable;      <- VirtualTable;    + parent_b :Expanded B;
        - a  <- do_a;         - b  <- do_b;       Section Public
        + aa := have_a;       + bb := have_b;       - a  <- do_c_a;
                                                    - b  <- do_c_b;
                                                    - c  <- do_c;
                                                    + cc := have_c;

  The virtual table of C is as follows:
  
      A, C ──>┏━━━━━━━━━━━━━━━━━┓<──┐       ⎫
              ┃ vtable for C    ╂───┤   ⎫   ⎪
              ┣━━━━━━━━━━━━━━━━━┫   │   ⎬ A ⎪
              ┃ @ do_c_a        ┃   │   ⎭   ⎪
         B ──>┣━━━━━━━━━━━━━━━━━┫   │       ⎪
              ┃ vtable for C    ╂───┘   ⎫   ⎬ C
              ┣━━━━━━━━━━━━━━━━━┫       ⎬ B ⎪
              ┃ @ do_c_b        ┃       ⎭   ⎪
              ┣━━━━━━━━━━━━━━━━━┫           ⎪
              ┃ @ do_c          ┃           ⎪
              ┗━━━━━━━━━━━━━━━━━┛           ⎭

  The mapping for an object C would be:
  
         C ──>┏━━━━━━━━━━━━━━━━━┓                        ⎫
              ┃ vtable          ╂───> vtable for C       ⎪
         A ──>┣━━━━━━━━━━━━━━━━━┫                        ⎪
              ┃ vtable          ╂───> vtable for A   ⎫   ⎪
              ┣━━━━━━━━━━━━━━━━━┫                    ⎬ A ⎪
              ┃ aa              ┃                    ⎭   ⎪
         B ──>┣━━━━━━━━━━━━━━━━━┫                        ⎬ C
              ┃ vtable          ╂───> vtable for B   ⎫   ⎪
              ┣━━━━━━━━━━━━━━━━━┫                    ⎬ B ⎪
              ┃ bb              ┃                    ⎭   ⎪
              ┣━━━━━━━━━━━━━━━━━┫                        ⎪
              ┃ cc              ┃                        ⎪
              ┗━━━━━━━━━━━━━━━━━┛                        ⎭

  To construct the object mapping, one rule to keep in mind is that for each
  level of the hierarchy, the VirtualTable slot is copied. If the parent is
  Expanded, it is included in the object as it is, else only its reference is
  stored. Nevertheless, its VirtualTable argument must always point to the
  correct part of the virtual table of the dynamic type.
  
  It is necessary to know the size of an object that we want to inherit
  Expanded, but as all operations with Expanded, this size is known by querying
  the object_size special method.

  As for the diamond issue (imagine both A and B abobe inherit from OBJECT),
  both OBJECT from A and OBJECT from B must be included in the virtual table.
  It doesn't prevent a common slot to have the same pointer in the two sub-parts
  of the virtual table. As for the object's mapping, it has not yet been
  defined. A change in the mapping might be necessary.
