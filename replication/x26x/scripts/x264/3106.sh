#!/bin/sh

numb='3107'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.1,1.4,1.2,0.4,0.9,0.6,3,2,0,35,230,4,25,30,4,3,67,38,1,1000,1:1,dia,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"