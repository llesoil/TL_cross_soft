#!/bin/sh

numb='3049'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 5.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.0,1.2,5.0,0.2,0.6,0.5,2,1,14,45,210,1,30,10,3,0,62,28,3,2000,-1:-1,dia,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"