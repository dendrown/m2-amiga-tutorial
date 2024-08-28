(* Amiga Tutorial C -> Modula2
 *
 * The MyWindow module has been adapted from the stand-alone program
 * we created in the "4. Windows" section of the tutorial.
 *)
IMPLEMENTATION MODULE MyWindow;

FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM Arts       IMPORT  Assert;
FROM ExecL      IMPORT  WaitPort;
FROM GadToolsL  IMPORT  GTGetIMsg, GTRefreshWindow, GTReplyIMsg;
FROM InputEvent IMPORT  closewindow;
FROM IntuitionD IMPORT  GadgetPtr, IDCMPFlags, IDCMPFlagSet, IntuiMessagePtr,
                        NewWindow, ScreenFlags, ScreenFlagSet,
                        WaTags, WindowFlags, WindowFlagSet, WindowPtr;
FROM IntuitionL IMPORT  intuitionVersion,
                        CloseWindow, OpenWindow, OpenWindowTagList;
FROM UtilityD   IMPORT  tagEnd, TagItem;

CONST
    idcmpCloseWin = IDCMPFlagSet{closeWindow};


(* ------------------------------------------------------------------------- *)
PROCEDURE MakeWindow(left,
                     top,
                     width,
                     height : INTEGER;
                     gadgets: GadgetPtr;
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

    tags : ARRAY[0..22] OF LONGINT;

BEGIN
    Assert(intuitionVersion>=36, ADR("Gadget Window requires Kickstart 2.0 [36]+"));
    window := OpenWindowTagList(ADR(newwin),
                                TAG(tags,
                                    waLeft, left,   waTop, top,
                                    waWidth, width, waHeight, height,
                                    waIDCMP, IDCMPFlagSet{closeWindow,gadgetUp},
                                    waFlags, winFlags,
                                    waGadgets, gadgets,
                                    waTitle, title,
                                    waPubScreenName, ADR("Workbench"),
                                    tagEnd));
    RETURN window;
END MakeWindow;


(* ------------------------------------------------------------------------- *)
PROCEDURE RunWindow(window : WindowPtr);

VAR
    byebye : BOOLEAN;
    winmsg : IntuiMessagePtr;

BEGIN
    (* Update window *)
    GTRefreshWindow(window, NIL);

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
