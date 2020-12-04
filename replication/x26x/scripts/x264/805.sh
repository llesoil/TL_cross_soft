#!/bin/sh

numb='806'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.3,2.6,0.6,0.9,0.6,2,1,8,20,290,2,25,30,3,4,68,48,5,1000,-1:-1,dia,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"