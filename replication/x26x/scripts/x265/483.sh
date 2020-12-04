#!/bin/sh

numb='484'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 5.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.5,1.3,5.0,0.5,0.7,0.5,3,1,8,35,230,3,29,0,4,4,64,18,5,2000,-1:-1,hex,crop,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"