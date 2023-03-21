MODULE Menus;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/menus.html
 *)

(* System imports *)
FROM GraphicsD  IMPORT  jam2;
FROM InOut      IMPORT  WriteLn, WriteString;
FROM IntuitionD IMPORT  menuEnabled,
                        Image, IntuiText, IntuiTextPtr,
                        Menu, MenuItem, MenuItemPtr, MenuItemFlags, MenuItemFlagSet,
                        WindowPtr;
FROM IntuitionL IMPORT  ClearMenuStrip, OffMenu, OnMenu, SetMenuStrip;
FROM SYSTEM     IMPORT  ADDRESS, ADR, BITSET, LONGSET;

(* Tutorial imports *)
FROM MyWindow   IMPORT  MakeWindow, RunWindow;

VAR
    item1, item2, item3, item4  : MenuItem;
    text1, text2, text3, text4  : IntuiText;

    menu    : Menu;
    window  : WindowPtr;

(* ------------------------------------------------------------------------- *)
PROCEDURE InitText(VAR text : IntuiText;
                    words : ADDRESS);
BEGIN
    WITH text DO
        frontPen := 0;
        backPen := 1;
        drawMode := jam2;
        leftEdge := 4;
        topEdge := 2;
        iTextFont := NIL;
        iText := words;
        nextText := NIL;
    END;
END InitText;

(* ------------------------------------------------------------------------- *)
PROCEDURE InitMenuItem(VAR item : MenuItem;
                       top  : INTEGER;
                       text : IntuiTextPtr;
                       next : MenuItemPtr);
CONST
    itemWidth   = 48;
    itemHeight  = 12;
    itemFlags   = MenuItemFlagSet{itemText,itemEnabled,highComp};

BEGIN
    WITH item DO
        nextItem := next;
        leftEdge := 0;
        topEdge := top;
        width := itemWidth;
        height := itemHeight;
        flags := itemFlags;
        mutualExclude := LONGSET{0};
        itemFill := text;
        selectFill := text;
        command := CHR(0);
        subItem :=  NIL;
        nextSelect := 0
    END;
END InitMenuItem;

(* ------------------------------------------------------------------------- *)
PROCEDURE InitMenu(window : WindowPtr) : BOOLEAN;

BEGIN
    InitText(text1, ADR("Quit"));
    InitText(text2, ADR("Print"));
    InitText(text3, ADR("Save"));
    InitText(text4, ADR("Open"));

    InitMenuItem(item1,  0, ADR(text4), NIL);
    InitMenuItem(item2, 12, ADR(text3), ADR(item1));
    InitMenuItem(item3, 24, ADR(text2), ADR(item2));
    InitMenuItem(item4, 36, ADR(text1), ADR(item3));

    WITH menu DO
        nextMenu := NIL;
        leftEdge := 0;
        topEdge := 0;
        width := 48;
        height := 12;
        flags := BITSET{menuEnabled};
        menuName := ADR("FILE");
        firstItem := ADR(item4);
        jazzX := 0; jazzY := 0; beatX := 0; beatY := 0;
    END;

    RETURN SetMenuStrip(window, ADR(menu));
END InitMenu;


(* ------------------------------------------------------------------------- *)
BEGIN
    window := MakeWindow(200, 150, ADR("My Window"));

    IF (window # NIL) AND InitMenu(window) THEN
        RunWindow(window);
    ELSE
        WriteString("Cannot open window");
        WriteLn;
    END;
END Menus.
