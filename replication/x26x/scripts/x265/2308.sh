#!/bin/sh

numb='2309'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 50 --keyint 250 --lookahead-threads 2 --min-keyint 21 --qp 20 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.6,1.1,1.8,0.5,0.9,0.7,2,2,0,50,250,2,21,20,4,3,64,38,1,2000,-1:-1,umh,show,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"