MODULE Windows;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/windows.html
 *)
FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM InOut      IMPORT  ReadCard, WriteLn, WriteString;
FROM IntuitionD IMPORT  IDCMPFlags, IDCMPFlagSet, NewWindow,
                        ScreenFlags, ScreenFlagSet, WaTags,
                        WindowFlags, WindowFlagSet, WindowPtr;
FROM IntuitionL IMPORT  intuitionVersion,
                        CloseWindow, OpenWindow, OpenWindowTagList;
FROM UtilityD   IMPORT  tagEnd, TagItem;
(*
FROM GraphicsD  IMPORT  ViewModes, ViewModeSet;
*)

VAR
    fixme  : CARDINAL;
    window : WindowPtr;


(* ------------------------------------------------------------------------- *)
PROCEDURE MakeWindow(width,
                     height : INTEGER;
                     title  : ADDRESS) : WindowPtr;

CONST
    idcmpCloseWin = IDCMPFlagSet{closeWindow};
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
BEGIN
    window := MakeWindow(200, 150, ADR("Jen Fenestro"));

    IF (window # NIL) THEN
        ReadCard(fixme);
        CloseWindow(window);
    ELSE
        WriteString("Cannot open window");
        WriteLn;
    END;
END Windows.
