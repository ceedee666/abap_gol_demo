CLASS zcl_cd_game_of_life_board DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_coordinate,
             row TYPE i,
             col TYPE i,
           END OF ty_coordinate.

    TYPES: BEGIN OF ty_cell.
             INCLUDE TYPE ty_coordinate.
    TYPES:   alive TYPE abap_bool,
           END OF ty_cell.

    TYPES: tty_coordinates TYPE HASHED TABLE OF ty_coordinate
            WITH UNIQUE KEY row col.

    TYPES: tty_grid TYPE HASHED TABLE OF ty_cell
            WITH UNIQUE KEY row col
            WITH NON-UNIQUE SORTED KEY key_alive
              COMPONENTS alive.

    METHODS constructor IMPORTING i_size TYPE i.
    METHODS activate_cell
      IMPORTING
        i_row TYPE i
        i_col TYPE i.
    METHODS alive_neighbors
      IMPORTING
        i_row                    TYPE i
        i_col                    TYPE i
      RETURNING
        VALUE(r_alive_neighbors) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA size TYPE i.
    DATA grid TYPE zcl_cd_game_of_life_board=>tty_grid.

    METHODS neighbors
      IMPORTING i_row TYPE i i_col TYPE i
      RETURNING VALUE(r_neighbors) TYPE tty_grid.
ENDCLASS.



CLASS zcl_cd_game_of_life_board IMPLEMENTATION.
  METHOD constructor.
    me->size = i_size.
    me->grid = VALUE tty_grid( FOR row = 1 WHILE row <= me->size
                               FOR col = 1 WHILE col <= me->size
                               ( row = row
                                 col = col
                                 alive = abap_false ) ).
  ENDMETHOD.

  METHOD neighbors.
    DATA(neighbor_coordinates) = VALUE tty_coordinates(
                                   ( row = i_row + 1 col = i_col + 1 )
                                   ( row = i_row     col = i_col + 1 )
                                   ( row = i_row + 1 col = i_col     )
                                   ( row = i_row - 1 col = i_col - 1 )
                                   ( row = i_row     col = i_col - 1 )
                                   ( row = i_row - 1 col = i_col     )
                                   ( row = i_row + 1 col = i_col - 1 )
                                   ( row = i_row - 1 col = i_col + 1 ) ).


    r_neighbors = FILTER #(
                    me->grid IN neighbor_coordinates
                    WHERE row = row AND col = col ).

  ENDMETHOD.


  METHOD activate_cell  .
    me->grid[ row = i_row col = i_col ]-alive = abap_true.
  ENDMETHOD.


  METHOD alive_neighbors.
    r_alive_neighbors = lines(
                          FILTER #(
                            me->neighbors( i_row = i_row i_col = i_col )
                              USING KEY key_alive
                              WHERE alive = abap_true ) ).
  ENDMETHOD.

ENDCLASS.
