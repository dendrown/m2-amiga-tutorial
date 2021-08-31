MODULE Screens;
(* Amiga Tutorial C -> Modula2
 * @ref http://www.pjhutchison.org/tutorial/screens.html
 *)
FROM SYSTEM IMPORT
    ADDRESS, ADR;

FROM InOut IMPORT
    ReadCard;

FROM GraphicsD IMPORT
    ViewModes, ViewModeSet;

FROM IntuitionD IMPORT
    customScreen, stdScreenHeight,
    NewScreen, ScreenPtr;

FROM IntuitionL IMPORT
    CloseScreen, OpenScreen;


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

BEGIN
    WITH newscr DO
        leftEdge := 0;
        topEdge := 0;
        width := width;
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
    RETURN OpenScreen(newscr);
END MakeScreen;


(* ------------------------------------------------------------------------- *)
BEGIN
    screen := MakeScreen(640, stdScreenHeight, 4, ADR("Saluton"));

    IF (screen # NIL) THEN
        ReadCard(fixme);
    END;
    CloseScreen(screen);
END Screens.
