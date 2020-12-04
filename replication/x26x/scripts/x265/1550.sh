#!/bin/sh

numb='1551'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 25 --keyint 210 --lookahead-threads 0 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.6,1.3,3.2,0.5,0.8,0.1,0,1,2,25,210,0,23,0,5,0,66,48,5,2000,-2:-2,umh,show,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"