#!/bin/sh

numb='2118'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 15 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.2,1.1,2.0,0.2,0.6,0.1,2,2,6,15,300,1,25,40,3,4,65,48,5,2000,-2:-2,dia,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"