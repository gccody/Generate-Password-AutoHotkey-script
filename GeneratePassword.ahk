^!p:: {
  ; === CONFIG ===
  wordFile := "WordsList.txt"
  minLength := 12
  replacementChance := 0.4
  upperChance := 0.1
  trailingSymbols := ["!", "@", "#", "$", "%", "&", "?"]

  letterMap := Map(
    "a", ["@", "4"],
    "e", ["3"],
    "i", ["!", "1"],
    "o", ["0"],
    "s", ["$", "5"],
    "l", ["1"]
  )

  ; === LOAD WORD LIST ===
  if !FileExist(wordFile) {
    MsgBox "Word list file not found: " wordFile
    return
  }

  fileContents := FileRead(wordFile)
  words := StrSplit(fileContents, ["`n", "`r"], "`n")

  ; Manual filter to remove empty or whitespace-only lines
  cleanWords := []
  for w in words {
    w := Trim(w)
    if w != ""
      cleanWords.Push(w)
  }
  words := cleanWords

  ; === GENERATE BASE PASSWORD ===
  password := ""
  while StrLen(password) < minLength {
    word := Trim(words[Random(1, words.Length)])
    password .= word
  }

  ; === RANDOM CHARACTER REPLACEMENTS ===
  newPassword := ""
  Loop Parse, password {
    char := A_LoopField
    lowerChar := StrLower(char)

    if letterMap.Has(lowerChar) && Random() < replacementChance {
      replacements := letterMap[lowerChar]
      replacement := replacements[Random(1, replacements.Length)]
      newPassword .= replacement
    } else {
      newPassword .= char
    }
  }

  password := newPassword

  ; === RANDOMIZE CAPITALIZATION ===
  finalPassword := ""
  Loop Parse, password {
    char := A_LoopField
    if char ~= "[a-zA-Z]" {
      finalPassword .= Random() < upperChance ? StrUpper(char) : char
    } else {
      finalPassword .= char
    }
  }

  ; === ADD TRAILING SYMBOL ===
  trailing := trailingSymbols[Random(1, trailingSymbols.Length)]
  finalPassword .= trailing

  ; === OUTPUT THE PASSWORD ===
  A_Clipboard := finalPassword
  ClipWait
  Send "^v"
}