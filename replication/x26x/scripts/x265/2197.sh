#!/bin/sh

numb='2198'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 25 --keyint 250 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.2,1.0,4.6,0.3,0.8,0.8,0,0,16,25,250,1,26,20,4,0,68,38,1,2000,-1:-1,hex,crop,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"