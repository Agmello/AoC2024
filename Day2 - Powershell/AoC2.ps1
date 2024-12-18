$file = Get-Content .\input.txt
#$file = Get-Content .\TestData.txt
##Write-Host $file;

$Part1 = "Part1";
$Part2 = "Part2";

$Part = $Part1;
Function Value-Compare {
    param (
        [int]$v1,
        [int]$v2
    )
    $diff = [Math]::Abs($v1-$v2);
    $r = if(($diff -gt 0) -and ($diff -lt 4)) {$True} else {$False};
    return $r;
}
function Check-Sequence {
    param (
        [int[]]$seq,
        [bool]$allowSkip
    )
    $last = $null
    $skipped = $allowSkip

    foreach($second in $seq){
        if($null -eq $last){
           $last = $second;
            continue;
        }
        if((Value-Compare -v1 $last -v2 $second) -eq $False){
            if($skipped -eq $false) {return $false;}
            $skipped = $false;
            continue;
        }
        if ($last -lt $second) {
            if($skipped -eq $false) {return $false;}
            $skipped = $false;
            continue;
        }
        $last = $second;
    }
    return $true
}

$correct = 0;
$incorrect = 0;

foreach($line in $file) {
    $seq = $line -split '\s+'
    $numseq = $line.split(' ') | % {iex $_}
    if($Part -eq $Part2){
        if((Check-Sequence -seq $numseq -allowSkip $true) -eq $true){
            #Write-Host "Standard correct";
            $correct = $correct + 1;
            continue;
        }
        $reverse =$numseq.clone()
        [array]::reverse($reverse)
        if((Check-Sequence -seq $reverse -allowSkip $true) -eq $true){
            $correct = $correct + 1;
            continue;
        }
        $skippedSeq = $numseq[1..($numseq.Length - 1)];
        if((Check-Sequence -seq $skippedSeq -allowSkip $false) -eq $true){
            $correct = $correct + 1;
            continue;
        }
        $skippedRev = $reverse[1..($reverse.Length - 1)];
        if((Check-Sequence -seq $skippedRev -allowSkip $false) -eq $true){
            $correct = $correct + 1;
            continue;
        }
    }
    else {
        if((Check-Sequence -seq $numseq -allowSkip $false) -eq $true){
            #Write-Host "Standard correct";
            $correct = $correct + 1;
            continue;
        }
        $reverse =$numseq.clone()
        [array]::reverse($reverse)
        if((Check-Sequence -seq $reverse -allowSkip $false) -eq $true){
            $correct = $correct + 1;
            continue;
        }
    }
    $incorrect = $incorrect + 1;
}

Write-Host "Correct: " $correct;
Write-Host "Incorrect: " $incorrect;
Write-Host "Total" $file.Length;
