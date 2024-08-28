(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/gadgets.html
 *)
MODULE Gadgets;

(* System imports *)
FROM Arts       IMPORT  Assert;
FROM GadToolsD  IMPORT  GtTags, NewGadget, NewGadgetFlags, NewGadgetFlagSet,
                        stringKind;
FROM GadToolsL  IMPORT  CreateContext, CreateGadgetA,  FreeGadgets, FreeVisualInfo,
                        GetVisualInfoA;
FROM GraphicsD  IMPORT  FontStyleSet, FontFlags, FontFlagSet, TextAttr;
FROM IntuitionD IMPORT  GadgetPtr, ScreenPtr, WindowPtr;
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
    gad1    : GadgetPtr;
    gadList : GadgetPtr;
    gadData : NewGadget;
    topaz8  : TextAttr;
    tags    : ARRAY[1..3] OF LONGINT;


(* ------------------------------------------------------------------------- *)

(* ------------------------------------------------------------------------- *)
BEGIN
    pubScreen := LockPubScreen(NIL);
    Assert(pubScreen#NIL, ADR("Cannot lock public screen"));

    visual := GetVisualInfoA(pubScreen, TAG(tags, tagDone));
    Assert(visual#NIL, ADR("Failed to get visual info"));

    (* Move to GadInit procedure *)
    WITH topaz8 DO
        name := ADR("topaz.font");
        ySize := 8;
        style := FontStyleSet{};
        flags := FontFlagSet{romFont}
    END;
    WITH gadData DO
        leftEdge := 63; topEdge := 26;
        width := 172;   height := 13;
        gadgetText := ADR("Name");
        textAttr := ADR(topaz8);
        gadgetID := 1;
        flags := NewGadgetFlagSet{placetextLeft};
        visualInfo := ADR(visual);                  (* Watch out! *)
        userData := NIL
    END;

    gadList := NIL;
    gad1 := CreateContext(gadList);
    Assert(gad1#NIL, ADR("Failed to create GadTools context"));

    gad1 := CreateGadgetA(stringKind, gad1^, gadData, TAG(tags, gtstMaxChars, 256, tagDone));

    window := MakeWindow(10, 15, 280, 180, gadList, ADR("Gadget Window"));
    Assert(window#NIL, ADR("Cannot create window"));

    RunWindow(window);

CLOSE
    IF gadList # NIL THEN
        FreeGadgets(gadList)
    END;

    IF visual # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END;
    visual := NIL;

    IF pubScreen # NIL THEN
        UnlockPubScreen(NIL, pubScreen)
    END;
    pubScreen := NIL
END Gadgets.
