MODULE Screens;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/screens.html
 *)
FROM SYSTEM     IMPORT  ADDRESS, ADR, TAG;
FROM InOut      IMPORT  ReadCard, WriteLn, WriteString;
FROM GraphicsD  IMPORT  ViewModes, ViewModeSet;
FROM IntuitionD IMPORT  customScreen, stdScreenHeight, stdScreenWidth,
                        NewScreen, SaTags, ScreenPtr;
FROM IntuitionL IMPORT  intuitionVersion,
                        CloseScreen, OpenScreen, OpenScreenTagList;
FROM UtilityD   IMPORT  tagEnd, TagItem;


VAR
    fixme  : CARDINAL;
    screen : ScreenPtr;


(* ------------------------------------------------------------------------- *)
PROCEDURE MakeScreen(width,
                     height,
                     depth  : INTEGER;
                     title  : ADDRESS) : ScreenPtr;
VAR
    newscr : NewScreen;
    screen : ScreenPtr;

    tags : ARRAY[0..14] OF LONGINT;

BEGIN
    IF intuitionVersion >= 36 THEN
        screen := OpenScreenTagList(ADR(newscr),
                                    TAG(tags,
                                        saLeft,     0,
                                        saTop,      0,
                                        saTitle,    title,
                                        saWidth,    width,
                                        saHeight,   height,
                                        saDepth,    depth,
                                        saSysFont,  1,
                                        tagEnd));
    ELSE
        WITH newscr DO
            leftEdge := 0;
            topEdge := 0;
            width := width;
            height := height;
            depth := depth;
            detailPen := 0;
            blockPen := 1;
            viewModes := ViewModeSet{hires};
            type := customScreen;
            font := NIL;
            defaultTitle := title;
            gadgets := NIL;
            customBitMap := NIL;
        END;
        screen := OpenScreen(newscr);
    END;

    RETURN screen;
END MakeScreen;


(* ------------------------------------------------------------------------- *)
BEGIN
    screen := MakeScreen(stdScreenWidth, stdScreenHeight, 4, ADR("Saluton"));

    IF (screen # NIL) THEN
        ReadCard(fixme);
    ELSE
        WriteString("Cannot open screen");
        WriteLn;
    END;
    CloseScreen(screen);
END Screens.
