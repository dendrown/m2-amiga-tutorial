MODULE Gadgets;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/gadgets.html
 *)

(* System imports *)
FROM Arts       IMPORT  Assert;
FROM GadToolsL  IMPORT  FreeVisualInfo, GetVisualInfoA;
FROM InOut      IMPORT  WriteLn, WriteString;
FROM IntuitionD IMPORT  ScreenPtr, WindowPtr;
FROM IntuitionL IMPORT  LockPubScreen, UnlockPubScreen;
FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM UtilityD   IMPORT  tagDone;

(* Tutorial imports *)
FROM MyWindow   IMPORT  MakeWindow, RunWindow;

VAR
    pubScreen : ScreenPtr;

    visual  : ADDRESS;
    window  : WindowPtr;
    tags    : ARRAY[1..2] OF LONGINT;


(* ------------------------------------------------------------------------- *)
PROCEDURE ShutDown;
BEGIN
    IF visual # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END;

    IF pubScreen # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END
END ShutDown;


(* ------------------------------------------------------------------------- *)
BEGIN
    TermProcedure(Shutdown);

    pubScreen := LockPubScreen(NIL);
    Assert(pubScreen # NIL, ADR("Cannot lock public screen"));

    visual := GetVisualInfoA(pubScreen, TAG(tags, tagDone));

    window := MakeWindow(200, 150, ADR("Gadget Window"));

    IF (window # NIL) THEN
        RunWindow(window)
    ELSE
        WriteString("Cannot open window");
        WriteLn;
    END;
END Gadgets.
