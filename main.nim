import raylib, rayutils

const
    screenWidth = 1280
    screenHeight = 720
    fsize = 30

InitWindow screenWidth, screenHeight, "Typing Test"

let text = "If this capsule history of our progress teaches us anything, it is that man, in his quest for knowledge and progress, is determined and cannot be deterred. The exploration of space will go ahead, whether we join in it or not, and it is one of the great adventures of all time, and no nation which expects to be the leader of other nations can expect to stay behind in the race for space."

while not WindowShouldClose():
    ClearBackground BGREY

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

    let ih = screenHeight div 2 -

    BeginDrawing()
    for i in 0..<tLines.len:
        drawTextCenteredX(tLines[i], screenWidth div 2, (i + 1) * (fsize + 5), fsize, WHITE)
    EndDrawing()


CloseWindow()