MODULE Menus;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/menus.html
 *)
FROM ExecL      IMPORT  WaitPort;
FROM GadToolsL  IMPORT  GTGetIMsg, GTReplyIMsg;
FROM GraphicsD  IMPORT  jam2;
FROM InOut      IMPORT  WriteLn, WriteString;
FROM InputEvent IMPORT  closewindow;
FROM IntuitionD IMPORT  menuEnabled,
                        IDCMPFlags, IDCMPFlagSet, Image, IntuiMessagePtr, IntuiText, IntuiTextPtr,
                        Menu, MenuItem, MenuItemPtr, MenuItemFlags, MenuItemFlagSet,
                        NewWindow, ScreenFlags, ScreenFlagSet, WaTags,
                        WindowFlags, WindowFlagSet, WindowPtr;
FROM IntuitionL IMPORT  intuitionVersion,
                        ClearMenuStrip, CloseWindow, OffMenu, OnMenu, OpenWindow,
                        OpenWindowTagList, SetMenuStrip;
FROM SYSTEM     IMPORT  ADDRESS, ADR, BITSET, LONGSET, TAG;
FROM UtilityD   IMPORT  tagEnd;

CONST
    idcmpCloseWin = IDCMPFlagSet{closeWindow};

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
PROCEDURE MakeWindow(width,
                     height : INTEGER;
                     title  : ADDRESS) : WindowPtr;

CONST
    winFlags = WindowFlagSet{activate,
                             windowClose,
                             windowDepth,
                             windowDrag,
                             windowSizing};
VAR
    newwin : NewWindow;
    window : WindowPtr;

    tags : ARRAY[0..20] OF LONGINT;

BEGIN
    IF intuitionVersion >= 36 THEN
        window := OpenWindowTagList(ADR(newwin),
                                    TAG(tags,
                                        waLeft, 20,
                                        waTop, 20,
                                        waTitle, title,
                                        waWidth, width,
                                        waHeight, height,
                                        waIDCMP, idcmpCloseWin,
                                        waFlags, winFlags,
                                        waTitle, title,
                                        waPubScreenName, ADR("Workbench"),
                                        tagEnd));
    ELSE
        WITH newwin DO
            leftEdge := 20;
            topEdge := 20;
            width := width;
            height := height;
            detailPen := 0;
            blockPen := 1;
            idcmpFlags := idcmpCloseWin;
            flags := winFlags;
            firstGadget := NIL;
            checkMark := NIL;
            title := title;
            screen := NIL;
            bitMap := NIL;
            minWidth := 0;
            minHeight := 0;
            maxWidth := 600;
            maxHeight := 400;
            type := ScreenFlagSet{wbenchScreen};
        END;
        window := OpenWindow(newwin);
    END;

    RETURN window;
END MakeWindow;


(* ------------------------------------------------------------------------- *)
PROCEDURE RunWindow(window : WindowPtr);

VAR
    byebye : BOOLEAN;
    winmsg : IntuiMessagePtr;

BEGIN
    (* All we do is wait for the user click the close gadget *)
    WHILE (NOT byebye) DO
        WaitPort(window^.userPort);
        winmsg := GTGetIMsg(window^.userPort);
        GTReplyIMsg(winmsg);
        IF (winmsg^.class = idcmpCloseWin) THEN
            CloseWindow(window);
            byebye := TRUE;
        END;
    END;
END RunWindow;

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
