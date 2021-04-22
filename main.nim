import raylib, rayutils, lenientops, sequtils

const
    screenWidth = 1280
    screenHeight = 720
    fsize = 30

InitWindow screenWidth, screenHeight, "Typing Test"
SetTargetFPS 60

type
    checkedText = enum
        COR, WRO, NONE

# let text = "If this capsule history of our progress teaches us anything, it is that man, in his quest for knowledge and progress, is determined and cannot be deterred. The exploration of space will go ahead, whether we join in it or not, and it is one of the great adventures of all time, and no nation which expects to be the leader of other nations can expect to stay behind in the race for space."

let text = "Then the Campeador departed unto his lodging straight. But when he was come thither, they had locked and barred the gate. In their fear of King Alfonso had they done even so. An the Cid forced not his entrance, neither for weal nor woe Durst they open it unto him. Loudly his men did call. Nothing thereto in answer said the folk within the hall. My lord the Cid spurred onward, to the doorway did he go. He drew his foot from the stirrup, he smote the door one blow. Yet the door would not open, for they lied barred it fast."

var tLines : seq[string]
var prevIterInx = 0
for i in 20..<text.len:
    if i == text.len - 1:
        tLines.add text[prevIterInx..i]
    elif i mod 50 == 0:
        var cutInx = i
        while text[cutInx] != ' ':
            cutInx += 1
        
        tLines.add text[prevIterInx..cutInx]
        prevIterInx = cutInx + 1

var typedSeq : seq[char]
var charPos : int

var corInp = newSeqWith(text.len, WHITE)

template tlineToCor(s : untyped, i, j : int, tline : seq[string]) : untyped =
    var sum : int
    for z in 0..<i:
        sum += tline[z].len
    return s[sum + j]

func corToTline(s : seq[string], i : int) : (int, int) =
    var line = 0
    var z = i
    while true:
        if z - s[line].len >= 0:
            z += -s[line].len
            line += 1
        else: return (line, z)

while not WindowShouldClose():
    ClearBackground BGREY

    var curpos : Vector2

    var updated = false
    let cPressed = GetCharPressed()
    let bksp = IsKeyPressed(KEY_BACKSPACE)
    if cPressed != 0:
        charPos += 1
        updated = true 
        typedSeq.add char cPressed
    if bksp:
        updated = true
        charPos += -1
        typedSeq = typedSeq[0..^2]
        for i in 1..corInp.len:
            if corInp[^i] != WHITE:
                corInp[^i] = WHITE
                break

    if updated:
        echo typedSeq.mapIt($it).foldl($a & $b)
        for inx, c in typedSeq.pairs:
            if c == text[inx]:
                corInp[inx] = GREEN
            else:
                corInp[inx] = RED

    let ih = screenHeight / 2 - tLines.len / 2 * (fsize + 5)

    # Calculating Cursor Position

    let tLineCharPos = corToTline(tLines, charPos)
    debugEcho tLineCharPos

    let tSize = MeasureTextEx(GetFontDefault(), tLines[tLineCharPos[0]], float fsize, max(20 , fsize) / 10) div 2
    let tOrigin = screenWidth div 2 - tSize.x
    curpos.x = tOrigin + MeasureTextEx(GetFontDefault(), tLines[tLineCharPos[0]][0..tLineCharPos[1] - 1], float fsize, max(20, fsize) / 10).x + 1


    BeginDrawing()
    DrawLineV makevec2(curpos.x, 0), makevec2(curpos.x, screenHeight), YELLOW
    DrawLineV(makevec2(0, screenHeight div 2), makevec2(screenWidth, screenHeight div 2), RED)
    for i in 0..<tLines.len:
        drawTextCenteredX($tLines[i], screenWidth div 2, int(ih + i * (fsize + 5)), fsize, WHITE)
    EndDrawing()


CloseWindow()