#!/bin/sh

numb='477'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 0 --keyint 290 --lookahead-threads 1 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.4,1.3,0.4,0.3,0.9,0.9,3,2,10,0,290,1,26,50,3,2,65,38,4,2000,-2:-2,hex,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"