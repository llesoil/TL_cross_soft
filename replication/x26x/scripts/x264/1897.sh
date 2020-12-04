#!/bin/sh

numb='1898'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 10 --keyint 290 --lookahead-threads 2 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.2,1.2,0.5,0.6,0.0,2,0,14,10,290,2,22,0,4,0,62,38,2,2000,-2:-2,dia,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"