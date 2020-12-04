#!/bin/sh

numb='784'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 25 --keyint 250 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.0,0.8,0.3,0.6,0.4,3,0,16,25,250,3,30,50,4,0,62,38,1,1000,-1:-1,umh,show,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"