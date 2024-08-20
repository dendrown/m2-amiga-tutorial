MODULE Gadgets;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/gadgets.html
 *)

(* System imports *)
FROM Arts       IMPORT  Assert;
FROM GadToolsL  IMPORT  FreeVisualInfo, GetVisualInfoA;
FROM IntuitionD IMPORT  ScreenPtr, WindowPtr;
FROM IntuitionL IMPORT  LockPubScreen, UnlockPubScreen;
FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM UtilityD   IMPORT  tagDone;

IMPORT
    RC : ReplyVals;

(* Tutorial imports *)
FROM MyWindow   IMPORT  MakeWindow, RunWindow;

VAR
    pubScreen : ScreenPtr;

    visual  : ADDRESS;
    window  : WindowPtr;
    tags    : ARRAY[1..2] OF LONGINT;


(* ------------------------------------------------------------------------- *)
BEGIN
    pubScreen := LockPubScreen(NIL);
    Assert(pubScreen#NIL, ADR("Cannot lock public screen"));

    visual := GetVisualInfoA(pubScreen, TAG(tags, tagDone));
    Assert(visual#NIL, ADR("Failed to get visual info"));

    window := MakeWindow(200, 150, ADR("Gadget Window"));
    Assert(window#NIL, ADR("Cannot create window"));

    RunWindow(window);

CLOSE
    IF visual # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END;
    visual := NIL;

    IF pubScreen # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END;
    pubScreen := NIL
END Gadgets.
