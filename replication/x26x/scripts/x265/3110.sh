#!/bin/sh

numb='3111'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 5.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 50 --keyint 240 --lookahead-threads 0 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.1,1.4,5.0,0.4,0.7,0.1,1,1,12,50,240,0,24,40,3,3,69,28,5,1000,-2:-2,dia,crop,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"