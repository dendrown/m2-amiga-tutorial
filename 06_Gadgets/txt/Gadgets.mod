(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/gadgets.html
 *)
MODULE Gadgets;

(* System imports *)
FROM Arts       IMPORT  Assert;
FROM GadToolsD  IMPORT  GtTags, NewGadget, NewGadgetFlags, NewGadgetFlagSet;
FROM GadToolsL  IMPORT  CreateContext, CreateGadgetA,  FreeGadgets, FreeVisualInfo,
                        GetVisualInfoA;
FROM GraphicsD  IMPORT  FontStyleSet, FontFlags, FontFlagSet, TextAttr;
FROM InOut      IMPORT  WriteInt, WriteLn, WriteString;
FROM IntuitionD IMPORT  GadgetPtr, ScreenPtr, WindowPtr;
FROM IntuitionL IMPORT  LockPubScreen, RefreshGList, UnlockPubScreen;
FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM UtilityD   IMPORT  Tag, tagDone;

IMPORT
    GAD: GadToolsD,
    RC : ReplyVals;

(* Tutorial imports *)
FROM GadWindow  IMPORT  MakeWindow, RunWindow;

CONST
    gadgetCount = 3;

TYPE
    Tags    = ARRAY[1..3] OF LONGCARD;
    GadTags = ARRAY[1..gadgetCount] OF Tags;

    GadKinds = ARRAY[1..gadgetCount] OF LONGCARD;
    GadSpecs = ARRAY[1..gadgetCount] OF NewGadget;

VAR
    screen  : ScreenPtr;
    window  : WindowPtr;
    visual  : ADDRESS;
    topaz8  : TextAttr;

    context : GadgetPtr;    (* FIXME: just use `gadget` in InitGadList *)
    gadList : GadgetPtr;
    tags    : Tags;


(* ------------------------------------------------------------------------- *)
PROCEDURE InitGadList;
CONST
    textLeft = NewGadgetFlagSet{placetextLeft};
    textIn   = NewGadgetFlagSet{placetextIn};

VAR
    i : INTEGER;
    gadKinds: GadKinds;
    gadSpecs: GadSpecs;
    gadTags : GadTags;
    gadget  : GadgetPtr;

    (* --------------------------------------------------------------------- *)
    PROCEDURE SpecGadget(id : CARDINAL;
                         left, top, w, h : INTEGER;
                         flags : NewGadgetFlagSet;
                         name  : ADDRESS);

    BEGIN
        WITH gadSpecs[id] DO
            gadgetID := id;     gadgetText := name;
            leftEdge := left;   topEdge := top;
            width := w;         height := h;
            flags := flags;     textAttr := ADR(topaz8);
            userData := NIL;    visualInfo := ADR(visual)
        END
    END SpecGadget;


BEGIN
    topaz8 := TextAttr{name:ADR("topaz.font"), ySize:8,
                       style:FontStyleSet{}, flags:FontFlagSet{romFont}};

    gadKinds := GadKinds{GAD.stringKind, GAD.integerKind, GAD.buttonKind};
    gadTags  := GadTags{Tags{Tag(gtstMaxChars), 256, tagDone},
                        Tags{Tag(gtnmBorder), Tag(TRUE), tagDone},
                        Tags{tagDone, 0, 0}};

    (* gadSpecs:  LFT  TOP   W   H             FIXNE: Name/Age labels are not displayed *)
    SpecGadget(1,  63,  26, 172, 13, textLeft, ADR("Name"));
    SpecGadget(2,  62,  50, 175, 15, textLeft, ADR("Age"));
    SpecGadget(3, 111, 105,  54, 31, textIn,   ADR("Calc!"));

    (* Initialize the gadget list *)
    gadList := NIL;
    context := CreateContext(gadList);
    gadget  := context;
    Assert(gadget#NIL, ADR("Failed to create GadTools context"));

    (* Create gadgets: specify kind, previous gadget, NewGadget spec, and extra tag info *)
    FOR i := 1 TO gadgetCount DO
        gadget := CreateGadgetA(gadKinds[i], gadget^, gadSpecs[i], ADR(gadTags[i]));
        Assert(gadget#NIL, ADR("Failed to create gadget"));
        WriteString('Created gadget #');
        WriteInt(i,1);
        WriteLn
    END
END InitGadList;


(* ------------------------------------------------------------------------- *)
BEGIN
    screen := LockPubScreen(NIL);
    Assert(screen#NIL, ADR("Cannot lock public screen"));

    visual := GetVisualInfoA(screen, TAG(tags, tagDone));
    Assert(visual#NIL, ADR("Failed to get visual info"));

    InitGadList;
    window := MakeWindow(10, 15, 280, 180, gadList, ADR("Gadget Window"));
    Assert(window#NIL, ADR("Cannot create window"));

    RefreshGList(context, window, NIL, -1); (* FIXME: Unnecessary? remove import *)
    RunWindow(window);

CLOSE
    (* The CLOSE section MUST be reentrant *)
    IF gadList # NIL THEN
        FreeGadgets(gadList);
        gadList := NIL
    END;

    IF visual # NIL THEN
        FreeVisualInfo(visual);
        visual := NIL
    END;

    IF screen # NIL THEN
        UnlockPubScreen(NIL, screen);
        screen := NIL
    END
END Gadgets.
