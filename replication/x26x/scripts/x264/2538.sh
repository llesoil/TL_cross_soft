#!/bin/sh

numb='2539'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 0 --keyint 280 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.4,1.2,4.4,0.3,0.9,0.2,1,1,16,0,280,0,30,10,3,1,69,28,4,1000,-1:-1,dia,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"