#!/bin/sh

numb='1740'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 5 --keyint 250 --lookahead-threads 0 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.2,1.4,0.6,0.2,0.7,0.5,2,2,2,5,250,0,30,20,4,3,63,18,2,2000,-2:-2,dia,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"