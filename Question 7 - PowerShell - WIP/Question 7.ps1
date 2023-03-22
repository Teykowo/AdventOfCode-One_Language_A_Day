# Read the input and put its content in a list, the function used to read a file seemingly puts the whole file in memory anyways so there is no real difference.
$inputText = get-content '.\input.txt'

# Hold the current folder's depth as a variable.
$currentFolderDepth = 0
# Hold the current folder's total as another variable.
$currentFolderTotal = 0
# Hold the answer which is the sum of folder sizes that are greater than 100000.
$answer = 0

# Iterate over the lines.
foreach ($line in $inputText){
    # remove the "$" symbol from lines as be it a cmd or a print, we need to process it.
    $line = $inputText[-$lineCount] -replace '[$]', ''
    # Remove the space after the "$" we just removed. We also split the array to get each arg.
    $line = $line.Trim().Split(' ')

    switch -regex ($line[0]){
        # Since we just need the folder weights, we can stay agnostic about the folder names, thus we'll just use the cd commande to increase or decrease a depth variable.
        'cd' {
            # If the cd command has a directory's name as arg:
            if ($line[1] -ne '..'){
                # Then it means we're going deeper inside the tree so increase depth by 1.
                $currentFolderDepth += 1
            # Else then we're going backwards so decrease the depth by 1.
            } else {
                $currentFolderDepth -= 1
            }
        }
        # If the first part of the line is a list of number, then it's the size of a file inside a folder, we add its total to the currentFolderTotal.
        '[\d+]'{

        }
    }
}

















# Instead of reading the file from top to bottom, going deeper inside the folder tree, its easier to go from the deepest point back to the top, as we need to keep less data in 
# memory since we don't need to take the ''cd ..'' command into account. thus we use a for loop and use the counter to reach the index from the end.
for ($lineCount = 0; $lineCount -lt $inputText.Length; $lineCount++) {
    
    switch -regex ($line[0]){
        # this line does nothing:
        'ls' {}
        # If the first part of the line is a list of number, then it's the size of a file inside a folder, we add its total to the currentFolderTotal.
        '[\d+]' {
            $currentFolderTotal += [int]$line[0]
        }
        # If the command is "cd", it means the previously tallied file size are from the folder that's shown as argument.
        'cd' {
            # We shan't process cd's to "..".
            if ($line[1] -ne '..'){
                
                # Hence we add the folder to the dict with the tally as value. 
                # # we also add the line of the cmd in the key so as to take into account multiple fodlers with the same name.
                # $unrevesedIndex = ($inputText.Length - $lineCount)
                # $keyName = $line[1] + $unrevesedIndex.ToString()
                $folderSizes += @{$line[1] = $currentFolderTotal}
                
                # If the size is greater than 100000 then add the count to the answer.
                if ($currentFolderTotal -ge 100000){
                    $answer += $currentFolderTotal
                }
                
                # And set the tally back to 0.
                $currentFolderTotal = 0
            }
        }
        # If the keyword is "dir", then the folder names as arg is a subfolder, meaning its total has to be added to the currentFolderTotal.
        'dir' {
            $currentFolderTotal += $($folderSizes[($line[1])])
            $folderSizes.Remove($line[1]) 

        }
        default {}
    }
}
$folderSizes
$answer