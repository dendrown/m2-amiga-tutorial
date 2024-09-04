(* Amiga Tutorial C -> Modula2
 *)
IMPLEMENTATION MODULE GadWindow;

FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM Arts       IMPORT  Assert;
FROM ExecL      IMPORT  WaitPort;
FROM GadToolsL  IMPORT  GTGetIMsg, GTRefreshWindow, GTReplyIMsg;
FROM InOut      IMPORT  WriteInt, WriteLn, WriteString;
FROM InputEvent IMPORT  closewindow;
FROM IntuitionD IMPORT  GadgetPtr, IDCMPFlags, IDCMPFlagSet, IntuiMessagePtr,
                        NewWindow, ScreenFlags, ScreenFlagSet,
                        WaTags, WindowFlags, WindowFlagSet, WindowPtr;
FROM IntuitionL IMPORT  intuitionVersion,
                        CloseWindow, OpenWindow, OpenWindowTagList;
FROM UtilityD   IMPORT  tagEnd, TagItem;

CONST
    idcmpCloseWin = IDCMPFlagSet{closeWindow};
    idcmpGadgetUp = IDCMPFlagSet{gadgetUp};


(* ------------------------------------------------------------------------- *)
PROCEDURE MakeWindow(left,
                     top,
                     width,
                     height : INTEGER;
                     gadgets: GadgetPtr;
                     title  : ADDRESS) : WindowPtr;

CONST
    winFlags = WindowFlagSet{activate,
                             windowRefresh,
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
                                    waIDCMP, IDCMPFlagSet{closeWindow,gadgetUp,refreshWindow},
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
    gadget : GadgetPtr;

BEGIN
    (* Update window *)
    GTRefreshWindow(window, NIL);

    (* Identify our custom gadgets until the user clicks the close gadget *)
    WHILE (NOT byebye) DO
        WaitPort(window^.userPort);
        winmsg := GTGetIMsg(window^.userPort);
        GTReplyIMsg(winmsg);
        IF (winmsg^.class = idcmpCloseWin) THEN
            CloseWindow(window);
            byebye := TRUE
        ELSIF (winmsg^.class = idcmpGadgetUp) THEN
            gadget := winmsg^.iAddress;
            Assert(gadget#NIL, ADR("Invalid gadget in window message"));
            WriteString('Accessed gadget #');
            WriteInt(gadget^.gadgetID,1);
            WriteLn
        END
    END
END RunWindow;

END GadWindow.
