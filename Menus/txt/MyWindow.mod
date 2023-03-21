IMPLEMENTATION MODULE MyWindow;
(* Amiga Tutorial C -> Modula2
 *
 * The Windows module has been adapted from the stand-alone program
 * we created in the "4. Windows" section of the tutorial.
 *)
FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM ExecL      IMPORT  WaitPort;
FROM GadToolsL  IMPORT  GTGetIMsg, GTReplyIMsg;
FROM InputEvent IMPORT  closewindow;
FROM IntuitionD IMPORT  IDCMPFlags, IDCMPFlagSet, IntuiMessagePtr,
                        NewWindow, ScreenFlags, ScreenFlagSet,
                        WaTags, WindowFlags, WindowFlagSet, WindowPtr;
FROM IntuitionL IMPORT  intuitionVersion,
                        CloseWindow, OpenWindow, OpenWindowTagList;
FROM UtilityD   IMPORT  tagEnd, TagItem;

CONST
    idcmpCloseWin = IDCMPFlagSet{closeWindow};


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

END MyWindow.
