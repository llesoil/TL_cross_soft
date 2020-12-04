#!/bin/sh

numb='2342'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 10 --keyint 230 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.4,4.6,0.5,0.6,0.0,0,2,6,10,230,2,24,20,4,0,69,38,2,2000,-2:-2,hex,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"