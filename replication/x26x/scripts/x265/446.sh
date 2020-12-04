#!/bin/sh

numb='447'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 50 --keyint 210 --lookahead-threads 4 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.2,1.3,4.6,0.3,0.9,0.7,1,0,2,50,210,4,29,20,5,2,68,18,3,1000,-2:-2,hex,show,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"