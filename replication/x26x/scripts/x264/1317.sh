#!/bin/sh

numb='1318'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 45 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.5,1.3,3.2,0.4,0.8,0.7,1,0,8,45,240,4,30,50,5,0,66,28,6,2000,-1:-1,umh,show,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"