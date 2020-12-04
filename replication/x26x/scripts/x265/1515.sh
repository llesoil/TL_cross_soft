#!/bin/sh

numb='1516'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.6,1.2,2.6,0.6,0.7,0.9,2,0,0,45,240,1,28,10,3,2,67,38,5,1000,-2:-2,hex,crop,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"