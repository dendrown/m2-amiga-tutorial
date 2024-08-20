MODULE Gadgets;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/gadgets.html
 *)

(* System imports *)
FROM Arts       IMPORT  Exit;
FROM GadToolsL  IMPORT  FreeVisualInfo, GetVisualInfoA;
FROM InOut      IMPORT  WriteLn, WriteString;
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
PROCEDURE ShutDown(rc : LONGINT);
BEGIN
    IF visual # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END;

    IF pubScreen # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END;
    
    Exit(rc)
END ShutDown;


(* ------------------------------------------------------------------------- *)
PROCEDURE AssertForRun(check : BOOLEAN;
                       msg   : ARRAY OF CHAR);
BEGIN
    IF NOT check THEN
        WriteString(msg);
        WriteLn;
        ShutDown(RC.rcActionErr)
    END
END AssertForRun;


(* ------------------------------------------------------------------------- *)
BEGIN
    (* NOTE: M2Amiga originally had TermProcedure(), which allowed us to hook
       a termination procedure that would be called to clean up resources
       before the program exists. This worked nicely with Assert() to alert
       the user of an unexpected condition before shutting things down.

       This version uses a local replacement: AssertForRun(). However, the
       official M2Amiga answer is a CLOSE section in the main code.
    *)
    pubScreen := LockPubScreen(NIL);
    AssertForRun(pubScreen#NIL, 'Cannot lock public screen');

    visual := GetVisualInfoA(pubScreen, TAG(tags, tagDone));
    AssertForRun(visual#NIL, 'Failed to get visual info');

    window := MakeWindow(200, 150, ADR("Gadget Window"));
    AssertForRun(window#NIL, 'Cannot create window');

    RunWindow(window);
    ShutDown(RC.rcOk)
END Gadgets.
