#!/bin/sh

numb='644'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 50 --keyint 280 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.3,3.0,0.3,0.7,0.0,1,0,12,50,280,2,20,40,3,0,65,28,4,2000,-1:-1,dia,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"