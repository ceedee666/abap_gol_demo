*"* use this source file for your ABAP unit test classes
CLASS ltcl_game_of_life_board DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_neighbors FOR TESTING RAISING cx_static_check,
      test_alive_neighbors FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_game_of_life_board IMPLEMENTATION.

  METHOD test_neighbors.
    DATA(board) = NEW zcl_cd_game_of_life_board( 3 ).

    DATA(neighbors_cell_1_1) = board->neighbors( i_col = 1 i_row = 1 ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'Cell at position (1,1) should have 3 neighbors'
        exp = 3
        act = lines( neighbors_cell_1_1 ) ).

    cl_abap_unit_assert=>assert_table_contains(
      EXPORTING
        msg   = 'Cell (1,2) should be a neighbor of cell (1,1)'
        line  = VALUE zcl_cd_game_of_life_board=>ty_cell( row = 1 col = 2 )
        table = neighbors_cell_1_1 ).

    cl_abap_unit_assert=>assert_table_contains(
      EXPORTING
        msg = 'Cell (2,2) should be a neighbor of cell (1,1)'
        line = VALUE zcl_cd_game_of_life_board=>ty_cell( row = 2 col = 2 )
        table = neighbors_cell_1_1 ).

    cl_abap_unit_assert=>assert_table_contains(
      EXPORTING
        msg = 'Cell (2,1) should be a neighbor of cell (1,1)'
        line = VALUE zcl_cd_game_of_life_board=>ty_cell( row = 2 col = 1 )
        table = neighbors_cell_1_1 ).


    DATA(neighbors_cell_2_2) = board->neighbors( i_col = 2 i_row = 2 ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'Cell at position (2,2) should have 8 neighbors'
        exp = 8
        act = lines( neighbors_cell_2_2 ) ).



    DATA(neighbors_cell_3_2) = board->neighbors( i_col = 3 i_row = 2 ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'Cell at position (3,2) should have 5 neighbors'
        exp = 5
        act = lines( neighbors_cell_3_2 ) ).
  ENDMETHOD.

  METHOD test_alive_neighbors.
    DATA(board) = NEW zcl_cd_game_of_life_board( 3 ).

    " | | | |
    " | |X|X|
    " | |X|X|
    board->activate_cell( i_row = 2 i_col = 2 ).
    board->activate_cell( i_row = 2 i_col = 3 ).
    board->activate_cell( i_row = 3 i_col = 2 ).
    board->activate_cell( i_row = 3 i_col = 3 ).

    cl_abap_unit_assert=>assert_equals( msg = 'Cell (1,1) should have 1 alive neighbors' exp = 1 act = board->alive_neighbors( i_row = 1 i_col = 1 ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'Cell (2,2) should have 3 alive neighbors' exp = 3 act = board->alive_neighbors( i_row = 2 i_col = 2 ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'Cell (3,1) should have 2 alive neighbors' exp = 2 act = board->alive_neighbors( i_row = 3 i_col = 1 ) ).

  ENDMETHOD.

ENDCLASS.
