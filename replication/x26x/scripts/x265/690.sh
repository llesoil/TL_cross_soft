#!/bin/sh

numb='691'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 15 --keyint 200 --lookahead-threads 2 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.2,1.2,4.0,0.4,0.7,0.5,3,0,4,15,200,2,23,50,3,4,66,38,4,1000,1:1,hex,crop,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"