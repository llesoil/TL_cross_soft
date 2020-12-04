#!/bin/sh

numb='2130'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 10 --keyint 230 --lookahead-threads 1 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.2,2.2,0.5,0.6,0.8,2,1,10,10,230,1,25,10,3,2,68,28,5,1000,-1:-1,dia,show,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"